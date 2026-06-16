#!/usr/bin/env bash
#
# Madong Skills 跨编辑器同步脚本 (macOS / Linux 版)
# 将 SKILL.md 分发到各编辑器格式
#
# 用法:
#   # 同步全部 (CodeBuddy + Cursor + Trae + Copilot)
#   bash madong-skills/sync.sh
#
#   # 只同步指定编辑器 (多个用逗号分隔)
#   bash madong-skills/sync.sh --target codebuddy
#   bash madong-skills/sync.sh --target cursor
#   bash madong-skills/sync.sh --target trae
#   bash madong-skills/sync.sh --target copilot
#   bash madong-skills/sync.sh --target codebuddy,cursor
#
# 可选值: codebuddy, cursor, trae, copilot

set -euo pipefail

# ----- 颜色 -----
if [[ -t 1 ]]; then
    C_GREEN='\033[0;32m'; C_GRAY='\033[0;90m'; C_CYAN='\033[0;36m'; C_YELLOW='\033[0;33m'; C_RESET='\033[0m'
else
    C_GREEN=''; C_GRAY=''; C_CYAN=''; C_YELLOW=''; C_RESET=''
fi

# ----- 路径 -----
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SRC_DIR/.." && pwd)"

# ----- 解析参数 -----
target_arg=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --target|-t)
            target_arg="$2"; shift 2 ;;
        --target=*)
            target_arg="${1#*=}"; shift ;;
        *)
            echo "未知参数: $1" >&2; exit 1 ;;
    esac
done

declare -a TARGETS
if [[ -z "$target_arg" ]]; then
    TARGETS=(codebuddy cursor trae copilot)
    LABEL="all"
else
    IFS=',' read -ra RAW <<< "$target_arg"
    TARGETS=()
    for t in "${RAW[@]}"; do
        t="$(echo "$t" | tr '[:upper:]' '[:lower:]' | xargs)"
        [[ -n "$t" ]] && TARGETS+=("$t")
    done
    LABEL="$(IFS=', '; echo "${TARGETS[*]}")"
fi

has_target() {
    local needle="$1"
    for t in "${TARGETS[@]}"; do
        [[ "$t" == "$needle" ]] && return 0
    done
    return 1
}

# ----- 收集 SKILL.md (排除 node_modules / .git) -----
declare -a SKILLS
while IFS= read -r f; do
    SKILLS+=("$f")
done < <(find "$SRC_DIR" -type f -name 'SKILL.md' \
            -not -path '*/node_modules/*' -not -path '*/.git/*' | sort)

echo -e "${C_GREEN}Found ${#SKILLS[@]} skill files${C_RESET}"
echo -e "${C_GRAY}Targets: $LABEL${C_RESET}"
echo ""

# ----- 辅助: 由 SKILL.md 路径生成技能名称 -----
# backend/gen-crud/SKILL.md -> backend-gen-crud
skill_name() {
    local full="$1"
    local rel="${full#"$SRC_DIR"/}"
    rel="${rel//\//-}"
    rel="${rel%-SKILL.md}"
    echo "$rel"
}

print_summary() {
    printf "${C_CYAN}%-14s: %s (%s %s)${C_RESET}\n" "$1" "$2" "$3" "$4"
}

# ===== 1. CodeBuddy =====
if has_target codebuddy; then
    CB_DIR="$ROOT/.codebuddy/skills"
    for skill in "${SKILLS[@]}"; do
        name="$(skill_name "$skill")"
        mkdir -p "$CB_DIR/$name"
        cp -f "$skill" "$CB_DIR/$name/SKILL.md"
        echo -e "  ${C_CYAN}[CodeBuddy] $name/SKILL.md${C_RESET}"
    done
    echo ""
fi

# ===== 2. Cursor =====
if has_target cursor; then
    CURSOR_DIR="$ROOT/.cursor/rules"
    for skill in "${SKILLS[@]}"; do
        name="$(skill_name "$skill")"
        mkdir -p "$CURSOR_DIR/$name"
        cp -f "$skill" "$CURSOR_DIR/$name/rule.mdc"
        echo -e "  ${C_CYAN}[Cursor] $name/rule.mdc${C_RESET}"
    done
    echo ""
fi

# ===== 3. Trae (Rules + Skills) =====
if has_target trae; then
    # --- Trae Rules: 转换 frontmatter ---
    TRAE_DIR="$ROOT/.trae/rules"
    for skill in "${SKILLS[@]}"; do
        name="$(skill_name "$skill")"
        mkdir -p "$TRAE_DIR/$name"
        dest="$TRAE_DIR/$name/rule.md"
        # 用 awk 解析 frontmatter 并重写为 Trae Rules 格式
        if head -n 1 "$skill" | grep -q '^---'; then
            awk '
                BEGIN { in_fm=0; fm_done=0; desc=""; globs=""; }
                NR==1 && $0 ~ /^---[[:space:]]*$/ { in_fm=1; next }
                in_fm && $0 ~ /^---[[:space:]]*$/ { in_fm=0; fm_done=1; next }
                in_fm {
                    line=$0
                    if (match(line, /^description:[[:space:]]*/)) {
                        desc=substr(line, RLENGTH+1)
                    }
                    if (match(line, /^[[:space:]]+-[[:space:]]+"[^"]*"/)) {
                        s=line
                        sub(/^[[:space:]]+-[[:space:]]+"/, "", s)
                        sub(/".*$/, "", s)
                        if (globs == "") globs=s; else globs=globs ", " s
                    }
                    next
                }
                fm_done { body = body $0 "\n" }
                END {
                    printf "---\n"
                    printf "alwaysApply: false\n"
                    if (desc != "") printf "description: %s\n", desc
                    if (globs != "") printf "globs: \"%s\"\n", globs
                    printf "---\n"
                    printf "%s", body
                }
            ' "$skill" > "$dest"
        else
            cp -f "$skill" "$dest"
        fi
        echo -e "  ${C_CYAN}[Trae Rules] $name/rule.md${C_RESET}"
    done
    # --- Trae Skills: 直接复制 ---
    TRAE_SKILLS_DIR="$ROOT/.agents/skills"
    for skill in "${SKILLS[@]}"; do
        name="$(skill_name "$skill")"
        mkdir -p "$TRAE_SKILLS_DIR/$name"
        cp -f "$skill" "$TRAE_SKILLS_DIR/$name/SKILL.md"
        echo -e "  ${C_CYAN}[Trae Skills] $name/SKILL.md${C_RESET}"
    done
    echo ""
fi

# ===== 4. Copilot: 聚合为单文件 =====
if has_target copilot; then
    COPILOT_DIR="$ROOT/.github"
    mkdir -p "$COPILOT_DIR"
    COPILOT_DEST="$COPILOT_DIR/copilot-instructions.md"
    {
        echo "# Madong Skills Instructions"
        echo ""
        for skill in "${SKILLS[@]}"; do
            rel="${skill#"$SRC_DIR"/}"
            category="${rel%%/*}"
            name="$(skill_name "$skill")"
            skill_short="${name##*-}"
            echo "---"
            echo ""
            echo "## $category / $skill_short"
            # 去掉 frontmatter 后输出正文
            awk '
                BEGIN { in_fm=0; done=0 }
                NR==1 && $0 ~ /^---[[:space:]]*$/ { in_fm=1; next }
                in_fm && $0 ~ /^---[[:space:]]*$/ { in_fm=0; done=1; next }
                in_fm { next }
                { print }
            ' "$skill" | sed -e 's/[[:space:]]*$//'
            echo ""
        done
    } > "$COPILOT_DEST"
    echo -e "  ${C_CYAN}[Copilot] copilot-instructions.md${C_RESET}"
    echo ""
fi

# ===== .gitignore (不存在则生成) =====
GITIGNORE="$SRC_DIR/.gitignore"
if [[ ! -f "$GITIGNORE" ]]; then
    cat > "$GITIGNORE" <<'EOF'
# Auto-generated by sync.sh
.cursor/
.trae/
.agents/
.github/copilot-instructions.md
EOF
fi

# ===== 结果汇总 =====
echo -e "${C_YELLOW}======= Sync Complete =======${C_RESET}"
has_target codebuddy && print_summary 'CodeBuddy'   '.codebuddy/skills/{name}/' "${#SKILLS[@]}" 'SKILL.md'
has_target cursor    && print_summary 'Cursor'      '.cursor/rules/{name}/'     "${#SKILLS[@]}" 'rule.mdc'
has_target trae      && print_summary 'Trae Rules'  '.trae/rules/{name}/'       "${#SKILLS[@]}" 'rule.md'
has_target trae      && print_summary 'Trae Skills' '.agents/skills/{name}/'    "${#SKILLS[@]}" 'SKILL.md'
has_target copilot   && print_summary 'Copilot'     '.github/'                  '1'             'aggregated'
echo -e "${C_YELLOW}=============================${C_RESET}"
