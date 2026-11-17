# Changelog

All notable changes to android-cmux are documented here.

## [0.1.0] - 2026-11-17

### 变更（待办清单补齐·续）

- **为什么**：T13–T19 补完后复核，仍有两处没有归属的工作：一是登录 / 配对属于协议 T2、但界面本身没人记（T2 只管认证链）；二是发版形态取决于分发渠道（GitHub Release 还是商店），不定下来 T13 的产物与签名要求就会反复。
- **做了什么**：`TODO.md` 新增 T20（登录 / 配对界面与设置页）与 T21（分发渠道决策），存活取待办 18 条。

### 变更（待办清单补齐）

- **为什么**：上一轮只看清单本身，没把「实现前必须存在的配套」列进去——发版链路、签名、测试防护网、断线续传、平台适配都是真实缺口，不记下来就会在某个环节才发现，那时返工成本最高。
- **做了什么**：`TODO.md` 新增 T13（tag → Release 上传 APK）、T14（发布签名走 Secrets）、T15（单测与回归防护网挂 required check）、T16（断线重连与游标恢复）、T17（补 Gradle wrapper）、T18（校正版本口径）、T19（Android 平台适配：安全区 / IME / 返回手势 / 字号缩放）；T1 补上「iroh-ffi 版本必须钉成 `1.2.0-cmux.1`」；T5 完成并归档。活跃待办 16 条。
- **依据**：T13 / T17 / T18 是文档与实现不一致（文档声称 Release 附 APK、写 `./gradlew` 但仓库无 wrapper、骨架版与首个可用版共用 0.1.0）；T14 / T15 是发布与回归防护的前提；T16 / T19 是移动端必需但之前只写在 `UI.md` 或协议说明里、没进待办。

### 新增（LOGO 与视觉标识）

- **为什么**：两版 README 只有徽章、没有 LOGO，仓库在 GitHub 上缺一个一眼能认出的标识；这也是 `commit` skill 第 9a 步的标配缺口（TODO T4）。
- **做了什么**：新增 `assets/logo.svg`（640×200，圆角 28px；深蓝黑渐变底 + 手机轮廓与终端提示符 `>_` 的绿青渐变图形 + 英文名称与定位）；`README.md` / `README_cn.md` 顶部居中区插入 LOGO；T4 归档。
- **校验**：`icon-design` 的文字边界硬校验 `check-text-bounds.py` PASS（无裁切风险），轮廓为圆角矩形、文字全英文。

### 新增（UI 设计基线）

- **为什么**：Android 端还没有界面设计依据，iOS 客户端的布局与交互是唯一现成参照。不先把参照固化成文档，后面每一屏都会各自发挥，返工不可避免。
- **做了什么**：新增 `UI.md`（iOS 参考屏的结构拆解 + Compose 实现映射 + 对齐边界）与 `assets/ui/` 五张参考屏；`TODO.md` 增补 T9（会话列表页）、T10（终端详情页骨架）、T11（键盘工具条）、T12（设计令牌）。
- **边界**：只对齐信息结构与视觉语言，不移植 iOS 的 SwiftUI 代码；图标用 Material Icons 等价物，不原样搬 SF Symbols。

### 新增（项目立项）

- **为什么建**：macOS 侧的 [cmux](https://github.com/xhqing/cmux) 已经有完整的手机端协议栈（Iroh/QUIC 传输、107 个 `mobile.*` RPC、cell 级 render-grid、配对与账号授权），但客户端只有上游那个未开源的 iOS beta。Android 上没有任何可用客户端，而协议已经在 Mac 侧就位。
- **做了什么**：建立独立仓库与 Gradle/Compose 工程骨架、协议对接文档（`DEVELOPMENT.md`）、CI 校验；Android 代码与本仓库之外的项目完全解耦，只按协议对接 cmux 的 Mobile host。
- **边界**：不复用 cmux 的 Swift 代码（cmux 是 GPL-3.0-or-later），只按协议字段独立实现 Kotlin 側。
