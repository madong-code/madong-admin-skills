---
name: backend-listener
description: 后端监听器规范（处理 Event，后缀 Listener，继承 BaseListener）
globs:
  - "backend/app/listener/**/*.php"
---

# 后端监听器规范

## 定位
- 目录：`app/listener/`，命名空间 `app\listener`
- 类大驼峰 + `Listener` 后缀：`MemberRegisterListener`、`MenuUpdatedListener`
- 继承 `core\foundation\base\BaseListener`，实现 `handle($event)` 方法。

## 约定
- 一个 Listener 对应一个 Event，在 `event` 配置或 `config/event.php` 里绑定。
- 可做：发通知、写日志、清缓存、触发队列任务等。
- 耗时操作应投递到队列（`app/queue/`）而非同步阻塞。

## 写法要点
```php
<?php
namespace app\listener;

use app\event\MemberRegisterEvent;
use core\foundation\base\BaseListener;

class MemberRegisterListener extends BaseListener
{
    public function handle(MemberRegisterEvent $event): void
    {
        // 发送欢迎短信 / 初始化数据 ...
    }
}
```
- 监听器内禁止再派发同类事件形成环。
