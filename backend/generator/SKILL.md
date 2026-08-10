---
name: backend-generator
description: 全栈代码生成器规范（core/business/generator，基于数据库表生成 controller/service/dao/model 等）
globs:
  - "backend/core/business/generator/**/*.php"
  - "backend/app/command/**/*.php"
---

# 后端代码生成器规范

## 定位
- 全栈代码生成器位于 `core/business/generator/`（14 个文件生成器 + 模板），引擎 `GeneratorEngine`。
- 命令行入口在 `app/command/`（Symfony Console 命令，类后缀 `Command`），部分命令带 `.stub` 模板。
- 设计理念：以**数据库表**为单一数据源，生成后端分层 + 前端页面 + 国际化。

## 生成范围
- 后端：`controller`（adminapi/api）、`service`、`dao`、`model`、`validate`、`schema`、`route`、迁移文件
- 前端：`template/admin` 的 view/api/store、以及 `template/web` 对应页面（取决于当前生效的 UI，见 `frontend/admin` §0）
- 国际化：后端 lang、前端 `locales/`
- **插件代码**：codegen 插件的 `app/generator/`（如 `GeneratorEngine`）是依附于插件的业务生成引擎，生成的文件落点在 `plugin\{name}\app\...` 命名空间下（见 `backend-plugin`）。

## 约定
- 表命名 `{prefix}_{module}_{table}` 决定生成目录与命名空间。
- 字段注释 / 类型映射决定表单控件（input/select/upload/richtext 等）。
- stub 模板在 `app/command/*.stub` 或 `core/business/generator/templates/`，插件生成器 stub 在 `plugin/codegen/resource/generator/stubs/`。

## 分工（避免混淆）
| 工具 | 粒度 | 典型用途 |
|------|------|----------|
| `core/business/generator` + codegen 插件 | 全栈 CRUD | 从数据表生成完整模块（后端分层 + 前端页面 + i18n） |
| `madong-make:*` 命令 | 单文件 | 只生成单个类骨架（controller/service/dao/...），stub 在 `app/command/make/stubs` |
| `madong-plugin:develop:create` | 插件壳 | 生成插件目录骨架（`backend/plugin/{name}/`） |

## 写法要点
- 新增生成目标（如支持 web 模版、或插件维度）时应扩展 generator，不要改业务分层模板以外的硬编码路径。
- 生成代码遵循本仓库其余 backend/* 与 frontend/* 技能规范（类名后缀、命名空间、`Json::success` 返回等）。
- 插件内生成代码使用 `plugin\{name}\app\` 根命名空间，遵循 `backend-plugin` 约定。
- 生成的代码应可直接运行（继承 Crud/Base 基类，注入 service/validate）。
