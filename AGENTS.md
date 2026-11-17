# android-cmux

> dev-agent（Atlas）名下的子项目 · 本项目规则本体

cmux 的 Android 客户端：在 Android 手机上连接 macOS 上的 [cmux](https://github.com/xhqing/cmux)，看终端、看编码 agent 在干什么、必要时接管输入。与本项目之外的 cmux 仓库**代码解耦**，只按协议对接。

## 归谁负责

本项目由 **Atlas**（dev-agent）负责维护。改动范围跨出本项目时（例如需要 cmux 侧新增 FCM 推送），先向 Atlas 说明，不自行扩张改动面。

## 你的角色

你在本项目（或其 worktree）里干活时，是 Atlas 派来的 **Worker**：只做当前 worktree 里的这一件事，干完向 Atlas 汇报——改了什么、验证结果、PR 号、遗留问题。

- **不碰 local main、不建 / 删 worktree**——那是 Atlas（Leader）的活。
- 上下文不够时向 Atlas 问，不要凭猜测改代码。
- 本项目的硬约束写在 `.pi/APPEND_SYSTEM.md`（会话启动时自动加载），动代码前先看一遍。

## 项目规则在哪

| 内容 | 位置 |
|---|---|
| 本项目硬约束、协议约束、构建要求 | `.pi/APPEND_SYSTEM.md`（自动加载） |
| 技术栈、协议对接方式、构建与发布 | `DEVELOPMENT.md` |
| 版本 / 变更 | `VERSION`、`CHANGELOG.md` |
| 待办 | `TODO.md` |
| 贡献者版权与许可 | `CONTRIBUTING.md` / `CONTRIBUTING_cn.md` |
