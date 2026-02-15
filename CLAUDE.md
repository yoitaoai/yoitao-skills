# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

`yoitao-skills` 是一个面向 Claude Code / Agents 的技能合集仓库，支持通过 `npx skills add` 一键安装技能。每个技能是一个自包含的 markdown 文件，定义了特定的自动化工作流或工具调用模式。

## 常用命令

### 验证技能结构

```bash
./scripts/validate-skills.sh
```

在发布前必须运行此脚本，它会检查：
- `skills/*/SKILL.md` 是否存在
- `name` frontmatter 字段与目录名是否一致
- `description` frontmatter 字段是否存在
- 目录名是否符合 kebab-case 规范
- `.claude-plugin/marketplace.json` 引用的技能路径是否有效

### 测试技能安装

```bash
# 列出可安装的技能
npx skills add yoitaoai/yoitao-skills -l

# 安装所有技能
npx skills add yoitaoai/yoitao-skills

# 安装特定技能
npx skills add yoitaoai/yoitao-skills --skill yoitao-jimeng-sessionid
```

## 架构说明

### 技能文件结构

每个技能位于 `skills/<skill-name>/SKILL.md`，必须包含：

1. **Frontmatter**（必需）：
   - `name`: 技能名称，必须与目录名一致
   - `description`: 触发场景描述，说明何时使用该技能

2. **正文内容**：
   - 触发场景：明确的使用条件列表
   - 依赖项：所需 MCP 服务或外部工具
   - 工作流：分步执行说明
   - 错误处理：常见问题及解决方案

### 可选子目录

```
skills/<skill-name>/
├── SKILL.md          # 必需
├── scripts/          # 可选：辅助脚本
├── references/       # 可选：参考文档
└── assets/           # 可选：静态资源
```

### 命名规范

- 技能目录名：kebab-case（小写字母 + 中划线），如 `yoitao-jimeng-sessionid`
- 避免使用：空格、中文、下划线、特殊符号

### 插件市场集成

`.claude-plugin/marketplace.json` 定义了插件组：

```json
{
  "plugins": [
    {
      "name": "plugin-group-name",
      "skills": ["./skills/skill-name-1", "./skills/skill-name-2"]
    }
  ]
}
```

新增技能后，需要将路径添加到相应 `plugin.skills` 数组中。

## 新增技能流程

1. 在 `skills/` 下创建新目录（kebab-case 命名）
2. 参考 `templates/skill-template/SKILL.md` 创建 `SKILL.md`
3. 确保 frontmatter 的 `name` 与目录名一致
4. 编写清晰的 `description`（触发场景，非实现细节）
5. 运行 `./scripts/validate-skills.sh` 验证
6. 更新 `.claude-plugin/marketplace.json` 添加新技能路径
7. 更新 `README.md` 技能列表

## 技能模板

使用 `templates/skill-template/SKILL.md` 作为新技能起点：

```markdown
---
name: your-skill-name
description: 当用户出现某类明确需求时使用
---

# Your Skill Name

一句话说明技能功能。

## 触发场景
- 场景 1
- 场景 2
```
