# TODO

本仓库的活跃待办。已处理的条目移入 [TODO-archive.md](TODO-archive.md)。

## 🔴 红色（不修会直接导致不可用）

- [ ] **T1** 接通 iroh 传输：从 `iroh-ffi` 生成 Kotlin 绑定并编出 Android ABI（arm64-v8a / armeabi-v7a），先跑通「连上 Mac 的 control lane」（记录：2026-11-17 22:44）
  **背景**：`manaflow-ai/iroh-ffi` 有 `README.kotlin.md` 与 Android NDK 交叉编译说明（API 29），但仓库没有发布到 Maven，需要本地/CI 构建绑定；**版本必须钉成 cmux 侧同一版（`1.2.0-cmux.1`）**，否则协议对不上。
  **验收**：一个能被 app 调用的 Kotlin API，能建立 QUIC 连接并收发一个 control lane 帧。

## 🟠 橙色（边界情况、防护缺口）

- [ ] **T2** 配对的认证链：Stack Auth 没有 Kotlin/Android SDK，需要自己封装 REST（登录 / token 刷新 / 吊销），并把 Swift CryptoKit 的设备签名换成 Android Keystore（记录：2026-11-17 14:50）
- [ ] **T3** lane header 与 JSON 消息：按 `CmuxIrohStreamHeader` 逐字节对齐 6 种 lane，并按 `CMUXMobileCore` 的 Codable 定义生成 Kotlin data class（含 snake_case 字段名）（记录：2026-11-17 14:50）
- [ ] **T13** 发版链路补齐：tag 触发构建 + 把签名 APK 上传到 GitHub Release（当前 CI 只把 debug APK 传成 14 天 artifact，`DEVELOPMENT.md` 声称的「Release 附 APK」并不存在）（记录：2026-11-17 22:44）
- [ ] **T14** 发布签名：release keystore 走 GitHub Secrets（不进仓库），`build.gradle.kts` 补 `signingConfigs` 与 release 构建类型（记录：2026-11-17 22:44）
- [ ] **T15** 测试与回归防护网：JVM 单测覆盖协议编解码（lane header 字节序、snake_case 字段）与 render-grid 网格状态机，并入 CI 的 `pull_request` + `push: main` 并挂 required check（记录：2026-11-17 22:44）
  **口径**：测试由 Leader 出题（先红后绿、只断言对外可观察行为），Worker 不改测试——见全局 `AGENTS.md` 的「测试与回归防护网」节
- [ ] **T16** 断线重连与游标恢复：移动网络切换 / 熄屏后重连，按 lane header 的 cursor 从 `serverEvents` 与 `terminal` 续传，不能掉线就重拉全量（记录：2026-11-17 22:44）

## 🟡 黄色（文档、格式、卫生）

- [ ] **T9** 会话列表页（Workspaces）+ 底部浮动搜索框，按 `UI.md` 的顶栏三胶囊 / 列表行 / 头像配色实现（记录：2026-11-17 21:53）
  **前置**：会话列表 RPC 字段先按 T3 对齐；列表先用假数据把布局与主题定死
- [ ] **T12** 设计令牌集中到 `app/src/main/java/dev/xhqing/androidcmux/ui/theme/`（纯黑底 + 浮层灰 + 胶囊圆角 + 字号层级），屏里不写裸值（记录：2026-11-17 21:53）
- [ ] **T17** 补 Gradle wrapper（`gradlew` / `gradlew.bat` + `gradle/wrapper/gradle-wrapper.properties`）：现在 `gradle/wrapper/` 是空目录，CI 依赖系统 gradle、`DEVELOPMENT.md` 却写 `./gradlew`，两边不一致（记录：2026-11-17 22:44）
- [ ] **T18** 校正版本口径：`VERSION` 0.1.0 是骨架版，`DEVELOPMENT.md` 里「第一个可用版本定为 0.1.0」需改写成骨架版与首个可用版各自的编号，避免发版时不知该 bump 到哪（记录：2026-11-17 22:44）

## 🟢 绿色（计划类新功能）

- [ ] **T6** MVP 终端：用 `render-grid` 的 cell 快照 + 增量帧在 Compose Canvas 上画终端（不移植 VT 解析器），支持输入回传（记录：2026-11-17 14:50）
- [ ] **T7** MVP agent 聊天：`mobile.chat.*` 会话列表 + 历史 + 发送 + 中断（记录：2026-11-17 14:50）
- [ ] **T8** 浏览器面板流（`mobile.browser.*`）与通知（FCM，需要 cmux 侧配合）（记录：2026-11-17 14:50）
- [ ] **T10** 终端详情页骨架：顶栏（返回 + 标题胶囊 + `>_`）、会话头三行、终端状态条、输入区——先静态版，画布接 T6（记录：2026-11-17 21:53）
- [ ] **T11** 键盘工具条：`↑` / `Tab` / `⌘` / 粘贴 / `Esc` 等横滚胶囊键，按下映射成 `terminalInput` lane 帧（记录：2026-11-17 21:53）
- [ ] **T19** Android 平台适配：`WindowInsets` 安全区（刘海 / 挖孔 / 手势条）、IME 弹出时终端区压缩而不遮挡输入行、系统返回手势导航、终端字号缩放手势（记录：2026-11-17 22:44）
- [ ] **T20** 登录 / 配对界面与设置页：Stack Auth 账号登录、设备配对状态与错误提示（配对失败 / ticket 过期 / 吊销）、设置项（终端字号、主题、连接信息）；iOS 参考屏里没有登录屏，这部分结构需自己定（记录：2026-11-17 22:47）
- [ ] **T21** 分发渠道决策：目前只发 GitHub Release APK；若上 Google Play，需 target 最新 API、AAB 产物、商店素材与隐私政策页——定了渠道才能确定 T13 的产物形态（记录：2026-11-17 22:47）
