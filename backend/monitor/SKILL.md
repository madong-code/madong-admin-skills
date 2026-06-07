---
name: madong-backend-monitor
description: 系统监控规范（ServerMonitor），监控磁盘/CPU/内存/Redis
globs:
  - "core/monitor/**/*.php"
---

## 监控指标

| 指标 | 说明 |
|------|------|
| 磁盘 | 磁盘使用率 |
| CPU | CPU 负载 |
| 内存 | 内存使用率 |
| Redis | Redis 连接状态 |
| 数据库 | 数据库连接池 |

## 使用方式

```php
use core\monitor\ServerMonitor;

$status = ServerMonitor::check();
// 返回 {disk, cpu, memory, redis, db}
```

## 检查清单

- [ ] 监控项是否完整覆盖关键指标
- [ ] 告警阈值是否合理
- [ ] 监控数据是否有存储
