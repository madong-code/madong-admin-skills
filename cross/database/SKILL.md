---
name: madong-cross-database
description: 数据库设计规范，命名约定/索引/迁移/ER 设计
globs:
  - "database/**/*.php"
  - "**/*.php"
---

## 命名约定

| 对象 | 规范 | 示例 |
|------|------|------|
| 数据库名 | snake_case | `madong_saas` |
| 表名 | `{prefix}_{module}_{table}` | `system_menu`, `member_user` |
| 字段名 | snake_case | `created_at`, `parent_id` |
| 主键 | `bigInteger` 雪花 ID | `id` |
| 索引 | `{table}_{column}_index` | `menu_parent_id_index` |
| 外键 | `{table}_{foreign}_foreign` | `menu_parent_id_foreign` |

## 字段类型

| MySQL 类型 | 用途 |
|-----------|------|
| bigint | 主键（雪花 ID） |
| varchar | 字符串（长度 50-500） |
| text | 长文本 |
| json | JSON 数据 |
| tinyint | 状态/枚举（0/1） |
| timestamp | 时间戳 |
| decimal | 金额（10,2） |

## 检查清单

- [ ] 表名是否包含模块前缀
- [ ] 主键是否为 bigint 雪花 ID
- [ ] 是否包含 created_at/updated_at/deleted_at
- [ ] 索引是否覆盖查询条件
- [ ] 字段类型是否合理
