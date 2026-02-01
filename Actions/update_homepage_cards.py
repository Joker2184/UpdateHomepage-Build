#!/usr/bin/env python3
"""
将 pages/UpdateHomepage.yml 中 cards 列表的第一项替换为指定 tag。
保持其他项不变。
"""

import yaml
import sys
import os

HOMEPAGE_YML = "pages/UpdateHomepage.yml"


def update_first_card(tag):
    if not os.path.exists(HOMEPAGE_YML):
        print(f"❌ {HOMEPAGE_YML} 不存在", file=sys.stderr)
        sys.exit(1)

    with open(HOMEPAGE_YML, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)

    if not isinstance(data.get("cards"), list) or len(data["cards"]) == 0:
        print("❌ cards 字段无效", file=sys.stderr)
        sys.exit(1)

    current = str(data["cards"][0]).strip('"')
    if current == tag:
        print(f"⏩ cards[0] 已是 {tag}，无需更新")
        return

    # 替换为带引号的字符串
    data["cards"][0] = f'"{tag}"'

    with open(HOMEPAGE_YML, "w", encoding="utf-8") as f:
        yaml.dump(
            data,
            f,
            allow_unicode=True,
            default_flow_style=False,
            sort_keys=False,
            indent=2
        )

    print(f"✅ 更新 cards[0] 为: \"{tag}\"")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("用法: python update_homepage_cards.py <tag>", file=sys.stderr)
        sys.exit(1)
    update_first_card(sys.argv[1])
