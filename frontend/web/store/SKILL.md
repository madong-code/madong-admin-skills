---
name: madong-frontend-web-store
description: Web 前台状态管理规范（Nuxt 4），基于 Pinia
globs:
  - "frontend/web/app/stores/**/*.ts"
---

## 代码模板

```typescript
import { defineStore } from 'pinia';

export const use{Model}Store = defineStore('{model}', () => {
  const list = ref<any[]>([]);
  const total = ref(0);

  async function fetchList(params?: any) {
    const res = await get{Model}List(params);
    list.value = res.data.items;
    total.value = res.data.total;
  }

  return { list, total, fetchList };
});
```

## 关键约定

- 使用 Pinia `setup store` 语法（Composition API）
- Store 命名：`use{Name}Store`
- Store ID：`kebab-case`
- Nuxt 项目中 store 支持 SSR

## 检查清单

- [ ] 是否使用 setup store 语法
- [ ] Store 名称是否唯一
- [ ] SSR 场景是否正确处理 hydration
