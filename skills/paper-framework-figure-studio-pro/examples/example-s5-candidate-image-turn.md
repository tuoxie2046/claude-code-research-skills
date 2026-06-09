# Example: S5-CANDIDATE-IMAGE

Run only S5 IMAGE_GENERATE. Read the S4-prepared prompt-index, preserve each row-level candidate_id exactly, then generate the requested formal raster candidates only through the runtime-locked image route and register/mirror each image to that row's target_image_path. Do not convert F01-F06 or any prompt-index id into C01-C06 or numeric ids. Do not create SVG or local/programmatic PNG/WebP substitutes. Do not write audit, explanation, ranking, revision guidance, aggregate narrative, caption package, or next-step prose. S5 is terminal.
