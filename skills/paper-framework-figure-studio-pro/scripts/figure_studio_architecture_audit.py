#!/usr/bin/env python3
"""Lightweight architecture audit for paper-framework-figure-studio-pro v3.2.15b."""
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED_FILES = [
    "SKILL.md",
    "VERSION",
    "metadata.json",
    "references/s2-s5-image-only-terminal-orchestration-policy-v3215.md",
    "references/candidate-artifact-id-coherence-policy-v3215.md",
    "references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md",
    "references/preferred-first-round-carryover-policy-v3215b.md",
    "references/restore-repair-or-redo-policy-v3215b.md",
    "scripts/figure_studio_core/constants.py",
    "scripts/figure_studio_core/identity.py",
]
FORBIDDEN_ACTIVE_TERMS = [
    "S" + "-Final",
    "TEXT" + "_FINAL",
    "IMAGE" + "_FINAL",
    "S2" + "-99-text-aggregate-checkpoint",
    "S5" + "-99-text-aggregate-checkpoint",
]
ACTIVE_TEXT_FILES = [
    "SKILL.md",
    "README.md",
    "metadata.json",
    "templates/project-state-template.json",
    "templates/prompt-template.md",
    "templates/figure-brief-template.md",
    "publish/starter_messages.md",
    "publish/listing_long.md",
    "publish/listing_short.md",
]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def main() -> int:
    findings = []
    version = (ROOT / "VERSION").read_text().strip()
    if version != "3.2.15b":
        findings.append({"level": "ERROR", "message": f"VERSION is {version}, expected 3.2.15b"})
    for rel in REQUIRED_FILES:
        if not (ROOT / rel).exists():
            findings.append({"level": "ERROR", "message": f"missing required file: {rel}"})
    skill = read("SKILL.md")
    required_phrases = [
        "S2-SKETCH-EXPLORE\n  └─ IMAGE_GENERATE only",
        "S5-CANDIDATE-IMAGE\n  └─ IMAGE_GENERATE only",
        "我的任务已经完成，剩下由人类来决策。",
        "S1-FIGURE-STRATEGY\n  └─ prepares S2 prompt packages",
        "S3-DIRECTION-SELECT\n  ├─ reviews generated S2 candidates",
        "S4-CANDIDATE-BRIEF\n  └─ prepares S5 prompt packages",
        "references/candidate-artifact-id-coherence-policy-v3215.md",
        "references/strict-source-grounded-modular-prompt-contract-policy-v3215a.md",
        "references/preferred-first-round-carryover-policy-v3215b.md",
    "references/restore-repair-or-redo-policy-v3215b.md",
        "preference_led_local_essence_refinement",
        "checkpoint-integrity-audit.json",
        "restore_repair_required_stage_redo",
        "prompt-index `candidate_id` is the source of truth",
        "modular-not-fragmented",
        "edge_support_ledger",
        "请使用 paper-framework-figure-studio-pro skill",
    ]
    for phrase in required_phrases:
        if phrase not in skill:
            findings.append({"level": "ERROR", "message": f"SKILL.md missing required v3.2.15b phrase: {phrase}"})

    forbidden_contract_terms = ["contract" + "_check" + "_mode", "candidate" + "_light" + "_extra" + "_check", "second" + "_round" + "_contract" + "_check", "candidate" + "_light"]
    forbidden_archive_prompt_terms = ["paper-framework-figure-studio-pro-" + "v3", "skill" + ".zip", "zip" + " 里的", "zip" + "里的"]
    for rel in ACTIVE_TEXT_FILES:
        path = ROOT / rel
        if not path.exists():
            findings.append({"level": "ERROR", "message": f"missing active text file: {rel}"})
            continue
        text = read(rel)
        for term in forbidden_contract_terms:
            if term in text:
                findings.append({"level": "ERROR", "message": f"{rel} exposes obsolete contract-setting term: {term}"})
        for term in forbidden_archive_prompt_terms:
            if term in text:
                findings.append({"level": "ERROR", "message": f"{rel} contains user-facing archive-specific skill wording: {term}"})
        if "outputs/S5-candidate-" + "images" in text:
            findings.append({"level": "ERROR", "message": f"{rel} uses obsolete plural S5 output directory"})
        if "outputs/S5-candidate-image/candidates/" + "C01" in text:
            findings.append({"level": "ERROR", "message": f"{rel} uses obsolete C01 default for S5 candidates"})

    meta = json.loads(read("metadata.json"))
    if meta.get("terminal_step") != "S5-CANDIDATE-IMAGE":
        findings.append({"level": "ERROR", "message": "metadata terminal_step must be S5-CANDIDATE-IMAGE"})
    if any(row.get("step") == ("S" + "-Final") for row in meta.get("workflow", [])):
        findings.append({"level": "ERROR", "message": "metadata workflow must not contain a assistant stage after S5"})
    if meta.get("version") != "3.2.15b":
        findings.append({"level": "ERROR", "message": "metadata version must be 3.2.15b"})
    print(json.dumps({"version": version, "finding_count": len(findings), "findings": findings}, indent=2, ensure_ascii=False))
    return 1 if any(f["level"] == "ERROR" for f in findings) else 0


if __name__ == "__main__":
    raise SystemExit(main())
