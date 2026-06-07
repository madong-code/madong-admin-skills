---
name: madong-backend-excel
description: Excel 导入导出规范（基于 PhpSpreadsheet）
globs:
  - "core/excel/**/*.php"
---

## 导出

```php
use core\excel\ExcelExportService;

$data = [
    ['name' => '名称', 'status' => '启用'],
];

ExcelExportService::export('filename.xlsx', [
    'name' => '名称',
    'status' => '状态',
], $data);
```

## 导入

```php
use core\excel\ExcelImportService;

$rows = ExcelImportService::import($filePath, [
    'name' => 'required',
    'status' => 'integer',
]);
```

## 检查清单

- [ ] 导出列名是否与数据键名一致
- [ ] 大数据量是否分页导出
- [ ] 导入是否有数据校验
- [ ] 导入是否有事务保护
