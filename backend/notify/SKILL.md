---
name: madong-backend-notify
description: 消息通知推送规范（基于 Webman Push），支持站内信/推送
globs:
  - "core/notify/**/*.php"
---

## 通知类型

| 类型 | 说明 |
|------|------|
| 站内信 | 存储在数据库中的消息 |
| 实时推送 | Webman Push 即时推送 |

## 使用方式

```php
use core\notify\NotificationService;

// 发送通知
NotificationService::send($memberId, 'title', 'content');

// 推送
NotificationService::push($memberId, ['type' => 'order', 'data' => []]);
```

## 检查清单

- [ ] 通知目标是否正确
- [ ] 推送消息格式是否标准
- [ ] 通知是否有重试机制
