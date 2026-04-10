---
name: madong-frontend
description: Generate Vue frontend pages for madong module. Supports both app (main project) and plugin targets. Creates index.vue with BasicCrud, schemas, and API service files following madong frontend conventions.
---

# Step 7: Generate Frontend Pages

Create Vue frontend pages and API service for module.

## File Locations

**App (主项目):**
```
frontend/admin/src/apps/{module}/
├── views/{model}/index.vue
├── views/{model}/schemas/index.tsx
├── api/{module}/index.ts
└── locales/lang/
    ├── zh-cn/{module}.json
    └── en/{module}.json
```

**Plugin (插件):**
```
resource/template/admin/views/{module}/{model}/index.vue
resource/template/admin/views/{module}/{model}/schemas/index.tsx

frontend/admin/src/apps/{plugin}/
├── api/{module}/index.ts
└── locales/lang/
    ├── zh-cn/{module}.json
    └── en/{module}.json
```

## i18n Key Pattern

| Target | Pattern | Example |
|--------|---------|---------|
| App | `{module}.{model}.*` | `ask.question.*` |
| Plugin | `{plugin}.{module}.{model}.*` | `official.ask.question.*` |

## index.vue Template

```vue
<template>
  <div class="{model}-page art-full-height">
    <BasicCrud />
  </div>
</template>

<script setup lang="tsx">
import { useCrud } from "@/components/crud";
import { crudSchema } from "./schemas";
import { $t } from "@/locales";

const [BasicCrud, crudApi] = useCrud({
  ...crudSchema(),
  beforeFetch: (params: any) => {
    return params;
  },
  // Custom table actions
  tableActions: [
    {
      label: $t('{i18n_prefix}.{model}.actions.detail'),
      type: "primary",
      sort: -1,
      link: true,
      icon: "ant-design:eye-outlined",
      auth: "{permission}:read",
      onClick(e: Event, record: any) {},
    },
  ],
  // Custom dropdown actions
  dropDownActions: [
    {
      label: $t('{i18n_prefix}.{model}.actions.edit'),
      type: "primary",
      sort: -1,
      link: true,
      icon: "ant-design:edit-outlined",
      auth: "{permission}:update",
      onClick(e: Event, record: any) {},
    },
    {
      label: $t('{i18n_prefix}.{model}.actions.delete'),
      type: "danger",
      sort: -1,
      link: true,
      icon: "ant-design:delete-outlined",
      auth: "{permission}:delete",
      onClick(e: Event, record: any) {},
    },
  ],
});
</script>
```

## schemas/index.tsx Template

```typescript
import { {Model}Service } from '@/apps/{app_name}/api/{module}'
import { DictEnum } from '@/apps/{app_name}/enums/dict-enum'
import { CrudSchema } from '@/components/crud'
import { formatDateTime } from '@/utils'
import { h } from 'vue'
import { ElTag } from 'element-plus'
import { $t } from '@/locales'

// CRUD配置
export const crudSchema = (): CrudSchema => {
  return {
    // 接口地址
    api: {Model}Service.list,
    dialogTitle: $t('{i18n_prefix}.{model}.dialog_title'),
    crudApi: {
      remove: {Model}Service.remove,
      view: {Model}Service.get,
      add: {Model}Service.create,
      edit: {Model}Service.update,
    },
    useCrud: true,
    hasAdd: true,
    hasRemove: true,
    hasEdit: true,
    hasView: true,
    addAuth: '{permission}:create',
    removeAuth: '{permission}:delete',
    editAuth: '{permission}:update',
    viewAuth: '{permission}:read',
    rowKey: 'id',
    columns: [
      {
        type: 'selection'
      },
      {
        prop: 'id',
        label: $t('{i18n_prefix}.{model}.table.columns.id'),
        align: 'center',
        width: 80,
        visible: false
      },
      {
        prop: 'name',
        label: $t('{i18n_prefix}.{model}.table.columns.name'),
        align: 'left',
        minWidth: 150,
        showOverflowTooltip: true
      },
      {
        prop: 'sort',
        label: $t('{i18n_prefix}.{model}.table.columns.sort'),
        align: 'center',
        width: 100,
      },
      {
        prop: 'status',
        label: $t('{i18n_prefix}.{model}.table.columns.status'),
        align: 'center',
        width: 100,
        component: 'ApiDict',
        componentProps: {
          code: DictEnum.SYS_NORMAL_DISABLE
        }
      },
      {
        prop: 'created_at',
        label: $t('{i18n_prefix}.{model}.table.columns.created_at'),
        minWidth: 170,
        align: 'center',
        formatter: (row: any) => {
          return formatDateTime(row.created_at)
        }
      },
      {
        type: 'operate',
        label: $t('common.operate'),
        align: 'center',
        width: 150,
        fixed: 'right',
      }
    ],
    dialogProps: {
      width: '50%',
    },
    searchFormSchema: {
      labelWidth: '100px',
      schema: [
        {
          label: $t('{i18n_prefix}.{model}.search_form.name'),
          prop: 'name',
          component: 'Input',
          colSpan: 6,
          componentProps: {
            placeholder: $t('{i18n_prefix}.{model}.search_form.name_placeholder')
          }
        },
        {
          label: $t('{i18n_prefix}.{model}.search_form.status'),
          prop: 'status',
          component: 'ApiDict',
          colSpan: 6,
          componentProps: {
            code: DictEnum.SYS_NORMAL_DISABLE,
            placeholder: $t('{i18n_prefix}.{model}.search_form.status_placeholder')
          }
        }
      ]
    },
    formSchema: {
      labelWidth: 120,
      gutter: 20,
      schema: [
        {
          label: $t('{i18n_prefix}.{model}.form.name'),
          prop: 'name',
          component: 'Input',
          componentProps: {
            placeholder: $t('{i18n_prefix}.{model}.form.name_placeholder'),
            maxlength: 50
          },
          colSpan: 24,
          rules: [{ required: true, message: $t('{i18n_prefix}.{model}.validate.name_required') }]
        },
        {
          label: $t('{i18n_prefix}.{model}.form.sort'),
          prop: 'sort',
          component: 'InputNumber',
          componentProps: {
            placeholder: $t('{i18n_prefix}.{model}.form.sort_placeholder'),
            min: 0,
            max: 9999
          },
          colSpan: 24,
        },
        {
          label: $t('{i18n_prefix}.{model}.form.status'),
          prop: 'status',
          component: 'ApiDict',
          componentProps: {
            code: DictEnum.SYS_NORMAL_DISABLE
          },
          colSpan: 24,
          rules: [{ required: true, message: $t('{i18n_prefix}.{model}.validate.status_required') }]
        }
      ]
    }
  }
}
```

## API Service Template

```typescript
import http from "@/support/http";

/**
 * {Model} API 服务
 */
export const {Model}Service = {
  /**
   * 获取列表
   */
  list: '/{api_prefix}',

  /**
   * 获取详情
   */
  get: '/{api_prefix}/{id}',

  /**
   * 创建
   */
  create: '/{api_prefix}',

  /**
   * 更新
   */
  update: '/{api_prefix}/{id}',

  /**
   * 删除
   */
  remove: '/{api_prefix}/{id}',

  /**
   * 批量删除
   */
  batchRemove: '/{api_prefix}',

  /**
   * 获取选项列表
   */
  select: '/{api_prefix}',

  /**
   * 自定义方法 - 设置状态
   */
  setStatus: (id: number, status: number) => {
    return http.post(`/{api_prefix}/status`, { id, status });
  },
};
```

## Complete Example (App)

### File: frontend/admin/src/apps/ask/api/question/index.ts

```typescript
import http from "@/support/http";

export const QuestionService = {
  list: '/ask/question',
  get: '/ask/question/{id}',
  create: '/ask/question',
  update: '/ask/question/{id}',
  remove: '/ask/question/{id}',
  batchRemove: '/ask/question',
  select: '/ask/question',
};
```

### i18n: frontend/admin/src/apps/ask/locales/lang/zh-cn/question.json

```json
{
  "ask": {
    "question": {
      "dialog_title": "问题管理",
      "table": {
        "columns": {
          "id": "ID",
          "title": "标题",
          "category_id": "分类",
          "price": "价格",
          "status": "状态",
          "created_at": "创建时间"
        }
      },
      "search_form": {
        "title": "标题",
        "title_placeholder": "请输入标题",
        "status": "状态",
        "status_placeholder": "请选择状态"
      },
      "form": {
        "title": "标题",
        "title_placeholder": "请输入标题",
        "category_id": "分类",
        "price": "价格",
        "status": "状态"
      },
      "actions": {
        "detail": "详情",
        "edit": "编辑",
        "delete": "删除"
      },
      "validate": {
        "title_required": "请输入标题"
      }
    }
  }
}
```

## Complete Example (Plugin)

### File: frontend/admin/src/apps/official/api/question/index.ts

```typescript
import http from "@/support/http";

export const QuestionService = {
  list: '/ask/question',
  get: '/ask/question/{id}',
  create: '/ask/question',
  update: '/ask/question/{id}',
  remove: '/ask/question/{id}',
  batchRemove: '/ask/question',
  select: '/ask/question',
};
```

### i18n: frontend/admin/src/apps/official/locales/lang/zh-cn/question.json

```json
{
  "official": {
    "ask": {
      "question": {
        "dialog_title": "问题管理",
        "table": {
          "columns": {
            "id": "ID",
            "title": "标题",
            "category_id": "分类",
            "price": "价格",
            "status": "状态",
            "created_at": "创建时间"
          }
        },
        "search_form": {
          "title": "标题",
          "title_placeholder": "请输入标题",
          "status": "状态",
          "status_placeholder": "请选择状态"
        },
        "form": {
          "title": "标题",
          "title_placeholder": "请输入标题",
          "category_id": "分类",
          "price": "价格",
          "status": "状态"
        },
        "actions": {
          "detail": "详情",
          "edit": "编辑",
          "delete": "删除"
        },
        "validate": {
          "title_required": "请输入标题"
        }
      }
    }
  }
}
```

## Column Component Types

| Component | Description |
|-----------|-------------|
| `ApiDict` | Dictionary select (uses DictEnum codes) |
| `ApiSelect` | API-based select dropdown |
| `Input` | Text input |
| `InputNumber` | Number input |
| `DatePicker` | Date picker |
| `DateTimePicker` | Date time picker |
| `Switch` | Toggle switch |
| `RadioGroup` | Radio group |
| `CheckboxGroup` | Checkbox group |
| `Upload` | File upload |
| `ImageUpload` | Image upload |
| `Editor` | Rich text editor |

## DictEnum Common Codes

| Code | Description |
|------|-------------|
| `DictEnum.SYS_NORMAL_DISABLE` | Status: Normal/Disable |
| `DictEnum.YES_NO` | Yes/No |
| `DictEnum.USER_SEX` | User gender |

## Auto-generation Checklist

When generating frontend:
- [ ] Create directory structure based on target (app/plugin)
- [ ] Generate index.vue with BasicCrud
- [ ] Generate schemas/index.tsx with CRUD config
- [ ] Generate API service file
- [ ] Generate i18n JSON files (zh-cn and en)
- [ ] Use $t() for all text
- [ ] Use proper i18n key pattern based on target
- [ ] Use proper DictEnum codes
- [ ] Configure proper permissions
