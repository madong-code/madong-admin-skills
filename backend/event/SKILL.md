---
name: backend-event
description: 后端事件规范（PHP 事件类，后缀 Event，解耦跨模块逻辑）
globs:
  - "backend/app/event/**/*.php"
---

# 后端事件规范

## 定位
- 目录：`app/event/`，命名空间 `app\event`
- 类大驼峰 + `Event` 后缀：`MemberRegisterEvent`、`MenuUpdatedEvent`
- 事件名约定：`{app}.{module}.{action}`，如 `adminapi.member.register`

## 约定
- 事件类只是**数据载体**（public 属性存放上下文，如 `$userId`、`$menuId`）。
- 通过 `event(new XxxEvent(...))` 派发，由对应的 Listener 异步/同步处理。
- 用于解耦：如会员注册后发邮件、初始化默认数据等跨模块副作用。

## 写法要点
```php
<?php
namespace app\event;

class MemberRegisterEvent
{
    public function __construct(public int $memberId, public string $mobile) {}
}
```
- 派发：`\support\event\Event::dispatch(new MemberRegisterEvent($id, $mobile));`
- 不要往事件里塞业务处理，处理放 Listener。
