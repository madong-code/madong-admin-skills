---
name: frontend-shared
description: 前端共用约定（请求客户端、国际化 i18n、组件适配，admin/web 两套模版通用）
globs:
  - "template/admin/src/api/**/*.ts"
  - "template/web/src/api/**/*.ts"
  - "template/admin/src/locales/**/*.ts"
  - "template/web/src/lang/**/*.ts"
---

# 前端共用约定（admin / web 两套模版通用）

## 请求客户端
- `template/admin`：请求封装在 `src/core/request/`（基于 axios/fetch 的 Vben RequestClient），统一拦截器处理 JWT、错误提示、SSE。
- `template/web`：请求封装在 `src/api/` 或 `composables/useRequest`，基于 `$fetch`（Nuxt 原生）。
- API 响应约定（snake_case）：`{ code, msg, data }`，分页 `{ items, total, page_no, page_size }`。

## API 函数命名与组织
- 文件：`src/api/{module}/{entity}.ts`（admin）/ `src/api/{module}/{entity}.ts`（web）。
- 函数小驼峰：`getMenuList`、`createMenu`、`updateMenu`、`deleteMenu`、`changeMenuStatus`。
- 入参出参类型放 `src/types/` 或同文件：`MenuRecord`、`MenuParam`、`MenuPageResult`。

## 国际化 i18n
- `template/admin`：`src/locales/` 下 JSON（如 `system.menu.name`），菜单/表单 label 引用。
- `template/web`：`src/lang/` 下 Vue I18n 文件（zh/en）。
- key 约定：`{module}.{model}.{field}`，如 `system.menu.name`。
- 新增字段务必补 i18n，避免硬编码中文。

## 组件适配（多 UI 收敛点）
- `template/admin` 的 `src/adapter/` 是 **UI 适配层**（多 UI 可切换的接缝：`component/`、`crud/`、`form.ts`、`vxe-table.ts`）。业务 view 应调 adapter，不要直接裸写 UI 库组件，避免整体替换 UI 时大面积改动。
- 图标：ele 版用 `ant-design:*` 作为图标名前缀（iconify 集合，非组件库），其他 UI 版同理；图标名与组件库解耦。
- 主题 token：ele 用 `useDesignTokens`，antd 用 `useAntdDesignTokens`（已在 `src/core/composables/use-design-tokens.ts`）。
- 公共业务组件放 `src/components`（admin）/ `src/components`（web），大驼峰 `.vue`，目录 kebab-case。
- **关键点**：`template/admin` 可被整体替换为功能等价、UI 不同的模版（靠 `package.json.name` 区分）。业务 view、api 尽量 UI 无关；UI 差异只在 `src/adapter` 与 `src/core/plugins` 收敛。改 admin 代码前务必先判定当前 UI 身份。
