# Madong Skills 技能库

本目录包含 Madong 框架的 **AI 技能库**，覆盖**代码生成**和**项目规范**两大领域，采用三层分类结构（backend/frontend/cross），支持一键同步到所有主流 AI 编辑器。

## 快速开始

### 同步到 AI 编辑器

```powershell
# 一键同步全部（CodeBuddy + Cursor + Trae + Copilot）
powershell -ExecutionPolicy Bypass -File madong-skills\sync.ps1

# 只同步你用的编辑器（推荐）
powershell -ExecutionPolicy Bypass -File madong-skills\sync.ps1 -target codebuddy
powershell -ExecutionPolicy Bypass -File madong-skills\sync.ps1 -target cursor
powershell -ExecutionPolicy Bypass -File madong-skills\sync.ps1 -target trae
powershell -ExecutionPolicy Bypass -File madong-skills\sync.ps1 -target copilot
```

### 生成完整 CRUD

```
create CRUD for articles app
create CRUD for articles plugin
create CRUD for articles no-api
```

参数说明：
- `articles` - 模块名称
- `app` - 主项目
- `plugin` - 插件
- `no-api` - 不生成 API 层

### 分步生成

```
generate model for article
generate dao for article
generate service for article
generate controller for article
generate validate for article
generate schema for article
```

## 目录结构

```
madong-skills/
├── README.md                     # 本文件
├── sync.ps1                       # 跨编辑器同步脚本
├── backend/                       # 后端 34 项（代码生成 + 项目规范）
│   ├── gen-crud/                 # [生成] CRUD 总编排
│   ├── gen-parse/                # [生成] 表解析
│   ├── gen-migrate/              # [生成] 数据库迁移
│   ├── gen-model/                # [生成] Eloquent 模型
│   ├── gen-controller/           # [生成] AdminAPI 控制器
│   ├── gen-api-controller/       # [生成] 前台 API 控制器
│   ├── gen-validate/             # [生成] 验证器
│   ├── gen-service/              # [生成] 后台服务层
│   ├── gen-api-service/          # [生成] 前台 API 服务层
│   ├── gen-dao/                  # [生成] 数据访问层
│   ├── gen-schema/               # [生成] Schema DTO
│   ├── gen-event/                # [生成] 事件
│   ├── gen-listener/             # [生成] 监听器
│   ├── route/                    # [生成+规范] 路由配置
│   ├── lang/                     # [生成+规范] 后端国际化
│   ├── logger/                   # [生成+规范] 日志集成
│   ├── tests/                    # [生成+规范] 测试规范
│   ├── config/                   # [规范] 配置体系
│   ├── bootstrap/                # [规范] 启动引导
│   ├── enum/                     # [规范] 枚举
│   ├── middleware/               # [规范] 中间件
│   ├── exception/                # [规范] 异常体系
│   ├── swagger/                  # [规范] Swagger/OpenAPI 注解
│   ├── command/                  # [规范] 命令行命令
│   ├── crontab/                  # [规范] 定时任务
│   ├── process/                  # [规范] 自定义进程
│   ├── queue/                    # [规范] Redis 队列
│   ├── scope/                    # [规范] 数据权限作用域
│   ├── upload/                   # [规范] 文件上传
│   ├── cache/                    # [规范] 缓存策略
│   ├── monitor/                  # [规范] 系统监控
│   ├── notify/                   # [规范] 消息通知
│   ├── excel/                    # [规范] Excel 导入导出
│   └── generator/                # [规范] 代码生成器
├── frontend/                     # 前端 14 项
│   ├── admin/                    # 管理后台 (Vue 3 + Element Plus)
│   │   ├── gen/                  # [生成] Vue 页面生成
│   │   ├── i18n/                 # [生成] 前端国际化
│   │   ├── view/                 # [规范] 视图层
│   │   ├── api/                  # [规范] API 层
│   │   ├── component/            # [规范] 公共组件
│   │   ├── store/                # [规范] Pinia 状态管理
│   │   ├── router/               # [规范] 路由
│   │   └── common/               # [规范] 公共规范
│   └── web/                      # 前台网站 (Nuxt 4)
│       ├── view/                 # [规范] 页面
│       ├── api/                  # [规范] API 层
│       ├── component/            # [规范] 组件
│       ├── store/                # [规范] 状态管理
│       ├── layout/               # [规范] 布局
│       └── common/               # [规范] 公共规范
└── cross/                        # 跨层 3 项
    ├── api-convention/           # [规范] API 对接规范
    ├── database/                 # [规范] 数据库设计规范
    └── app-skeleton/             # [规范] 站点脚手架规范
```

## Target 参数说明

所有生成类 Skills 支持 `target` 参数来区分主项目和插件：

| 参数值 | 说明 | 命名空间 |
|--------|------|----------|
| `app` | 主项目 | `app\{module}\...` |
| `plugin` | 插件 | `plugin\{Plugin}\app\...` |

## 统一路径变量

| 变量 | App | Plugin |
|------|-----|--------|
| `{ns}` | `app` | `plugin\{Plugin}\app` |
| `{prefix}` | (空) | `plugin\{Plugin}` |
| `{model_ns}` | `app\model` | `plugin\{Plugin}\app\model` |
| `{dao_ns}` | `app\dao` | `plugin\{Plugin}\app\dao` |
| `{service_ns}` | `app\service\admin` | `plugin\{Plugin}\app\service\admin` |

## 技术栈

- **后端**：PHP 8.2+ / Workerman Webman 2.2+ / Laravel Eloquent 11+
- **管理后台**：Vue 3 + TypeScript + Element Plus + VxeTable + Pinia
- **前台网站**：Vue 3 + Nuxt 4 + Element Plus + UnoCSS
- **数据库**：MySQL 8.0+（雪花 ID 主键）
- **API 文档**：OpenAPI/Swagger（注解自动生成）
- **认证**：JWT（AccessTokenMiddleware）
- **权限**：`#[Permission]` 属性注解

## 按场景选择技能

| 场景 | 推荐技能 |
|------|---------|
| **生成 CRUD** | gen-crud（自动编排所有 gen-* 子技能） |
| **后端开发** | backend/ 下所有 gen-* + 规范 |
| **前端开发** | frontend/admin/ + cross/api-convention |
| **前台网站** | frontend/web/ + cross/api-convention |
| **架构设计** | cross/database + cross/app-skeleton |

## 同步目标

执行 `sync.ps1` 后，技能文件被分发到：

| 编辑器 | 位置 | 格式 |
|--------|------|------|
| **CodeBuddy** | `.codebuddy/skills/{name}/SKILL.md` | 直接复制 |
| **Cursor** | `.cursor/rules/{name}/rule.mdc` | 直接复制 |
| **Trae Rules** | `.trae/rules/{name}/rule.md` | 转换 frontmatter |
| **Trae Skills** | `.agents/skills/{name}/SKILL.md` | 直接复制 |
| **GitHub Copilot** | `.github/copilot-instructions.md` | 聚合 Markdown |
