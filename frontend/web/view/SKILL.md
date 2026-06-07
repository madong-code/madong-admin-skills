---
name: madong-frontend-web-view
description: Web 前台页面规范（Nuxt 4），页面文件组织与组件使用
globs:
  - "frontend/web/app/pages/**/*.vue"
---

## 文件位置

```
frontend/web/app/pages/{module}/
├── index.vue          # 列表/首页
├── [id].vue           # 详情页
└── create.vue         # 创建页
```

## 技术栈

- Vue 3 + Nuxt 4
- Element Plus
- Pinia
- UnoCSS

## 关键约定

- 页面使用 Nuxt 文件路由（`pages/` 目录自动生成路由）
- 动态路由使用 `[param].vue` 命名
- 布局文件使用 `layouts/` 目录
- 组件使用 `components/` 目录，自动全局注册

## 检查清单

- [ ] 页面文件命名是否符合 Nuxt 文件路由规范
- [ ] 是否使用了正确的布局
- [ ] API 调用是否通过 composable 封装
