# Prompt Template v3.2.15b

## S0 prompt

请使用 paper-framework-figure-studio-pro skill，进入并只执行 S0-PAPER-FOUNDATION。

本轮纯文字：只执行文字、state、manifest、brief、audit、guidance 或 checkpoint 写入；不要生成任何图片。

## S1 prompt

请使用 paper-framework-figure-studio-pro skill，根据当前状态和 S0 产物，进入并只执行 S1-FIGURE-STRATEGY。S1 必须内置完成原 S1-embedded S2 preparation 的职责，生成 S2 prompt-index 和候选 prompt packages；必须对每个生图 prompt 做严格契约审核与最多 3 次修复循环，检查所有箭头/连线的论文证据、连接线去重/合并、变量在线上/port/tag 表达、模块化不碎片化、内部示意图简洁通用、workflow 不重复、背景只占小部分；不要生成图片。

本轮纯文字：只执行文字、state、manifest、brief、audit、guidance 或 checkpoint 写入；不要生成任何图片。

## S2 prompt

请使用 paper-framework-figure-studio-pro skill，根据当前状态和 S1 已登记产物，进入并只执行 S2-SKETCH-EXPLORE 的 IMAGE_GENERATE。读取 S1 生成的 S2 prompt-index，逐一读取每个 candidate 的 prompt_path，并按同一行 candidate_id 生成/登记对应 target_image_path；candidate_id、prompt_path、target_image_path、状态文件、artifact 和 checkpoint 必须一致。只生成图像，不写审计、排名、解释、修复、聚合或下一步文本。

## S3 prompt

请使用 paper-framework-figure-studio-pro skill，根据当前状态、S0/S1 产物和 S2 已生成图像，进入并只执行 S3-DIRECTION-SELECT。S3 必须先内置完成原 S3 review of S2 outputs 和 aggregate 的职责，再做方向选择；用户可在本提示中指定倾向的一个或多个第一轮候选图 ID 作为参考信号，但 S3 仍需基于论文证据和契约审核选择方向；不要生成图片。

本轮纯文字：只执行文字、state、manifest、brief、audit、guidance 或 checkpoint 写入；不要生成任何图片。

## S4 prompt

请使用 paper-framework-figure-studio-pro skill，根据当前状态和 S3 方向选择结果，进入并只执行 S4-CANDIDATE-BRIEF。S4 必须内置完成原 S4-embedded S5 preparation 的职责，生成 S5 prompt-index 和 formal candidate prompt packages；必须对每个生图 prompt 做严格契约审核与最多 3 次修复循环，检查所有箭头/连线的论文证据、连接线去重/合并、变量在线上/port/tag 表达、模块化不碎片化、内部示意图简洁通用、workflow 不重复、背景只占小部分；不要生成图片。

本轮纯文字：只执行文字、state、manifest、brief、audit、guidance 或 checkpoint 写入；不要生成任何图片。

## S5 prompt

请使用 paper-framework-figure-studio-pro skill，根据当前状态和 S4 已登记产物，进入并只执行 S5-CANDIDATE-IMAGE 的 IMAGE_GENERATE。读取 S4 生成的 S5 prompt-index，逐一读取每个 candidate 的 prompt_path，并按同一行 candidate_id 生成/登记对应 target_image_path；candidate_id、prompt_path、target_image_path、状态文件、artifact 和 checkpoint 必须一致，不要把 F01-F06 或 prompt-index 中的其他 ID 改写成 C01-C06 或数字序号。只生成图像，不写审计、排名、解释、修复、聚合、最终 caption 或下一步文本。S5 生图后 assistant workflow 结束。

## Terminal answer

```text
我的任务已经完成，剩下由人类来决策。
```
