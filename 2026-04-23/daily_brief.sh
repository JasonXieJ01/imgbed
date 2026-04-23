#!/bin/bash
DATE=$(date +%Y.%m.%d)
SHORT_DATE=$(date +%Y.%m.%d)
WORKSPACE="/home/jasonxiej/.openclaw/workspace-lumen"
SCOUT_DIR="/home/jasonxiej/.openclaw/workspace-scout/trendradar"
CHANNEL_ID="1481141246687842465"
ACCOUNT="lumen"

echo "=== Starting daily brief at $(date) ===" >> "$WORKSPACE/cron.log"

# 运行爬虫
cd "$SCOUT_DIR"
/home/jasonxiej/.local/bin/uv run python main.py >> "$WORKSPACE/cron.log" 2>&1

# 获取去重后的新闻
cd "$SCOUT_DIR"
NEWS_JSON=$(/home/jasonxiej/.local/bin/uv run python3 << 'PYTHON'
import json
import glob

SCOUT_DIR = "/home/jasonxiej/.openclaw/workspace-scout/trendradar"

# 只对比昨天去重
sent_titles = set()
output_dirs = sorted(glob.glob(f"{SCOUT_DIR}/output/2026年*日"))[-1:]
for d in output_dirs:
    for f in glob.glob(f"{d}/txt/*.txt"):
        try:
            with open(f, 'r') as file:
                for line in file:
                    if line.strip():
                        sent_titles.add(line.strip())
        except: pass

from mcp_server.tools.data_query import DataQueryTools
tools = DataQueryTools(SCOUT_DIR)
news_data = tools.get_latest_news(limit=100, include_url=True)

new_news = [n for n in news_data.get('news', []) if n.get('title', '') not in sent_titles]

# 取每类10条
categories = {
    'AI': ['IT之家', '掘金', 'GitHub', 'Hacker News', 'V2EX', '牛客网', 'Solidot', '少数派', 'ProductHunt'],
    '国际': ['凤凰网', '参考消息', '卫星通讯社', '联合早报', 'MKT新闻', '靠谱新闻'],
    '财经': ['华尔街见闻', '财联社', '格隆汇', '雪球', '金十数据'],
    '社会': ['今日头条', '百度热搜', '微博', '抖音', 'bilibili', '贴吧', '虎扑', '知乎', '虫部落'],
    '政治': ['澎湃新闻']
}

# 输出简化数据
output = []
for cat, plats in categories.items():
    items = [n for n in new_news if n.get('platform_name', '') in plats][:10]
    output.append({'category': cat, 'items': items})

print(json.dumps({'date': '2026.03.17', 'categories': output}, ensure_ascii=False))
PYTHON
)

echo "News data prepared" >> "$WORKSPACE/cron.log"

# 调用 Lumen 生成摘要
openclaw agent --agent lumen --message "今天是 $DATE。请根据以下新闻数据生成每日新闻简报：

$NEWS_JSON

格式要求：
1. 标题：# 🛰️ Orion 灵感雷达 | $DATE
2. 每个分类10条新闻
3. 每条新闻包含：标题、内容概要（100字）、深度思考
4. 分类：AI/科技、国际局势、财经/资本、社会/生活、政治/两岸
5. 日期格式：📅 YYYY.MM.DD
6. 链接用尖括号包裹

生成完成后发送到 Discord 频道。" --deliver 2>> "$WORKSPACE/cron.log"

echo "=== Daily brief completed at $(date) ===" >> "$WORKSPACE/cron.log"
