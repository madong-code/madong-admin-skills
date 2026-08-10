---
name: cross-git-convention
description: Git 提交流程规范（lefthook + commitlint + czg 工具链，分支命名）
globs:
  - "**/lefthook.yml"
  - "**/commitlint.config.*"
  - "**/.commitlintrc*"
---

# Git 提交规范（工具链）

## 工具链
- `lefthook`：git hooks 管理（pre-commit / commit-msg / post-merge）。
  - 前端 `template/admin/lefthook.yml`：`pre-commit` 跑 `pnpm lint` + `pnpm check:type`；`commit-msg` 跑 `commitlint`；`post-merge` 跑 `pnpm install`。
- `commitlint`：校验提交信息格式，配置来自 `@vben/commitlint-config`（admin）或项目 `commitlint.config.*`。
- `czg` / `commitizen`：交互式生成符合规范的提交信息（可选）。

## 提交信息格式
```
<type>(<scope>): <subject>
```
type 枚举见 `cross-commit-convention`，scope 用法见同技能。

## 分支命名建议
- `feat/xxx`、`fix/xxx`、`refactor/xxx`、`chore/xxx`、`release/x.y.z`
- 多人协作可加作者前缀：`feat/mr-april/xxx`。

## 要点
- 禁止 `--no-verify` 跳过 hooks。
- 一次提交只做一件事，subject 简明（中文或英文均可，团队统一）。
- 提交前确保 lint + typecheck 通过（pre-commit 已拦截）。
