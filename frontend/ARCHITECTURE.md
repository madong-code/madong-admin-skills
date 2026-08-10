---
name: frontend-architecture
description: 前端总体架构原则（一个后端拖多个 UI 前端；template/admin 同一位置可整体换 UI，靠 package.json name 区分）
globs:
  - "template/admin/package.json"
  - "template/web/package.json"
  - "template/install/package.json"
  - "backend/config/route.php"
---

# 前端总体架构（一后端 · 多前端 · 多 UI）

## 核心原则
**一个后端（`backend/`），拖多个前端壳。** 后端是单一数据源与业务逻辑中心；前端只是不同形态/不同 UI 风格的使用界面，全部消费同一套后端 API。

```
                    ┌──────────────────────┐
   backend/  ◄──────┤ template/admin/      │ 主管理后台
   (Webman API)     │  （同一目录位置，     │ 内容可整体替换为另一套 UI
   ← 统一 REST      │   name 决定是哪种 UI）│ 例：vue-vben-admin-ele /
   ← SSE 推送       │                       │     madong-vue / vben-antd
                    ├──────────────────────┤
                    │ template/web/         │ Nuxt 4 + Element Plus 后台（另一独立技术栈）
                    ├──────────────────────┤
                    │ template/install/     │ 安装向导（轻量 Element Plus）
                    └──────────────────────┘
```

## 关键点：template/admin 是「同一位置、可换内容」的 UI 槽位
- `template/admin/` 是**固定目录位置**，但里面**只会存在其中一份 UI 模版的内容**（不是并列子目录）。
- 不同 UI 模版（如 `vue-vben-admin-ele`、来自 gitee `motion-code/madong-vue` 的版本、`vue-vben-admin-antd` 等）功能等价，只是 UI 实现不同；**任意时刻只有一种在生效**。
- 仓库切换/升级 UI 时，是**整体替换 `template/admin/` 的内容**，而不是新增并列目录。
- **用 `package.json` 的 `name` 字段来区分当前是哪一套 UI**——这是最完美的判定方式，无需并列目录、无歧义。

### 如何识别当前 template/admin 用的是什么 UI（必做）
生成/修改 admin 代码前，先读 `template/admin/package.json` 的 `name`：
| name 示例 | 来源 / UI kit |
|-----------|---------------|
| `vue-vben-admin-ele` | Vben 5.7 + **Element Plus**（当前默认） |
| `madong-vue` | gitee `motion-code/madong-vue`（另一套等价 UI 模版，功能相同、UI 不同） |
| `vue-vben-admin-antd` | Vben 5.7 + **Ant Design Vue**（可能的另一种） |

若同一仓库内 `name` 不足以区分（如多个 ele 变体），再用 `.env` 的 `VITE_UI` / `VITE_DESIGN`（`element` / `antd`）辅助判定；或看 `src/adapter/component/index.ts` 的 import 来源（`element-plus` vs `ant-design-vue`）。

> 判定结论决定：组件选型（`<el-table>` vs `<a-table>` vs 该 UI 的表格）、表单 Schema 控件类型、图标库前缀、主题 token。

## 各前端壳职责边界
| 目录 | 是否可换 UI | UI 识别 | 技术栈 | 路由方式 | 用途 |
|------|------------|--------|--------|----------|------|
| `template/admin` | ✅ 内容整体可换 | `package.json.name` | 由 name 决定（Vben+Ele / madong-vue / Vben+Antd） | 由该 UI 决定 | 主管理后台（功能等价，UI 不同） |
| `template/web` | ❌ 固定 | — | Nuxt 4 + Element Plus | `pages/` 约定 | 另一套后台/站点 |
| `template/install` | ❌ 固定 | — | Vue3 + Element Plus | 极简/无 | 安装向导 |

## 对 AI 的硬约束
- **后端不感知前端 UI**：所有 UI 差异在前端消化，后端只产出统一 API（见 `cross-api-convention`）。
- **多 UI 模版之间保持 API 契约一致**：它们调用的是同一后端接口，禁止为某个 UI 改后端契约。
- 修改 `template/admin` 时，**先按 name 判定当前 UI**，再选对应的组件/适配器写法；不要假设永远是 Element Plus。
- 新增/替换 UI 模版（如切到 `madong-vue`）时：整体替换 `template/admin/` 内容，更新 `package.json.name`；业务 view/api 尽量保持一致，UI 差异收敛在 `src/adapter` 与 `src/core/plugins`。

## 相关技能
- `frontend-shared`：跨 shell 的共用约定（API 客户端、i18n、命名）。
- `frontend-admin`：admin 系列（含「按 name 判定 UI」）。
- `frontend/web` / `frontend/install`：其他固定壳。
- `backend-plugin`：插件体系（插件复用主程序分层、命名空间 `plugin\{name}\app`、前端随 resource 部署）。
- `backend-command`：命令脚本（madong-plugin/make/install/config/metadata 系列，含建插件、装系统）。
- `backend-*` / `cross-api-convention`：后端与对接契约。
