# yoitao-skills

`yoitao-skills` 是一个面向 **Claude Code / Agents** 的技能合集仓库，支持直接通过：

```bash
npx skills add yoitaoai/yoitao-skills
```

安装技能。

## 目标

- 统一托管可复用的 Skills
- 支持 `npx skills add` 一键安装
- 支持 Claude 插件市场（`/plugin marketplace add`）按插件组安装
- 提供可持续扩展的目录规范，便于后续新增更多 Skills

## 安装方式

### 1) npx skills（推荐）

```bash
# 查看可安装技能
npx skills add yoitaoai/yoitao-skills -l

# 安装全部技能（按提示）
npx skills add yoitaoai/yoitao-skills

# 仅安装指定技能
npx skills add yoitaoai/yoitao-skills --skill yoitao-jimeng-sessionid
```

### 2) Claude 插件市场模式（可选）

```bash
/plugin marketplace add yoitaoai/yoitao-skills
```

然后在 Claude Code 中选择插件并安装。

## 当前技能列表

| Skill | 说明 | 状态 |
| --- | --- | --- |
| `yoitao-jimeng-sessionid` | 自动打开即梦页面并提取 `sessionid` Cookie（需 Playwright MCP） | ✅ 维护中 |
| `yoitao-xhs-mcp-skill-小红书MCP技能` | 小红书 MCP 统一能力封装，支持登录、浏览、搜索、互动、发布等完整流程 | ✅ 推荐使用 |
| `yoitao-xiaohongshu-auto-comment-小红书自动评论` | 已过时，不再维护；请迁移到 `yoitao-xhs-mcp-skill-小红书MCP技能` | ⚠️ Deprecated |

## 仓库结构

```text
.
├── .claude-plugin/
│   └── marketplace.json        # 插件市场入口
├── skills/
│   └── <skill-name>/
│       └── SKILL.md            # 技能定义（必须）
├── templates/
│   └── skill-template/
│       └── SKILL.md            # 新技能模板（不会被安装器当成真实技能）
└── CONTRIBUTING.md             # 贡献与规范
```

## 新增 Skill 规范（摘要）

1. 路径：`skills/<skill-name>/SKILL.md`
2. 命名：`<skill-name>` 使用小写和中划线，例如 `yoitao-jimeng-sessionid`
3. Frontmatter 必须包含：
   - `name`: 与目录名一致
   - `description`: 清晰描述触发场景（何时使用）
4. 保持技能自包含；重型文档放到 skill 子目录的 `references/`，脚本放 `scripts/`

完整规范见 `CONTRIBUTING.md`。

## 发布前校验

```bash
./scripts/validate-skills.sh
```

该脚本会检查：
- `skills/*/SKILL.md` 是否齐全
- `name` 与目录名是否一致
- 命名是否为 kebab-case
- `description` 是否存在
- `.claude-plugin/marketplace.json` 引用路径是否有效
