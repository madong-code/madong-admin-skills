---
name: backend-core
description: 后端框架内核 core/ 分包约定（foundation/business/security 等，基类与能力来源）
globs:
  - "backend/core/**/*.php"
---

# 后端 core/ 内核规范

## 定位
`backend/core/` 是系统核心库（madong.tech），提供框架基础能力，按功能领域归为 6 个分组，PSR-4 自动加载，命名空间 `core\{group}\{module}`。

## 分组与层级
```
foundation/   (第1层) 基础支撑：base(MVC 抽象类) / exception / interface / trait / tool(Json,Assert,Util) / config
infrastructure/(第2层) 基础设施：cache / logger / monitor / scheduler
security/     (第2层) 安全认证：captcha / jwt(双Token/多端/黑名单)
communication/(第3层) 通信通知：email / sms / notify(WebSocket Push)
io/           (第3层) 文件 IO：excel / upload(本地/OSS/COS/七牛/S3) / uuid(雪花ID/UUID)
business/     (第4层) 业务模块：generator(全栈代码生成器) / plugin(插件系统) / route(Swagger) / service
```
依赖方向：`foundation → infrastructure+security → communication+io → business`，不可反向依赖。

## 常用入口
- MVC 基类：`core\foundation\base\{BaseController,BaseService,BaseDao,BaseModel,BaseValidate}`
- JSON 响应：`core\foundation\tool\Json`
- JWT：`core\security\jwt\JwtToken`
- 上传：`core\io\upload\UploadFile`
- 雪花 ID：`core\io\uuid\UUIDGenerator`
- 代码生成：`core\business\generator\GeneratorEngine`

## 写法要点
- **业务代码不要往 `core/` 写**，core 是框架层；业务放 `app/`。
- 新增能力优先做成 core 分组模块（带 `config/app.php` 的 `enable`），保持可插拔。
- 全局辅助函数：`core/functions.php`、`app/functions.php`（已自动加载）。
