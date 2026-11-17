# UI 参考（对齐 cmux iOS 客户端）

Android 端的界面基准。参考物是 cmux iOS 客户端对外展示的界面（`assets/ui/` 下是从官网落地页裁出的屏幕），**只对齐信息结构与视觉语言，不移植其代码**（iOS 侧是 SwiftUI，这里是 Compose，独立实现）。

| 文件 | 内容 |
| --- | --- |
| `assets/ui/overview.png` | 落地页整体（六组屏幕概览） |
| `assets/ui/workspaces.png` | 会话列表页 |
| `assets/ui/terminal.png` | 终端详情页（含键盘工具条与输入区） |
| `assets/ui/keyboard.png` | 终端底部：运行状态行、终端状态条、键盘工具条特写 |
| `assets/ui/colors.png` | 彩色 TUI 保真（htop / neovim 的 16 色与真彩渲染） |

## 设计语言

- **纯黑背景**（`#000000`）+ 深灰浮层（约 `#1C1C1E`，搜索框与顶栏按钮带半透明毛玻璃）。首版只做深色，不做浅色主题。
- **控件一律胶囊或圆形**：顶栏按钮、键盘键、输入框、搜索框、列表头像。没有直角矩形按钮。
- **列表头像**：48dp 圆，纯色或双色渐变（橙 / 蓝 / 绿 / 青 / 亮蓝），中间一个白色终端图标（`>_` 或卡片方框）。颜色按 workspace 稳定分配（同名同色，取色板哈希），不做随机。
- **文字层级**：主标题 17sp 半粗白色；副标题 / 时间 / 路径 13sp 灰（`#8E8E93`）；图标按钮白色。
- **终端区等宽字体**，不换行、不重排；字号由用户缩放，单元格宽高按字体度量算。
- **颜色只出现在三处**：workspace 头像、终端内容（由 `render-grid` 的样式表决定，见 `DEVELOPMENT.md`）、终端状态条的分段高亮（模型白 / 档位黄 / 上下文剩余橙 / 路径绿 / 分支灰）。

## 屏幕一：会话列表（Workspaces）

```
┌──────────────────────────────────────────────┐
│ (…)  [布局]        Workspaces    [列表] [+]  │  ← 顶栏：三组胶囊
├──────────────────────────────────────────────┤
│ ⬤  agent split panes #6499          9:12 PM >│  ← 头像 + 标题(+可选编号)
│    ~/fun/cmuxterm-hq                        │  ← 副标题：cwd 或 "Terminal"
│ ⬤  Claude Code                     10:21 PM >│
│    ~/fun/cmux                               │
│ ⬤  posthog analytics                9:12 PM >│
│    Terminal                                 │
│                     ⋮                        │
├──────────────────────────────────────────────┤
│  ⌕  Search                                   │  ← 底部浮动胶囊（毛玻璃）
└──────────────────────────────────────────────┘
```

- **顶栏**：左侧 `…` 圆钮 + 布局切换胶囊；中间标题胶囊「Workspaces」；右侧「列表图标 + `+`」胶囊（新建会话 / 切换视图）。
- **列表行**（高约 72dp）：左头像 → 主标题（会话名，长名截断，可选 `#编号`）→ 副标题（cwd 路径或 `Terminal`）→ 右侧时间 + chevron。
- **底部搜索框**：浮动在列表之上，胶囊形、毛玻璃、放大镜 + `Search` 占位。
- **数据**：会话列表来自 Mac 侧的 RPC（`mobile.terminal.*` / 会话相关方法，字段待 T3 按 `CMUXMobileCore` 对齐）；时间取会话最后活动时间。

## 屏幕二：终端详情

自上而下四段：

1. **顶栏**：左「返回 chevron + 同组页数徽章圆」、中「会话名」胶囊、右「`>_`」圆钮（切到纯终端视图）。
2. **会话头**（3 行，左图标 + 右侧文字）：agent logo｜名称 + 版本号（`Claude Code v2.1.186`）／模型 + 计费（`Opus 4.8 (1M context) · API Usage Billing`）／cwd（`~/fun/cmux`）。
3. **终端画布**：`render-grid` 绘制的 cell 网格 —— 彩色文本、粗体、背景色、光标。运行中的 agent 有一行内联状态：`• Working (25s · esc to interrupt)`。
4. **底部三件套**：
   - **输入提示行**：`> |` + 占位文本（浅灰底横条），即 agent 的输入框在终端视图里的形态。
   - **终端状态条**：`gpt-5.5 high · Context 90% left · ~/fun/cmux · cmux · issue-…`（客户端自绘，不属于 render-grid 内容；数据来自 terminal 状态事件，字段待对齐）。
   - **键盘工具条**：横向一排胶囊键：键盘切换、圆形键点、编辑、`↑`、`Tab`、`⌘`、`↑`、粘贴、`Tab`、`Esc` —— 把终端必需但手机软键盘没有的键补上。
   - **输入区**（聊天模式）：附件（回形针）、麦克风、`Message` 输入框、发送箭头。

## 屏幕三：彩色 TUI 保真（`colors.png`）

htop、btop、neovim、vim 的截图说明渲染必须逐 cell 保真：16 色 / 256 色 / 真彩都要对，粗体与反显也要对。这正是选 `render-grid` 而**不在 Android 重造 VT 解析器**的理由——Mac 侧已经算好样式 id，这边只负责按 span 上色。

## Compose 实现映射

| UI 元素 | Compose | 数据来源 |
| --- | --- | --- |
| 顶栏三组胶囊 | `Row` + `Surface(shape = CircleShape / RoundedCornerShape(50))` | 本地状态 |
| 会话列表行 | `LazyColumn` + 自绘 `Row`（不用 `ListItem`，它的内边距对不上） | 会话列表 RPC |
| 头像色 | 色板数组 + 名称哈希 | 本地（稳定分配） |
| 浮动搜索框 | `Box` + `Surface(tonalElevation)` + `TextField`（无边框） | 本地过滤 |
| 终端画布 | `Canvas` + `drawText`（`TextMeasurer`，每 cell 位置固定） | render-grid 全量 / 增量帧 |
| 键盘工具条 | `LazyRow` + `Surface` 胶囊键 | 本地 → `terminalInput` 帧 |
| 输入区 | `TextField` + 尾部圆形发送钮 | 本地 → `terminalInput` / chat RPC |
| 状态条 | `Row` + 分段 `Text`（每段独立颜色） | terminal 状态事件 |
| 背景 / 浮层 | `Color(0xFF000000)` / `Color(0xFF1C1C1E)` + `Modifier.background` | `ui/theme` 设计令牌 |

设计令牌（颜色、字号、圆角、间距）统一放 `app/src/main/java/dev/xhqing/androidcmux/ui/theme/`，屏里不写裸值。

## 对齐边界

- **不做**：iPad 式多栏布局、浅色主题、iOS 的 SF Symbols 原样搬运（用 Material Icons 的等价图标）。
- **必做**：单栏 + 详情导航（Android 返回手势要能用）、刘海 / 挖孔屏的安全区适配（`WindowInsets`）、终端区的等宽对齐精度。
- **由 Mac 侧决定、不在 Android 侧重算**：行列数（`viewport` 协商）、样式表、增量帧、光标状态。
