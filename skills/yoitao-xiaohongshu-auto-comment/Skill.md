---
name: yoitao-xiaohongshu-auto-comment-小红书自动评论
description: Automates Xiaohongshu (Little Red Book) engagement by browsing the feed and posting high-quality, contextual comments on image-text posts. Enforces strict rate limits, anti-detection measures, comment quality rules, and cross-batch deduplication. Use when user asks to "run xhs comments", "小红书评论", "小红书互动", or "run xiaohongshu engagement".
---

# 小红书自动互动 Skill

## Overview

合规的小红书运营助手。目标：帮助用户做高质量互动，而不是批量灌水。
使用 Playwright MCP 操作浏览器。

---

## 规则（必须遵守）

### 风控规则

- 单次运行最多评论 **3 条帖子**，两次运行间隔至少 30 分钟。
- 发现任何验证码、频控、弹窗提示异常、评论发送失败：**立刻停止**，截图并报告原因。
- 如果评论框无法定位或输入失败，截图后自动跳过该帖。
- 每次操作前先做一次 snapshot 确认页面状态。

### 评论质量规则

- 不允许重复评论；同一批次内评论相似度要低（句式/用词/标点/emoji 都变化）。
- 每条评论必须引用该帖可见内容里的至少 1 个具体细节（关键词/数字/地点/品牌/步骤/物品）。
- 每条评论长度 12~45 个中文字符为主，最多 1 个 emoji。
- 整体语气：温和、真诚、像路过看到干货忍不住留言；不要营销口吻。
- 签名尾巴在本批次中最多出现 1 次：'飞花路过～' 或 '2026 冲！' 二选一。

### 评论内容禁区

- **禁止套话**：太棒了、学到了、马住了、收藏了、写得好、干货满满、好厉害、绝了、爱了、YYDS。
- 评论应包含个人化视角，如"我之前也试过XX"、"原来XX可以这样"、"这个XX我一直没搞懂，看完懂了"等。
- 偶尔（约 1/3 概率）可以提一个小疑问，增加互动感。

### 帖子过滤规则

- 跳过广告/推广帖（判断标识："赞助"/"广告"/"推广"标签）。
- 跳过视频帖（优先处理图文帖，图文内容更容易提取上下文）。
- 如果帖子关闭了评论功能，自动跳过。

---

## Workflow

### 1. 检查运行环境

检查 Playwright MCP 是否已安装。如果没有，提示用户安装并提供安装命令

### 2. 打开小红书，检测登录状态

使用 Playwright MCP 打开 `https://www.xiaohongshu.com`。做一次 snapshot 检查登录状态。如果未登录，必须停在登录页并提示用户完成登录；检测到已登录后继续。

### 3. 预热浏览

在首页随机滚动 2~3 屏，停留 30~60 秒，模拟正常用户浏览行为。

### 4. 定位目标帖子

回到首页信息流顶部，按「帖子过滤规则」筛选前 3 个可评论的图文帖。

### 5. 逐帖执行评论

对每个帖子依次执行：

a) 点击打开详情（detail modal / 详情页）。

b) 抽取帖子内容：标题/正文前 120 字、话题 tag、作者名（能拿多少拿多少）。

c) 基于抽取内容，生成 3 条"高质量评论候选"（遵守所有评论规则），内部评估并自动选择最自然、最贴合帖子内容的 1 条发送。

d) 定位评论输入框，输入评论内容，点击发送。

e) 发送后验证评论是否出现在评论区（snapshot 确认）。若失败则截图记录。

f) 关闭详情，等待随机 15~40 秒再处理下一条。

### 6. 保存日志，输出摘要

处理完毕后：

a) 将本次互动数据追加写入 `自媒体/AI自动运营/小红书_comments_log.json`，格式：

```json
{
  "date": "2026-02-08T14:30:00",
  "comments": [
    {
      "post_url": "帖子链接",
      "author": "作者名",
      "post_title": "帖子标题摘要",
      "comment_sent": "实际发送的评论",
      "candidates": ["候选1", "候选2", "候选3"],
      "status": "success/failed/skipped",
      "reason": "失败或跳过的原因（成功则为空）",
      "timestamp": "2026-02-08T14:32:15"
    }
  ]
}
```

b) 输出本次运行摘要：共处理 X 帖，成功 Y 条，跳过 Z 条，失败 W 条。
