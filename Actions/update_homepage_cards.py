#!/usr/bin/env python3
"""
将 pages/UpdateHomepage.yml 中 cards 列表的第一项替换为指定 tag，
并确保其以双引号形式输出（防止 2.10 → 2.1）。
"""

import yaml
from yaml.scalarstring import DoubleQuotedScalarString
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

    current = data["cards"][0]
    # 去除可能的引号后比较
    current_clean = str(current).strip('"\'')
    if current_clean == tag:
        print(f"⏩ cards[0] 已是 {tag}，无需更新")
        return

    # 使用 DoubleQuotedScalarString 确保输出为 "tag"
    data["cards"][0] = DoubleQuotedScalarString(tag)

    # 保留其他元素原样（不强制加引号）
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
