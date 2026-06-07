---
name: madong-backend-tests
description: 通用的测试脚本管理技能，专注于测试脚本的归类、组织和管理，避免脚本散落在根目录
---

# Tester Skill

本技能专注于测试脚本的组织、归类和管理。当需要创建、管理或执行测试脚本时，应使用此技能来确保所有测试脚本都按标准目录结构归类存放。

## 何时使用此技能

当遇到以下情况时使用此技能：
1. 测试脚本散落在项目根目录，需要整理归类
2. 需要创建新的测试脚本，需要遵循标准目录结构
3. 需要管理和组织测试脚本文件
4. 需要执行批量测试或验证
5. 需要统一的测试脚本管理规范

## 如何使用此技能

### 1. 测试目录结构管理规范

所有测试脚本必须归类存放，禁止在项目根目录创建临时测试文件。使用以下简化目录结构（最多一层子目录）：

```
backend/tests/
├── plugin/                         # 插件相关测试（直接放文件）
├── unit/                           # 单元测试（直接放文件）
├── integration/                    # 集成测试（直接放文件）
├── e2e/                           # 端到端测试（直接放文件）
├── scripts/                       # 测试脚本工具（直接放文件）
└── fixtures/                      # 测试数据文件（直接放文件）
```

### 2. 测试脚本创建和归类流程

创建测试脚本时应遵循以下流程：

1. **确定测试类型**：根据测试目的选择适当的目录（unit/integration/e2e/plugin等）
2. **创建标准目录**：如果目录不存在，先创建标准目录结构
3. **命名规范**：使用有意义的文件名，如 `user-model-test.php`、`api-auth-test.php`
4. **归类存放**：将脚本放在正确的子目录中，避免根目录
5. **清理临时文件**：测试完成后，清理并删除临时测试文件
6. **更新目录文档**：更新相应目录的 README 或说明文件

### 2. 测试脚本归类规则

所有测试脚本必须按以下规则归类存放（最多一层目录）：

#### 2.1 按测试类型归类
- **单元测试**：`tests/unit/` - 测试单个类或方法（直接放文件）
- **集成测试**：`tests/integration/` - 测试多个组件的交互（直接放文件）
- **端到端测试**：`tests/e2e/` - 测试完整业务流程（直接放文件）
- **插件测试**：`tests/plugin/` - 专门测试插件功能（直接放文件）
- **性能测试**：`tests/performance/` - 测试性能和负载（直接放文件）

#### 2.2 命名规范
- 使用有意义的文件名，如 `user-model-test.php`、`api-auth-test.php`
- 文件名应反映测试内容，避免通用名称如 `test.php`、`check.php`

#### 2.3 禁止行为
- ❌ 禁止在项目根目录创建测试脚本
- ❌ 禁止在 `public/`、`vendor/` 等目录创建测试脚本
- ❌ 禁止使用临时文件名（如 `test1.php`、`temp.php`）
- ❌ 禁止测试脚本残留临时文件
- ❌ 禁止创建多层子目录结构（最多一层）

### 4. 测试脚本质量标准

所有测试脚本应满足以下质量标准：
- ✅ 按标准目录结构归类存放
- ✅ 使用有意义的文件名，描述测试内容
- ✅ 包含清晰的注释和文档说明
- ✅ 输出标准的测试结果格式（✓/✗/⚠）
- ✅ 自动清理临时文件和资源
- ✅ 支持命令行参数和配置选项
- ✅ 可独立运行，不依赖复杂环境

### 5. 常用测试脚本模板

#### 4.1 单元测试模板（简化版）
```php
<?php
// tests/unit/UserModelTest.php
namespace Tests\Unit;

use App\Models\User;

class UserModelTest
{
    public function testUserCreation()
    {
        echo "=== 用户模型测试 ===\n";
        
        // 测试用户创建逻辑
        $user = new User(['name' => 'Test User']);
        
        if ($user->name === 'Test User') {
            echo "✓ 用户创建测试成功\n";
        } else {
            echo "✗ 用户创建测试失败\n";
        }
    }
}
```

#### 4.2 API集成测试模板（简化版）
```php
<?php
// tests/integration/AuthApiTest.php
namespace Tests\Integration;

class AuthApiTest
{
    public function testLoginApi()
    {
        echo "=== API认证测试 ===\n";
        
        // 测试登录API逻辑
        $response = $this->simulateApiCall('/api/login', [
            'username' => 'test',
            'password' => 'password'
        ]);
        
        if ($response['status'] === 200 && isset($response['token'])) {
            echo "✓ API认证测试成功\n";
        } else {
            echo "✗ API认证测试失败\n";
        }
    }
    
    private function simulateApiCall($endpoint, $data)
    {
        // 模拟API调用逻辑
        return ['status' => 200, 'token' => 'mock_token'];
    }
}
```

#### 4.3 插件安装测试模板（简化版）
```php
<?php
// tests/plugin/MigrationTest.php
namespace Tests\Plugin;

class MigrationTest
{
    public function run()
    {
        echo "=== 迁移文件测试 ===\n";
        
        // 测试迁移文件语法
        $this->testMigrationSyntax();
        
        // 测试索引名称长度
        $this->testIndexNames();
        
        // 测试引擎设置
        $this->testEngineSettings();
    }
    
    private function testMigrationSyntax()
    {
        // 迁移文件语法测试逻辑
    }
}
```

### 6. 批量测试执行和归类检查

#### 5.1 运行所有测试（简化版）
使用 `tests/scripts/run-all-tests.php` 脚本执行所有归类好的测试：

```php
<?php
// tests/scripts/run-all-tests.php
echo "=== 批量测试执行 ===\n";

// 扫描所有测试目录中的文件
$testDirectories = ['plugin', 'unit', 'integration', 'e2e'];

foreach ($testDirectories as $directory) {
    $dirPath = __DIR__ . '/../' . $directory;
    if (!is_dir($dirPath)) {
        continue;
    }
    
    echo "=== 执行 {$directory} 测试 ===\n";
    
    $files = scandir($dirPath);
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..' && pathinfo($file, PATHINFO_EXTENSION) === 'php') {
            $testPath = $dirPath . '/' . $file;
            include $testPath;
        }
    }
}
```

#### 5.2 检查测试脚本归类（简化版）
使用以下脚本检查是否有未归类的测试文件：

```php
<?php
// tests/scripts/check-classification.php
echo "=== 测试脚本归类检查 ===\n";

// 允许的目录
$allowedDirs = ['tests/', 'vendor/'];

// 查找项目根目录中的测试文件
function findTestFiles($dir)
{
    $testFiles = [];
    $patterns = ['/test.*\.php$/i', '/.*test\.php$/i', '/check.*\.php$/i'];
    
    if ($handle = opendir($dir)) {
        while (false !== ($entry = readdir($handle))) {
            if ($entry === '.' || $entry === '..') continue;
            
            $path = $dir . '/' . $entry;
            
            if (is_dir($path)) {
                // 递归查找子目录
                $testFiles = array_merge($testFiles, findTestFiles($path));
            } else {
                // 检查是否是测试文件
                foreach ($patterns as $pattern) {
                    if (preg_match($pattern, $entry)) {
                        $testFiles[] = $path;
                        break;
                    }
                }
            }
        }
        closedir($handle);
    }
    
    return $testFiles;
}

// 检查测试文件是否在允许的目录中
$projectRoot = realpath(__DIR__ . '/../../');
$allTestFiles = findTestFiles($projectRoot);
$unclassified = [];

foreach ($allTestFiles as $file) {
    $isAllowed = false;
    foreach ($allowedDirs as $allowed) {
        if (strpos($file, $allowed) !== false) {
            $isAllowed = true;
            break;
        }
    }
    
    if (!$isAllowed) {
        $unclassified[] = $file;
    }
}

// 输出结果
if (count($unclassified) > 0) {
    echo "⚠ 发现 " . count($unclassified) . " 个未正确归类的测试脚本:\n\n";
    foreach ($unclassified as $file) {
        $relativePath = str_replace($projectRoot . '/', '', $file);
        echo "  • " . $relativePath . "\n";
    }
    echo "\n请将这些文件移动到 tests/ 目录下的相应子目录中。\n";
} else {
    echo "✓ 所有测试脚本都已正确归类到 tests/ 目录中。\n";
}
```

### 6. 测试结果验证

每个测试脚本应输出明确的验证结果：
- ✓ 成功：绿色标记
- ✗ 失败：红色标记  
- ⚠ 警告：黄色标记
- 详细说明：问题描述和修复建议

### 7. 临时文件管理

所有测试脚本应在完成后清理临时文件：
```php
// 清理临时文件
$tempFiles = ['test_*.php', 'check_*.php', 'fix_*.php'];
foreach ($tempFiles as $pattern) {
    // 查找并删除临时文件
}
```

## 技能资源

本技能包含以下资源：

### 脚本资源 (`scripts/`)
- `create-test-directory.php`：创建测试目录结构的脚本
- `test-template-generator.php`：生成各种测试脚本模板
- `validate-migration-files.php`：验证迁移文件的完整脚本
- `check-index-names.php`：检查索引名称长度的脚本

### 参考资源 (`references/`)
- `mysql-limitations.md`：MySQL 限制参考（标识符长度、引擎等）
- `laravel-migration-guide.md`：Laravel 迁移最佳实践指南
- `plugin-install-flow.md`：插件安装流程和常见问题
- `testing-best-practices.md`：测试最佳实践和标准

### 资产资源 (`assets/`)
- `test-directory-structure.txt`：测试目录结构模板
- `test-script-templates/`：各种测试脚本模板文件
- `expected-output-examples/`：预期输出示例

## 执行流程示例

### 场景1：测试脚本归类检查
1. 使用 `tests/scripts/check-classification.php` 检查是否有未归类的测试脚本
2. 将发现的临时测试文件移动到正确的 `tests/` 子目录中
3. 使用有意义的文件名重命名测试文件
4. 执行 `tests/scripts/cleanup-temp.php` 清理残留临时文件

### 场景2：创建新的插件测试
1. 在 `tests/plugin/` 目录下创建新的测试文件，如 `official-plugin-test.php`
2. 编写测试逻辑，包含清晰的注释和输出格式
3. 执行测试验证功能是否正常
4. 确保测试完成后清理所有临时资源

### 场景3：批量执行测试
1. 使用 `tests/scripts/run-all-tests.php` 执行所有测试
2. 查看测试结果报告，识别失败的测试
3. 修复失败的测试或相关问题
4. 重新执行测试确保所有测试通过

通过本技能，可以系统化地管理和执行插件安装相关的测试工作，确保所有修复都经过充分验证，避免重复问题。