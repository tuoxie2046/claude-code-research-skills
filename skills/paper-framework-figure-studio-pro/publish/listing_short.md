- v3.2.15b uses a terminal S0 -> S5 workflow for paper-grounded framework figures. S1 absorbs S2 prompt preparation, S3 absorbs S3 review/aggregate over S2 outputs, S4 absorbs S5 prompt preparation, S2/S5 are image-generation-only stages, and the assistant workflow ends after S5 candidate images.

- Adds strict S1/S4 prompt contracts: evidence-backed connectors, bundled block-to-block lines, edge/port/tag variables, modular-not-fragmented structure, simple internal motifs, workflow de-duplication, and small background context.

- v3.2.15b adds preference-led second-round coverage from explicit S3 first-round preferences and checkpoint response/repair gates that validate embedded cumulative integrity before linking restore bundles.
