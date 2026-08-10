# Madong SaaS Skills — 项目 AI 技能库 (MDAdmin 标准版)

让 AI 理解你的项目规范。覆盖后端、前端、跨层三大领域，一键分发到各 AI 编辑器。

> 适用版本：`madong v5.1.0` 重构后的标准版仓库
> - 后端：`backend/`（PHP 8.2 + Webman 2.2 + Laravel Eloquent）
> - 前端：**一个后端拖多个 UI 前端**——`template/admin`(固定位置，内容可整体换为不同 UI 的等价模版，靠 package.json name 区分，如 `vue-vben-admin-ele` / `madong-vue` / `vue-vben-admin-antd`) + `template/web`(Nuxt 4 + Element Plus) + `template/install`(轻量安装向导)，全部消费同一后端 API
> - 安装向导：`template/install`

## 快速开始

### Windows
```powershell
# 一键同步全部（默认）
powershell -ExecutionPolicy Bypass -File skills\sync.ps1

# 只同步你用的编辑器（推荐）
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target codebuddy
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target cursor
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target trae
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target copilot
```

### macOS / Linux
```bash
chmod +x skills/sync.sh
./skills/sync.sh            # 全部
./skills/sync.sh codebuddy  # 只同步 CodeBuddy
```

执行后根据你使用的编辑器查看对应章节：

### CodeBuddy
1. 运行同步脚本
2. 打开 **设置 → 技能**，应看到所有技能
3. 对话中直接输入：`@backend-controller` 或描述需求自动触发

### Trae
| 功能 | 文件位置 |
|------|---------|
| 技能（Skills） | `.agents/skills/{name}/SKILL.md` |
| 规则（Rules） | `.trae/rules/{name}/rule.md` |

### Cursor
- 规则自动出现在 **Rules** 管理界面（需重启）
- 文件：`.cursor/rules/{name}/rule.mdc`

### GitHub Copilot
- 所有规范聚合在 `.github/copilot-instructions.md`，自动读取

---

## 技能源文件结构

```text
skills/
├── README.md                     # ← 本文件
├── sync.ps1                      # ← 同步脚本（Windows PowerShell）
├── sync.sh                       # ← 同步脚本（macOS / Linux bash）
├── backend/                      # 后端规范（分层 skill 均"一个文件覆盖框架层+插件端"）
│   ├── controller/               # 控制器（adminapi/api/install + 插件端，含命名空间对照表）
│   ├── service/                  # 服务层（注入 DAO / 事务，框架+插件）
│   ├── dao/                      # 数据访问层（BaseDao，框架+插件）
│   ├── model/                    # Eloquent 模型（软删除/雪花ID/Scope，框架+插件）
│   ├── enum/                     # PHP 8.1 原生枚举（框架+插件）
│   ├── schema/                   # DTO（Request/Response，框架+插件）
│   ├── validate/                 # 验证器（场景校验，框架+插件）
│   ├── route/                    # 路由注册（webman Route + 注解）
│   ├── middleware/               # 中间件
│   ├── event/                    # 事件
│   ├── listener/                 # 监听器
│   ├── config/                   # 配置体系（core.{group}.*）
│   ├── core/                     # 框架内核 core/ 分包约定
│   ├── generator/                # 全栈代码生成器（core/business/generator）
│   ├── plugin/                   # 插件体系「专有」部分（Install/config/info/resource + 命名空间根规律）
│   └── command/                  # 命令脚本体系（madong-plugin/make/install/config/metadata）
├── frontend/                     # 前端规范（一个后端拖多个 UI 前端）
│   ├── ARCHITECTURE.md           # ★ 总架构：一后端·多前端·多UI（必读）
│   ├── shared/                   # 跨 admin/web/install 共用（api 客户端 / i18n / 命名）
│   ├── admin/                    # ★ 主后台（固定目录位置，内容可整体换 UI，靠 package.json name 区分）
│   │   ├── SKILL.md              #   按 name 判定当前 UI + 规范
│   │   └── INSTANCES.md          #   可能的 UI 身份清单（ele / madong-vue / antd...互斥）
│   ├── web/                      # Nuxt 4 + Element Plus 后台（独立技术栈）
│   └── install/                  # 安装向导（轻量 Element Plus 应用）
└── cross/                        # 跨层规范
    ├── git-convention/           # Git 提交规范（lefthook + commitlint + czg）
    ├── commit-convention/        # 多仓库提交信息格式（scope 用法）
    ├── lint-format/              # Lint/Format（oxlint + eslint + stylelint + oxfmt）
    ├── database/                 # 数据库设计规范（表 / 字段 / 迁移）
    └── api-convention/           # 前后端 API 对接规范（所有前端共用契约）
```

### ★ 核心架构：一个后端拖多个 UI 前端
- `backend/` 是**单一数据源与业务逻辑中心**，不感知前端 UI。
- `template/admin` 是**固定目录位置，内容可整体替换为功能等价、UI 不同的模版**（当前：`vue-vben-admin-ele`；另可来自 gitee `motion-code/madong-vue`；未来可能 `vue-vben-admin-antd`）。任意时刻只生效其中一种，**靠 `package.json` 的 `name` 区分当前是哪套 UI**。
- `template/web`（Nuxt 4）与 `template/install`（轻量 Ele）是另外两个独立前端壳，同样消费同一后端。
- 所有前端共享同一套 API 契约（见 `cross-api-convention`），**禁止为某个 UI 改后端契约**。
- 详见 `frontend/ARCHITECTURE.md`，改 admin 前先读 `frontend/admin/SKILL.md` 的「§0 判定 UI」章节。

---

## 按场景选择

| 场景 | 推荐技能 |
|------|---------|
| 写后端 CRUD | backend/controller + service + dao + model + validate + schema + route |
| 写 Admin 页面（任意 UI） | frontend/admin（先 §0 按 name 判定 UI）+ frontend/shared/* |
| 切换/替换 admin 的 UI | frontend/ARCHITECTURE + frontend/admin/INSTANCES + frontend/admin §4 |
| 写 Web(Nuxt) 页面 | frontend/web/* + frontend/shared/* |
| 写 Install 页面 | frontend/install/* |
| 写/接插件（plugin） | backend/plugin/* + backend/command（madong-plugin:*） |
| 脚手架/命令脚本 | backend/command/* |
| 代码生成 | backend/generator/* + backend/command（madong-make:*） |
| 整体项目开发 | 以上全部 + cross/* |

## 关键命令速查（backend）
```bash
# 插件
php webman madong-plugin:develop:create <snake_name> <Title>   # 新建插件模板
php webman madong-plugin:develop:build <name>                  # 构建插件
php webman madong-plugin:install <name>                        # 安装（建表/导菜单/部署前端）
php webman madong-plugin:uninstall <name>                      # 卸载
php webman madong-plugin:list                                  # 列出插件

# 单文件脚手架（stub 在 app/command/make/stubs）
php webman madong-make:controller <Name>
php webman madong-make:service <Name>
php webman madong-make:dao <Name>
php webman madong-make:model <Name>
php webman madong-make:validate <Name>
php webman madong-make:middleware <Name>

# 安装 / 配置 / 元数据
php webman install:madong               # 系统安装
php webman madong-download:template <name>
php webman madong-config:mysql          # 写 MySQL 配置
php webman madong:migrate-admin-menu     # 同步后台菜单
php webman madong:permission:collect     # 收集权限码
```
> 命令基于 Symfony Console，注册用 `#[AsCommand]`，基类 `app\command\BaseCommand`（支持 SSE）。详见 `backend/command`。

---

## 项目通用规范（供 AI 参考）

### 技术栈
- 后端：PHP 8.2 + Workerman Webman 2.2 + **Laravel Eloquent 11**（使用 `Illuminate\Database\Eloquent`，**非 ThinkPHP**）

> ⚠️ **ORM 栈禁令（扫描/生成时务必遵守）**：本项目数据层只用 Laravel Eloquent，**严禁 ThinkPHP 风格写法**。
> - 基类命名空间均为 `core\foundation\base\`（注意是 **foundation**，不是 `found`）。
> - 模型：`class X extends core\foundation\base\BaseModel`，字段用 `$table`/`$fillable`/`$timestamps`，软删除用 `SoftDeletes` trait。
> - 查询一律走 Eloquent：`getModel()->query()`、`->where()`、`->find()`、`->first()`、`->get()`、`->paginate()`、`->create()`、`->update()`、`->delete()`、`->destroy()`。
> - 严禁：ThinkPHP 的 `Db::name()`、`->where()->find()`、`->inc()`、`->dec()`、`->value()`、`->column()`、`->insertGetId()`、`fetchSql()`、`->findOrEmpty()`、`->saveAll()` 等；这些会导致逻辑错误，且易与本项目栈混淆。
> - 框架内仅有的 `Db::`（如 `MigrateCommand.php`）是 Laravel 的 `Illuminate\Support\Facades\DB`，属正确用法，不要改动。
- 前端：`template/admin` = Vue 3 + Vite + TypeScript + **Vben Admin 5.7（当前生效 UI 由 package.json name 决定；默认 `vue-vben-admin-ele`/Element Plus，可整体替换为 `madong-vue` 等等价模版）** + Pinia
- 前端：`template/web` = Nuxt 4 + TypeScript + Vite + Element Plus + Pinia + UnoCSS
- 数据库：MySQL 8.0+（多租户）
- 实时通信：SSE（Server-Sent Events）

### 命名总则
| 场景 | 规范 | 示例 |
|------|------|------|
| 控制器类 | 大驼峰 + `Controller` 后缀 | `MenuController` |
| 服务类 | 大驼峰 + `Service` 后缀 | `MenuService` |
| DAO 类 | 大驼峰 + `Dao` 后缀 | `MenuDao` |
| 模型类 | 大驼峰（无后缀） | `Menu` |
| 验证器类 | 大驼峰 + `Validate` 后缀 | `MenuValidate` |
| Schema Request | 大驼峰 + `Request` 后缀 | `MenuCreateRequest` |
| Schema Response | 大驼峰 + `Response` 后缀 | `MenuResponse` |
| 枚举类 | 大驼峰（无后缀，PHP enum） | `MenuType` |
| 中间件类 | 大驼峰 + `Middleware` 后缀 | `AdminAuthMiddleware` |
| 数据库表 | `{prefix}_{module}_{table}` | `system_menu`、`member_user` |
| 数据库字段 | snake_case | `created_at`、`parent_id` |
| 路由/权限码 | `{app}.{module}.{action}` / `{module}:{model}:{action}` | `adminapi.menu.update` / `system:menu:update` |
| 前端组件 | 大驼峰 .vue | `MenuModal.vue` |
| 前端 API 函数 | 小驼峰 | `getMenuList`、`createMenu` |
| 前端路由 code | `{App}{Module}{Action}` | `SystemMenuList` |
| JSON 响应字段 | snake_case | `items`、`total`、`page_no`、`page_size` |
| 目录/文件名 | kebab-case | `system/menu/index.vue` |

### 控制器继承链
```
adminapi:  Controller → Crud → Base(BaseController)   [app/adminapi/controller/]
api:       Controller → Base(BaseController)          [app/api/controller/]
```
基类均位于 `core/foundation/base/`（`core\foundation\base` 命名空间）。

### Git 提交规范
```
<type>(<scope>): <subject>
```
| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `refactor` | 重构 |
| `style` | UI 样式变更 |
| `perf` | 性能优化 |
| `chore` | 构建/工具/配置变更 |
| `docs` | 文档更新 |
| `test` | 测试相关 |
| `revert` | 回退 |
| `types` | 类型定义变更 |
| `release` | 发版 |

| scope | 说明 |
|-------|------|
| `backend` | 后端 |
| `admin` | Vben 后台前端 |
| `web` | Nuxt 后台前端 |
| `install` | 安装向导前端 |
| `project` | 项目级 |
| `lint` | Lint 配置 |
| `ci` | CI 配置 |
| `deploy` | 部署 |
| `other` | 其他 |

```
feat(admin): 新增会员积分管理页面
fix(web): 修复租户列表分页问题
refactor(backend): 重构菜单服务的查询逻辑
chore(backend): 升级 webman 框架到 2.2
```
