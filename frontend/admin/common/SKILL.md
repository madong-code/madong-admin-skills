---
name: madong-frontend-admin-common
description: Admin 前端公共规范，Monorepo 结构、目录组织、命名约定
globs:
  - "frontend/admin/**/*.ts"
  - "frontend/admin/**/*.vue"
---

## Monorepo 结构

```
frontend/admin/
├── src/
│   ├── api/          # API 层
│   ├── components/   # 公共组件
│   ├── hooks/        # 组合式函数
│   ├── store/        # Pinia 状态
│   ├── router/       # 路由
│   ├── views/        # 页面
│   ├── utils/        # 工具
│   ├── types/        # 类型定义
│   ├── styles/       # 样式
│   └── lang/         # 国际化
├── apps/             # 子应用
├── public/
└── vite.config.ts
```

## 命名约定

| 场景 | 规范 | 示例 |
|------|------|------|
| 目录名 | kebab-case | `system/menu/` |
| Vue 组件 | PascalCase | `MenuModal.vue` |
| TS 文件 | kebab-case | `use-crud.ts` |
| API 函数 | camelCase | `getMenuList()` |
| 接口类型 | PascalCase | `MenuRecord` |

## 检查清单

- [ ] 目录名是否 kebab-case
- [ ] 文件名是否 kebab-case
- [ ] 组件名是否 PascalCase
- [ ] API 函数是否 camelCase
