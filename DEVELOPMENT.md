# 开发说明

## 技术栈

| 项 | 选择 | 原因 |
| --- | --- | --- |
| 语言 | Kotlin | 与 Android 生态一致，iroh-ffi 提供 Kotlin 绑定 |
| UI | Jetpack Compose | 终端之外的界面（会话列表、设置）用声明式写省事；终端画布用 Canvas |
| 构建 | Gradle（Kotlin DSL） | 标准 |
| 最低版本 | `minSdk 29`（Android 10） | `iroh-ffi` 的 Android 绑定要求 API 29 |
| JDK | 17 | AGP 8.x 的要求 |

## 对端：cmux 的 Mobile host

Mac 侧实现在 [cmux](https://github.com/xhqing/cmux) 仓库，参照物是这些位置：

| 内容 | cmux 仓库路径 |
| --- | --- |
| RPC 数据模型（JSON 字段） | `Packages/Shared/CMUXMobileCore/Sources/CMUXMobileCore/` |
| iOS 侧的 RPC / 传输封装 | `Packages/iOS/CmuxMobileRPC`、`CmuxMobileTransport`、`CmuxMobileShellModel` |
| lane header 与 QUIC 会话 | `Packages/Shared/CmuxIrohTransport/Sources/CmuxIrohTransport/` |
| Mac 侧 host 实现 | `Sources/Mobile/`（`MobileHostService`、`MobileHostIrxRuntime`、`MobileHostTerminalInputApplier`） |
| 渲染网格格式 | `MobileTerminalRenderGrid.swift`（`cmux.render-grid.v1`） |

### 传输

Iroh（QUIC + NAT 穿透）。绑定来自 `https://github.com/manaflow-ai/iroh-ffi`，cmux 侧钉的是 `1.2.0-cmux.1.ios17`。仓库有 `README.kotlin.md`，含 Android NDK 交叉编译说明：

```toml
# .cargo/config.toml
[target.aarch64-linux-android]
ar = "<NDK>/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ar"
linker = "<NDK>/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android29-clang"
```

构建流程：`cargo make bindgen-kotlin`（生成 Kotlin 绑定 + 编 cdylib）→ 按 ABI 放进 `app/src/main/jniLibs/<abi>/` → Gradle 里引用生成的 Kotlin 源码。

### lane header

每条 QUIC 流开头的二进制头，6 种 lane：

| lane | 载荷 | 说明 |
| --- | --- | --- |
| `control` | 认证的请求 / 响应 / 生命周期 | 必须带 admission credential，否则连接被拒 |
| `serverEvents(cursor)` | 有序的服务器事件 | 从游标恢复 |
| `terminal(resourceID, cursor)` | 某个终端的输出字节流 | 从字节游标恢复 |
| `terminalInput(resourceID)` | 只上行输入 | host 先发一个空 replay 信封作为就绪基线 |
| `artifact(resourceID, offset)` | 低优先级产物 | 按精确字节偏移续传 |
| `simulatorStream(resourceID)` | iOS 模拟器视频 + 输入回传 | 不可续传，每次重新关键帧；Android 端不需要 |

Swift 侧定义在 `CmxIrohStreamHeader.swift` / `CmxIrohLane.swift`，Kotlin 实现必须逐字节对齐。

### RPC

JSON，字段名 snake_case（例：`render_revision_floor`、`applied_input_sequence`）。107 个方法，常用分组：

- `mobile.terminal.*`：viewport（Mac 返回跨设备的最小有效网格）、输入、渲染网格事件
- `mobile.chat.*`：会话列表 / 历史 / 发送 / 中断 / artifact 列表与缩略图
- `mobile.browser.*`：面板创建、导航、前进后退、刷新、viewport、`stream.start|stop`、`frame.ack`、指针/键盘/滚轮/文本输入、对话框应答
- `mobile.directory.*`：目录列举与搜索
- `mobile.task.attachment.upload`：附件上传

### 认证

v2 配对链路（无 QR）：

1. 手机上用 Stack Auth 账号登录
2. 生成设备身份（密钥对），公钥随请求上行
3. Mac 侧校验签名 + live QUIC EndpointID，签发一次性 attach ticket
4. ticket 换来 admission credential，放进第一条 `control` lane 的 header
5. 授权刷新最多合并 30 秒；断开后本地保留授权最多 7 天；显式吊销立刻关闭对应连接

Stack Auth 没有 Kotlin/Android SDK，需要自己封装 REST：登录、refresh token、revoke。设备签名用 Android Keystore（`EC` 或 `RSA`，取决于 Mac 侧验签要求的算法）。

### 终端渲染

**不要在 Android 上重造 VT 解析器。** Mac 侧已经算好渲染网格：

- `columns` / `rows`：跨设备协商后的有效网格
- `cursor`：行、列与可见性
- `styles`：样式表（前景/背景/属性/URL 等），cell 用 style id 引用
- `rowSpans`：每行的 cell 区间（含宽字符宽度）
- `activeScreen`：主屏 / 备用屏，恢复语义按 `?1049h`
- `modes`：需要还原的 DEC/ANSI 模式（鼠标跟踪、bracketed paste、应用光标键、自动换行等）
- `full` / `clearedRows`：全量快照 vs 增量帧
- `terminalForeground` / `terminalBackground` / `terminalCursorColor`

Kotlin 侧要做的就是：维护网格状态机 → 应用增量帧 → 在 Canvas 上按 span 绘制 → 把触摸/键盘映射成 `terminalInput` lane 帧。

## 构建

```bash
# 本机（需要 Android SDK；当前这台机器只有 JDK 17 + adb，构建走 CI）
./gradlew assembleDebug
./gradlew lint

# 直接看构建产物
ls app/build/outputs/apk/debug/
```

CI：`.github/workflows/android-build.yml` 在 PR / main 上跑 `assembleDebug` 与 `lint`；`.github/workflows/validate.yml` 是仓库卫生与脚本语法检查（required check）。

## 版本与发布

- 版本号权威：仓库根 `VERSION`（当前 `0.1.0`）
- 发版：更新 `VERSION` → `CHANGELOG.md` 顶部写条目 → 打 tag `v<VERSION>` → CI 构建 → GitHub Release 附 APK
- 目前还没有可发布的客户端（见 `TODO.md` 的 T1~T3），第一个可用版本定为 `0.1.0`
