version_info=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq '.[0]')

version=$(echo "$version_info" | jq -r .tag_name)
release_type=$(echo "$version_info" | jq -r .prerelease)  # true if pre-release, false if release
created_at=$(echo "$version_info" | jq -r .created_at | cut -d 'T' -f 1)  # 获取时间部分

if [ "$release_type" == "true" ]; then
    # 如果是 pre-release，填入指定链接
    link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebb11.png"
else
    # 如果是 release，填入 I_Link 链接
    link="https://pic.imgdb.cn/item/66fde7a30a206445e36ebafe.png"
fi

file_path="libraries/$version.md"
if [ -e "$file_path" ]; then
    echo "文件存在，无需更改"
else
    echo "文件不存在，正在更新"
    echo "---\nnew: \"true\"\ndate: $created_at\nI_Link: $link\n---\n" > $file_path
    sed -i "2s/.*/- \"${version}\"/" pages/UpdateHomepage.yml
fi

git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git add *
git diff-index --quiet HEAD || git commit -m "Update to $version" && git push
