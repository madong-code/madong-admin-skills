---
name: madong-backend-cache
description: 缓存策略规范，支持 Redis/File 适配器、分布式锁
globs:
  - "core/cache/**/*.php"
---

## 缓存驱动

| 驱动 | 说明 |
|------|------|
| Redis | 生产环境推荐，支持分布式锁 |
| File | 开发环境，文件缓存 |

## 使用方式

```php
use core\cache\CacheService;

// 设置缓存
CacheService::set('key', $value, 3600);

// 获取缓存
$value = CacheService::get('key');

// 分布式锁
$lock = CacheService::lock('lock_name', 10);
if ($lock->acquire()) {
    // 业务逻辑
    $lock->release();
}
```

## 检查清单

- [ ] 缓存键名是否唯一且有前缀
- [ ] 缓存的 TTL 是否合理
- [ ] 锁是否在 finally 中释放
