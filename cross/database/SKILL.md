---
name: cross-database
description: 数据库设计规范（表命名、字段约定、迁移 phinx、模型映射）
globs:
  - "backend/phinx.php"
  - "backend/database/migrations/**/*.php"
  - "backend/app/model/**/*.php"
---

# 数据库设计规范

## 表命名
- 格式：`{prefix}_{module}_{table}`，如 `system_menu`、`member_user`、`content_article`。
- 前缀在配置中统一；`module` 对应业务域（system/member/content/ops/plugin/web/site）。
- 迁移文件：`{version}_{module}_{table}`（phinx 风格），如 `2024_01_01_000001_system_menu`。

## 字段约定
- 全部 `snake_case`：`created_at`、`updated_at`、`deleted_at`、`parent_id`、`sort`、`status`。
- 主键：雪花 ID（bigint，非自增）。
- 软删除：`deleted_at` nullable datetime。
- 状态/类型字段用 `tinyint` + 对应 PHP enum（`app/enum/`）。
- 时间统一用 `datetime` / `timestamp`，不要字符串存时间。
- 多租户：`tenant_id` 字段 + 全局 Scope 过滤。

## 迁移（phinx）
- 迁移文件位置由 `phinx.php` 指定（`database/migrations/` 或 `backend/migrations/`）。
- 每个迁移只做原子变更，配套 `down()` 可回滚。
- 改表后同步更新对应 `app/model/` 与 `schema/` DTO。

## 模型映射
- 模型 `$table` 显式声明表名；`BaseModel` 提供软删除/时间戳/雪花ID 基础能力。
- 字段 cast 用 PHP enum 或标准类型，避免裸数组。
