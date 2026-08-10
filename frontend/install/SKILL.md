---
name: frontend-install
description: 安装向导前端规范（轻量 Element Plus 应用，template/install）
globs:
  - "template/install/src/**/*.vue"
  - "template/install/src/**/*.ts"
---

# 安装向导（Install）前端规范

## 定位
- 目录：`template/install/`，独立于 admin/web 的轻量前端应用，用于系统首次部署的安装向导。
- 技术栈：Vue 3 + Element Plus + Pinia（直接 `createApp` 挂载，无 Vben 内核 / 无 Nuxt）。

## 约定
- `src/api/`：axios 请求客户端（连接后端 `app/install/` 应用接口）。
- `src/components/`：安装步骤组件（典型 6 步骤：环境检测 → 数据库 → 管理员 → 完成等）。
- `src/store/`：安装状态（选项式 API + SSE 进度可选）。
- 启动：`createApp(App).use(ElementPlus).mount('#app')`，无路由框架或极简路由。

## 写法要点
- 保持轻量，不要引入 admin 的 Vben 体系或 web 的 Nuxt 机制。
- 步骤状态用 Pinia store 或简单的 reactive 管理。
- 请求后端安装接口走 `app/install/controller/`，权限码/路由与后台一致约定。
