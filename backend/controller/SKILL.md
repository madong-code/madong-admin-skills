---
name: backend-controller
description: 控制器规范（AdminAPI/API/Install 与插件端共用，继承 Crud/Base 基类，统一 Json 响应）
globs:
  - "backend/app/**/controller/**/*.php"
  - "backend/plugin/**/app/**/controller/**/*.php"
---

# 控制器规范（框架层 + 插件端共用）

> **核心结论**：控制器是「按端分化」最明显的层。框架与插件都分 **adminapi（后台）** 与 **api（前端/移动）** 两种端，**写法不同、不能混用**；其余 dao/model/enum/schema/validate 等是「端无关的通用层」，不区分 adminapi/api（见各分层 skill）。

## 两种端对照（框架 / 插件同构）

| 端 | 框架路径 | 插件路径 | 框架命名空间 | 插件命名空间 | 基类 | 特征 |
|----|----------|----------|--------------|--------------|------|------|
| **AdminAPI（后台）** | `app/adminapi/controller/{module}/{Name}Controller.php` | `plugin/{name}/app/adminapi/controller/{module}/{Name}Controller.php` | `app\adminapi\controller\{module}` | `plugin\{name}\app\adminapi\controller\{module}` | `Crud` | 继承 `Crud` 全套 RESTful；挂 `AccessToken + Permission + Operation` 三类中间件；需权限码 |
| **API（前端/移动）** | `app/api/controller/{module}/{Name}Controller.php` | `plugin/{name}/app/api/controller/{module}/{Name}Controller.php` | `app\api\controller\{module}` | `plugin\{name}\app\api\controller\{module}` | `Base` | 继承 `Base`（无 Crud 全套）；按需挂中间件（多为登录态）；不强制权限码 |
| Install（安装，仅框架） | `app/install/controller/{Name}Controller.php` | — | `app\install\controller` | — | `Base` | 仅主程序安装向导使用，插件无此端 |

`Crud > Base > BaseController` 继承链：`app/adminapi/controller/Crud.php` → `app/api/controller/Base.php` → `core\foundation\base\BaseController`。

> 规律：**插件端只是把根 `app\` 换成 `plugin\{name}\app\`**，两种端的目录、命名空间、基类、中间件约定与主程序完全一致。下方以 AdminAPI 为例，换成 API 端就把 `adminapi` 改 `api`、基类改 `Base`、去掉权限中间件即可。

## 基类说明
- `core\foundation\base\BaseController`（abstract）：持有 `protected BaseService|null $service`、`protected BaseValidate|null $validate`，构造调抽象 `initialize(): void`。
- `app/adminapi/controller/Crud.php`：提供标准 RESTful 方法 `index/select/create/store/show/edit/update/changeStatus/export`，统一 `try/catch` + `Json::success()/Json::fail()`。
- `app/api/controller/Base.php`：API 端基类（继承 BaseController，不含 Crud 全套，需自行定义 action）。

## 代码模板

### AdminAPI（继承 Crud，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\adminapi\controller\{module};          // 插件：plugin\{name}\app\adminapi\controller\{module}

use app\adminapi\controller\Crud;
use app\adminapi\middleware\AccessTokenMiddleware;
use app\adminapi\middleware\OperationMiddleware;
use app\adminapi\middleware\PermissionMiddleware;
use app\adminapi\validate\{module}\{Model}Validate;     // 插件：plugin\{name}\app\adminapi\validate\{module}
use app\service\admin\{module}\{Model}Service;          // 插件：plugin\{name}\app\service\admin\{module}
use core\foundation\tool\Json;
use support\annotation\Middleware;

#[Middleware(AccessTokenMiddleware::class, PermissionMiddleware::class, OperationMiddleware::class)]
final class {Model}Controller extends Crud
{
    public function __construct(
        protected {Model}Service $service,
        protected {Model}Validate $validate,
    ) {}
}
```
`Crud` 已内置 `index/store/update` 等，无需重写除非定制。插件端同样 extends `Crud`、同样挂三类中间件。

### API（继承 Base，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\api\controller\{module};               // 插件：plugin\{name}\app\api\controller\{module}

use app\api\controller\Base;
use app\service\api\{module}\{Model}Service;           // 插件：plugin\{name}\app\service\api\{module}
use core\foundation\tool\Json;

final class {Model}Controller extends Base
{
    public function __construct(
        protected {Model}Service $service,
    ) {}

    public function detail(): \support\Response
    {
        $id = (int) request()->get('id');
        return Json::success($this->service->getInfo($id));
    }
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case，如 `codegen`） |
| `{Model}` | Menu/Member/Article | 同左 |
| 命名空间根 | `app\` | `plugin\{name}\app\` |
| 目录根 | `app/` | `plugin/{name}/app/` |
| 端目录 | `adminapi` / `api` | 同左（放在插件 `app/` 下） |

## 关键约定
- **端选择**：后台管理页面用 `adminapi` 端（Crud + 权限）；对外开放/移动端用 `api` 端（Base）。插件建控制器时同样先决定走哪一端。
- 控制器只做「接收参数 → 调 service → 返回 Json」，禁止直接操作 DAO/Model。
- 统一 `Json::success($data)` / `Json::fail($msg)`；分页响应 snake_case：`items/total/page_no/page_size`。
- 权限码：`{module}:{model}:{action}`，仅 adminapi 端强制；api 端按业务按需鉴权。
- 插件控制器代码随插件 `resource/template/admin/` 部署到前端（见 `backend-plugin`）。

## 检查清单
- [ ] 端是否选对：`adminapi`（Crud+三类中间件）或 `api`（Base，自行定义 action）
- [ ] 是否 extends `Crud`（adminapi/plugin）或 `Base`（api/install）
- [ ] adminapi 端是否挂 `AccessToken+Permission+Operation` 中间件
- [ ] 是否通过构造注入 service（+validate）
- [ ] 是否用 `Json::success()/Json::fail()` 返回
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
- [ ] 是否未直接调用 DAO/Model
