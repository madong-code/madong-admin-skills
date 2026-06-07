---
name: madong-backend-config
description: 配置体系规范，覆盖 28 个配置文件的结构、加载顺序、环境变量覆盖规则
globs:
  - "config/**/*.php"
  - "app/**/config/**/*.php"
---

## 配置体系

### 全局配置 (config/)

| 文件 | 说明 |
|------|------|
| `app.php` | 应用基础配置 |
| `database.php` | 数据库连接配置 |
| `cache.php` | 缓存配置 (Redis/File) |
| `log.php` | 日志配置 |
| `route.php` | 路由配置 |
| `middleware.php` | 全局中间件 |
| `exception.php` | 异常处理配置 |
| `thinkorm.php` | Laravel Eloquent ORM 配置 |

### 环境变量覆盖

所有配置项可通过 `.env` 文件覆盖，使用 `env()` 函数读取：

```php
return [
    'host' => env('DB_HOST', '127.0.0.1'),
    'port' => env('DB_PORT', 3306),
];
```

## 关键约定

- 配置返回 PHP 数组，键名使用 snake_case
- 敏感信息必须通过 `env()` 从环境变量读取
- 动态配置存储在数据库中，通过 Config Service 读取
- 插件配置放在 `plugin/{name}/config/` 下

## 检查清单

- [ ] 配置键名是否 snake_case
- [ ] 敏感信息是否使用 env() 读取
- [ ] 是否有合理的默认值
- [ ] 插件配置是否放在正确路径
