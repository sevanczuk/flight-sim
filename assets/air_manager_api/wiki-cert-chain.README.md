# wiki.siminnovations.com TLS certificate chain

**Created:** 2026-04-20T00:00:00Z
**Source:** docs/tasks/amapi_crawler_bugfix_02_prompt.md

This PEM file contains the three-cert chain for `wiki.siminnovations.com`
as observed on 2026-04-20: leaf (`*.siminnovations.com`, valid through
2026-05-26), Sectigo RSA Domain Validation intermediate, USERTrust RSA
Certification Authority root.

Used by `scripts/amapi_crawler.py` as the CA bundle for TLS verification
when Python's bundled `certifi` trust store does not include USERTrust
(common on Windows). See `docs/tasks/amapi_crawler_bugfix_02_*.md` for
the investigation that led to this file's creation.

**Regeneration:** if the wiki's cert is renewed, extract a fresh chain
with the PowerShell script in
`docs/tasks/amapi_crawler_bugfix_02_prompt.md` (Turn 32 diagnostic).
Alternatively, if Python's certifi bundle is updated to include
USERTrust or the host's cert chain changes to an already-trusted root,
this file can be deleted.
