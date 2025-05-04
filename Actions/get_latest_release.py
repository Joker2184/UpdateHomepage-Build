import requests

def get_latest_release():
    """
    获取 Hex-Dragon/PCL2 仓库的最新 release 信息。
    
    :return: 最新 release 的版本信息或错误信息
    """
    url = "https://api.github.com/repos/Hex-Dragon/PCL2/releases/latest"
    headers = {
        "Accept": "application/vnd.github.v3+json"
    }
    
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        data = response.json()
        return {
            "tag_name": data.get("tag_name"),
            "name": data.get("name"),
            "body": data.get("body"),
            "html_url": data.get("html_url"),
            "published_at": data.get("published_at")
        }
    except requests.exceptions.RequestException as e:
        return {"error": str(e)}

def save_release_to_markdown(release_info):
    """
    将 release 信息保存为 Markdown 文件。
    
    :param release_info: 包含 release 信息的字典
    """
    filename = f"temp/{release_info['tag_name']}.md"  # 修改输出路径为 temp 文件夹
    date = release_info['published_at'].split("T")[0]  # 仅保留年月日
    metadata = f"---\n" \
               f"date: {date}\n" \
               f"I_Link: https://pic1.imgdb.cn/item/66fde7a30a206445e36ebb11.png\n" \
               f"Writer: GitHub-actions\n" \
               f"Type: 快照版\n" \
               f"Note: 本次更新为快照版更新，仅赞助者可以试用。当更新内容稳定后，即会更新至正式版。\n" \
               f"---\n\n"
    content = f"# {release_info['name']}\n\n" \
              f"**版本号**: {release_info['tag_name']}\n\n" \
              f"\n{release_info['body']}\n\n" \
              f"[查看 Release]({release_info['html_url']})"
    try:
        with open(filename, "w", encoding="utf-8") as file:
            file.write(metadata + content)
        print(f"Release 信息已保存到文件: {filename}")
    except IOError as e:
        print(f"保存文件失败: {e}")

if __name__ == "__main__":
    release_info = get_latest_release()
    if "error" in release_info:
        print(f"获取 release 信息失败: {release_info['error']}")
    else:
        print("最新 Release 信息：")
        print(f"版本号: {release_info['tag_name']}")
        print(f"名称: {release_info['name']}")
        print(f"描述: {release_info['body']}")
        print(f"链接: {release_info['html_url']}")
        save_release_to_markdown(release_info)
