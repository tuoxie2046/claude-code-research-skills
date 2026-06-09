## v3.2.15b — Response Checkpoint Zip Gate + Source-Faithful Prompt Audit

- Moves design-origin and fixed reply rules into a top-level highest-priority controller section in `SKILL.md`.
- Requires every workflow text reply to validate or rebuild a cumulative checkpoint zip mirror before claiming the stage is recoverable or handing off to the next stage.
- Adds `scripts/figure_studio_response_checkpoint_zip_gate.py` and `references/response-checkpoint-zip-gate-policy-v3215b.md`.
- Adds source-faithful prompt audit and symbol-disambiguation gates: all image-prompt entities, relationships, connectors, and symbols must be paper-supported or derived through strict recorded inference.
- Adds package context-on-demand guidance and prunes historical `PATCH_REPORT_*.md` files from the clean release package.

## v3.2.15b — Final Redo Gate For Checkpoints And Preference Coverage

- A failed cumulative checkpoint repair is now a `redo_required` diagnostic, not a final restore checkpoint state.
- User-facing checkpoint links may only point to `complete_restore_ready` bundles with passing cumulative integrity.
- If missing assets cannot be repaired generically, the affected public step or image-registration/prompt-preparation step must be redone before proceeding.
- Preference-led S5 coverage from explicit S3 first-round preferences must be satisfied by dynamic rows; S4 must expand or be redone with feasible style/candidate allocation.
- The implementation remains paper-neutral: all IDs, style slots, target paths, and counts are derived from project records and prompt-index files.


## v3.2.15b max-eight hotfix

- Adds an absolute second-round/S5 maximum of eight formal candidate schemes.
- Keeps default F01-F06 but allows preference coverage expansion only to F07/F08.
- If preferred-source × active-style coverage cannot fit within eight, S4 must repair/replan or redo before S5 handoff; no ninth scheme or batch-splitting bypass is allowed.

## v3.2.15b repair-or-redo checkpoint gate hardening

- Makes incomplete cumulative checkpoints non-final: missing assets must be repaired or the producing stage/substage must be redone.
- Treats `redo_required` as a transient diagnostic only, never a usable checkpoint state.
- Requires root-level `checkpoint-integrity-audit.json` in cumulative checkpoints.
- Keeps preference-led second-round local-essence coverage for explicit S3 first-round user preferences.

# Changelog

## v3.2.15b — Preference Coverage + Checkpoint Repair + Genericity Guards

- If S3 records explicit user-preferred first-round S2 candidate IDs, S4 must carry them into S5 as preference-led local-essence candidates for every declared second-round style/treatment slot.
- Adds generic preference-coverage matrix generation and validation helpers; coverage derives from S3 preference IDs and S4 style slots, never from hard-coded candidate counts, page counts, project IDs, or paper domains.
- Strengthens checkpoint response/repair gating: a linked cumulative checkpoint must contain `checkpoint-manifest.json` and a passing `checkpoint-cumulative-integrity.json`; incomplete bundles must be rebuilt from cumulative roots; if rebuild cannot recover required assets, redo the producing stage/substage before closure.
- Adds configurable paper-neutral hardcoding lint for active reusable files while keeping vector-library metadata non-doctrinal.
- Keeps S2/S5 image-only stages and the terminal human decision boundary after S5.

## v3.2.15b — Preference-Led Second-Round Coverage + Checkpoint Response Gate

- Adds/locks the S3→S4 preference-transfer contract: user-preferred first-round candidate IDs become machine-checkable second-round coverage obligations.
- Requires every valid preferred first-round ID to lead at least one S5 local-essence refinement for every active second-round style family, unless the user explicitly withdraws the preference or S4 stops for budget negotiation.
- Adds generic preference-coverage helpers and guard script updates; candidate IDs, styles, and counts are derived from prompt-index/candidate rows, not hard-coded.
- Strengthens checkpoint response gating so user-facing checkpoint links require an in-archive cumulative integrity PASS / complete_restore_ready report.
- Adds paper-neutral hardcoding lint guidance and keeps project-specific paper facts out of reusable skill files.

## v3.2.15b — Preferred First-Round Carryover + Dynamic Formal Matrix

- Bumps package-visible version fields to `3.2.15b`.
- Adds `references/preferred-first-round-carryover-policy-v3215b.md`.
- If S3 records user-preferred first-round S2 candidate IDs, S4 must preserve them as machine-readable preference signals and S5 prompt preparation must include preference-led local-essence candidates.
- Coverage rule: for every preferred first-round candidate and every active second-round style family, allocate at least one S5 candidate with `lineage_role: preference_led_local_essence_refinement`, `dominant_source_candidate_id`, and `style_family`.
- Treats the default six S5 candidates as a floor, not a cap, whenever preference/style coverage requires additional rows. Candidate counts and style families are derived dynamically from project records.
- Adds generic Python helpers and a preference-coverage guard. The guard does not encode project IDs, paper topics, candidate IDs, image counts, or filenames.
- Reinforces cumulative checkpoint guards: linked stage-final checkpoints must be cumulative PASS bundles, not delta zips.

## v3.2.15b — Preference Carryover + Checkpoint Link Gate

- Adds a paper-agnostic preferred first-round carryover policy. When S3 records user-preferred S2 candidate IDs, S4 must create at least one second-round preference-led local-essence candidate for each preferred ID in every active S5 style family.
- Adds generic helpers and a CLI guard that discover preferred IDs and style families from S3/S4/S5 records, without hard-coding candidate counts, image counts, paper topics, or filenames.
- Makes default S5 candidate count a floor rather than a cap when preference × style coverage requires extra rows.
- Hardens checkpoint response behavior: linked checkpoints must pass embedded cumulative integrity validation, and S3 cumulative checkpoints must include registered S2 candidate images at active prompt-index paths.

## v3.2.15b — Formal Default + Strict Modular Prompt Contract

- Package-visible version remains `3.2.15b` as requested, while retaining the formal first-round default behavior.
- Keeps the first-round/S2 default rendering surface as `formal_publication_schematic` / 正式出版风格 and preserves the S1 style-override reminder.
- Adds `references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md`.
- Makes S1/S4 prompt preparation run a mandatory strict prompt audit and repair loop up to 3 cycles before image handoff.
- Requires every planned connector to have source-material evidence for upstream endpoint, downstream endpoint, direction, and transferred meaning.
- Requires one bundled connector between two block-level modules unless distinct source-supported quantities justify multiple labeled lines.
- Requires transferred variables to live on connectors, ports, forks, merges, or tags rather than peer module boxes.
- Requires modular-not-fragmented layouts, simple reviewer-recognizable internal motifs, no repeated workflows or redundant zooms, and small background-context panels.
- Updates S3 guidance so users may name preferred first-round candidate IDs as reference signals for later direction selection.
- Preserves the terminal S0→S5 workflow, image-only S2/S5, and candidate/artifact ID coherence rules.

# Changelog
## v3.2.15b — First-Round Style Default Hotfix

- Bumps the package-visible version number to `3.2.15b`.
- Current package-level default is `formal_publication_schematic` / 正式出版风格.
- Adds `references/first-round-default-style-guidance-policy-v3215a.md` with a required S1 non-blocking user reminder.
- Requires S1 handoff prompts to tell users that they may change the first-round default before S2, and lists compatible options: low-fidelity sketch, whiteboard wireframe, clean flat minimal line-art, formal schematic layout study, light blueprint, light scientific illustration, light interface metaphor, light isometric structure, light infographic board, and hand-drawn storyboard.
- Records the first-round default style, option menu, and user reminder in project-state defaults.

## v3.2.15 — Candidate / Artifact ID Coherence

- Adds a generic candidate-id coherence policy across S2/S5 prompt-index rows, prompt paths, target image paths, stage manifests, substage candidate ids, candidate registries, artifact records, image-generation events, outputs, and checkpoint image inventories.
- Makes prompt-index `candidate_id` the source of truth after S1/S4 preparation; scripts must not renumber formal S5 images as Cxx or raw numeric ids when the prompt-index uses Fxx or another safe id family.
- Updates S5 formal candidate defaults to F01-F06 while preserving S2 C01-C08 defaults and accepting any validated prompt-index ids.
- Updates prompt-index helpers to normalize both object-shaped candidate maps and canonical ordered candidate lists.
- Updates starter/copyable prompts so they say “请使用 paper-framework-figure-studio-pro skill” rather than referring to a versioned zip package.
- Adds `references/candidate-artifact-id-coherence-policy-v3215.md` and `references/s2-s5-image-only-terminal-orchestration-policy-v3215.md`.

## v3.2.14 — Fixed Candidate Contract Without User-Exposed Mode

- Removes the user-facing contract-check setting from startup guidance, copyable prompts, project state templates, and policy references.
- Keeps the fixed candidate contract behavior internal: S1/S4 prepare strict prompt contracts; S3 reviews and aggregates S2; S2/S5 remain image-generation-only; S5 remains terminal.
- Replaces the inactive contract-check-mode reference with `references/fixed-candidate-contract-policy-v3214.md`.
- Updates scripts, metadata, templates, and release text so users are not invited to modify a single-option setting.

## v3.2.13 — Terminal Image-Only S2/S5 Workflow

- Changes the main workflow to: S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> END.
- Makes S2 and S5 image-generation-only public stages.
- Moves S2 prompt-package preparation into S1 as a mandatory responsibility.
- S3 reviews generated S2 candidates and aggregates exploration signals before direction selection.
- Moves S5 prompt-package preparation into S4 as a mandatory responsibility.
- Removes S2/S5 candidate-level rerun and review.
- Removes S2/S5 standalone aggregate substages.
- Removes all assistant workflow after S5. After S5, remaining selection, revision, captioning, and paper integration are human decisions.
- Removes future-image-stage parity based on the inactive dynamic text-image substage template.
- Introduced the fixed candidate contract behavior that v3.2.14 later made non-user-configurable.
- Adds `references/s2-s5-image-only-terminal-orchestration-policy-v3213.md`.
- Updates state schema, metadata, examples, templates, architecture assets, and scripts for terminal S5 behavior.

## v3.2.12 — S2 Narrative Strategy And Layout Divergence Hardening

- Added generic S2 narrative-strategy and layout-divergence gates so first-round sketches test different method-story explanations rather than near-duplicate layouts.

## v3.2.11 — Edge-Label-First And Internal Motif Hardening

- Added edge-label-first rendering, semantic-vs-visual graph separation, line-carried variable registries, and internal visual motif requirements for core compound modules.

## v3.2.10 — Academic Hierarchy And Image Mirror Hardening

- Added academic framework hierarchy, connector bundling/edge economy, and stage-local image mirror requirements without paper-specific hardcoding.

## v3.2.9 — Cumulative Checkpoint Integrity

- Added cumulative checkpoint integrity validation for restore bundles.

## v3.2.8 And Earlier

- Added framework abstraction, entity-density control, flowline semantics, semantic graph prompt contracts, image-route hardening, caption symbiosis, and S0 readiness policies.
