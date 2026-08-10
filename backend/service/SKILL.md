---
name: backend-service
description: 服务层规范（框架与插件共用，注入 DAO、事务控制、继承 BaseService，__call 透传 dao）
globs:
  - "backend/app/**/service/**/*.php"
  - "backend/plugin/**/app/**/service/**/*.php"
---

# 服务层规范（框架层 + 插件端共用）

> **端分化**：Service 也按调用方分端（`admin` / `api` / `core`），**与控制器端一一对应**——`adminapi` 控制器注入 `service/admin/...`，`api` 控制器注入 `service/api/...`，跨端复用的公共逻辑放 `service/core/...`。插件端同构：`plugin/{name}/app/service/{admin|api|core}/...`。其余 dao/model/enum/schema/validate 不分层、通用。

## 文件位置

| 端 | 框架路径 | 插件路径 | 框架命名空间 | 插件命名空间 | 基类 |
|----|----------|----------|--------------|--------------|------|
| Admin（后台） | `app/service/admin/{module}/{Model}Service.php` | `plugin/{name}/app/service/admin/{module}/{Model}Service.php` | `app\service\admin\{module}` | `plugin\{name}\app\service\admin\{module}` | `core\foundation\base\BaseService` |
| API（前端/移动） | `app/service/api/{module}/{Model}Service.php` | `plugin/{name}/app/service/api/{module}/{Model}Service.php` | `app\service\api\{module}` | `plugin\{name}\app\service\api\{module}` | 同上 |
| Core（公共） | `app/service/core/{module}/{Model}Service.php` | `plugin/{name}/app/service/core/{module}/{Model}Service.php` | `app\service\core\{module}` | `plugin\{name}\app\service\core\{module}` | 同上 |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`，service 分层写法一致。

## 基类
`core\foundation\base\BaseService`（abstract）：
- 持有 `protected ?BaseDao $dao`；`use ServiceTrait`；
- `transaction(callable, bool $throw=true, ?string $connection=null)`、`getPageValue()`、`cacheDriver()`、`passwordHash()`；
- **`__call()` 魔术方法**：未定义调用自动透传 `$this->dao`，故 service 可直接 `$this->getList()` 由 dao 实现。

## 代码模板（Admin，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\service\admin\{module};        // 插件：plugin\{name}\app\service\admin\{module}

use app\dao\{module}\{Model}Dao;               // 插件：plugin\{name}\app\dao\{module}
use core\foundation\base\BaseService;
use core\foundation\trait\ServiceTrait;

class {Model}Service extends BaseService
{
    use ServiceTrait;

    public function __construct()
    {
        $this->dao = new {Model}Dao();
    }

    public function create{model}(array $data): int
    {
        return $this->transaction(function () use ($data) {
            return $this->dao->save($data)->id;
        });
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
- 构造注入 DAO（`$this->dao = new {Model}Dao();`），不允许注入 Model。
- 普通 CRUD 无需手写方法，`__call` 透传到 DAO。
- 业务逻辑（聚合/计算/状态机）放 Service；DAO 只做单表访问。
- 事务在 Service 层用 `$this->transaction(fn() => ...)`；跨模块用事件解耦。
- 返回领域数据（数组/模型），不在 Service 返回 `\support\Response`。

## 检查清单
- [ ] 是否通过构造/initialize 注入 DAO
- [ ] 简单 CRUD 是否走 `__call` 代理（不手写）
- [ ] 复杂业务是否用 `transaction()` 包裹
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
- [ ] 是否未直接 new Model 查询
