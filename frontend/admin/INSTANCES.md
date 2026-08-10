---
name: frontend-admin-instances
description: template/admin 可能的 UI 身份清单（互斥，靠 package.json name 区分；同一位置只生效其一）
globs:
  - "template/admin/package.json"
---

# template/admin 的可能 UI 身份（互斥）

> `template/admin/` 是固定目录位置，内容可整体替换为功能等价、UI 不同的模版。**任意时刻只有一种 UI 生效**，靠 `package.json.name` 区分。本文件列出所有可能的 UI 身份，供 AI 判定当前生效的是哪一个。

## 已知 UI 身份

| package.json name | UI Kit / 来源 | 状态 | 备注 |
|-------------------|---------------|------|------|
| `vue-vben-admin-ele` | **Element Plus**（Vben 5.7） | ✅ 当前默认 | 适配层 `src/adapter/component/index.ts` 引 `element-plus`；visual-form 插件 `virtual:visual-form-element-plus` |
| `madong-vue` | gitee `motion-code/madong-vue` | 🔄 可整体替换 | 功能等价、UI 不同的另一套 admin 模版；替换时整体覆盖 `template/admin/` 并改 `name` |
| `vue-vben-admin-antd` | **Ant Design Vue**（Vben 5.7） | 🔜 可能 | 若采用，需替换适配层与 `src/core/plugins` UI 适配 |

## 识别步骤（生成/改代码前必做）
1. 读 `template/admin/package.json` 的 `name` → 命中上表即确定 UI。
2. 若 `name` 模糊，读 `.env*` 的 `VITE_UI`/`VITE_DESIGN`（`element`/`antd`）。
3. 再看 `src/adapter/component/index.ts` import 来源（`element-plus` vs `ant-design-vue`）。

## 约定
- 后端契约对所有 UI 身份一致，禁止为某身份改动后端接口。
- 跨 UI 通用逻辑放 `src/adapter` 抽象，UI 差异收敛在 adapter/plugins。
- 切换 UI：整体替换 `template/admin/` 内容 + 更新 `package.json.name`，重新 `pnpm install`。
