#!/usr/bin/env bash
#============================================================
# Madong SaaS Skills 跨编辑器同步脚本（MDAdmin 标准版）
# 将 skills/ 下所有 SKILL.md 分发到各 AI 编辑器格式。
#
# 用法：
#   ./skills/sync.sh                # 同步全部（默认）
#   ./skills/sync.sh codebuddy      # 只同步 CodeBuddy
#   ./skills/sync.sh trae           # 只同步 Trae（Skills + Rules）
#   ./skills/sync.sh claude windsurf cline roo gemini qwen
#   ./skills/sync.sh codebuddy cursor
#============================================================
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SRC_DIR")"

# 目标解析
if [ $# -eq 0 ]; then
  TARGETS=("codebuddy" "cursor" "trae" "copilot" "claude" "windsurf" "cline" "roo" "gemini" "qwen")
  LABEL="all"
else
  TARGETS=("$@")
  LABEL="$*"
fi

# 收集所有 SKILL.md（排除 node_modules / .git）
mapfile -t SKILLS < <(find "$SRC_DIR" -type f -name 'SKILL.md' \
  | grep -vE 'node_modules|/\.git' | sort)

TOTAL=${#SKILLS[@]}
echo -e "\033[0;32mFound $TOTAL skill files\033[0m"
echo -e "\033[0;90mTargets: $LABEL\033[0m"
echo

skill_name() {
  local f="$1"
  local rel="${f#$SRC_DIR/}"
  rel="${rel//\\//}"
  rel="${rel%-SKILL.md}"
  echo "${rel//\//-}"
}

# 检查目标
has() { printf '%s\n' "${TARGETS[@]}" | grep -qx "$1"; }

# 将 SKILL.md 转换为规则文件（重写 frontmatter：windsurf/cline/roo）
rule_file() {
  local src="$1" fmt="$2" out="$3"
  local desc globs_raw
  desc="$(grep -m1 '^description:' "$src" | sed 's/^description:[[:space:]]*//')"
  globs_raw="$(grep -E '^[[:space:]]+- "' "$src" | sed -E 's/^[[:space:]]+- "(.*)"/\1/' | paste -sd ', ' -)"
  {
    echo "---"
    if [ "$fmt" = "windsurf" ]; then
      echo "alwaysApply: false"
    fi
    [ -n "$desc" ] && echo "description: $desc"
    [ -n "$globs_raw" ] && echo "globs: \"$globs_raw\""
    echo "---"
    awk 'BEGIN{p=0} /^---\r?$/{if(++c==2){p=1;next}} p' "$src"
  } > "$out"
}

# 聚合所有 skill 生成单一指令文件（Copilot / Gemini / Qwen）
aggregate_skills() {
  local out="$1" label="$2" display="$3"
  {
    echo "# Madong SaaS Project Instructions"
    echo
    echo "Project-wide coding rules and conventions for the Madong SaaS (MDAdmin standard) project."
    echo
    for s in "${SKILLS[@]}"; do
      rel="${s#$SRC_DIR/}"
      category="$(echo "$rel" | cut -d/ -f1)"
      skillname="$(skill_name "$s" | awk -F- '{print $NF}')"
      echo "---"
      echo
      echo "## $category / $skillname"
      echo
      awk 'BEGIN{p=0} /^---\r?$/{if(++c==2){p=1;next}} p' "$s"
      echo
    done
  } > "$out"
  echo -e "  \033[0;36m[$label]\033[0m $display"
  echo
}

#============================================================
# 1. CodeBuddy
#============================================================
if has codebuddy; then
  CB_DIR="$ROOT_DIR/.codebuddy/skills"
  mkdir -p "$CB_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    mkdir -p "$CB_DIR/$name"
    cp "$s" "$CB_DIR/$name/SKILL.md"
    echo -e "  \033[0;36m[CodeBuddy]\033[0m $name/SKILL.md"
  done
  echo
fi

#============================================================
# 2. Cursor
#============================================================
if has cursor; then
  CUR_DIR="$ROOT_DIR/.cursor/rules"
  mkdir -p "$CUR_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    mkdir -p "$CUR_DIR/$name"
    cp "$s" "$CUR_DIR/$name/rule.mdc"
    echo -e "  \033[0;36m[Cursor]\033[0m $name/rule.mdc"
  done
  echo
fi

#============================================================
# 3. Trae (Rules + Skills)
#============================================================
if has trae; then
  TRAE_RULES="$ROOT_DIR/.trae/rules"
  TRAE_SKILLS="$ROOT_DIR/.agents/skills"
  mkdir -p "$TRAE_RULES" "$TRAE_SKILLS"

  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"

    # 3a Rules
    mkdir -p "$TRAE_RULES/$name"
    desc="$(grep -m1 '^description:' "$s" | sed 's/^description:[[:space:]]*//')"
    globs_raw="$(grep -E '^\s+- "' "$s" | sed -E 's/^\s+- "(.*)"/\1/' | paste -sd ', ' -)"
    {
      echo "---"
      echo "alwaysApply: false"
      [ -n "$desc" ] && echo "description: $desc"
      [ -n "$globs_raw" ] && echo "globs: \"$globs_raw\""
      echo "---"
      tail -n +1 "$s" | awk 'BEGIN{p=0} /^---\r?$/{if(++c==2){p=1;next}} p'
    } > "$TRAE_RULES/$name/rule.md"
    echo -e "  \033[0;36m[Trae Rules]\033[0m $name/rule.md"

    # 3b Skills
    mkdir -p "$TRAE_SKILLS/$name"
    cp "$s" "$TRAE_SKILLS/$name/SKILL.md"
    echo -e "  \033[0;36m[Trae Skills]\033[0m $name/SKILL.md"
  done
  echo
fi

#============================================================
# 4. Copilot
#============================================================
if has copilot; then
  GH_DIR="$ROOT_DIR/.github"
  mkdir -p "$GH_DIR"
  aggregate_skills "$GH_DIR/copilot-instructions.md" "Copilot" ".github/copilot-instructions.md"
fi

#============================================================
# 5. Claude Code (Agent Skills)
#============================================================
if has claude; then
  CLAUDE_DIR="$ROOT_DIR/.claude/skills"
  mkdir -p "$CLAUDE_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    mkdir -p "$CLAUDE_DIR/$name"
    cp "$s" "$CLAUDE_DIR/$name/SKILL.md"
    echo -e "  \033[0;36m[Claude]\033[0m $name/SKILL.md"
  done
  echo
fi

#============================================================
# 6. Windsurf
#============================================================
if has windsurf; then
  WS_DIR="$ROOT_DIR/.windsurf/rules"
  mkdir -p "$WS_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    mkdir -p "$WS_DIR/$name"
    rule_file "$s" windsurf "$WS_DIR/$name/rule.md"
    echo -e "  \033[0;36m[Windsurf]\033[0m $name/rule.md"
  done
  echo
fi

#============================================================
# 7. Cline
#============================================================
if has cline; then
  CLINE_DIR="$ROOT_DIR/.clinerules"
  mkdir -p "$CLINE_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    rule_file "$s" cline "$CLINE_DIR/$name.md"
    echo -e "  \033[0;36m[Cline]\033[0m $name.md"
  done
  echo
fi

#============================================================
# 8. Roo Code
#============================================================
if has roo; then
  ROO_DIR="$ROOT_DIR/.roo/rules"
  mkdir -p "$ROO_DIR"
  for s in "${SKILLS[@]}"; do
    name="$(skill_name "$s")"
    rule_file "$s" roo "$ROO_DIR/$name.md"
    echo -e "  \033[0;36m[Roo]\033[0m $name.md"
  done
  echo
fi

#============================================================
# 9. Gemini CLI
#============================================================
if has gemini; then
  aggregate_skills "$ROOT_DIR/GEMINI.md" "Gemini" "GEMINI.md"
fi

#============================================================
# 10. Qwen Code
#============================================================
if has qwen; then
  aggregate_skills "$ROOT_DIR/QCLAUDE.md" "Qwen" "QCLAUDE.md"
fi

#============================================================
# .gitignore
#============================================================
GI="$SRC_DIR/.gitignore"
IGNORE_TEMPLATE=$(cat <<'EOF'
# Editor rule directories auto-generated by sync scripts
.codebuddy/skills/
.cursor/
.trae/
.agents/
.github/copilot-instructions.md
.claude/skills/
.windsurf/rules/
.clinerules/
.roo/rules/
GEMINI.md
QCLAUDE.md
EOF
)
if [ ! -f "$GI" ]; then
  printf '%s\n' "$IGNORE_TEMPLATE" > "$GI"
else
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    tr -d '\r' < "$GI" | grep -qxF "$line" || echo "$line" >> "$GI"
  done <<< "$IGNORE_TEMPLATE"
fi

echo -e "\033[0;33m======= Sync Complete =======\033[0m"
[ -n "${TARGETS[*]}" ]
for t in "${TARGETS[@]}"; do
  case "$t" in
    codebuddy) echo -e "CodeBuddy  : .codebuddy/skills/{name}/SKILL.md x$TOTAL";;
    cursor)    echo -e "Cursor     : .cursor/rules/{name}/rule.mdc x$TOTAL";;
    trae)      echo -e "Trae Rules : .trae/rules/{name}/rule.md x$TOTAL";;
    trae)      echo -e "Trae Skills: .agents/skills/{name}/SKILL.md x$TOTAL";;
    copilot)   echo -e "Copilot    : .github/copilot-instructions.md (aggregated)";;
    claude)    echo -e "Claude     : .claude/skills/{name}/SKILL.md x$TOTAL";;
    windsurf)  echo -e "Windsurf   : .windsurf/rules/{name}/rule.md x$TOTAL";;
    cline)     echo -e "Cline      : .clinerules/{name}.md x$TOTAL";;
    roo)       echo -e "Roo        : .roo/rules/{name}.md x$TOTAL";;
    gemini)    echo -e "Gemini     : GEMINI.md (aggregated)";;
    qwen)      echo -e "Qwen       : QCLAUDE.md (aggregated)";;
  esac
done
echo -e "\033[0;33m==========================\033[0m"
