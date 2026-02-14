---
name: jimeng-sessionid_获取即梦sessionId
description: 自动打开即梦网站，检查登录状态，获取并返回 sessionId cookie 值。当用户需要获取即梦的 sessionId、刷新过期的 sessionId、或其他 skill 需要即梦认证凭据时使用。
---

# Jimeng SessionId Skill

自动打开即梦网站，检查登录状态，获取并直接返回 `sessionId` 值（不写文件）。

## When to Use This Skill

- 用户要求获取即梦 sessionId
- 其他 skill（如 jimeng-api）需要 sessionId 时由其调用
- 刷新过期的 sessionId

## Workflow

### 1. 打开即梦网站

使用 Playwright MCP 导航到：

```
https://jimeng.jianying.com/ai-tool/home
```

### 2. 检查登录状态

获取页面快照，判断：

- 存在 "登录" 按钮 → **未登录**，告知用户在浏览器中完成登录后通知你，保持浏览器打开等待
- 存在会员信息（如 "基础会员"、"高级会员"）→ **已登录**，继续下一步

### 3. 获取 sessionId

使用 `browser_run_code` 执行：

```javascript
async (page) => {
  const cookies = await page.context().cookies();
  const sessionId = cookies.find(
    (c) => c.name === 'sessionid' && (c.domain.includes('jimeng.jianying.com') || c.domain.includes('jianying.com')),
  );
  return sessionId ? sessionId.value : null;
};
```

**注意：Cookie 名称是小写 `sessionid`，不是 `sessionId`。**

### 4. 关闭浏览器并返回结果

- 使用 `browser_close` 清理资源
- 如果获取成功：直接返回 sessionId 值给用户或调用方
- 如果获取失败：告知用户未找到 sessionid，建议刷新页面重试

## Key Info

| 项目        | 值                                       |
| ----------- | ---------------------------------------- |
| 网站        | https://jimeng.jianying.com/ai-tool/home |
| Cookie 名称 | `sessionid` (小写)                       |
| 域名        | `jianying.com`                           |

## Notes

1. sessionId 会过期，需要定期重新获取
2. 登录后可能需要刷新页面才能获取到完整的 cookie
3. 本 skill 不写文件，仅返回 sessionId 值
