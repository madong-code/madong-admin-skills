---
name: frontend-admin
description: Admin 后台模版规范（固定目录位置，内容可整体换为不同 UI 的等价模版，按 package.json name 判定当前 UI）
globs:
  - "template/admin/**/*.vue"
  - "template/admin/**/*.ts"
  - "template/admin/**/*.tsx"
  - "template/admin/package.json"
---

# Admin 后台模版规范

> 架构前提：见 `frontend-architecture`。`template/admin/` 是**固定目录位置**，内容可整体替换为另一套功能等价、UI 不同的模版（如默认 `vue-vben-admin-ele`，或来自 gitee `motion-code/madong-vue` 的版本）。任意时刻只有一种 UI 生效，靠 `package.json.name` 区分。

## §0 先判定：当前 template/admin 用的是什么 UI（必做）
生成/修改 admin 代码前，**先读 `template/admin/package.json` 的 `name`**，否则组件选型会错：

| name 示例 | UI kit / 来源 |
|-----------|---------------|
| `vue-vben-admin-ele` | **Element Plus**（默认，Vben 5.7） |
| `madong-vue` | gitee `motion-code/madong-vue`（功能等价、UI 不同的另一套） |
| `vue-vben-admin-antd` | **Ant Design Vue**（可能的另一种） |

若 `name` 不足以区分（如同 UI 多变体），再用 `.env*` 的 `VITE_UI`/`VITE_DESIGN`（`element`/`antd`）或看 `src/adapter/component/index.ts` import 来源辅助判定。

判定结果驱动：表格（`<el-table>` vs 该 UI 表格）、表单控件、图标前缀、主题 token。

## §1 技术栈（ele 实例）
Vue 3 + Vite 8 + TypeScript + **Element Plus** + Pinia + Vue Router + Tailwind CSS 4 + VXE Table + Vitest，基于 Vben `v5.7.0`。

## §2 目录边界（重要）
`template/admin/src/`：
- `core/`：**Vben 内核，勿改**（除非改框架本身）。业务不要反向依赖时破坏边界。
- `adapter/`：**UI 适配层**——多 UI 可切换的接缝（`component/`、`crud/`、`form.ts`、`vxe-table.ts`）。新增 UI 模版时在此加对应适配，业务 view 尽量调 adapter 而非直接调 UI 库。
- `api/`、`views/`、`components/`、`router/`、`store/`、`enums/`、`types/`、`utils/`、`layouts/`、`locales/`、`lang/`、`plugin/`（插件业务）。
- 依赖方向：`应用层` 可依赖 `src/core`；`src/core` 不得反向依赖 `src/api`、`src/components`、`src/views`。
- 别名：运行时不使用 `@/`、`@vben/*`，用 `#/*` → `src/*`。

## §3 页面（views）规范
- CRUD 用 `useCrud`（来自 `src/adapter` 或 `src/core`）+ `FormDialog` 弹窗，UI 无关。
- 列表用 Vben 的 `VxeTable`/`BaseTable`；表单用 Schema 表单。
- 文件 kebab-case：`system/menu/index.vue`、`system/menu/menu-modal.vue`。
- 路由 code 与后端对齐：`{App}{Module}{Action}`（如 `SystemMenuList`）；权限码 `system:menu:list`。

## §4 切换 / 替换 UI 模版（给 AI 的指引）
当把 `template/admin` 整体换成另一套 UI（如从 `vue-vben-admin-ele` 切到 `madong-vue`）时：
- **整体替换 `template/admin/` 内容**（来自对应仓库，如 gitee `motion-code/madong-vue`），并写入正确的 `package.json.name`。
- 业务 `views/`、`api/` **尽量保持一致**（同一后端契约），仅 `adapter/`、`core/plugins/` 做 UI 差异。
- 不要为某个 UI 去改后端接口；若某 UI 需要字段而其他不需要，用前端可选字段处理。
- 替换后重新 `pnpm install` 并按该 UI 的 dev/build 命令运行。

## §5 启动/构建
- 要求 Node 22.18+/24+，pnpm 10+。
- `pnpm dev`（默认 5777 端口，含 Nitro Mock，账号 `vben/123456`）。
- `pnpm typecheck` / `pnpm lint` / `pnpm build`（输出 `dist/` + `dist.zip`）。
- 受保护不可改：`frontend/packages`、`frontend/scripts`、`frontend/internal` 及依赖定义；业务改 `src/views`、`src/api`。

## 已知 admin 实例
见同目录 `INSTANCES.md`（列出当前仓库各 admin 模版的 name、UI、目录）。
