------------------------------------------------
section "mod-boot/class/Game.lua"

t("Welcome to T-Engine and the Tales of Maj'Eyal", "T-Engine과 Tales of Maj'Eyal에 오신 것을 환열합니다", "_t")
t([[#GOLD#"Tales of Maj'Eyal"#WHITE# is the main game, you can also install more addons or modules by going to https://te4.org/

When inside a module remember you can press Escape to bring up a menu to change keybindings, resolution and other module specific options.

Remember that in most roguelikes death is usually permanent so be careful!

Now go and have some fun!]], [[#GOLD#"Tales of Maj'Eyal"#WHITE#은 메인 게임입니다. 다른 애드온이나 모듈을 다음 주소에서 설치하실 수 있습니다. https://te4.org/

모듈에서는 ESC키를 눌러 키 설정이나 해상도 설정 등 다양한 설정을 변경할 수 있습니다.

로그라이크 게임에서 한 번의 죽음은 되돌릴 수 없으니 조심하세요!

그러면 게임을 즐겨주시기 바랍니다!]], "_t")
t("Upgrade to 1.0.5", "1.0.5 업데이트 변경점", "_t")
t([[The way the engine manages saving has been reworked for v1.0.5.

The background saves should no longer lag horribly and as such it is highly recommended that you use the option. The upgrade turned it on for you.

For the same reason the save per level option should not be used unless you have severe memory problems. The upgrade turned it off for you.
]], [[엔진 버전 v1.0.5부터 세이브 방식이 변경됐습니다.

자동 세이브는 더 이상 심각한 렉을 발생시키지 않기 때문에, 이제 이 옵션을 항상 활성화하시는 것을 매우 추천드립니다. 업데이트 후 자동으로 활성화됩니다.

이전의 매 층 자동 세이브 옵션은 비활성화하십시오. 심각한 메모리 문제가 있는 경우에만 사용해 주시기 바랍니다. 업데이트 후 자동으로 비활성화됩니다.
]], "_t")
t("Safe Mode", "안전 모드", "_t")
t([[Oops! Either you activated safe mode manually or the game detected it did not start correctly last time and thus you are in #LIGHT_GREEN#safe mode#WHITE#.
Safe Mode disabled all graphical options and sets a low FPS. It is not advisable to play this way (as it will be very painful and ugly).

Please go to the Video Options and try enabling/disabling options and then restarting until you do not get this message.
A usual problem is shaders and thus should be your first target to disable.]], [[이런! 안전 모드를 수동으로 작동하셨거나 게임이 저번 시도 때 올바르게 가동되지 못해서 #LIGHT_GREEN#안전 모드#WHITE#에 진입하셨습니다.
안전 모드는 모든 그래픽 옵션을 끄고 낮은 FPS를 유지합니다. 이 상태일 때는 게임 플레이를 권장드리지 못합니다. (왜냐하면 정말 고통스럽고 역겹거든요).

비디오 옵션으로 가서 이 메시지가 더 이상 뜨지 않을 때까지, 기능들을 활성화/비활성화한 후 게임을 재시작하는 것을 반복해 보세요.
보통 이런 문제는 셰이더로 인한 일이 잦으니 셰이더 기능들을 먼저 꺼보시는 게 좋겠죠.]], "_t")
t("Message", "메시지", "_t")
t("Duplicate Addon", "중복 애드온", "_t")
t([[Oops! It seems like you have the same addon/dlc installed twice.
This is unsupported and would make many things explode. Please remove one of the copies.

Addon name: #YELLOW#%s#LAST#

Check out the following folder on your computer:
%s
%s
]], [[이런! 같은 애드온이나 DLC를 두 번 설치하신 거 같네요.
그런 기능은 지원하지도 않고 많은 문제를 일으킬 수 있습니다. 중복된 것 중에 하나를 지워 주세요.

애드온 명칭: #YELLOW#%s#LAST#

컴퓨터에서 다음 폴더를 확인해 보세요:
%s
%s
]], "_t")
t("Updating addon: #LIGHT_GREEN#%s", "애드온 업데이트 중: #LIGHT_GREEN#%s", "tformat")
t("Quit", "종료", "_t")
t("Really exit T-Engine/ToME?", "T-Engine/ToME를 종료하시겠습니까?", "_t")
t("Continue", "계속하기", "_t")
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
This is all optional, you are not forced to use this feature at all, but the developer would thank you if you did as it will make balancing easier.]], [[#LIGHT_GREEN#Tales of Maj'Eyal#LAST#에 오신 것을 환영합니다!

혁신적인 방법으로 셀 수 없이 죽으시기 전에 온라인 플레이에 대해 말씀드릴 게 있어요.

이 게임은 #{bold}#싱글 플레이 게임#{normal}#입니다. 하지만 게임 플레이를 돕고, 관련 커뮤니티를 장려하기 위해 다음처럼 많은 온라인 기능도 가지고 있죠:
* 해금 요소나 업적 복사 없이 여러 컴퓨터에서 플레이
* 인게임에서 조언을 듣거나 추억을 얘기하기 위해 친구 플레이어와 채팅
* 킬, 데스, 많이 플레이한 클래스 등에 대한 수치 기록
* 게임 플레이 스타일 향상을 위한 멋진 통계 기능
* 공식 확장팩이나 서드파티 모드를 인게임에서 인스톨
* 게임을 구매하셨거나, 후원하셨다면 구매자/후원자 보너스를 다음 주소에서 확인해 보세요: https://te4.org/
* 개발자에게 게임 밸런스 조절이나 개선점에 대해 조언하기

#LIGHT_BLUE#https://te4.org/#LAST# 사이트에서 친구들에게 과시할 수 있는 유저 페이지를 가지고 계십니다.
이 모든 것은 선택적이며, 이 모든 기능을 꼭 이용하셔야 하는 것은 아닙니다만 이 기능들을 사용해 주시면 밸런싱이 쉬워지기 때문에 개발자로서는 사용해 주시면 감사할 따름입니다.]], "_t")
t("Logging in...", "로그인 중...", "_t")
t("Please wait...", "기다려 주세요...", "_t")
t("Profile logged in!", "프로필 로그인!", "_t")
t("Your online profile is now active. Have fun!", "온라인 프로필이 활성되었습니다. 즐거운 게임하시길!!", "_t")
t("Login failed!", "로그인 실패!", "_t")
t("Check your login and password or try again in in a few moments.", "로그인 상태와 패스워드를 다시 확인해 주시고 잠시 후에 다시 시도해 주세요.", "_t")
t("Registering...", "등록 중...", "_t")
t("Registering on https://te4.org/, please wait...", "https://te4.org/에 등록 중, 기다려 주세요...", "_t")
t("Logged in!", "로그인 성공!", "_t")
t("Profile created!", "프로필 생성됨!", "_t")
t("Profile creation failed!", "프로필 생성 실패!", "_t")
t("Creation failed: %s (you may also register on https://te4.org/)", "생성 실패: %s (다음 주소에서도 등록하실 수 있습니다: https://te4.org/)", "tformat")
t("Try again in in a few moments, or try online at https://te4.org/", "잠시 후 다시 시도해 주시거나 다음 주소에서 생성해 주세요: https://te4.org/", "_t")

------------------------------------------------
section "mod-boot/class/Player.lua"

t("%s available", "%s 사용 가능", "tformat")
t("#00ff00#Talent %s is ready to use.", "#00ff00#기술 %s 사용하실 수 있습니다.", "log", nil, {"을"})
t("LEVEL UP!", "레벨업!", "_t")

------------------------------------------------
section "mod-boot/data/birth/descriptors.lua"

t("base", "베이스", "birth descriptor name")
t("Destroyer", "파괴자", "birth descriptor name")
t("Acid-maniac", "애시드 매니아", "birth descriptor name")

------------------------------------------------
section "mod-boot/data/damage_types.lua"

t("Kill!", "죽임!", "_t")

------------------------------------------------
section "mod-boot/data/general/grids/basic.lua"

t("floor", "바닥", "entity type")
t("floor", "바닥", "entity subtype")
t("floor", "바닥", "entity name")
t("wall", "벽", "entity type")
t("wall", "벽", "entity name")
t("door", "문", "entity name")
t("open door", "열린 문", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/forest.lua"

t("floor", "바닥", "entity type")
t("grass", "잔디", "entity subtype")
t("grass", "잔디", "entity name")
t("wall", "벽", "entity type")
t("tree", "나무", "entity name")
t("flower", "꽃", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/underground.lua"

t("wall", "벽", "entity type")
t("underground", "지하", "entity subtype")
t("crystals", "수정", "entity name")
t("floor", "바닥", "entity type")
t("floor", "바닥", "entity name")

------------------------------------------------
section "mod-boot/data/general/grids/water.lua"

t("floor", "바닥", "entity type")
t("water", "물", "entity subtype")
t("deep water", "깊은 물", "entity name")

------------------------------------------------
section "mod-boot/data/general/npcs/canine.lua"

t("animal", "동물", "entity type")
t("canine", "개과", "entity subtype")
t("wolf", "늑대", "entity name")
t("Lean, mean, and shaggy, it stares at you with hungry eyes.", "비쩍 마르고 털이 덥수룩한 늑대입니다. 굶주린 눈으로 당신을 바라보고 있습니다.", "_t")
t("white wolf", "흰 늑대", "entity name")
t("A large and muscled wolf from the northern wastes. Its breath is cold and icy and its fur coated in frost.", "북쪽 황무지에서 온 커다란 근육질 늑대입니다. 내뱉는 숨결은 서늘하고 털도 서리로 뒤덮여 있습니다.", "_t")
t("warg", "와르그", "entity name")
t("It is a large wolf with eyes full of cunning.", "교활함으로 가득 찬 눈을 가진 거대한 늑대입니다.", "_t")
t("fox", "여우", "entity name")
t("The quick brown fox jumps over the lazy dog.", "다람쥐 헌 쳇바... 아니, 날쌘 갈색 여우가 게으른 개를 뛰어 넘는 법이죠.", "_t")

------------------------------------------------
section "mod-boot/data/general/npcs/skeleton.lua"

t("undead", "언데드", "entity type")
t("skeleton", "스켈레톤", "entity subtype")
t("degenerated skeleton warrior", "낡은 스켈레톤 전사", "entity name")
t("skeleton warrior", "스켈레톤 전사", "entity name")
t("skeleton mage", "스켈레톤 마법사", "entity name")
t("armoured skeleton warrior", "무장한 스켈레톤 전사", "entity name")

------------------------------------------------
section "mod-boot/data/general/npcs/troll.lua"

t("giant", "거인", "entity type")
t("troll", "트롤", "entity subtype")
t("forest troll", "숲 트롤", "entity name")
t("Green-skinned and ugly, this massive humanoid glares at you, clenching wart-covered green fists.", "못생기고 피부가 초록색인, 거대한 인간형 생물이 사마귀로 덮인 녹색 주먹을 움켜쥐고 당신을 노려보고 있습니다.", "_t")
t("stone troll", "바위 트롤", "entity name")
t("A giant troll with scabrous black skin. With a shudder, you notice the belt of dwarf skulls around his massive waist.", "우둘투둘한 검은 가죽을 가진 거대한 트롤입니다. 당신은 그의 거대한 허리춤에 둘러진 허리띠가 드워프 해골로 장식되어 있다는 걸 알아차리고 전율합니다.", "_t")
t("cave troll", "동굴 트롤", "entity name")
t("This huge troll wields a massive spear and has a disturbingly intelligent look in its piggy eyes.", "이 거대한 트롤은 거대한 창을 휘두르며, 이상하게도 그 돼지 같은 눈동자에서 총명한 빛이 엿보입니다.", "_t")
t("mountain troll", "산 트롤", "entity name")
t("A large and athletic troll with an extremely tough and warty hide.", "거대하고 튼튼한 트롤입니다. 가죽이 아주 질기고 사마귀 투성이입니다.", "_t")
t("mountain troll thunderer", "산 트롤 번개 부르미", "entity name")

------------------------------------------------
section "mod-boot/data/talents.lua"

t("misc", "도구", "talent category")
t("Kick", "발차기", "talent name")
t("Acid Spray", "산성 스프레이", "talent name")
t("Manathrust", "마나 쐐기", "talent name")
t("Flame", "불꽃", "talent name")
t("Fireflash", "화염 섬광", "talent name")
t("Lightning", "번개", "talent name")
t("Sunshield", "태양 방패", "talent name")
t("Flameshock", "화염 충격", "talent name")

------------------------------------------------
section "mod-boot/data/timed_effects.lua"

t("Burning from acid", "산성액으로 인한 화상", "_t")
t("#Target# is covered in acid!", "#Target2# 산성액으로 뒤덮였다!", "_t")
t("+Acid", "+산성액", "_t")
t("#Target# is free from the acid.", "#Target2# 산성액으로부터 벗어났다.", "_t")
t("-Acid", "-산성액", "_t")
t("Sunshield", "태양 방패", "_t")

------------------------------------------------
section "mod-boot/data/zones/dungeon/zone.lua"

t("Forest", "숲", "_t")

------------------------------------------------
section "mod-boot/dialogs/Addons.lua"

t("Configure Addons", "애드온 설정", "_t")
t("You can get new addons at #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "새로운 애드온을 다음 주소에서 받으실 수 있습니다: #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", "_t")
t(" and #LIGHT_BLUE##{underline}#Te4.org DLCs#{normal}#", " 그리고 #LIGHT_BLUE##{underline}#Te4.org DLC들#{normal}#", "_t")
t("You can get new addons on #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "새로운 애드온을 다음 장소에서 받으실 수 있습니다: #LIGHT_BLUE##{underline}#Steam Workshop#{normal}#", "_t")
t(", #LIGHT_BLUE##{underline}#Te4.org Addons#{normal}#", ", #LIGHT_BLUE##{underline}#Te4.org 애드온#{normal}#", "_t")
t("Show incompatible", "호환되지 않는 버전 보이기", "_t")
t("Auto-update on start", "시작하면 자동 업데이트", "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")
t("Addon", "애드온", "_t")
t("Active", "켜짐", "_t")
t("#GREY#Developer tool", "#GREY#개발자 도구", "_t")
t("#LIGHT_RED#Donator Status: Disabled", "#LIGHT_RED#후원자 상태: 꺼짐", "_t")
t("#LIGHT_GREEN#Manual: Active", "#LIGHT_GREEN#수동 조작: 켜짐", "_t")
t("#LIGHT_RED#Manual: Disabled", "#LIGHT_RED#수동 조작: 꺼짐", "_t")
t("#LIGHT_GREEN#Auto: Active", "#LIGHT_GREEN#자동 조작: 켜짐", "_t")
t("#LIGHT_RED#Auto: Incompatible", "#LIGHT_RED#자동 조작: 호환되지 않음", "_t")
t("Addon Version", "애드온 버전", "_t")
t("Game Version", "게임 버전", "_t")

------------------------------------------------
section "mod-boot/dialogs/Credits.lua"

t("Project Lead", "프로젝트 리더", "_t")
t("Lead Coder", "코더 리더", "_t")
t("World Builders", "맵 제작자", "_t")
t("Graphic Artists", "그래픽 아티스트", "_t")
t("Expert Shaders Design", "셰이더 디자인", "_t")
t("Soundtracks", "사운드트랙", "_t")
t("Sound Designer", "사운드 엔지니어", "_t")
t("Lore Creation and Writing", "스토리 작가", "_t")
t("Code Heroes", "코드 히어로", "_t")
t("Community Managers", "커뮤니티 관리자", "_t")
t("Text Editors", "텍스트 편집", "_t")
t("Chinese Translation Lead", "중국어 번역 주도", "_t")
t("Chinese Translators", "중국어 번역가들", "_t")
t("Korean Translation", "한국어 번역", "_t")
t("Japanese Translation", "일본어 번역", "_t")
t("The Community", "커뮤니티", "_t")
t("Others", "그 밖에 도움을 주신 분들", "_t")

------------------------------------------------
section "mod-boot/dialogs/FirstRun.lua"

t("Welcome to Tales of Maj'Eyal", "Tales of Maj'Eyal에 오신 것을 환영합니다", "_t")
t("Register now!", "가입하기!", "_t")
t("Login existing account", "기존 계정에 로그인", "_t")
t("Maybe later", "나중에", "_t")
t("#RED#Disable all online features", "#RED#모든 온라인 기능을 끈다", "_t")
t("Disable all connectivity", "모든 연결을 끊는다", "_t")
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

If you disable this option you can always re-activate it in the Online category of the Game Options menu later on.]], [[네트워크 연결을 끊으시려는 중입니다.
다음과 같은 기능들을 사용할 수 없게 됩니다. 이 밖에도 사용할 수 없는 기능이 있을 수 있습니다.
- 플레이어 프로필: 로그인이나 가입을 할 수 없게 됩니다
- 캐릭터 페이지: 캐릭터의 진행 로그를 업로드할 수 없게 되어 영광의 궤적을 보여줄 수 없게 됩니다
- 아이템 금고: 아이템 금고에 접속할 수 없게 됩니다. 아이템을 꺼낼 수도, 보관할 수도 없게 됩니다
- 인게임 채팅: 인게임 채팅은 다른 사람들과 대화하기 위해 온라인 연결을 필요로 합니다. 고로 할 수 없게 됩니다
- 구매자 / 후원자 혜택: 기본 게임은 무료이기 때문에 후원자나 구매자에게 보너스를 주기 위해서는 온라인 프로필을 확인해야 합니다. 고로 혜택을 받으실 수 없게 됩니다.
- 애드온의 쉬운 다운로드 및 설치: 사용할 수 있는 애드온 리스트를 인게임에서 확인할 수 없게 되며, 한 번의 클릭으로 설치하는 것도 할 수 없게 됩니다. 이 모든 것을 수동으로 하셔야 합니다.
- 버전 체크: 애드온 업데이트를 확인할 수 없게 됩니다.
- Discord: Discord를 사용하고 계신다면 Rich Presence 기능을 사용할 수 없게 됩니다.
- 인게임 뉴스: 메인 메뉴가 새로운 업데이트에 대한 사항을 알려주지 않게 됩니다.

#{bold}##CRIMSON#정말 할 수 있는 게 제한되고, 많은 즐거움과 기능을 제거하기 때문에 다른 방법이 없을 경우에만 추천드립니다.#{normal}#

이 옵션을 끄신다면 언제든 게임 옵션의 온라인 항목에서 재활성화할 수 있습니다.]], "_t")
t("Cancel", "취소", "_t")
t("#RED#Disable all!", "#RED#전부 끄기!", "_t")

------------------------------------------------
section "mod-boot/dialogs/LoadGame.lua"

t("Load Game", "게임 불러오기", "_t")
t("Show older versions", "이전 버전 보기", "_t")
t("Ignore unloadable addons", "불러올 수 없는 애드온 무시", "_t")
t("  Play!  ", "  플레이!  ", "_t")
t("Delete", "삭제", "_t")
t([[#{bold}##GOLD#%s: %s#WHITE##{normal}#
Game version: %d.%d.%d
Requires addons: %s

%s]], [[#{bold}##GOLD#%s: %s#WHITE##{normal}#
게임 버전: %d.%d.%d
애드온 요구사항: %s

%s]], "tformat")
t("You can simply grab an older version of the game from where you downloaded it.", "게임을 다운로드한 곳에서 이전 버전을 가지고 오셔도 됩니다.", "_t")
t("You can downgrade the version by selecting it in the Steam's \"Beta\" properties of the game.", "Steam에서 이 게임의 \"Beta\" 항목을 조작하는 것으로 게임을 다운그레이드할 수 있습니다.", "_t")
t("Original game version not found", "원래 게임 버전을 찾을 수 없습니다", "_t")
t([[This savefile was created with game version %s. You can try loading it with the current version if you wish but it is recommended you play it with the old version to ensure compatibility
%s]], [[이 세이브 파일은 다음 게임 버전에서 작성되었습니다: %s. 현재 버전에서 실행하실 수도 있지만 권장하지는 않으며 가급적이면 이전 버전에서 로드하시는 것을 추천드립니다.
%s]], "tformat")
t("Cancel", "취소", "_t")
t("Run with newer version", "최신 버전에서 실행", "_t")
t("Developer Mode", "개발자 모드", "_t")
t("#LIGHT_RED#WARNING: #LAST#Loading a savefile while in developer mode will permanently invalidate it. Proceed?", "#LIGHT_RED#경고: #LAST#개발자 모드에서 세이브 파일을 로드하는 것은 이를 영구적으로 망가트릴 수도 있습니다. 계속하시겠습니까?", "_t")
t("Load anyway", "어쨌든 불러오기", "_t")
t("Delete savefile", "세이브 파일 삭제", "_t")
t("Really delete #{bold}##GOLD#%s#WHITE##{normal}#", "정말로 #{bold}##GOLD#%s#WHITE##{normal}# 삭제하시겠습니까?", "tformat", nil, {"를"})
t("Old game data", "구 버전 데이터", "_t")
t("No data available for this game version.", "이 게임 버전에서 사용할 수 있는 데이터가 없습니다.", "_t")
t("Downloading old game data: #LIGHT_GREEN#", "구 버전 데이터를 다운로드하는 중: #LIGHT_GREEN#", "_t")
t("Old game data for %s correctly installed. You can now play.", "구 버전 데이터 %s 올바르게 설치되었습니다. 이제 플레이하실 수 있습니다.", "tformat", nil, {"가"})
t("Failed to install.", "설치 실패.", "_t")

------------------------------------------------
section "mod-boot/dialogs/MainMenu.lua"

t("Main Menu", "메인 메뉴", "_t")
t("New Game", "새 게임", "_t")
t("Load Game", "게임 불러오기", "_t")
t("Addons", "애드온", "_t")
t("Options", "설정", "_t")
t("Game Options", "게임 설정", "_t")
t("Credits", "개발진들", "_t")
t("Exit", "나가기", "_t")
t("Reboot", "재시작", "_t")
t("Disable animated background", "움직이는 배경화면 비활성화", "_t")
t("#{bold}##B9E100#T-Engine4 version: %d.%d.%d", "#{bold}##B9E100#T-Engine4 버전: %d.%d.%d", "tformat")
t([[#{bold}##GOLD#Ashes of Urh'Rok - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#Many in Maj'Eyal have heard of "demons", sadistic creatures who appear seemingly from nowhere, leaving a trail of suffering and destruction wherever they go.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#New class:#WHITE# Doombringers. These avatars of demonic destruction charge into battle with massive two-handed weapons, cutting swaths of firey devastation through hordes of opponents. Armed with flame magic and demonic strength, they delight in fighting against overwhelming odds
#LIGHT_UMBER#New class:#WHITE# Demonologists. Bearing a shield and the magic of the Spellblaze itself, these melee-fighting casters can grow demonic seeds from their fallen enemies. Imbue these seeds onto your items to gain a wide array of new talents and passive benefits, and summon the demons within them to fight!
#LIGHT_UMBER#New race:#WHITE# Doomelves. Shalore who've taken to the demonic alterations especially well, corrupting their typical abilities into a darker form.
#LIGHT_UMBER#New artifacts, lore, zones, events...#WHITE# For your demonic delight!

]], [[#{bold}##GOLD#울흐'록의 재 - 확장팩#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#마즈'에이알 사람들은 대부분 "악마" 에 대한 이야기를 알고 있습니다. 가학적인 짓을 즐기며 허공에서 갑자기 튀어나오고, 가는 길마다 고통과 파괴를 남기는 존재들이죠.#{normal}##LAST#

#{bold}#특징#{normal}#:
#LIGHT_UMBER#새로운 직업:#WHITE# 파멸의 사도. 이들은 악마와 같은 파괴의 화신으로 거대한 양손 무기를 들고 전장으로 뛰어들어, 적들을 베어버리고 불타는 상흔을 남깁니다.  화염의 마법과 악마의 힘으로 무장한 파멸의 사도들은 압도적인 전력차에 맞서 싸우는 걸 즐깁니다.
#LIGHT_UMBER#새로운 직업:#WHITE# 악마학자. 이들은 방패와 마법폭발의 힘으로 무장한 근접 전투형 주문시전자들로, 쓰러진 적들에게서 악마의 씨앗을 키워낼 수 있습니다.  이 씨앗들을 아이템에 섞어 넣어 다양한 새 기술과 지속형 이득을 얻을 수 있고, 악마들도 동료로 소환할 수 있습니다!
#LIGHT_UMBER#새로운 종족:#WHITE# 둠엘프. 악마들의 처치를 특히 잘 받은 샬로레들로, 원래 종족 특징들이 어두운 쪽으로 타락한 상태입니다.
#LIGHT_UMBER#새로운 유물, 이야기, 장소, 사건들...#WHITE# 모두가 당신의 악마적인 즐거움을 위해 준비되어 있습니다!

]], "_t")
t("#LIGHT_GREEN#Installed", "#LIGHT_GREEN#설치됨", "_t")
t("#YELLOW#Not installed - Click to download / purchase", "#YELLOW#설치되지 않음 - 클릭 시 다운로드 / 구매", "_t")
t([[#{bold}##GOLD#Embers of Rage - Expansion#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#One year has passed since the one the Orcs call the "Scourge from the West" came and single-handedly crushed the Orc Prides of Grushnak, Vor, Gorbat, and Rak'Shor.  The Allied Kingdoms, now linked by farportal to their distant, long-lost Sunwall allies, have helped them conquer most of Var'Eyal.  The few remnants of the ravaged Prides are caged...  but one Pride remains.#{normal}##LAST#

#{bold}#Features#{normal}#:
#LIGHT_UMBER#A whole new campaign:#WHITE# Set one year after the events of the main game, the final destiny of the Orc Prides is up to you. Discover the Far East like you never knew it. 
#LIGHT_UMBER#New classes:#WHITE# Sawbutchers, Gunslingers, Psyshots, Annihilators and Technomanchers. Harness the power of steam to power deadly contraptions to lay waste to all those that oppose the Pride!  
#LIGHT_UMBER#New races:#WHITE# Orcs, Yetis, Whitehooves. Discover the orcs and their unlikely 'allies' as you try to save your Pride from the disasters caused by the one you call 'The Scourge from the West'.
#LIGHT_UMBER#Tinker system:#WHITE# Augment your items with powerful crafted tinkers. Attach rockets to your boots, gripping systems to your gloves and many more.
#LIGHT_UMBER#Salves:#WHITE# Bound to the tinker system, create powerful medical salves to inject into your skin, replacing the infusions§runes system.
#LIGHT_UMBER#A ton#WHITE# of artifacts, lore, zones, events... 

]], [[#{bold}##GOLD#분노의 잉걸불 - 확장팩#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#오크들이 흔히 "서쪽에서 온 재앙"이라 부르는 자가 홀로 그루쉬낙, 보르, 고르뱃, 락'쇼르 긍지를 파괴한지 1년이 지났습니다.  왕국연합은 오랫동안 잊혀져 있던 태양의 장벽과 장거리 차원문을 통해 연결되었으며, 그들이 바르'에이알의 대부분의 지역을 점령하는데 도움을 주었습니다.  파괴된 긍지들의 잔존병들은 감금되어 있지만...  아직 긍지가 하나 남아 있습니다.#{normal}##LAST#

#{bold}#특징#{normal}#:
#LIGHT_UMBER#완전히 새로운 캠페인:#WHITE# 메인 게임 이후 1년 뒤의 이야기를 다룹니다. 오크 긍지들의 마지막 운명이 당신에게 달려 있습니다. 극동의 미지의 지역을 탐험 해보세요. 
#LIGHT_UMBER#새로운 직업:#WHITE# 톱 도살자, 총잡이, 염동사수, 섬멸자, 마도공학자. 증기의 힘으로 치명적인 기계를 활성화시켜, 긍지에 맞서는 모든 이들을 초토화하세요!  
#LIGHT_UMBER#새로운 종족:#WHITE# 오크, 예티, 화이트후프.  당신이 '서쪽에서 온 재앙'이라고 부르는 자가 일으킨 참사에서 긍지를 구하는 동안 오크와 그들의 예상 밖의 동맹들에 대해 알아보세요.
#LIGHT_UMBER#발명품:#WHITE# 강력한 발명품으로 장비를 강화하세요. 신발에 로켓을 달고, 장갑에 강철 같은 손아귀를 붙이는 등, 다양한 방법으로 장비에 특수한 능력을 부여할 수 있습니다.
#LIGHT_UMBER#연고:#WHITE# 발명품 시스템과 연계해, 강력한 의료용 연고를 제작해 피부에 투여하세요. 주입물과 룬을 대체합니다.
#LIGHT_UMBER#무수히 많은#WHITE# 유물, 이야기, 장소, 사건들... 

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

]], [[#{bold}##GOLD#금단의 교단 - 확장팩#LAST##{normal}#
#{italic}##ANTIQUE_WHITE#모험가들이라고 모두 재물을 찾고 있는 건 아니고, 세상을 지키고 있다고 모두 선행을 염두에 두고 있는 것도 아닙니다. 최근에 공포체들을 목격하는 빈도가 엄청하게 증가했습니다. 익숙한 길에서 벗어나버린 사람들은 몇 년 뒤에야 발견될 것이고, 그들은 무시무시하게 변이되어 있고, 또 약간 미친 상태일 겁니다. 물론 발견이 된다면 말이지요. 마즈'에이알 지하 깊은 곳에 무언가가 있다는 게 확실해지고 있습니다. 그 무언가가 바로 당신입니다.#{normal}##LAST#

#{bold}#특징#{normal}#:
#LIGHT_UMBER#새로운 직업:#WHITE# 뒤틀린 자. 타락한 힘 앞에 무릎 꿇은 이들로, 스스로를 서서히 공포체로 변화시키고, 자신의 뜻에 따라 공포체들을 소환하며, 피부를 벗어버리고 얼굴을 녹여내 적들을 공격합니다. 촉수로 변한 팔을 갖고 있는데, 누가 당신을 막을 수 있을까요?
#LIGHT_UMBER#새로운 직업:#WHITE# 엔트로피 광신도. 광기와 엔트로피의 힘을 제어하여 정상적인 물리법칙을 풀어헤칩니다. 이 주문 시전자는 회복을 공격으로 변화시키고, 공허의 힘을 불러와 적을 먼지로 화하게 할 수 있습니다.
#LIGHT_UMBER#새로운 종족:#WHITE# 드렘. 오염된 드워프의 하위 종족으로, 티끝 같은 이성을 유지하여 지성이 없는 공포체로 완전히 변하는 것을 막았습니다. 이들은 광분 상태로 돌입할 수 있고 공포체를 소환하는 법마저 익힐 수 있습니다.
#LIGHT_UMBER#새로운 종족:#WHITE# 크로그. 본래 자신들을 죽여야 했던 자들의 의해 변형된 오우거들입니다. 이들의 강력한 일격은 적들을 기절시킬 수 있고, 양 손에 한손 무기를 하나씩 장비할 수 있습니다.
#LIGHT_UMBER#새로운 지역:#WHITE# 재앙의 구덩이를 탐험하고, 거대한 지렁이에게서 빠져나가기 위해 싸우고 (어떻게 지렁이 안에 *들어* 갔는지는 묻지 마세요), 비술의 출로의 경이들을 발견하고, 또 기이하고 촉수로 가득 찬 장소로 떠나세요!
#LIGHT_UMBER#새로운 공포:#WHITE# 눈부신 공포가 마음에 드시나요? 불사르는 빛의 공포도 아주 마음에 드실 겁니다! 또 엔트로피의 조각들도요. 또 기타 등등도요...
#LIGHT_UMBER#지긋지긋한 내 머리:#WHITE#  멋지고 편안한 공포체로 바꿔버립시다!
#LIGHT_UMBER#무수히 많은#WHITE# 유물, 이야기, 사건들... 

]], "_t")
t("#GOLD#Online Profile", "#GOLD#온라인 프로필", "_t")
t("Login", "로그인", "_t")
t("Register", "가입", "_t")
t("Username: ", "유저명: ", "_t")
t("Password: ", "비밀번호: ", "_t")
t("Login with Steam", "Steam으로 로그인", "_t")
t("#GOLD#Online Profile#WHITE#", "#GOLD#온라인 프로필#WHITE#", "_t")
t("#LIGHT_BLUE##{underline}#Logout", "#LIGHT_BLUE##{underline}#로그아웃", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Password", "비밀번호", "_t")
t("Your password is too short", "비밀번호가 너무 짧습니다.", "_t")
t("Login...", "로그인 중...", "_t")
t("Logging in your account, please wait...", "로그인 중 입니다. 잠시만 기다려주세요...", "_t")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.", "_t")
-- untranslated text
--[==[
t("#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "#LIGHT_BLUE##{underline}#%s#LAST##{normal}#", "tformat")
--]==]


------------------------------------------------
section "mod-boot/dialogs/NewGame.lua"

t("New Game", "새 게임", "_t")
t("Show all versions", "모든 버전 보이기", "_t")
t("Show incompatible", "호환되지 않는 버전 보이기", "_t")
t([[You can get new games at
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], [[다음 사이트에서 최신 버전을 다운로드 할 수 있습니다
#LIGHT_BLUE##{underline}#https://te4.org/games#{normal}#]], "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")
t("Enter your character's name", "캐릭터 이름을 입력해주세요", "_t")
t("Overwrite character?", "캐릭터를 덮어씌우시겠습니까?", "_t")
t("There is already a character with this name, do you want to overwrite it?", "이미 존재하는 캐릭터의 이름입니다만, 덮어씌우시겠습니까?", "_t")
t("No", "아니요", "_t")
t("Yes", "네", "_t")
t("This game is not compatible with your version of T-Engine, you can still try it but it might break.", "이 게임은 현재 T-Engine 버전과 호환되지 않기에 실행 시 심각한 오류가 발생할 수도 있습니다.", "_t")

------------------------------------------------
section "mod-boot/dialogs/Profile.lua"

t("Player Profile", "플레이어 프로필", "_t")
t("Logout", "로그아웃", "_t")
t("You are logged in", "로그인 됨", "_t")
t("Do you want to log out?", "정말 로그아웃하시겠습니까?", "_t")
t("Log out", "로그아웃", "_t")
t("Cancel", "취소", "_t")
t("Login", "로그인", "_t")
t("Create Account", "계정 생성", "_t")

------------------------------------------------
section "mod-boot/dialogs/ProfileLogin.lua"

t("Online profile ", "온라인 프로필 ", "_t")
t("Username: ", "유저명: ", "_t")
t("Password: ", "비밀번호: ", "_t")
t("Login", "로그인", "_t")
t("Cancel", "취소", "_t")
t("Password again: ", "비밀번호 재입력: ", "_t")
t("Email: ", "이메일: ", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "#{bold}#매우 드물게#{normal}# (1년에 한두 통 정도) 발송되는 중요한 게임 이벤트에 대한 메일 수신 수락.", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "이 게임을 플레이 하려면 최소 16세 이상이거나 보호자의 허락이 있어야 합니다.", "_t")
t("Create", "제작", "_t")
t("Privacy Policy (opens in browser)", "개인정보 보호정책 (브라우저로 열기)", "_t")
t("Password", "비밀번호", "_t")
t("Password mismatch!", "비밀번호가 맞지 않습니다!", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Your password is too short", "비밀번호가 너무 짧습니다.", "_t")
t("Email", "이메일", "_t")
t("Your email seems invalid", "올바르지 않은 이메일 같습니다", "_t")
t("Age Check", "연령 확인", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "최소 16세 이상, 또는 보호자의 허락이 있어야 게임을 플레이 할 수 있습니다.", "_t")

------------------------------------------------
section "mod-boot/dialogs/ProfileSteamRegister.lua"

t("Steam User Account", "Steam 유저 계정", "_t")
t([[Welcome to #GOLD#Tales of Maj'Eyal#LAST#.
To enjoy all the features the game has to offer it is #{bold}#highly#{normal}# recommended that you register your steam account.
Luckily this is very easy to do: you only require a profile name and optionally an email (we send very few email, maybe two a year at most).
]], [[#GOLD#테일즈 오브 마즈'에이알#LAST#에 어서 오십시오.
이 게임의 모든 기능을 즐기기 위해서 당신의 Steam 계정을 등록하는 것을 #{bold}#강력#{normal}# 추천합니다.
정말 다행스럽게도 아주 손쉽게 가능합니다. 프로필에 사용할 닉네임과 부가적으로 이메일 주소만 있으면 됩니다 (저희는 이메일을 거의 보내지 않습니다. 2년에 한 번 보낼까 말까죠).
]], "_t")
t("Username: ", "유저명: ", "_t")
t("Email: ", "이메일: ", "_t")
t("Accept to receive #{bold}#very infrequent#{normal}# (a few per year) mails about important game events from us.", "#{bold}#매우 드물게#{normal}# (1년에 한두 통 정도) 발송되는 중요한 게임 이벤트에 대한 메일 수신 수락.", "_t")
t("You at least 16 years old, or have parental authorization to play the game.", "이 게임을 플레이 하려면 최소 16세 이상이거나 보호자의 허락이 있어야 합니다.", "_t")
t("Register", "가입", "_t")
t("Cancel", "취소", "_t")
t("Privacy Policy (opens in browser)", "개인정보 보호정책 (브라우저로 열기)", "_t")
t("Username", "유저명", "_t")
t("Your username is too short", "유저명이 너무 짧습니다.", "_t")
t("Email", "이메일", "_t")
t("Your email does not look right.", "올바르지 않은 이메일 같습니다.", "_t")
t("Age Check", "연령 확인", "_t")
t("You need to be 16 years old or more or to have parental authorization to play this game.", "최소 16세 이상, 또는 보호자의 허락이 있어야 게임을 플레이 할 수 있습니다.", "_t")
t("Registering...", "등록 중...", "_t")
t("Registering on https://te4.org/, please wait...", "https://te4.org/에 등록 중, 기다려 주세요...", "_t")
t("Steam client not found.", "Steam 클라이언트를 찾을 수 없습니다.", "_t")
t("Error", "오류", "_t")
t("Username or Email already taken, please select an other one.", "입력하신 유저명 또는 이메일은 이미 사용 중 입니다.", "_t")

------------------------------------------------
section "mod-boot/dialogs/UpdateAll.lua"

t("Update all game modules", "모든 게임 모듈 업데이트", "_t")
t([[All those components will be updated:
]], [[모든 구성 요소 업데이트 됩니다:
]], "_t")
t("Component", "구성 요소", "_t")
t("Version", "버전", "_t")
t("Nothing to update", "업데이트 할 것이 없습니다", "_t")
t("All your game modules are up to date.", "모든 게임 모듈이 최신 상태입니다.", "_t")
t("Game: #{bold}##GOLD#", "게임: #{bold}##GOLD#", "_t")
t("Engine: #{italic}##LIGHT_BLUE#", "엔진: #{italic}##LIGHT_BLUE#", "_t")
t("Error!", "에러!", "_t")
t([[There was an error while downloading:
]], [[다운로드 중에 에러가 발생했습니다 downloading:
]], "_t")
t("Downloading: ", "다운로드 중: ", "_t")
t("Update", "업데이트", "_t")
t("All updates installed, the game will now restart", "모든 업데이트가 설치되었습니다. 게임이 재시작 됩니다", "_t")

------------------------------------------------
section "mod-boot/dialogs/ViewHighScores.lua"

t("View High Scores", "고득점 보기", "_t")
t("Game Module", "게임 모듈", "_t")
t("Version", "버전", "_t")
t("World", "세계", "_t")
t([[#{bold}##GOLD#%s#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s#GREEN# 고득점#WHITE##{normal}#

]], "tformat")
t([[#{bold}##GOLD#%s(%s)#GREEN# High Scores#WHITE##{normal}#

]], [[#{bold}##GOLD#%s(%s)#GREEN# 고득점#WHITE##{normal}#

]], "tformat")

------------------------------------------------
section "mod-boot/init.lua"

t("Tales of Maj'Eyal Main Menu", "테일즈 오브 마즈'에이알 메인 메뉴", "init.lua long_name")
t([[Bootmenu!
]], [[부트메뉴!
]], "init.lua description")

------------------------------------------------
section "mod-boot/load.lua"

t("Strength", "힘", "stat name")
t("str", "힘", "stat short_name")
t("Dexterity", "민첩", "stat name")
t("dex", "민첩", "stat short_name")
t("Constitution", "체격", "stat name")
t("con", "체격", "stat short_name")

