# Madong Skills 技能库

本目录包含 Madong 框架的代码生成技能，用于快速生成模块的完整 CRUD 代码。

## 目录结构

```
skills/
├── README.md                     # 本文件
├── madong-backend-gen-crud/      # CRUD 生成主技能（整合所有子技能）
├── madong-backend-gen-parse/     # 表解析
├── madong-backend-gen-migrate/   # 数据库迁移
├── madong-backend-gen-model/     # Eloquent 模型
├── madong-backend-gen-controller/ # AdminAPI 控制器
├── madong-backend-gen-api-controller/ # API 控制器
├── madong-backend-gen-validate/  # 验证器
├── madong-backend-gen-service/   # 服务层
├── madong-backend-gen-api-service/ # API 服务层
├── madong-backend-gen-dao/       # 数据访问层
├── madong-backend-gen-schema/    # Schema DTO
├── madong-backend-route/         # 路由配置
├── madong-backend-lang/          # 后端国际化
├── madong-backend-logger/        # 后端日志集成
├── madong-frontend-admin-gen/    # Admin 前端生成
├── madong-frontend-admin-i18n/   # Admin 前端国际化
├── madong-backend-tester/        # 后端测试
└── madong-backend-gen-event/     # 事件
└── madong-backend-gen-listener/  # 监听器
```

## 快速开始

### 生成完整 CRUD

使用 `madong-backend-gen-crud` 技能可以一键生成完整的 CRUD 模块：

```
create CRUD for articles app
create CRUD for articles plugin
create CRUD for articles no-api
```

参数说明：
- `articles` - 模块名称
- `app` - 主项目
- `plugin` - 插件
- `no-api` - 不生成 API 层

### 分步生成

也可以按需生成各个层次的代码：

1. **Migration** - 数据库迁移
2. **Model** - Eloquent 模型
3. **Controller** - AdminAPI 控制器
4. **Validate** - 验证器
5. **Service** - 服务层
6. **DAO** - 数据访问层
7. **Schema** - Schema DTO
8. **Route** - 路由配置
9. **Event** - 事件
10. **Listener** - 监听器
11. **Frontend** - Vue 前端

## Target 参数说明

所有 Skills 支持 `target` 参数来区分主项目和插件：

| 参数值 | 说明 | 命名空间 |
|--------|------|----------|
| `app` | 主项目 | `app\{module}\...` |
| `plugin` | 插件 | `plugin\{Plugin}\app\...` |

## 统一路径变量

| 变量 | App | Plugin |
|------|-----|--------|
| `{ns}` | `app` | `plugin\{Plugin}\app` |
| `{prefix}` | `` (空) | `plugin\{Plugin}` |
| `{model_ns}` | `app\model` | `plugin\{Plugin}\app\model` |
| `{dao_ns}` | `app\dao` | `plugin\{Plugin}\app\dao` |
| `{service_ns}` | `app\service\admin` | `plugin\{Plugin}\app\service\admin` |

## 生成的代码结构

### 主项目 (App)

```
app/
├── adminapi/
│   ├── controller/{module}/{Model}Controller.php  # CRUD 控制器
│   ├── validate/{module}/{Model}Validate.php      # 验证器
│   └── middleware/
├── api/
│   ├── controller/{module}/{Model}Controller.php  # API 控制器
│   └── validate/{module}/{Model}Validate.php      # API 验证器
├── dao/{module}/{Model}Dao.php                     # 数据访问层
├── model/{module}/{Model}.php                      # Eloquent 模型
├── service/
│   ├── admin/{module}/{Model}Service.php          # Admin 服务
│   └── api/{module}/{Model}Service.php             # API 服务
├── schema/
│   ├── request/{module}/                           # 请求 DTO
│   └── response/{module}/                          # 响应 DTO
└── config/
    └── route.php                                    # 路由配置
```

### 插件 (Plugin)

```
plugin/{Plugin}/
├── app/
│   ├── adminapi/controller/{module}/               # 控制器
│   ├── api/controller/{module}/                    # API 控制器
│   ├── dao/{module}/                               # DAO
│   ├── model/{module}/                             # 模型
│   └── service/admin/{module}/                     # 服务
├── config/
│   └── route.php                                   # 路由
└── database/migrations/                            # 迁移文件
```

## 控制器说明

### AdminAPI 控制器

继承 `Crud` 基类，自动实现标准 CRUD：

| 方法 | 路由 | 说明 |
|------|------|------|
| `index` | GET `/{module}/{model}` | 列表 |
| `show` | GET `/{module}/{model}/{id}` | 详情 |
| `store` | POST `/{module}/{model}` | 创建 |
| `update` | PUT `/{module}/{model}/{id}` | 更新 |
| `destroy` | DELETE `/{module}/{model}/{id}` | 删除 |
| `batchDelete` | DELETE `/{module}/{model}` | 批量删除 |

### 权限控制

使用 `#[Permission]` 属性控制权限：

```php
#[Permission("module:model:list")]    // 列表权限
#[Permission("module:model:read")]    // 查看权限
#[Permission("module:model:create")]  // 创建权限
#[Permission("module:model:update")]  // 更新权限
#[Permission("module:model:delete")]  // 删除权限
```

## 模型说明

### 软删除

所有模型默认使用软删除：

```php
use Illuminate\Database\Eloquent\SoftDeletes;

class {Model} extends BaseModel
{
    use SoftDeletes;
}
```

### 关联关系

支持常见的 Eloquent 关联：

```php
// 一对一
public function profile(): BelongsTo { }

// 一对多
public function comments(): HasMany { }

// 多对多
public function tags(): BelongsToMany { }
```

## 服务层说明

### AdminAPI 服务

```php
class {Model}Service extends BaseService
{
    public function __construct({Model}Dao $dao)
    {
        $this->dao = $dao;
    }
}
```

服务层通过 DAO 进行数据库操作，业务逻辑集中在服务层。

## DAO 说明

### 数据访问

```php
class {Model}Dao extends BaseDao
{
    protected function setModel(): string
    {
        return {Model}::class;
    }
}
```

BaseDao 提供：
- `selectList()` - 分页查询
- `getCount()` - 计数
- `get()` - 获取单条
- `save()` - 创建
- `update()` - 更新
- `delete()` - 删除
- `transaction()` - 事务

## Schema 说明

### 请求 DTO

```php
#[OA\Schema(title: '请求Schema')]
class {Model}Request extends BaseRequestDTO
{
    #[OA\Property(property: 'id', description: 'ID', type: 'integer')]
    #[ValidationRules(rules: 'integer|required')]
    public int $id;
}
```

### 响应 DTO

```php
#[OA\Schema(title: '响应Schema')]
class {Model}Response
{
    #[OA\Property(property: 'id', description: 'ID', type: 'integer')]
    public int $id;
}
```

## OpenAPI 文档

Swagger 文档通过路由配置自动生成：

- AdminAPI: `/openapi/adminapi`
- API: `/openapi/api`

扫描路径在对应的 `route.php` 中配置。

## 事件和监听器说明

### 事件结构

事件类包含公开属性、构造函数和 `dispatch()` 方法：

```php
namespace app\adminapi\event;

use Webman\Event\Event;

class PointsChangedEvent
{
    public int|string $memberId;
    public int $oldPoints;
    public int $newPoints;
    public int $points;
    public string $remark;
    
    public function __construct(
        int|string $memberId,
        int $points,
        int $oldPoints,
        int $newPoints,
        string $remark = ''
    ) {
        $this->memberId = $memberId;
        $this->points = $points;
        $this->oldPoints = $oldPoints;
        $this->newPoints = $newPoints;
        $this->remark = $remark;
    }

    public function dispatch(): void
    {
        Event::emit('adminapi.points.changed', $this);
    }
}
```

### 监听器结构

监听器包含 `handle()` 方法，使用 `Container::make()` 获取 DAO：

```php
namespace app\adminapi\listener;

use app\adminapi\event\PointsChangedEvent;
use app\dao\member\MemberPointsDao;
use support\Container;

class PointsChangedListener
{
    public function handle(PointsChangedEvent $event): void
    {
        /** @var MemberPointsDao $dao */
        $dao = Container::make(MemberPointsDao::class);
        
        $dao->save([
            'member_id' => $event->memberId,
            'points' => $event->points,
            'balance' => $event->newPoints,
            'remark' => $event->remark,
        ]);
    }
}
```

### 事件注册

监听器需要在 `config/event.php` 中注册：

```php
return [
    'adminapi.points.changed' => [
        [\app\adminapi\listener\PointsChangedListener::class, 'handle'],
    ],
];
```

### 触发事件名规范

| 前缀 | 说明 |
|------|------|
| `adminapi.` | AdminAPI 事件 |
| `member.` | 会员 API 事件 |

## 使用示例

### 1. 创建文章模块（主项目）

```
create CRUD for article app
```

这将生成：
- `app/model/article/Article.php`
- `app/dao/article/ArticleDao.php`
- `app/service/admin/article/ArticleService.php`
- `app/adminapi/controller/article/ArticleController.php`
- `app/adminapi/validate/article/ArticleValidate.php`
- `app/schema/request/article/ArticleRequest.php`

### 2. 创建文章模块（插件）

```
create CRUD for article plugin
```

### 3. 仅生成 API 层

```
create CRUD for article no-api
```

### 4. 分步生成

```
generate model for article
generate dao for article
generate service for article
generate controller for article
generate validate for article
generate schema for article
```

## 注意事项

1. **命名规范**
   - 模型名：`Article`（大驼峰）
   - 表名：`article` 或带前缀 `official_article`
   - 控制器名：`ArticleController`
   - 服务名：`ArticleService`
   - DAO名：`ArticleDao`

2. **插件命名空间**
   - 插件代码放在 `plugin/{Plugin}/app/` 下
   - 命名空间前缀 `plugin\{Plugin}\app`

3. **数据库表前缀**
   - 主项目表：`article`
   - 插件表：`{prefix}_article`（如 `official_article`）

4. **软删除**
   - 所有模型默认启用软删除
   - 使用 `SoftDeletes` trait

5. **权限控制**
   - 控制器方法使用 `#[Permission]` 属性
   - 权限码格式：`{module}:{model}:{action}`
