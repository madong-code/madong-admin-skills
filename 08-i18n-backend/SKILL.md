---
name: madong-i18n-backend
description: Generate backend i18n translation files for madong plugin module. Creates PHP translation files with proper key patterns for both zh_CN and en languages.
---

# Step 8: Generate Backend i18n

Generate PHP translation files for plugin module backend.

## File Locations

```
plugin/{plugin}/resource/translations/zh_CN/{module}.php
plugin/{plugin}/resource/translations/en/{module}.php
```

## Translation Key Pattern

Backend i18n uses dot notation: `{module}.{model}.*`

## Translation File Template (zh_CN)

```php
<?php

/**
 * {Module} 多语言文件
 * 插件: {plugin}
 */

return [
    // 通用
    'common' => [
        'success'   => '操作成功',
        'fail'      => '操作失败',
        'delete_success' => '删除成功',
        'delete_fail'    => '删除失败',
        'save_success'   => '保存成功',
        'save_fail'      => '保存失败',
    ],

    // {Model} 相关
    '{model}' => [
        'title'      => '{Model}管理',
        'list'       => '{Model}列表',
        'add'        => '添加{Model}',
        'edit'       => '编辑{Model}',
        'delete'     => '删除{Model}',
        'detail'     => '{Model}详情',
        'export'     => '导出{Model}',
        'import'     => '导入{Model}',

        // 字段
        'field' => [
            'id'          => 'ID',
            'name'        => '名称',
            'sort'        => '排序',
            'status'      => '状态',
            'created_at'  => '创建时间',
            'updated_at'  => '更新时间',
        ],

        // 状态
        'status' => [
            'normal'  => '正常',
            'disable' => '禁用',
        ],

        // 验证消息
        'validate' => [
            'name_required' => '请输入名称',
            'name_max'      => '名称最多50个字符',
            'status_required' => '请选择状态',
        ],

        // 搜索表单
        'search' => [
            'name'          => '名称',
            'name_placeholder' => '请输入名称',
            'status'        => '状态',
            'status_placeholder' => '请选择状态',
            'date_range'    => '创建时间',
        ],

        // 操作提示
        'tips' => [
            'add_success'   => '添加{Model}成功',
            'add_fail'     => '添加{Model}失败',
            'edit_success' => '编辑{Model}成功',
            'edit_fail'    => '编辑{Model}失败',
            'delete_confirm' => '确认删除该{Model}吗？',
            'delete_success' => '删除{Model}成功',
            'delete_fail'   => '删除{Model}失败',
        ],
    ],
];
```

## Translation File Template (en)

```php
<?php

/**
 * {Module} Translation File
 * Plugin: {plugin}
 */

return [
    // Common
    'common' => [
        'success'   => 'Operation successful',
        'fail'      => 'Operation failed',
        'delete_success' => 'Deleted successfully',
        'delete_fail'    => 'Delete failed',
        'save_success'   => 'Saved successfully',
        'save_fail'      => 'Save failed',
    ],

    // {Model} Related
    '{model}' => [
        'title'      => '{Model} Management',
        'list'       => '{Model} List',
        'add'        => 'Add {Model}',
        'edit'       => 'Edit {Model}',
        'delete'     => 'Delete {Model}',
        'detail'     => '{Model} Detail',
        'export'     => 'Export {Model}',
        'import'     => 'Import {Model}',

        // Fields
        'field' => [
            'id'          => 'ID',
            'name'        => 'Name',
            'sort'        => 'Sort',
            'status'      => 'Status',
            'created_at'  => 'Created At',
            'updated_at'  => 'Updated At',
        ],

        // Status
        'status' => [
            'normal'  => 'Normal',
            'disable' => 'Disabled',
        ],

        // Validation Messages
        'validate' => [
            'name_required' => 'Please enter name',
            'name_max'      => 'Name cannot exceed 50 characters',
            'status_required' => 'Please select status',
        ],

        // Search Form
        'search' => [
            'name'          => 'Name',
            'name_placeholder' => 'Please enter name',
            'status'        => 'Status',
            'status_placeholder' => 'Please select status',
            'date_range'    => 'Created At',
        ],

        // Operation Tips
        'tips' => [
            'add_success'   => '{Model} added successfully',
            'add_fail'     => 'Failed to add {Model}',
            'edit_success' => '{Model} edited successfully',
            'edit_fail'    => 'Failed to edit {Model}',
            'delete_confirm' => 'Are you sure to delete this {Model}?',
            'delete_success' => '{Model} deleted successfully',
            'delete_fail'   => 'Failed to delete {Model}',
        ],
    ],
];
```

## Usage in Backend Code

```php
// Using trans() helper
echo trans('{plugin}.{module}.{model}.title');

// Using __() helper (if configured)
echo __('{plugin}.{module}.{model}.field.name');
```

## Auto-generation Checklist

When generating backend i18n:
- [ ] Create `resource/translations/` directory if not exists
- [ ] Generate `zh_CN/{module}.php` with complete keys
- [ ] Generate `en/{module}.php` with complete keys
- [ ] Ensure key structure matches frontend i18n pattern
- [ ] Add placeholder comments for missing translations

## Key Naming Convention

| Type | Key Pattern | Example |
|------|-------------|---------|
| Title | `{module}.{model}.title` | `ask.question.title` |
| Field | `{module}.{model}.field.{name}` | `ask.question.field.name` |
| Status | `{module}.{model}.status.{value}` | `ask.question.status.normal` |
| Search | `{module}.{model}.search.{name}` | `ask.question.search.name` |
| Tips | `{module}.{model}.tips.{action}` | `ask.question.tips.add_success` |
