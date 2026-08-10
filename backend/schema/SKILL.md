---
name: backend-schema
description: DTO Schema 规范（框架与插件共用，Request/Response 数据传输对象）
globs:
  - "backend/app/**/schema/**/*.php"
  - "backend/plugin/**/app/**/schema/**/*.php"
---

# Schema (DTO) 规范（框架层 + 插件端共用）

## 文件位置

| 端 | 路径 | 命名空间 |
|----|------|----------|
| 框架 | `app/schema/{module}/{Model}/{Model}Response.php` | `app\schema\{module}\{Model}` |
| 插件 | `plugin/{name}/app/schema/{module}/{Model}/{Model}Response.php` | `plugin\{name}\app\schema\{module}\{Model}` |

> 规律：插件只把根 `app\` 换成 `plugin\{name}\app\`；类后缀 `Request`/`Response`。

## 约定
- Request DTO：承载校验后入参；Response DTO：定义返回前端的字段结构（隐藏密码、格式化时间）。
- 纯数据结构，不含业务逻辑；字段用 `public` 构造参数。
- Response 在 service 层由模型转换得到，控制器 `Json::success($dto->toArray())`。

## 代码模板（框架，插件同构仅换命名空间前缀）

```php
<?php
declare(strict_types=1);

namespace app\schema\{module}\{Model};      // 插件：plugin\{name}\app\schema\{module}\{Model}

class {Model}Response
{
    public function __construct(
        public int $id,
        public string $name,
        public ?int $parentId,
    ) {}

    public static function fromModel(\app\model\{module}\{Model} $m): self
    {
        return new self($m->id, $m->name, $m->parent_id);   // 插件：plugin\{name}\app\model...
    }
}
```

## 目标变量表

| 变量 | 框架模式 | 插件模式 |
|------|----------|----------|
| `{module}` | system/member/content/ops | 插件业务模块名 |
| `{name}` | — | 插件标识（snake_case） |
| 命名空间根 | `app\` | `plugin\{name}\app\` |

## 关键约定
- 可配合 Swagger 注解描述字段，便于生成接口文档。
- DTO 不放业务逻辑；跨端共用时放 `app/schema/core`。

## 检查清单
- [ ] 是否纯 DTO（无业务逻辑）
- [ ] 命名空间是否正确（框架 `app\...` / 插件 `plugin\{name}\app\...`）
