---
name: backend-middleware
description: 后端中间件规范（Webman 中间件，鉴权/日志/跨域，后缀 Middleware）
globs:
  - "backend/app/middleware/**/*.php"
  - "backend/app/adminapi/middleware/**/*.php"
---

# 后端中间件规范

## 定位
- 目录：`app/middleware/`（全局）、`app/adminapi/middleware/`（后台专用）
- 类大驼峰 + `Middleware` 后缀：`AdminAuthMiddleware`、`OperateLogMiddleware`
- Webman 中间件实现 `process()` 方法，签名：`process(Request $request, callable $handler): Response`

## 约定
- 鉴权中间件负责解析 JWT（来自 `core/security/jwt`），写入 `request->admin` / `request->tenant` 上下文。
- 操作日志中间件（`OperateLogMiddleware`）记录后台关键操作。
- CORS/跨域中间件在全局 `config/middleware.php` 注册。
- 中间件不写业务，只做「拦截 / 注入上下文 / 改写响应」。

## 写法要点
```php
<?php
namespace app\adminapi\middleware;

use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;
use Webman\Http\Response as HttpResponse;

class AdminAuthMiddleware implements MiddlewareInterface
{
    public function process(Request $request, callable $handler): Response
    {
        // 解析 token、校验权限码 ...
        return $handler($request);
    }
}
```
- 在 `config/middleware.php` 或路由 group 里挂载。
