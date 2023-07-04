------------------------------------------------
section "tome-items-vault/data/entities/fortress-grids.lua"

t("Item's Vault Control Orb", "아이템 금고 제어 오브", "entity name")

------------------------------------------------
section "tome-items-vault/init.lua"

t("Items Vault", "아이템 금고", "init.lua long_name")
t("Adds access to the items vault (donator feature). The items vault will let you upload a few unwanted items to your online profile and retrieve them on other characters.", "아이템 금고를 이용할 수 있는 기능을 추가합니다. (후원자 전용) 아이템 금고에 사용하지 않는 아이템을 플레이어의 온라인 프로필로 전송하여 다른 캐릭터로 옮길 수 있습니다.", "init.lua description")

------------------------------------------------
section "tome-items-vault/overload/data/chats/items-vault-command-orb-offline.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 금고에 전송 시 %d 레벨의 착용 제한이 적용됩니다.", "tformat")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.", "_t")
t([[*#LIGHT_GREEN#This orb seems to be some kind of interface to an extra-dimentional vault of items.
All your characters in alternate universes will be able to access it from here.
Only items from a validated game versions are uploadable.#WHITE#*

#CRIMSON#Offline mode#WHITE#: The item's vault works even without a network connection but items will thus only be saved on your computer and can not be shared to an other one.
The offline vault is only available when offline and contains 3 slots.]], [[#LIGHT_GREEN#*이 오브는 여분 차원의 아이템 금고와 상호 작용할 수 있는 것 같습니다.
다른 우주에 존재하는 모든 캐릭터들 또한 여기에 접근할 수 있습니다.
유효한 게임 버전의 아이템만 보관할 수 있습니다.*#WHITE#

#CRIMSON#오프라인 모드#WHITE#: 아이템 금고는 인터넷 연결이 되어있지 않아도 작동하지만, 컴퓨터 내 저장소에만 저장되므로 온라인 상 다른 아이템에 접근이 불가능합니다.
오프라인 금고는 3 칸의 금고만 사용 가능합니다.]], "_t")
t("[Place an item in the vault]", "[금고에 아이템 보관하기]", "_t")
t("Item's Vault", "아이템 금고", "_t")
t("You can not place an item in the vault from debug mode game.", "디버그 모드에서는 아이템 금고에 아이템을 보관할 수 없습니다.", "_t")
t("Place an item in the Item's Vault", "금고에 아이템을 보관하기.", "_t")
t("Caution", "경고", "_t")
t("Continue?", "계속하시겠습니까?", "_t")
t("[Retrieve an item from the vault]", "[금고에서 아이템을 찾아오기.]", "_t")
t("[Leave the orb alone]", "[오브를 두고 떠난다]", "_t")

------------------------------------------------
section "tome-items-vault/overload/data/chats/items-vault-command-orb.lua"

t("Transfering this item will place a level %d requirement on it, since it has no requirements. ", "이 아이템은 착용 제한이 없으나, 금고에 전송 시 %d 레벨의 착용 제한이 적용됩니다.", "tformat")
t("Some properties of the item will be lost upon transfer, since they are class- or talent-specific. ", "전송 시 직업 혹은 재능에 기반한 부가 능력은 사라질 수도 있습니다.", "_t")
t([[*#LIGHT_GREEN#This orb seems to be some kind of interface to an extra-dimentional vault of items.
All your characters in alternate universes will be able to access it from here.
Only items from a validated game versions are uploadable.#WHITE#*

#GOLD#Donator's Feature#ANCIENT_WHITE#: Items are saved on the server, only donators have access to this feature and the number of items storable at once depends on your generosity.
I, DarkGod, the maker of this game want to personaly thank all donators because you people are keeping this game going. Thanks and enjoy!]], [[#LIGHT_GREEN#*이 오브는 여분 차원의 아이템 금고와 상호 작용할 수 있는 것 같습니다.
다른 우주에 존재하는 모든 캐릭터들 또한 여기에 접근할 수 있습니다.
유효한 게임 버전의 아이템만 보관할 수 있습니다.*#WHITE#

#GOLD#후원자 전용 기능#ANCIENT_WHITE#: 아이템을 서버에 저장할 수 있습니다. 후원자만 이 기능을 사용할 수 있으며 아이템 금고의 크기는 후원자의 도량에 따라 달라집니다.
이 게임을 만든 저 DarkGod은 모든 후원자분들께 개인적으로 감사드립니다. 재밌게 즐기세요!]], "_t")
t("\
#CRIMSON#Note for Steam Players#ANCIENT_WHITE#: This feature requires you to have registered a profile & bound it to steam (automatic if you register ingame) because it needs to store things on the server.\
Until you do so you will get an error.", "\
#CRIMSON#Steam 플레이어들을 위한 메모#ANCIENT_WHITE#: 이 기능은 서버에 데이터를 저장해야 하기 때문에 계정을 Steam에 연동해야만 합니다. (게임 내에 프로필을 등록 시 자동으로 연동됩니다.) \
연동하기 전까진 오류가 발생할 수 있습니다.", "_t")
t("[Place an item in the vault]", "[금고에 아이템 보관하기]", "_t")
t("Item's Vault", "아이템 금고", "_t")
t("You can not place an item in the vault from an un-validated game.", "유효하지 않은 게임의 아이템은 금고에 보관할 수 없습니다.", "_t")
t("Place an item in the Item's Vault", "금고에 아이템을 보관하기.", "_t")
t("Caution", "경고", "_t")
t("Continue?", "계속하시겠습니까?", "_t")
t("[Retrieve an item from the vault]", "[금고에서 아이템을 찾아오기.]", "_t")
t("#GOLD#I wish to help the funding of this game and donate#WHITE#", "#GOLD#나는 이 게임에 도움을 주기 위해 후원을 하고 싶다#WHITE#", "_t")
t("[Leave the orb alone]", "[오브를 두고 떠난다]", "_t")

------------------------------------------------
section "tome-items-vault/overload/data/maps/items-vault/fortress.lua"


-- untranslated text
--[==[
t("Psionic Metarial Retention", "Psionic Metarial Retention", "_t")
t("Temporal Locked Vault", "Temporal Locked Vault", "_t")
--]==]


------------------------------------------------
section "tome-items-vault/overload/mod/class/ItemsVaultDLC.lua"

t("the #GOLD#Item's Vault#WHITE#", "#GOLD#아이템 금고#WHITE#", "_t")
t("\
#CRIMSON#This item has been sent to the Item's Vault.", "\
#CRIMSON#이 아이템은 금고로 전송되었던 것입니다.", "_t")
t("Transfering...", "전송 중...", "_t")
t("Teleporting object to the vault, please wait...", "물건을 금고로 전이시키는 중입니다. 잠시만 기다려주세요...", "_t")
t("unknown reason", "알 수 없는 이유", "_t")
t("#LIGHT_BLUE#You transfer %s to the online item's vault.", "#LIGHT_BLUE#%s 온라인 아이템 금고로 전송했습니다.", "logPlayer", nil, {"를"})
t("#LIGHT_RED#Error while transfering %s to the online item's vault, please retry later.", "#LIGHT_RED#%s 온라인 아이템 금고로 전송하는 도중에 오류가 발생했습니다. 다시 시도해주세요.", "logPlayer", nil, {"를"})
t("#CRIMSON#Server said: %s", "#CRIMSON#서버 : %s", "logPlayer")
t("#LIGHT_BLUE#You transfer %s to the offline item's vault.", "#LIGHT_BLUE#%s 오프라인 아이템 금고로 전송했습니다.", "logPlayer", nil, {"를"})
t("Teleporting object from the vault, please wait...", "금고에서 물건을 전이시켜 오는 중입니다. 잠시만 기다려주세요...", "_t")
t("Transfer failed", "전송 실패", "_t")
t([[This item comes from a previous version and would not work in your current game.
To prevent the universe from imploding the item was not transfered from the vault.]], [[이 아이템은 이전 버전의 것이며 현재 게임에서는 작동하지 않습니다.
우주가 이 아이템을 파괴할 수 있으므로 금고에서 가져오지 않았습니다.]], "_t")
t("Item's Vault", "아이템 금고", "_t")
t("Checking item's vault list, please wait...", "아이템 금고 목록을 확인하는 중입니다. 잠시만 기다려주세요...", "_t")

------------------------------------------------
section "tome-items-vault/overload/mod/dialogs/ItemsVault.lua"

t("Item's Vault", "아이템 금고", "_t")
t("Impossible to contact the server, please wait a few minutes and try again.", "서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.", "_t")
t("Item's Vault (%d/%d)", "아이템 금고 (%d/%d)", "tformat")
t([[Retrieve an item from the vault. When you place an item in the vault the paradox energies around it are so powerful you must wait one hour before retrieving it.
	#CRIMSON#Warning: while you *can* retrieve items made with previous versions of the game, no guarantee is given that the universe (or your character) will not explode.]], [[금고에서 아이템을 되찾아옵니다. 금고에 보관된 아이템은 강력한 역설 에너지가 감싸고 있기 때문에 한 시간 뒤에 되찾아올 수 있습니다.
	#CRIMSON#경고: 이전 버전 게임의 아이템도 *찾아올 수는* 있지만 우주(혹은 당신의 캐릭터)가 폭발하지 않는다는 보장은 없습니다.]], "_t")
t("Name", "이름", "_t")
t("Usable", "사용 가능", "_t")
t("#LIGHT_GREEN#Yes", "#LIGHT_GREEN#네", "_t")
t("#LIGHT_RED#In less than one minute", "#LIGHT_RED#1분 이내", "_t")
t("#LIGHT_RED#In %d minutes", "#LIGHT_RED#%d분 내", "tformat")
t("Cooldown", "대기 시간", "_t")
t("This item has been placed recently in the vault, you must wait a bit before removing it.", "이 아이템은 보관된지 얼마 지나지 않았으므로, 아직 제거할 수 없습니다.", "_t")
t("#LIGHT_BLUE#You transfer %s from the online item's vault.", "#LIGHT_BLUE#%s 온라인 아이템 금고에서 전송받았습니다.", "log", nil, {"를"})
t("#LIGHT_RED#Error while transfering from the online item's vault, please retry later.", "#LIGHT_RED#온라인 아이템 금고에서 전송받는 도중에 오류가 발생했습니다. 다시 시도해주세요.", "log")

------------------------------------------------
section "tome-items-vault/overload/mod/dialogs/ItemsVaultOffline.lua"

t("Item's Vault", "아이템 금고", "_t")
t("Impossible to contact the server, please wait a few minutes and try again.", "서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.", "_t")
t("Item's Vault (%d/%d)", "아이템 금고 (%d/%d)", "tformat")
t([[Retrieve an item from the vault. When you place an item in the vault the paradox energies around it are so powerful you must wait one hour before retrieving it.
	#CRIMSON#Warning: while you *can* retrieve items made with previous versions of the game, no guarantee is given that the universe (or your character) will not explode.]], [[금고에서 아이템을 되찾아옵니다. 금고에 보관된 아이템은 강력한 역설 에너지가 감싸고 있기 때문에 한 시간 뒤에 되찾아올 수 있습니다.
	#CRIMSON#경고: 이전 버전 게임의 아이템도 *찾아올 수는* 있지만 우주(혹은 당신의 캐릭터)가 폭발하지 않는다는 보장은 없습니다.]], "_t")
t("Name", "이름", "_t")
t("Usable", "사용 가능", "_t")
t("#LIGHT_GREEN#Yes", "#LIGHT_GREEN#네", "_t")
t("#LIGHT_RED#In less than one minute", "#LIGHT_RED#1분 이내", "_t")
t("#LIGHT_RED#In %d minutes", "#LIGHT_RED#%d분 내", "tformat")
t("Cooldown", "대기 시간", "_t")
t("This item has been placed recently in the vault, you must wait a bit before removing it.", "이 아이템은 보관된지 얼마 지나지 않았으므로, 아직 제거할 수 없습니다.", "_t")
t("#LIGHT_BLUE#You transfer %s from the offline item's vault.", "#LIGHT_BLUE#%s 오프라인 아이템 금고에서 전송받았습니다.", "log", nil, {"를"})
t("#LIGHT_RED#Error while transfering from the offline item's vault, please retry later.", "#LIGHT_RED#오프라인 아이템 금고에서 전송받는 도중에 오류가 발생했습니다. 다시 시도해주세요.", "log")

