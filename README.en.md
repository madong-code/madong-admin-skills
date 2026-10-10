<div align="center">

<img src="https://raw.githubusercontent.com/madong-code/madong-admin/main/public/logo.png" alt="Madong Logo" width="120" />

# Madong SaaS Skills

Project AI skill library (MDAdmin Standard Edition) — help AI understand your project conventions

[![Version](https://img.shields.io/badge/madong-v5.1.0-2488C9)](https://github.com/madong-code/madong-admin)
[![Skills](https://img.shields.io/badge/Domains-backend%20%C2%B7%20frontend%20%C2%B7%20cross-7C3AED)](#choose-by-scenario)
[![AI Editors](https://img.shields.io/badge/AI%20editors-11-10B981)](#quick-start)
[![License](https://img.shields.io/badge/License-MIT-green)](./LICENSE)

[中文](./README.md) | **English**

</div>

Covers three domains — backend, front-end and cross-cutting — and distributes to various AI editors with one command.

> Target version: the `madong v5.1.0` refactored standard-edition repository
> - Backend: `backend/` (PHP 8.2 + Webman 2.2 + Laravel Eloquent)
> - Front-end: **one backend pulling multiple UI front-ends** — `template/admin` (fixed location, content can be swapped wholesale for an equivalent template of a different UI, distinguished by `package.json` name, e.g. `vue-vben-admin-ele` / `madong-vue` / `vue-vben-admin-antd`) + `template/web` (Nuxt 4 + Element Plus) + `template/install` (lightweight installer), all consuming the same backend API
> - Installer: `template/install`

## Quick Start

### Windows
```powershell
# Sync everything (default)
powershell -ExecutionPolicy Bypass -File skills\sync.ps1

# Sync only the editor(s) you use (recommended)
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target codebuddy
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target cursor
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target trae
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target copilot
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target claude
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target windsurf
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target cline
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target roo
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target gemini
powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target qwen
```

### macOS / Linux
```bash
chmod +x skills/sync.sh
./skills/sync.sh            # all
./skills/sync.sh codebuddy  # CodeBuddy only
./skills/sync.sh claude windsurf cline roo gemini qwen  # a few of them
```

After running, refer to the section for your editor:

### CodeBuddy
1. Run the sync script
2. Open **Settings → Skills**; all skills should be visible
3. In chat, type `@backend-controller` directly, or describe a need to trigger automatically

### Trae
| Feature | File location |
|---------|---------------|
| Skills | `.agents/skills/{name}/SKILL.md` |
| Rules | `.trae/rules/{name}/rule.md` |

### Cursor
- Rules appear automatically in the **Rules** manager (restart required)
- File: `.cursor/rules/{name}/rule.mdc`

### GitHub Copilot
- All conventions are aggregated in `.github/copilot-instructions.md` and read automatically

### Claude Code
| Feature | File location |
|---------|---------------|
| Skills | `.claude/skills/{name}/SKILL.md`, reference via `@skill-name` in chat |

### Windsurf
| Feature | File location |
|---------|---------------|
| Rules | `.windsurf/rules/{name}/rule.md` |

### Cline
| Feature | File location |
|---------|---------------|
| Rules | `.clinerules/{name}.md` |

### Roo Code
| Feature | File location |
|---------|---------------|
| Rules | `.roo/rules/{name}.md` |

### Gemini CLI
- All conventions aggregated in `GEMINI.md`, read automatically

### Qwen Code
- All conventions aggregated in `QCLAUDE.md`, read automatically

---

## Skill Source Structure

```text
skills/
├── README.md                     # ← this file
├── sync.ps1                      # ← sync script (Windows PowerShell)
├── sync.sh                       # ← sync script (macOS / Linux bash)
├── backend/                      # Backend conventions (each layered skill covers "framework layer + plugin side" in one file)
│   ├── controller/               # Controllers (adminapi/api/install + plugin side, with namespace mapping table)
│   ├── service/                  # Service layer (inject DAO / transactions, framework + plugin)
│   ├── dao/                      # Data access layer (BaseDao, framework + plugin)
│   ├── model/                    # Eloquent models (soft delete / snowflake ID / Scope, framework + plugin)
│   ├── enum/                     # PHP 8.1 native enums (framework + plugin)
│   ├── schema/                   # DTOs (Request/Response, framework + plugin)
│   ├── validate/                 # Validators (scenario validation, framework + plugin)
│   ├── route/                    # Route registration (webman Route + annotations)
│   ├── middleware/               # Middleware
│   ├── event/                    # Events
│   ├── listener/                 # Listeners
│   ├── config/                   # Configuration system (core.{group}.*)
│   ├── core/                     # Framework core core/ package conventions
│   ├── generator/                # Full-stack code generator (core/business/generator)
│   ├── plugin/                   # Plugin system "specific" parts (Install/config/info/resource + namespace root pattern)
│   └── command/                  # Command script system (madong-plugin/make/install/config/metadata)
├── frontend/                     # Front-end conventions (one backend, multiple UI front-ends)
│   ├── ARCHITECTURE.md           # ★ Overall architecture: one backend · many front-ends · many UIs (must-read)
│   ├── shared/                   # Shared across admin/web/install (api client / i18n / naming)
│   ├── admin/                    # ★ Main admin (fixed directory location; UI can be swapped wholesale, distinguished by package.json name)
│   │   ├── SKILL.md              #   Determine current UI by name + conventions
│   │   └── INSTANCES.md          #   Possible UI identities (ele / madong-vue / antd ... mutually exclusive)
│   ├── web/                      # Nuxt 4 + Element Plus admin (independent stack)
│   └── install/                  # Installer (lightweight Element Plus app)
└── cross/                        # Cross-cutting conventions
    ├── git-convention/           # Git commit convention (lefthook + commitlint + czg)
    ├── commit-convention/        # Commit message format (plugin name scope only)
    ├── lint-format/              # Lint/Format (oxlint + eslint + stylelint + oxfmt)
    ├── database/                 # Database design conventions (tables / fields / migrations)
    └── api-convention/           # Front-end/back-end API contract (shared by all front-ends)
```

### ★ Core Architecture: one backend pulling multiple UI front-ends
- `backend/` is the **single source of data and business logic**, unaware of the front-end UI.
- `template/admin` is a **fixed directory location whose content can be swapped wholesale for a functionally equivalent template of a different UI** (current: `vue-vben-admin-ele`; also available from Gitee `motion-code/madong-vue`; future `vue-vben-admin-antd`). Only one UI is active at any time, **distinguished by the `package.json` `name`**.
- `template/web` (Nuxt 4) and `template/install` (lightweight Ele) are two other independent front-end shells, also consuming the same backend.
- All front-ends share the same API contract (see `cross-api-convention`); **do not change the backend contract for a particular UI**.
- See `frontend/ARCHITECTURE.md`; read the "§0 Determine UI" section in `frontend/admin/SKILL.md` before modifying admin.

---

## Choose by Scenario

| Scenario | Recommended skills |
|----------|--------------------|
| Write backend CRUD | backend/controller + service + dao + model + validate + schema + route |
| Write an Admin page (any UI) | frontend/admin (first §0 determine UI by name) + frontend/shared/* |
| Switch / replace admin UI | frontend/ARCHITECTURE + frontend/admin/INSTANCES + frontend/admin §4 |
| Write Web (Nuxt) page | frontend/web/* + frontend/shared/* |
| Write Install page | frontend/install/* |
| Write / integrate a plugin | backend/plugin/* + backend/command (madong-plugin:*) |
| Scaffolding / command scripts | backend/command/* |
| Code generation | backend/generator/* + backend/command (madong-make:*) |
| Whole-project development | all of the above + cross/* |

## Quick Command Reference (backend)
```bash
# Plugins
php webman madong-plugin:develop:create <snake_name> <Title>   # create a plugin template
php webman madong-plugin:develop:build <name>                  # build a plugin
php webman madong-plugin:install <name>                        # install (create tables / import menu / deploy front-end)
php webman madong-plugin:uninstall <name>                      # uninstall
php webman madong-plugin:list                                  # list plugins

# Single-file scaffolding (stubs in app/command/make/stubs)
php webman madong-make:controller <Name>
php webman madong-make:service <Name>
php webman madong-make:dao <Name>
php webman madong-make:model <Name>
php webman madong-make:validate <Name>
php webman madong-make:middleware <Name>

# Install / config / metadata
php webman install:madong               # system install
php webman madong-download:template <name>
php webman madong-config:mysql          # write MySQL config
php webman madong:migrate-admin-menu     # sync admin menu
php webman madong:permission:collect     # collect permission codes
```
> Commands are based on Symfony Console, registered with `#[AsCommand]`, base class `app\command\BaseCommand` (supports SSE). See `backend/command`.

---

## General Project Conventions (for AI reference)

### Tech Stack
- Backend: PHP 8.2 + Workerman Webman 2.2 + **Laravel Eloquent 11** (uses `Illuminate\Database\Eloquent`, **not ThinkPHP**)

> ⚠️ **ORM stack prohibition (observe strictly when scanning/generating)**: this project's data layer uses only Laravel Eloquent; **ThinkPHP-style code is strictly forbidden**.
> - Base class namespaces are all `core\foundation\base\` (note: **foundation**, not `found`).
> - Models: `class X extends core\foundation\base\BaseModel`, fields via `$table`/`$fillable`/`$timestamps`, soft delete via the `SoftDeletes` trait.
> - Queries always go through Eloquent: `getModel()->query()`, `->where()`, `->find()`, `->first()`, `->get()`, `->paginate()`, `->create()`, `->update()`, `->delete()`, `->destroy()`.
> - Forbidden: ThinkPHP's `Db::name()`, `->where()->find()`, `->inc()`, `->dec()`, `->value()`, `->column()`, `->insertGetId()`, `fetchSql()`, `->findOrEmpty()`, `->saveAll()`, etc. — these cause logic errors and easily confuse the stack.
> - The only `Db::` in the framework (e.g. `MigrateCommand.php`) is Laravel's `Illuminate\Support\Facades\DB`, which is correct usage; do not change it.
- Front-end: `template/admin` = Vue 3 + Vite + TypeScript + **Vben Admin 5.7 (the active UI is decided by package.json name; default `vue-vben-admin-ele` / Element Plus, can be swapped wholesale for `madong-vue` etc.)** + Pinia
- Front-end: `template/web` = Nuxt 4 + TypeScript + Vite + Element Plus + Pinia + UnoCSS
- Database: MySQL 8.0+ (multi-tenant)
- Real-time: SSE (Server-Sent Events)

### Naming Conventions
| Scenario | Convention | Example |
|----------|------------|---------|
| Controller class | PascalCase + `Controller` suffix | `MenuController` |
| Service class | PascalCase + `Service` suffix | `MenuService` |
| DAO class | PascalCase + `Dao` suffix | `MenuDao` |
| Model class | PascalCase (no suffix) | `Menu` |
| Validator class | PascalCase + `Validate` suffix | `MenuValidate` |
| Schema Request | PascalCase + `Request` suffix | `MenuCreateRequest` |
| Schema Response | PascalCase + `Response` suffix | `MenuResponse` |
| Enum class | PascalCase (no suffix, PHP enum) | `MenuType` |
| Middleware class | PascalCase + `Middleware` suffix | `AdminAuthMiddleware` |
| Database table | `{prefix}_{module}_{table}` | `system_menu`, `member_user` |
| Database field | snake_case | `created_at`, `parent_id` |
| Route / permission code | `{app}.{module}.{action}` / `{module}:{model}:{action}` | `adminapi.menu.update` / `system:menu:update` |
| Front-end component | PascalCase .vue | `MenuModal.vue` |
| Front-end API function | camelCase | `getMenuList`, `createMenu` |
| Front-end route code | `{App}{Module}{Action}` | `SystemMenuList` |
| JSON response field | snake_case | `items`, `total`, `page_no`, `page_size` |
| Directory / file name | kebab-case | `system/menu/index.vue` |

### Controller Inheritance Chain
```
adminapi:  Controller → Crud → Base(BaseController)   [app/adminapi/controller/]
api:       Controller → Base(BaseController)          [app/api/controller/]
```
Base classes are located in `core/foundation/base/` (namespace `core\foundation\base`).

### Git Commit Convention (backend monorepo)
```
<type>: <subject>               # no scope by default
<type>(<plugin-name>): <subject> # only for changes inside plugin/<plugin-name>/
```
| type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Refactoring |
| `style` | UI / style changes |
| `perf` | Performance improvement |
| `chore` | Build / tooling / config changes |
| `docs` | Documentation updates |
| `test` | Test-related |
| `revert` | Revert |
| `types` | Type definition changes |
| `release` | Release |

scope = plugin directory name (lowercase), used only for changes inside `plugin/`, e.g. `cms`, `pay`, `workflow`; all other changes have no scope.

```
feat(cms): add content model and column management
fix(pay): fix duplicate signature verification on callback
feat: add member points management page
fix: fix tenant list pagination issue
refactor: refactor menu service query logic
chore: upgrade webman framework to 2.2
```
