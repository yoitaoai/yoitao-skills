# 贡献指南（Skills 仓库规范）

本文用于统一 `yoitao-skills` 的结构和质量标准，保证仓库可被 `npx skills add` 稳定安装。

## 目录约定

- 所有可发布技能放在：`skills/<skill-name>/`
- 每个技能必须有：`SKILL.md`
- 可选资源目录：
  - `skills/<skill-name>/scripts/`
  - `skills/<skill-name>/references/`
  - `skills/<skill-name>/assets/`
- 模板或草稿不要放在 `skills/` 下，避免被安装器误识别

## 命名规范

- 技能目录名：小写 + 中划线（kebab-case）
  - 示例：`yoitao-jimeng-sessionid`
- `SKILL.md` frontmatter 的 `name` 必须与目录名一致
- 避免使用空格、中文、下划线或特殊符号作为技能名

## SKILL.md 最小要求

```markdown
---
name: your-skill-name
description: 何时触发该 skill（明确场景）
---
```

- `description` 重点写触发条件，而不是长篇实现细节
- 正文建议包含：
  - 目标与输入输出
  - 执行流程
  - 关键参数
  - 错误处理或注意事项

## 发布入口维护

- `README.md`：同步更新技能列表与安装说明
- `.claude-plugin/marketplace.json`：
  - 新增技能后，将路径加入对应 `plugins[].skills`
  - 版本更新时同步修改 `metadata.version`

## 新增 Skill 检查清单

1. 技能路径是否为 `skills/<name>/SKILL.md`
2. `name` 是否等于 `<name>` 且为 kebab-case
3. `description` 是否清晰描述触发场景
4. `npx skills add yoitaoai/yoitao-skills -l` 是否能看到新 skill
5. README 与 marketplace 是否已同步更新

## 本地校验命令

```bash
./scripts/validate-skills.sh
```
