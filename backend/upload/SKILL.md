---
name: madong-backend-upload
description: 文件上传规范，支持 Local/COS/OSS/Qiniu/S3 6种存储驱动
globs:
  - "core/upload/**/*.php"
---

## 存储驱动

| 驱动 | 类 | 说明 |
|------|-----|------|
| Local | `storage/Local.php` | 本地存储 |
| COS | `storage/Cos.php` | 腾讯云 COS |
| OSS | `storage/Oss.php` | 阿里云 OSS |
| Qiniu | `storage/Qiniu.php` | 七牛云 |
| S3 | `storage/S3.php` | AWS S3 兼容 |

## 使用方式

```php
use core\upload\UploadFile;

// 上传文件
$url = UploadFile::upload($file, 'images');

// 删除文件
UploadFile::delete($url);
```

## 检查清单

- [ ] 上传配置是否包含 bucket/region/secret
- [ ] 文件类型是否在白名单内
- [ ] 文件大小是否限制
- [ ] 是否生成唯一文件名
