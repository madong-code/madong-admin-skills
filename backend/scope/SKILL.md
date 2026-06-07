---
name: madong-backend-scope
description: 数据权限作用域规范（Scope），支持全局 Scope 和查询 Scope
globs:
  - "app/scope/**/*.php"
---

## 数据权限模型

| 类型 | 说明 |
|------|------|
| 全局 Scope | 自动应用在所有查询上 |
| 查询 Scope | 通过 `->scopeName()` 调用 |

## 代码模板

```php
<?php

namespace app\scope;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Scope;

class {Name}Scope implements Scope
{
    public function apply(Builder $builder, Model $model): void
    {
        $builder->where('{field}', '{value}');
    }
}
```

## 检查清单

- [ ] Scope 是否注册到模型
- [ ] 全局 Scope 是否影响所有查询
- [ ] 查询 Scope 命名是否清晰
