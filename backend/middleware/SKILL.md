---
name: madong-backend-middleware
description: 中间件规范，支持全局中间件、路由中间件、控制器注解中间件
globs:
  - "app/**/middleware/**/*.php"
---

## 文件位置

```
app/{app}/middleware/{Name}Middleware.php
```

## 中间件类型

| 类型 | 注册方式 | 示例 |
|------|---------|------|
| 全局 | `config/middleware.php` | AccessTokenMiddleware |
| 路由 | Route::group 第二个参数 | PermissionMiddleware |
| 注解 | `#[Middleware]` | OperationMiddleware |

## 代码模板

```php
<?php

namespace app\adminapi\middleware;

use Webman\Http\Request;
use Webman\Http\Response;

class {Name}Middleware
{
    public function process(Request $request, callable $next): Response
    {
        // 前置处理
        $response = $next($request);
        // 后置处理
        return $response;
    }
}
```

## 检查清单

- [ ] 中间件注册方式是否正确
- [ ] 是否处理了异常情况
- [ ] 是否返回正确的 Response 对象
