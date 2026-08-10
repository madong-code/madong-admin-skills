---
name: backend-model
description: Eloquent 模型规范（框架与插件共用，无后缀命名、软删除、雪花ID、多租户 Scope）
globs:
  - "backend/app/**/model/**/*.php"
  - "backend/plugin/**/app/**/model/**/*.php"
---

# 模型规范（框架层 + 插件端共用）

## 文件位置

| 端 | 路径 | 命名空间 |
|----|------|----------|
| 框架 | `app/model/{module}/{Model}.php` | `app\model\{module}` |
| 插件 | `plugin/{name}/app/model/{module}/{Model}.php` | `plugin\{name}\app\model\{module}` |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`；模型类无后缀（大驼峰）。

## 基类
`core\foundation\base\BaseModel`（→ `support\Model`）：提供软删除、时间戳、雪花ID 基础能力。

## 代码模板（框架，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\model\{module};               // 插件：plugin\{name}\app\model\{module}

use core\foundation\base\BaseModel;
use Illuminate\Database\Eloquent\SoftDeletes;

class {Model} extends BaseModel
{
    use SoftDeletes;

    protected $table = '{prefix}_{module}_{table}';   // 表名（含前缀）
    public $incrementing = false;                     // 雪花ID非自增
    protected $keyType = 'int';

    protected $fillable = ['parent_id', 'name', 'sort', 'status'];
    protected $casts = ['status' => 'int', 'created_at' => 'datetime'];
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case） |
| `{prefix}_{module}_{table}` | `system_menu` | 如 `plugin_codegen_task`（建议带插件前缀避免冲突） |
| 命名空间根 | `app\` | `plugin\{name}\app\` |

## 关键约定
- 只放：表声明、fillable/guarded、casts、关联、Scope、访问器；不放业务逻辑。
- 软删除 `SoftDeletes`；主键雪花ID（`$incrementing=false`）。
- 多租户用 `app/scope/` 全局 Scope 注入。
- 枚举字段用 PHP 8.1 enum cast：`protected $casts = ['type' => {Model}Type::class];`
- 插件模型表建议带插件前缀（如 `plugin_{name}_*`）避免与主程序表冲突。

## 检查清单
- [ ] 是否 extends `BaseModel`
- [ ] 表名/主键/软删除是否正确
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
- [ ] 业务逻辑是否未写进模型
