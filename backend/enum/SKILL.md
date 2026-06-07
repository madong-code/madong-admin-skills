---
name: madong-backend-enum
description: 枚举规范，继承 IEnum 接口，支持 label()/tryFrom() 模式
globs:
  - "app/enum/**/*.php"
  - "app/**/enum/**/*.php"
---

## 文件位置

```
app/enum/{module}/{Name}Enum.php
```

## 代码模板

```php
<?php

namespace app\enum\{module};

use core\interface\IEnum;

enum {Name}Enum: int implements IEnum
{
    case ACTIVE = 1;
    case INACTIVE = 0;

    public function label(): string
    {
        return match ($this) {
            self::ACTIVE   => '启用',
            self::INACTIVE => '禁用',
        };
    }
}
```

## 关键约定

- 所有枚举实现 `core\interface\IEnum` 接口
- 枚举使用 PHP 8.1+ native enum，backed by int 或 string
- 必须实现 `label()` 方法返回中文描述
- 枚举值一旦发布不可修改（只能追加）
- 模型字段转换使用 `$casts` 中的 `EnumsCast`

## 检查清单

- [ ] 是否实现 IEnum 接口
- [ ] 是否包含 label() 方法
- [ ] 枚举值是否稳定（发布后不改）
- [ ] 命名空间是否正确
