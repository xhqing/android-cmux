# android-cmux · 项目硬约束

身份与角色见本仓库根 `AGENTS.md`；团队通用规则见全局 `~/.pi/agent/AGENTS.md`，此处不重述。

## 本项目是什么

cmux 的 Android 客户端。对标上游那个未开源的 iOS beta：在手机上连到 macOS 上的 cmux，看终端与编码 agent 会话、必要时接管输入。

**与 cmux 仓库代码解耦**：本项目不复用 cmux 的 Swift 代码（cmux 是 GPL-3.0-or-later），只按协议独立实现 Kotlin 侧。

## 协议对接（改任何网络/终端代码前必读）

Mac 侧（cmux 仓库）提供的是：

- **传输**：Iroh（QUIC + NAT 穿透）。依赖 `manaflow-ai/iroh-ffi` 的 Kotlin 绑定；版本必须与 cmux 侧钉的一致（cmux 用 `1.2.0-cmux.1.ios17`）
- **lane header**：每条 QUIC 流开头的二进制头，6 种 lane —— `control`（必须带 admission credential）、`serverEvents(cursor)`、`terminal(resourceID,cursor)`、`terminalInput(resourceID)`、`artifact(resourceID,offset)`、`simulatorStream(resourceID)`
- **RPC**：JSON（Swift Codable），107 个 `mobile.*` 方法；字段名是 snake_case（如 `render_revision_floor`）
- **终端**：host 侧已算好 `render-grid`（`cmux.render-grid.v1`：columns/rows/cursor/styles/rowSpans/activeScreen/modes/主题色，全量与增量帧）。**不要在 Android 上重造 VT 解析器**，按 span 画格子
- **认证**：v2 配对 = Stack Auth 账号 + 设备身份签名 + 一次性 attach ticket（无 QR）；token refresh 最多合并 30 秒；断开后本地授权最多保留 7 天
- **协议参照物**：cmux 仓库的 `Packages/iOS/CmuxMobile*`（6 个包）与 `Packages/Shared/CMUXMobileCore`。协议演进时以那边为准，本项目跟随

## 构建

- **Gradle + Kotlin + Jetpack Compose**；`minSdk 29`（iroh-ffi 的 Android 要求），`compileSdk 34`
- **本机没有 Android SDK**（只有 JDK 17 与 adb）：构建与验证在 CI 跑（`.github/workflows/android-build.yml`），本机只做 Kotlin 语法层面的改动
- 新增依赖前先确认它支持 Android API 29，且不会把 APK 撑得过大

## 绝对不要做的事

- **不把 cmux 的 Swift 代码搬到本项目**：那是 GPL-3.0-or-later 代码，搬进来本项目就得跟 GPL；协议是接口，独立实现才安全
- **不硬编码 Mac 侧的主机名/IP/端口**：连接信息全部来自配对流程
- **不在日志里打印 token、attach ticket、设备私钥**
- **不改 `minSdk`**：iroh-ffi 的绑定要求 API 29 起

## 验证清单（改行为后必须过）

1. `./gradlew assembleDebug` 通过（CI 或装好 SDK 的本机）
2. `./gradlew lint` 无新增 error
3. 涉及协议字段时，逐字段对照 `Packages/Shared/CMUXMobileCore` 的 Codable 定义（字段名大小写、可选性、默认值）
