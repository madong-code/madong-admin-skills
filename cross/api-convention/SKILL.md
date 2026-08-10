---
name: cross-api-convention
description: 前后端 API 对接规范（响应格式、分页、错误码、权限码、SSE）
globs:
  - "backend/app/adminapi/controller/**/*.php"
  - "template/admin/src/api/**/*.ts"
  - "template/web/src/api/**/*.ts"
---

# 前后端 API 对接规范

## 响应格式（统一）
后端 `core\foundation\tool\Json`：
```json
{ "code": 0, "msg": "ok", "data": { } }
```
- `code = 0` 成功，非 0 业务错误；`msg` 提示；`data` 业务数据。
- 前端请求客户端统一拦截 `code !== 0` 弹错。

## 分页
```json
{ "code": 0, "data": { "items": [], "total": 100, "page_no": 1, "page_size": 20 } }
```
- 字段全部 snake_case：`items` / `total` / `page_no` / `page_size`。

## 路由与权限码
- 路由前缀：`/adminapi/*`（后台）、`/api/*`（前台）、`/install/*`。
- 路由 code：`{app}.{module}.{action}`，如 `adminapi.menu.update`。
- 权限码：`{module}:{model}:{action}`，如 `system:menu:update`，前后端共用，前端控制按钮显隐、后端中间件校验。

## 入参
- 创建/更新走 `BaseValidate` 场景校验，字段 snake_case。
- 文件上传走 `core/io/upload`，返回 URL 或相对路径。

## 实时通信（SSE）
- 需服务端推送的接口用 SSE（`text/event-stream`），前端用 EventSource 或 Vben 的 SSE 封装消费。
- 典型场景：安装进度、队列任务进度、通知。

## 前端对接（admin / web）
- admin：见 `frontend-admin`，用 `src/core/request` + `useCrud`。
- web：见 `frontend-web`，用 `$fetch` + `composables`。
- API 函数命名小驼峰，类型放 `src/types/`，遵循 `frontend-shared`。
