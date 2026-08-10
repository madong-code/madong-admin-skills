---
name: cross-commit-convention
description: 多仓库/多模块提交信息格式规范（backend/admin/web/install 的 scope 写法）
globs:
  - "**/commitlint.config.*"
  - "**/.commitlintrc*"
---

# 提交信息格式（scope 用法）

## 格式
```
<type>(<scope>): <subject>
```

## type 枚举
| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `refactor` | 重构 |
| `style` | UI 样式变更 |
| `perf` | 性能优化 |
| `chore` | 构建/工具/配置变更 |
| `docs` | 文档更新 |
| `test` | 测试相关 |
| `revert` | 回退 |
| `types` | 类型定义变更 |
| `release` | 发版 |

## scope 按模块区分
本仓库是「后端 + 两套前端 + 安装」的多模块单体仓库，scope 用模块名：

| scope | 对应范围 |
|-------|---------|
| `backend` | `backend/` 后端 PHP |
| `admin` | `template/admin/` Vben 后台 |
| `web` | `template/web/` Nuxt 后台 |
| `install` | `template/install/` 安装向导 |
| `project` | 仓库级（根 README、skills、CI） |
| `lint` | Lint / 格式化配置 |
| `ci` | CI 配置 |
| `deploy` | 部署相关 |
| `other` | 其他 |

## 示例
```
feat(admin): 新增会员积分管理页面
fix(web): 修复租户列表分页问题
refactor(backend): 重构菜单服务的查询逻辑
chore(backend): 升级 webman 框架到 2.2
docs(project): 补充 skills 使用说明
```

## 注意
- 单仓库多模块，提交时 scope 标到具体模块，便于生成 CHANGELOG 与代码评审。
- 跨模块改动（如同时改后端接口 + 前端页面）可拆两次提交，或用一个最相关的 scope + 在 subject 说明。
