#!/bin/bash

# 获取最新的 PR 编号和标题
number=($(gh api -H "Accept: application/vnd.github+json" \
    repos/Hex-Dragon/PCL2/pulls | jq -r '.[0:10] | .[].number'))
title=($(gh api -H "Accept: application/vnd.github+json" \
    repos/Hex-Dragon/PCL2/pulls | jq -r '.[0:10] | .[].title'))

# 输出调试信息
echo "Number array: ${number[@]}"
echo "Title array: ${title[@]}"

# 配置文件路径
file_path="libraries/Homepage/IssueList.xaml"
previous_file_path="libraries/Homepage/IssueList.xaml"

# 删除旧的 IssueList.xaml 文件
if [ -e "$previous_file_path" ]; then
    echo "删除旧的 XAML 文件: $previous_file_path"
    rm "$previous_file_path"
else
    echo "没有找到旧的 XAML 文件: $previous_file_path"
fi

# 创建新的 IssueList.xaml 文件
echo "创建新的 IssueList.xaml 文件"

cat <<EOF > "$file_path"
<local:MyCard Margin="0,0,0,15">
    <StackPanel Margin="20,14">
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="3*"/>
                <ColumnDefinition Width="1*"/>
            </Grid.ColumnDefinitions>
            <StackPanel Grid.Column="0">
                <TextBlock FontSize="16"><Bold>Issue快讯</Bold></TextBlock>
                <TextBlock FontSize="14">你可以查看实时Issue列表</TextBlock>
                <TextBlock FontSize="14">提交Issue前可以瞄眼,请避免重复提交</TextBlock>
            </StackPanel>
            <local:MyIconTextButton Grid.Column="1" HorizontalAlignment="Right" EventType="打开网页" LogoScale="1"
                Text="Issues" EventData="https://github.com/Hex-Dragon/PCL2/issues" ToolTip="提交一个PCL Issue 如果是Bug修复后可以获取活跃橙"
                Logo="M8 9.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0z M1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0z"/>
        </Grid>
        <Line X1="0" X2="100" Stroke="{DynamicResource ColorBrush6}" StrokeThickness="1.5" Stretch="Fill" Margin="0,8"/>
        <TextBlock FontSize="16" Margin="13,0,0,0"><Bold>最新Issue [latest:10 5min reload]</Bold></TextBlock>
        <StackPanel>
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                    <RowDefinition Height="45" />
                </Grid.RowDefinitions>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="400" />
                </Grid.ColumnDefinitions>
                <local:MyListItem Title="Issue#${number[0]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[0]}" Grid.Row="0" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[1]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[1]}" Grid.Row="1" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[2]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[2]}" Grid.Row="2" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[3]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[3]}" Grid.Row="3" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[4]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[4]}" Grid.Row="4" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[5]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[5]}" Grid.Row="5" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[6]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[6]}" Grid.Row="6" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[7]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[7]}" Grid.Row="7" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[8]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[8]}" Grid.Row="8" Grid.Column="1"/>
                <local:MyListItem Title="Issue#${number[9]}" Margin="5,0,0,0" IsHitTestVisible="False" Info="${title[9]}" Grid.Row="9" Grid.Column="1"/>
            </Grid>
        </StackPanel>
    </StackPanel>
</local:MyCard>
EOF

# 配置 Git 提交信息并推送到指定仓库
git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git remote set-url origin https://github.com/Joker2184/UpdateHomepage.git

# 检查更改并推送
git add *
git diff-index --quiet HEAD || git commit -m "Update IssueList.xaml for Issue#${number[0]}" && git push origin main
