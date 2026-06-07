---
name: madong-frontend-admin-store
description: Admin 前端状态管理规范，基于 Pinia
globs:
  - "frontend/admin/src/store/**/*.ts"
  - "apps/**/src/stores/**/*.ts"
---

## 代码模板

```typescript
import { defineStore } from 'pinia';

interface {Model}State {
  list: any[];
  total: number;
}

export const use{Model}Store = defineStore('{module}-{model}', {
  state: (): {Model}State => ({
    list: [],
    total: 0,
  }),
  actions: {
    async fetchList(params?: any) {
      const res = await get{Model}List(params);
      this.list = res.data.items;
      this.total = res.data.total;
    },
  },
});
```

## 关键约定

- Store 命名：`use{Name}Store`
- Store ID：`kebab-case`
- State 使用类型定义
- Actions 使用 async/await

## 检查清单

- [ ] Store 名称是否唯一
- [ ] State 是否有类型定义
- [ ] Actions 是否有错误处理
