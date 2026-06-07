---
name: madong-backend-crontab
description: 定时任务规范（Crontab），基于 Webman Crontab 组件
globs:
  - "app/crontab/**/*.php"
---

## 文件位置

```
app/crontab/{Name}Task.php
```

## 代码模板

```php
<?php

namespace app\crontab;

use Webman\Crontab\Task;

class {Name}Task extends Task
{
    protected string $crontab = '*/5 * * * *'; // 每5分钟
    
    public function run(): void
    {
        // 任务逻辑
    }
}
```

## 检查清单

- [ ] crontab 表达式是否正确
- [ ] 任务是否有错误处理
- [ ] 是否注册到配置中
- [ ] 长时间任务是否使用了队列
