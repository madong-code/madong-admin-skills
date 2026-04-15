---
name: madong-backend-logger
description: Help integrate backend debug logger component (core/logger) into code. Provides logger usage patterns, configuration guidance, and best practices for different log levels.
globs:
  - "app/**/*.php"
  - "plugin/**/*.php"
  - "backend/core/logger/**/*.php"
---

# Madong Backend Logger Integration

快速集成后端调试日志组件到你的代码中。

## 组件介绍

`core/logger` 是一个基于 Monolog 的日志组件，提供静态方法调用接口，支持多种日志级别和自动文件分割。

### 核心特性

- ✅ 静态方法调用，使用简单
- ✅ 支持 8 种日志级别
- ✅ 按日期和级别自动分割日志文件
- ✅ 支持日志清理和保留策略
- ✅ 支持上下文数据
- ✅ 基于 Monolog，功能强大

---

## 快速开始

### 1. 基本使用

```php
use core\logger\Logger;

// 简单日志
Logger::info('用户登录成功');
Logger::error('数据库连接失败');

// 带上下文的日志
Logger::info('用户登录', ['user_id' => 123, 'ip' => '192.168.1.1']);
Logger::error('订单创建失败', ['order_id' => 456, 'error' => '库存不足']);
```

### 2. 日志级别

| 方法 | 级别值 | 使用场景 |
|------|--------|----------|
| `Logger::debug()` | 100 | 调试信息，开发环境使用 |
| `Logger::info()` | 200 | 一般信息，如用户操作 |
| `Logger::notice()` | 250 | 重要事件，但非错误 |
| `Logger::warning()` | 300 | 警告信息，潜在问题 |
| `Logger::error()` | 400 | 运行错误，需要关注 |
| `Logger::critical()` | 500 | 严重故障，需要立即处理 |
| `Logger::alert()` | 550 | 需要立即采取行动 |
| `Logger::emergency()` | 600 | 系统不可用，最高级别 |

---

## 配置说明

配置文件路径：`backend/core/logger/config/app.php`

```php
return [
    'enable'   => true,
    'base'     => [
        'path'           => runtime_path('logs'), // 日志存储路径
        'channel'        => 'core',               // 日志通道名称
        'retention_days' => 7,                    // 保留天数
        'daily_rotation' => true,                 // 每日文件分割
    ],
    'format'   => [
        'date'   => 'Y-m-d H:i:s.u',
        'output' => "[%datetime%] %channel%.%level_name%: %message% %context%\n",
    ],
    'levels'   => [
        'debug'     => config('app.debug', false), // 跟随应用调试模式
        'min_level' => 'debug',                    // 最小记录级别
    ],
    'handlers' => [
        'stream' => true,  // 启用文件处理器
        'syslog' => false, // 禁用 syslog
    ],
];
```

---

## 使用场景

### 场景 1: 控制器中记录请求日志

```php
namespace app\adminapi\controller\user;

use core\base\Controller;
use core\logger\Logger;
use support\Request;

class UserController extends Controller
{
    public function index(Request $request)
    {
        Logger::info('访问用户列表', [
            'user_id' => $request->user->id ?? 0,
            'page'    => $request->get('page', 1),
            'ip'      => $request->getRealIp(),
        ]);

        // 业务逻辑...
    }
}
```

### 场景 2: 服务层记录业务日志

```php
namespace app\service\admin\order;

use core\base\BaseService;
use core\logger\Logger;
use app\dao\order\OrderDao;

class OrderService extends BaseService
{
    public function createOrder(array $data)
    {
        Logger::info('开始创建订单', ['data' => $data]);

        try {
            $order = $this->dao->save($data);
            Logger::info('订单创建成功', ['order_id' => $order->id]);
            return $order;
        } catch (\Throwable $e) {
            Logger::error('订单创建失败', [
                'data'  => $data,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            throw $e;
        }
    }
}
```

### 场景 3: 异常处理

```php
namespace app\service\admin\payment;

use core\base\BaseService;
use core\logger\Logger;

class PaymentService extends BaseService
{
    public function processPayment(int $orderId, float $amount)
    {
        try {
            // 支付处理逻辑...
            Logger::info('支付处理成功', [
                'order_id' => $orderId,
                'amount'   => $amount,
            ]);
        } catch (\Throwable $e) {
            Logger::critical('支付处理失败', [
                'order_id' => $orderId,
                'amount'   => $amount,
                'error'    => $e->getMessage(),
                'file'     => $e->getFile(),
                'line'     => $e->getLine(),
            ]);
            throw $e;
        }
    }
}
```

### 场景 4: 调试信息

```php
namespace app\service\admin\sync;

use core\base\BaseService;
use core\logger\Logger;

class SyncService extends BaseService
{
    public function syncData(array $items)
    {
        Logger::debug('开始同步数据', ['count' => count($items)]);

        foreach ($items as $index => $item) {
            Logger::debug('处理数据项', [
                'index' => $index,
                'item'  => $item,
            ]);
            // 处理逻辑...
        }

        Logger::debug('数据同步完成');
    }
}
```

### 场景 5: 性能监控

```php
namespace app\service\admin\report;

use core\base\BaseService;
use core\logger\Logger;

class ReportService extends BaseService
{
    public function generateReport(string $type)
    {
        $startTime = microtime(true);
        Logger::info('开始生成报表', ['type' => $type]);

        // 报表生成逻辑...
        $report = $this->buildReport($type);

        $duration = round((microtime(true) - $startTime) * 1000, 2);
        Logger::info('报表生成完成', [
            'type'     => $type,
            'duration' => $duration . 'ms',
            'size'     => strlen($report),
        ]);

        return $report;
    }
}
```

---

## 日志文件结构

日志文件按日期和级别自动分割：

```
runtime/logs/
└── core/                    # 通道名称
    └── 2024-01/            # 年月目录
        ├── 01-DEBUG.log    # 每日调试日志
        ├── 01-INFO.log     # 每日信息日志
        ├── 01-WARNING.log  # 每日警告日志
        ├── 01-ERROR.log    # 每日错误日志
        └── ...
```

---

## 日志清理

### 手动清理

```php
use core\logger\Logger;

// 清理过期日志（根据配置的 retention_days）
Logger::cleanup();

// 强制清理所有日志
Logger::cleanup(true);

// 清理指定通道的日志
Logger::cleanup(false, 'payment');
```

### 自动清理

建议在定时任务中配置自动清理：

```php
// config/crontab.php
return [
    '0 2 * * *' => function () {
        \core\logger\Logger::cleanup();
    },
];
```

---

## 最佳实践

### 1. 选择合适的日志级别

```php
// ✅ 好的做法
Logger::debug('变量值', ['var' => $value]);           // 调试信息
Logger::info('用户操作', ['action' => 'login']);      // 一般信息
Logger::warning('库存不足', ['product_id' => 123]);   // 警告
Logger::error('支付失败', ['order_id' => 456]);       // 错误
Logger::critical('数据库连接失败');                    // 严重错误

// ❌ 不好的做法
Logger::emergency('用户登录');  // 级别过高
Logger::debug('支付失败');      // 级别过低
```

### 2. 提供有意义的上下文

```php
// ✅ 好的做法
Logger::info('订单创建成功', [
    'order_id'     => $order->id,
    'user_id'      => $order->user_id,
    'amount'       => $order->amount,
    'payment_type' => $order->payment_type,
]);

// ❌ 不好的做法
Logger::info('订单创建成功');
Logger::info('订单创建成功', ['data' => $order]); // 数据过多
```

### 3. 避免敏感信息

```php
// ✅ 好的做法
Logger::info('用户登录', [
    'user_id' => $user->id,
    'ip'      => $request->getRealIp(),
]);

// ❌ 不好的做法
Logger::info('用户登录', [
    'password' => $request->post('password'),  // 敏感信息
    'token'    => $user->api_token,            // 敏感信息
]);
```

### 4. 异常日志包含堆栈

```php
try {
    // 业务逻辑...
} catch (\Throwable $e) {
    Logger::error('操作失败', [
        'error' => $e->getMessage(),
        'file'  => $e->getFile(),
        'line'  => $e->getLine(),
        'trace' => $e->getTraceAsString(),
    ]);
    throw $e;
}
```

---

## 集成步骤

### Step 1: 检查配置

确认 `backend/core/logger/config/app.php` 配置正确。

### Step 2: 引入 Logger

在需要记录日志的文件中引入：

```php
use core\logger\Logger;
```

### Step 3: 添加日志调用

根据业务场景选择合适的日志级别和位置。

### Step 4: 验证日志

检查 `runtime/logs/{channel}/{Y-m}/` 目录下的日志文件。

---

## Quick Commands

| Command | Description |
|---------|------------|
| `add logger to UserController` | 在 UserController 中添加日志 |
| `add logger to OrderService` | 在 OrderService 中添加日志 |
| `add debug logger to sync method` | 在同步方法中添加调试日志 |
| `add error logger to try-catch` | 在异常处理中添加错误日志 |
| `show logger usage examples` | 显示日志使用示例 |
| `configure logger for production` | 配置生产环境日志 |

---

## Boundaries

- ✅ **Always**: 使用静态方法调用 `Logger::xxx()`
- ✅ **Always**: 提供有意义的上下文数据
- ✅ **Always**: 选择合适的日志级别
- ✅ **Always**: 异常日志包含堆栈信息
- ⚠️ **Ask first**: 敏感信息是否需要脱敏
- 🚫 **Never**: 记录密码、token 等敏感信息
- 🚫 **Never**: 在循环中大量记录 debug 日志
- 🚫 **Never**: 使用过高的日志级别记录普通信息
