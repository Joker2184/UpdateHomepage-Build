version_info=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq '.[0]')

# 提取版本、发布类型、创建时间
version=$(echo "$version_info" | jq -r .tag_name)
release_type=$(echo "$version_info" | jq -r .prerelease)  # true if pre-release, false if release
created_at=$(echo "$version_info" | jq -r .created_at | cut -d 'T' -f 1)  # 获取日期部分

# 根据发布类型选择链接
if [ "$release_type" == "true" ]; then
    link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebb11.png"  # pre-release 链接
else
    link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebafe.png"  # release 链接
fi

# 确保文件路径正确
file_path="libraries/$version.md"

# 检查文件是否存在
if [ -e "$file_path" ]; then
    echo "文件存在，无需更改"
else
    echo "文件不存在，正在更新"
    # 将新内容写入文件，确保正确格式
    echo -e "---\nnew: \"true\"\ndate: $created_at\nI_Link: $link\n---\n" > "$file_path"
    # 更新页面配置
    sed -i "2s/.*/- \"${version}\"/" pages/UpdateHomepage.yml
fi

# 配置 Git 用户信息并提交更改
git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git add *
git diff-index --quiet HEAD || (git commit -m "Update to $version" && git push)
