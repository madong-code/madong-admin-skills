---
name: madong-i18n-frontend
description: Generate frontend i18n translation files for madong plugin module. Creates JSON translation files with proper key patterns for both zh-cn and en languages.
---

# Step 9: Generate Frontend i18n

Generate JSON translation files for plugin module frontend.

## File Locations

```
frontend/admin/src/apps/{plugin}/locales/lang/zh-cn/{module}.json
frontend/admin/src/apps/{plugin}/locales/lang/en/{module}.json
```

## Translation Key Pattern

Frontend i18n uses dot notation: `{plugin}.{module}.{model}.*`

## Translation File Template (zh-cn)

```json
{
  "{plugin}.{module}.{model}": {
    "title": "{Model}管理",
    "dialog_title": "{Model}",
    "list_title": "{Model}列表",
    "add_title": "添加{Model}",
    "edit_title": "编辑{Model}",
    "detail_title": "{Model}详情",

    "table": {
      "columns": {
        "id": "ID",
        "name": "名称",
        "sort": "排序",
        "status": "状态",
        "created_at": "创建时间",
        "updated_at": "更新时间"
      }
    },

    "search_form": {
      "name": "名称",
      "name_placeholder": "请输入名称",
      "status": "状态",
      "status_placeholder": "请选择状态",
      "date_range": "创建时间",
      "date_range_placeholder": "请选择日期范围",
      "keywords": "关键词",
      "keywords_placeholder": "请输入关键词"
    },

    "form": {
      "name": "名称",
      "name_placeholder": "请输入名称",
      "name_rules": "请输入名称，最多50个字符",
      "sort": "排序",
      "sort_placeholder": "请输入排序值",
      "status": "状态",
      "status_placeholder": "请选择状态",
      "remark": "备注",
      "remark_placeholder": "请输入备注"
    },

    "validate": {
      "name_required": "请输入名称",
      "name_max": "名称最多50个字符",
      "status_required": "请选择状态"
    },

    "tips": {
      "add_success": "添加{Model}成功",
      "add_fail": "添加{Model}失败",
      "edit_success": "编辑{Model}成功",
      "edit_fail": "编辑{Model}失败",
      "delete_confirm": "确认删除该{Model}吗？",
      "delete_success": "删除{Model}成功",
      "delete_fail": "删除{Model}失败"
    },

    "status": {
      "normal": "正常",
      "disable": "禁用"
    },

    "actions": {
      "add": "新增",
      "edit": "编辑",
      "delete": "删除",
      "detail": "详情",
      "export": "导出",
      "import": "导入",
      "refresh": "刷新",
      "reset": "重置",
      "search": "查询",
      "submit": "提交",
      "cancel": "取消",
      "confirm": "确定"
    }
  }
}
```

## Translation File Template (en)

```json
{
  "{plugin}.{module}.{model}": {
    "title": "{Model} Management",
    "dialog_title": "{Model}",
    "list_title": "{Model} List",
    "add_title": "Add {Model}",
    "edit_title": "Edit {Model}",
    "detail_title": "{Model} Detail",

    "table": {
      "columns": {
        "id": "ID",
        "name": "Name",
        "sort": "Sort",
        "status": "Status",
        "created_at": "Created At",
        "updated_at": "Updated At"
      }
    },

    "search_form": {
      "name": "Name",
      "name_placeholder": "Please enter name",
      "status": "Status",
      "status_placeholder": "Please select status",
      "date_range": "Created At",
      "date_range_placeholder": "Please select date range",
      "keywords": "Keywords",
      "keywords_placeholder": "Please enter keywords"
    },

    "form": {
      "name": "Name",
      "name_placeholder": "Please enter name",
      "name_rules": "Please enter name, max 50 characters",
      "sort": "Sort",
      "sort_placeholder": "Please enter sort value",
      "status": "Status",
      "status_placeholder": "Please select status",
      "remark": "Remark",
      "remark_placeholder": "Please enter remark"
    },

    "validate": {
      "name_required": "Please enter name",
      "name_max": "Name cannot exceed 50 characters",
      "status_required": "Please select status"
    },

    "tips": {
      "add_success": "{Model} added successfully",
      "add_fail": "Failed to add {Model}",
      "edit_success": "{Model} edited successfully",
      "edit_fail": "Failed to edit {Model}",
      "delete_confirm": "Are you sure to delete this {Model}?",
      "delete_success": "{Model} deleted successfully",
      "delete_fail": "Failed to delete {Model}"
    },

    "status": {
      "normal": "Normal",
      "disable": "Disabled"
    },

    "actions": {
      "add": "Add",
      "edit": "Edit",
      "delete": "Delete",
      "detail": "Detail",
      "export": "Export",
      "import": "Import",
      "refresh": "Refresh",
      "reset": "Reset",
      "search": "Search",
      "submit": "Submit",
      "cancel": "Cancel",
      "confirm": "Confirm"
    }
  }
}
```

## Usage in Frontend Code

```typescript
import { $t } from '@/locales'

// Using $t helper
const title = $t('{plugin}.{module}.{model}.title')
const columnLabel = $t('{plugin}.{module}.{model}.table.columns.name')

// In Vue component
<el-button>{{ $t('{plugin}.{module}.{model}.actions.add') }}</el-button>
```

## Auto-generation Checklist

When generating frontend i18n:
- [ ] Create locales directory structure if not exists
- [ ] Generate `zh-cn/{module}.json` with complete keys
- [ ] Generate `en/{module}.json` with complete keys
- [ ] Ensure key structure matches backend i18n pattern
- [ ] Add all column labels, placeholders, and validation messages

## Key Naming Convention

| Type | Key Pattern | Example |
|------|-------------|---------|
| Title | `{plugin}.{module}.{model}.title` | `official.ask.question.title` |
| Column | `{plugin}.{module}.{model}.table.columns.{name}` | `official.ask.question.table.columns.name` |
| Search | `{plugin}.{module}.{model}.search_form.{name}` | `official.ask.question.search_form.name` |
| Form | `{plugin}.{module}.{model}.form.{name}` | `official.ask.question.form.name` |
| Action | `{plugin}.{module}.{model}.actions.{name}` | `official.ask.question.actions.add` |

## Integration with Frontend Code

The generated i18n keys should match the schemas/index.tsx:

```typescript
// schemas/index.tsx
export const crudSchema = (): CrudSchema => {
  return {
    dialogTitle: $t('{plugin}.{module}.{model}.dialog_title'),
    columns: [
      {
        prop: 'name',
        label: $t('{plugin}.{module}.{model}.table.columns.name'),
      },
    ],
    searchFormSchema: {
      schema: [
        {
          label: $t('{plugin}.{module}.{model}.search_form.name'),
          prop: 'name',
        },
      ],
    },
    formSchema: {
      schema: [
        {
          label: $t('{plugin}.{module}.{model}.form.name'),
          prop: 'name',
        },
      ],
    },
  }
}
```
