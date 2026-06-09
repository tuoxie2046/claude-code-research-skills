# S3 To S5 Candidate Module v3.2.15b

S3 must first review and aggregate S2 sketches, then select direction.

S3 responsibilities:

- inspect registered S2 images;
- record issue-ledger and visual-signal summaries;
- accept optional user-named preferred S2 candidate IDs as preference signals, while still selecting by evidence and contract compliance;
- record explicit `user_preferred_first_round_candidate_ids` when the S3 prompt names preferred first-round candidates;
- transfer useful/risky S2 findings to S4;
- choose the refinement direction.

S3 preference signals are weighted signals, not unconditional final selections. If S3 does not select a user-preferred candidate or does not use it as a leading ingredient, S3 must record why.

S4 is the formal candidate brief stage and prepares all S5 prompt packages before closing.

S4 must prepare:

- formal candidate matrix;
- S2 issue transfer and negative constraints;
- formal layout/routing/arrow contracts with `edge_support_ledger`;
- connector multiplicity/bundling audit;
- visible text whitelist;
- line-carried variable registry and edge-label-first variable placement;
- modularity-not-fragmentation gate;
- simple reviewer-recognizable internal visual motif plan;
- redundancy/background-context budget gates;
- prompt contradiction audit plus a maximum 3-cycle audit/repair log;
- preference-led second-round coverage when S3 recorded preferred first-round candidates;
- `outputs/S5-candidate-image/prompt-index.json`;
- candidate/artifact ID coherence: every S5 prompt-index row must preserve the same `candidate_id` across `prompt_path`, `target_image_path`, registry keys, artifacts, status files, and checkpoint inventories. Default formal IDs are F01-F06, not C01-C06.

## Preference-led second-round coverage

If S3 recorded explicit user-preferred first-round candidate IDs, S4 must include at least one S5 local-essence candidate led by each preferred first-round source for every S4-declared second-round style/treatment slot.

The required count is dynamic:

```text
required_preference_rows = len(preferred_source_ids) × len(style_slots)
```

S4 may expand the S5 matrix as needed only within the configured safe maximum of eight schemes. If the coverage requirement exceeds eight, S4 must stop at a text checkpoint and repair/replan or ask the user for a trade-off instead of silently dropping coverage or creating a ninth scheme. The workflow must not hard-code preferred IDs, style counts, or paper-specific image counts; the eight-scheme cap is a generic workflow maximum.

Each preference-led S5 prompt must bind:

- `source_first_round_candidate_id`
- `style_id`
- `preference_coverage_role = preferred_first_round_local_essence_lead`

and must state that the source candidate is a visual preference signal only. It must preserve useful local visual essence while repairing S3 issue-ledger problems and preserving source-grounded paper semantics.

S5 is image generation only and terminal. It reads the S4-prepared prompt-index, maps generated images by exact prompt-index row order, mirrors each image to the same row `target_image_path`, generates formal candidates through the approved image route, and then assistant workflow ends.

S4 image prompts must explicitly include the strict hard-constraint block from `references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md`: source-supported arrows only, one bundled connector unless distinct labeled transfers are supported, variables on lines/ports/tags, modular not fragmented, simple internal motifs, no duplicate workflow or redundant inset, and small background context.
