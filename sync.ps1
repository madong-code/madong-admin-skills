<#
.SYNOPSIS
  Madong SaaS Skills 跨编辑器同步脚本（MDAdmin 标准版）
  将 skills/ 下所有 SKILL.md 分发到各 AI 编辑器格式。

.PARAMETER target
  指定要同步的编辑器，多个用逗号分隔。可选值：
    codebuddy, cursor, trae, copilot, claude, windsurf, cline, roo, gemini, qwen
  不传则同步全部。

.EXAMPLE
  # 同步全部（默认）
  powershell -ExecutionPolicy Bypass -File skills\sync.ps1

  # 只同步 CodeBuddy
  powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target codebuddy

  # 只同步 Trae（含 Skills + Rules）
  powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target trae

  # 同步多个
  powershell -ExecutionPolicy Bypass -File skills\sync.ps1 -target codebuddy,cursor
#>

param(
    [string[]]$target
)

$ErrorActionPreference = 'Stop'
# 脚本位于 skills/ 目录，仓库根目录为其父目录
$srcDir = $PSScriptRoot
$root   = Split-Path -Parent $srcDir

# 解析目标
# 注意：powershell -File 模式下 "-target a,b,c" 的逗号不会自动拆分为数组，这里手动拆分
$rawTargets = if ($target) { $target } else { @() }
$rawTargets = @($rawTargets | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
if ($rawTargets.Count -eq 0) {
    $targets = @('codebuddy', 'cursor', 'trae', 'copilot', 'claude', 'windsurf', 'cline', 'roo', 'gemini', 'qwen')
    $label = 'all'
} else {
    $targets = $rawTargets | ForEach-Object { $_.ToLower().Trim() }
    $label = "$($targets -join ', ')"
}

# 收集所有 SKILL.md 文件
$skills = Get-ChildItem -Recurse -Filter 'SKILL.md' -Path $srcDir | Where-Object {
    $_.DirectoryName -notmatch 'node_modules|\\\.git'
}

Write-Host "Found $($skills.Count) skill files" -ForegroundColor Green
Write-Host "Targets: $label" -ForegroundColor Gray
Write-Host ""

# 辅助函数：生成技能名称（用目录路径做连字符名字）
function Get-SkillName($skillFile) {
    $relPath = $skillFile.FullName.Replace("$srcDir\", '').Replace("$srcDir/", '')
    return ($relPath -replace '[/\\]', '-') -replace '-SKILL\.md$', ''
}

# 辅助函数：把 SKILL.md 转换为指定编辑器的规则文件内容（重写 frontmatter）
function Convert-ToRuleContent($content, $format) {
    if ($content -match '(?s)^---\r?\n(.*?)\r?\n---\r?\n(.*)$') {
        $frontmatter = $matches[1]
        $body = $matches[2]

        $desc = ''
        $globsList = @()
        foreach ($line in ($frontmatter -split '\r?\n')) {
            if ($line -match '^description:\s*(.*)') { $desc = ($matches[1] -replace '\r$', '') }
            if ($line -match '^\s+-\s+"(.*)"') { $globsList += $matches[1] }
        }

        $newFront = @()
        if ($format -eq 'windsurf') { $newFront += 'alwaysApply: false' }
        if ($desc) { $newFront += "description: $desc" }
        if ($globsList.Count -gt 0) {
            $newFront += 'globs: "' + ($globsList -join ', ') + '"'
        }
        return "---`n" + ($newFront -join "`n") + "`n---`n$body"
    }
    return $content
}

# 辅助函数：聚合所有 skill 生成单一指令文件（Gemini / Qwen）
function Write-AggregatedFile($destPath, $label) {
    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine('# Madong SaaS Project Instructions')
    $null = $sb.AppendLine('')
    $null = $sb.AppendLine('Project-wide coding rules and conventions for the Madong SaaS (MDAdmin standard) project.')
    $null = $sb.AppendLine('')

    foreach ($skill in $skills) {
        $relPath = $skill.FullName.Replace("$srcDir\", '').Replace("$srcDir/", '')
        $category = ($relPath -split '[/\\]')[0]
        $skillName = (($relPath -replace '[/\\]', '-') -replace '-SKILL\.md$', '') -split '-' | Select-Object -Last 1

        $null = $sb.AppendLine('---')
        $null = $sb.AppendLine('')
        $null = $sb.AppendLine("## $category / $skillName")

        $content = [System.IO.File]::ReadAllText($skill.FullName)
        $content = $content -replace '(?s)^---\r?\n.*?\r?\n---\r?\n', ''
        $null = $sb.AppendLine('')
        $null = $sb.AppendLine($content.Trim())
        $null = $sb.AppendLine('')
    }

    [System.IO.File]::WriteAllText($destPath, $sb.ToString())
    Write-Host "  [$label] $destPath" -ForegroundColor Cyan
    Write-Host ''
}

function Write-Summary($label, $path, $count, $format) {
    Write-Host "$($label.PadRight(14)): $path ($count $format)" -ForegroundColor Cyan
}

# =============================================================
# 1. CodeBuddy
# =============================================================
if ($targets -contains 'codebuddy') {
    $cbDir = Join-Path $root '.codebuddy\skills'
    New-Item -ItemType Directory -Force -Path $cbDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $cbDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'SKILL.md'
        Copy-Item -Path $skill.FullName -Destination $dest -Force
        Write-Host "  [CodeBuddy] $name/SKILL.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 2. Cursor
# =============================================================
if ($targets -contains 'cursor') {
    $cursorDir = Join-Path $root '.cursor\rules'
    New-Item -ItemType Directory -Force -Path $cursorDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $cursorDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'rule.mdc'
        Copy-Item -Path $skill.FullName -Destination $dest -Force
        Write-Host "  [Cursor] $name/rule.mdc" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 3. Trae (Rules + Skills)
# =============================================================
if ($targets -contains 'trae') {

    # 3a. Trae Rules
    $traeDir = Join-Path $root '.trae\rules'
    New-Item -ItemType Directory -Force -Path $traeDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $traeDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'rule.md'

        $content = [System.IO.File]::ReadAllText($skill.FullName)

        if ($content -match '(?s)^---\r?\n(.*?)\r?\n---\r?\n(.*)$') {
            $frontmatter = $matches[1]
            $body = $matches[2]

            $desc = ''
            $globsList = @()
            foreach ($line in ($frontmatter -split '\r?\n')) {
                if ($line -match '^description:\s*(.*)') { $desc = ($matches[1] -replace '\r$', '') }
                if ($line -match '^\s+-\s+"(.*)"') { $globsList += $matches[1] }
            }

            $newFront = @()
            $newFront += 'alwaysApply: false'
            if ($desc) { $newFront += "description: $desc" }
            if ($globsList.Count -gt 0) {
                $newFront += 'globs: "' + ($globsList -join ', ') + '"'
            }

            $newContent = "---`n" + ($newFront -join "`n") + "`n---`n$body"
            [System.IO.File]::WriteAllText($dest, $newContent, [System.Text.UTF8Encoding]::new($false))
        } else {
            Copy-Item -Path $skill.FullName -Destination $dest -Force
        }

        Write-Host "  [Trae Rules] $name/rule.md" -ForegroundColor Cyan
    }

    # 3b. Trae Skills
    $traeSkillsDir = Join-Path $root '.agents\skills'
    New-Item -ItemType Directory -Force -Path $traeSkillsDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $traeSkillsDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'SKILL.md'
        Copy-Item -Path $skill.FullName -Destination $dest -Force
        Write-Host "  [Trae Skills] $name/SKILL.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 4. Copilot
# =============================================================
if ($targets -contains 'copilot') {
    $copilotDir = Join-Path $root '.github'
    New-Item -ItemType Directory -Force -Path $copilotDir | Out-Null
    $copilotDest = Join-Path $copilotDir 'copilot-instructions.md'

    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine("# Madong SaaS Project Instructions")
    $null = $sb.AppendLine("")
    $null = $sb.AppendLine("Project-wide coding rules and conventions for the Madong SaaS (MDAdmin standard) project.")
    $null = $sb.AppendLine("")

    foreach ($skill in $skills) {
        $relPath = $skill.FullName.Replace("$srcDir\", '').Replace("$srcDir/", '')
        $category = ($relPath -split '[/\\]')[0]
        $skillName = (($relPath -replace '[/\\]', '-') -replace '-SKILL\.md$', '') -split '-' | Select-Object -Last 1

        $null = $sb.AppendLine("---")
        $null = $sb.AppendLine("")
        $null = $sb.AppendLine("## $category / $skillName")

        $content = [System.IO.File]::ReadAllText($skill.FullName)
        $content = $content -replace '(?s)^---\r?\n.*?\r?\n---\r?\n', ''
        $null = $sb.AppendLine("")
        $null = $sb.AppendLine($content.Trim())
        $null = $sb.AppendLine("")
    }

    [System.IO.File]::WriteAllText($copilotDest, $sb.ToString())
    Write-Host "  [Copilot] copilot-instructions.md" -ForegroundColor Cyan
    Write-Host ""
}

# =============================================================
# 5. Claude Code (Agent Skills)
# =============================================================
if ($targets -contains 'claude') {
    $claudeDir = Join-Path $root '.claude\skills'
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $claudeDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'SKILL.md'
        Copy-Item -Path $skill.FullName -Destination $dest -Force
        Write-Host "  [Claude] $name/SKILL.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 6. Windsurf
# =============================================================
if ($targets -contains 'windsurf') {
    $windsurfDir = Join-Path $root '.windsurf\rules'
    New-Item -ItemType Directory -Force -Path $windsurfDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $skillDir = Join-Path $windsurfDir $name
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        $dest = Join-Path $skillDir 'rule.md'
        $content = [System.IO.File]::ReadAllText($skill.FullName)
        [System.IO.File]::WriteAllText($dest, (Convert-ToRuleContent $content 'windsurf'), [System.Text.UTF8Encoding]::new($false))
        Write-Host "  [Windsurf] $name/rule.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 7. Cline
# =============================================================
if ($targets -contains 'cline') {
    $clineDir = Join-Path $root '.clinerules'
    New-Item -ItemType Directory -Force -Path $clineDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $dest = Join-Path $clineDir "$name.md"
        $content = [System.IO.File]::ReadAllText($skill.FullName)
        [System.IO.File]::WriteAllText($dest, (Convert-ToRuleContent $content 'cline'), [System.Text.UTF8Encoding]::new($false))
        Write-Host "  [Cline] $name.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 8. Roo Code
# =============================================================
if ($targets -contains 'roo') {
    $rooDir = Join-Path $root '.roo\rules'
    New-Item -ItemType Directory -Force -Path $rooDir | Out-Null

    foreach ($skill in $skills) {
        $name = Get-SkillName $skill
        $dest = Join-Path $rooDir "$name.md"
        $content = [System.IO.File]::ReadAllText($skill.FullName)
        [System.IO.File]::WriteAllText($dest, (Convert-ToRuleContent $content 'roo'), [System.Text.UTF8Encoding]::new($false))
        Write-Host "  [Roo] $name.md" -ForegroundColor Cyan
    }
    Write-Host ""
}

# =============================================================
# 9. Gemini CLI
# =============================================================
if ($targets -contains 'gemini') {
    $geminiDest = Join-Path $root 'GEMINI.md'
    Write-AggregatedFile $geminiDest 'Gemini'
}

# =============================================================
# 10. Qwen Code
# =============================================================
if ($targets -contains 'qwen') {
    $qwenDest = Join-Path $root 'QCLAUDE.md'
    Write-AggregatedFile $qwenDest 'Qwen'
}

# =============================================================
# .gitignore (always, in skills source dir)
# =============================================================
$gitignorePath = Join-Path $srcDir '.gitignore'
$ignoreLines = @(
    '# Editor rule directories auto-generated by sync scripts',
    '.codebuddy/skills/',
    '.cursor/',
    '.trae/',
    '.agents/',
    '.github/copilot-instructions.md',
    '.claude/skills/',
    '.windsurf/rules/',
    '.clinerules/',
    '.roo/rules/',
    'GEMINI.md',
    'QCLAUDE.md'
)
if (-not (Test-Path $gitignorePath)) {
    $ignoreLines | Set-Content -Path $gitignorePath -Encoding UTF8
} else {
    $existing = Get-Content $gitignorePath
    $toAdd = $ignoreLines | Where-Object { $_ -notin $existing }
    if ($toAdd.Count -gt 0) {
        Add-Content -Path $gitignorePath -Value $toAdd -Encoding UTF8
    }
}

# =============================================================
# 结果汇总
# =============================================================
Write-Host "======= Sync Complete =======" -ForegroundColor Yellow
if ($targets -contains 'codebuddy') { Write-Summary 'CodeBuddy' '.codebuddy/skills/{name}/'  $skills.Count 'SKILL.md' }
if ($targets -contains 'cursor')   { Write-Summary 'Cursor'    '.cursor/rules/{name}/'     $skills.Count 'rule.mdc'  }
if ($targets -contains 'trae')     { Write-Summary 'Trae Rules' '.trae/rules/{name}/'       $skills.Count 'rule.md'   }
if ($targets -contains 'trae')     { Write-Summary 'Trae Skills'.PadRight(14) '.agents/skills/{name}/'    $skills.Count 'SKILL.md'  }
if ($targets -contains 'copilot')  { Write-Summary 'Copilot'   '.github/'                  '1'           'aggregated' }
if ($targets -contains 'claude')   { Write-Summary 'Claude'    '.claude/skills/{name}/'    $skills.Count 'SKILL.md' }
if ($targets -contains 'windsurf') { Write-Summary 'Windsurf'  '.windsurf/rules/{name}/'   $skills.Count 'rule.md'  }
if ($targets -contains 'cline')    { Write-Summary 'Cline'     '.clinerules/{name}.md'     $skills.Count 'rule'     }
if ($targets -contains 'roo')      { Write-Summary 'Roo'       '.roo/rules/{name}.md'      $skills.Count 'rule'     }
if ($targets -contains 'gemini')   { Write-Summary 'Gemini'    'GEMINI.md'                 '1'           'aggregated' }
if ($targets -contains 'qwen')     { Write-Summary 'Qwen'      'QCLAUDE.md'                '1'           'aggregated' }
Write-Host "==========================" -ForegroundColor Yellow
