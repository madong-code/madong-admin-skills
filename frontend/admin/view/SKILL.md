---
name: madong-frontend-admin-view
description: Admin 前端视图层规范，Vue 3 + Element Plus + VxeTable 页面模板
globs:
  - "frontend/admin/src/views/**/*.vue"
  - "apps/**/src/views/**/*.vue"
---

## 文件位置

```
frontend/admin/src/views/{module}/{name}/
├── index.vue            # 列表页面
└── schemas/index.tsx    # CRUD Schema 定义
```

## 技术栈

- Vue 3 + TypeScript + Vite
- Element Plus（UI 组件库）
- VxeTable（表格组件）
- Pinia（状态管理）
- Tailwind CSS（样式）

## 关键约定

- 每个页面使用 `defineOptions({ name: '{App}{Model}List' })` 设置组件名
- CRUD 页面使用 FormDialog + VxeTable 组合
- 查询条件使用 Element Plus 表单组件
- 列表使用 VxeTable 组件
- 表单使用 FormDialog 组件（el-form + el-form-item）

## 检查清单

- [ ] 组件名是否按规范命名
- [ ] API 导入路径是否正确
- [ ] 表单校验规则是否完整
- [ ] 列表列配置是否包含操作列
- [ ] 国际化 key 是否配置
