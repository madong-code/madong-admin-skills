---
name: madong-backend-exception
description: 异常体系规范，15 种异常类 + 全局异常处理器
globs:
  - "core/exception/**/*.php"
  - "app/**/exception/**/*.php"
---

## 异常体系

| 异常类 | 用途 |
|--------|------|
| `BusinessException` | 业务异常（通用） |
| `NotFoundException` | 资源不存在 |
| `UnauthorizedException` | 未认证/令牌过期 |
| `ForbiddenException` | 无权限 |
| `ValidationException` | 参数校验失败 |
| `TooManyRequestsException` | 请求频率限制 |

## 全局异常处理器

位置：`core/exception/Handler.php`

自动处理：
- 404 → NotFoundException
- 401 → UnauthorizedException  
- 403 → ForbiddenException
- 500 → 服务器内部错误

## 检查清单

- [ ] 异常是否继承自正确的基类
- [ ] 全局处理器是否覆盖了相关异常
- [ ] 异常消息是否用户友好（中文）
