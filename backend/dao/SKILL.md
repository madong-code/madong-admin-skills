---
name: backend-dao
description: 数据访问层规范（框架与插件共用，继承 BaseDao，setModel 返回模型类，单表 CRUD）
globs:
  - "backend/app/**/dao/**/*.php"
  - "backend/plugin/**/app/**/dao/**/*.php"
---

# 数据访问层规范（框架层 + 插件端共用）

## 文件位置

| 端 | 路径 | 命名空间 |
|----|------|----------|
| 框架 | `app/dao/{module}/{Model}Dao.php` | `app\dao\{module}` |
| 插件 | `plugin/{name}/app/dao/{module}/{Model}Dao.php` | `plugin\{name}\app\dao\{module}` |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`。

## 基类
`core\foundation\base\BaseDao`（abstract）：必须实现 `setModel(): string` 返回模型类名；核心方法 `getModel()`、`selectList()`、`getCount()`、`get()`、`getColumn()`、`save()`、`update()`、`delete()`。Service 经 `__call` 透传调用。

## 代码模板（框架，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\dao\{module};                 // 插件：plugin\{name}\app\dao\{module}

use core\foundation\base\BaseDao;
use app\model\{module}\{Model};              // 插件：plugin\{name}\app\model\{module}

class {Model}Dao extends BaseDao
{
    protected function setModel(): string
    {
        return {Model}::class;
    }
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case） |
| `{Model}` | Menu/Member/Article | 同左 |
| 命名空间根 | `app\` | `plugin\{name}\app\` |

## 关键约定
- 只做单表数据访问，不含跨表业务。
- 统一走 `getModel()` 获取查询构造器，不在 dao 裸写 `DB::table()`。
- 软删除由模型 `SoftDeletes` 自动过滤。
- 批量/事务操作回 Service 处理。

## 检查清单
- [ ] 是否 extends `BaseDao` 并实现 `setModel()` 返回模型类
- [ ] 是否只做单表访问
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
