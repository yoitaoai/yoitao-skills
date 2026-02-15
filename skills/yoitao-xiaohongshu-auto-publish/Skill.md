---
name: yoitao-xiaohongshu-auto-publish-小红书无人值守自动生图
description: 小红书无人值守自动生图，使用预设配置直接生成图文内容，无需确认，只返回最终结果。
---

# 小红书无人值守自动生图 Skill

**核心特点：全自动、零交互、只给结果**

## 🚀 功能特点

- ⚡ **无人值守**：使用预设配置，跳过所有确认步骤
- 🎯 **一键生成**：输入内容主题，直接获得4张图片
- 🎨 **预设风格**：默认使用 pop 风格 + 视觉优先策略
- 💧 **自动水印**："飞花无双"水印自动添加
- 📁 **智能归档**：自动保存到 `自媒体/图文/{日期}/` 目录
- 🖼️ **清理冗余**：只保留图片和提示词，删除中间文件

## 📋 预设配置（上次选择）

```yaml
# 用户偏好（固定配置，无需确认）
核心卖点: 情感陪伴 - 24小时贴心在线
目标受众: 孤独人群 - 需要情感陪伴
呈现方式: 真实体验分享
大纲策略: Strategy C - 视觉优先型
视觉风格: pop（高冲击力、赛博朋克）
视觉元素: 默认设置（gradient-radial背景 + stars-sparkles装饰）
布局方式: sparse（封面/结尾）+ comparison/mindmap（中间）
图片数量: 4张
```

## 🎯 使用方法

### 基础用法

```bash
# 输入主题，直接生成
/yoitao-xiaohongshu-auto-publish "AI女友上线"

# 使用文件
/yoitao-xiaohongshu-auto-publish article.md

# 使用URL
/yoitao-xiaohongshu-auto-publish https://example.com/article
```

### 高级用法（覆盖默认值）

```bash
# 指定不同风格（临时覆盖）
/yoitao-xiaohongshu-auto-publish "主题" --style warm

# 指定图片数量（临时覆盖）
/yoitao-xiaohongshu-auto-publish "主题" --count 5
```

## 🔄 执行流程

### 自动化流程（无需人工干预）

```
输入 → 配置检查 → 内容分析 → 直接选择Strategy C → 生成图片 → 清理文件 → 输出报告
```

**跳过的步骤**：

- ❌ 不询问核心卖点
- ❌ 不询问目标受众
- ❌ 不询问呈现方式
- ❌ 不显示3个策略对比
- ❌ 不确认风格和元素
- ✅ 直接使用预设配置生成

### 详细步骤

#### Step 1: 环境准备

```bash
# 1.1 创建输出目录
today=$(date +%Y%m%d)
output_dir="自媒体/图文/${today}"
mkdir -p "${output_dir}"

# 1.2 更新 EXTEND.md 配置
cat > .baoyu-skills/baoyu-xhs-images/EXTEND.md << 'EOF'
---
# 小红书自动生图 - 无人值守配置

# 水印设置
watermark:
  enabled: true
  content: "飞花无双"
  position: bottom-right
  style: subtle

# 图片生成设置
image_generation:
  skill: baoyu-danger-gemini-web
  session_id_prefix: xhs-deploy

# 输出目录设置
output:
  base_directory: 自媒体/图文
  date_format: YYYYMMDD

# 用户偏好（固定配置）
user_preferences:
  # Step 2 确认（自动应答）
  core_selling_point: "情感陪伴 - 24小时贴心在线"
  target_audience: "孤独人群 - 需要情感陪伴"
  presentation_style: "真实体验分享"

  # Step 4 确认（自动应答）
  outline_strategy: "c"  # Strategy C - 视觉优先型
  visual_style: "pop"    # 使用策略推荐风格
  visual_elements: "default"  # 使用风格默认设置

# 自动化模式
automation:
  enabled: true
  skip_confirmations: true
  auto_select_strategy: "c"
  auto_cleanup: true  # 自动清理中间文件

# 默认风格偏好
preferred_style: "pop"
preferred_layout: "sparse"

# 语言偏好
language: zh-CN
EOF
```

#### Step 2: 内容分析（静默模式）

- 分析内容类型和主题
- 自动确定图片数量（4张）
- **跳过用户确认**，直接使用预设

#### Step 3: 策略选择（自动）

- **不生成** Strategy A 和 B
- **直接使用** Strategy C（视觉优先型）
- 风格：pop，元素：默认

#### Step 4: 图片生成

```bash
# 使用 baoyu-danger-gemini-web 生成4张图片
# P1: 封面（sparse布局）
# P2: 情感冲击对比（comparison布局）
# P3: 功能视觉化（mindmap布局）
# P4: 行动号召（sparse布局）

# 每张图片自动添加"飞花无双"水印
```

#### Step 5: 自动清理

```bash
# 删除中间文件，只保留核心输出
cd "${output_dir}/<topic-slug>/"

# 保留：
# - 4张图片 (*.png)
# - 提示词 (prompts/*.md)
# - 最终大纲 (outline.md)

# 删除：
rm -f analysis.md
rm -f outline-strategy-a.md
rm -f outline-strategy-b.md
# outline-strategy-c.md 保留（它就是outline.md）
```

#### Step 6: 生成报告

- 输出图片列表和路径
- 提供小红书发布建议
- **不显示**详细的策略分析过程

## 📦 输出结构

```
自媒体/图文/20260210/<topic-slug>/
├── 01-cover-<slug>.png          # 封面图
├── 02-emotional-<slug>.png      # 情感对比图
├── 03-features-<slug>.png       # 功能展示图
├── 04-cta-<slug>.png           # CTA图
├── outline.md                   # 最终大纲（Strategy C）
└── prompts/
    ├── 01-cover-<slug>.md      # 封面提示词
    ├── 02-emotional-<slug>.md  # 对比图提示词
    ├── 03-features-<slug>.md   # 功能图提示词
    └── 04-cta-<slug>.md       # CTA提示词
```

**清理后只有 6 个文件**（对比原版的 13+ 个文件）

## 🎨 默认策略详情

### Strategy C: 视觉优先型 - 氛围冲击路线

**核心思路**: 用强烈的视觉冲击力传递情感，最小化文字，让画面说话。

#### 图片规划

| 序号 | 类型     | Hook               | 布局       | 特点                             |
| ---- | -------- | ------------------ | ---------- | -------------------------------- |
| P1   | 封面     | "AI女友真的来了🔥" | sparse     | 科技感AI形象，炫彩背景，极简文字 |
| P2   | 情感冲击 | "不再孤单💕"       | comparison | 黑白vs彩色对比，强烈视觉转变     |
| P3   | 功能     | "24/7在线陪伴"     | mindmap    | 中心放射，时钟+对话气泡          |
| P4   | CTA      | "来体验吧👉"       | sparse     | 巨大CTA元素，行动引导            |

#### 视觉风格：pop

**色彩方案**:

- 主色：荧光粉、电蓝色、紫红色
- 辅色：深紫、黑色
- 点缀：白色、荧光黄、青色

**设计元素**:

- 渐变、光效、粒子
- 爆炸、闪电、能量波
- 几何图形、科技线条
- 高对比度设计

**情感氛围**:

- 炫酷、冲击、兴奋
- 未来感、科技感
- 活力、能量、吸引力

## 🛠️ 配置管理

### 查看当前配置

```bash
cat .baoyu-skills/baoyu-xhs-images/EXTEND.md
```

### 修改默认风格

如果想更改默认风格，编辑 EXTEND.md：

```yaml
user_preferences:
  visual_style: 'warm' # 改为温暖风格
  # 或 "cute", "fresh", "bold", "minimal", "retro", "notion"
```

### 修改图片数量

```yaml
user_preferences:
  image_count: 5 # 改为5张（默认4张）
```

## 📊 与原版对比

| 特性     | 原版 (yoitao-xiaohongshu-tuwen-generate) | 无人值守版 (auto-publish)    |
| -------- | -------------------------------- | ---------------------- |
| 用户确认 | 需要2次确认                      | ✅ 零确认              |
| 策略对比 | 生成3个策略供选择                | ✅ 直接使用 Strategy C |
| 中间文件 | 13+ 个文件                       | ✅ 6 个文件            |
| 执行时间 | ~3-5分钟（含确认）               | ✅ ~2-3分钟            |
| 适用场景 | 精细化定制                       | ✅ 批量生产            |

## 🎯 适用场景

### ✅ 推荐使用 deploy 版本

- 批量生成多篇内容
- 已确定风格和策略
- 追求效率的生产环境
- 定时任务自动化

### ❌ 使用原版 tuwen

- 第一次使用，不确定风格
- 需要对比多个策略
- 内容差异大，需要个性化定制
- 需要详细的创作过程记录

## 📝 小红书发布建议模板

每次生成后会自动提供：

### 标题建议（5个选项）

基于内容自动生成，包含emoji和关键词

### 标签建议（8-10个）

混合热门标签和精准标签

### 正文模板

根据策略C的视觉优先特点，提供简洁有力的文案

### 最佳发布时间

- 首选：晚上 21:00-23:00
- 次选：中午 12:00-13:00
- 备选：早上 07:30-08:30

### 互动引导

评论区置顶话术和回复模板

## ⚡ 快速开始

```bash
# 1. 第一次使用，确保 EXTEND.md 配置正确
/yoitao-xiaohongshu-auto-publish "测试主题"

# 2. 检查输出目录
ls -lh 自媒体/图文/$(date +%Y%m%d)/

# 3. 批量生成
topics=("AI助手" "智能陪伴" "黑科技推荐")
for topic in "${topics[@]}"; do
  /yoitao-xiaohongshu-auto-publish "$topic"
done
```

## 🔧 故障排除

### 问题1: 风格不符合预期

**解决**: 修改 EXTEND.md 中的 `preferred_style` 字段

### 问题2: 图片数量不对

**解决**: 策略C固定4张图，如需更多图片使用 `--count` 参数

### 问题3: 生成速度慢

**解决**:

- 检查网络连接（需要访问 Google Gemini）
- 确认 baoyu-danger-gemini-web 配置正确
- 考虑设置代理：`export HTTPS_PROXY=...`

## 📌 注意事项

- ⚡ **首次运行**: 会自动创建/更新 EXTEND.md 配置
- 💾 **文件清理**: 自动删除中间文件，只保留必要内容
- 🎨 **风格一致**: 同一天生成的内容使用相同的 session ID
- 📁 **目录冲突**: 如果 slug 重复，会自动添加时间戳
- 🔄 **图片修改**: 编辑 `prompts/*.md` 后需要手动重新生成

## 🆚 手动覆盖

虽然是无人值守模式，但仍可临时覆盖配置：

```bash
# 覆盖风格
/yoitao-xiaohongshu-auto-publish "主题" --style warm

# 覆盖布局（影响中间2张图）
/yoitao-xiaohongshu-auto-publish "主题" --layout balanced

# 覆盖图片数量
/yoitao-xiaohongshu-auto-publish "主题" --count 5
```

**注意**: 临时覆盖不会修改 EXTEND.md，下次运行仍使用默认配置。

## 🔄 更新日志

### v2.0.0 (2026-02-10) - 无人值守版本

- ✨ 新增自动化模式，跳过所有确认
- 🎯 预设用户偏好配置
- 🗑️ 自动清理中间文件
- ⚡ 只生成 Strategy C，不对比其他策略
- 📦 精简输出，从13+文件减少到6文件
- 🚀 执行时间缩短 30-40%

### v1.0.0 (2026-02-10) - 基础版本

- 🎨 集成 baoyu-xhs-images 核心功能
- 💧 自动配置"飞花无双"水印
- 📁 智能日期目录管理
- 🖼️ 默认使用 Gemini Web 作为生成后端
