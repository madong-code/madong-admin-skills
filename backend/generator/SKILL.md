---
name: madong-backend-generator
description: 代码生成器规范（generator），基于模板引擎的代码自动生成
globs:
  - "core/generator/**/*.php"
---

## 生成器架构

| 组件 | 说明 |
|------|------|
| GeneratorEngine | 生成引擎核心 |
| factory/ | 各种生成器工厂（11种） |
| file/ | 文件生成器 |
| scene/ | 场景定义 |
| stubs/ | 代码模板文件 |

## 使用方式

```php
use core\generator\GeneratorEngine;

$engine = new GeneratorEngine([
    'module' => 'article',
    'model' => 'Article',
    'table' => 'article',
    'fields' => [...],
]);

$engine->generate();
```

## 检查清单

- [ ] 生成配置是否完整
- [ ] 模板文件是否存在
- [ ] 输出目录是否可写
- [ ] 生成的文件是否可覆盖
