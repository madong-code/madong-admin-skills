---
name: madong-backend-process
description: 自定义进程规范，基于 Workerman Worker 的自定义进程
globs:
  - "app/process/**/*.php"
---

## 进程类型

| 进程 | 说明 |
|------|------|
| Http | HTTP 服务进程 |
| Monitor | 文件监控进程 |
| PushNotification | 推送通知进程 |

## 代码模板

```php
<?php

namespace app\process;

use Workerman\Worker;

class {Name}Process
{
    public function onWorkerStart(Worker $worker): void
    {
        // 进程启动逻辑
    }
}
```

## 检查清单

- [ ] 进程是否注册到 config/process.php
- [ ] 是否有内存泄漏风险
- [ ] 进程间通信是否正确
