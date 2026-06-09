# claude-code-research-skills

A curated collection of **Claude Code** skills and plugins for academic / research paper workflows — figures, writing, polishing, peer-review simulation, literature search, and full research→write→review pipelines.

> This is a personal install bundle. Every component is third-party work; original authorship and licenses are preserved. See **Attribution & Licenses** below. `visiomaster` is intentionally excluded (Windows + Microsoft Visio only — not usable on macOS/Linux).

## Contents

### `skills/` — standalone skills (drop into `~/.claude/skills/` or a project `.claude/skills/`)

| Skill | Version | Purpose | Source | License |
|---|---|---|---|---|
| `paper-framework-figure-studio-pro` | 3.2.15b | Human-in-the-loop paper framework/architecture figure workflow (S0–S5) | [c-narcissus/paper-framework-figure-studio-pro](https://github.com/c-narcissus/paper-framework-figure-studio-pro) | MIT-0 |
| `drawio-skill` | 1.14.0 | Generate editable `.drawio` diagrams, export PNG/SVG/PDF/JPG via draw.io CLI | [Agents365-ai/drawio-skill](https://github.com/Agents365-ai/drawio-skill) | MIT |
| `research-paper-writing` | — | ML/CV/NLP paper writing quality (section structure, flow, self-review) | [Master-cai/Research-Paper-Writing-Skills](https://github.com/Master-cai/Research-Paper-Writing-Skills) | MIT |

### `plugins/` — Claude Code plugins (install via plugin marketplace)

| Plugin | Version | Skills | Source | License |
|---|---|---|---|---|
| `nature-skills` | 1.0.0 | 10 skills: figure, polishing, writing, reviewer, citation, data, reader, response, paper2ppt, **academic-search (MCP)** | [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills) | MIT |
| `academic-research-skills` (ARS) | 3.12.0 | 18 skills/commands; 4 core (deep-research, academic-paper, academic-paper-reviewer, academic-pipeline) + `ars-*` commands | [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) (Edward Cheng-I Wu) | **CC BY-NC 4.0** |

## Install

### Standalone skills
```bash
cp -R skills/<name> ~/.claude/skills/          # user-level (all projects)
# or into a project: cp -R skills/<name> .claude/skills/
```
Restart Claude Code so it registers.

### Plugins (recommended: original marketplaces)
```bash
# nature-skills
claude plugin marketplace add Yuan1z0825/nature-skills
claude plugin install nature-skills@nature-skills

# academic-research-skills (ARS)
claude plugin marketplace add Imbad0202/academic-research-skills
claude plugin install academic-research-skills@academic-research-skills
```
(The `plugins/` copies here are a snapshot for reference/backup.)

## macOS dependencies

| Component | Needs | Install |
|---|---|---|
| `drawio-skill` export | draw.io desktop CLI | `brew install --cask drawio` |
| ARS / nature DOCX output | Pandoc | `brew install pandoc` |
| ARS APA-7 PDF compile | Tectonic | `brew install tectonic` |
| CJK PDF (Chinese) | Static CJK serif font | `brew install --cask font-noto-serif-cjk-tc` |

### ⚠️ ARS PDF + Chinese: font gotcha
ARS LaTeX templates hardcode `\setCJKmainfont{Source Han Serif TC VF}`. That **variable font crashes Tectonic** (`findFontByName` panic on variable-font `.ttc`). Before compiling a Chinese PDF, change that line to a **static** font:
```latex
\setCJKmainfont{Noto Serif CJK TC}
```
Same glyphs (Adobe/Google co-developed). English-only papers don't touch CJK fonts and compile fine.

## `nature-academic-search` MCP server

`nature-skills` ships an MCP server (`plugins/nature-skills/skills/nature-academic-search/mcp-server/`) for multi-source literature search (CrossRef + PubMed + arXiv by default; Scopus / ScienceDirect optional via Elsevier `pybliometrics` config).

Register it at **user scope** (NOTE: writing `~/.claude/.mcp.json` does **not** work — Claude Code only reads project-root `.mcp.json`; use `claude mcp add`):
```bash
MCP_DIR="$HOME/.claude/mcp_servers/academic-search"
mkdir -p "$MCP_DIR"
cp -R plugins/nature-skills/skills/nature-academic-search/mcp-server/* "$MCP_DIR/"

claude mcp add academic-search -s user \
  -e PUBMED_EMAIL=you@example.com \
  -- uv run --python 3.13 --no-project --directory "$MCP_DIR" \
  --with 'mcp>=1.0.0,<2.0.0' --with 'requests>=2.28.0,<3.0.0' --with 'toml>=0.10.2,<2.0.0' \
  --with 'lxml>=4.9.0,<6.0.0' --with 'pybliometrics>=4.4.1,<5.0.0' \
  python academic_search_server.py
```
Requires [`uv`](https://docs.astral.sh/uv/). `--python 3.13` is required because `mcp` needs Python ≥3.10 (don't rely on macOS system Python 3.9). `PUBMED_EMAIL` is required by NCBI; `NCBI_API_KEY` is optional for higher rate limits.

## Attribution & Licenses

Each subdirectory retains its upstream `LICENSE`/`NOTICE`. Notably **`academic-research-skills` is CC BY-NC 4.0 (non-commercial, attribution required)** — see `plugins/academic-research-skills/LICENSE` and `NOTICE.md`. All other components are MIT / MIT-0. This collection is a non-commercial backup; respect each upstream license for any redistribution or use.
