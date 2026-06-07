---
name: madong-backend-bootstrap
description: 启动引导规范，应用初始化流程和事件钩子
globs:
  - "app/bootstrap/**/*.php"
---

## 引导流程

```
启动顺序:
1. config/ 配置加载
2. app/bootstrap/ 应用引导
3. 中间件注册
4. 路由注册
5. 服务提供者注册
```

## 代码模板

```php
<?php

// app/bootstrap/{name}.php

return function () {
    // 初始化逻辑
};
```

## 检查清单

- [ ] 引导代码执行顺序是否正确
- [ ] 是否有异常处理
- [ ] 是否遵循框架启动流程
