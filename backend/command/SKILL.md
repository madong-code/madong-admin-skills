---
name: backend-command
description: 后端命令行脚本体系（madong-plugin/make/install/config/metadata 全部命令，Symfony AsCommand 注册，BaseCommand 基类含 SSE）
globs:
  - "backend/app/command/**/*.php"
  - "backend/config/console.php"
  - "backend/webman"
  - "backend/start.php"
---

# 后端命令脚本（Command）体系

## 运行方式
- 基于 **Symfony Console**，命令用 `#[AsCommand(name: 'xxx', ...)]` 属性注册。
- 基类：`app\command\BaseCommand`（继承 `Symfony\Component\Console\Command\Command`），提供 SSE 事件解析、目录操作等通用方法。
- 执行：Webman 下 `php webman {command}`（或 `php start.php {command}`，视入口），需先 `composer install`。
- 命令注册通常在 `config/console.php`（或自动扫描 `app/command/`）。

## 命令清单（按分组）

### 插件管理 `madong-plugin:*`
| 命令 | 作用 |
|------|------|
| `madong-plugin:develop:create <name> <title> [desc]` | 创建插件开发模板（name 用 snake_case，如 `test_demo`） |
| `madong-plugin:develop:build <name>` | 构建/打包插件 |
| `madong-plugin:develop:delete <name>` | 删除开发中的插件模板 |
| `madong-plugin:install <name>` | 安装插件（执行 resource：建表、导菜单、部署前端） |
| `madong-plugin:uninstall <name>` | 卸载插件（按 info.php 的 uninstall 配置 drop_tables 等） |
| `madong-plugin:delete <name>` | 删除已安装插件 |
| `madong-plugin:run <name>` | 运行插件（触发入口） |
| `madong-plugin:list` | 列出插件 |
| `madong-plugin-migrate <name>` | 插件数据库迁移 |

### 代码脚手架 `madong-make:*`（单文件生成，配 stubs）
| 命令 | 生成物 | stub |
|------|--------|------|
| `madong-make:controller <name>` | 控制器 | `app/command/make/stubs/*` |
| `madong-make:service <name>` | 服务类 | 同上 |
| `madong-make:dao <name>` | DAO 类 | 同上 |
| `madong-make:model <name>` | 模型类 | 同上 |
| `madong-make:validate <name>` | 验证器 | 同上 |
| `madong-make:middleware <name>` | 中间件 | 同上 |

> 注意分工：`madong-make:*` 生成**单文件骨架**（stub 模板在 `app/command/make/stubs/`）；而 `backend/core/business/generator` + codegen 插件是**全栈 CRUD 生成**（后端分层 + 前端页面 + i18n）。日常建新模块优先用全栈生成器。

### 安装/部署 `install:*`
| 命令 | 作用 |
|------|------|
| `install:madong` | 系统安装（建库、导入初始数据、初始化管理员） |
| `madong-download:template <name>` | 下载前端模版（如 admin/web 模版） |
| `madong:migrate` 类（见 install/MigrateCommand） | 执行迁移 |

### 配置/元数据 `config:*`、`metadata:*`
| 命令 | 作用 |
|------|------|
| `madong-config:mysql` | 生成/写入 MySQL 配置 |
| `madong:migrate-admin-menu` | 迁移/同步后台菜单 |
| `madong:permission:collect` | 收集权限码（扫描路由/注解，写入权限表） |

## 写法要点
- 新命令：放 `app/command/{group}/`，`namespace app\command\{group};`，`extends BaseCommand`，用 `#[AsCommand(name: 'madong:{group}:{action}')]` 声明。
- 需要流式进度（如插件安装）时用 `BaseCommand::parseSseEvent()` 输出 SSE。
- 命令里调用 service 直接 `new XxxService()` 或 `Container::get()`，不要在命令里写业务逻辑，委托给 service/plugin service。
- 命令名统一前缀 `madong:` 便于辨识，分组清晰（plugin/make/install/config/metadata）。

## 与参考项目
参考项目把"关键命令脚本"单列（如 `madong-plugin:*`、`madong-make:*`）。本仓库已具备同等能力，本 skill 即对齐该维度，确保 AI 知道：建插件用 `madong-plugin:develop:create`、建单文件用 `madong-make:*`、装系统用 `install:madong`、收权限用 `madong:permission:collect`。
