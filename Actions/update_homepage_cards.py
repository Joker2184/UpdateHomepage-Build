#!/usr/bin/env python3
"""
安全更新 pages/UpdateHomepage.yml 的 cards 第一项为 "最新tag"
不依赖 yaml.scalarstring，纯文本处理，确保输出为:
  - "2.12.3"
"""

import sys
import os
import re

HOMEPAGE_YML = "pages/UpdateHomepage.yml"


def update_first_card(tag):
    if not os.path.exists(HOMEPAGE_YML):
        print(f"❌ {HOMEPAGE_YML} 不存在", file=sys.stderr)
        sys.exit(1)

    with open(HOMEPAGE_YML, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # 找到 cards: 下的第一项（假设格式为 - "x.x.x" 或 - x.x.x）
    in_cards = False
    updated = False
    new_lines = []

    for line in lines:
        stripped = line.strip()
        if stripped == "cards:":
            in_cards = True
            new_lines.append(line)
            continue

        if in_cards and stripped.startswith("-"):
            # 提取当前值（去除 - 和引号）
            current_val = stripped[1:].strip().strip('"\'')
            if current_val == tag:
                print(f"⏩ cards[0] 已是 {tag}，无需更新")
                return

            # 替换为标准格式: - "tag"
            indent = len(line) - len(line.lstrip())
            new_line = " " * indent + f'- "{tag}"\n'
            new_lines.append(new_line)
            updated = True
            in_cards = False  # 只改第一个
        else:
            new_lines.append(line)
            if in_cards and stripped == "":
                # 空行表示 cards 结束（可选）
                in_cards = False

    if not updated:
        print("⚠️ 未找到 cards 列表中的第一项，跳过更新", file=sys.stderr)
        return

    # 写回文件
    with open(HOMEPAGE_YML, "w", encoding="utf-8") as f:
        f.writelines(new_lines)

    print(f'✅ 成功更新 cards[0] 为: "{tag}"')


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("用法: python update_homepage_cards.py <tag>", file=sys.stderr)
        sys.exit(1)
    update_first_card(sys.argv[1])
