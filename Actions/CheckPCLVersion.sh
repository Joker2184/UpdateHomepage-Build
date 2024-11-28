version=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    repos/Hex-Dragon/PCL2/releases | jq | grep tag_name | head -n 1 | cut -d '"' -f 4)

file_path="libraries/$version.md"
if [ -e "$file_path" ]; then
    echo "文件存在，无需更改"
else
    echo "文件不存在，正在更新"
    echo "---\nnew: \"true\"\n---\n" > $file_path
    sed -i "2s/.*/- \"${version}\"/" pages/UpdateHomepage.yml
fi

git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git add *
git diff-index --quiet HEAD || git commit -m "Update to $version" && git push