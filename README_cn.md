<div align="center">

  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](LICENSE.md)
  [![Version](https://img.shields.io/badge/Version-0.1.0-blue)](CHANGELOG.md)
  [![Type](https://img.shields.io/badge/Type-Android%20app-3DDC84)](#)
  [![Platform](https://img.shields.io/badge/Platform-Android-3DDC84)](#)

  [English](README.md)
</div>

# android-cmux

> cmux 的 Android 客户端：在手机上看着终端和编码 agent 干活，需要时再接管。

这是 [cmux](https://github.com/xhqing/cmux) 的 Android 对应物。cmux 是基于 Ghostty 的 macOS 终端，带竖向标签页，专为同时跟多个编码 agent 打交道而做。上游有一个 iOS beta，源码不公开；Android 上什么都没有。本项目补上这一块——用的是 Mac 侧已经说好的那套协议。

## 状态

**早期骨架**。仓库、构建配置与协议文档已就位，还没有可用的客户端。路线图见 `TODO.md` 与 `DEVELOPMENT.md`。

## 为什么单独一个项目

- **难的那部分 Mac 侧已经做完了**：Iroh/QUIC 传输、107 个 `mobile.*` RPC、cell 级 `render-grid` 快照、配对与账号授权，cmux 里都有实现。
- **客户端是另一套技术栈**：Kotlin + Jetpack Compose，Gradle 构建，走 Android 的发布渠道；除了线上协议，与 Swift 代码库不共享任何东西。
- **刻意解耦**：cmux 是 GPL-3.0-or-later，本项目不复制它的代码，而是独立实现协议，所以本项目能保持 MIT。

## 怎么连

| 层 | Mac 侧提供什么 | 本项目做什么 |
| --- | --- | --- |
| 传输 | Iroh（QUIC + NAT 穿透），经 `iroh-ffi` | 用同一套 Kotlin 绑定 |
| 流 | 二进制 lane header，共 6 种 lane | 逐字节重新实现 |
| 消息 | JSON（Swift `Codable`），107 个 `mobile.*` 方法 | 字段名对齐的 Kotlin data class |
| 终端 | `render-grid`（`cmux.render-grid.v1`）cell 快照 + 增量帧 | 在 Compose Canvas 上画格子 |
| 认证 | Stack Auth 账号 + 设备签名 + attach ticket | 自写 REST 客户端 + Android Keystore |

lane 清单、字段命名规则等细节见 `DEVELOPMENT.md`。

## 环境要求

- 一台运行 [cmux](https://github.com/xhqing/cmux) 并开启 Mobile host 的 Mac
- Android 10（API 29）及以上——`iroh-ffi` 的要求
- 本地构建需要 JDK 17 与 Android SDK（CI 两者都有）

## 参与

见 `CONTRIBUTING_cn.md`：你的贡献版权归你，贡献按 MIT 授权给本项目。

## 许可

MIT，见 `LICENSE.md`。版权归 xhqing and contributors（2026）。
