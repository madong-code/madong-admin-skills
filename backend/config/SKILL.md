---
name: backend-config
description: 后端配置体系规范（config/ 与 core.{group}.* 命名空间，PSR 加载）
globs:
  - "backend/config/**/*.php"
  - "backend/core/**/config/**/*.php"
---

# 后端配置体系规范

## 业务配置（backend/config/）
- 应用级配置放在 `backend/config/*.php`，通过 `config('key')` 读取。
- 路由、中间件、数据库、redis、静态文件等在对应 `config/*.php` 中定义。

## 内核配置（core/ 分组）
- `core/` 下每个一级分组（foundation/infrastructure/security/communication/io/business）有独立 `config/app.php` 控制 `enable`。
- 启用后配置以命名空间 `core.{group}.{module}.{key}` 加载，例：
  - `config('core.security.jwt.token_name')`
  - `config('core.io.snowflake.node_id')`
  - `config('core.infrastructure.logger.base.path')`
- 新增 core 模块：在对应分组 `config/` 下加 `{module}.php`，需要时到 `config/app.php` 设 `enable=true`。
- 入口：`app/bootstrap/CoreConfigBootstrap.php` 扫描并加载。

## 写法要点
- 配置返回纯数组，键用 snake_case。
- 敏感信息（密钥、DB 密码）放 `.env`，用 `env('KEY')` 读取，不要硬编码。
