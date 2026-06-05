<div align="center">

# /-TendoAr1sBot-/

<img src="Tendoar1Bot.png" width="100%" />

*-「只要和老师在一起，爱丽丝就没有什么好怕的。」-*

[![Release](https://img.shields.io/github/v/release/Yuzcen/TendoAr1sBot?style=flat-square)](https://github.com/Yuzcen/TendoAr1sBot/releases)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![AstrBot](https://img.shields.io/badge/AstrBot-v4.8+-purple?style=flat-square)](https://astrbot.app/)
[![License](https://img.shields.io/github/license/Yuzcen/TendoAr1sBot?style=flat-square)](LICENSE)
---


**QQ 机器人全家桶 — AstrBot + Ollama（无 So-VITS 分支）**

天童爱丽丝（Aris）文字对话

</div>

## 架构

```
用户消息 → NapCat (QQ 协议) → AstrBot (AI 对话) → 文字回复
                                      ↓
                                  Ollama (embedding / 本地推理)
```

## 服务清单

| 服务 | 端口 | 用途 |
|------|------|------|
| NapCat | 6099 / 13000 / 13001 | QQ 协议 |
| AstrBot | 6185 / 6199 | AI 对话引擎 |
| Ollama | 11434 | 本地 embedding |
| Shipyard Bay | 8114 | 管理面板 |
| Bay Session | 8123 | 会话管理 |

## 环境要求

- Docker + Docker Compose
- NVIDIA GPU（可选，用于 Ollama 本地推理）
- NVIDIA Container Toolkit（如使用 GPU）

## 快速部署

### 1. 克隆仓库

```bash
git clone -b no-sovits https://github.com/Yuzcen/TendoAr1sBot.git
cd TendoAr1sBot
```

### 2. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 填入实际值
```

### 3. 启动服务

```bash
docker compose up -d
```

### 4. 验证服务

```bash
# 检查所有容器状态
docker compose ps

# 测试 Ollama
curl http://localhost:11434/api/tags
```

### 5. 配置 AstrBot

1. 打开 `http://localhost:6185` 进入 AstrBot Dashboard
2. 配置模型供应商（Mimo / Gemini / DeepSeek 等）
3. 配置人格（天童爱丽丝、代码专家、搜索专家）
4. 创建知识库并上传角色文件

## 关键配置说明

### AstrBot

- `cmd_config.json` — 模型供应商配置（通过 Dashboard 修改更安全）
- `plugins/` — 插件目录（LivingMemory、表情包管理等）
- `knowledge_base/` — 角色知识库文件

### NO_PROXY

Docker 容器间通信不能走代理，以下地址已加入 NO_PROXY：
```
localhost,127.0.0.1,ollama,bay,shipyard-bay,napcat
```

## 常见问题

**Q: 容器间通信失败？**
A: 检查 NO_PROXY 配置，确保所有内部服务名都已加入。

**Q: 显存不够？**
A: Ollama 仅保留 embedding 模型（nomic-embed-text ~600MB），不要同时跑对话模型。

## 目录结构

```
TendoAr1sBot/
├── docker-compose.yml          # 主编排文件
├── bay-config.yaml             # Shipyard Bay 配置
├── .env.example                # 环境变量模板
├── astrbot/
│   └── data/
│       ├── plugins/            # AstrBot 插件
│       └── knowledge_base/     # 角色知识库
└── napcat/
    └── config/                 # NapCat 配置
```
