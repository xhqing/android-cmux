# Changelog

All notable changes to android-cmux are documented here.

## [0.1.0] - 2026-11-17

### 新增（项目立项）

- **为什么建**：macOS 侧的 [cmux](https://github.com/xhqing/cmux) 已经有完整的手机端协议栈（Iroh/QUIC 传输、107 个 `mobile.*` RPC、cell 级 render-grid、配对与账号授权），但客户端只有上游那个未开源的 iOS beta。Android 上没有任何可用客户端，而协议已经在 Mac 侧就位。
- **做了什么**：建立独立仓库与 Gradle/Compose 工程骨架、协议对接文档（`DEVELOPMENT.md`）、CI 校验；Android 代码与本仓库之外的项目完全解耦，只按协议对接 cmux 的 Mobile host。
- **边界**：不复用 cmux 的 Swift 代码（cmux 是 GPL-3.0-or-later），只按协议字段独立实现 Kotlin 側。
