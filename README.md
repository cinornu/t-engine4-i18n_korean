# readme

This is NOT the repository for [ToME4](http://te4.org/), the repository for it is [here](https://git.net-core.org/tome/t-engine4).

This repository is a platform for co-work oriented towards an I18n-enhanced T-Engine and ToME4.

The following readme will be in Chinese.

## 安装和运行

安装 [Git for windows](https://git-scm.com/downloads) 。

安装教程 <https://www.cnblogs.com/jyd0124/p/git.html>

安装后，右键一个空目录选择 Git bash here ，然后输入以下命令：

```bash
git clone https://github.com/StarSapphireX/t-engine4-i18n_working_bench.git
```

这个命令会下载并同步该仓库。

之后每次更新的时候，在仓库内右键 Git bash here ，输入以下命令：

```bash
git pull
```

直接运行t-engine.exe即可。

如果有问题请在群里提问。

## 开发要求

安装并配置一个终端环境， `lua 5.1`，`luarocks` <https://luarocks.org/> ，还有以下`luarocks`包

* `luafilesystem` 最新版
* `lpeg` 0.9-1 不能使用最新版！

汉化内容位于`i18n_tools`目录下，

汉化进程分以下几个步骤：

* 切换到 `i18n_tools` 目录
* 使用`lua i18n_extractor.lua ../game/engines ../game/modules/tome ../game/dlcs ../game/addons >tmp.log` 提取游戏的汉化文本到 `i18n_list.lua` 文件
* 运行 `lua i18n_helper.lua` 将会把 `merge_translation.lua` 里面的汉化文本整理去重，然后输出整理完成的`output_translation.lua`文件和未汉化文本`untranslated.lua`文件。
* 现在这个程序也会自动生成 `game/engines/data/locales/zh_CN.lua`了，进行测试吧。
* 如果你觉得汉化好了，可以随时用`output_translation.lua`覆盖`merge_translation.lua`。
