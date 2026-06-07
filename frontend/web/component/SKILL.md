---
name: madong-frontend-web-component
description: Web 前台组件规范（Nuxt 4），Element Plus 组件使用与封装
globs:
  - "frontend/web/app/components/**/*.vue"
---

## 组件分类

| 分类 | 说明 |
|------|------|
| advertisement/ | 广告组件 |
| icon/ | 图标组件 |
| login-dialog/ | 登录弹窗 |
| search-box/ | 搜索组件 |
| seo/ | SEO 组件 |
| sms-code/ | 短信验证码 |

## 关键约定

- Nuxt auto-imports `components/` 下的所有组件
- 组件名与文件名一致（PascalCase）
- 公共组件放在 `components/`，页面私有组件放在 `components/{page}/`
- 使用 Element Plus 组件时直接使用 `<el-*>` 标签

## 检查清单

- [ ] 组件名是否 PascalCase
- [ ] 是否利用 Nuxt auto-import
- [ ] 是否使用 Composition API
- [ ] Props 是否有默认值
