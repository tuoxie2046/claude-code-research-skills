# v3.2.15b Release Validation — Response Zip Gate And Prompt Fidelity Clean Release

Status: **PASS**

## Policy validated

- Design-origin and fixed reply rules are present near the top of `SKILL.md`.
- Every workflow text reply is governed by a response-time cumulative checkpoint zip gate.
- `scripts/figure_studio_response_checkpoint_zip_gate.py` exists, compiles, and provides a generic CLI.
- S1/S4 prompt packages must audit paper-source fidelity, strict logical inference, and symbol disambiguation before image handoff.
- Historical `PATCH_REPORT_*.md` files are pruned from the clean release package without affecting runtime rules.
- On-demand reference loading remains explicit in `SKILL.md` and package notes.

## Checks

| Check | Result |
|---|---|
| Python compile | PASS |
| Response checkpoint zip gate CLI help | PASS |
| Response checkpoint zip gate fallback smoke test | PASS |
| Top-priority origin/reply section scan | PASS |
| Source-faithful prompt audit rule scan | PASS |
| Patch report pruning scan | PASS |
| Release path scan | PASS |

## Compatibility

The visible version remains `3.2.15b`. The package keeps the terminal S0→S5 workflow, image-only S2/S5 behavior, preference-led second-round coverage, max-eight S5 cap, and repair-or-redo checkpoint semantics.
