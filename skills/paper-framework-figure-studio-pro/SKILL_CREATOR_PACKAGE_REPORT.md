# Skill Creator Package Report v3.2.15b

This package updates paper-framework-figure-studio-pro to v3.2.15b.

## v3.2.15b first-round formal publication default

- Updates package-visible version fields to `3.2.15b`.
- Changes the first-round/S2 default style from `low_fidelity_sketch` to `formal_publication_schematic` / 正式出版风格.
- Keeps the non-blocking S1 reminder and makes it tell users they may change the next S2 prompt's `第一轮默认风格：正式出版风格` clause before image generation.
- Preserves the terminal S0→S5 image-only workflow and prompt-index/candidate/artifact ID coherence behavior.

## v3.2.15b strict modular prompt contract

- Adds `references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md`.
- Requires S1/S4 prompt packages to audit connector evidence, connector multiplicity, edge-label-first variables, modularity, internal motif simplicity, workflow redundancy, and context budget.
- Requires every image prompt to carry these hard constraints in prompt text.
- Limits prompt audit/repair to three cycles before residual-risk stop.
- Updates S3 guidance to let users name preferred first-round candidate IDs as preference signals.

## v3.2.15b Preferred First-Round Carryover

- Adds a generic carryover rule for user-preferred S2 candidates named during S3.
- S4/S5 preparation must allocate local-essence refinement rows per preferred candidate and active style family.
- Adds generic Python guard code and dynamic formal matrix helper logic.

## v3.2.15b preference carryover and checkpoint guard hardening

- Updates package-visible version fields to `3.2.15b`.
- Adds `references/preferred-first-round-carryover-policy-v3215b.md`.
- Adds generic preference carryover helpers and CLI guard.
- Requires S3 user-preferred first-round candidate IDs to be preserved into S4/S5 as preference-led local-essence candidates across active style families.
- Reinforces cumulative checkpoint response gates and S3 registered-image checkpoint coverage.


## v3.2.15b repair-or-redo addendum

Incomplete cumulative checkpoints are not valid closure artifacts. The workflow must repair them generically or redo the producing stage/substage and rebuild until the guard passes. Explicit S3 preferred first-round candidate IDs require second-round local-essence candidates for every active S5 style family.

## v3.2.15b response zip gate / source-faithful prompt audit clean-release addendum

- Moves the design-origin and fixed reply rules into the top-priority controller area of `SKILL.md`.
- Adds a response-time cumulative checkpoint zip gate for every workflow text reply and introduces `scripts/figure_studio_response_checkpoint_zip_gate.py`.
- Adds source-faithful image-prompt and symbol-disambiguation policies so prompt entities, relations, connectors, and symbols must be paper-supported or justified by strict recorded inference.
- Adds context-on-demand packaging guidance and removes historical `PATCH_REPORT_*.md` files from the clean release package because they are not runtime dependencies.
