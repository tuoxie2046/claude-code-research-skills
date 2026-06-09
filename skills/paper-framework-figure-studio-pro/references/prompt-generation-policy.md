# Prompt Generation Policy v3.2.15b

Long image prompts must be saved to files and referenced through `prompt-index.json`; user-visible handoff text must not inline full multi-candidate prompts.

S1 prepares S2 first-round prompts. S4 prepares S5 formal-candidate prompts. S2 and S5 only read those prompts and generate images using the environment-locked image route.

Prompt packages must remain paper-grounded: semantic graph and visual render graph are separated, visible text is whitelisted, edge direction is evidence-backed, variables/metrics/weights default to line/port/fork/merge/tag labels, and core modules include simple pictorial internal motifs.

S1/S4 prompt generation must apply `references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md`. In particular:

- every connector must have paper/material support for upstream endpoint, downstream endpoint, direction, and transferred meaning;
- between two block-level modules, use a single bundled connector unless distinct source-supported transferred quantities justify multiple labeled connectors;
- inter-module variables must appear on connectors, ports, forks, merges, or small tags, not as peer module boxes;
- the figure must be modular, not fragmented into many small disconnected micro-blocks;
- internal submodule motifs must be simple and reviewer-recognizable, using common schematic conventions instead of complex miniature algorithms;
- do not duplicate a workflow across a main block and a zoom/cutaway; if a cutaway is needed, simplify the parent block;
- keep background/context minor and preserve method-framework priority.

S1/S4 must audit and repair prompt packages for these conditions up to three cycles. If blockers remain after the third cycle, stop before image-generation handoff and write a residual-risk ledger.

No prompt generation stage exists after S5.
