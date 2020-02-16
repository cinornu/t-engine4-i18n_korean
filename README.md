# readme

This is NOT the repository for [ToME4](http://te4.org/), the repository for it is [here](https://git.net-core.org/tome/t-engine4).

This repository is a platform for co-work oriented towards an I18n-enhanced T-Engine and ToME4.

## Install and run

Install [Git for windows](https://git-scm.com/downloads) .

After install, right click and choose 'Git bash here', run the following command.

```bash
git clone https://github.com/cinornu/t-engine4-i18n_korean.git
```

It will download and sync the repository.

Everytime you need to update, you can right click in the repository, choose 'Git bash here' and use this command:

```bash
git pull
```

You can run `t-engine.exe` to start the game.

## Developer's guide

You would need a console environment, `lua 5.1`，`luarocks` <https://luarocks.org/> and the following `luarocks` packages.

* `luafilesystem` latest version
* `lpeg` 0.9-1 DON'T use latest version!

Translation tools is under `i18n_tools` directory.

The translation preparation will includes those steps:

* Change dir to `i18n_tools`.
* Run `lua i18n_extractor.lua ../game/engines ../game/modules/tome ../game/dlcs ../game/addons >tmp.log` to extract any text in the game to `i18n_list.lua` file.
* Run `lua i18n_helper.lua` . It will rearrange and deduplicate all text in  `merge_translation.lua`, and print the rearranged translation file to `output_translation.lua` and or untranslated texts to  `untranslated.lua`
* It will also generate `game/engines/data/locales/ko_KR.lua`, which is used by the game.
* You can add tranlation texts in the end of `merge_translation.lua` and repeat runing `lua i18n_helper.lua` to rearrange it, after this, you should use `output_translation.lua` to replace `merge_translation.lua`.
