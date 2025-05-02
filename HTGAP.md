配置构建器：
```yaml
如果是快照版请使用第一个
---
date: XXXX-X-XX 
I_Link: https://pic1.imgdb.cn/item/66fde7a30a206445e36ebb11.png
Writer: XXXXXX
Type: 快照版
Note: 本次更新为快照版更新，仅赞助者可以试用。当更新内容稳定后，即会更新至正式版。
---
如果是正式版请使用第二个
---
date: XXXX-X-XX
I_Link: https://pic1.imgdb.cn/item/66fde7a30a206445e36ebafe.png
Writer: XXXXXX
Type: 正式版
Note: PCL 正式版可以永久免费下载使用。
---
```
正文部分：
本仓库默认以B站专栏作为范本
1.Copy B站专栏
2.打开 Deepsheep 
3.Paste B站专栏

Deepseek的命令：
他只需要干三件事
1.将文字转换成Markdown 输出为Markdown 
2.为 #数字 添加链接 https://github.com/Hex-Dragon/PCL2/issues/数字
3.为 英文部分 添加 `` 如 `Mod` 

Github操作：
在libraries/Verison文件夹下
创建一个新Markdown文件
```
如快照版则：
配置构建器
---
date: XXXX-X-XX 
I_Link: https://pic1.imgdb.cn/item/66fde7a30a206445e36ebb11.png
Writer: XXXXXX
Type: 快照版
Note: 本次更新为快照版更新，仅赞助者可以试用。当更新内容稳定后，即会更新至正式版。
---
# PCL 现已支持下载资源包、光影包和数据包！

非常感谢 Pigeon0v0 提供的帮助！


## 更新亮点
- **支持下载资源包、光影包、数据包**  
  （[#44](https://github.com/Hex-Dragon/PCL2/issues/44)、[#396](https://github.com/Hex-Dragon/PCL2/issues/396)、[#2991](https://github.com/Hex-Dragon/PCL2/issues/2991)，@ZerkyLiu、@WForst-Breeze，PR @Pigeon0v0）
   ![1](https://i0.hdslb.com/bfs/new_dyn/56fa1f459ef5560eed50a1e09cc024cb11343203.png)[图片是必要的 手动加入]

...

如果文字中含有PR @xxx 则为该句子添加颜色 如：<paracolor color="Orange"/>特定操作下，`MyListItem` 显示不正确（[#4596](https://github.com/Hex-Dragon/PCL2/issues/4596)，@ThendJyc，PR @Open-KFC）

```

然后修改 Pages 文件夹下的文件
修改第一行版本号

提交PR即可
3分钟内自动构建
