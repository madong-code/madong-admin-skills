---
name: cross-commit-convention
description: Git 提交信息格式规范（backend 单体仓库：仅 plugin/ 插件内容带插件名 scope 如 feat(cms):，其余提交一律不带 scope；必须 UTF-8 文件提交避免乱码）
globs:
  - "**/commitlint.config.*"
  - "**/.commitlintrc*"
---

# Git 提交信息规范

> 本规范用于约束 AI 助手与人工提交，重点解决三类高频事故：
> 1. **乱码**（AI 用 `-m` 传中文时 PowerShell/GBK 环境下 90% 概率乱码）
> 2. **错误加 scope**（非 plugin 改动一律不带 scope，AI 常误加 `backend` 等）
> 3. **漏加 scope**（`plugin/` 下插件改动必须带插件名 scope）

## 格式

```
<type>: <subject>              # 默认（绝大多数提交）
<type>(<插件名>): <subject>     # 仅当改动位于 plugin/<插件名>/ 内
```

> **backend 为单体仓库**：`app/`、`config/`、`core/`、`resource/`、`tests/`、根文件等常规改动**一律不带 scope**。
> **唯一例外是 `plugin/`**：改动位于 `plugin/<插件名>/` 内时，scope 必须为插件目录名（小写），如 `feat(cms):`、`fix(pay):`。
> 禁止使用 `backend`、`admin`、`docs`、`project` 等仓库/模块级 scope。
> 多个插件各自改动拆成多笔提交，每笔 scope 对应各自插件。

## plugin scope 对照（仅 plugin/ 内改动使用）

| scope | 插件 |
|-------|------|
| `cms` | CMS 内容管理 |
| `codegen` | 代码生成 |
| `demo` | 示例插件 |
| `logviewer` | 日志查看 |
| `pay` | 支付 |
| `portal` | 门户 |
| `roport` | 报表 |
| `workflow` | 工作流 |

> 新增插件时直接使用其目录名作为 scope，无需更新本表（目录名即 scope）。

## type 枚举

| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `refactor` | 重构（不改变外部行为） |
| `style` | UI 样式变更 |
| `perf` | 性能优化 |
| `chore` | 构建/工具/配置变更 |
| `docs` | 文档更新 |
| `test` | 测试相关 |
| `revert` | 回退提交 |
| `types` | 类型定义变更 |
| `release` | 发版 |

## subject 规则

- 使用**简体中文**祈使句，不超过 50 字。
- 清晰描述「做了什么」，不含句号。
- 一次提交只做一类事，跨插件/跨类型改动**拆成多次提交**。

## 示例（正确）

```
feat(cms): 新增内容模型与栏目管理        # plugin/cms/ 内改动
fix(demo): 移除路由模板未使用的导入      # plugin/demo/ 内改动
feat: 新增会员积分管理页面              # app/ 等常规改动，无 scope
fix: 修复租户列表分页错位问题
refactor: 重构菜单服务查询逻辑
chore: 升级 webman 框架到 2.2
docs: 补充 skills 使用说明
revert: 回退菜单 is_tab 字段迁移
```

## 示例（错误）

```
feat: 新增栏目管理           # plugin/cms/ 内改动漏加 scope，应为 feat(cms)
fix(backend): 修复 xxx       # 禁止仓库级 scope
chore(cms): 调整根 composer  # 非 plugin 改动不应带 scope
fix: 修复 method_exists 报错。  # 不应有句号
Feat: 新增功能               # type 必须小写
```

---

## ⚠️ 防乱码铁律（AI 必须执行）

**禁止**使用 `git commit -m "中文"` 传中文 message —— 在 Windows PowerShell（GBK 代码页）下，`-m` 的中文会被错误编码，导致 commit message 在 `git log` 中乱码（实测 90% 概率）。

**必须**用临时文件 + `-F` 方式提交：

```powershell
# 1) 用 write_to_file 工具创建 UTF-8 提交信息文件（不要带 BOM）
#    路径建议放在当前仓库 .git/ 目录下，例如 .git/.msg.txt
#    内容为完整提交信息，例如：
#    fix: 修复 is_tab 迁移文件风格导致安装报 method_exists int 错误

# 2) 提交（用 -F 读取文件，不进终端命令行，避免转码）
git add <具体文件>
git commit -F .git/.msg.txt

# 3) 提交后删除临时文件
```

### 操作要点

- 临时文件用 `write_to_file` 工具生成（工具写入为 UTF-8，无 BOM），**不要**用 `echo`/`Add-Content` 等 shell 命令写中文（仍会乱码）。
- 一次只 `git add` 本次提交相关的文件，**不要** `git add -A` / `git add .`，避免把无关改动（如 CRLF 换行警告、临时调试脚本）混入提交。
- 多笔提交：每笔用独立临时文件，提交后删除，再写下一个。
- 回退提交用 `git reset --soft <目标>`（保留工作区代码），不要用 `git reset --hard`。

### 验证

提交后用 `git --no-pager log --oneline -1` 确认中文正常显示（若仍乱码说明误用了 `-m`，需 `git commit --amend -F 文件` 修正）。

---

## 提交 SOP（AI 执行清单）

1. `git status --short` 看清本次改动文件。
2. `git --no-pager log --oneline -5` 看最近提交风格，避免重复/冲突。
3. 按 scope / type 拆分：不同插件拆多笔，跨类型拆多笔；**plugin 内改动必须带插件名 scope，其余不带**。
4. 每个提交：`write_to_file` 写 UTF-8 临时 message → `git add <文件>` → `git commit -F 文件` → 删除临时文件。
5. `git --no-pager log --oneline -3` 复核中文无乱码、scope 用法正确（仅 plugin 改动带插件名 scope）。
6. **不主动 `git push`**，除非用户明确要求。
