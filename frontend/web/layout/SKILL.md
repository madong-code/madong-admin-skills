---
name: madong-frontend-web-layout
description: Web 前台布局规范（Nuxt 4），布局文件组织与使用
globs:
  - "frontend/web/app/layouts/**/*.vue"
---

## 布局文件

| 布局 | 文件 | 说明 |
|------|------|------|
| default | `layouts/default.vue` | 默认布局（含 header/footer） |
| blank | `layouts/blank.vue` | 空白布局 |
| container | `layouts/container.vue` | 容器布局 |
| member | `layouts/member.vue` | 会员中心布局 |

## 代码模板

```vue
<template>
  <div>
    <Header />
    <slot />
    <Footer />
  </div>
</template>
```

## 关键约定

- Nuxt 自动加载 `layouts/` 目录下的布局文件
- 页面通过 `definePageMeta({ layout: 'name' })` 指定布局
- 默认布局为 `default.vue`
- 布局中可使用 `<slot />` 嵌入页面内容

## 检查清单

- [ ] 布局文件是否放在 layouts/ 目录
- [ ] 页面是否指定了正确的布局
- [ ] 布局中是否包含必要的公共元素
