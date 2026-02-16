---
name: yoitao-xhs-mcp-skill-小红书MCP技能
description: Automates Xiaohongshu (Little Red Book) engagement by browsing the feed and posting high-quality, contextual comments on image-text posts. Enforces strict rate limits, anti-detection measures, comment quality rules, and cross-batch deduplication. Use when user asks to "run xhs comments", "小红书评论", "小红书互动", or "run xiaohongshu engagement".
---

# 小红书 MCP Skill

> 封装 [xiaohongshu-mcp](https://github.com/xpzouying/xiaohongshu-mcp) 的全部能力，提供统一的调用规范。

---

## 前置检查（每次调用前必做）

### 1. 检查 MCP 是否可用

调用 `mcp__xiaohongshu-mcp__check_login_status` 测试连接。

- **如果工具不存在 / 调用失败**：提示用户安装 xiaohongshu-mcp：
  ```
  ⚠️ xiaohongshu-mcp 未安装或未启动。请按以下步骤操作：
  1. 从 https://github.com/xpzouying/xiaohongshu-mcp/releases 下载对应平台的二进制文件
  2. 先运行 xiaohongshu-login 完成登录
  3. 再运行 xiaohongshu-mcp 启动服务（默认 http://localhost:18060/mcp）
  4. 在 Claude Code 中执行：claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp
  ```
- **如果返回未登录**：调用 `mcp__xiaohongshu-mcp__get_login_qrcode` 获取二维码，提示用户扫码登录。

### 2. 确认登录状态

登录成功后才能继续执行任何操作。

---

## 可用能力一览

| 能力     | MCP 工具                                                     | 章节                              |
| -------- | ------------------------------------------------------------ | --------------------------------- |
| 登录管理 | `check_login_status` / `get_login_qrcode` / `delete_cookies` | [登录管理](#登录管理)             |
| 浏览首页 | `list_feeds`                                                 | [浏览首页](#浏览首页)             |
| 搜索内容 | `search_feeds`                                               | [搜索内容](#搜索内容)             |
| 笔记详情 | `get_feed_detail`                                            | [笔记详情](#笔记详情)             |
| 用户主页 | `user_profile`                                               | [用户主页](#用户主页)             |
| 点赞     | `like_feed`                                                  | [互动操作](#互动操作点赞收藏评论) |
| 收藏     | `favorite_feed`                                              | [互动操作](#互动操作点赞收藏评论) |
| 发评论   | `post_comment_to_feed`                                       | [互动操作](#互动操作点赞收藏评论) |
| 回复评论 | `reply_comment_in_feed`                                      | [互动操作](#互动操作点赞收藏评论) |
| 发布图文 | `publish_content`                                            | [发布图文](#发布图文)             |
| 发布视频 | `publish_with_video`                                         | [发布视频](#发布视频)             |

---

## 登录管理

### 检查登录状态

```
mcp__xiaohongshu-mcp__check_login_status()
```

### 获取登录二维码

```
mcp__xiaohongshu-mcp__get_login_qrcode()
```

返回 Base64 图片，展示给用户扫码。

### 重置登录（谨慎使用）

```
mcp__xiaohongshu-mcp__delete_cookies()
```

删除 cookies 文件，需要重新登录。**仅在登录异常时使用**。

---

## 浏览首页

```
mcp__xiaohongshu-mcp__list_feeds()
```

返回首页推荐的笔记列表。每条笔记包含 `feed_id` 和 `xsec_token`，这两个值是后续所有操作的必要参数。

> **重要**：`xsec_token` 是从 feed 列表获取的访问令牌，几乎所有操作都需要它。

---

## 搜索内容

```
mcp__xiaohongshu-mcp__search_feeds(keyword, filters?)
```

### 参数

| 参数                   | 必填 | 说明                                         |
| ---------------------- | ---- | -------------------------------------------- |
| `keyword`              | 是   | 搜索关键词                                   |
| `filters.sort_by`      | 否   | 综合 / 最新 / 最多点赞 / 最多评论 / 最多收藏 |
| `filters.note_type`    | 否   | 不限 / 视频 / 图文                           |
| `filters.publish_time` | 否   | 不限 / 一天内 / 一周内 / 半年内              |
| `filters.location`     | 否   | 不限 / 同城 / 附近                           |
| `filters.search_scope` | 否   | 不限 / 已看过 / 未看过 / 已关注              |

---

## 笔记详情

```
mcp__xiaohongshu-mcp__get_feed_detail(feed_id, xsec_token, ...)
```

### 参数

| 参数                 | 必填 | 说明                                                            |
| -------------------- | ---- | --------------------------------------------------------------- |
| `feed_id`            | 是   | 笔记 ID                                                         |
| `xsec_token`         | 是   | 访问令牌                                                        |
| `load_all_comments`  | 否   | true 滚动加载更多评论，默认 false（仅前 10 条）                 |
| `limit`              | 否   | 加载评论数量上限，默认 20（需 load_all_comments=true）          |
| `click_more_replies` | 否   | 是否展开二级回复（需 load_all_comments=true）                   |
| `reply_limit`        | 否   | 跳过回复数超过此值的评论，默认 10（需 click_more_replies=true） |
| `scroll_speed`       | 否   | 滚动速度：slow / normal / fast（需 load_all_comments=true）     |

---

## 用户主页

```
mcp__xiaohongshu-mcp__user_profile(user_id, xsec_token)
```

返回用户基本信息、关注/粉丝/获赞量及其笔记列表。

---

## 互动操作（点赞/收藏/评论）

### 风控规则（必须遵守）

- 单次运行互动操作（点赞+收藏+评论合计）**不超过 10 次**。
- 每次操作间隔 **5~15 秒**（随机）。
- 发现任何验证码、频控提示、操作失败：**立刻停止**，报告原因。
- 不要短时间内对同一笔记重复操作。

### 点赞

```
mcp__xiaohongshu-mcp__like_feed(feed_id, xsec_token, unlike?)
```

- `unlike=true` 取消点赞，默认为点赞。
- 已点赞的笔记会自动跳过。

### 收藏

```
mcp__xiaohongshu-mcp__favorite_feed(feed_id, xsec_token, unfavorite?)
```

- `unfavorite=true` 取消收藏，默认为收藏。
- 已收藏的笔记会自动跳过。

### 发表评论

```
mcp__xiaohongshu-mcp__post_comment_to_feed(feed_id, xsec_token, content)
```

#### 评论质量规则

- 不允许重复评论；同一批次内评论相似度要低（句式/用词/标点/emoji 都变化）。
- 每条评论必须引用该帖可见内容里的至少 1 个具体细节。
- 每条评论长度 12~45 个中文字符，最多 1 个 emoji。
- 语气：温和、真诚、像路过看到干货忍不住留言；不要营销口吻。
- **禁止套话**：太棒了、学到了、马住了、收藏了、写得好、干货满满、好厉害、绝了、爱了、YYDS。
- 评论应包含个人化视角，如"我之前也试过XX"、"原来XX可以这样"等。
- 偶尔（约 1/3 概率）可以提一个小疑问，增加互动感。

### 回复评论

```
mcp__xiaohongshu-mcp__reply_comment_in_feed(feed_id, xsec_token, content, comment_id?, user_id?)
```

- `comment_id`：目标评论 ID（从评论列表获取）。
- `user_id`：目标评论用户 ID。
- 回复同样遵守上述评论质量规则。

---

## 发布图文

```
mcp__xiaohongshu-mcp__publish_content(title, content, images, tags?, schedule_at?)
```

### 参数

| 参数          | 必填 | 说明                                                      |
| ------------- | ---- | --------------------------------------------------------- |
| `title`       | 是   | 标题，**最多 20 个中文字**                                |
| `content`     | 是   | 正文，**最多 1000 字**，不要包含 # 标签（用 tags 参数）   |
| `images`      | 是   | 图片路径数组，**至少 1 张**，支持 HTTP 链接或本地绝对路径 |
| `tags`        | 否   | 话题标签数组，如 `["美食", "旅行"]`                       |
| `schedule_at` | 否   | 定时发布，ISO8601 格式，支持 1 小时~14 天内               |

### 发布注意事项

- **标题**：控制在 20 字以内，建议包含关键词，吸引点击。
- **正文**：不要在正文中写 `#标签`，所有话题标签通过 `tags` 参数传入。
- **图片**：
  - 推荐使用本地绝对路径（更稳定）。
  - 建议图片比例 3:4（竖屏）或 1:1（方形），适合小红书展示。
  - 图片数量建议 3~9 张，第一张为封面图要精心选择。
  - 支持 JPG、PNG、WebP 格式。
- **标签**：建议 3~5 个相关话题标签，提高曝光。
- **定时发布**：格式示例 `2026-02-20T10:30:00+08:00`。

### 发布前检查清单

1. 标题是否不超过 20 字？
2. 正文是否不超过 1000 字？
3. 正文中是否不含 # 标签？
4. 图片是否至少 1 张且路径正确？
5. 确认用户同意发布内容？（**发布前必须让用户确认**）

---

## 发布视频

```
mcp__xiaohongshu-mcp__publish_with_video(title, content, video, tags?, schedule_at?)
```

### 参数

| 参数          | 必填 | 说明                                    |
| ------------- | ---- | --------------------------------------- |
| `title`       | 是   | 标题，**最多 20 个中文字**              |
| `content`     | 是   | 正文，**最多 1000 字**，不要包含 # 标签 |
| `video`       | 是   | **本地视频绝对路径**（仅支持单个视频）  |
| `tags`        | 否   | 话题标签数组                            |
| `schedule_at` | 否   | 定时发布，ISO8601 格式                  |

### 视频注意事项

- **仅支持本地文件**，不支持 HTTP 链接。
- 建议文件大小 **不超过 1GB**。
- 建议竖屏 9:16 比例，适合小红书展示。
- 支持 MP4 格式。
- 发布前同样需要用户确认。

---

## 通用规则

### 安全与合规

- **所有发布操作（图文/视频）必须在执行前让用户确认内容**。
- 不发布违规、侵权、虚假信息。
- 不进行批量灌水、恶意引流等违规操作。
- 遵守小红书社区规范。

### 频率控制

- 发布操作：建议每天不超过 3 篇。
- 互动操作（点赞/收藏/评论）：单次不超过 10 次，间隔 5~15 秒。
- 搜索操作：无严格限制，但避免高频调用。

### 错误处理

- 登录过期：自动调用 `get_login_qrcode` 引导用户重新登录。
- 操作失败：记录错误信息，报告给用户，不要重试（避免触发风控）。
- 网络异常：等待 10 秒后重试一次，仍失败则停止并报告。

---

## 典型用法示例

### 浏览并互动

```
1. check_login_status → 确认登录
2. list_feeds → 获取首页推荐
3. get_feed_detail(feed_id, xsec_token) → 查看感兴趣的笔记
4. like_feed(feed_id, xsec_token) → 点赞
5. post_comment_to_feed(feed_id, xsec_token, content) → 评论
```

### 搜索特定内容

```
1. check_login_status → 确认登录
2. search_feeds("护肤", filters={sort_by: "最多点赞", note_type: "图文"})
3. get_feed_detail(feed_id, xsec_token) → 查看详情
```

### 发布图文笔记

```
1. check_login_status → 确认登录
2. 准备标题（≤20字）、正文（≤1000字）、图片路径
3. 展示给用户确认
4. publish_content(title, content, images, tags)
```
