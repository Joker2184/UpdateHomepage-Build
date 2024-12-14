#!/bin/bash

# 获取版本号 (tag_name)
version=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq -r '.[0].tag_name')

# 获取发布类型 (prerelease)
release_type=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq -r '.[0].prerelease')

# 获取创建时间 (只取 T 前面的日期)
created_at=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq -r '.[0].created_at' | cut -d 'T' -f 1)

# 获取最新提交的 commit 信息中的消息
commit_message=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/Hex-Dragon/PCL2/commits | jq -r '.[0].commit.message')

# 检查 commit_message 是否含有"正式版"
if [[ "$commit_message" == *"正式版"* ]]; then
    # 根据发布类型选择链接
    if [ "$release_type" == "true" ]; then
        # 如果是 pre-release，使用指定的链接
        link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebb11.png"
    elif [ "$release_type" == "false" ]; then
        # 如果是正式版本，使用指定的链接
        link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebafe.png"
    fi

    # 文件路径
    file_path="libraries/$version.md"

    # 检查文件是否存在
    if [ -e "$file_path" ]; then
        echo "文件已存在，无需更改"
    else
        echo "文件不存在，正在更新"
        # 创建或更新文件内容，确保格式正确
        echo -e "---\nnew: \"true\"\ndate: $created_at\nI_Link: $link\nWriter: Null\n---\n" > "$file_path"
        # 更新页面配置
        sed -i "2s/.*/- \"${version}\"/" pages/UpdateHomepage.yml

        # 使用 GitHub API 触发 repository_dispatch 事件
        curl -v -X POST \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $PAT_TOKEN" \
            https://api.github.com/repos/Joker2184/HomepageBuilder/dispatches \
            -d '{"event_type": "trigger-a-build"}'
    fi

    # 配置 Git 用户信息并提交更改
    git config --local user.email "Joker2184@outlook.com"
    git config --local user.name "Joker2184Bot"
    git add *
    git diff-index --quiet HEAD || (git commit -m "Update PCL to ${version}" && git push)
fi
