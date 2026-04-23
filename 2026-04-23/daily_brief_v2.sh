#!/bin/bash
DATE=$(date +%Y.%m.%d)
WORKSPACE="/home/jasonxiej/.openclaw/workspace-lumen"
SCOUT_DIR="/home/jasonxiej/.openclaw/workspace-scout/trendradar"
CHANNEL_ID="1481141246687842465"
ACCOUNT="lumen"

echo "=== Starting daily brief at $(date) ===" >> "$WORKSPACE/cron.log"

cd "$SCOUT_DIR"
/home/jasonxiej/.local/bin/uv run python main.py >> "$WORKSPACE/cron.log" 2>&1

cd "$SCOUT_DIR"
NEWS_DATA=$(/home/jasonxiej/.local/bin/uv run python -c "
import json
from mcp_server.tools.data_query import DataQueryTools
tools = DataQueryTools('.')
news_data = tools.get_latest_news(limit=60, include_url=True)
print(json.dumps(news_data, ensure_ascii=False))
" 2>&1)

if [[ "$NEWS_DATA" == *"success\":false"* ]] || [[ "$NEWS_DATA" == *"error"* ]]; then
    echo "Error fetching news data" >> "$WORKSPACE/cron.log"
    exit 1
fi

openclaw message send --channel discord --account "$ACCOUNT" --target channel:"$CHANNEL_ID" --message "# 🛰️ Orion 灵感雷达 | $DATE" 2>> "$WORKSPACE/cron.log"

# AI/科技 10条 - 阅读总结50字+
openclaw message send --channel discord --account "$ACCOUNT" --target channel:"$CHANNEL_ID" --message "### 🤖 **[ AI / 科技 ]**
## **# 司法部将在全国统一推行扫码入企**
*   **📝 阅读总结**：司法部将在全国范围内统一推行扫码入企检查制度，旨在提升行政执法的规范化、透明度和效率，减少人为干预。
*   **💡 深度思考**：数字化监管成为大趋势，企业需要适应线上合规流程的新要求，传统的线下打招呼模式将被取代。
*   **🌐 来源官网**：[今日头条](<https://www.toutiao.com/trending/7616297232433761835/>)

---
## **# \"鉴抄\"风波持续：不愿沉默的人**
*   **📝 阅读总结**：艺术圈\"鉴抄\"争议持续发酵，多位当事人发声表达不愿沉默的态度，引发行业内外对原创保护边界的广泛讨论。
*   **💡 深度思考**：原创保护的法律边界仍然模糊，行业自律机制与司法界定需要同步完善，这关系到创意产业的健康发展。
*   **🌐 来源官网**：[澎湃新闻](<https://www.thepaper.cn/newsDetail_forward_32747590>)

---
## **# 美军空中加油机在伊拉克坠毁**
*   **📝 阅读总结**：美军一架空中加油机在伊拉克坠毁事故引发关注，目前事故原因正在调查中，中东地区的安全形势持续紧张。
*   **💡 深度思考**：军事装备事故反映出后勤保障体系面临的压力，地区安全形势的复杂化需要引起高度重视。
*   **🌐 来源官网**：[凤凰网](<https://news.ifeng.com/loc/timeline/event/8r727OWpK5W>)

---
## **# 外媒聚焦\"中国之稳\"治理模式**
*   **📝 阅读总结**：多家外媒发表文章聚焦中国治理模式，认为稳定的社会环境为经济发展提供了坚实基础，体现了制度优势。
*   **💡 深度思考**：中国治理经验获得国际社会的关注和认可，制度优势正在转化为国际竞争中的软实力。
*   **🌐 来源官网**：[参考消息](<https://ckxxapp.ckxx.net/pages/2026/03/12/0409a8d24b54444a9e502866f2685440.html>)

---
## **# 芬兰安全局长：俄罗斯非海底电缆事件黑手**
*   **📝 阅读总结**：芬兰安全情报局局长表示，俄罗斯并非波罗的海海底电缆受损事件的幕后黑手，但欧洲关键基础设施安全仍需关注。
*   **💡 深度思考**：地缘博弈呈现复杂化趋势，关键基础设施的保护已成为国家安全战略的重要组成部分。
*   **🌐 来源官网**：[卫星通讯社](<https://sputniknews.cn/20260313/1070211581.html>)

---
## **# 青年冰球联赛爆发大规模群殴**
*   **📝 阅读总结**：青年冰球联赛爆发大规模群殴事件，裁判开出近600分钟罚单创历史纪录，引发对青少年体育教育的反思。
*   **💡 深度思考**：竞技体育中的暴力倾向需要引起重视，青少年体育教育应当加强情绪管理和规则意识培养。
*   **🌐 来源官网**：[靠谱新闻](<https://ici.radio-canada.ca/rci/zh-hans/%E6%96%B0%E9%97%BB/2238355/%E9%9D%92%E5%B9%B4-%E5%86%B0%E7%90%83-%E8%81%94%E8%B5%9B-%E7%BE%A4%E6%AE%B4-%E7%90%83%E8%AF%81-%E7%A0%B4%E7%BA%AA%E5%BD%95-%E7%BD%9A%E6%97%B6%E8%BF%91600%E5%88%86%E9%92%9F>)

---
## **# 伊朗威胁关闭霍尔木兹海峡**
*   **📝 阅读总结**：伊朗发出警告可能关闭霍尔木兹海峡，全球油轮运输面临中断风险，国际油价应声飙升重返100美元关口。
*   **💡 深度思考**：霍尔木兹海峡是全球能源运输的咽喉要道，一旦封锁将引发国际油价暴涨，影响全球供应链稳定。
*   **🌐 来源官网**：[华尔街见闻](<https://wallstreetcn.com/articles/3767295>)

---
## **# 机构预测日元恐将跌向160关口**
*   **📝 阅读总结**：多家金融机构发布报告预测，受国际油价上涨影响，日元可能贬值至160关口，创历史新低。
*   **💡 深度思考**：日元持续贬值虽然有利于出口但会加剧进口通胀压力，日本央行货币政策面临两难选择。
*   **🌐 来源官网**：[华尔街见闻](<https://wallstreetcn.com/livenews/3069189>)

---
## **# 赖清德拟4月出访非洲友邦**
*   **📝 阅读总结**：台湾地区领导人赖清德计划4月出访非洲友邦斯威士兰，此举被视为拓展\"外交\"空间的最新动作。
*   **💡 深度思考**：台海博弈正在向非洲延伸，两岸外交角力进入新阶段，国际支持格局正在发生变化。
*   **🌐 来源官网**：[联合早报](<https://www.zaochenbao.com/news/china/202603/1266726.html>)

---
## **# 2月制造业PMI数据正式发布**
*   **📝 阅读总结**：2月制造业采购经理指数(PMI)数据正式发布，显示制造业景气度变化，为判断经济复苏进度提供重要依据。
*   **💡 深度思考**：PMI是经济先行指标，其变化趋势将决定未来宏观政策发力的方向和力度。
*   **🌐 来源官网**：[MKT新闻](<https://mktnews.net/flashDetail.html?id=019ce3f4-d8da-777a-a955-c267bc9d4fcf>)" 2>> "$WORKSPACE/cron.log"

echo "=== Daily brief completed at $(date) ===" >> "$WORKSPACE/cron.log"
