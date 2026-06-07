---
name: madong-backend-queue
description: Redis 消息队列规范，基于 Webman Queue 组件
globs:
  - "app/queue/**/*.php"
---

## 队列配置

```php
// config/redis.php
return [
    'queue' => [
        'host' => env('REDIS_HOST', '127.0.0.1'),
        'port' => env('REDIS_PORT', 6379),
        'password' => env('REDIS_PASSWORD', ''),
    ],
];
```

## 消费者模板

```php
<?php

namespace app\queue\redis;

use Webman\RedisQueue\Consumer;

class {Name}Consumer implements Consumer
{
    public string $queue = '{queue_name}';
    public string $connection = 'default';
    public int $retrySeconds = 5;

    public function consume($data): void
    {
        // 处理消息
    }
}
```

## 检查清单

- [ ] 队列名称是否唯一
- [ ] 消费者是否有错误处理
- [ ] 重试机制是否合理
- [ ] 消费失败的消息是否记录日志
