---
name: backend-validate
description: 验证器规范（框架与插件共用，BaseValidate，rules/messages/scenes 三数组 + 场景校验）
globs:
  - "backend/app/**/validate/**/*.php"
  - "backend/plugin/**/app/**/validate/**/*.php"
---

# 验证器规范（框架层 + 插件端共用）

## 文件位置

| 端 | 路径 | 命名空间 |
|----|------|----------|
| 框架 | `app/adminapi/validate/{module}/{Model}Validate.php` 或 `app/api/validate/...` | `app\adminapi\validate\{module}` |
| 插件 | `plugin/{name}/app/adminapi/validate/{module}/{Model}Validate.php` | `plugin\{name}\app\adminapi\validate\{module}` |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`；类后缀 `Validate`。

## 基类
`core\foundation\base\BaseValidate`：三属性 + 场景机制：
```php
protected array $rules = ['name' => 'required|string|max:50'];
protected array $messages = ['name.required' => '名称不能为空'];
protected array $scenes = ['create' => ['name'], 'update' => ['name']];
```
使用：`$validate->scene('create')->check($data)`，失败抛异常由控制器 `try/catch` 捕获。

## 代码模板（框架，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\adminapi\validate\{module};    // 插件：plugin\{name}\app\adminapi\validate\{module}

use core\foundation\base\BaseValidate;

class {Model}Validate extends BaseValidate
{
    protected array $rules = [
        'name' => 'required|string|max:50',
    ];
    protected array $messages = [
        'name.required' => '{model_name}名称不能为空',
    ];
    protected array $scenes = [
        'create' => ['name'],
        'update' => ['name'],
    ];
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case） |
| 命名空间根 | `app\` | `plugin\{name}\app\` |

## 关键约定
- 控制器经 `BaseController::$validate` 持有验证器，在 `initialize()`/构造注入。
- 不同操作（create/update/changeStatus）用 `scenes` 区分字段。
- 唯一性校验 `unique:table,column,except_id` 注意排除自身（更新场景）。

## 检查清单
- [ ] 是否 extends `BaseValidate` 且定义 rules/messages/scenes
- [ ] 是否用 `scene()->check()`
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
