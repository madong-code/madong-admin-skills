---
name: madong-backend-swagger
description: Swagger/OpenAPI 注解规范，自动生成 API 文档
globs:
  - "app/**/controller/**/*.php"
  - "app/schema/**/*.php"
---

## 注解规范

### 控制器注解

```php
use OpenApi\Attributes as OA;

#[OA\Tag(name: '{module_name}管理')]
class {Model}Controller extends Crud
{
    #[OA\Get(path: '/adminapi/{module_route}', summary: '列表')]
    #[Permission('{module}:{model}:list')]
    public function index(Request $request): \support\Response
```

### Schema 注解

```php
#[OA\Schema(title: '创建请求')]
class {Model}CreateRequest
{
    #[OA\Property(property: 'name', description: '名称', type: 'string')]
    public string $name;
}
```

## 扫描路径

| 模块 | 路径 |
|------|------|
| AdminAPI | `/adminapi/{module}` |
| API | `/api/{module}` |

## 检查清单

- [ ] 控制器类是否有 `#[OA\Tag]`
- [ ] 每个方法是否有 `#[OA\Get/Post/Put/Delete]`
- [ ] Schema 属性是否有 `#[OA\Property]`
- [ ] 路由已注册 Swagger 扫描路径
