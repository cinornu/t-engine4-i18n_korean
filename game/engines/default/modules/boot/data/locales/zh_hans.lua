locale "zh_hans"
------------------------------------------------
section "mod-boot/class/Game.lua"

t("Welcome to T-Engine and the Tales of Maj'Eyal", "欢迎来到 T-Engine 和马基·埃亚尔的传说", "_t")
t([[#GOLD#"Tales of Maj'Eyal"#WHITE# is the main game, you can also install more addons or modules by going to https://te4.org/

When inside a module remember you can press Escape to bring up a menu to change keybindings, resolution and other module specific options.

Remember that in most roguelikes death is usually permanent so be careful!

Now go and have some fun!]], [[#GOLD#马·基埃亚尔的传说#WHITE# 是主游戏，你也可以在 https://te4.org/ 下载到更多游戏插件和游戏模组。

在游戏模组内，你可以按ESC键打开菜单，改变按键绑定，游戏分辨率和其他和模组有关的设置。

请记住，在大部分Roguelike游戏里，角色的死亡都是永久的，请小心！

玩的开心！]], "_t")
t("Upgrade to 1.0.5", "升级到 v1.0.5 版本", "_t")
t([[The way the engine manages saving has been reworked for v1.0.5.

The background saves should no longer lag horribly and as such it is highly recommended that you use the option. The upgrade turned it on for you.

For the same reason the save per level option should not be used unless you have severe memory problems. The upgrade turned it off for you.
]], [[游戏引擎管理游戏存档的方式在 v1.0.5 版本发生了变化

后台存档将不再会严重拖慢你的游戏运行速率，强烈建议你开启这一选项。这次更新会自动帮你打开这个选项。

与此同时，每层存档的选项已经没有必要使用，除非你有严重的内存问题。这次更新会自动帮你关闭这个选项。
]], "_t")
t("Safe Mode", "安全模式", "_t")
t([[Oops! Either you activated safe mode manually or the game detected it did not start correctly last time and thus you are in #LIGHT_GREEN#safe mode#WHITE#.
Safe Mode disabled all graphical options and sets a low FPS. It is not advisable to play this way (as it will be very painful and ugly).

Please go to the Video Options and try enabling/disabling options and then restarting until you do not get this message.
A usual problem is shaders and thus should be your first target to disable.]], [[糟糕！如果你不是手动开启了安全模式的话，那么说明，游戏检测到上一次启动时发生错误，目前游戏已进入#LIGHT_GREEN#安全模式#WHITE#。
在安全模式下，所有图形选项都被关闭，FPS被设置为很低。不建议在这种情况下进行游戏(游戏画面会变得很难看)。

请你进入游戏视频选项，尝试调整游戏选项，直到你不再弹出此消息。
常见的问题一般是由着色器引发的，你可以先尝试关闭这些选项。]], "_t")
t("Message", "消息", "_t")
t("Duplicate Addon", "重复的插件", "_t")
t([[Oops! It seems like you have the same addon/dlc installed twice.
This is unsupported and would make many things explode. Please remove one of the copies.

Addon name: #YELLOW#%s#LAST#

Check out the following folder on your computer:
%s
%s
]], [[糟糕！好像你安装了多份同一个插件/DLC。
这种情况不被支持的，会引发很多BUG。请你移除掉多余的文件。

插件名称： #YELLOW#%s#LAST#

请你检查你电脑里的以下文件夹：
%s
%s
]], "_t")
t("Updating addon: #LIGHT_GREEN#%s", "正在更新插件: #LIGHT_GREEN#%s", "tformat")
t("Quit", "退出", "_t")
t("Really exit T-Engine/ToME?", "真的要退出 T-Engine/马基·埃亚尔的传说", "_t")
t("Continue", "继续", "_t")
t([[Welcome to #LIGHT_GREEN#Tales of Maj'Eyal#LAST#!

Before you can start dying in many innovative ways we need to ask you about online play.

This is a #{bold}#single player game#{normal}# but it also features many online features to enhance your gameplay and connect you to the community:
* Play from several computers without having to copy unlocks and achievements.
* Talk ingame to other fellow players, ask for advice, share your most memorable moments...
* Keep track of your kill count, deaths, most played classes...
* Cool statistics for to help sharpen your gameplay style
* Install official expansions and third-party addons directly from the game, hassle-free
* Access your purchaser / donator bonuses if you have bought the game or donated on https://te4.org/
* Help the game developers balance and refine the game

You will also have a user page on #LIGHT_BLUE#https://te4.org/#LAST# to show off to your friends.
This is all optional, you are not forced to use this feature at all, but the developer would thank you if you did as it will make balancing easier.]], [[欢迎来到#LIGHT_GREEN#马基·埃亚尔的传说#LAST#！

在你开始尝试这个游戏里无数有趣的死法之前，我们想问你一下有关在线游戏的事情。

马基·埃亚尔的传说是一个#{bold}#单人游戏#{normal}#，但也提供了丰富的在线功能，可以增强你的游戏体验，并让你和游戏社区建立联系：
* 在多台电脑上游玩，而不需要复制游戏解锁和成就。
* 与其他玩家在游戏内聊天，寻求建议，分享难忘的时刻…
* 记录你的击杀数量，死亡次数，以及最喜欢的职业…
* 统计你的游戏数据，来记录你的游戏风格
* 在游戏里直接安装官方扩展包和第三方插件，免去手动安装的麻烦
* 如果你购买了游戏或是在 https:/te4.org/ 上进行了捐助，你可以获得获得你的购买者/赞助者独享权益
* 帮助游戏开发者调整游戏平衡，让这个游戏变得更好。

你也会在获得一个 #LIGHT_BLUE#https:/te4.org/#LAST# 上的用户页面，可以用来向你的朋友炫耀。
这一切都是可选的，你可以自愿使用或者关闭这些功能。开发者会根据你的用户反馈来协助调整游戏平衡。]], "_t")
t("Login in...", "登录中…", "_t")
t("Please wait...", "请等待…", "_t")
t("Profile logged in!", "账户登录成功！", "_t")
t("Your online profile is now active. Have fun!", "你的在线账户已可用。玩得开心！", "_t")
t("Login failed!", "登陆失败！", "_t")
t("Check your login and password or try again in in a few moments.", "请确认你的用户名和密码，或在几分钟后再试。", "_t")
t("Registering...", "正在注册", "_t")
t("Registering on https://te4.org/, please wait...", "正在在 https://te4.org/ 上注册，请稍候…", "_t")
t("Logged in!", "登陆成功！", "_t")
t("Profile created!", "账户创建成功！", "_t")
t("Profile creation failed!", "账户创建失败！", "_t")
t("Creation failed: %s (you may also register on https://te4.org/)", "创建失败: %s (你也可以在 https://te4.org/ 网站上注册）", "tformat")
t("Try again in in a few moments, or try online at https://te4.org/", "请过几分钟后再试，或在 https://te4.org/ 网站上注册", "_t")

------------------------------------------------
section "mod-boot/class/Player.lua"

t("%s available", "%s可用", "tformat")
t("#00ff00#Talent %s is ready to use.", "#00ff00#技能%s已经可以使用了。", "log")
t("LEVEL UP!", "升级了！", "_t")

------------------------------------------------
section "mod-boot/data/birth/descriptors.lua"

t("base", "基础", "birth descriptor name")
t("Destroyer", "毁灭者", "birth descriptor name")
t("Acid-maniac", "狂酸使", "birth descriptor name")

------------------------------------------------
section "mod-boot/data/damage_types.lua"

t("Kill!", "击杀!", "_t")

------------------------------------------------
section "mod-boot/data/general/grids/basic.lua"

t("floor", "地板", "entity type")
t("floor", "地板", "entity subtype")
t("floor", "地板", "entity name")
t("wall", "墙壁", "entity type")
t("wall", "墙壁", "entity name")
t("door", "门", "entity name")
t("open door", "敞开的门", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/forest.lua"

t("floor", "地板", "entity type")
t("grass", "草地", "entity subtype")
t("grass", "草地", "entity name")
t("wall", "墙壁", "entity type")
t("tree", "树", "entity name")
t("flower", "花", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/underground.lua"

t("wall", "墙壁", "entity type")
t("underground", "地下", "entity subtype")
t("crystals", "水晶", "entity name")
t("floor", "地板", "entity type")
t("floor", "地板", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/water.lua"

t("floor", "地板", "entity type")
t("water", "水", "entity subtype")
t("deep water", "深水", "entity name")

------------------------------------------------
section "mod-boot/data/general/npcs/canine.lua"

t("animal", "动物", "entity type")
t("canine", "犬类", "entity subtype")
t("wolf", "狼", "entity name")
t("Lean, mean, and shaggy, it stares at you with hungry eyes.", "一头瘦弱的、狡猾的皮毛蓬松的饿狼，它正用贪婪的眼神看着你。", "_t")
t("white wolf", "白狼", "entity name")
t("A large and muscled wolf from the northern wastes. Its breath is cold and icy and its fur coated in frost.", "一头来自北部荒野的狼，它膘肥身健，体型匀称。它的呼吸冰冷而急促且全身都凝结着冰霜。", "_t")
t("warg", "座狼", "entity name")
t("It is a large wolf with eyes full of cunning.", "这是一只狡猾且体型巨大的狼。", "_t")
t("fox", "狐狸", "entity name")
t("The quick brown fox jumps over the lazy dog.", "这只灵巧的棕色狐狸从一只懒狗身上跳了过去。", "_t")

------------------------------------------------
section "mod-boot/data/general/npcs/skeleton.lua"

t("undead", "亡灵", "entity type")
t("skeleton", "骷髅", "entity subtype")
t("degenerated skeleton warrior", "腐化骷髅战士", "entity name")
t("skeleton warrior", "骷髅战士", "entity name")
t("skeleton mage", "骷髅法师", "entity name")
t("armoured skeleton warrior", "武装骷髅战士", "entity name")

------------------------------------------------
section "mod-boot/data/general/npcs/troll.lua"

t("giant", "巨人", "entity type")
t("troll", "巨魔", "entity subtype")
t("forest troll", "森林巨魔", "entity name")
t("Green-skinned and ugly, this massive humanoid glares at you, clenching wart-covered green fists.", "丑陋的绿皮生物正盯着你，同时它握紧了满是肉瘤的绿色拳头。", "_t")
t("stone troll", "岩石巨魔", "entity name")
t("A giant troll with scabrous black skin. With a shudder, you notice the belt of dwarf skulls around his massive waist.", "有着粗糙黑色皮肤的巨魔，一阵战栗后，你惊讶的发现他的腰带是用矮人头骨制成。", "_t")
t("cave troll", "洞穴巨魔", "entity name")
t("This huge troll wields a massive spear and has a disturbingly intelligent look in its piggy eyes.", "这只巨魔手握一根笨重的长矛，同时在它那贪婪的眼睛里，你看出了一丝令人不安的信息。", "_t")
t("mountain troll", "山岭巨魔", "entity name")
t("A large and athletic troll with an extremely tough and warty hide.", "一只高大且强壮的巨魔，身披一张丑陋但异常坚硬的兽皮。", "_t")
t("mountain troll thunderer", "闪电山岭巨魔", "entity name")

------------------------------------------------
section "mod-boot/data/talents.lua"

t("misc", "杂项", "talent category")
t("Kick", "踢", "talent name")
t("Acid Spray", "酸液喷吐", "talent name")
t("Manathrust", "奥术射线", "talent name")
t("Flame", "火球术", "talent name")
t("Fireflash", "爆裂火球", "talent name")
t("Lightning", "闪电术", "talent name")
t("Sunshield", "太阳护盾", "talent name")
t("Flameshock", "火焰冲击", "talent name")

------------------------------------------------
section "mod-boot/data/timed_effects.lua"

t("Burning from acid", "酸液灼烧", "_t")
t("#Target# is covered in acid!", "#Target#被酸液覆盖！", "_t")
t("+Acid", "+酸液", "_t")
t("#Target# is free from the acid.", "#Target#身上的酸液消失了。", "_t")
t("-Acid", "-酸液", "_t")
t("Sunshield", "太阳护盾", "_t")

------------------------------------------------
section "mod-boot/data/zones/dungeon/zone.lua"

t("Forest", "森林", "_t")

------------------------------------------------
section "mod-boot/dialogs/Addons.lua"

t("Configure Addons", "设置插件", "_t")
t("You can get new addons at #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "在以下位置可以获得新的插件： #LIGHT_BLUE##{underline}#Te4.org 插件页面#{normal}#", "_t")
t(" and #LIGHT_BLUE##{underline}#Te4.org DLCs#{normal}#", " 和 #LIGHT_BLUE##{underline}#Te4.org DLC页面#{normal}#", "_t")
t("You can get new addons on #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "在以下位置可以获得新的插件： #LIGHT_BLUE##{underline}#Steam 创意工坊#{normal}# ", "_t")
t(", #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", ", #LIGHT_BLUE##{underline}#Te4.org 插件页面#{normal}#", "_t")
t("Show incompatible", "显示不兼容版本", "_t")
t("Auto-update on start", "启动时自动更新", "_t")
t("Game Module", "游戏模组", "_t")
t("Version", "版本", "_t")
t("Addon", "插件", "_t")
t("Active", "启动", "_t")
t("#GREY#Developer tool", "#GREY#开发者工具", "_t")
t("#LIGHT_RED#Donator Status: Disabled", "#LIGHT_RED#捐赠者状态：禁用", "_t")
t("#LIGHT_GREEN#Manual: Active", "#LIGHT_GREEN#手动：启动", "_t")
t("#LIGHT_RED#Manual: Disabled", "#LIGHT_RED#手动：禁用", "_t")
t("#LIGHT_GREEN#Auto: Active", "#LIGHT_GREEN#自动：启动", "_t")
t("#LIGHT_RED#Auto: Incompatible", "#LIGHT_RED#自动：不兼容", "_t")
t("Addon Version", "插件版本", "_t")
t("Game Version", "游戏版本", "_t")

------------------------------------------------
section "mod-boot/dialogs/Credits.lua"

t("Project Lead", "首席制作人", "_t")
t("Lead Coder", "领衔程序设计", "_t")
t("World Builders", "世界构建", "_t")
t("Graphic Artists", "视觉艺术", "_t")
t("Expert Shaders Design", "特效设计", "_t")
t("Soundtracks", "游戏音乐", "_t")
t("Sound Designer", "音效设计", "_t")
t("Lore Creation and Writing", "剧情撰写", "_t")
t("Code Helpers", "程序设计", "_t")
t("Community Managers", "社区经理", "_t")
t("Text Editors", "文本编辑", "_t")
t("The Community", "游戏社区", "_t")
t("Others", "其他", "_t")

------------------------------------------------
section "mod-boot/dialogs/FirstRun.lua"

t("Welcome to Tales of Maj'Eyal", "欢迎来到马基埃亚尔的传说", "_t")
t("Register now!", "现在注册！", "_t")
t("Login existing account", "登录已有账户", "_t")
t("Maybe later", "以后再说", "_t")
t("#RED#Disable all online features", "#RED#关闭所有联网功能", "_t")
t("Disable all connectivity", "禁用所有网络连接", "_t")
t([[You are about to disable all connectivity to the network.
This includes, but is not limited to:
- Player profiles: You will not be able to login, register
- Characters vault: You will not be able to upload any character to the online vault to show your glory
- Item's Vault: You will not be able to access the online item's vault, this includes both storing and retrieving items.
- Ingame chat: The ingame chat requires to connect to the server to talk to other players, this will not be possible.
- Purchaser / Donator benefits: The base game being free, the only way to give donators their bonuses fairly is to check their online profile. This will thus be disabled.
- Easy addons downloading & installation: You will not be able to see ingame the list of available addons, nor to one-click install them. You may still do so manually.
- Version checks: Addons will not be checked for new versions.
- Discord: If you are a Discord user, Rich Presence integration will also be disabled by this setting.
- Ingame game news: The main menu will stop showing you info about new updates to the game.

#{bold}##CRIMSON#This is an extremely restrictive setting. It is recommended you only activate it if you have no other choice as it will remove many fun and acclaimed features.#{normal}#

If you disable this option you can always re-activate it in the Online category of the Game Options menu later on.]], [[即将禁止所有网络请求
包括但不仅限于:
- 用户信息：不能登录或者注册。
- 角色备份：不能在te4.org上保存你的角色信息(用来给其他人分享你的炫酷角色)。
- 物品仓库：不能访问你的在线物品仓库(包括存入和取回)。
- 游戏内聊天：聊天要联网, 谢谢。
- 氪金福利：联网才能获取你的氪金状态。
- 扩展包&DLC：和氪金状态一样, 无法获取DLC的购买状态。
- 便捷的插件安装：无法在游戏内看见插件列表, 但是你还可以手动安装插件。
- 插件版本更新：无法更新插件的版本。
- Steam：无法使用Steam相关的任何功能。
- Discord：无法同步到Discord的实时状态。
- 游戏内新闻：主菜单将不再显示新闻。
注意这个设置只影响游戏本身。如果你使用游戏启动器，它的唯一目的就是确保游戏是最新的，因此它仍然会连接网络。
如果你不想这样，直接运行游戏即可。启动器只是用来更新游戏的。


#{bold}##CRIMSON#这是一个极端的选项。如果不是迫不得已, 推荐你不要打开它, 这会让你失去很多好用的功能和一些游戏体验。#{normal}#
关闭后，可以通过游戏设置菜单的在线选项卡打开。]], "_t")
t("Cancel", "取消", "_t")
t("#RED#Disable all!", "#RED#全部禁用！", "_t")

------------------------------------------------
section "mod-boot/dialogs/LoadGame.lua"

t("Load Game", "读取游戏", "_t")
t("Show older versions", "显示旧版本", "_t")
t("Ignore unloadable addons", "忽略无法读取的插件", "_t")
t("  Play!  ", "  游玩！  ", "_t")
t("Delete", "删除", "_t")
t([[#{bold}##GOLD#%s: %s#WHITE##{normal}#
Game version: %d.%d.%d
Requires addons: %s

%s]], [[#{bold}##GOLD#%s：%s#WHITE##{normal}#
游戏版本： %d.%d.%d
需要的插件： %s

%s]], "tformat")
t("You can simply grab an older version of the game from where you downloaded it.", "你可以在下载这个游戏的地方，下载到这个游戏的旧版本。", "_t")
t("You can downgrade the version by selecting it in the Steam's \"Beta\" properties of the game.", "你可以在Steam中设置Beta版本属性，来降级你的游戏版本。", "_t")
t("Original game version not found", "未找到原游戏版本", "_t")
t([[This savefile was created with game version %s. You can try loading it with the current version if you wish but it is recommended you play it with the old version to ensure compatibility
%s]], [[这个存档是游戏版本 %s 创建的。如果你愿意，你可以尝试使用当前版本强制读档，但是建议你使用旧版本游戏进行游玩，来确保兼容性。
%s]], "tformat")
t("Cancel", "取消", "_t")
t("Run with newer version", "运行新版本", "_t")
t("Developer Mode", "开发者模式", "_t")
t("#LIGHT_RED#WARNING: #LAST#Loading a savefile while in developer mode will permanently invalidate it. Proceed?", "#LIGHT_RED#警告： #LAST#在开发者模式下读取一个存档将会不可逆地将其标记为作弊存档。确定吗？", "_t")
t("Load anyway", "仍然读档", "_t")
t("Delete savefile", "删除存档", "_t")
t("Really delete #{bold}##GOLD#%s#WHITE##{normal}#", "真的要删除#{bold}##GOLD#%s#WHITE##{normal}#吗", "tformat")
t("Old game data", "旧版游戏数据", "_t")
t("No data available for this game version.", "没有当前游戏版本的数据。", "_t")
t("Downloading old game data: #LIGHT_GREEN#", "正在下载旧版游戏数据： #LIGHT_GREEN#", "_t")
t("Old game data for %s correctly installed. You can now play.", " %s 的旧版游戏数据已经安装成功了。你可以现在游玩了。", "tformat")
t("Failed to install.", "安装失败。", "_t")

------------------------------------------------
section "mod-boot/dialogs/MainMenu.lua"

t("Main Menu", "主菜单", "_t")
t("New Game", "新游戏", "_t")
t("Load Game", "读取游戏", "_t")
t("Addons", "插件", "_t")
t("Options", "选项", "_t")
t("Game Options", "游戏选项", "_t")
t("Credits", "制作人员名单", "_t")
t("Exit", "退出", "_t")
t("Reboot", "重启游戏", "_t")
t("Disable animated background", "关闭动态背景", "_t")
t("#{bold}##B9E100#T-Engine4 version: %d.%d.%d", "#{bold}##B9E100#T-Engine4 版本：%d.%d.%d", "tformat")
t([[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]], [[#{bold}##GOLD#乌鲁洛克之烬 - 游戏扩展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#很多马基埃亚尔的居民都曾经听说过“恶魔”的名字，它们是一群似乎凭空出现的暴虐生物，无论走到哪里都会带来痛苦和毁灭。#{normal}##LAST#

#{bold}#扩展包特性#{normal}#:
#LIGHT_UMBER#新职业：#WHITE# 毁灭使者。 他们是恶魔毁灭力量的化身，手拿双手武器加入战斗，将敌人化为一片火海。他们的手中掌握着火焰的魔法和恶魔的力量，在与势不可挡的敌人战斗中寻求欢愉。
#LIGHT_UMBER#新职业：#WHITE# 恶魔使者。 这些近战施法者手拿盾牌，掌握魔法大爆炸本身的力量的魔法，可以在倒下的敌人的身上终止恶魔种子。将这些恶魔种子附魔到你的物品里，可以获得各种全新的技能和被动的能力，并召唤种子里的恶魔来加入战斗！
#LIGHT_UMBER#新种族：#WHITE# 魔化精灵。 那些被恶魔的力量所改变的永恒精灵，他们的种族能力被腐化成了黑暗的形态。
#LIGHT_UMBER#更多新神器、新手札、新地图、新事件……#WHITE# 体验恶魔的欢愉吧！

]], "_t")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#已安装", "_t")
t("#YELLOW#Not installed - Click to download / purchase", "#YELLOW#未安装 - 点击下载/购买", "_t")
t([[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]], [[#{bold}##GOLD#余烬怒火 - 游戏扩展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#自从被兽人成为“西方灾星”的那个人，孤身一人粉碎了格鲁希纳克、沃尔、加伯特和拉克肖四大部落之后，已经过了一年的时间。联合王国现在已经通过远古传送门，和他们失落已久的盟友太阳堡垒建立了联系，帮助他们征服了瓦·埃亚尔大陆的近乎全境。被战火蹂躏的兽人部落的少数残余，现在都被联军关押在监狱里……但是，还有一个部落存活了下来。#{normal}##LAST#

#{bold}#扩展包特性#{normal}#:
#LIGHT_UMBER#全新战役：#WHITE# 这场战役在主游戏战役以后，决定兽人部落的最终命运。探索全新的远东大陆吧！
#LIGHT_UMBER#全新职业：#WHITE# 链锯屠夫，枪手，念力射手，歼灭者和科技法师。掌握蒸汽的力量，驱动致命的装置，用钢铁洪流粉碎那些胆敢反抗部落的人吧！
#LIGHT_UMBER#全新种族：#WHITE# 兽人，雪人，白蹄。了解兽人和他们那些奇特的“盟友”，团结起来，将兽人一族从“西方灾星”带来的灾难中拯救出来。
#LIGHT_UMBER#插件系统：#WHITE# 合成强大的插件，用于强化你的物品。包括给你的靴子安装火箭，给你的手套安装抓取系统，乃至许多更多的插件。
#LIGHT_UMBER#药剂系统：#WHITE# 在插件系统中，合成强大的医疗药剂，用于注入你的皮肤，替代就有的纹身和符文系统。
#LIGHT_UMBER#大量#WHITE# 全新神器、手札、地图和事件！

]], "_t")
t([[#{bold}##GOLD#Forgotten Cults - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Not all adventurers seek fortune, not all that defend the world have good deeds in mind. Lately the number of sightings of horrors have grown tremendously. People wander off the beaten paths only to be found years later, horribly mutated and partly insane, if they are found at all. It is becoming evident something is stirring deep below Maj'Eyal. That something is you.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Writhing Ones. Give in to the corrupting forces and turn yourself gradually into an horror, summon horrors to do your bidding, shed your skin and melt your face to assault your foes. With your arm already turned into a tentacle, what creature can stop you?
#LIGHT_UMBER#New class:#WHITE# Cultists of Entropy. Using its insanity and control of entropic forces to unravel the normal laws of physic this caster class can turn healing into attacks and call upon the forces of the void to reduce its foes to dust.
#LIGHT_UMBER#New race:#WHITE# Drems. A corrupt subrace of dwarves, that somehow managed to keep a shred of sanity to not fully devolve into mindless horrors. They can enter a frenzy and even learn to summon horrors.
#LIGHT_UMBER#New race:#WHITE# Krogs. Ogres transformed by the very thing that should kill them. Their powerful attacks can stun their foes and they are so strong they can dual wield any one handed weapons.
#LIGHT_UMBER#Many new zones:#WHITE# Explore the Scourge Pits, fight your way out of a giant worm (don't ask how you get *in*), discover the wonders of the Occult Egress and many more strange and tentacle-filled zones!
#LIGHT_UMBER#New horrors:#WHITE# You liked radiant horrors? You'll love searing horrors! And Nethergames. And Entropic Shards. And ... more
#LIGHT_UMBER#Sick of your own head:#WHITE#  Replace it with a nice cozy horror!
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, events... 

]], [[#{bold}##GOLD#禁忌邪教 - 游戏扩展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#不是所有的冒险者都在寻求财富，也不是所有保卫世界的人都心存善念。最近，恐魔在大陆上出现的次数急剧增加。不断有人在偏僻的小路上失踪，有时几年后才被人发现，身体却遭受了恐怖的变异，进入了疯狂之中，也有时候再也无法寻到踪迹。很明显，在马基·埃亚尔的大地深处，有某种东西正在暗中活动。那种东西——就是你。#{normal}##LAST#

#{bold}#扩展包特性#{normal}#:
#LIGHT_UMBER#新职业：#WHITE# 苦痛者。 它们被赋予了腐化的力量，最终将自己的身体转化成了恐魔。它们可以召唤恐魔在战斗中协助自己，撕裂你的皮肤，融化你的脸庞，作为攻击敌人的武器。当你的手臂也被转化成触手之后，还有什么敌人能阻挡你呢？
#LIGHT_UMBER#新职业：#WHITE# 熵教徒。 这种法师职业使用疯狂的能力，掌控了熵的力量，颠覆了传统的物理定律。它们可以将治疗转换成伤害，并召唤虚空的力量，将敌人粉碎为尘土。
#LIGHT_UMBER#新种族：#WHITE# 德瑞姆。 他们是矮人的一支腐化分支，但是因为某种原因，保持了一定程度的理性，而没有完全孵化成为没有意识的恐魔。他们可以进入狂热状态，并学会召唤恐魔。
#LIGHT_UMBER#新种族：#WHITE# 克罗格。 他们是被本来应当杀死他们的那群人转化的食人魔。他们强大的攻击可以震慑敌人，并且他们强壮的力量可以双持任何单手武器。
#LIGHT_UMBER#大量全新地图：#WHITE# 探索瘟疫之穴，在一只巨大蠕虫的身体内杀出一条血路(不要问我你是怎么*进来*的)，探索神秘的出口，以及更多奇异的，充满触手的地图！
#LIGHT_UMBER#新的恐魔：#WHITE# 你喜欢灼眼恐魔吗？你一定会喜欢上灼热恐魔的！还有虚空蠕虫，还有熵之碎片，还有其他更多怪物！
#LIGHT_UMBER#厌倦了你自己的头？#WHITE#  把它换成一个悠闲的寄生兽吧！
#LIGHT_UMBER#大量#WHITE# 全新神器、手札、事件……

]], "_t")
t("#GOLD#Online Profile", "#GOLD#在线账户", "_t")
t("Login", "登录", "_t")
t("Register", "注册", "_t")
t("Username: ", "用户名：", "_t")
t("Password: ", "密码：", "_t")
t("Login with Steam", "使用Steam登录", "_t")
t("#GOLD#Online Profile#WHITE#", "#GOLD#在线账户#WHITE#", "_t")
t("#LIGHT_BLUE##{underline}#Logout", "#LIGHT_BLUE##{underline}#登出", "_t")
t("Username", "用户名", "_t")
t("Your username is too short", "你的用户名过短", "_t")
t("Password", "密码", "_t")
t("Your password is too short", "你的密码过短", "_t")
t("Login...", "登录中…", "_t")
t("Login in your account, please wait...", "正在登录账户，请稍后…", "_t")
t("Steam client not found.", "找不到Steam客户端", "_t")
-- untranslated text
--[==[
t("#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "tformat")
--]==]


------------------------------------------------
section "mod-boot/dialogs/NewGame.lua"

t("New Game", "新游戏", "_t")
t("Show all versions", "显示所有版本", "_t")
t("Show incompatible", "显示不兼容版本", "_t")
t([[You can get new games at
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], [[你可以在这里下载到最新游戏
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], "_t")
t("Game Module", "游戏模组", "_t")
t("Version", "版本", "_t")
t("Enter your character's name", "输入角色名称", "_t")
t("Overwrite character?", "覆盖角色？", "_t")
t("There is already a character with this name, do you want to overwrite it?", "已经有一个这个名称的角色了，你要覆盖这个角色吗？", "_t")
t("No", "否", "_t")
t("Yes", "是", "_t")
t("This game is not compatible with your version of T-Engine, you can still try it but it might break.", "这个游戏与你T-Engine的版本不兼容，你可以尝试运行，但是游戏可能崩溃。", "_t")

------------------------------------------------
section "mod-boot/dialogs/Profile.lua"

t("Player Profile", "玩家账户", "_t")
t("Logout", "登出", "_t")
t("You are logged in", "你已经登入了。", "_t")
t("Do you want to log out?", "你要登出吗？", "_t")
t("Log out", "登出", "_t")
t("Cancel", "取消", "_t")
t("Login", "登录", "_t")
t("Create Account", "创建账户", "_t")

------------------------------------------------
section "mod-boot/dialogs/ProfileLogin.lua"

t("Online profile ", "在线账户", "_t")
t("Username: ", "用户名：", "_t")
t("Password: ", "密码：", "_t")
t("Login", "登录", "_t")
t("Cancel", "取消", "_t")
t("Password again: ", "重复密码：", "_t")
t("Email: ", "邮箱", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "允许我们#{bold}#偶尔#{normal}#向你发送有关游戏重要新闻的邮件(每年最多只会有几封)", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "游玩此游戏时你已年满16岁，或已得到了家长的许可。", "_t")
t("Create", "创建", "_t")
t("Privacy Policy (opens in browser)", "隐私政策(用浏览器打开)", "_t")
t("Password", "密码", "_t")
t("Password mismatch!", "密码不匹配！", "_t")
t("Username", "用户名", "_t")
t("Your username is too short", "你的用户名过短", "_t")
t("Your password is too short", "你的密码过短", "_t")
t("Email", "邮箱", "_t")
t("Your email seems invalid", "邮箱地址无效", "_t")
t("Age Check", "年龄确认", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "你需要年满16岁以上，或者得到了家长的许可，才可以游玩本游戏。", "_t")

------------------------------------------------
section "mod-boot/dialogs/ProfileSteamRegister.lua"

t("Steam User Account", "Steam用户账户", "_t")
t([[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]], [[欢迎来到#GOLD#马基·埃亚尔的传说#LAST#.
为了享受游戏的全部功能，我们#{bold}#强烈#{normal}#推荐你注册你的Steam账户。
幸运的是，这非常容易：你只需要提供你的Steam用户名，也可以提供你的邮箱。（我们基本上不会给你发送邮件，每年最多发送一两份）
]], "_t")
t("Username: ", "用户名：", "_t")
t("Email: ", "邮箱", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "允许我们#{bold}#偶尔#{normal}#向你发送有关游戏重要新闻的邮件(每年最多只会有几封)", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "游玩此游戏时你已年满16岁，或已得到了家长的许可。", "_t")
t("Register", "注册", "_t")
t("Cancel", "取消", "_t")
t("Privacy Policy (opens in browser)", "隐私政策(用浏览器打开)", "_t")
t("Username", "用户名", "_t")
t("Your username is too short", "你的用户名过短", "_t")
t("Email", "邮箱", "_t")
t("Your email does not look right.", "你的邮件地址有问题。", "_t")
t("Age Check", "年龄确认", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "你需要年满16岁以上，或者得到了家长的许可，才可以游玩本游戏。", "_t")
t("Registering...", "正在注册", "_t")
t("Registering on https://te4.org/, please wait...", "正在在 https://te4.org/ 上注册，请稍候…", "_t")
t("Steam client not found.", "找不到Steam客户端", "_t")
t("Error", "错误", "_t")
t("Username or Email already taken, please select an other one.", "用户名或邮件地址已被使用，请选择其他用户名或邮件地址", "_t")

------------------------------------------------
section "mod-boot/dialogs/UpdateAll.lua"

t("Update all game modules", "更新所有游戏模组", "_t")
t([[All those components will be updated:
]], [[所有需要更新的模组: 
]], "_t")
t("Component", "组件", "_t")
t("Version", "版本", "_t")
t("Nothing to update", "没有需要更新的内容", "_t")
t("All your game modules are up to date.", "所有游戏模组都处于最新版本。", "_t")
t("Game: #{bold}##GOLD#", "游戏：#{bold}##GOLD#", "_t")
t("Engine: #{italic}##LIGHT_BLUE#", "游戏引擎：#{italic}##LIGHT_BLUE#", "_t")
t("Error!", "错误！", "_t")
t([[There was an error while downloading:
]], [[下载时发生错误:
]], "_t")
t("Downloading: ", "正在下载：", "_t")
t("Update", "更新", "_t")
t("All updates installed, the game will now restart", "所有更新已安装完毕，游戏现在将会重新启动", "_t")

------------------------------------------------
section "mod-boot/dialogs/ViewHighScores.lua"

t("View High Scores", "查看高分榜", "_t")
t("Game Module", "游戏模组", "_t")
t("Version", "版本", "_t")
t("World", "世界", "_t")
t([[#{bold}##GOLD#%s#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s#GREEN# 高分榜 #WHITE##{normal}#

]], "tformat")
t([[#{bold}##GOLD#%s(%s)#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s(%s)#GREEN# 高分榜 #WHITE##{normal}#

]], "tformat")

------------------------------------------------
section "mod-boot/init.lua"

t("Tales of Maj'Eyal Main Menu", "马基·埃亚尔的传说 主菜单", "init.lua long_name")
t([[Bootmenu!
]], [[启动菜单!
]], "init.lua description")

------------------------------------------------
section "mod-boot/load.lua"

t("Strength", "力量", "stat name")
t("str", "力量", "stat short_name")
t("Dexterity", "敏捷", "stat name")
t("dex", "敏捷", "stat short_name")
t("Constitution", "体质", "stat name")
t("con", "体质", "stat short_name")

