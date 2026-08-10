---
name: backend-route
description: 后端路由注册规范（Webman Route 配置式 + 注解，adminapi/api 分组，权限码绑定）
globs:
  - "backend/route/**/*.php"
  - "backend/config/route.php"
  - "backend/app/adminapi/route/**/*.php"
---

# 后端路由规范

## 注册方式
- Webman 路由在 `config/route.php` 或各应用 `route/` 目录的 PHP 文件里用 `Route::` 静态方法注册。
- 典型分组：
  ```php
  Route::group('/adminapi', function () {
      Route::get('/system/menu/list', [MenuController::class, 'index']);
      Route::post('/system/menu/create', [MenuController::class, 'store']);
  });
  ```
- 也可使用注解（参考 `core/business/route` 的路由组织 + Swagger 注册机制）。

## 约定
- 路由前缀区分应用：`/adminapi/*`（后台）、`/api/*`（前台）、`/install/*`（安装）。
- 路由 code（权限标识）：`{app}.{module}.{action}`，如 `adminapi.menu.update`。
- 权限码：`{module}:{model}:{action}`，如 `system:menu:update`，用于前端菜单/按钮权限与后端中间件校验。
- 在 `Crud` 基类的标准方法里，路由已约定好；新增自定义动作需同步加路由 + 权限码。

## 写法要点
- 不要在控制器里写 `Route::`（路由与控制器分离）。
- SSE 实时接口单独注册，返回 `text/event-stream`。
- 路由文件改动后需重启 Webman（或开启自动重载）。
