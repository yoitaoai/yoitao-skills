---
name: yoitao-xiaohongshu-tuwen-generate-小红书自动生成N篇图片
description: 小红书自动生成 N 篇图片，根据用户输入的网址或md文件或其他内容，生成N篇图片，用于发小红书。
---

# 小红书自动生成 N 篇图片 Skill

自动生成小红书图文内容的便捷工具，预配置了水印、输出目录和图片生成后端。

## 功能特点

- 🎨 自动使用 baoyu-xhs-images skill 生成精美图片
- 🖼️ 默认使用 baoyu-danger-gemini-web 作为图片生成后端
- 💧 自动添加"Yoitao"水印
- 📁 智能输出到 `自媒体/图文/{date}/` 目录（date格式：YYYYMMDD）
- 📝 支持多种输入源：URL、Markdown文件、纯文本

## 使用方法

```bash
# 使用 Markdown 文件
/yoitao-xiaohongshu-tuwen-generate article.md

# 使用 URL
/yoitao-xiaohongshu-tuwen-generate https://example.com/article

# 直接粘贴内容
/yoitao-xiaohongshu-tuwen-generate
[粘贴你的文章内容]

# 指定风格和布局
/yoitao-xiaohongshu-tuwen-generate article.md --style notion --layout dense

# 指定图片数量
/yoitao-xiaohongshu-tuwen-generate article.md --count 6
```

## 参数说明

| 参数       | 说明                            | 示例                                     |
| ---------- | ------------------------------- | ---------------------------------------- |
| `input`    | 输入源（文件路径/URL/直接粘贴） | `article.md` 或 URL                      |
| `--style`  | 视觉风格（可选）                | `cute`, `notion`, `warm`, `bold` 等      |
| `--layout` | 布局方式（可选）                | `sparse`, `balanced`, `dense`, `list` 等 |
| `--count`  | 图片数量（可选，2-10）          | `--count 5`                              |

## 工作流程

1. **准备阶段**
   - 检查并创建今日输出目录：`自媒体/图文/{YYYYMMDD}/`
   - 验证输入源（文件/URL/文本）

2. **配置 EXTEND.md**
   - 如果 `.baoyu-skills/baoyu-xhs-images/EXTEND.md` 不存在，自动创建
   - 配置水印：`Yoitao`
   - 配置输出目录：`自媒体/图文/{当天日期}/`
   - 配置图片生成后端：`baoyu-danger-gemini-web`

3. **调用 baoyu-xhs-images**
   - 传递用户输入和参数
   - 使用预配置的设置生成图片
   - 图片自动保存到今日目录

4. **完成报告**
   - 显示生成的图片列表
   - 显示输出目录路径
   - 提供小红书发布建议

## 自动配置

### EXTEND.md 配置示例

```yaml
---
watermark:
  enabled: true
  content: '飞花无双'
  position: bottom-right
  style: subtle

image_generation:
  skill: baoyu-danger-gemini-web
  session_id_prefix: xhs-yoitao

output:
  base_directory: 自媒体/图文
  date_format: YYYYMMDD
  structure: '{base_directory}/{date}/'

language: zh-CN
---
```

### 目录结构示例

```
自媒体/图文/20260210/
├── source-article.md                 # 源内容
├── analysis.md                       # 内容分析
├── outline-strategy-a.md             # 策略A大纲
├── outline-strategy-b.md             # 策略B大纲
├── outline-strategy-c.md             # 策略C大纲
├── outline.md                        # 最终选定大纲
├── prompts/
│   ├── 01-cover-article.md          # 封面提示词
│   ├── 02-content-article.md        # 内容提示词
│   └── ...
├── 01-cover-article.png             # 封面图
├── 02-content-article.png           # 内容图1
├── 03-content-article.png           # 内容图2
└── NN-ending-article.png            # 结尾图
```

## 执行逻辑

### Step 1: 初始化

```bash
# 获取今天日期
today=$(date +%Y%m%d)

# 创建输出目录
output_dir="自媒体/图文/${today}"
mkdir -p "${output_dir}"
```

### Step 2: 配置 EXTEND.md

```bash
# 检查配置文件
config_file=".baoyu-skills/baoyu-xhs-images/EXTEND.md"

if [ ! -f "${config_file}" ]; then
  # 创建配置目录
  mkdir -p .baoyu-skills/baoyu-xhs-images

  # 写入配置
  cat > "${config_file}" << 'EOF'
---
watermark:
  enabled: true
  content: "飞花无双"
  position: bottom-right
  style: subtle

image_generation:
  skill: baoyu-danger-gemini-web
  session_id_prefix: xhs-yoitao

output:
  base_directory: 自媒体/图文
  date_format: YYYYMMDD

language: zh-CN
---
EOF
fi
```

### Step 3: 调用 baoyu-xhs-images

```
根据用户输入调用 baoyu-xhs-images skill，传递：
- 输入源（文件/URL/文本）
- 可选参数（style, layout, count）
- 输出目录：今日目录
```

### Step 4: 完成报告

```
显示：
- 生成的图片数量和文件名
- 输出目录完整路径
- 小红书发布建议（标题、标签等）
```

## 风格和布局选项

### 可用风格（Style）

- `cute` - 可爱甜美风（默认）
- `fresh` - 清新自然风
- `warm` - 温暖亲和风
- `bold` - 高冲击力风格
- `minimal` - 极简风
- `retro` - 复古风
- `pop` - 活力风
- `notion` - 简约线条风
- `chalkboard` - 黑板粉笔风
- `study-notes` - 手写笔记风

### 可用布局（Layout）

- `sparse` - 极简布局（1-2个要点）
- `balanced` - 平衡布局（3-4个要点）
- `dense` - 密集布局（5-8个要点）
- `list` - 列表排版（4-7项）
- `comparison` - 对比布局
- `flow` - 流程布局（3-6步）
- `mindmap` - 思维导图布局（4-8分支）
- `quadrant` - 四象限布局

## 小红书发布建议

生成完成后，会自动提供：

1. **标题建议**
   - 3-5个吸引眼球的标题选项
   - 包含emoji和关键词

2. **标签建议**
   - 5-10个相关话题标签
   - 混合热门标签和精准标签

3. **发布时机**
   - 最佳发布时间段建议
   - 基于内容类型的推荐

4. **互动话术**
   - 引导评论的问题
   - 提高互动率的技巧

## 注意事项

- 📅 **日期目录**: 每天的图片会自动归档到独立目录
- 💧 **水印位置**: 默认右下角，不会影响主要内容展示
- 🎨 **图片生成**: 使用 Gemini Web API，质量稳定
- 📝 **内容备份**: 所有提示词和分析文件都会保存，方便后续修改
- 🔄 **图片修改**: 如需修改图片，更新对应的 prompt 文件后重新生成

## 常见问题

**Q: 如何修改水印内容？**
A: 编辑 `.baoyu-skills/baoyu-xhs-images/EXTEND.md` 文件中的 `watermark.content` 字段。

**Q: 如何更改输出目录？**
A: 编辑 EXTEND.md 中的 `output.base_directory` 字段，或在调用时指定完整路径。

**Q: 如何调整图片数量？**
A: 使用 `--count` 参数指定，范围 2-10 张。系统会根据内容长度自动建议合适的数量。

**Q: 生成的图片质量不满意怎么办？**
A: 可以修改对应的 prompt 文件（在 `prompts/` 目录下），然后重新生成该图片。

**Q: 如何更换图片生成后端？**
A: 编辑 EXTEND.md 中的 `image_generation.skill` 字段，改为其他可用的图片生成 skill。

## 高级用法

### 批量生成多篇内容

```bash
# 为多个文章生成图片
for file in articles/*.md; do
  /yoitao-xiaohongshu-tuwen-generate "$file"
done
```

### 自定义输出目录

```bash
# 生成到特定主题目录
/yoitao-xiaohongshu-tuwen-generate article.md --output 自媒体/图文/20260210/美食测评
```

### 组合风格和布局

```bash
# 知识干货 - notion风格 + 密集布局
/yoitao-xiaohongshu-tuwen-generate knowledge.md --style notion --layout dense

# 生活分享 - 温暖风格 + 平衡布局
/yoitao-xiaohongshu-tuwen-generate life.md --style warm --layout balanced

# 产品测评 - 简约风格 + 对比布局
/yoitao-xiaohongshu-tuwen-generate review.md --style minimal --layout comparison
```

## 相关技能

- `baoyu-xhs-images` - 底层图片生成技能
- `baoyu-danger-gemini-web` - 图片生成API
- `xhs-auto-comment` - 小红书自动评论
- `baoyu-post-to-x` - 跨平台内容发布

## 更新日志

### v1.0.0 (2026-02-10)

- ✨ 初始版本发布
- 🎨 集成 baoyu-xhs-images 核心功能
- 💧 自动配置"飞花无双"水印
- 📁 智能日期目录管理
- 🖼️ 默认使用 Gemini Web 作为生成后端
