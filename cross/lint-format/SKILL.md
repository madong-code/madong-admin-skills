---
name: cross-lint-format
description: Lint/Format 规范（admin: oxlint+eslint+stylelint+oxfmt；web/install 对应配置）
globs:
  - "template/admin/eslint.config.mjs"
  - "template/admin/oxlint.config.ts"
  - "template/admin/stylelint.config.mjs"
  - "template/admin/oxfmt.config.ts"
  - "template/web/eslint.config.mjs"
---

# Lint / Format 规范

## Admin 前端（template/admin）
- `oxlint.config.ts`：JS/TS 快速 lint（Vben 默认 oxlint）。
- `eslint.config.mjs`：ESLint 兜底规则。
- `stylelint.config.mjs`：CSS/SCSS 样式规范。
- `oxfmt.config.ts`：代码格式化（oxfmt）。
- 命令：`pnpm lint`、`pnpm format`、`pnpm check:type`、`pnpm lint:style`。
- 提交前 lefthook 已自动跑 `pnpm lint` + `pnpm check:type`。

## Web 前端（template/web）
- `eslint.config.mjs`：Nuxt 默认 ESLint 规则。
- 用 `pnpm lint` / `pnpm typecheck` 保证一致性。

## 通用约定
- 缩进：TypeScript/Vue 用 2 空格；PHP 遵循 PSR-12（4 空格）。
- 字符串：前端用单引号；PHP 双引号或单引号按 PSR。
- 禁止 `any`（TS）；前端组件 `defineOptions({ name })` 显式命名。
- 行尾 LF、UTF-8、末尾换行。
- 不要手动改 `frontend/packages`、`frontend/scripts`、`frontend/internal` 等受保护工程配置；业务代码改 `src/`。
