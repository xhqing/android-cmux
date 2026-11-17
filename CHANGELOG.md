# Changelog

All notable changes to android-cmux are documented here.

## [0.1.0] - 2026-11-17

### 新增（UI 设计基线）

- **为什么**：Android 端还没有界面设计依据，iOS 客户端的布局与交互是唯一现成参照。不先把参照固化成文档，后面每一屏都会各自发挥，返工不可避免。
- **做了什么**：新增 `UI.md`（iOS 参考屏的结构拆解 + Compose 实现映射 + 对齐边界）与 `assets/ui/` 五张参考屏；`TODO.md` 增补 T9（会话列表页）、T10（终端详情页骨架）、T11（键盘工具条）、T12（设计令牌）。
- **边界**：只对齐信息结构与视觉语言，不移植 iOS 的 SwiftUI 代码；图标用 Material Icons 等价物，不原样搬 SF Symbols。

### 新增（项目立项）

- **为什么建**：macOS 侧的 [cmux](https://github.com/xhqing/cmux) 已经有完整的手机端协议栈（Iroh/QUIC 传输、107 个 `mobile.*` RPC、cell 级 render-grid、配对与账号授权），但客户端只有上游那个未开源的 iOS beta。Android 上没有任何可用客户端，而协议已经在 Mac 侧就位。
- **做了什么**：建立独立仓库与 Gradle/Compose 工程骨架、协议对接文档（`DEVELOPMENT.md`）、CI 校验；Android 代码与本仓库之外的项目完全解耦，只按协议对接 cmux 的 Mobile host。
- **边界**：不复用 cmux 的 Swift 代码（cmux 是 GPL-3.0-or-later），只按协议字段独立实现 Kotlin 側。
