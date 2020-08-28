locale "ko_KR"

------------------------------------------------
section "game/addons/tome-addon-dev/init.lua"

t("ToME Addon's Development Tools", "ToME 애드온 개발 도구", "init.lua long_name")
t("Provides tools to develop and publish addons.", "애드온을 개발하고 출시할 수 있는 도구를 제공합니다.", "init.lua description")


------------------------------------------------
section "game/addons/tome-addon-dev/superload/mod/dialogs/debug/AddonDeveloper.lua"

t("Addon Developer", "애드온 개발자", "_t")
t([[- Your profile has been enabled for addon uploading, you can go to #{italic}##LIGHT_BLUE#http://te4.org/addons/tome#LAST##{normal}# and upload your addon.
]], [[- 애드온 업로드 기능이 활성화된 계정이며, #{italic}##LIGHT_BLUE#http://te4.org/addons/tome#LAST##{normal}# 에서 애드온을 업로드할 수 있습니다.
]], "_t")
t([[Addon archive created:
- Addon file: #LIGHT_GREEN#%s#LAST# in folder #{bold}#%s#{normal}#
- Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard)
%s
]], [[애드온 저장소 생성됨:
- 애드온 파일: #LIGHT_GREEN#%s#LAST# 폴더 내 #{bold}#%s#{normal}#
- 애드온 MD5: #LIGHT_BLUE#%s#LAST# (클립보드에 복사됨)
%s
]], "_t", {2,1,3})
t("Archive for %s", "%s 저장소", "tformat")
t("Addon #LIGHT_GREEN#%s#LAST# registered. You may now upload a version for it.", "#LIGHT_GREEN#%s#LAST# 애드온이 등록되었습니다. 이제 해당 버전을 업로드할 수 있습니다.", "tformat")
t("Addon #LIGHT_RED#%s#LAST# not registered: %s", "#LIGHT_RED#%s#LAST# 애드온이 등록되지 않았습니다: %s", "tformat")
t("Addon #LIGHT_GREEN#%s#LAST# uploaded, players may now play with it!", "#LIGHT_GREEN#%s#LAST# 애드온이 업로드되었습니다. 이제 다른 플레이어들도 사용할 수 있습니다!", "tformat")
t("Addon #LIGHT_RED#%s#LAST# not upload: %s", "#LIGHT_RED#%s#LAST# 애드온을 업로드할 수 없습니다: %s", "tformat")
t("Uploading addon", "애드온 업로드 중", "_t")
t("unknown reason", "알 수 없는 이유", "_t")
t("Addon init.lua must contain a tags table, i.e: tags={'foo', 'bar'}", "애드온의 init.lua에는 태그 테이블이 포함되어야 합니다. 예시: tags={'foo', 'bar'}", "_t")
t("Addon init.lua must contain a description field", "애드온의 init.lua에는 설명 필드가 포함되어야 합니다.", "_t")
t("Registering new addon", "새로운 애드온 등록 중", "_t")
t("Connecting to server", "서버에 접속 중", "_t")
t("Update error: %s", "업데이트 오류: %s", "tformat")
t("unknown", "알 수 없음", "_t")
t("Uploading addon to Steam Workshop", "Steam 창작마당에 애드온 업로드 중", "_t")
t([[Addon succesfully uploaded to the Workshop.
You need to accept Steam Workshop Agreement in your Steam Client before the addon is visible to the community.]], [[애드온이 성공적으로 창작마당에 업로드되었습니다.
Steam 클라이언트에서 창작마당 이용 약관에 동의해야 커뮤니티에 업로드한 애드온이 표시됩니다. ]], "_t")
t("Go to Workshop", "창작마당으로 가기", "_t")
t("Later", "나중에", "_t")
t("Addon succesfully uploaded to the Workshop.", "애드온을 창작마당에 업로드하는데 성공했습니다..", "_t")
t("Addon: %s", "애드온: %s", "tformat")
t("Uploading addon preview to Steam Workshop", "Steam 창작마당에 애드온 미리보기 업로드 중", "_t")
t("There was an error uploading the addon preview.", "애드온 미리보기를 업로드 중 오류가 발생했습니다.", "_t")
t("Addon update & preview succesfully uploaded to the Workshop.", "창작마당의 애드온 업데이트 & 미리보기를 업로드하는데 성공했습니다.", "_t")
t("There was an error uploading the addon.", "애드온을 업로드하는 중 오류가 발생했습니다.", "_t")
t("Addon update succesfully uploaded to the Workshop.", "창작마당의 애드온 업데이트를 성공적으로 업로드했습니다..", "_t")
t("Steam Workshop: %s", "Steam 창작마당: %s", "tformat")
t("Choose an addon for MD5", "애드온의 MD5 선택", "_t")
t([[Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard).
However you should'nt need that anymore, you can upload your addon directly from here.]], [[애드온 MD5: #LIGHT_BLUE#%s#LAST# (클립보드에 항목이 복사됨).
더 이상 필요없겠지만, 이 곳에서 바로 애드온을 업로드할 수 있습니다.]], "tformat")
t("MD5 for %s", "%s의 MD5", "tformat")
t("Choose an addon to archive", "애드온 저장소 선택", "_t")
t("Choose an addon to register", "애드온 게시자 선택", "_t")
t("Choose an addon to publish", "애드온 게시처 선택", "_t")
t("Name", "이름", "_t")
t("Name for this addon's release", "애드온 게시명 입력", "_t")
t("Choose an addon to publish to Steam Workshop (needs to have been published to te4.org first)", "Steam 창작마당에 게시할 애드온 선택 (먼저 te4.org에 애드온을 게시해야 합니다.)", "_t")
t("Addon preview", "애드온 미리보기", "_t")
t([[Addons on Steam Workshop need a "preview" image for the listing.
The game has generated a default one, however it is best if you make a custom one and place it in the folder #LIGHT_GREEN#%s#LAST# named #LIGHT_BLUE#%s#LAST# (512x512 is a good size for it)
You can still upload now and place it later.]], [[Steam 창작마당에서는 애드온의 미리보기 이미지가 필요합니다.
게임이 기본 미리보기 이미지를 만들었지만, 다른 애드온 미리보기 이미지를 사용하고 싶다면 #LIGHT_GREEN#%s#LAST# 폴더 내에 #LIGHT_BLUE#%s#LAST# 라는 이름의 파일로 넣어주세요.(512x512 크기의 이미지를 권장합니다.)
먼저 업로드 후 나중에 파일을 넣어도 됩니다.]], "_t")
t("Upload now", "지금 업로드", "_t")
t("Wait", "대기", "_t")
t("Generate Addon's MD5", "애드온의 MD5 생성", "_t")
t("Register new Addon", "새로운 애드온 등록", "_t")
t("Publish Addon to te4.org", "te4.org에 애드온 게시", "_t")
t("Publish Addon to Steam Workshop", "Steam 창작마당에 애드온 게시", "_t")


------------------------------------------------
section "game/addons/tome-addon-dev/superload/mod/dialogs/debug/DebugMain.lua"

t("Addon Developer", "애드온 개발자", "_t")


