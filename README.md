# AgentForge

**One API Key. Every LLM. Zero Vendor Lock-In.**

[![Buy on Gumroad](https://img.shields.io/badge/Buy-%2415%2Fmo-violet)](https://empirelabs1.gumroad.com/l/agentforge)
[![by Empire Labs](https://img.shields.io/badge/by-Empire%20Labs-7170ff)](https://github.com/narko4u)

---

![AgentForge Cover](agentforge-cover.png)

---

## The Problem

You're building something with AI. You start with OpenAI. Then you need Claude for safety-critical tasks. DeepSeek for cost. Maybe OpenRouter for edge models.

Now you're managing **six different API keys**, **four SDKs**, **three authentication headers**, and **two different response formats**. One provider goes down and your app has no fallback. Your cost tracking is a spreadsheet you haven't updated in weeks.

Every new model vendor is another integration you didn't have time for.

---

## The Solution

AgentForge is a lightweight proxy server that sits between your app and every LLM provider. Instead of managing six SDKs, you get **one endpoint, one API key, one response format** — and intelligent routing to the best provider for every request.

```
┌─────────────┐     POST /v1/chat/completions     ┌──────────────┐
│   Your App  │  ──────────────────────────────▶   │  AgentForge  │
│             │     Authorization: Bearer af-xxx   │              │
│  • Python   │                                    │  • Routing   │
│  • Node.js  │                                    │  • Fallback  │
│  • cURL     │                                    │  • Cost Logs │
│  • Any SDK  │                                    │  • Usage API │
└─────────────┘                                    └──────┬───────┘
                                                           │
                        ┌──────────────────────────────────┼──────────────────────────────────┐
                        ▼                                  ▼                                  ▼
               ┌──────────────┐                    ┌──────────────┐                    ┌──────────────┐
               │    OpenAI    │                    │   Anthropic  │                    │   DeepSeek   │
               │  gpt-4o      │                    │claude-sonnet-4│                    │deepseek-chat │
               │  gpt-4o-mini │                    │claude-3-opus │                    │   ($0.14/M)  │
               └──────────────┘                    └──────────────┘                    └──────────────┘
                                                           │
                                                   ┌──────┴──────┐
                                                   │  OpenRouter │
                                                   │  (any model)│
                                                   └─────────────┘
```

### What This Means For Developers

| Before AgentForge | After AgentForge |
|---|---|
| Manage 6 SDKs and API clients | One HTTP client, one endpoint |
| Hard-code provider logic in every service | Configure routing in one place |
| App breaks when a provider has an outage | Auto-fallback to next available provider |
| Cost tracking is an afterthought | Every request logged with token usage + cost |
| Switching providers means rewriting code | Change one config value, done |
| Each team member needs their own provider keys | One AgentForge key per developer |

---

## How It Works

**Step 1 — Start the server:**
```bash
# Set your provider keys
export AGENTFORGE_OPENAI_KEY=sk-...
export AGENTFORGE_ANTHROPIC_KEY=sk-ant-...
export AGENTFORGE_DEEPSEEK_KEY=sk-...
export AGENTFORGE_API_KEY=af-your-secret-key

# Run
agentforge
# → Listening on http://localhost:8902
```

**Step 2 — Call it like any OpenAI endpoint:**
```bash
curl http://localhost:8902/v1/chat/completions \
  -H "Authorization: Bearer af-your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

**Step 3 — Get a unified response with cost tracking:**
```json
{
  "id": "chatcmpl-...",
  "choices": [{ "message": { "content": "Hi there!" }}],
  "usage": { "prompt_tokens": 10, "completion_tokens": 5, "total_tokens": 15 },
  "_meta": {
    "provider": "openai",
    "cost": 0.000035,
    "duration_ms": 340
  }
}
```

---

## Why AgentForge?

**🔄 Auto-Fallback**
If OpenAI returns a 503, AgentForge automatically retries on Anthropic, then DeepSeek, then OpenRouter. Your app keeps working even when individual providers fail.

**🔌 One Integration, All Providers**
Switch from `openai` SDK to `httpx` with a single base URL change. Your chat completions code stays the same whether you're using GPT-4o, Claude, DeepSeek, or any OpenRouter model.

**💰 Built-In Cost Tracking**
Every request is logged with prompt tokens, completion tokens, total cost, and duration. `GET /v1/usage` gives you your spend at a glance. No more manual spreadsheet tracking.

**🔑 One API Key To Manage**
Instead of every developer needing their own OpenAI, Anthropic, and DeepSeek keys, they get one AgentForge key. You rotate one key. You audit one key. You revoke one key.

**🧠 Smart Provider Resolution**
Specify a model and AgentForge finds the cheapest/best provider that supports it. Or force a specific provider with `"provider": "anthropic"` — you stay in control.

---

## Commands at a Glance

| Endpoint | Method | Description |
|---|---|---|
| `/health` | GET | Server health check |
| `/v1/models` | GET | List available models across all providers |
| `/v1/chat/completions` | POST | Unified chat completion — OpenAI format |
| `/v1/usage` | GET | View token usage and cost data |
| `/v1/usage/reset` | POST | Reset usage statistics |

---

## Who Needs This?

- **Solo developers** building AI apps who are tired of managing multiple API keys
- **Startups** running AI features in production who need reliability across providers
- **Teams** where every developer needs LLM access without sharing keys
- **Cost-conscious builders** who want to see exactly what they're spending per model
- **Anyone** who wants to switch from OpenAI to DeepSeek without rewriting their codebase

---

## Plans

| | Hobby | Pro | Enterprise |
|---|---|---|---|
| **Price** | $15/mo | $49/mo | Custom |
| **API Requests** | 100K/mo | 1M/mo | Unlimited |
| **Providers** | 2 | All | All + Custom |
| **Auto-Fallback** | ✅ | ✅ | ✅ |
| **Usage Dashboard** | ✅ | ✅ | ✅ |
| **Support** | Email | Priority | SLA + Phone |
| **Self-Hosted** | ✅ | ✅ | ✅ |
| **Dedicated Instance** | — | — | ✅ |

---

## Architecture

![AgentForge Architecture](agentforge-architecture.svg)

---

## Requirements

- Python 3.9+
- API keys for your chosen providers (OpenAI, Anthropic, DeepSeek, etc.)
- 30 seconds to configure

---

## Buy

Ready to stop managing six API keys and start shipping?

👉 [**Buy AgentForge on Gumroad — $15/mo**](https://empirelabs1.gumroad.com/l/agentforge)

*Built with purpose by Empire Labs.*
