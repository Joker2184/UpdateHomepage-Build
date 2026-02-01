#!/usr/bin/env python3
"""
自动获取 PCL 最新 Release 日志，
生成带固定 Front Matter 的 Markdown 文件，
仅当文件不存在时才创建。
"""

import requests
import os
import sys

# === 配置区（可按需调整）===
SNAPSHOT_DIR = "libraries/Verison/Snapshot"
FRONT_MATTER = """---
date: {date}
I_Link: https://pic1.imgdb.cn/item/66fde7a30a206445e36ebb11.png
Writer: ZeroPrism
Type: 快照版
Note: 本次更新为快照版更新，仅赞助者可以试用。当更新内容稳定后，即会更新至正式版。
---"""


def main():
    os.makedirs(SNAPSHOT_DIR, exist_ok=True)

    # 获取最新 Release
    resp = requests.get("https://api.github.com/repos/Meloong-Git/PCL/releases/latest")
    if resp.status_code != 200:
        print(f"❌ 获取最新 Release 失败: {resp.status_code}", file=sys.stderr)
        sys.exit(1)

    release = resp.json()
    tag = release["tag_name"]
    published_at = release["published_at"]  # ISO 8601 格式，如 2024-06-15T10:30:00Z
    body = release["body"]

    filepath = os.path.join(SNAPSHOT_DIR, f"{tag}.md")

    if os.path.exists(filepath):
        print(f"⏩ {tag}.md 已存在，跳过")
        return

    # 构建完整内容
    content = FRONT_MATTER.format(date=published_at) + "\n\n" + body

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"✅ 已生成: {filepath}")


if __name__ == "__main__":
    main()
