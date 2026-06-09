# paper-framework-figure-studio-pro v3.2.15b

A human-in-the-loop workflow for research-paper framework, architecture, pipeline, data-flow, and mechanism figures.

Workflow: Bootstrap -> S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> END.

Key behavior:

- S0 builds the paper foundation and risk register.
- S1 designs the figure strategy and must prepare all S2 prompt packages/prompt-index.
- S2 generates formal publication-style first-round candidates through the approved image route by default; S1 reminds users that the next S2 prompt can change the first-round style to one of the listed compatible options before image generation.
- S3 reviews/aggregates S2 visual signals and selects the direction.
- S4 prepares formal candidate briefs and all S5 prompt packages/prompt-index.
- S5 only generates formal raster candidates and ends the assistant workflow.
- Human selection, manuscript captioning, and downstream editing after S5 are outside this skill.

Strict prompt contract: S1/S4 prompt packages must prove source support for every connector, merge duplicate block-to-block lines unless they carry distinct labeled quantities, keep transferred variables on edges/ports/tags, preserve modular structure, use simple reviewer-recognizable internal motifs, avoid duplicate workflows/insets, and keep background context minor. S3 guidance lets users name preferred first-round candidate IDs as reference signals.
