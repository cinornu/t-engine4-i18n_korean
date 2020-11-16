------------------------------------------------
section "tome-addon-dev/init.lua"

t("ToME Addon's Development Tools", "ToME 애드온 개발 도구", "init.lua long_name")
t("Provides tools to develop and publish addons.", "애드온을 개발하고 출시할 수 있는 도구를 제공합니다.", "init.lua description")

------------------------------------------------
section "tome-addon-dev/overload/engine/i18nhelper/ArrangeText.lua"

t("Success", "성공", "_t")
-- new text
--[==[
t([[[WARNING]Mismatched translation for %s(%s): 
Last occurance: %s (from section %s)
Current occurance: %s (from section %s)
]], [[[WARNING]Mismatched translation for %s(%s): 
Last occurance: %s (from section %s)
Current occurance: %s (from section %s)
]], "log")
t([[Translation text checked.
Logs written to %s]], [[Translation text checked.
Logs written to %s]], "tformat")
t("\
-- new text\
", "\
-- new text\
", "_t")
t("\
-- untranslated text\
", "\
-- untranslated text\
", "_t")
t("\
-- old translated text\
", "\
-- old translated text\
", "_t")
t([[Translation text rearranged.
Logs written to %s]], [[Translation text rearranged.
Logs written to %s]], "tformat")
--]==]


------------------------------------------------
section "tome-addon-dev/overload/engine/i18nhelper/Extractor.lua"

t("Success", "성공", "_t")
-- new text
--[==[
t("Luafish parse error on file %s: %s", "Luafish parse error on file %s: %s", "log")
t("Error writing file %s", "Error writing file %s", "log")
t("MD5 matched for part %s, skipped.", "MD5 matched for part %s, skipped.", "log")
t("Extracting text", "Extracting text", "_t")
t("Processing source code of %s", "Processing source code of %s", "tformat")
t("Translation text extracted.", "Translation text extracted.", "_t")
--]==]


------------------------------------------------
section "tome-addon-dev/overload/engine/i18nhelper/FSHelper.lua"


-- new text
--[==[
t("Error %s", "Error %s", "log")
t("Calculating MD5", "Calculating MD5", "_t")
t("Calculating MD5 for %s", "Calculating MD5 for %s", "tformat")
--]==]


------------------------------------------------
section "tome-addon-dev/superload/mod/dialogs/debug/AddonDeveloper.lua"

t("Addon Developer", "애드온 개발자", "_t")
t([[- Your profile has been enabled for addon uploading, you can go to #{italic}##LIGHT_BLUE#https://te4.org/addons/tome#LAST##{normal}# and upload your addon.
]], [[- 애드온 업로드 기능이 활성화된 계정이며, #{italic}##LIGHT_BLUE#https://te4.org/addons/tome#LAST##{normal}# 에서 애드온을 업로드할 수 있습니다.
]], "_t")
t("Archive for %s", "%s 저장소", "tformat")
t([[Addon archive created:
- Addon file: #LIGHT_GREEN#%s#LAST# in folder #{bold}#%s#{normal}#
- Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard)
%s
]], [[애드온 저장소 생성됨:
- 애드온 파일: #LIGHT_GREEN#%s#LAST# 폴더 내 #{bold}#%s#{normal}#
- 애드온 MD5: #LIGHT_BLUE#%s#LAST# (클립보드에 복사됨)
%s
]], "_t", {2,1,3})
t("Registering new addon", "새로운 애드온 등록 중", "_t")
t("Addon init.lua must contain a tags table, i.e: tags={'foo', 'bar'}", "애드온의 init.lua에는 태그 테이블이 포함되어야 합니다. 예시: tags={'foo', 'bar'}", "_t")
t("Addon init.lua must contain a description field", "애드온의 init.lua에는 설명 필드가 포함되어야 합니다.", "_t")
t("Addon: %s", "애드온: %s", "tformat")
t("Addon #LIGHT_GREEN#%s#LAST# registered. You may now upload a version for it.", "#LIGHT_GREEN#%s#LAST# 애드온이 등록되었습니다. 이제 해당 버전을 업로드할 수 있습니다.", "tformat")
t("Addon #LIGHT_RED#%s#LAST# not registered: %s", "#LIGHT_RED#%s#LAST# 애드온이 등록되지 않았습니다: %s", "tformat")
t("unknown reason", "알 수 없는 이유", "_t")
t("Uploading addon", "애드온 업로드 중", "_t")
t("Addon #LIGHT_GREEN#%s#LAST# uploaded, players may now play with it!", "#LIGHT_GREEN#%s#LAST# 애드온이 업로드되었습니다. 이제 다른 플레이어들도 사용할 수 있습니다!", "tformat")
t("Addon #LIGHT_RED#%s#LAST# not upload: %s", "#LIGHT_RED#%s#LAST# 애드온을 업로드할 수 없습니다: %s", "tformat")
t("Connecting to server", "서버에 접속 중", "_t")
t("Steam Workshop: %s", "Steam 창작마당: %s", "tformat")
t("Update error: %s", "업데이트 오류: %s", "tformat")
t("unknown", "알 수 없음", "_t")
t("Uploading addon to Steam Workshop", "Steam 창작마당에 애드온 업로드 중", "_t")
t("There was an error uploading the addon.", "애드온을 업로드하는 중 오류가 발생했습니다.", "_t")
t([[Addon succesfully uploaded to the Workshop.
You need to accept Steam Workshop Agreement in your Steam Client before the addon is visible to the community.]], [[애드온이 성공적으로 창작마당에 업로드되었습니다.
Steam 클라이언트에서 창작마당 이용 약관에 동의해야 커뮤니티에 업로드한 애드온이 표시됩니다. ]], "_t")
t("Go to Workshop", "창작마당으로 가기", "_t")
t("Later", "나중에", "_t")
t("Addon succesfully uploaded to the Workshop.", "애드온을 창작마당에 업로드하는데 성공했습니다..", "_t")
t("Uploading addon preview to Steam Workshop", "Steam 창작마당에 애드온 미리보기 업로드 중", "_t")
t("There was an error uploading the addon preview.", "애드온 미리보기를 업로드 중 오류가 발생했습니다.", "_t")
t("Addon update & preview succesfully uploaded to the Workshop.", "창작마당의 애드온 업데이트 & 미리보기를 업로드하는데 성공했습니다.", "_t")
t("Addon update succesfully uploaded to the Workshop.", "창작마당의 애드온 업데이트를 성공적으로 업로드했습니다..", "_t")
t("Choose an addon for MD5", "애드온의 MD5 선택", "_t")
t("MD5 for %s", "%s의 MD5", "tformat")
t([[Addon MD5: #LIGHT_BLUE#%s#LAST# (this was copied to your clipboard).
However you should'nt need that anymore, you can upload your addon directly from here.]], [[애드온 MD5: #LIGHT_BLUE#%s#LAST# (클립보드에 항목이 복사됨).
더 이상 필요없겠지만, 이 곳에서 바로 애드온을 업로드할 수 있습니다.]], "tformat")
t("Choose an addon to archive", "애드온 저장소 선택", "_t")
t("Choose an addon to register", "애드온 게시자 선택", "_t")
t("Choose an addon to publish", "애드온 게시처 선택", "_t")
t("Name for this addon's release", "애드온 게시명 입력", "_t")
t("Name", "이름", "_t")
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
section "tome-addon-dev/superload/mod/dialogs/debug/DebugMain.lua"

t("Addon Developer", "애드온 개발자", "_t")
-- new text
--[==[
t("Translation Tool", "Translation Tool", "_t")
--]==]


------------------------------------------------
section "tome-addon-dev/superload/mod/dialogs/debug/ExampleAddonMaker.lua"

t("Finish", "끝내기", "_t")
t("Cancel", "취소", "_t")
t("Failure", "실패", "_t")
t("Success", "성공", "_t")
-- new text
--[==[
t("DEBUG -- Create Translation Addon", "DEBUG -- Create Translation Addon", "_t")
t("", "", "_t")
t("#LIGHT_GREEN#Locale Code:#LAST# ", "#LIGHT_GREEN#Locale Code:#LAST# ", "_t")
t("#LIGHT_GREEN#Language Name:#LAST# ", "#LIGHT_GREEN#Language Name:#LAST# ", "_t")
t("Addon %s already exists", "Addon %s already exists", "tformat")
t([[Fail when copying file to /addons/%s:
%s]], [[Fail when copying file to /addons/%s:
%s]], "tformat")
t([[Addon %s successfully created
Newly created addon is stored in %s]], [[Addon %s successfully created
Newly created addon is stored in %s]], "tformat")
t("\
ToME4 is about to relaunch and change locale to %s, proceed?", "\
ToME4 is about to relaunch and change locale to %s, proceed?", "tformat")
--]==]


------------------------------------------------
section "tome-addon-dev/superload/mod/dialogs/debug/ReleaseTranslation.lua"

t("Failure", "실패", "_t")
t("Success", "성공", "_t")
-- new text
--[==[
t("Choose addon", "Choose addon", "_t")
t("Choose the addon you want to copy translation file to.", "Choose the addon you want to copy translation file to.", "_t")
t([[Fail when copying file to %s:
%s]], [[Fail when copying file to %s:
%s]], "tformat")
t([[Translation text copied to %s
Logs written to %s]], [[Translation text copied to %s
Logs written to %s]], "tformat")
--]==]


------------------------------------------------
section "tome-addon-dev/superload/mod/dialogs/debug/TranslationTool.lua"


-- new text
--[==[
t("Translation Toolkit", "Translation Toolkit", "_t")
t("Change locale", "Change locale", "_t")
t("Enter locale code", "Enter locale code", "_t")
t("Change working locale (current: %s)", "Change working locale (current: %s)", "tformat")
t("Create translation addon", "Create translation addon", "_t")
t("Extract text index", "Extract text index", "_t")
t("Rearrange translation files", "Rearrange translation files", "_t")
t("Check translation files", "Check translation files", "_t")
t("Release translation as addon", "Release translation as addon", "_t")
--]==]


