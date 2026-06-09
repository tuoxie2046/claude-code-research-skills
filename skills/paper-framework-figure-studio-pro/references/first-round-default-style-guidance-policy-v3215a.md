# First-Round Default Style And Override Reminder Policy v3.2.15b

This source-policy update is packaged in this release as `v3.2.15b`.

“First round” means the S1-prepared, S2-generated candidate batch (`C01`-`C08` by default). It does not mean the S5 formal candidate round.

## Default First-Round Surface

The default first-round surface is `formal_publication_schematic` / 正式出版风格.

Unless the user explicitly overrides it before S2 generation, every required S2 prompt package and S2 image-only handoff must request a clean publication-style academic framework schematic: polished but restrained vector-like layout, crisp module hierarchy, readable labels, precise arrow routing, light scientific color palette, and manuscript-ready structure.

This default changes only the rendering surface. S1 must still vary the eight S2 candidates across layout grammar, reader path, semantic focus, density, detail strategy, visual rhetoric, and style lens. Those are design hypotheses. They do not allow paper-unsupported content, raw-data-sharing implications, cluttered dashboards, or decorative polish that weakens semantic readability.

## Non-Blocking User Reminder

At the end of S1-FIGURE-STRATEGY, before the S2 image-only handoff prompt, include a compact, non-blocking reminder that the first-round default style can be changed in the next prompt before running S2. This reminder must not pause the workflow or ask a mandatory question.

Use this meaning in Chinese user-facing handoffs:

```text
第一轮默认风格：正式出版风格。若要在 S2 生图前修改第一轮默认风格，可把下一步提示词里的「第一轮默认风格：正式出版风格」改为以下之一：正式出版风格、低保真草图、白板线框、干净扁平极简线稿、正式 schematic 布局草案、轻量蓝图精密稿、轻量科学插画、轻量界面隐喻、轻量等距结构、轻量信息图板、手绘故事板。
```

The S1 handoff prompt should also carry the explicit clause `第一轮默认风格：正式出版风格` so the user has a concrete phrase to edit.

## Allowed First-Round Style Options

These options are compatible with S2 only when they remain source-grounded and governed by the same paper-semantics, arrow, hierarchy, density, and prompt-audit contracts.

| Option ID | User-facing label | S2 meaning |
|---|---|---|
| `formal_publication_schematic` | 正式出版风格 | Default. Clean publication-style academic framework schematic for first-round comparison; polished surface, but still one candidate direction. |
| `low_fidelity_sketch` | 低保真草图 | Rough exploratory framework sketch, whiteboard/wireframe feel, sparse labels. |
| `whiteboard_wireframe` | 白板线框 | Very rough boxes, arrows, grouping, and layout structure with minimal surface polish. |
| `clean_flat_minimal_line` | 干净扁平极简线稿 | Cleaner line-art while still exploratory; no excessive final polish. |
| `formal_schematic_layout_study` | 正式 schematic 布局草案 | More ordered schematic grammar for layout testing. |
| `precision_blueprint_light` | 轻量蓝图精密稿 | Grid/port/routing emphasis for high arrow-risk papers; avoid dense blueprint clutter. |
| `scientific_editorial_light` | 轻量科学插画 | Light scientific editorial treatment with separable modules and restrained texture. |
| `interface_metaphor_light` | 轻量界面隐喻 | UI/control-board metaphor only when it clarifies paper mechanisms without adding facts. |
| `isometric_structure_light` | 轻量等距结构 | Mild dimensional structure only when it does not obscure connectors or labels. |
| `infographic_board_light` | 轻量信息图板 | Compact explanation board, with density and caption burden explicitly budgeted. |
| `hand_drawn_storyboard` | 手绘故事板 | Narrative/storyboard option only when S1 records a close story-to-paper bridge. |

Forbidden as S2 defaults: photorealism, cinematic rendering, glossy marketing poster style, dense dashboard, decorative texture that makes semantic primitives hard to read, or any style that weakens source-grounding.

## Prompt-Index And State Recording

S1 should record the first-round style decision in state and prompt packages when available:

- `first_round_default_style_id`: `formal_publication_schematic` unless explicitly overridden;
- `first_round_style_options`: the allowed option menu above;
- `first_round_style_user_reminder`: the compact reminder text;
- candidate-level `first_round_style_surface` or equivalent field in S2 prompt packages.

If the user overrides the first-round style, record it as an explicit user decision and preserve the override in the S2 prompt-index/prompt packages. A first-round style override does not automatically set S5 formal style; S4 must make or confirm formal style choices using S3 direction and paper needs.

## Stage Placement

- Bootstrap/S0 may mention that first-round style is adjustable, but should not block on it.
- S1 is the main stage that must show the reminder because S1 prepares S2 prompts and stops before S2 image generation.
- S2 is image-only and must not discuss style; it simply follows the S1 prompt-index. If no explicit override is present, S2 uses `formal_publication_schematic`.
- S3/S4 may carry forward human-selected visual preferences, but should not treat an S2 surface as a final S5 style lock unless the user explicitly says so.
