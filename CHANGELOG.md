# Changelog

All notable changes to android-cmux are documented here.

## [未发布]

### 变更（AGENTS.md 角色口径更新为三级 agentLeader / subLeader / Worker，2026-11-25）

- **为什么改**：用户 2026-11-25 把全团队 Leader / Worker 重定义为三级角色（agentLeader = Agent 项目主工作区 main、subLeader = 子项目主工作区 main、Worker = 任何项目的非 main 分支 worktree）。原 `AGENTS.md` 写的是「本项目（或其 worktree）= Worker、建删 worktree 是 Atlas（Leader）的活」，把子项目主工作区 main 也说成了 Worker，与全局规则冲突。
- **改了什么**：`AGENTS.md`「你的角色」节改为按「当前是否停在 main」判定——本项目主工作区 main = subLeader（ff 同步 local main、建删自身 worktree、派 Worker、合并自身 PR、发自身版本、回收 Worker，对 dev-agent 与 sibling 只读），非 main 分支 worktree = Worker（只干当前 worktree，不碰 local main、不建删 worktree）；规则索引表里的「Leader / Worker 分工」改为「agentLeader / subLeader / Worker 分工」。`.pi/APPEND_SYSTEM.md` 逐条核对：没有「任何分支 / worktree = Worker」类角色定义，测试只读节里的「Leader」按全局术语口径保留，未改。
- **回归检查**：只改角色表述，项目硬约束、验证要求、测试只读约定一字未动；版本号不动（文档类改动，不触发 bump / 发版）。

## [0.1.0] - 2026-11-17

### 变更（待办清单补齐·续）

- **为什么**：T13–T19 补完后复核，仍有两处没有归属的工作：一是登录 / 配对属于协议 T2、但界面本身没人记（T2 只管认证链）；二是发版形态取决于分发渠道（GitHub Release 还是商店），不定下来 T13 的产物与签名要求就会反复。
- **做了什么**：`TODO.md` 新增 T20（登录 / 配对界面与设置页）与 T21（分发渠道决策），活跃待办 19 条。

### 变更（待办清单补齐）

- **为什么**：上一轮只看清单本身，没把「实现前必须存在的配套」列进去——发版链路、签名、测试防护网、断线续传、平台适配都是真实缺口，不记下来就会在某个环节才发现，那时返工成本最高。
- **做了什么**：`TODO.md` 新增 T13（tag → Release 上传 APK）、T14（发布签名走 Secrets）、T15（单测与回归防护网挂 required check）、T16（断线重连与游标恢复）、T17（补 Gradle wrapper）、T18（校正版本口径）、T19（Android 平台适配：安全区 / IME / 返回手势 / 字号缩放）；T1 补上「iroh-ffi 版本必须钉成 `1.2.0-cmux.1`」；T5 完成并归档。当时活跃待办 17 条。
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
