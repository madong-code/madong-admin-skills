---
name: frontend-web
description: Web(Nuxt) 后台模版规范（Nuxt 4 + Element Plus，pages/ 约定路由，与 admin 不同技术栈）
globs:
  - "template/web/src/**/*.vue"
  - "template/web/src/**/*.ts"
  - "template/web/**/*.ts"
---

# Web 后台模版（Madong-Nuxt）规范

## 技术栈
**Nuxt 4** + TypeScript + Vite + **Element Plus** + Pinia + Vue I18n + SCSS + UnoCSS。是项目**第二套**后台管理模版，与 `template/admin` 技术栈完全不同。

## 目录结构（template/web/src 或 Nuxt app/）
- `pages/`：页面，**约定式路由**（`pages/system/menu.vue` → `/system/menu`），与 admin 的手动 router 配置不同。
- `components/`：Vue 组件（Nuxt 自动导入，无需 import）。
- `composables/`：组合式函数（`useXxx`，自动导入）。
- `api/`：接口定义（基于 `$fetch`）。
- `stores/`：Pinia 状态。
- `lang/`：Vue I18n 国际化文件。
- `layouts/`：布局组件。
- `plugins/`：Nuxt 插件（Element Plus 注册等）。

## 约定
- 请求用 Nuxt 的 `$fetch`（或封装 `composables/useRequest`），服务端/客户端通用。
- 状态用 Pinia（`stores/`），组合式 `useXxxStore`。
- 组件名大驼峰 `.vue`；页面文件按路由 kebab-case。
- 权限码、API 函数命名与 `frontend-shared` 一致（snake_case 响应、`{module}:{model}:{action}` 权限码）。

## 与 admin 的差异（生成代码时务必区分）
| 维度 | admin (Vben) | web (Nuxt) |
|------|--------------|------------|
| 路由 | `src/router/` 手动配置 | `pages/` 约定式 |
| 请求 | `src/core/request` axios | `$fetch` |
| 组件导入 | 显式 import / `#/` 别名 | Nuxt 自动导入 |
| 状态 | Pinia `src/store` | Pinia `stores/` |
| UI | Element Plus + Vben adapter | Element Plus 原生 |

## 示例（Nuxt 页面）
```vue
<script setup lang="ts">
const { data: list } = await useFetch('/api/system/menu/list');
</script>
<template>
  <el-table :data="list">
    <el-table-column prop="name" label="名称" />
  </el-table>
</template>
```
