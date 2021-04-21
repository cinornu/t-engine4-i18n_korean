@echo off
title ToME4 dlc 임시 한글 패치 주입기
echo * initialize...
mkdir temp
echo * tome-addon-dev unpacking...
7za x -y addons\tome-addon-dev_KR.teaa -o"temp\tome-addon-dev_KR"
echo * patching...
xcopy /Y game\addons\tome-addon-dev\data\locales\ko_KR.lua temp\tome-addon-dev_KR\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 tome-addon-dev_KR.zip -r temp\tome-addon-dev_KR\.
echo * Finalizing...
del /F addons\tome-addon-dev_KR.teaa
ren tome-addon-dev_KR.zip tome-addon-dev_KR.teaa
move tome-addon-dev_KR.teaa addons\
rmdir /S /Q temp\tome-addon-dev_KR
cls

echo * tome-items-vault unpacking...
7za x -y addons\tome-items-vault_KR.teaa -o"temp\tome-items-vault_KR"
echo * patching...
xcopy /Y game\addons\tome-items-vault\data\locales\ko_KR.lua temp\tome-items-vault_KR\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 tome-items-vault_KR.zip -r temp\tome-items-vault_KR\.
echo * Finalizing...
del /F addons\tome-items-vault_KR.teaa
ren tome-items-vault_KR.zip tome-items-vault_KR.teaa
move tome-items-vault_KR.teaa addons\
rmdir /S /Q temp\tome-items-vault_KR
cls

echo * tome-possessors unpacking...
7za x -y addons\tome-possessors_KR.teaa -o"temp\tome-possessors_KR"
echo * patching...
xcopy /Y game\addons\tome-possessors\data\locales\ko_KR.lua temp\tome-possessors_KR\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 tome-possessors_KR.zip -r temp\tome-possessors_KR\.
echo * Finalizing...
del /F addons\tome-possessors_KR.teaa
ren tome-possessors_KR.zip tome-possessors_KR.teaa
move tome-possessors_KR.teaa addons\
rmdir /S /Q temp\tome-possessors_KR
cls

echo * ashes-urhrok unpacking...
7za x -y dlcs\ashes-urhrok-KR.teaac -o"temp\ashes-urhrok-KR"
echo * patching...
xcopy /Y game\dlcs\tome-ashes-urhrok\data\locales\ko_KR.lua temp\ashes-urhrok-KR\tome-ashes-urhrok\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 ashes-urhrok-KR.zip -r temp\ashes-urhrok-KR\.
echo * Finalizing...
del /F dlcs\ashes-urhrok-KR.teaac
ren ashes-urhrok-KR.zip ashes-urhrok-KR.teaac
move ashes-urhrok-KR.teaac dlcs\
rmdir /S /Q temp\ashes-urhrok-KR
cls

echo * cults unpacking...
7za x -y dlcs\cults-KR.teaac -o"temp\cults-KR"
echo * patching...
xcopy /Y game\dlcs\tome-cults\data\locales\ko_KR.lua temp\cults-KR\tome-cults\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 cults-KR.zip -r temp\cults-KR\.
echo * Finalizing...
del /F dlcs\cults-KR.teaac
ren cults-KR.zip cults-KR.teaac
move cults-KR.teaac dlcs\
rmdir /S /Q temp\cults-KR
cls

echo * orcs unpacking...
7za x -y dlcs\orcs-KR.teaac -o"temp\orcs-KR"
echo * patching...
xcopy /Y game\dlcs\tome-orcs\data\locales\ko_KR.lua temp\orcs-KR\tome-orcs\data\locales\ko_KR.lua
echo * repacking...
7za a -tzip -mx=0 orcs-KR.zip -r temp\orcs-KR\.
echo * Finalizing...
del /F dlcs\orcs-KR.teaac
ren orcs-KR.zip orcs-KR.teaac
move orcs-KR.teaac dlcs\
rmdir /S /Q temp\
cls

echo COMPLETE!!!
pause.