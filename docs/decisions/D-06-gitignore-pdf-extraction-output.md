# D-06: Gitignore `assets/gnc355_pdf_extracted/`

**Created:** 2026-04-20T09:10:00-04:00
**Source:** Purple Turn 37 — deferred from GNC355-EXTRACT-01 completion report
**Decision type:** data management / repo hygiene

## Decision

Add `assets/gnc355_pdf_extracted/` to `.gitignore`. The PDF extraction output (151.2 MB: 310 per-page JSON records, 521 extracted images, 170 detected tables) is regenerable from the source PDF and extraction script in ~16 seconds. Does not belong in git history.

## Rationale

- **Size:** 151.2 MB. Exceeds Git's practical comfort zone for binary-heavy directories; would bloat repo clone + fetch times permanently.
- **Regenerability:** The source PDF (`assets/Garmin GNC 375 - ... 190-02488-01_c.pdf`) IS tracked. Combined with `scripts/gnc355_pdf_extract.py` (also tracked), a fresh checkout can reconstruct the extraction in ~16 seconds.
- **Curation state:** The extracted content is raw machine output. Zero manual curation has been applied. Any meaningful product derived from it will live in `docs/specs/GNC355_Functional_Spec_V1.md` (Stream C2) — that file WILL be tracked.
- **Precedent:** Same rationale as D-03's gitignoring of `assets/air_manager_api/crawl.sqlite3`.

## Implementation

Add to `.gitignore`:

```
# GNC 355 PDF extraction output — regenerable from source PDF + scripts/gnc355_pdf_extract.py (D-06)
assets/gnc355_pdf_extracted/
```

Location: same group as the AMAPI crawler DB entries, grouped with other "regenerable artifacts."

## Consequences

- The extraction output never enters git history.
- A fresh checkout requires running `python scripts/gnc355_pdf_extract.py` before C2 can proceed. Since C2 is a CC task, its pre-flight should verify the output exists and regenerate if not — worth capturing in the C2 prompt when we author it.
- The existing GNC355-EXTRACT-01 commit (5f88e9c) correctly excluded the output per its Phase H guidance; no git history rewrite needed.
- `docs/tasks/gnc355_pdf_extract_completion.md` already recommends gitignore; this decision ratifies it.

## Related

- D-03 (AMAPI crawler DB schema — precedent for gitignoring regenerable artifacts)
- GNC355-EXTRACT-01 completion report (Phase H gitignore recommendation)
- `scripts/gnc355_pdf_extract.py` (regeneration script)
- `docs/specs/GNC355_Prep_Implementation_Plan_V1.md` §6 Stream C
