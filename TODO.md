# TODO

本仓库的活跃待办。已处理的条目移入 [TODO-archive.md](TODO-archive.md)。

## 🔴 红色（不修会直接导致不可用）

- [ ] **T1** 接通 iroh 传输：从 `iroh-ffi` 生成 Kotlin 绑定并编出 Android ABI（arm64-v8a / armeabi-v7a），先跑通「连上 Mac 的 control lane」（记录：2026-11-17 14:50）
  **背景**：`manaflow-ai/iroh-ffi` 有 `README.kotlin.md` 与 Android NDK 交叉编译说明（API 29），但仓库没有发布到 Maven，需要本地/CI 构建绑定。
  **验收**：一个能被 app 调用的 Kotlin API，能建立 QUIC 连接并收发一个 control lane 帧。

## 🟠 橙色（边界情况、防护缺口）

- [ ] **T2** 配对的认证链：Stack Auth 没有 Kotlin/Android SDK，需要自己封装 REST（登录 / token 刷新 / 吊销），并把 Swift CryptoKit 的设备签名换成 Android Keystore（记录：2026-11-17 14:50）
- [ ] **T3** lane header 与 JSON 消息：按 `CmuxIrohStreamHeader` 逐字节对齐 6 种 lane，并按 `CMUXMobileCore` 的 Codable 定义生成 Kotlin data class（含 snake_case 字段名）（记录：2026-11-17 14:50）

## 🟡 黄色（文档、格式、卫生）

- [ ] **T5** `TODO-archive.md` / `MEMO.md` 首次出现需求时再建，不预建空文件（记录：2026-11-17 14:50）
- [ ] **T9** 会话列表页（Workspaces）+ 底部浮动搜索框，按 `UI.md` 的顶栏三胶囊 / 列表行 / 头像配色实现（记录：2026-11-17 21:53）
  **前置**：会话列表 RPC 字段先按 T3 对齐；列表先用假数据把布局与主题定死
- [ ] **T12** 设计令牌集中到 `app/src/main/java/dev/xhqing/androidcmux/ui/theme/`（纯黑底 + 浮层灰 + 胶囊圆角 + 字号层级），屏里不写裸值（记录：2026-11-17 21:53）

## 🟢 绿色（计划类新功能）

- [ ] **T6** MVP 终端：用 `render-grid` 的 cell 快照 + 增量帧在 Compose Canvas 上画终端（不移植 VT 解析器），支持输入回传（记录：2026-11-17 14:50）
- [ ] **T7** MVP agent 聊天：`mobile.chat.*` 会话列表 + 历史 + 发送 + 中断（记录：2026-11-17 14:50）
- [ ] **T8** 浏览器面板流（`mobile.browser.*`）与通知（FCM，需要 cmux 侧配合）（记录：2026-11-17 14:50）
- [ ] **T10** 终端详情页骨架：顶栏（返回 + 标题胶囊 + `>_`）、会话头三行、终端状态条、输入区——先静态版，画布接 T6（记录：2026-11-17 21:53）
- [ ] **T11** 键盘工具条：`↑` / `Tab` / `⌘` / 粘贴 / `Esc` 等横滚胶囊键，按下映射成 `terminalInput` lane 帧（记录：2026-11-17 21:53）
