<div align="center">

# /-TendoAr1sBot-/

<img src="Tendoar1Bot.png" width="100%" />

*-「只要和老师在一起，爱丽丝就没有什么好怕的。」-*

[![Release](https://img.shields.io/github/v/release/Yuzcen/TendoAr1sBot?style=flat-square)](https://github.com/Yuzcen/TendoAr1sBot/releases)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![AstrBot](https://img.shields.io/badge/AstrBot-v4.8+-purple?style=flat-square)](https://astrbot.app/)
[![GPT-SoVITS](https://img.shields.io/badge/GPT--SoVITS-v2-red?style=flat-square)](https://github.com/RVC-Boss/GPT-SoVITS)
[![License](https://img.shields.io/github/license/Yuzcen/TendoAr1sBot?style=flat-square)](LICENSE)
---


**QQ 机器人全家桶 — AstrBot + GPT-SoVITS + Ollama**

天童爱丽丝（Aris）中文语音 TTS

</div>

## 架构

```
用户消息 → NapCat (QQ 协议) → AstrBot (AI 对话) → GPT-SoVITS (TTS) → 语音回复
                                      ↓
                                  Ollama (embedding / 本地推理)
```

## 服务清单

| 服务 | 端口 | 用途 |
|------|------|------|
| NapCat | 6099 / 13000 / 13001 | QQ 协议 |
| AstrBot | 6185 / 6199 | AI 对话引擎 |
| Ollama | 11434 | 本地 embedding |
| GPT-SoVITS | 9880 | TTS 语音合成 |
| Shipyard Bay | 8114 | 管理面板 |
| Bay Session | 8123 | 会话管理 |

## 环境要求

- Docker + Docker Compose
- NVIDIA GPU（RTX 3060 或以上，显存 >= 6GB）
- NVIDIA Container Toolkit（GPU 直通）

## 快速部署

### 1. 克隆仓库

```bash
git clone https://github.com/Yuzcen/TendoAr1sBot.git
cd TendoAr1sBot
```

### 2. 准备模型文件

**GPT-SoVITS 模型（必须）：**
```bash
# 将训练好的模型放到 gpt-sovits/models/
# - Airs_Chinese-e15.ckpt (GPT 模型)
# - Airs_Chinese_e8_s400.pth (SoVITS 模型)
```

**预训练模型（必须）：**
```bash
# 下载预训练模型到 gpt-sovits/pretrained_models/
# - chinese-roberta-wwm-ext-large/
# - chinese-hubert-base/
# - sv/pretrained_eres2netv2w24s4ep4.ckpt (v2Pro 必需)
```

**参考音频（必须）：**
```bash
# 将参考音频放到 gpt-sovits/reference_audio/
# 至少需要一个 .wav 文件作为默认参考
```

### 3. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 填入实际值
```

### 4. 启动服务

```bash
docker compose up -d
```

首次启动会自动拉取镜像，GPT-SoVITS 镜像较大（~5GB），需要等待。

### 5. 验证服务

```bash
# 检查所有容器状态
docker compose ps

# 测试 GPT-SoVITS API
curl http://localhost:9880/docs

# 测试 Ollama
curl http://localhost:11434/api/tags
```

### 6. 配置 AstrBot

1. 打开 `http://localhost:6185` 进入 AstrBot Dashboard
2. 配置模型供应商（Mimo / Gemini / DeepSeek 等）
3. 配置人格（天童爱丽丝、代码专家、搜索专家）
4. 创建知识库并上传角色文件
5. 启用 GPT-SoVITS 插件

## 关键配置说明

### GPT-SoVITS

- `tts_infer.yaml` — 模型路径、推理设备、半精度设置
- `start.sh` — 启动脚本，修复 torchcodec 兼容性问题
- `text_lang=zh` — 中文模型必须设为 `zh`

### AstrBot

- `cmd_config.json` — 模型供应商配置（通过 Dashboard 修改更安全）
- `plugins/` — 插件目录（GPT-SoVITS、LivingMemory、表情包管理等）
- `knowledge_base/` — 角色知识库文件

### NO_PROXY

Docker 容器间通信不能走代理，以下地址已加入 NO_PROXY：
```
localhost,127.0.0.1,gpt-sovits,ollama,bay,shipyard-bay,napcat
```

## 常见问题

**Q: GPT-SoVITS 启动报 torchcodec 错误？**
A: `start.sh` 已包含修复，确保使用 `command: ["bash", "/workspace/GPT-SoVITS/start.sh"]` 启动。

**Q: TTS 输出乱码声音？**
A: 检查 `text_lang` 是否设为 `zh`，日文模型 + `text_lang=zh` 会出乱音。

**Q: 容器间通信失败？**
A: 检查 NO_PROXY 配置，确保所有内部服务名都已加入。

**Q: 显存不够？**
A: Ollama 仅保留 embedding 模型（nomic-embed-text ~600MB），不要同时跑对话模型。

## 模型演进

| 版本 | 模型 | 大小 | 语言 | 状态 |
|------|------|------|------|------|
| Aris v1 | GPT e15 + SoVITS e15 | 229MB | 日语参考 + zh | 已弃用 |
| 爱丽丝（女仆）日文 | GPT e15 + SoVITS e12 | ~1GB | 日语 | 跨语言效果差 |
| Airs_Chinese | GPT e15 + SoVITS e8 | ~280MB | 中文 | **当前使用** |

## 目录结构

```
TendoAr1sBot/
├── docker-compose.yml          # 主编排文件
├── bay-config.yaml             # Shipyard Bay 配置
├── .env.example                # 环境变量模板
├── gpt-sovits/
│   ├── config/
│   │   └── tts_infer.yaml      # TTS 推理配置
│   ├── start.sh                # 启动脚本（含兼容性修复）
│   ├── models/                 # 训练好的模型（需要自行放入）
│   ├── pretrained_models/      # 预训练模型（需要自行下载）
│   ├── reference_audio/        # 参考音频（需要自行放入）
│   └── output/                 # TTS 输出目录
├── astrbot/
│   └── data/
│       ├── plugins/            # AstrBot 插件
│       └── knowledge_base/     # 角色知识库
└── napcat/
    └── config/                 # NapCat 配置
```
