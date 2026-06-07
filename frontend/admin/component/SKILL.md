---
name: madong-frontend-admin-component
description: Admin 前端公共组件规范，基于 Element Plus 组件封装
globs:
  - "frontend/admin/src/components/**/*.vue"
---

## 组件分类

| 分类 | 说明 | 示例 |
|------|------|------|
| core/ | 核心组件 | Page, SearchBar, TableAction |
| crud/ | CRUD 组件 | FormDialog, CrudSchema |
| form/ | 表单组件 | FormDialog, FormItem |
| dialog/ | 弹窗组件 | DialogModal |
| view/ | 视图组件 | ViewComponent 注册表 |
| business/ | 业务组件 | MemberSelect, UploadImage |
| terminal/ | 终端组件 | TerminalMain |

## 关键约定

- 组件使用 `defineOptions({ name: '...' })` 命名
- Props 使用 TypeScript 类型定义
- 组件名使用 PascalCase
- 公共组件通过 `components/` 按目录分类

## 检查清单

- [ ] 组件名是否 PascalCase
- [ ] Props 是否有类型声明
- [ ] 组件是否有默认导出
- [ ] 是否使用 Vue 3 Composition API
