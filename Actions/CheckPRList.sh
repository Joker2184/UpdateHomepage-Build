#!/bin/bash

# 初始化文件更新标志
file_updated=false

# 获取最新的 PR 编号和标题
number=$(gh api -H "Accept: application/vnd.github+json" \
    repos/Hex-Dragon/PCL2/pulls | jq -r 'sort_by(.created_at) | last | .number')

title=$(gh api -H "Accept: application/vnd.github+json" \
    repos/Hex-Dragon/PCL2/pulls | jq -r 'sort_by(.created_at) | last | .title')

# 基于 PR 编号创建文件路径
file_path="libraries/Homepage/PRSave/PR#$number.xaml"

# 判断文件是否存在
if [ -e "$file_path" ]; then
    echo "文件已存在，无需更改"
else
    echo "文件不存在，正在更新"
    # 创建新 XAML 文件，填入对应的内容
    cat <<EOF > "$file_path"
<local:MyCard Margin="0,0,0,15">
    <StackPanel Margin="20,14">
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="3*"/>
                <ColumnDefinition Width="1*"/>
            </Grid.ColumnDefinitions>
            <StackPanel Grid.Column="0">
                <TextBlock FontSize="16"><Bold>社区快讯</Bold></TextBlock>
                <TextBlock FontSize="14">社区用户正在参与制作更多有趣的新功能</TextBlock>
                <TextBlock FontSize="14">他们正为 PCL 伟大的咕咕咕事业贡献自己的力量！</TextBlock>
            </StackPanel>
            <local:MyIconTextButton Grid.Column="1" HorizontalAlignment="Right" EventType="打开网页" LogoScale="1"
                Text="PRs" EventData="https://github.com/Hex-Dragon/PCL2/pulls" ToolTip="提交一个PCL Pull Requests 合并后可以获取活跃橙"
                Logo="M256 170.666667a85.333333 85.333333 0 1 0 0 170.666666 85.333333 85.333333 0 0 0 0-170.666666zM85.333333 256a170.666667 170.666667 0 1 1 213.333334 165.290667V896a42.666667 42.666667 0 0 1-85.333334 0V421.290667A170.666667 170.666667 0 0 1 85.333333 256z m426.666667 0a42.666667 42.666667 0 0 1 42.666667-42.666667H682.666667A128 128 0 0 1 810.666667 341.333333v261.376a170.666667 170.666667 0 1 1-85.333334 0V341.333333a42.666667 42.666667 0 0 0-42.666666-42.666666H554.666667A42.666667 42.666667 0 0 1 512 256z m256 426.666667a85.333333 85.333333 0 1 0 0 170.666666 85.333333 85.333333 0 0 0 0-170.666666z"/>
        </Grid>
        <Line X1="0" X2="100" Stroke="{DynamicResource ColorBrush6}" StrokeThickness="1.5" Stretch="Fill" Margin="0,8"/>
        <TextBlock FontSize="16"><Bold>最新PR</Bold></TextBlock>
        <StackPanel>
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="45" />
                </Grid.RowDefinitions>
                <local:MyListItem Title="PR#$number" Margin="-10,0,0,0" IsHitTestVisible="False" Info="$title" Grid.Row="0" Grid.Column="1"/>
            </Grid>
        </StackPanel>
        <TextBlock FontSize="16"><Bold>你可以帮忙的PR</Bold></TextBlock>
        <StackPanel>
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="45" />
                </Grid.RowDefinitions>
                <local:MyListItem Title="本地化：语言、配置项、时间 #4145" Margin="-10,0,0,0" IsHitTestVisible="False" Info="你可以协助社区工作者一同完善PCL的国际化工作" Grid.Row="0" Grid.Column="1"/>
                <local:MyIconTextButton Grid.Column="1" HorizontalAlignment="Right" EventType="打开网页" LogoScale="1"
                    Text="加入翻译队伍" EventData="https://weblate.tangge233.cn/engage/PCL/" 
                    Logo="M640 416h256c35.36 0 64 28.48 64 64v416c0 35.36-28.48 64-64 64H480c-35.36 0-64-28.48-64-64V640h128c53.312 0 96-42.976 96-96V416zM64 128c0-35.36 28.48-64 64-64h416c35.36 0 64 28.48 64 64v416c0 35.36-28.48 64-64 64H128c-35.36 0-64-28.48-64-64V128z m128 276.256h46.72v-24.768h67.392V497.76h49.504V379.488h68.768v20.64h50.88V243.36H355.616v-34.368c0-10.08 1.376-18.784 4.16-26.112a10.56 10.56 0 0 0 1.344-4.16c0-0.896-3.2-1.792-9.6-2.72h-46.816v67.36H192v160.896z m46.72-122.368h67.392v60.48h-67.36V281.92z m185.664 60.48h-68.768V281.92h68.768v60.48z m203.84 488l19.264-53.632h100.384l19.264 53.632h54.976L732.736 576h-64.64L576 830.4h52.256z m33.024-96.256l37.12-108.608h1.376l34.368 108.608h-72.864zM896 320h-64a128 128 0 0 0-128-128v-64a192 192 0 0 1 192 192zM128 704h64a128 128 0 0 0 128 128v64a192 192 0 0 1-192-192z"/>
            </Grid>
        </StackPanel>
    </StackPanel>
</local:MyCard>
EOF
    # 更新 pages/UpdateHomepage.yml 的第 3 行
    sed -i "4s/.*/- PR#$number/" pages/UpdateHomepage.yml

    # 设置文件更新标志
    file_updated=true
fi

# 只有在文件更新时才触发 GitHub Action
if [ "$file_updated" = true ]; then  # 使用 "= true" 进行比较
    # 使用 GitHub API 触发 repository_dispatch 事件
    curl -v -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $PAT_TOKEN" \
        https://api.github.com/repos/Joker2184/HomepageBuilder/dispatches \
        -d '{"event_type": "trigger-a-build"}'
fi

# 配置 Git 提交信息并推送
git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git add *
git diff-index --quiet HEAD || (git commit -m "Update to PR#$number" && git push)
