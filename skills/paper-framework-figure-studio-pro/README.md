# Paper Framework Figure Studio Pro

Version: **3.2.15b**

A human-in-the-loop skill for paper-grounded research framework figures: architecture diagrams, method overviews, mechanism schematics, system/data-flow figures, and pipeline figures.

## v3.2.15b workflow

```text
Bootstrap / plan-only gate
  ↓
S0-PAPER-FOUNDATION
  ↓
S1-FIGURE-STRATEGY
  └─ prepares S2 prompt packages
  ↓
S2-SKETCH-EXPLORE
  └─ image generation only
  ↓
S3-DIRECTION-SELECT
  └─ reviews and aggregates generated S2 candidates
  ↓
S4-CANDIDATE-BRIEF
  └─ prepares S5 prompt packages
  ↓
S5-CANDIDATE-IMAGE
  └─ image generation only, terminal
```

After S5, the assistant workflow is complete. The remaining selection, manual editing, final captioning, and paper-layout decisions are handled by humans.

If asked what comes after S5, answer:

```text
我的任务已经完成，剩下由人类来决策。
```

## What changed in v3.2.15b

- Moves the design-origin and fixed reply principles to the top of `SKILL.md` as highest-priority controller rules.
- Adds a response-time cumulative checkpoint zip gate: every workflow text reply must ensure a complete restore-ready zip exists or rebuild/reconstruct before claiming recoverability.
- Adds `scripts/figure_studio_response_checkpoint_zip_gate.py` for generic zip validation/repair dispatch.
- Hardens S1/S4 image-prompt audits: every entity, relation, connector, symbol, variable, and label must be source-supported or derived by strict recorded logic; contradictions and symbol mixing block image handoff.
- Keeps skill packaging context-light: runtime rules stay in `SKILL.md`/`references`/`scripts`, while historical `PATCH_REPORT_*.md` files may be pruned from clean release packages.

- If S3 records user-preferred first-round S2 candidate IDs, S4/S5 prompt preparation must include preference-led local-essence second-round candidates: at least one row for every preferred candidate × active S5 style family pair, provided the pair set fits the absolute eight-scheme second-round cap. Default F01-F06 may expand only to F07/F08; beyond eight, S4 must repair/replan or redo the active style/preference allocation before S5.
- Adds a generic preference coverage guard and carryover helpers; they derive IDs/styles from project records and never hard-code paper topics, candidate counts, or fixed image pages.
- Hardens cumulative checkpoint messaging: only PASS cumulative checkpoint zips may be linked as restore bundles.

- S2 and S5 are now **image-generation-only public stages**.
- S1 **must** perform the S2 prompt-package preparation responsibilities before closing.
- S3 **must** review generated S2 candidates and aggregate exploration signals before or during direction selection.
- S4 **must** perform the S5 prompt-package preparation responsibilities before closing.
- S2/S5 rerun, review, and standalone aggregate substages are removed.
- There is no assistant workflow after S5; human selection and manuscript use are outside this skill.
- The active workflow has no image-stage parity substage.
- User-facing contract-check configuration remains removed; the fixed candidate contract behavior is built into S1/S3/S4 and never appears as a prompt option.
- Prompt-index `candidate_id` is now the hard source of truth for S2/S5 image ids, paths, state registries, artifacts, and checkpoints.
- S2 defaults to `C01`-`C08` and the first-round rendering default is `formal_publication_schematic` / 正式出版风格; S5 defaults to `F01`-`F06`, but any validated prompt-index id set is allowed without paper-specific hardcoding.
- Suggested user prompts say “请使用 paper-framework-figure-studio-pro skill” rather than naming a versioned skill zip.
- S1 handoffs now include a compact style-reminder: first-round S2 defaults to formal publication-style schematics, and users are reminded before S2 that the next prompt can change it to a compatible option such as low-fidelity sketch, whiteboard wireframe, clean minimal line-art, formal schematic layout study, light blueprint, light scientific illustration, interface metaphor, isometric structure, infographic board, or hand-drawn storyboard.
- Strict S1/S4 prompt contracts are now hard-gated: every image prompt must audit source-supported connectors, connector multiplicity/bundling, variables on edges/ports/tags, modular-not-fragmented structure, simple reviewer-recognizable internal motifs, workflow de-duplication, and small background context with a maximum 3-cycle repair loop.
- S3 next-step guidance reminds users that they may name preferred first-round candidate IDs as reference signals for direction selection.

- If S3 records explicit user-preferred first-round S2 candidates, S4 must generate second-round S5 local-essence candidates led by each preferred source for every declared S5 style/treatment slot; the S5 matrix expands dynamically only within the configured safe maximum of eight instead of silently dropping preference coverage or creating a ninth scheme.
- Checkpoint links are gated by cumulative integrity validation: a usable checkpoint must include `checkpoint-manifest.json`, a passing `checkpoint-cumulative-integrity.json`, all prior-stage roots, existing assets, and registered stage-local raster mirrors; incomplete bundles must be rebuilt generically; if rebuild cannot recover required assets, redo the producing stage/substage before closure.
- New generic helper scripts support preference-coverage planning/validation and configurable paper-neutral hardcoding lint without embedding paper topics, candidate IDs, image counts, or page counts.
- If S3 records preferred first-round candidate IDs, S4/S5 must include preference-led local-refinement candidates for every preferred ID across every active second-round style family.
- Checkpoint links shown to users must pass an in-archive cumulative integrity response gate; newest-numbered delta zips cannot be advertised as stage-final checkpoints.
- If S3 records user-preferred first-round candidate IDs, S4 must allocate preference-led local-essence S5 candidates for every preferred ID across every active S5 style family; the default S5 count may expand only up to the eight-scheme second-round cap.
- Checkpoint links may only be reported as usable cumulative checkpoints after embedded guard validation passes; S3 cumulative checkpoints must include registered S2 images.

## Image route

Target paper images must be generated only through the environment-approved image route:

- Codex: `image_gen`
- ChatGPT web: Create Image / ChatGPT Images 2.0
- Other runtimes: named approved image-generation API only

The workflow forbids SVG, Mermaid, HTML/canvas, Python/PIL/Pillow, Matplotlib, Graphviz, TikZ, PPT/PDF rendering, screenshots, SVG-to-PNG, and local programmatic raster substitutes for target paper images.

## Main safeguards

- Paper-grounded source evidence and risk register from S0.
- Reader-first visual strategy and S2 prompt preparation inside S1.
- Formal publication-style first-round S2 candidates by default; S1 reminds users before S2 that the first-round default style can be changed in the next prompt to a listed compatible option.
- S3 issue-ledger review of generated S2 candidates and direction selection.
- Formal candidate prompt preparation inside S4.
- Formal candidate image generation in S5.
- Human decision boundary after S5.
- Candidate/artifact/checkpoint id coherence validation across outputs and state files.
- Strict modular prompt validation: source-supported arrows only, bundled connectors, edge-label-first variables, simple internal motifs, no duplicate workflows, and background context kept minor.
- Entity compression guard: repeated entity families default to compact markers around one canonical process unless sources justify distinct branches.
- Conversation-aware next-step guidance: current conversation stage execution and image generation events outrank checkpoint recency when suggesting the next prompt.
- Preference-led S5 coverage: explicit S3 first-round preferences create local-essence coverage obligations in S4/S5 for every declared style/treatment slot.
- Cumulative checkpoint response gate: linked restore checkpoints must pass embedded integrity validation, otherwise rebuild or redo the producing stage/substage before closure.
- Response checkpoint zip gate: every workflow text reply validates or rebuilds a cumulative checkpoint mirror before reporting a recoverable state.
- Prompt source-faithfulness: prompt packages block unsupported or paper-contradicting entities, relations, connectors, and symbol assignments.

## Package notes

Reusable skill files must stay paper-neutral. Project-specific paper facts, module names, variables, datasets, candidate outputs, and audit conclusions belong only in run outputs, not in the skill package.


## v3.2.15b Repair-or-redo checkpoint gate

Cumulative checkpoints are complete-or-redone. If a checkpoint cannot be rebuilt from existing cumulative roots, the workflow must redo the producing stage/substage for the missing assets before handoff. `redo_required` is a transient blocker, not a final recoverable status.


## v3.2.15b final redo gate

Checkpoint repair failure is a redo trigger, not a recoverable checkpoint state. If cumulative roots, existing assets, or registered rasters cannot be rebuilt into a complete restore bundle, redo the affected stage or registration/prompt-preparation step and rebuild until validation passes. Preference-led second-round coverage from explicit S3 choices must be satisfied by dynamic S5 rows; if a runtime limit blocks coverage, redo S4 allocation rather than dropping rows.
