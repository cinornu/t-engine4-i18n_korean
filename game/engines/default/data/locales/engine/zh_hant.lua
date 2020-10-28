locale "zh_hant"
-- COPY
forceFontPackage("chinese")
setFlag("break_text_all_character", true)

------------------------------------------------
section "always_merge"

t("3-head", "三頭蛇", nil)
t("3-headed hydra", "三頭蛇", nil)
t("Agrimley the hermit", "隱居者亞格雷姆利", nil)
t("Allied Kingdoms", "聯合王國", nil)
t("Angolwen", "安格利文", nil)
t("Assassin lair", "盜賊巢穴", nil)
t("Control Room", "控制室", nil)
t("Cosmic Fauna", "太空生物", nil)
t("Dreadfell", "恐懼王座", nil)
t("Enemies", "敵人", nil)
t("Experimentation Room", "實驗室", nil)
t("Exploratory Farportal", "異度傳送門", nil)
t("FINGER", "戒指", nil)
t("Fearscape", "惡魔空間", nil)
t("Hall of Reflection", "反射之間", nil)
t("Horrors", "恐魔", nil)
t("Iron Throne", "鋼鐵王座", nil)
t("Keepers of Reality", "現實守衛", nil)
t("MAINHAND", "主手", nil)
t("Marus of Elvala", "埃爾瓦拉的馬魯斯", nil)
t("OFFHAND", "副手", nil)
t("Orc Pride", "獸人部落", nil)
t("Portal Room", "傳送門房間", nil)
t("Rhalore", "羅蘭精靈", nil)
t("Sandworm Burrowers", "鑽地沙蟲", nil)
t("Shalore", "永恆精靈", nil)
t("Sher'Tul", "夏·圖爾", nil)
t("Slavers", "奴隸販子", nil)
t("Sorcerers", "法師", nil)
t("Stire of Derth", "德斯鎮的斯泰爾", nil)
t("Storage Room", "存儲間", nil)
t("Sunwall", "太陽堡壘", nil)
t("Temple of Creation", "造物者神廟", nil)
t("Thalore", "自然精靈", nil)
t("The Way", "維網", nil)
t([[Today is the %s %s of the %s year of the Age of Ascendancy of Maj'Eyal.
The time is %02d:%02d.]], [[今天是馬基·埃亞爾卓越紀%s年，%s %s 。
當前時間 %02d:%02d。]], nil, {3,2,1,4,5})
t("Undead", "不死族", nil)
t("Ungrol of Last Hope", "最後的希望的溫格洛", nil)
t("Vargh Republic", "瓦爾弗娜迦共和國", nil)
t("Victim", "受害者", nil)
t("Water lair", "水下墓穴", nil)
t("Zigur", "伊格", nil)
t("absolute", "絕對", nil)
t("armours", "護甲", nil)
t("bomb", "炸彈", nil)
t("bonestaff", "白骨法杖", nil)
t("cannister", "罐子", nil)
t("charged", "電能", nil)
t("combat", "戰鬥", nil)
t("daikara", "岱卡拉", nil)
t("default", "默認", nil)
t("demon", "惡魔", nil)
t("dragon", "龍", nil)
t("dream", "夢境", nil)
t("east", "東面", nil)
t("exit", "出口", nil)
t("harmonystaff", "和諧法杖", nil)
t("humanoid", "人形生物", nil)
t("humanoid/orc", "人形生物/獸人", nil)
t("husk", "屍傀", nil)
t("hydra", "多頭蛇", nil)
t("image", "鏡像", nil)
t("injured seer", "受傷的先知", nil)
t("kinetic", "動能", nil)
t("living", "生命", nil)
t("lone alchemist", "落單的鍊金術師", nil)
t("lost defiler", "迷路的墮落者", nil)
t("lost sun paladin", "迷路的太陽騎士", nil)
t("lost warrior", "迷路的戰士", nil)
t("magestaff", "元素法杖", nil)
t("magical", "魔法", nil)
t("mainhand", "主手", nil)
t("melee", "近戰", nil)
t("mental", "精神", nil)
t("mountain chain", "山脈", nil)
t("movement", "移動", nil)
t("north", "北面", nil)
t("northeast", "東北面", nil)
t("northwest", "西北面", nil)
t("offhand", "副手", nil)
t("portal", "傳送門", nil)
t("portal back", "返回傳送門", nil)
t("ranged", "遠程", nil)
t("repented thief", "懺悔的盜賊", nil)
t("rimebark", "霧凇", nil)
t("seed", "種子", nil)
t("south", "南面", nil)
t("southeast", "東南面", nil)
t("southwest", "西南面", nil)
t("spell", "法術", nil)
t("standard", "標準", nil)
t("standby", "乖乖站好", nil)
t("starstaff", "羣星法杖", nil)
t("steambot", "蒸汽機器人", nil)
t("stone golem", "岩石傀儡", nil)
t("summon", "召喚", nil)
t("summoned", "召喚物", nil)
t("tank", "肉盾", nil)
t("temporal explorer", "時空旅行者", nil)
t("temporal hound", "時空獵犬", nil)
t("thermal", "熱能", nil)
t("throwing", "投擲", nil)
t("turtle", "烏龜", nil)
t("unarmed", "徒手", nil)
t("undead", "亡靈", nil)
t("unliving", "非活物", nil)
t("unnatural", "非自然生物", nil)
t("unseen", "沒有看見", nil)
t("vilestaff", "邪惡法杖", nil)
t("volcanic mountains", "火山山脈", nil)
t("war hound", "戰爭獵犬", nil)
t("weapons", "武器", nil)
t("west", "西面", nil)
t("worried loremaster", "擔憂的賢者", nil)


------------------------------------------------
section "game/engines/default/data/keybinds/actions.lua"

t("Go to next/previous level", "到下一層/上一層地圖", "_t")
t("Levelup window", "打開升級窗口", "_t")
t("Use talents", "使用技能", "_t")
t("Show quests", "顯示任務", "_t")
t("Rest for a while", "休息一下", "_t")
t("Save game", "保存遊戲", "_t")
t("Quit game", "退出遊戲", "_t")
t("Tactical display on/off", "戰術視圖 開/關", "_t")
t("Look around", "查看四周", "_t")
t("Center the view on the player", "將屏幕中心定位到玩家", "_t")
t("Toggle minimap", "開關小地圖", "_t")
t("Show game calendar", "顯示遊戲內日期", "_t")
t("Show character sheet", "顯示角色面板", "_t")
t("Switch graphical modes", "切換圖形模式", "_t")
t("Accept action", "確認操作", "_t")
t("Exit menu", "退出目錄", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/chat.lua"

t("Talk to people", "與人交談", "_t")
t("Display chat log", "顯示聊天記錄", "_t")
t("Cycle chat channels", "切換聊天頻道", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/debug.lua"

t("Show Lua console", "顯示Lua控制檯", "_t")
t("Debug Mode", "調試模式", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/hotkeys.lua"

t("Hotkey 1", "快捷鍵 1", "_t")
t("Hotkey 2", "快捷鍵 2", "_t")
t("Hotkey 3", "快捷鍵 3", "_t")
t("Hotkey 4", "快捷鍵 4", "_t")
t("Hotkey 5", "快捷鍵 5", "_t")
t("Hotkey 6", "快捷鍵 6", "_t")
t("Hotkey 7", "快捷鍵 7", "_t")
t("Hotkey 8", "快捷鍵 8", "_t")
t("Hotkey 9", "快捷鍵 9", "_t")
t("Hotkey 10", "快捷鍵 10", "_t")
t("Hotkey 11", "快捷鍵 11", "_t")
t("Hotkey 12", "快捷鍵 12", "_t")
t("Secondary Hotkey 1", "第二快捷鍵 1", "_t")
t("Secondary Hotkey 2", "第二快捷鍵 2", "_t")
t("Secondary Hotkey 3", "第二快捷鍵 3", "_t")
t("Secondary Hotkey 4", "第二快捷鍵 4", "_t")
t("Secondary Hotkey 5", "第二快捷鍵 5", "_t")
t("Secondary Hotkey 6", "第二快捷鍵 6", "_t")
t("Secondary Hotkey 7", "第二快捷鍵 7", "_t")
t("Secondary Hotkey 8", "第二快捷鍵 8", "_t")
t("Secondary Hotkey 9", "第二快捷鍵 9", "_t")
t("Secondary Hotkey 10", "第二快捷鍵 10", "_t")
t("Secondary Hotkey 11", "第二快捷鍵 11", "_t")
t("Secondary Hotkey 12", "第二快捷鍵 12", "_t")
t("Third Hotkey 1", "第三快捷鍵 1", "_t")
t("Third Hotkey 2", "第三快捷鍵 2", "_t")
t("Third Hotkey 3", "第三快捷鍵 3", "_t")
t("Third Hotkey 4", "第三快捷鍵 4", "_t")
t("Third Hotkey 5", "第三快捷鍵 5", "_t")
t("Third Hotkey 6", "第三快捷鍵 6", "_t")
t("Third Hotkey 7", "第三快捷鍵 7", "_t")
t("Third Hotkey 8", "第三快捷鍵 8", "_t")
t("Third Hotkey 9", "第三快捷鍵 9", "_t")
t("Third Hotkey 10", "第三快捷鍵 10", "_t")
t("Third Hotkey 11", "第三快捷鍵 11", "_t")
t("Third Hotkey 12", "第三快捷鍵 12", "_t")
t("Fourth Hotkey 1", "第四快捷鍵 1", "_t")
t("Fourth Hotkey 2", "第四快捷鍵 2", "_t")
t("Fourth Hotkey 3", "第四快捷鍵 3", "_t")
t("Fourth Hotkey 4", "第四快捷鍵 4", "_t")
t("Fourth Hotkey 5", "第四快捷鍵 5", "_t")
t("Fourth Hotkey 6", "第四快捷鍵 6", "_t")
t("Fourth Hotkey 7", "第四快捷鍵 7", "_t")
t("Fourth Hotkey 8", "第四快捷鍵 8", "_t")
t("Fourth Hotkey 9", "第四快捷鍵 9", "_t")
t("Fourth Hotkey 10", "第四快捷鍵 10", "_t")
t("Fourth Hotkey 11", "第四快捷鍵 11", "_t")
t("Fourth Hotkey 12", "第四快捷鍵 12", "_t")
t("Fifth Hotkey 1", "第五快捷鍵 1", "_t")
t("Fifth Hotkey 2", "第五快捷鍵 2", "_t")
t("Fifth Hotkey 3", "第五快捷鍵 3", "_t")
t("Fifth Hotkey 4", "第五快捷鍵 4", "_t")
t("Fifth Hotkey 5", "第五快捷鍵 5", "_t")
t("Fifth Hotkey 6", "第五快捷鍵 6", "_t")
t("Fifth Hotkey 7", "第五快捷鍵 7", "_t")
t("Fifth Hotkey 8", "第五快捷鍵 8", "_t")
t("Fifth Hotkey 9", "第五快捷鍵 9", "_t")
t("Fifth Hotkey 10", "第五快捷鍵 10", "_t")
t("Fifth Hotkey 11", "第五快捷鍵 11", "_t")
t("Fifth Hotkey 12", "第五快捷鍵 12", "_t")
t("Six Hotkey 1", "第六快捷鍵 1", "_t")
t("Six Hotkey 2", "第六快捷鍵 2", "_t")
t("Six Hotkey 3", "第六快捷鍵 3", "_t")
t("Six Hotkey 4", "第六快捷鍵 4", "_t")
t("Six Hotkey 5", "第六快捷鍵 5", "_t")
t("Six Hotkey 6", "第六快捷鍵 6", "_t")
t("Six Hotkey 7", "第六快捷鍵 7", "_t")
t("Six Hotkey 8", "第六快捷鍵 8", "_t")
t("Six Hotkey 9", "第六快捷鍵 9", "_t")
t("Six Hotkey 10", "第六快捷鍵 10", "_t")
t("Six Hotkey 11", "第六快捷鍵 11", "_t")
t("Six Hotkey 12", "第六快捷鍵 12", "_t")
t("Seven Hotkey 1", "第七快捷鍵 1", "_t")
t("Seven Hotkey 2", "第七快捷鍵 2", "_t")
t("Seven Hotkey 3", "第七快捷鍵 3", "_t")
t("Seven Hotkey 4", "第七快捷鍵 4", "_t")
t("Seven Hotkey 5", "第七快捷鍵 5", "_t")
t("Seven Hotkey 6", "第七快捷鍵 6", "_t")
t("Seven Hotkey 7", "第七快捷鍵 7", "_t")
t("Seven Hotkey 8", "第七快捷鍵 8", "_t")
t("Seven Hotkey 9", "第七快捷鍵 9", "_t")
t("Seven Hotkey 10", "第七快捷鍵 10", "_t")
t("Seven Hotkey 11", "第七快捷鍵 11", "_t")
t("Seven Hotkey 12", "第七快捷鍵 12", "_t")
t("Previous Hotkey Page", "上一頁快捷鍵", "_t")
t("Next Hotkey Page", "下一頁快捷鍵", "_t")
t("Quick switch to Hotkey Page 2", "快速切換到快捷鍵第2頁", "_t")
t("Quick switch to Hotkey Page 3", "快速切換到快捷鍵第3頁", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/interface.lua"

t("Toggle list of seen creatures", "切換至視野內生物列表", "_t")
t("Show message log", "顯示消息記錄", "_t")
t("Take a screenshot", "屏幕截圖", "_t")
t("Show map", "顯示地圖", "_t")
t("Scroll map mode", "地圖滾動模式", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/inventory.lua"

t("Show inventory", "顯示物品欄", "_t")
t("Show equipment", "顯示裝備", "_t")
t("Pickup items", "拾取物品", "_t")
t("Drop items", "丟棄物品", "_t")
t("Wield/wear items", "裝備/穿戴 物品", "_t")
t("Takeoff items", "脫下物品", "_t")
t("Use items", "使用物品", "_t")
t("Quick switch weapons set", "快速切換武器", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/move.lua"

t("Move left", "向左移動", "_t")
t("Move right", "向右移動", "_t")
t("Move up", "向上移動", "_t")
t("Move down", "向下移動", "_t")
t("Move diagonally left and up", "向左上方移動", "_t")
t("Move diagonally right and up", "向右上方移動", "_t")
t("Move diagonally left and down", "向左下方移動", "_t")
t("Move diagonally right and down", "向右下方移動", "_t")
t("Stay for a turn", "原地待命一回合", "_t")
t("Run", "奔跑", "_t")
t("Run left", "向左奔跑", "_t")
t("Run right", "向右奔跑", "_t")
t("Run up", "向上奔跑", "_t")
t("Run down", "向下奔跑", "_t")
t("Run diagonally left and up", "向左上方奔跑", "_t")
t("Run diagonally right and up", "向右上方奔跑", "_t")
t("Run diagonally left and down", "向左下方奔跑", "_t")
t("Run diagonally right and down", "向右下方奔跑", "_t")
t("Auto-explore", "自動探索", "_t")
t("Move left (WASD directions)", "向左移動 (WASD 方向鍵)", "_t")
t("Move right (WASD directions)", "向右移動 (WASD 方向鍵)", "_t")
t("Move up (WASD directions)", "向上移動 (WASD 方向鍵)", "_t")
t("movement", "移動", "_t")
t("Move down (WASD directions)", "向下移動 (WASD 方向鍵)", "_t")


------------------------------------------------
section "game/engines/default/data/keybinds/mtxn.lua"

t("List purchasable", "列出可購買物品", "_t")
t("Use purchased", "使用已購買物品", "_t")


------------------------------------------------
section "game/engines/default/engine/ActorsSeenDisplay.lua"

t("%s (%d)#WHITE#; distance [%s]", "%s (%d)#WHITE#; 距離 [%s]", "tformat")


------------------------------------------------
section "game/engines/default/engine/Birther.lua"

t("Enter your character's name", "輸入角色名稱", "_t")
t("Name", "名稱", "_t")
t("Character Creation: %s", "創建角色%s", "tformat")
t([[Keyboard: #00FF00#up key/down key#FFFFFF# to select an option; #00FF00#Enter#FFFFFF# to accept; #00FF00#Backspace#FFFFFF# to go back.
Mouse: #00FF00#Left click#FFFFFF# to accept; #00FF00#right click#FFFFFF# to go back.
]], [[鍵盤：#00FF00#上/下鍵#FFFFFF#選擇選項，#00FF00#回車#FFFFFF#鍵確定;#00FF00#退格#FFFFFF#鍵返回。
鼠標：#00FF00#左鍵#FFFFFF#接受，#00FF00#右鍵#FFFFFF#返回。]], "_t")
t("Random", "隨機", "_t")
t("Do you want to recreate the same character?", "你想要以同一角色重新生成嗎？", "_t")
t("Quick Birth", "快速角色生成", "_t")
t("New character", "新角色", "_t")
t("Recreate", "重新生成角色？", "_t")
t("Randomly selected %s.", "隨機選擇%s。", "log")


------------------------------------------------
section "game/engines/default/engine/DebugConsole.lua"

t("Lua Console", "Lua 控制檯", "_t")


------------------------------------------------
section "game/engines/default/engine/Dialog.lua"

t("Yes", "是", "_t")
t("No", "否", "_t")


------------------------------------------------
section "game/engines/default/engine/Game.lua"

t([[Screenshot should appear in your Steam client's #LIGHT_GREEN#Screenshots Library#LAST#.
Also available on disk: %s]], [[屏幕截圖將會保存在你Steam客戶端的#LIGHT_GREEN#截圖庫#LAST#中。
也保存在硬盤上：%s]], "tformat")
t("File: %s", "文件：%s", "tformat")
t("Screenshot taken!", "屏幕截圖已保存", "_t")


------------------------------------------------
section "game/engines/default/engine/HotkeysDisplay.lua"

t("Missing!", "不見了！", "_t")


------------------------------------------------
section "game/engines/default/engine/HotkeysIconsDisplay.lua"

t("Unknown!", "未知!", "_t")
t("Missing!", "不見了！", "_t")


------------------------------------------------
section "game/engines/default/engine/I18N.lua"

t("Testing arg one %d and two %d", "測試參數1 %d和參數2 %d", "tformat")


------------------------------------------------
section "game/engines/default/engine/Key.lua"

t("#LIGHT_RED#Keyboard input temporarily disabled.", "#LIGHT_RED#暫時禁用鍵盤輸入。", "log")


------------------------------------------------
section "game/engines/default/engine/LogDisplay.lua"

t("Message Log", "消息日誌", "_t")


------------------------------------------------
section "game/engines/default/engine/MicroTxn.lua"

t("Test", "測試", "_t")


------------------------------------------------
section "game/engines/default/engine/Module.lua"

t("#{italic}##PINK#Addons developers can still test their addons by enabling developer mode.#{normal}#", "#{italic}##PINK#插件開發者可以通過開啓調試模式繼續測試他們的插件。#{normal}#", "_t")
t("Beta Addons Disabled", "Beta版禁用插件", "_t")
t([[This beta version is meant to be tested without addons, as such the following ones are currently disabled:
#GREY#]], [[本Beta版本設計上用於純原版測試環境，因此，以下插件被自動禁用:
#GREY#]], "_t")
t("#LIGHT_RED#Online profile disabled(switching to offline profile) due to %s.", "#LIGHT_RED#由於 %s ，在線存檔無法運行（切換至離線存檔）", "log")


------------------------------------------------
section "game/engines/default/engine/Mouse.lua"

t("#LIGHT_RED#Mouse input temporarily disabled.", "#LIGHT_RED#暫時禁用鼠標輸入。", "log")


------------------------------------------------
section "game/engines/default/engine/Object.lua"

t("Requires:", "裝備需求：", "_t")
t("%s (level %d)", "%s (等級 %d)", "tformat")
t("Level %d", "等級 %d", "tformat")
t("Talent %s (level %d)", "技能 %s (等級 %d)", "tformat")
t("Talent %s", "技能 %s", "tformat")


------------------------------------------------
section "game/engines/default/engine/PlayerProfile.lua"

t("#YELLOW#Connection to online server established.", "#YELLOW#連接至在線服務器。", "log")
t("#YELLOW#Connection to online server lost, trying to reconnect.", "#YELLOW#與在線服務器的連接丟失，嘗試重新連接。", "log")
t("bad game version", "遊戲版本錯誤", "_t")
t("nothing to update", "無需更新", "_t")
t("bad game addon version", "遊戲插件版本錯誤", "_t")
t("no online profile active", "未開啓在線存檔", "_t")
t("cheat mode active", "已開啓作弊模式", "_t")
t("savefile tainted", "存檔文件被修改", "_t")
t("unknown error", "未知錯誤", "_t")
t("Character is being registered on https://te4.org/", "正在註冊角色到 https://te4.org/", "_t")
t("Registering character", "正在註冊角色", "_t")
t("Retrieving data from the server", "正在從服務端拉取數據…", "_t")
t("Retrieving...", "正在拉取…", "_t")


------------------------------------------------
section "game/engines/default/engine/Quest.lua"

t("active", "正在進行", "_t")
t("completed", "完成", "_t")
t("done", "結束", "_t")
t("failed", "失敗", "_t")


------------------------------------------------
section "game/engines/default/engine/Savefile.lua"

t("Please wait while saving the world...", "正在保存世界，請稍候…", "_t")
t("Saving world", "正在保存世界", "_t")
t("Please wait while saving the game...", "正在保存遊戲，請稍候…", "_t")
t("Saving game", "正在保存遊戲", "_t")
t("Please wait while saving the zone...", "正在保存地圖，請稍候…", "_t")
t("Saving zone", "正在保存地圖", "_t")
t("Please wait while saving the level...", "正在保存樓層，請稍候…", "_t")
t("Saving level", "正在保存樓層", "_t")
t("Please wait while saving the entity...", "正在保存實體，請稍候…", "_t")
t("Saving entity", "正在保存實體", "_t")
t("Loading world", "正在讀取世界", "_t")
t("Please wait while loading the world...", "正在讀取世界，請稍候…", "_t")
t("Loading game", "正在讀取遊戲", "_t")
t("Please wait while loading the game...", "正在讀取遊戲，請稍候…", "_t")
t("Loading zone", "正在讀取地圖", "_t")
t("Please wait while loading the zone...", "正在讀取地圖，請稍候…", "_t")
t("Loading level", "正在讀取樓層", "_t")
t("Please wait while loading the level...", "正在讀取樓層，請稍候…", "_t")
t("Loading entity", "正在讀取實體", "_t")
t("Please wait while loading the entity...", "正在讀取實體，請稍候…", "_t")


------------------------------------------------
section "game/engines/default/engine/SavefilePipe.lua"

t("Saving done.", "保存完畢。", "log")
t("Please wait while saving...", "正在保存，請稍候…", "_t")
t("Saving...", "正在保存…", "_t")


------------------------------------------------
section "game/engines/default/engine/Store.lua"

t("Store: %s", "商店：%s", "tformat")
t("Buy %d %s", "購買%d個%s", "tformat")
t("Buy", "購買", "_t")
t("Sell %d %s", "出售%d個%s", "tformat")
t("Cancel", "取消", "_t")
t("Sell", "出售", "_t")


------------------------------------------------
section "game/engines/default/engine/Trap.lua"

t("%s fails to disarm a trap (%s).", "%s 拆除陷阱（ %s ）失敗。", "logSeen")
t("%s disarms a trap (%s).", "%s 拆除了陷阱（ %s ）。", "logSeen")
t("%s triggers a trap (%s)!", "%s 觸發了陷阱（ %s ）！", "logSeen")


------------------------------------------------
section "game/engines/default/engine/UserChat.lua"

t("Ignoring all new messages from %s.", "拒收所有來自%s的消息。", "log")
t([[#{bold}#Thank you#{normal}# for you donation, your support means a lot for the continued survival of this game.

Your current donation total is #LIGHT_GREEN#%0.2f euro#WHITE# which equals to #ROYAL_BLUE#%d voratun coins#WHITE# to use on te4.org.
Your Item Vault has #TEAL#%d slots#WHITE#.

Again, thank you, and enjoy Eyal!

#{italic}#Your malevolent local god of darkness, #GOLD#DarkGod#{normal}#]], [[#{bold}#感謝#{normal}# 你的捐贈，你的捐助將會讓這個遊戲變得更好。

你的捐款總額爲#LIGHT_GREEN#%0.2f 歐元#WHITE# 相當於 #ROYAL_BLUE#%d 個沃瑞鉭幣#WHITE#，可以在 te4.org 上消費。
你的共享倉庫有 #TEAL#%d 個槽位#WHITE#.

再次感謝你，祝你在埃亞爾玩的開心！

#{italic}#你的邪惡的黑暗之神， #GOLD#DarkGod#{normal}#]], "tformat")
t("Thank you!", "謝謝你！", "_t")
t("#{italic}#Joined channel#{normal}#", "#{italic}#已加入頻道#{normal}#", "_t")
t("#{italic}#Left channel#{normal}#", "#{italic}#已退出頻道#{normal}#", "_t")
t("#{italic}##FIREBRICK#has joined the channel#{normal}#", "#{italic}##FIREBRICK#已加入頻道#{normal}#", "_t")
t("#{italic}##FIREBRICK#has left the channel#{normal}#", "#{italic}##FIREBRICK#已退出頻道#{normal}#", "_t")
t("#CRIMSON#You are not subscribed to any channel, you can change that in the game options.#LAST#", "#CRIMSON#你沒有關注任何頻道，你可以在遊戲設置中調節這一選項。#LAST#", "log")
t("Error", "錯誤", "_t")
t("The server does not know about this player.", "服務器裏沒有這個玩家", "_t")
t("Requesting user info...", "正在請求用戶信息...", "_t")
t("Requesting...", "正在請求...", "_t")


------------------------------------------------
section "game/engines/default/engine/Zone.lua"

t("Loading level", "正在讀取樓層", "_t")
t("Please wait while loading the level... ", "正在讀取樓層，請稍候……", "_t")
t("Generating level", "正在生成樓層", "_t")
t("Please wait while generating the level... ", "正在生成樓層，請稍候……", "_t")


------------------------------------------------
section "game/engines/default/engine/ai/talented.lua"



------------------------------------------------
section "game/engines/default/engine/dialogs/AudioOptions.lua"

t("Audio Options", "音頻設置", "_t")
t("Enable audio", "啓用聲音", "_t")
t("Music: ", "音樂：", "_t")
t("Effects: ", "音效：", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatChannels.lua"

t("Chat channels", "聊天頻道", "_t")
t("Global", "全局", "_t")
t(" [spoilers]", " [詳情]", "_t")
t("Select which channels to listen to. You can join new channels by typing '/join <channelname>' in the talkbox and leave channels by typing '/part <channelname>'", "選擇你參與的聊天頻道。你可以在聊天框輸入指令 '/join <頻道名>' 來加入頻道，並通過輸入指令 '/part <頻道名>' 來離開頻道。", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatFilter.lua"

t("Chat filters", "聊天過濾器", "_t")
t("Public chat", "公開聊天", "_t")
t("Private whispers", "私人聊天", "_t")
t("Join/part messages", "加入/退出頻道信息", "_t")
t("First time achievements (recommended to keep them on)", "第一次取得成就(建議開啓)", "_t")
t("Important achievements (recommended to keep them on)", "重要成就(建議開啓)", "_t")
t("Other achievements", "其他成就", "_t")
t("Select which types of chat events to see or not.", "選擇你想要觀看或屏蔽的聊天內容。", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ChatIgnores.lua"

t("Chat ignore list", "聊天屏蔽列表", "_t")
t("Really stop ignoring: %s", "真的要停止屏蔽 %s 嗎", "tformat")
t("Stop ignoring", "停止屏蔽", "_t")
t("Click a user to stop ignoring her/his messages.", "點擊一個用戶以停止屏蔽他/她的消息", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/DisplayResolution.lua"

t("Switch Resolution", "切換分辨率", "_t")
t("Fullscreen", "全屏", "_t")
t("Borderless", "無邊框", "_t")
t("Windowed", "窗口模式", "_t")
t("Engine Restart Required", "需要重啓遊戲引擎", "_t")
t(" (progress will be saved)", " (遊戲進度會被保存)", "_t")
t("Continue? %s", "繼續嗎? %s", "tformat")
t("Reset Window Position?", "重設窗口位置？", "_t")
t("Simply restart or restart+reset window position?", "你要僅重啓，還是重啓並重設窗口位置？", "_t")
t("Restart", "重啓", "_t")
t("Restart with reset", "重啓並重設", "_t")
t("No", "否", "_t")
t("Yes", "是", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/Downloader.lua"

t("Download: %s", "正在下載：%s", "tformat")
t("Cancel", "取消", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GameMenu.lua"

t("Game Menu", "遊戲目錄", "_t")
t("Resume", "暫停遊戲", "_t")
t("Language", "語言", "_t")
t("Key Bindings", "按鍵綁定", "_t")
t("Video Options", "圖像設置", "_t")
t("Display Resolution", "顯示分辨率", "_t")
t("Show Achievements", "顯示成就", "_t")
t("Audio Options", "音頻設置", "_t")
t("#GREY#Developer Mode", "#GREY#開發者模式", "_t")
t("Disable developer mode?", "關閉開發者模式？", "_t")
t("Developer Mode", "開發者模式", "_t")
t([[Enable developer mode?
Developer Mode is a special game mode used to debug and create addons.
Using it will #CRIMSON#invalidate#LAST# any savefiles loaded.
When activated you will have access to special commands:
- CTRL+L: bring up a lua console that lets you explore and alter all the game objects, enter arbitrary lua commands, ...
- CTRL+A: bring up a menu to easily do many tasks (create NPCs, teleport to zones, ...)
- CTRL+left click: teleport to the clicked location
]], [[啓動開發者模式？
開發者模式是一種特殊的遊戲模式，用於調試遊戲和創建遊戲插件。
啓用開發者模式時，所有讀取的存檔都會成爲#CRIMSON#作弊狀態#LAST#。
在開發者模式下，你可以使用以下幾種特殊指令：
- CTRL+L：啓動Lua控制檯，可以讓你探索和修改遊戲物件，並執行任意Lua腳本……
- CTRL+A：啓動調試目錄，可以讓你方便地進行各種操作(創建NPC，傳送到地圖，等等…)
- CTRL+鼠標左鍵：傳送到點擊的位置。
]], "_t")
t("No", "否", "_t")
t("Yes", "是", "_t")
t("Save Game", "保存遊戲", "_t")
t("Main Menu", "主菜單", "_t")
t("Exit Game", "退出遊戲", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantity.lua"

t("Quantity", "數量", "_t")
t("Accept", "接受", "_t")
t("Cancel", "取消", "_t")
t("Enter a quantity.", "輸入數量", "_t")
t("Error", "錯誤", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetQuantitySlider.lua"

t("Quantity", "數量", "_t")
t("Accept", "接受", "_t")
t("Cancel", "取消", "_t")
t("Enter a quantity.", "輸入數量", "_t")
t("Error", "錯誤", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/GetText.lua"

t("Accept", "接受", "_t")
t("Cancel", "取消", "_t")
t("Error", "錯誤", "_t")
t("Must be between %i and %i characters.", "必須介於 %i 和 %i 個字符之間", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/KeyBinder.lua"

t("Key bindings", "鍵位綁定", "_t")
t("      Press a key (escape to cancel, backspace to remove) for: %s", "      請按鈕 (ESC鍵取消，退格鍵刪除) 以綁定 %s 的鍵位", "tformat")
t("Bind alternate key", "綁定替代鍵位", "_t")
t("Bind key", "綁定鍵位", "_t")
t("Make gesture (using right mouse button) or type it (or escape) for: %s", "請輸入鼠標手勢 (使用鼠標右鍵) 或者按鍵 (或按ESC取消) 以綁定 %s 的鍵位", "tformat")
t("Gesture", "鼠標手勢", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/LanguageSelect.lua"

t("Language Selection", "語言選擇", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowAchievements.lua"

t("Achievements(%s/%s)", "成就(%s/%s)", "tformat")
t("Yours only", "只列出當前角色的", "_t")
t("All achieved", "所有已經獲得的", "_t")
t("Everything", "所有", "_t")
t("Achievement", "成就", "_t")
t("Category", "分類", "_t")
t("When", "何時", "_t")
t("Who", "何人", "_t")
t([[#GOLD#Also achieved by your current character#LAST#
]], [[#GOLD#你的當前角色也取得了這一成就#LAST#
]], "_t")
t([[#GOLD#Achieved on:#LAST# %s
#GOLD#Achieved by:#LAST# %s
%s
#GOLD#Description:#LAST# %s]], [[#GOLD#成就達成時間:#LAST# %s
#GOLD#成就獲得者:#LAST# %s
%s
#GOLD#介紹:#LAST# %s]], "tformat")
t("Progress: ", "進度: ", "_t")
t("-- Unknown --", "-- 未知 --", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipInven.lua"

t("Inventory", "物品欄", "_t")
t("Equipment", "裝備", "_t")
t("Category", "分類", "_t")
t("Enc.", "負重", "_t")
t("%s assigned to hotkey %s", "%s 已綁定到鍵位 %s", "tformat")
t("Hotkey %s assigned", "鍵位 %s 已綁定", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowEquipment.lua"

t("Equipment", "裝備", "_t")
t("Category", "分類", "_t")
t("Enc.", "負重", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowErrorStack.lua"

t("Lua Error", "Lua腳本錯誤", "_t")
t("If you already reported that error, you do not have to do it again (unless you feel the situation is different).", "如果你已經彙報過了這個錯誤，你不需要再次進行彙報。(除非你認爲這一情況和之前有所不同)", "_t")
t("You #LIGHT_GREEN#already reported#WHITE# that error, you do not have to do it again (unless you feel the situation is different).", "你 #LIGHT_GREEN#已經彙報過了#WHITE# 這個錯誤，你不需要再次進行彙報。(除非你認爲這一情況和之前有所不同)", "_t")
t("You have already got this error but #LIGHT_RED#never reported#WHITE# it, please do.", "你以前遇到過這個錯誤，但你#LIGHT_RED#還沒有彙報過#WHITE#這個錯誤，請彙報這個錯誤。", "_t")
t("You have #LIGHT_RED#never seen#WHITE# that error, please report it.", "你之前#LIGHT_RED#從未遇到過#WHITE#這個錯誤，請彙報這個錯誤。", "_t")
t([[#{bold}#Oh my! It seems there was an error!
The game might still work but this is suspect, please type in your current situation and click on "Send" to send an error report to the game creator.
If you are not currently connected to the internet, please report this bug when you can on the forums at http://forums.te4.org/

]], [[#{bold}#哦不！遊戲出錯了！
這個遊戲也許暫時還能繼續運行，但是沒法保證之後會出現什麼問題。請你輸入你目前的狀況，點擊“發送”按鈕，向遊戲的作者發送一份錯誤報告。
如果你現在無法連接到互聯網，請你在可以聯網的時候在 http://forums.te4.org/ 論壇上彙報這個錯誤。

]], "_t")
t("What happened?: ", "發生了什麼？：", "_t")
t("Send", "發送", "_t")
t("Close", "關閉", "_t")
t("Close All", "全部關閉", "_t")
t("File location copied to clipboard.", "文件位置已複製到剪貼板。", "log")
t("Log saved to file (click to copy to clipboard):#LIGHT_BLUE#%s", "遊戲日誌已保存到文件(點擊複製到剪貼板):#LIGHT_BLUE#%s", "tformat")
t("#YELLOW#Error report sent, thank you.", "#YELLOW#錯誤報告已發送，謝謝！", "log")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowInventory.lua"

t("Inventory", "物品欄", "_t")
t("Category", "分類", "_t")
t("Enc.", "負重", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowPickupFloor.lua"

t("Pickup", "拾取", "_t")
t("(*) Take all", "(*) 全部拾取", "_t")
t("Item", "物品", "_t")
t("Category", "分類", "_t")
t("Enc.", "負重", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowQuests.lua"

t("Quest Log for %s", "%s 的任務日誌", "tformat")
t("Quest", "任務", "_t")
t("Status", "狀態", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowStore.lua"

t("Inventory", "物品欄", "_t")
t("Store", "商店", "_t")
t("Category", "分類", "_t")
t("Price", "價格", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ShowText.lua"

t("Text", "文本", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/SteamOptions.lua"

t("Steam Options", "Steam 設置", "_t")
t([[Enable Steam Cloud saves.
Your saves will be put on steam cloud and always be available everywhere.
Disable if you have bandwidth limitations.#WHITE#]], [[啓動Steam雲存檔。
你的存檔會被保存在Steam 雲中，可以各處使用。
如果你的網絡帶寬有限，請禁用這一設置。#WHITE#]], "_t")
t("#GOLD##{bold}#Cloud Saves#WHITE##{normal}#", "#GOLD##{bold}#雲存檔#WHITE##{normal}#", "_t")
t("disabled", "已禁用", "_t")
t("enabled", "已啓用", "_t")
t([[Purge all Steam Cloud saves.
This will remove all saves from the cloud cloud (but not your local copy). Only use if you somehow encounter storage problems on it (which should not happen, the game automatically manages it for you).#WHITE#]], [[刪除所有Steam雲存檔。
這會在Steam雲中刪除所有的雲存檔，但不會刪除你的本地存檔。只有在你遇到存儲問題的時候才使用這一功能。(一般情況下這不會發生，遊戲會自動管理雲存檔)
#WHITE#]], "_t")
t("#GOLD##{bold}#Purge Cloud Saves#WHITE##{normal}#", "#GOLD##{bold}#清除雲存檔#WHITE##{normal}#", "_t")
t("Confirm purge?", "確認刪除？", "_t")
t("All data purged from the cloud.", "所有云存檔數據已被刪除。", "_t")
t("Steam Cloud Purge", "清除Steam雲存檔", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/Talkbox.lua"

t("Say: ", "說：", "_t")
t("Accept", "接受", "_t")
t("Cancel", "取消", "_t")
t("Target: ", "目標：", "_t")
t("Channel: %s", "頻道：%s", "tformat")
t("Friend: %s", "好友：%s", "tformat")
t("User: %s", "用戶：%s", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/UseTalents.lua"

t("Use Talents: ", "使用技能：", "tformat")
t([[You can bind a talent to a hotkey be pressing the corresponding hotkey while selecting a talent.
Check out the keybinding screen in the game menu to bind hotkeys to a key (default is 1-0 plus control or shift).
]], [[你可以把技能綁定到一個快捷鍵。方法是選擇一個技能，然後按下對應的快捷鍵。
請確認遊戲菜單中的快捷鍵綁定界面，將快捷鍵綁定到鍵盤按鍵。(默認綁定位置是1-0+Ctrl/Shift鍵)
]], "_t")
t("Talent", "技能", "_t")
t("Status", "狀態", "_t")
t("%s assigned to hotkey %s", "%s 已綁定到鍵位 %s", "tformat")
t("Hotkey %s assigned", "鍵位 %s 已綁定", "tformat")


------------------------------------------------
section "game/engines/default/engine/dialogs/UserInfo.lua"

t("User: %s", "用戶：%s", "tformat")
t("Currently playing: ", "正在玩: ", "_t")
t("unknown", "未知", "_t")
t("Game: ", "遊戲：", "_t")
t("Game has been validated by the server", "遊戲被服務器認證", "_t")
t("Game is not validated by the server", "遊戲不被服務器認證", "_t")
t("Validation: ", "認證狀態: ", "_t")
t("Go to online profile", "前往在線用戶檔案", "_t")
t("Go to online charsheet", "前往在線角色表", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/VideoOptions.lua"

t("Video Options", "圖像設置", "_t")
t("Display resolution.", "顯示分辨率。", "_t")
t("#GOLD##{bold}#Resolution#WHITE##{normal}#", "#GOLD##{bold}#分辨率#WHITE##{normal}#", "_t")
t("If you have a very high DPI screen you may want to raise this value. Requires a restart to take effect.#WHITE#", "如果你有一個高分辨率的屏幕，你可以調高該數值。重啓後生效。#WHITE#", "_t")
t("#GOLD##{bold}#Screen Zoom#WHITE##{normal}#", "#GOLD##{bold}#屏幕縮放#WHITE##{normal}#", "_t")
t("Enter Zoom %", "輸入縮放比例 %", "_t")
t("From 50 to 400", "從 50 到 400", "_t")
t([[Request this display refresh rate.
Set it lower to reduce CPU load, higher to increase interface responsiveness.#WHITE#]], [[設置遊戲的顯示幀率(FPS)。
降低幀率可以減輕CPU佔用，提高幀率可以提升顯示效果。#WHITE#]], "_t")
t("#GOLD##{bold}#Requested FPS#WHITE##{normal}#", "#GOLD##{bold}#FPS設定#WHITE##{normal}#", "_t")
t("From 5 to 60", "從 5 到 60", "_t")
t([[Controls the particle effects density.
This option allows to change the density of the many particle effects in the game.
If the game is slow when displaying spell effects try to lower this setting.#WHITE#]], [[設定粒子效果的密度。
這一選項會可以改變遊戲內的粒子效果密度。
如果你在施法時發現遊戲速度進行較慢，請嘗試降低這個設置。#WHITE#]], "_t")
t("#GOLD##{bold}#Particle effects density#WHITE##{normal}#", "#GOLD##{bold}#粒子效果密度#WHITE##{normal}#", "_t")
t("Enter density", "輸入密度", "_t")
t("From 0 to 100", "從 0 到 100", "_t")
t([[Activates antialiased texts.
Texts will look nicer but it can be slower on some computers.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[啓用文字抗鋸齒。
激活該效果會使文字看上去更美觀，但在有些電腦運行速度會變慢。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#Antialiased texts#WHITE##{normal}#", "#GOLD##{bold}#文字抗鋸齒#WHITE##{normal}#", "_t")
t([[Apply a global scaling to all fonts.
Applies after restarting the game]], "全局字體大小調整，重啓遊戲後生效", "_t")
t("#GOLD##{bold}#Font Scale#WHITE##{normal}#", "#GOLD##{bold}#字體縮放#WHITE##{normal}#", "_t")
t("Font Scale %", "字體縮放比率 %", "_t")
t([[Activates framebuffers.
This option allows for some special graphical effects.
If you encounter weird graphical glitches try to disable it.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[激活幀緩存。
這個選項可以激活一些特殊的視頻效果。
如果畫面碰到異常請嘗試關閉這個效果。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#Framebuffers#WHITE##{normal}#", "#GOLD##{bold}#幀緩存#WHITE##{normal}#", "_t")
t([[Activates OpenGL Shaders.
This option allows for some special graphical effects.
If you encounter weird graphical glitches try to disable it.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[啓用 OpenGL 着色器。
這個選項可以激活一些特殊的視頻效果。
如果出現奇怪的畫面異常，請嘗試關閉這個效果。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 着色器#WHITE##{normal}#", "_t")
t([[Activates advanced shaders.
This option allows for advanced effects (like water surfaces, ...). Disabling it can improve performance.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[開啓高級着色器效果。
這個選項可以激活一些高級的視頻效果(例如水面效果……)。關閉它可以提升運行速度。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Advanced#WHITE##{normal}#", "#GOLD##{bold}#OpenGL着色器：高級#WHITE##{normal}#", "_t")
t([[Activates distorting shaders.
This option allows for distortion effects (like spell effects doing a visual distortion, ...). Disabling it can improve performance.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[開啓扭曲着色器效果，
這個選項可以激活一些扭曲視頻特效(例如會造成視覺扭曲的法術)
關閉它可以提升運行速度。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Distortions#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 着色器：扭曲#WHITE##{normal}#", "_t")
t([[Activates volumetric shaders.
This option allows for volumetricion effects (like deep starfields). Enabling it will severely reduce performance when shaders are displayed.

#LIGHT_RED#You must restart the game for it to take effect.#WHITE#]], [[開啓體積着色器效果。
這個選項可以激活一些特殊的視頻效果(例如星空特效)。開啓它會顯著降低運行速度。

#LIGHT_RED#你必須重啓遊戲才能看到效果。#WHITE#]], "_t")
t("#GOLD##{bold}#OpenGL Shaders: Volumetric#WHITE##{normal}#", "#GOLD##{bold}#OpenGL 着色器：體積着色器#WHITE##{normal}#", "_t")
t([[Use the custom cursor.
Disabling it will use your normal operating system cursor.#WHITE#]], [[使用自定義鼠標貼圖。
關閉這個選項將使用系統默認鼠標。#WHITE#]], "_t")
t("#GOLD##{bold}#Mouse cursor#WHITE##{normal}#", "#GOLD##{bold}#鼠標貼圖#WHITE##{normal}#", "_t")
t([[Gamma correction setting.
Increase this to get a brighter display.#WHITE#]], [[亮度矯正設定。
提高數值會使畫面變亮。#WHITE#]], "_t")
t("#GOLD##{bold}#Gamma correction#WHITE##{normal}#", "#GOLD##{bold}#亮度矯正#WHITE##{normal}#", "_t")
t("From 50 to 300", "從 50 到 300", "_t")
t("Gamma correction", "亮度矯正", "_t")
t([[Enable/disable usage of tilesets.
In some rare cases on very slow machines with bad GPUs/drivers it can be detrimental.]], [[開啓/關閉圖塊使用。
在某些顯卡/顯卡驅動的很差且很慢的機器上，開啓這個選項偶爾可能帶來負面效果。]], "_t")
t("#GOLD##{bold}#Use tilesets#WHITE##{normal}#", "#GOLD##{bold}#圖塊使用#WHITE##{normal}#", "_t")
t("disabled", "已禁用", "_t")
t("enabled", "已啓用", "_t")
t([[Request a specific origin point for the game window.
This point corresponds to where the upper left corner of the window will be located.
Useful when dealing with multiple monitors and borderless windows.

The default origin is (0,0).

Note: This value will automatically revert after ten seconds if not confirmed by the user.#WHITE#]], [[設置遊戲窗口的原點。
這個點表示窗口中畫面的左上角。
這一選項用於在使用無邊框窗口或者多顯示器的場合。

默認原點： (0,0).

注意：如果用戶在十秒後不進行確認，這一數值將會自動重置#WHITE#]], "_t")
t("#GOLD##{bold}#Requested Window Position#WHITE##{normal}#", "#GOLD##{bold}#設置窗口位置#WHITE##{normal}#", "_t")
t("Enter the x-coordinate", "輸入X座標", "_t")
t("Window Origin: X-Coordinate", "窗口原點：X座標", "_t")
t("Enter the y-coordinate", "輸入Y座標", "_t")
t("Window Origin: Y-Coordinate", "窗口原點：Y座標", "_t")
t("Position changed.", "位置已修改。", "_t")
t("Save position?", "保存位置？", "_t")
t("Accept", "接受", "_t")
t("Revert", "撤銷", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/ViewHighScores.lua"

t("High Scores", "高分榜", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/MTXMain.lua"

t("%s #GOLD#Purchasables#LAST#", "%s #GOLD#可購買物品#LAST#", "tformat")
t("Online Store", "在線商城", "_t")
t([[Welcome!

I am #{italic}##ANTIQUE_WHITE#DarkGod#LAST##{normal}#, the creator of the game and before you go on your merry way I wish to take a few seconds of your time to explain why there are microtransactions in the game.

Before you run off in terror let me put it plainly: I am very #{bold}#firmly #CRIMSON#against#LAST# pay2win#{normal}# things so rest assured I will not add this kind of stuff.

So why put microtransactions? Tales of Maj'Eyal is a cheap/free game and has no subscription required to play. It is my baby and I love it; I plan to work on it for many years to come (as I do since 2009!) but for it to be viable I must ensure a steady stream of income as this is sadly the state of the world we live in.

As for what kind of purchases are/will be available:
- #GOLD#Cosmetics#LAST#: in addition to the existing racial cosmetics & item shimmers available in the game you can get new packs of purely cosmetic items & skins to look even more dapper!
- #GOLD#Pay2DIE#LAST#: Tired of your character? End it with style!
- #GOLD#Vault space#LAST#: For those that donated they can turn all those "useless" donations into even more online vault slots.
- #GOLD#Community events#LAST#: A few online events are automatically and randomly triggered by the server. With those options you can force one of them to trigger; bonus point they trigger for the whole server so everybody online benefits from them each time!

I hope I've convinced you of my non-evil intentions (ironic for a DarkGod I know ;)). I must say feel dirty doing microtransactions even as benign as those but I want to find all the ways I can to ensure the game's future.
Thanks, and have fun!]], [[歡迎!

我是遊戲的製造者 #{italic}##ANTIQUE_WHITE#DarkGod#LAST##{normal}#。在愉快的探險開始之前，我希望佔用短暫的時間向你解釋遊戲內購的存在意義。

請不要聽到“內購”就驚慌逃跑，聽完我的解釋再做選擇： 我本人 #{bold}# 堅決 #CRIMSON#反對#LAST# 氪金勝利 #{normal}# ，因此我保證絕不會做這種事情。

那麼，爲什麼要加入內購呢？ 馬基艾亞爾的傳說是一款便宜/免費的遊戲，也不需要會員訂閱。它就像我的孩子一樣；我非常愛它，並計劃爲之長久工作（從2009年開始我就一直這麼幹了！）。 但是，爲了生存，我仍然需要在現實世界中取得必要的收入。

目前，我提供了以下幾種內購項:
- #GOLD#時裝#LAST#：在目前遊戲內已有的種族、物品時裝外，你可以獲得更多時裝效果，讓你看起來更靚！
- #GOLD#氪金速死#LAST#：已經不想玩這個角色了嗎？用這個選項來迎接一個帥氣的終結吧！
- #GOLD#額外共享裝備格#LAST#：至少，捐贈者可以將所有無用的捐贈化爲“有用”的額外在線共享裝備格。
- #GOLD#社區事件#LAST#：服務器會自動觸發部分在線事件，而你可以強制讓服務器觸發特定事件。當然，當前在線的所有玩家都會收到該事件！

我希望這些能說服你，我並沒有什麼邪惡的想法（雖然我名爲DarkGod）。 我不得不說，內購這種事情讓我感覺很齷齪，即使上面這些選項都不影響遊戲內容，但爲了遊戲的未來，我必須想盡辦法。
感謝你看到這裏，去享受遊戲吧！]], "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/ShowPurchasable.lua"

t("#{italic}##UMBER#Bonus vault slots from this order: #ROYAL_BLUE#%d#{normal}#", "#{italic}##UMBER#這項購買提供的額外在線共享裝備格數： #ROYAL_BLUE#%d#{normal}#", "_t")
t([[For every purchase of #{italic}##GREY#%s#LAST##{normal}# you gain a permanent additional vault slot.
#GOLD##{italic}#Because why not!#{normal}#]], [[每次購買 #{italic}##GREY#%s#LAST##{normal}#，你都會獲得額外一個在線共享裝備格。
#GOLD##{italic}#爲什麼不呢！#{normal}#]], "_t")
t("#{italic}##UMBER#Voratun Coins available from your donations: #ROYAL_BLUE#%d#{normal}#", "#{italic}##UMBER#可用沃瑞鉭硬幣數：#ROYAL_BLUE#%d#{normal}#", "_t")
t([[For every donations you've ever made you have earned voratun coins. These can be spent purchasing expansions or options on the online store. This is the amount you have left, if your purchase total is below this number you'll instantly get your purchase validated, if not you'll need to donate some more first.
#GOLD##{italic}#Thanks for your support, every little bit helps the game survive for years on!#{normal}#]], [[每次捐贈，你都會獲得一定數額的沃瑞鉭硬幣，可以用於購買擴展Dlc或者在線商店的商品。這是你當前可用的硬幣，如果購買價格在這以下，你可以立刻獲得商品，否則你需要進行更多的捐贈。
#GOLD##{italic}#感謝你的支持，每一分錢都讓這遊戲更加持久!#{normal}#]], "_t")
t("%s #GOLD#Online Store#LAST#", "%s #GOLD#在線商店#LAST#", "tformat")
t("#YELLOW#-- connecting to server... --", "#YELLOW#-- 正在連接到服務器... --", "_t")
t("Name", "名稱", "_t")
t("Price", "價格", "_t")
t("Qty", "數量", "_t")
t("You need to be logged in before using the store. Please go back to the main menu and login.", "需要登錄遊戲賬號才能使用商店，請退回主菜單登錄。", "_t")
t("Steam users need to link their profiles to their steam account. This is very easy in just a few clicks. Once this is done, simply restart the game.", "Steam用戶需要將遊戲賬號和Steam賬號綁定。這非常簡單，只需要數次點擊，完成後重啓遊戲即可。", "_t")
t("Let's do it! (Opens in your browser)", "開始吧! (在瀏覽器中打開)", "_t")
t("The Online Store (and expansions) are only purchasable by players that bought the game. Plaese go have a look at the donation page for more explanations.", "在線商店(和擴展Dlc)只對購買過遊戲本體的玩家開放。詳情請查看捐贈頁面。", "_t")
t("%0.2f %s", "%0.2f%s", "tformat")
t("%d coins", "%d幣", "tformat")
t("#{bold}#TOTAL#{normal}#", "#{bold}#總量#{normal}#", "_t")
t("  (%d items in cart, %s)", "  (購物車中有%d件物品, %s)", "tformat")
t("Cart", "購物車", "_t")
t("Cart is empty!", "購物車是空的！", "_t")
t([[In-game browser is inoperant or disabled, impossible to auto-install shimmer pack.
Please go to https://te4.org/ to download it manually.]], [[無法啓動遊戲內瀏覽器，因此無法自動安裝時裝包。
請前往 https://te4.org/ 手動下載。]], "_t")
t("Shimmer pack installed!", "時裝包安裝成功!", "_t")
t([[Could not dynamically link addon to current character, maybe the installation weng wrong.
You can fix that by manually downloading the shimmer addon from https://te4.org/ and placing it in game/addons/ folder.]], [[無法自動將插件鏈接至當前角色，可能安裝失敗了。
你可以在 https://te4.org/ 手動下載時裝插件並放置於 game/addons/ 目錄下來解決這個問題。]], "_t")
t("Downloading cosmetic pack: #LIGHT_GREEN#%s", "時裝包下載中： #LIGHT_GREEN#%s", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: The pack should be downloading or even finished by now.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}# ：時裝包安裝剩餘時間：", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: You can now trigger it whenever you are ready.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#： 準備好的時候就可以觸發它。", "tformat")
t("- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#: Your available vault space has increased.", "- #{bold}##ROYAL_BLUE#%s #SLATE#x%d#WHITE##{normal}#： 你可用的在線共享裝備空間增加了。", "tformat")
t([[Payment accepted.
%s]], [[支付已確認。
%s]], "tformat")
t("Steam Overlay should appear, if it does not please make sure it you have not disabled it.", "Steam 層應該出現了，如果沒有出現的話，請確認一下你是否關閉了該功能。", "_t")
t("Connecting to Steam", "正在連接到Steam", "_t")
t("Finalizing transaction with Steam servers...", "正在結束和Stean服務器的交易……", "_t")
t("Connecting to server", "正在連接到服務器", "_t")
t("Please wait...", "請等待…", "_t")
t("You have enough coins to instantly purchase those options. Confirm?", "你擁有足夠的硬幣來完成購買。確定購買嗎？", "_t")
t("Cancel", "取消", "_t")
t("Purchase", "購買", "_t")
t("You need %s more coins to purchase those options. Do you want to go to the donation page now?", "你還需要 %s 硬幣來完成購買。是否前往捐贈頁面？", "tformat")
t("Let's go! (Opens in your browser)", "去吧！（在瀏覽器中打開）", "_t")
t("Not now", "還是不了", "_t")
t("Payment", "付款", "_t")
t("Payment refused, you have not been billed.", "付款被拒絕，你未能成功付款。", "_t")
t([[#{bold}##GOLD#Community Online Event#WHITE##{normal}#: Once you have purchased a community event you will be able to trigger it at any later date, on whichever character you choose.
Community events once triggered will activate for #{bold}#every player currently logged on#{normal}# including yourself. Every player receiving it will know you sent it and thus that you are to thank for it.
To activate it you will need to have your online events option set to "all" (which is the default value).]], [[#{bold}##GOLD#社區在線事件#WHITE##{normal}#：成功購買一次社區事件後，你可以在任何時間、任何角色上觸發。
社區事件對 #{bold}#當前所有在線角色#{normal}# 生效，所有收到這次事件的玩家將知曉你的名字，並因此而感激你。
你需要將在線事件選項設置爲“全部”才能激活這個效果，注意，默認值即爲“全部”。
To activate it you will need to have your online events option set to "all" (which is the default value).]], "_t")
t([[#{bold}##GOLD#Event#WHITE##{normal}#: Once you have purchased an event you will be able to trigger it at any later date, on whichever character you choose.
To activate it you will need to have your online events option set to "all" (which is the default value).]], [[#{bold}##GOLD#Event#WHITE##{normal}#：成功購買一次事件後，你可以在任何時間、任何角色上觸發。
你需要將在線事件選項設置爲“全部”才能激活這個效果，注意，默認值即爲“全部”。]], "_t")
t("#{bold}##GOLD#Non Immediate#WHITE##{normal}#: This events adds new content that you have to find by exploration. If you die before finding it, there can be no refunds.", "#{bold}##GOLD#非即時#WHITE##{normal}#：該事件爲你後續遊戲進程增加了部分內容。即使你在接觸到新增內容前就死去也無法退款。", "_t")
t("#{bold}##GOLD#Once per Character#WHITE##{normal}#: This event can only be received #{bold}#once per character#{normal}#. Usualy because it adds a new zone or effect to the game that would not make sense to duplicate.", "#{bold}##GOLD#每角色限一次#WHITE##{normal}#：這個事件 #{bold}#每名角色只能接收一次#{normal}#. 通常是因爲它添加了新地城或者其他遊戲內不能重複添加的效果。", "_t")
t([[#{bold}##GOLD#Shimmer Pack#WHITE##{normal}#: Once purchased the game will automatically install the shimmer pack to your game and enable it for your current character too (you will still need to use the Mirror of Reflection to switch them on).
#LIGHT_GREEN#Bonus perk:#LAST# purchasing any shimmer pack will also give your characters a portable Mirror of Reflection to be able to change your appearance anywhere, anytime!]], [[#{bold}##GOLD#時裝包#WHITE##{normal}#：購買後遊戲會自動安裝時裝包，同時爲當前角色自動開啓。仍然需要使用反射之鏡來切換。
#LIGHT_GREEN#額外特效:#LAST# 購買任何時裝包後，你的角色自動獲得便攜式反射之鏡，可以隨時隨地切換時裝!]], "_t")
t("#{bold}##GOLD#Vault Space#WHITE##{normal}#: Once purchased your vault space is permanently increased.", "#{bold}##GOLD#Vault Space#WHITE##{normal}#：購買後，你的共享倉庫大小會永久增加。", "_t")
t("Online Store", "在線商城", "_t")


------------------------------------------------
section "game/engines/default/engine/dialogs/microtxn/UsePurchased.lua"

t("%s #GOLD#Purchased Options#LAST#", "%s #GOLD#已購買的選項#LAST#", "tformat")
t("#YELLOW#-- connecting to server... --", "#YELLOW#-- 正在連接到服務器... --", "_t")
t("Name", "名稱", "_t")
t("Available", "可用", "_t")
t("Please use purchased options when not on the worldmap.", "請不要在世界地圖上使用已購買的選項", "_t")
t("This option may only be used once per character to prevent wasting it.", "這一選項每個角色只能使用一次，以防止你浪費它。", "_t")
t([[This option requires you to accept to receive events from the server.
Either you have the option currently disabled or you are playing a campaign that can not support these kind of events (mainly the Arena).
Make sure you have #GOLD##{bold}#Allow online events#WHITE##{normal}# in the #GOLD##{bold}#Online#WHITE##{normal}# section of the game options set to "all". You can set it back to your own setting once you have received the event.
]], [[這一選項需要你的角色支持接收服務器發來的事件。
如果你關閉了這一選項，或者正在遊玩不支持這一功能的戰役(如競技場)，你將無法接收到事件。
請確保在遊戲設置的#GOLD##{bold}#在線#WHITE##{normal}#選項中將#GOLD##{bold}#允許在線事件#WHITE##{normal}# 設置爲“全部”。在事件接收完成後，你可以重新關閉這一選項。
]], "_t")
t("This pack is already installed and in use for your character.", "這個包已經安裝，可以用於你的角色。", "_t")
t("You are about to use a charge of this option. You currently have %d charges remaining.", "你準備使用這個選項，消耗一次使用次數。你還有 %d 次使用次數。", "tformat")
t("Please wait while contacting the server...", "請稍候，正在與服務器進行通信", "_t")
t("The option has been activated.", "選項已激活。", "_t")
t("There was an error from the server: %s", "服務器發生錯誤： %s", "tformat")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#已安裝", "_t")
t("#YELLOW#Installable", "#YELLOW#可以安裝", "_t")
t("Online Store", "在線商城", "_t")
t("You have not purchased any usable options yet. Would you like to see the store?", "你還沒有購買任何選項。你要瀏覽商城嗎？", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ActorInventory.lua"

t("%s picks up (%s.): %s%s.", "%s拾取了（%s）：%s%s", "logSeen")
t("%s has no room for: %s.", "%s沒有空間放置：%s。", "logSeen")
t("There is nothing to pick up here.", "沒什麼可以拾取的東西。", "logSeen")
t("There is nothing to drop.", "沒東西可以丟棄。", "logSeen")
t("%s drops on the floor: %s.", "%s把%s丟在了地上。", "logSeen")
t("wrong equipment slot", "無法在該在該裝備欄裝備", "_t")
t("not enough stat", "屬性值不足", "_t")
t("missing %s (level %s )", "缺少%s(等級%s )", "tformat")
t("missing %s", "缺少%s", "tformat")
t("not enough levels", "等級不足", "_t")
t("missing dependency", "未滿足裝備條件", "_t")
t("cannot use currently due to an other worn object", "由於目前穿戴的其他裝備，無法裝備此物品", "_t")
t("%s is not wearable.", "%s無法裝備。", "logSeen")
t("%s can not wear %s.", "%s不能裝備%s。", "logSeen")
t("%s wears: %s.", "%s 裝備了： %s", "logSeen")
t("%s wears (offslot): %s.", "%s副手裝備了： %s", "logSeen")
t("%s can not wear (%s): %s (%s).", "%s無法%s裝備：%s（%s）", "logSeen")
t("%s wears (replacing %s): %s.", "%s裝備（替換%s）了： %s", "logSeen")
t("%s can not wear: %s.", "%s不能裝備%s。", "logSeen")


------------------------------------------------
section "game/engines/default/engine/interface/ActorLife.lua"

t("#{bold}#%s killed %s!#{normal}#", "#{bold}#%s殺死了%s!#{normal}#", "logSeen")
t("something", "某物", "_t")
t("%s attacks %s.", "%s攻擊了%s.", "logSeen")


------------------------------------------------
section "game/engines/default/engine/interface/ActorTalents.lua"

t("%s is still on cooldown for %d turns.", "%s還有%d回合才能冷卻。", "logPlayer")
t("Talent Use Confirmation", "技能使用確認", "_t")
t("Use %s?", "使用%s?", "tformat")
t("Cancel", "取消", "_t")
t("Continue", "繼續", "_t")
t("unknown", "未知", "_t")
t("%s %s %s.", "%s%s%s。", "logSeen")
t("activates", "啓用了", "_t")
t("deactivates", "關閉了", "_t")
t("%s uses %s.", "%s使用了%s。", "logSeen")
t("not enough stat: %s", "屬性點不足: %s", "tformat")
t("not enough levels", "等級不足", "_t")
t("missing dependency", "未滿足裝備條件", "_t")
t("is not %s", "不是%s", "tformat")
t("unknown talent type", "未知的技能類型", "_t")
t("not enough talents of this type known", "技能樹中已學習技能不足", "_t")
t("- Talent category known", "- 技能樹已學會", "_t")
t("- Lower talents of the same category: %d", "- 技能樹中已學技能數：%d", "tformat")
t("- Level %d", "- 等級 %d", "tformat")
t("- Talent %s (not known)", "- 技能%s(未學習)", "tformat")
t("- Talent %s (%d)", "- 技能%s(%d)", "tformat")
t("- Talent %s", "- 技能%s", "tformat")
t("- Is %s", "- 是%s", "tformat")


------------------------------------------------
section "game/engines/default/engine/interface/GameTargeting.lua"

t("Tactical display disabled. Press shift+'t' to enable.", "戰術視圖關閉。請按Shift+'t'啓用。", "_t")
t("Are you sure you want to target yourself?", "你確認要瞄準你自己嗎？", "_t")
t("No", "否", "_t")
t("Target yourself?", "瞄準你自己？", "_t")
t("Yes", "是", "_t")
t("Tactical display enabled. Press shift+'t' to disable.", "戰術視圖啓用。請按Shift+'t'關閉。", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/ObjectActivable.lua"

t("It can be used to %s, with %d charges out of %d.", "可以用於 %s ，消耗 %d 充能，總計 %d。", "tformat")
t("It can be used to %s, costing %d power out of %d/%d.", "可以用於 %s, 消耗 %d 充能，總計 %d/%d 。", "tformat")
t("It can be used to activate talent: %s (level %d).", "可以用於激活技能： %s (等級 %d)。", "tformat")
t("It can be used to activate talent: %s (level %d), costing %d power out of %d/%d.", "可以用於激活技能： %s (等級 %d)，消耗 %d 充能，總計 %d/%d 。", "tformat")
t("%s is still recharging.", "%s 還在充能。", "logPlayer")
t("%s can not be used anymore.", "%s 無法再繼續使用了。", "logPlayer")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerExplore.lua"

t("Running...", "跑步中……", "_t")
t("You are exploring, press any key to stop.", "你正在自動探索，請按任意鍵停止", "_t")
t("the path is blocked", "路被擋住了", "_t")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerHotkeys.lua"

t("Hotkey not defined", "按鍵未定義", "_t")
t("You may define a hotkey by pressing 'm' and following the instructions there.", "你可以按m鍵打開按鍵綁定窗口，遵循上面的指示綁定按鍵。", "_t")
t("Item not found", "找不到物品", "_t")
t("You do not have any %s .", "你的物品欄裏裏沒有%s。", "tformat")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerMouse.lua"

t("[CHEAT] teleport to %dx%d", "[作弊] 傳送到 %dx%d", "log")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerRest.lua"

t("resting", "休息", "_t")
t("rested", "休息了", "_t")
t("%s...", "%s中...", "tformat")
t("You are %s, press Enter to stop.", "你正在%s，請按回車鍵停止。", "tformat")
t("%s starts...", "%s開始了...", "log")
t("%s for %d turns (stop reason: %s).", "%s%d回合 (停止原因：%s)。", "log")
t("%s for %d turns.", "%s%d回合。", "log")


------------------------------------------------
section "game/engines/default/engine/interface/PlayerRun.lua"

t("You are running, press Enter to stop.", "你正在跑步中，請按回車鍵停止。", "_t")
t("You don't see how to get there...", "你不知道怎麼到達那裏...", "logPlayer")
t("Running...", "跑步中……", "_t")
t("You are running, press any key to stop.", "你正在跑步中，請按任意鍵停止。", "_t")
t("didn't move", "沒有移動", "_t")
t("trap spotted", "發現陷阱", "_t")
t("terrain change on the left", "左側地形變化", "_t")
t("terrain change on the right", "右側地形變化", "_t")
t("at %s", "在 %s", "tformat")
t("Ran for %d turns (stop reason: %s).", "自動探索了%d回合（中斷原因：%s）", "log")


------------------------------------------------
section "game/engines/default/engine/interface/WorldAchievements.lua"

t("#%s#Personal New Achievement: %s!", "#%s#個人新成就：%s!", "log")
t("Personal New Achievement: #%s#%s", "個人新成就： #%s#%s", "tformat")
t("#%s#New Achievement: %s!", "#%s#新成就：%s!", "log")
t("New Achievement: #%s#%s", "新成就： #%s#%s", "tformat")
t("New Achievement", "新成就", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Dialog.lua"

t("Close", "關閉", "_t")
t("Yes", "是", "_t")
t("No", "否", "_t")
t("Cancel", "取消", "_t")
t("Copy URL", "複製網址", "_t")
t("URL copied to your clipboard.", "網址已複製到剪貼板。", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Gestures.lua"

t("Mouse Gestures", "鼠標手勢", "_t")
t([[You have started to draw a mouse gesture for the first time!
Gestures allow you to use talents or keyboard action by a simple movement of the mouse. To draw one you simply #{bold}#hold right click + move#{normal}#.
By default no bindings are done for gesture so if you want to use them go to the Keybinds and add some, it's easy and fun!

Gestures movements are color coded to better display which movement to do:
#15ed2f##{italic}#green#{normal}##LAST#: moving up
#1576ed##{italic}#blue#{normal}##LAST#: moving down
#ed1515##{italic}#red#{normal}##LAST#: moving left
#d6ed15##{italic}#yellow#{normal}##LAST#: moving right

If you do not wish to see gestures anymore, you can hide them in the UI section of the Game Options.
]], [[你開始試着繪製鼠標手勢了！
鼠標手勢可以讓你用鼠標動作來完成釋放技能或是鍵盤操作。
你只需要#{bold}#右擊並拖動#{normal}#就可以繪製鼠標手勢。
默認情況下，鼠標手勢沒有綁定到任何操作。如果你需要使用鼠標手勢，你可以在瀏覽“按鍵綁定”並添加，它可以爲你的冒險旅程提供幫助。

手勢動作以顏色編碼，以讓你更好地顯示你目前做出的動作：
#15ed2f##{italic}#綠色#{normal}##LAST#: 向上拖動
#1576ed##{italic}#藍色#{normal}##LAST#: 向下拖動
#ed1515##{italic}#紅色#{normal}##LAST#: 向左拖動
#d6ed15##{italic}#黃色#{normal}##LAST#: 向右拖動

如果你不希望看到手勢動作，請在遊戲設置的UI欄設置關閉它。
]], "_t")


------------------------------------------------
section "game/engines/default/engine/ui/Inventory.lua"

t("Inventory", "物品欄", "_t")
t("Category", "分類", "_t")
t("Enc.", "負重", "_t")


------------------------------------------------
section "game/engines/default/engine/ui/WebView.lua"

t("Download: ", "下載：", "tformat")
t("Cancel", "取消", "_t")
t("Are you sure you want to install this addon: #LIGHT_GREEN##{bold}#%s#{normal}##LAST# ?", "你確認要安裝這個插件嗎： #LIGHT_GREEN##{bold}#%s#{normal}##LAST# ？", "_t")
t("Confirm addon install/update", "確認插件安裝/更新", "_t")
t("Are you sure you want to install this module: #LIGHT_GREEN##{bold}#%s#{normal}##LAST#?", "你確認要安裝這個模組嗎： #LIGHT_GREEN##{bold}#%s#{normal}##LAST# ？", "tformat")
t("Confirm module install/update", "確認模組安裝/更新", "_t")
t("Addon installation successful. New addons are only active for new characters.", "插件安裝成功。新的插件只會在新的遊戲角色生效。", "_t")
t("Addon installed!", "墨子安裝完成！", "_t")
t("Game installation successful. Have fun!", "遊戲安裝完成。玩的開心！", "_t")
t("Game installed!", "遊戲安裝完成!", "_t")


------------------------------------------------
section "game/engines/default/engine/utils.lua"

t("%dth", "%d", "_t")
t("%dst", "%d", "_t")
t("%dnd", "%d", "_t")
t("%drd", "%d", "_t")
t("an ", "一個", "_t")
t("a ", "一個", "_t")
t("she", "她", "_t")
t("he", "他", "_t")
t("its", "它的", "_t")
t("his", "他的", "_t")
t("her", "她的", "_t")
t("it", "它", "_t")
t("him", "他", "_t")
t("herself", "她自己", "_t")
t("itself", "它自己", "_t")
t("himself", "他自己", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/class/Game.lua"

t("Welcome to T-Engine and the Tales of Maj'Eyal", "歡迎來到 T-Engine 和馬基·埃亞爾的傳說", "_t")
t([[#GOLD#"Tales of Maj'Eyal"#WHITE# is the main game, you can also install more addons or modules by going to https://te4.org/

When inside a module remember you can press Escape to bring up a menu to change keybindings, resolution and other module specific options.

Remember that in most roguelikes death is usually permanent so be careful!

Now go and have some fun!]], [[#GOLD#馬·基埃亞爾的傳說#WHITE# 是主遊戲，你也可以在 https://te4.org/ 下載到更多遊戲插件和遊戲模組。

在遊戲模組內，你可以按ESC鍵打開菜單，改變按鍵綁定，遊戲分辨率和其他和模組有關的設置。

請記住，在大部分Roguelike遊戲裏，角色的死亡都是永久的，請小心！

玩的開心！]], "_t")
t([[The way the engine manages saving has been reworked for v1.0.5.

The background saves should no longer lag horribly and as such it is highly recommended that you use the option. The upgrade turned it on for you.

For the same reason the save per level option should not be used unless you have severe memory problems. The upgrade turned it off for you.
]], [[遊戲引擎管理遊戲存檔的方式在 v1.0.5 版本發生了變化

後臺存檔將不再會嚴重拖慢你的遊戲運行速率，強烈建議你開啓這一選項。這次更新會自動幫你打開這個選項。

與此同時，每層存檔的選項已經沒有必要使用，除非你有嚴重的內存問題。這次更新會自動幫你關閉這個選項。
]], "_t")
t("Upgrade to 1.0.5", "升級到 v1.0.5 版本", "_t")
t([[Oops! Either you activated safe mode manually or the game detected it did not start correctly last time and thus you are in #LIGHT_GREEN#safe mode#WHITE#.
Safe Mode disabled all graphical options and sets a low FPS. It is not advisable to play this way (as it will be very painful and ugly).

Please go to the Video Options and try enabling/disabling options and then restarting until you do not get this message.
A usual problem is shaders and thus should be your first target to disable.]], [[糟糕！如果你不是手動開啓了安全模式的話，那麼說明，遊戲檢測到上一次啓動時發生錯誤，目前遊戲已進入#LIGHT_GREEN#安全模式#WHITE#。
在安全模式下，所有圖形選項都被關閉，FPS被設置爲很低。不建議在這種情況下進行遊戲(遊戲畫面會變得很難看)。

請你進入遊戲視頻選項，嘗試調整遊戲選項，直到你不再彈出此消息。
常見的問題一般是由着色器引發的，你可以先嚐試關閉這些選項。]], "_t")
t("Safe Mode", "安全模式", "_t")
t("Message", "消息", "_t")
t("Duplicate Addon", "重複的插件", "_t")
t([[Oops! It seems like you have the same addon/dlc installed twice.
This is unsupported and would make many things explode. Please remove one of the copies.

Addon name: #YELLOW#%s#LAST#

Check out the following folder on your computer:
%s
%s
]], [[糟糕！好像你安裝了多份同一個插件/DLC。
這種情況不被支持的，會引發很多BUG。請你移除掉多餘的文件。

插件名稱： #YELLOW#%s#LAST#

請你檢查你電腦裏的以下文件夾：
%s
%s
]], "_t")
t("Updating addon: #LIGHT_GREEN#%s", "正在更新插件: #LIGHT_GREEN#%s", "tformat")
t("Really exit T-Engine/ToME?", "真的要退出 T-Engine/馬基·埃亞爾的傳說", "_t")
t("Continue", "繼續", "_t")
t("Quit", "退出", "_t")
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
This is all optional, you are not forced to use this feature at all, but the developer would thank you if you did as it will make balancing easier.]], [[歡迎來到#LIGHT_GREEN#馬基·埃亞爾的傳說#LAST#！

在你開始嘗試這個遊戲裏無數有趣的死法之前，我們想問你一下有關在線遊戲的事情。

馬基·埃亞爾的傳說是一個#{bold}#單人遊戲#{normal}#，但也提供了豐富的在線功能，可以增強你的遊戲體驗，並讓你和遊戲社區建立聯繫：
* 在多臺電腦上游玩，而不需要複製遊戲解鎖和成就。
* 與其他玩家在遊戲內聊天，尋求建議，分享難忘的時刻…
* 記錄你的擊殺數量，死亡次數，以及最喜歡的職業…
* 統計你的遊戲數據，來記錄你的遊戲風格
* 在遊戲裏直接安裝官方擴展包和第三方插件，免去手動安裝的麻煩
* 如果你購買了遊戲或是在 https:/te4.org/ 上進行了捐助，你可以獲得獲得你的購買者/贊助者獨享權益
* 幫助遊戲開發者調整遊戲平衡，讓這個遊戲變得更好。

你也會在獲得一個 #LIGHT_BLUE#https:/te4.org/#LAST# 上的用戶頁面，可以用來向你的朋友炫耀。
這一切都是可選的，你可以自願使用或者關閉這些功能。開發者會根據你的用戶反饋來協助調整遊戲平衡。]], "_t")
t("Login in...", "登錄中…", "_t")
t("Please wait...", "請等待…", "_t")
t("Profile logged in!", "賬戶登錄成功！", "_t")
t("Check your login and password or try again in in a few moments.", "請確認你的用戶名和密碼，或在幾分鐘後再試。", "_t")
t("Login failed!", "登陸失敗！", "_t")
t("Registering on https://te4.org/, please wait...", "正在在 https://te4.org/ 上註冊，請稍候…", "_t")
t("Registering...", "正在註冊", "_t")
t("Logged in!", "登陸成功！", "_t")
t("Profile created!", "賬戶創建成功！", "_t")
t("Your online profile is now active. Have fun!", "你的在線賬戶已可用。玩得開心！", "_t")
t("Creation failed: %s (you may also register on https://te4.org/)", "創建失敗: %s (你也可以在 https://te4.org/ 網站上註冊）", "tformat")
t("Profile creation failed!", "賬戶創建失敗！", "_t")
t("Try again in in a few moments, or try online at https://te4.org/", "請過幾分鐘後再試，或在 https://te4.org/ 網站上註冊", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/class/Player.lua"

t("%s available", "%s可用", "tformat")
t("#00ff00#Talent %s is ready to use.", "#00ff00#技能%s已經可以使用了。", "log")
t("LEVEL UP!", "升級了！", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/birth/descriptors.lua"

t("base", "基礎", "birth descriptor name")
t("Destroyer", "毀滅者", "birth descriptor name")
t("Acid-maniac", "狂酸使", "birth descriptor name")


------------------------------------------------
section "game/engines/default/modules/boot/data/damage_types.lua"

t("Kill!", "擊殺!", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/basic.lua"

t("door", "門", "entity name")
t("floor", "地板", "entity subtype")
t("wall", "牆壁", "entity type")
t("open door", "敞開的門", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/forest.lua"

t("wall", "牆壁", "entity type")
t("tree", "樹", "entity name")
t("floor", "地板", "entity type")
t("grass", "草地", "entity subtype")
t("flower", "花", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/underground.lua"

t("wall", "牆壁", "entity type")
t("crystals", "水晶", "entity name")
t("underground", "地下", "entity subtype")
t("floor", "地板", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/grids/water.lua"

t("floor", "地板", "entity type")
t("water", "水", "entity subtype")
t("deep water", "深水", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/canine.lua"

t("animal", "動物", "entity type")
t("canine", "犬類", "entity subtype")
t("wolf", "狼", "entity name")
t("Lean, mean, and shaggy, it stares at you with hungry eyes.", "一頭瘦弱的、狡猾的皮毛蓬鬆的餓狼，它正用貪婪的眼神看着你。", "_t")
t("white wolf", "白狼", "entity name")
t("A large and muscled wolf from the northern wastes. Its breath is cold and icy and its fur coated in frost.", "一頭來自北部荒野的狼，它膘肥身健，體型勻稱。它的呼吸冰冷而急促且全身都凝結着冰霜。", "_t")
t("warg", "座狼", "entity name")
t("It is a large wolf with eyes full of cunning.", "這是一隻狡猾且體型巨大的狼。", "_t")
t("fox", "狐狸", "entity name")
t("The quick brown fox jumps over the lazy dog.", "這隻靈巧的棕色狐狸從一隻懶狗身上跳了過去。", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/skeleton.lua"

t("skeleton", "骷髏", "entity subtype")
t("undead", "亡靈", "entity type")
t("degenerated skeleton warrior", "腐化骷髏戰士", "entity name")
t("skeleton warrior", "骷髏戰士", "entity name")
t("skeleton mage", "骷髏法師", "entity name")
t("armoured skeleton warrior", "武裝骷髏戰士", "entity name")


------------------------------------------------
section "game/engines/default/modules/boot/data/general/npcs/troll.lua"

t("giant", "巨人", "entity type")
t("troll", "巨魔", "entity subtype")
t("forest troll", "森林巨魔", "entity name")
t("Green-skinned and ugly, this massive humanoid glares at you, clenching wart-covered green fists.", "醜陋的綠皮生物正盯着你，同時它握緊了滿是肉瘤的綠色拳頭。", "_t")
t("stone troll", "岩石巨魔", "entity name")
t("A giant troll with scabrous black skin. With a shudder, you notice the belt of dwarf skulls around his massive waist.", "有着粗糙黑色皮膚的巨魔，一陣戰慄後，你驚訝的發現他的腰帶是用矮人頭骨製成。", "_t")
t("cave troll", "洞穴巨魔", "entity name")
t("This huge troll wields a massive spear and has a disturbingly intelligent look in its piggy eyes.", "這隻巨魔手握一根笨重的長矛，同時在它那貪婪的眼睛裏，你看出了一絲令人不安的信息。", "_t")
t("mountain troll", "山嶺巨魔", "entity name")
t("mountain troll thunderer", "閃電山嶺巨魔", "entity name")
t("A large and athletic troll with an extremely tough and warty hide.", "一隻高大且強壯的巨魔，身披一張醜陋但異常堅硬的獸皮。", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/talents.lua"

t("misc", "雜項", "talent category")
t("Kick", "踢", "talent name")
t("Acid Spray", "酸液噴吐", "talent name")
t("Manathrust", "奧術射線", "talent name")
t("Flame", "火球術", "talent name")
t("Fireflash", "爆裂火球", "talent name")
t("Lightning", "閃電術", "talent name")
t("Sunshield", "太陽護盾", "talent name")
t("Flameshock", "火焰衝擊", "talent name")


------------------------------------------------
section "game/engines/default/modules/boot/data/timed_effects.lua"

t("Burning from acid", "酸液灼燒", "_t")
t("#Target# is covered in acid!", "#Target#被酸液覆蓋！", "_t")
t("+Acid", "+酸液", "_t")
t("#Target# is free from the acid.", "#Target#身上的酸液消失了。", "_t")
t("-Acid", "-酸液", "_t")
t("Sunshield", "太陽護盾", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/data/zones/dungeon/zone.lua"

t("Forest", "森林", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Addons.lua"

t("Configure Addons", "設置插件", "_t")
t("You can get new addons at #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "在以下位置可以獲得新的插件： #LIGHT_BLUE##{underline}#Te4.org 插件頁面#{normal}#", "_t")
t("You can get new addons on #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "在以下位置可以獲得新的插件： #LIGHT_BLUE##{underline}#Steam 創意工坊#{normal}# ", "_t")
t(", #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", ", #LIGHT_BLUE##{underline}#Te4.org 插件頁面#{normal}#", "_t")
t(" and #LIGHT_BLUE##{underline}#Te4.org DLCs#{normal}#", " 和 #LIGHT_BLUE##{underline}#Te4.org DLC頁面#{normal}#", "_t")
t("Show incompatible", "顯示不兼容版本", "_t")
t("Auto-update on start", "啓動時自動更新", "_t")
t("Game Module", "遊戲模組", "_t")
t("Version", "版本", "_t")
t("Addon", "插件", "_t")
t("Active", "啓動", "_t")
t("#GREY#Developer tool", "#GREY#開發者工具", "_t")
t("#LIGHT_RED#Donator Status: Disabled", "#LIGHT_RED#捐贈者狀態：禁用", "_t")
t("#LIGHT_GREEN#Manual: Active", "#LIGHT_GREEN#手動：啓動", "_t")
t("#LIGHT_RED#Manual: Disabled", "#LIGHT_RED#手動：禁用", "_t")
t("#LIGHT_GREEN#Auto: Active", "#LIGHT_GREEN#自動：啓動", "_t")
t("#LIGHT_RED#Auto: Incompatible", "#LIGHT_RED#自動：不兼容", "_t")
t("Addon Version", "插件版本", "_t")
t("Game Version", "遊戲版本", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Credits.lua"

t("Project Lead", "首席製作人", "_t")
t("Lead Coder", "領銜程序設計", "_t")
t("World Builders", "世界構建", "_t")
t("Graphic Artists", "視覺藝術", "_t")
t("Expert Shaders Design", "特效設計", "_t")
t("Soundtracks", "遊戲音樂", "_t")
t("Sound Designer", "音效設計", "_t")
t("Lore Creation and Writing", "劇情撰寫", "_t")
t("Code Helpers", "程序設計", "_t")
t("Community Managers", "社區經理", "_t")
t("Text Editors", "文本編輯", "_t")
t("The Community", "遊戲社區", "_t")
t("Others", "其他", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/FirstRun.lua"

t("Welcome to Tales of Maj'Eyal", "歡迎來到馬基埃亞爾的傳說", "_t")
t("Register now!", "現在註冊！", "_t")
t("Login existing account", "登錄已有賬戶", "_t")
t("Maybe later", "以後再說", "_t")
t("#RED#Disable all online features", "#RED#關閉所有聯網功能", "_t")
t("Disable all connectivity", "禁用所有網絡連接", "_t")
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

If you disable this option you can always re-activate it in the Online category of the Game Options menu later on.]], [[即將禁止所有網絡請求
包括但不僅限於:
- 用戶信息：不能登錄或者註冊。
- 角色備份：不能在te4.org上保存你的角色信息(用來給其他人分享你的炫酷角色)。
- 物品倉庫：不能訪問你的在線物品倉庫(包括存入和取回)。
- 遊戲內聊天：聊天要聯網, 謝謝。
- 氪金福利：聯網才能獲取你的氪金狀態。
- 擴展包&DLC：和氪金狀態一樣, 無法獲取DLC的購買狀態。
- 便捷的插件安裝：無法在遊戲內看見插件列表, 但是你還可以手動安裝插件。
- 插件版本更新：無法更新插件的版本。
- Steam：無法使用Steam相關的任何功能。
- Discord：無法同步到Discord的實時狀態。
- 遊戲內新聞：主菜單將不再顯示新聞。
注意這個設置隻影響遊戲本身。如果你使用遊戲啓動器，它的唯一目的就是確保遊戲是最新的，因此它仍然會連接網絡。
如果你不想這樣，直接運行遊戲即可。啓動器只是用來更新遊戲的。


#{bold}##CRIMSON#這是一個極端的選項。如果不是迫不得已, 推薦你不要打開它, 這會讓你失去很多好用的功能和一些遊戲體驗。#{normal}#
關閉後，可以通過遊戲設置菜單的在線選項卡打開。]], "_t")
t("#RED#Disable all!", "#RED#全部禁用！", "_t")
t("Cancel", "取消", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/LoadGame.lua"

t("Load Game", "讀取遊戲", "_t")
t("Show older versions", "顯示舊版本", "_t")
t("Ignore unloadable addons", "忽略無法讀取的插件", "_t")
t("  Play!  ", "  遊玩！  ", "_t")
t([[#{bold}##GOLD#%s: %s#WHITE##{normal}#
Game version: %d.%d.%d
Requires addons: %s

%s]], [[#{bold}##GOLD#%s：%s#WHITE##{normal}#
遊戲版本： %d.%d.%d
需要的插件： %s

%s]], "tformat")
t("You can simply grab an older version of the game from where you downloaded it.", "你可以在下載這個遊戲的地方，下載到這個遊戲的舊版本。", "_t")
t("You can downgrade the version by selecting it in the Steam's \"Beta\" properties of the game.", "你可以在Steam中設置Beta版本屬性，來降級你的遊戲版本。", "_t")
t("Original game version not found", "未找到原遊戲版本", "_t")
t([[This savefile was created with game version %s. You can try loading it with the current version if you wish but it is recommended you play it with the old version to ensure compatibility
%s]], [[這個存檔是遊戲版本 %s 創建的。如果你願意，你可以嘗試使用當前版本強制讀檔，但是建議你使用舊版本遊戲進行遊玩，來確保兼容性。
%s]], "tformat")
t("Run with newer version", "運行新版本", "_t")
t("#LIGHT_RED#WARNING: #LAST#Loading a savefile while in developer mode will permanently invalidate it. Proceed?", "#LIGHT_RED#警告： #LAST#在開發者模式下讀取一個存檔將會不可逆地將其標記爲作弊存檔。確定嗎？", "_t")
t("Developer Mode", "開發者模式", "_t")
t("Load anyway", "仍然讀檔", "_t")
t("Delete savefile", "刪除存檔", "_t")
t("Really delete #{bold}##GOLD#%s#WHITE##{normal}#", "真的要刪除#{bold}##GOLD#%s#WHITE##{normal}#嗎", "tformat")
t("Cancel", "取消", "_t")
t("Delete", "刪除", "_t")
t("No data available for this game version.", "沒有當前遊戲版本的數據。", "_t")
t("Downloading old game data: #LIGHT_GREEN#", "正在下載舊版遊戲數據： #LIGHT_GREEN#", "_t")
t("Old game data for %s correctly installed. You can now play.", " %s 的舊版遊戲數據已經安裝成功了。你可以現在遊玩了。", "tformat")
t("Failed to install.", "安裝失敗。", "_t")
t("Old game data", "舊版遊戲數據", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/MainMenu.lua"

t("Main Menu", "主菜單", "_t")
t("New Game", "新遊戲", "_t")
t("Load Game", "讀取遊戲", "_t")
t("Addons", "插件", "_t")
t("Options", "選項", "_t")
t("Game Options", "遊戲選項", "_t")
t("Credits", "製作人員名單", "_t")
t("Exit", "退出", "_t")
t("Reboot", "重啓遊戲", "_t")
t("Disable animated background", "關閉動態背景", "_t")
t("#{bold}##B9E100#T-Engine4 version: %d.%d.%d", "#{bold}##B9E100#T-Engine4 版本：%d.%d.%d", "tformat")
t([[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]], [[#{bold}##GOLD#烏魯洛克之燼 - 遊戲擴展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#很多馬基埃亞爾的居民都曾經聽說過“惡魔”的名字，它們是一羣似乎憑空出現的暴虐生物，無論走到哪裏都會帶來痛苦和毀滅。#{normal}##LAST#

#{bold}#擴展包特性#{normal}#:
#LIGHT_UMBER#新職業：#WHITE# 毀滅使者。 他們是惡魔毀滅力量的化身，手拿雙手武器加入戰鬥，將敵人化爲一片火海。他們的手中掌握着火焰的魔法和惡魔的力量，在與勢不可擋的敵人戰鬥中尋求歡愉。
#LIGHT_UMBER#新職業：#WHITE# 惡魔使者。 這些近戰施法者手拿盾牌，掌握魔法大爆炸本身的力量的魔法，可以在倒下的敵人的身上終止惡魔種子。將這些惡魔種子附魔到你的物品裏，可以獲得各種全新的技能和被動的能力，並召喚種子裏的惡魔來加入戰鬥！
#LIGHT_UMBER#新種族：#WHITE# 魔化精靈。 那些被惡魔的力量所改變的永恆精靈，他們的種族能力被腐化成了黑暗的形態。
#LIGHT_UMBER#更多新神器、新手札、新地圖、新事件……#WHITE# 體驗惡魔的歡愉吧！

]], "_t")
t([[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]], [[#{bold}##GOLD#餘燼怒火 - 遊戲擴展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#自從被獸人成爲“西方災星”的那個人，孤身一人粉碎了格魯希納克、沃爾、加伯特和拉克肖四大部落之後，已經過了一年的時間。聯合王國現在已經通過遠古傳送門，和他們失落已久的盟友太陽堡壘建立了聯繫，幫助他們征服了瓦·埃亞爾大陸的近乎全境。被戰火蹂躪的獸人部落的少數殘餘，現在都被聯軍關押在監獄裏……但是，還有一個部落存活了下來。#{normal}##LAST#

#{bold}#擴展包特性#{normal}#:
#LIGHT_UMBER#全新戰役：#WHITE# 這場戰役在主遊戲戰役以後，決定獸人部落的最終命運。探索全新的遠東大陸吧！
#LIGHT_UMBER#全新職業：#WHITE# 鏈鋸屠夫，槍手，念力射手，殲滅者和科技法師。掌握蒸汽的力量，驅動致命的裝置，用鋼鐵洪流粉碎那些膽敢反抗部落的人吧！
#LIGHT_UMBER#全新種族：#WHITE# 獸人，雪人，白蹄。瞭解獸人和他們那些奇特的“盟友”，團結起來，將獸人一族從“西方災星”帶來的災難中拯救出來。
#LIGHT_UMBER#插件系統：#WHITE# 合成強大的插件，用於強化你的物品。包括給你的靴子安裝火箭，給你的手套安裝抓取系統，乃至許多更多的插件。
#LIGHT_UMBER#藥劑系統：#WHITE# 在插件系統中，合成強大的醫療藥劑，用於注入你的皮膚，替代就有的紋身和符文系統。
#LIGHT_UMBER#大量#WHITE# 全新神器、手札、地圖和事件！

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

]], [[#{bold}##GOLD#禁忌邪教 - 遊戲擴展包#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#不是所有的冒險者都在尋求財富，也不是所有保衛世界的人都心存善念。最近，恐魔在大陸上出現的次數急劇增加。不斷有人在偏僻的小路上失蹤，有時幾年後才被人發現，身體卻遭受了恐怖的變異，進入了瘋狂之中，也有時候再也無法尋到蹤跡。很明顯，在馬基·埃亞爾的大地深處，有某種東西正在暗中活動。那種東西——就是你。#{normal}##LAST#

#{bold}#擴展包特性#{normal}#:
#LIGHT_UMBER#新職業：#WHITE# 苦痛者。 它們被賦予了腐化的力量，最終將自己的身體轉化成了恐魔。它們可以召喚恐魔在戰鬥中協助自己，撕裂你的皮膚，融化你的臉龐，作爲攻擊敵人的武器。當你的手臂也被轉化成觸手之後，還有什麼敵人能阻擋你呢？
#LIGHT_UMBER#新職業：#WHITE# 熵教徒。 這種法師職業使用瘋狂的能力，掌控了熵的力量，顛覆了傳統的物理定律。它們可以將治療轉換成傷害，並召喚虛空的力量，將敵人粉碎爲塵土。
#LIGHT_UMBER#新種族：#WHITE# 德瑞姆。 他們是矮人的一支腐化分支，但是因爲某種原因，保持了一定程度的理性，而沒有完全孵化成爲沒有意識的恐魔。他們可以進入狂熱狀態，並學會召喚恐魔。
#LIGHT_UMBER#新種族：#WHITE# 克羅格。 他們是被本來應當殺死他們的那羣人轉化的食人魔。他們強大的攻擊可以震懾敵人，並且他們強壯的力量可以雙持任何單手武器。
#LIGHT_UMBER#大量全新地圖：#WHITE# 探索瘟疫之穴，在一隻巨大蠕蟲的身體內殺出一條血路(不要問我你是怎麼*進來*的)，探索神祕的出口，以及更多奇異的，充滿觸手的地圖！
#LIGHT_UMBER#新的恐魔：#WHITE# 你喜歡灼眼恐魔嗎？你一定會喜歡上灼熱恐魔的！還有虛空蠕蟲，還有熵之碎片，還有其他更多怪物！
#LIGHT_UMBER#厭倦了你自己的頭？#WHITE#  把它換成一個悠閒的寄生獸吧！
#LIGHT_UMBER#大量#WHITE# 全新神器、手札、事件……

]], "_t")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#已安裝", "_t")
t("#YELLOW#Not installed - Click to download / purchase", "#YELLOW#未安裝 - 點擊下載/購買", "_t")
t("Login", "登錄", "_t")
t("Register", "註冊", "_t")
t("Username: ", "用戶名：", "_t")
t("Password: ", "密碼：", "_t")
t("#GOLD#Online Profile", "#GOLD#在線賬戶", "_t")
t("Login with Steam", "使用Steam登錄", "_t")
t("#GOLD#Online Profile#WHITE#", "#GOLD#在線賬戶#WHITE#", "_t")
t("#LIGHT_BLUE##{underline}#Logout", "#LIGHT_BLUE##{underline}#登出", "_t")
t("Username", "用戶名", "_t")
t("Your username is too short", "你的用戶名過短", "_t")
t("Password", "密碼", "_t")
t("Your password is too short", "你的密碼過短", "_t")
t("Login in your account, please wait...", "正在登錄賬戶，請稍後…", "_t")
t("Login...", "登錄中…", "_t")
t("Steam client not found.", "找不到Steam客戶端", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/NewGame.lua"

t("New Game", "新遊戲", "_t")
t("Show all versions", "顯示所有版本", "_t")
t("Show incompatible", "顯示不兼容版本", "_t")
t([[You can get new games at
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], [[你可以在這裏下載到最新遊戲
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], "_t")
t("Game Module", "遊戲模組", "_t")
t("Version", "版本", "_t")
t("Enter your character's name", "輸入角色名稱", "_t")
t("Overwrite character?", "覆蓋角色？", "_t")
t("There is already a character with this name, do you want to overwrite it?", "已經有一個這個名稱的角色了，你要覆蓋這個角色嗎？", "_t")
t("No", "否", "_t")
t("Yes", "是", "_t")
t("This game is not compatible with your version of T-Engine, you can still try it but it might break.", "這個遊戲與你T-Engine的版本不兼容，你可以嘗試運行，但是遊戲可能崩潰。", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/Profile.lua"

t("Player Profile", "玩家賬戶", "_t")
t("Logout", "登出", "_t")
t("Do you want to log out?", "你要登出嗎？", "_t")
t("You are logged in", "你已經登入了。", "_t")
t("Cancel", "取消", "_t")
t("Log out", "登出", "_t")
t("Login", "登錄", "_t")
t("Create Account", "創建賬戶", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileLogin.lua"

t("Online profile ", "在線賬戶", "_t")
t("Login", "登錄", "_t")
t("Password again: ", "重複密碼：", "_t")
t("Username: ", "用戶名：", "_t")
t("Password: ", "密碼：", "_t")
t("Email: ", "郵箱", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "允許我們#{bold}#偶爾#{normal}#向你發送有關遊戲重要新聞的郵件(每年最多隻會有幾封)", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "遊玩此遊戲時你已年滿16歲，或已得到了家長的許可。", "_t")
t("Create", "創建", "_t")
t("Privacy Policy (opens in browser)", "隱私政策(用瀏覽器打開)", "_t")
t("Cancel", "取消", "_t")
t("Password mismatch!", "密碼不匹配！", "_t")
t("Username", "用戶名", "_t")
t("Your username is too short", "你的用戶名過短", "_t")
t("Password", "密碼", "_t")
t("Your password is too short", "你的密碼過短", "_t")
t("Email", "郵箱", "_t")
t("Your email seems invalid", "郵箱地址無效", "_t")
t("Age Check", "年齡確認", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "你需要年滿16歲以上，或者得到了家長的許可，纔可以遊玩本遊戲。", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ProfileSteamRegister.lua"

t("Steam User Account", "Steam用戶賬戶", "_t")
t([[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]], [[歡迎來到#GOLD#馬基·埃亞爾的傳說#LAST#.
爲了享受遊戲的全部功能，我們#{bold}#強烈#{normal}#推薦你註冊你的Steam賬戶。
幸運的是，這非常容易：你只需要提供你的Steam用戶名，也可以提供你的郵箱。（我們基本上不會給你發送郵件，每年最多發送一兩份）
]], "_t")
t("Username: ", "用戶名：", "_t")
t("Email: ", "郵箱", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "允許我們#{bold}#偶爾#{normal}#向你發送有關遊戲重要新聞的郵件(每年最多隻會有幾封)", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "遊玩此遊戲時你已年滿16歲，或已得到了家長的許可。", "_t")
t("Register", "註冊", "_t")
t("Cancel", "取消", "_t")
t("Privacy Policy (opens in browser)", "隱私政策(用瀏覽器打開)", "_t")
t("Username", "用戶名", "_t")
t("Your username is too short", "你的用戶名過短", "_t")
t("Email", "郵箱", "_t")
t("Your email does not look right.", "你的郵件地址有問題。", "_t")
t("Age Check", "年齡確認", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "你需要年滿16歲以上，或者得到了家長的許可，纔可以遊玩本遊戲。", "_t")
t("Registering on https://te4.org/, please wait...", "正在在 https://te4.org/ 上註冊，請稍候…", "_t")
t("Registering...", "正在註冊", "_t")
t("Steam client not found.", "找不到Steam客戶端", "_t")
t("Error", "錯誤", "_t")
t("Username or Email already taken, please select an other one.", "用戶名或郵件地址已被使用，請選擇其他用戶名或郵件地址", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/UpdateAll.lua"

t("Update all game modules", "更新所有遊戲模組", "_t")
t([[All those components will be updated:
]], [[所有需要更新的模組: 
]], "_t")
t("Component", "組件", "_t")
t("Version", "版本", "_t")
t("All your game modules are up to date.", "所有遊戲模組都處於最新版本。", "_t")
t("Nothing to update", "沒有需要更新的內容", "_t")
t("Game: #{bold}##GOLD#", "遊戲：#{bold}##GOLD#", "_t")
t("Engine: #{italic}##LIGHT_BLUE#", "遊戲引擎：#{italic}##LIGHT_BLUE#", "_t")
t("Downloading: ", "正在下載：", "_t")
t("Error!", "錯誤！", "_t")
t([[There was an error while downloading:
]], [[下載時發生錯誤:
]], "_t")
t("All updates installed, the game will now restart", "所有更新已安裝完畢，遊戲現在將會重新啓動", "_t")
t("Update", "更新", "_t")


------------------------------------------------
section "game/engines/default/modules/boot/dialogs/ViewHighScores.lua"

t("View High Scores", "查看高分榜", "_t")
t("Game Module", "遊戲模組", "_t")
t("Version", "版本", "_t")
t("World", "世界", "_t")
t([[#{bold}##GOLD#%s#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s#GREEN# 高分榜 #WHITE##{normal}#

]], "tformat")
t([[#{bold}##GOLD#%s(%s)#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s(%s)#GREEN# 高分榜 #WHITE##{normal}#

]], "tformat")


------------------------------------------------
section "game/engines/default/modules/boot/init.lua"

t("Tales of Maj'Eyal Main Menu", "馬基·埃亞爾的傳說 主菜單", "init.lua long_name")
t([[Bootmenu!
]], [[啓動菜單!
]], "init.lua description")


------------------------------------------------
section "game/engines/default/modules/boot/load.lua"

t("Strength", "力量", "stat name")
t("str", "力量", "stat short_name")
t("Dexterity", "敏捷", "stat name")
t("dex", "敏捷", "stat short_name")
t("Constitution", "體質", "stat name")
t("con", "體質", "stat short_name")


