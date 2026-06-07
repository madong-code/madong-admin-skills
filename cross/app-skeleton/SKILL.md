---
name: madong-cross-app-skeleton
description: 站点脚手架规范，项目结构/目录组织/模块划分
globs:
  - "**/*.php"
  - "**/*.ts"
---

## 项目结构

```
madong/
├── backend/              # PHP Webman 后端
│   ├── app/              # 应用代码
│   │   ├── adminapi/     # 管理后台 API
│   │   ├── api/          # 前台 API
│   │   ├── model/        # 模型
│   │   ├── dao/          # 数据访问
│   │   ├── service/      # 服务层
│   │   ├── enum/         # 枚举
│   │   └── command/      # 命令
│   ├── core/             # 核心基础设施
│   ├── config/           # 配置
│   ├── plugin/           # 插件
│   └── packages/         # 本地包
├── frontend/
│   ├── admin/            # 管理后台 (Vue 3 + Element Plus)
│   └── web/              # 前台网站 (Nuxt 4)
└── doc/                  # 文档
```

## 模块分层

| 层级 | 目录 | 依赖 |
|------|------|------|
| Controller | `{app}/controller/` | Service |
| Validate | `{app}/validate/` | - |
| Service | `{app}/service/` | DAO |
| DAO | `{app}/dao/` | Model |
| Model | `{app}/model/` | - |
| Schema | `{app}/schema/` | - |

## 检查清单

- [ ] 目录结构是否符合项目规范
- [ ] 模块分层是否正确
- [ ] 依赖方向是否单向（Controller→Service→DAO→Model）
