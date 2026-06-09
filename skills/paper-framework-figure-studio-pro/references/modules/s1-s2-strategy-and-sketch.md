# S1/S2 Strategy And Sketch Module v3.2.15b

S1 is the strategy stage and prepares all S2 prompt packages before closing.

S1 must prepare:

- reader question and figure role;
- paper-core semantics lock;
- S2 candidate cards;
- S2 narrative/layout divergence matrix;
- source-grounded text whitelist;
- edge/port/arrow contracts with `edge_support_ledger`;
- connector multiplicity/bundling audit;
- line-carried variable registry and edge-label-first variable placement;
- semantic graph versus visual render graph split;
- modularity-not-fragmentation gate;
- simple reviewer-recognizable internal visual motif plan for core compound modules;
- redundancy/background-context budget gates;
- prompt contradiction audit plus a maximum 3-cycle audit/repair log;
- `outputs/S2-sketch-explore/prompt-index.json`;
- candidate/artifact ID coherence: every S2 prompt-index row must preserve the same `candidate_id` across `prompt_path`, `target_image_path`, registry keys, artifacts, status files, and checkpoint inventories.

S2 is image generation only. It reads the S1-prepared prompt-index, maps generated images by exact prompt-index row order, mirrors each image to the same row `target_image_path`, and creates formal publication-style first-round candidates through the approved image route unless S1 records an explicit user-selected compatible first-round style override. It does not audit, rerun, rank, aggregate, discuss style, or hand off.


S1 image prompts must explicitly include the strict hard-constraint block from `references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md`: source-supported arrows only, one bundled connector unless distinct labeled transfers are supported, variables on lines/ports/tags, modular not fragmented, simple internal motifs, no duplicate workflow or redundant inset, and small background context.
