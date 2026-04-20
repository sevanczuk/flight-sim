"""Tests for gnc355_pdf_extract.py — pure-function components only. No real PDF."""

from unittest.mock import patch

import pytest

from scripts.gnc355_pdf_extract import (
    format_image_filename,
    get_image_format,
    get_text_confidence,
    parse_page_range,
    should_truncate_table,
    tesseract_available,
)


# ---------------------------------------------------------------------------
# 1. Confidence heuristic
# ---------------------------------------------------------------------------


def test_confidence_empty():
    assert get_text_confidence(0) == "empty"


def test_confidence_sparse_low():
    assert get_text_confidence(1) == "sparse"


def test_confidence_sparse_high():
    assert get_text_confidence(199) == "sparse"


def test_confidence_clean_boundary():
    assert get_text_confidence(200) == "clean"


def test_confidence_clean_large():
    assert get_text_confidence(1000) == "clean"


# ---------------------------------------------------------------------------
# 2. Image filename formatting
# ---------------------------------------------------------------------------


def test_image_filename_page1_idx0_jpg():
    assert format_image_filename(1, 0, "jpg") == "page_0001_img_00.jpg"


def test_image_filename_page240_idx15_png():
    assert format_image_filename(240, 15, "png") == "page_0240_img_15.png"


# ---------------------------------------------------------------------------
# 3. Image format mapping
# ---------------------------------------------------------------------------


def test_image_format_dct():
    assert get_image_format("/DCTDecode") == "jpg"


def test_image_format_flat():
    assert get_image_format("/FlateDecode") == "png"


def test_image_format_unknown():
    assert get_image_format("/LZWDecode") == "bin"


def test_image_format_none():
    assert get_image_format(None) == "bin"


# ---------------------------------------------------------------------------
# 4. Page range parsing
# ---------------------------------------------------------------------------


def test_page_range_all():
    result = parse_page_range("all", 5)
    assert result == [1, 2, 3, 4, 5]


def test_page_range_single_range():
    result = parse_page_range("1-10", 20)
    assert result == list(range(1, 11))


def test_page_range_single_page():
    result = parse_page_range("5", 10)
    assert result == [5]


def test_page_range_comma_combined():
    result = parse_page_range("1-5,10,20-25", 30)
    assert result == [1, 2, 3, 4, 5, 10, 20, 21, 22, 23, 24, 25]


def test_page_range_clamps_to_total():
    result = parse_page_range("1-5", 3)
    assert result == [1, 2, 3]


# ---------------------------------------------------------------------------
# 5. Tesseract detection graceful failure
# ---------------------------------------------------------------------------


def test_tesseract_unavailable_when_raises():
    with patch("scripts.gnc355_pdf_extract._PYTESSERACT_IMPORTED", True):
        with patch("scripts.gnc355_pdf_extract.pytesseract") as mock_tess:
            mock_tess.get_tesseract_version.side_effect = Exception("not found")
            result = tesseract_available()
    assert result is False


# ---------------------------------------------------------------------------
# 6. Table truncation decision
# ---------------------------------------------------------------------------


def test_table_not_truncated_at_boundary():
    assert should_truncate_table(20, 10) is False


def test_table_truncated_rows_over():
    assert should_truncate_table(21, 10) is True


def test_table_truncated_cols_over():
    assert should_truncate_table(20, 11) is True


def test_table_truncated_both_over():
    assert should_truncate_table(25, 15) is True
