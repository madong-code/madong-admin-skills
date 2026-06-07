---
name: madong-frontend-web-common
description: Web 前台公共规范（Nuxt 4），项目结构、命名约定、工具函数
globs:
  - "frontend/web/**/*.ts"
  - "frontend/web/**/*.vue"
---

## 项目结构

```
frontend/web/
├── app/
│   ├── api/           # API 层
│   ├── components/    # 组件
│   ├── composables/   # 组合式函数
│   ├── layouts/       # 布局
│   ├── middleware/    # 中间件
│   ├── pages/         # 页面
│   ├── plugins/       # 插件
│   ├── stores/        # Pinia 状态
│   ├── types/         # 类型定义
│   └── utils/         # 工具函数
├── public/
├── nuxt.config.ts
└── package.json
```

## 关键约定

- 使用 Nuxt 4 目录约定（`app/` 目录结构）
- Composables 使用 `use` 前缀
- 工具函数放在 `utils/` 下
- 中间件放在 `middleware/` 下

## 检查清单

- [ ] 目录结构是否符合 Nuxt 4 约定
- [ ] composable 命名是否以 use 开头
- [ ] 工具函数是否归类到 utils/
