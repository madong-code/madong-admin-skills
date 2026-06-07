---
name: madong-backend-command
description: 命令行命令规范（Webman Command），支持 make/config/install/metadata/plugin
globs:
  - "app/command/**/*.php"
---

## 文件位置

```
app/command/{Name}Command.php
```

## 代码模板

```php
<?php

namespace app\command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class {Name}Command extends Command
{
    protected static $defaultName = '{name}';
    protected static $defaultDescription = '{description}';

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln('Done');
        return self::SUCCESS;
    }
}
```

## 检查清单

- [ ] 命令名称是否 kebab-case
- [ ] 是否注册到 config/command.php
- [ ] 是否有描述信息
- [ ] 是否返回正确的 exit code
