---
name: madong-frontend-admin-api
description: Admin 前端 API 层规范，基于 requestClient 的 API 调用模式
globs:
  - "frontend/admin/src/api/**/*.ts"
  - "apps/**/src/api/**/*.ts"
---

## 文件位置

```
frontend/admin/src/api/{module}/index.ts
```

## 代码模板

```typescript
import { requestClient } from '#/api/request';

/** 获取列表 */
export function get{Model}List(params?: any) {
  return requestClient.get('/{module}/{model}', { params });
}

/** 创建 */
export function create{Model}(data: any) {
  return requestClient.post('/{module}/{model}', data);
}

/** 更新 */
export function update{Model}(id: number, data: any) {
  return requestClient.put(`/{module}/{model}/${id}`, data);
}

/** 删除 */
export function delete{Model}(id: number) {
  return requestClient.delete(`/{module}/${model}/${id}`);
}
```

## 关键约定

- API 函数命名：`动词{Model}`（getList/create/update/delete）
- CRUD 路径：`/{module}/{model}`
- 响应格式：`{code: 0, msg: 'ok', data: {...}}`
- 列表返回：`{items: [], total: N}`

## 检查清单

- [ ] 函数命名是否小驼峰
- [ ] 路径是否与后端路由一致
- [ ] 参数类型是否正确
- [ ] 是否处理了异常情况
