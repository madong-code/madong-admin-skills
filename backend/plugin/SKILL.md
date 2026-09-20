---
name: backend-plugin
description: 后端插件体系（plugin/{name} 容器、插件专有结构 Install/config/info/resource，分层写法见各 backend-* skill）
globs:
  - "backend/plugin/**/*.php"
  - "backend/plugin/**/config/*.php"
  - "backend/plugin/**/resource/**/*"
---

# 后端插件（Plugin）体系规范

> 本 skill 只讲**插件专有**的部分。插件内部的 controller/service/dao/model/enum/schema/validate 写法与主程序**完全一致**，只是根命名空间不同——请直接看对应分层 skill（`backend-controller` / `backend-service` / `backend-dao` / `backend-model` / `backend-enum` / `backend-schema` / `backend-validate`），每个都已内含「框架模式 vs 插件模式」的命名空间对照表。

## 核心规律：根命名空间替换
| 主程序 | 插件 |
|--------|------|
| 目录 `backend/app/` | `backend/plugin/{name}/app/` |
| 命名空间 `app\` | `plugin\{name}\app\` |

其余分层、基类（`core\foundation\base\*`）、路由/权限码（`{module}:{model}:{action}`）全部一致。用户观察正确：**很多插件几乎一样，只是命名空间不同**。

## 插件目录结构（专有骨架）
```
backend/plugin/{name}/
├── Install.php              # 插件入口（install/uninstall 钩子），可空实现
├── config/
│   ├── app.php              # Webman 应用配置（enable、controller_suffix…）
│   ├── info.php             # ★ 元信息（见下）
│   ├── route.php            # 路由注册
│   ├── exception.php         # 异常配置（可选）
│   └── translation.php       # 翻译配置（可选）
├── app/                     # 业务逻辑（分层同主程序，仅命名空间换根）
│   ├── adminapi/  api/  service/  dao/  model/  enum/  schema/  validate/
└── resource/                # ★ 部署资源（安装时落地到主程序/前端）
    ├── data/menu/           # 菜单数据源（admin.php / web.php）→ 写入菜单表
    ├── database/             # 迁移 + seed（migrations/*.php、seeds/*.php）
    └── template/
        ├── admin/           # 插件前端 → 部署到 template/admin/src/plugin/{name}/
        │   ├── api/app/plugin/{name}/*.ts
        │   ├── views/plugin/{name}/*.vue
        │   ├── lang/{zh-cn,en-us}/app/plugin/{name}.json
        │   └── routes/index.ts
        └── web/             # （若该插件也支持 web 模版）→ template/web
```

## ★ 元信息 config/info.php（必填）
```php
return [
    'name' => 'codegen',
    'identifier' => 'codegen',
    'type' => 'madong:app',
    'version' => '1.0.0',
    'description' => '...',
    'author' => 'Mr.April',
    'uninstall' => ['drop_tables' => true, 'remove_dependencies' => false, 'undeletable' => false],
    'resource' => ['menu' => 'data/menu'],
];
```

## 插件生命周期（命令管理）
| 命令 | 作用 |
|------|------|
| `madong-plugin:develop:create <name> <title>` | 创建插件开发模板 |
| `madong-plugin:develop:build <name>` | 构建/打包插件 |
| `madong-plugin:install <name>` | 安装（执行 resource：建表、导菜单、部署前端） |
| `madong-plugin:uninstall <name>` | 卸载（按 info.php 的 uninstall 配置） |
| `madong-plugin:list` | 列出插件 |

> 命令详情见 `backend-command`。

## 插件开发目录与变更范围（重要）
- 开发中的插件源码在项目根的**插件开发目录** `{开发目录}/{name}/`（目录名由 `TransferCommand::DOWNLOAD_DIR` 定义，当前为 `download/`，**可能改名，勿硬编码**——动手前以该常量或实际存在的目录为准）。
- 流程：在开发目录里改源码 → `madong-plugin:transfer {name} full` 分发到 `backend/plugin/{name}/` 与各前端模版；`extract` 反向提取到开发目录。
- **只改当前正在运行/调试的端**，其他端一行都不动：
  - 调后端（webman）→ 只改 `{name}/app/`、`config/`
  - admin 模版在运行 → 只改 `{name}/resource/template/admin/`
  - web 模版在运行 → 只改 `{name}/resource/template/web/`
- 禁止为"保持一致"顺手生成其他端的等价实现/占位代码；其他端开发到时再改。

## 插件前端部署要点
- 插件自带 Vue 页面放 `resource/template/admin/`，安装时部署到 `template/admin/src/plugin/{name}/`。
- 改插件前端前先按 `frontend/admin` §0 判定当前 `template/admin` 的 UI（name）。
- 插件前端遵循对应 `frontend/admin`、`frontend/web` 规范 + 本 skill 的 resource 约定。

## 与参考项目差异
参考项目用 `addon/{plugin}/` 目录、命名空间 `addon\{plugin}\`；本仓库用 `plugin/{name}/`、命名空间 `plugin\{name}\app\`。其余「一个分层 skill 同时覆盖框架+插件」的设计一致。

## 检查清单（插件开发）
- [ ] 命名空间根是否为 `plugin\{name}\app\`（分层写法见各 backend-* skill）
- [ ] `config/info.php` 元信息是否完整
- [ ] 插件前端是否放 `resource/template/admin/`（而非直接改 template/admin）
- [ ] 菜单数据是否放 `resource/data/menu`
- [ ] 插件路径是否以实际开发目录为准（勿硬编码 `download`，见 `TransferCommand::DOWNLOAD_DIR`）
- [ ] 是否只改了当前运行/调试的端（未生成其他端无用代码）
- [ ] 是否通过 `madong-plugin:*` 命令创建/安装/卸载
