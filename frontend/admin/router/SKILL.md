---
name: madong-frontend-admin-router
description: Admin 前端路由规范，基于 Vue Router
globs:
  - "frontend/admin/src/router/**/*.ts"
---

## 路由结构

```typescript
import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/{module}',
    component: () => import('#/layouts/DefaultLayout.vue'),
    children: [
      {
        path: '{model}',
        name: '{App}{Model}List',
        component: () => import('#/views/{module}/{model}/index.vue'),
        meta: { title: '{title}', permission: '{module}:{model}:list' },
      },
    ],
  },
];
```

## 关键约定

- 路由 name：`{App}{Model}List`（PascalCase）
- 路由 path：`/{module}/{model}`（kebab-case）
- 所有页面使用懒加载（dynamic import）
- 权限通过 `meta.permission` 配置

## 检查清单

- [ ] 路由 name 是否 PascalCase
- [ ] 是否使用懒加载
- [ ] 权限配置是否正确
- [ ] 父子路由嵌套是否合理
