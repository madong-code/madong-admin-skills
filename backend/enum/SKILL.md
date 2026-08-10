---
name: backend-enum
description: PHP 8.1 原生枚举规范（框架与插件共用，无后缀命名，用于字段 cast 与状态机）
globs:
  - "backend/app/**/enum/**/*.php"
  - "backend/plugin/**/app/**/enum/**/*.php"
---

# 枚举规范（框架层 + 插件端共用）

## 文件位置

| 端 | 路径 | 命名空间 |
|----|------|----------|
| 框架 | `app/enum/{module}/{Model}/{Model}Type.php` 或 `app/enum/{module}/{Model}Type.php` | `app\enum\{module}` |
| 插件 | `plugin/{name}/app/enum/{module}/{Model}Type.php` | `plugin\{name}\app\enum\{module}` |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`；枚举类无后缀（大驼峰 enum）。

## 约定
- 优先 backed enum（`enum X: int` / `enum X: string`），便于存库与序列化。
- 模型 `casts` 自动转换：`protected $casts = ['type' => {Model}Type::class];`
- 可加 `label()` 方法做值→标签映射。

## 代码模板（框架，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\enum\{module};               // 插件：plugin\{name}\app\enum\{module}

enum {Model}Type: int
{
    case ONE = 1;
    case TWO = 2;

    public function label(): string
    {
        return match ($this) {
            self::ONE => '类型一',
            self::TWO => '类型二',
        };
    }
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case） |
| 命名空间根 | `app\` | `plugin\{name}\app\` |

## 关键约定
- 语义集中放 `enum/`，不要在 service/controller 散落魔法数字。
- 前端对应 TS 枚举放 `template/admin/src/enums/`（当前 UI，见 `frontend/admin` §0）。

## 检查清单
- [ ] 是否用 backed enum
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
