---
name: madong-frontend-web-api
description: Web 前台 API 层规范（Nuxt 4），基于 $fetch 或 useFetch
globs:
  - "frontend/web/app/api/**/*.ts"
---

## 文件位置

```
frontend/web/app/api/{module}/index.ts
```

## 代码模板

```typescript
import type { ApiResult } from '~/types/api';

export async function get{Model}List(params?: any): Promise<ApiResult> {
  return $fetch('/api/{module}/{model}', { params });
}

export async function get{Model}Detail(id: number): Promise<ApiResult> {
  return $fetch(`/api/{module}/{model}/${id}`);
}
```

## 关键约定

- 使用 Nuxt `$fetch` 或 `useFetch`，避免使用 axios
- API 路径以 `/api/` 开头
- 响应格式：`{code: 0, msg: 'ok', data: {...}}`
- SSR 场景使用 `useFetch`，CSR 场景使用 `$fetch`

## 检查清单

- [ ] 是否使用 $fetch/useFetch 而非 axios
- [ ] 路径是否以 /api/ 开头
- [ ] SSR 场景是否使用 useFetch
- [ ] 是否处理了请求错误
