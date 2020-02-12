#!/bin/sh

if test $# -lt 1 ; then
	echo "Usage: release.sh [version] [beta, if any]"
	exit
fi

if test -f game/modules/tome/data/gfx/ts-shockbolt-npc.lua; then
	echo "***********************************************************"
	echo "***********************************************************"
	echo "**************** TILESET MODE already active! *************"
	echo "***********************************************************"
	echo "***********************************************************"
	echo "Removing tilsets..."
	rm -f game/modules/tome/data/gfx/ts-*lua game/modules/tome/data/gfx/ts-*png
	echo "...done"
	echo
fi

echo "*********** Compute tilesets? (Y/n)"
read ok
if test "$ok" '!=' 'n'; then
	sh utils/tileset-maker.tome.sh 2>/dev/null
fi

echo "*********** Make sure bunbled addons are updated. Ok ? (Y/n)"
read ok
if test "$ok" '=' 'n'; then exit; fi

# Check validity
echo "Validating lua files..."
find game/ bootstrap/ -name '*lua' | xargs -n1 luac -p
if test $? -ne 0 ; then
	echo "Invalid lua files!"
	exit 1
fi
echo "...done"

ever="$1"
tver="$1"
ver="$1"
filever="$1"
beta="$2"

if test -n "$beta"; then
	filever="$filever-$beta"
fi

rm -rf tmp
mkdir tmp
cd tmp
mkdir t-engine4-windows-"$filever"
mkdir t-engine4-src-"$filever"
mkdir t-engine4-linux32-"$filever"
mkdir t-engine4-linux64-"$filever"
mkdir t-engine4-osx-"$filever"

# src
echo "******************** Src"
cd t-engine4-src-"$filever"
cp -a ../../bootstrap/  ../../game/ ../../C* ../../premake4.lua ../../src/ ../../build/ ../../mac/  .
rm -rf mac/base_app/
rm -rf game/modules/angband
rm -rf game/modules/rogue
rm -rf game/modules/gruesome
find . -name '*~' -or -name '.svn' -or -name '.keep' | xargs rm -rf

# stamp the releases
echo "version_desc = '$ver'" >> game/engines/default/modules/boot/init.lua
echo "version_desc = '$ver'" >> game/modules/tome/init.lua
if test -n "$beta"; then
	echo "return '$beta'" > game/engines/default/engine/version_beta.lua
fi

# create teae/teams
cd game/engines
te4_pack_engine.sh default/ te4-"$ever"
te4_pack_engine.sh default/ te4-"$ever" 1
\cp -f te4-*.teae boot-te4-*.team /foreign/eyal/var/www/te4.org/htdocs/dl/engines
mv boot*team ../modules
rm -rf default
cd ../modules
te4_pack_module_tome.sh tome "$tver"
#te4_pack_module.sh tome "$tver" 1
\cp -f tome*.team /foreign/eyal/var/www/te4.org/htdocs/dl/modules/tome/
rm -f tome*nomusic.team
rm -f boot*nomusic.team
rm -rf tome
cd ../../

cd ..
tar cvjf t-engine4-src-"$filever".tar.bz2 t-engine4-src-"$filever"

# windows
echo "******************** Windows"
cd t-engine4-windows-"$filever"
cp -a ../../bootstrap/  ../t-engine4-src-"$filever"/game/ ../../C* ../../dlls/* .
find . -name '*~' -or -name '.svn' | xargs rm -rf
cd ..
zip -r -9 t-engine4-windows-"$filever".zip t-engine4-windows-"$filever"

# linux 32
echo "******************** linux32"
cd t-engine4-linux32-"$filever"
cp -a ../../bootstrap/  ../t-engine4-src-"$filever"/game/ ../../C* ../../linux-bin/* .
find . -name '*~' -or -name '.svn' | xargs rm -rf
cd ..
tar -cvjf t-engine4-linux32-"$filever".tar.bz2 t-engine4-linux32-"$filever"

# linux 64
echo "******************** linux64"
cd t-engine4-linux64-"$filever"
cp -a ../../bootstrap/  ../t-engine4-src-"$filever"/game/ ../../C* ../../linux-bin64/* .
find . -name '*~' -or -name '.svn' | xargs rm -rf
cd ..
tar -cvjf t-engine4-linux64-"$filever".tar.bz2 t-engine4-linux64-"$filever"

# OSX
echo "******************** OSX"
cd t-engine4-osx-"$filever"
mkdir T-Engine.app/
cp -a ../../mac/base_app/* T-Engine.app/
cp -a ../../bootstrap/ T-Engine.app/Contents/MacOS/
cp ../../utils/boot-osx-standalone-apple-sucks.lua T-Engine.app/Contents/MacOS/bootstrap/boot.lua
cp -a ../t-engine4-src-"$filever"/game/ T-Engine.app/Contents/Resources/
cp -a ../../C* .
find . -name '*~' -or -name '.svn' | xargs rm -rf
zip -r -9 ../t-engine4-osx-"$filever".zip *
cd ..

#### Music less

# src
echo "******************** Src n/m"
cd t-engine4-src-"$filever"
IFS=$'\n'; for i in `find game/ -name '*.ogg'`; do
	echo "$i"|grep '/music/' -q
	if test $? -eq 0; then rm "$i"; fi
done
rm game/modules/tome*-music.team
rm game/modules/boot*team
cp /foreign/eyal/var/www/te4.org/htdocs/dl/engines/boot-te4-"$ever"-nomusic.team game/modules/
cd ..
tar cvjf t-engine4-src-"$filever"-nomusic.tar.bz2 t-engine4-src-"$filever"

# windows
echo "******************** Windows n/m"
cd t-engine4-windows-"$filever"
IFS=$'\n'; for i in `find game/ -name '*.ogg'`; do
	echo "$i"|grep '/music/' -q
	if test $? -eq 0; then rm "$i"; fi
done
rm game/modules/tome*-music.team
rm game/modules/boot*team
cp /foreign/eyal/var/www/te4.org/htdocs/dl/engines/boot-te4-"$ever"-nomusic.team game/modules/
cd ..
zip -r -9 t-engine4-windows-"$filever"-nomusic.zip t-engine4-windows-"$filever"

# linux 32
echo "******************** linux32 n/m"
cd t-engine4-linux32-"$filever"
IFS=$'\n'; for i in `find game/ -name '*.ogg'`; do
	echo "$i"|grep '/music/' -q
	if test $? -eq 0; then rm "$i"; fi
done
rm game/modules/tome*-music.team
rm game/modules/boot*team
cp /foreign/eyal/var/www/te4.org/htdocs/dl/engines/boot-te4-"$ever"-nomusic.team game/modules/
cd ..
tar -cvjf t-engine4-linux32-"$filever"-nomusic.tar.bz2 t-engine4-linux32-"$filever"

# linux 64
echo "******************** linux64 n/m"
cd t-engine4-linux64-"$filever"
IFS=$'\n'; for i in `find game/ -name '*.ogg'`; do
	echo "$i"|grep '/music/' -q
	if test $? -eq 0; then rm "$i"; fi
done
rm game/modules/tome*-music.team
rm game/modules/boot*team
cp /foreign/eyal/var/www/te4.org/htdocs/dl/engines/boot-te4-"$ever"-nomusic.team game/modules/
cd ..
tar -cvjf t-engine4-linux64-"$filever"-nomusic.tar.bz2 t-engine4-linux64-"$filever"

cp *zip *bz2 *dmg.gz /foreign/eyal/var/www/te4.org/htdocs/dl/t-engine

########## Announce

echo
echo "Download links:"
echo "https://te4.org/dl/t-engine/t-engine4-windows-$filever.zip"
echo "https://te4.org/dl/t-engine/t-engine4-src-$filever.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-linux32-$filever.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-linux64-$filever.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-windows-$filever-nomusic.zip"
echo "https://te4.org/dl/t-engine/t-engine4-src-$filever-nomusic.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-linux32-$filever-nomusic.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-linux64-$filever-nomusic.tar.bz2"
echo "https://te4.org/dl/t-engine/t-engine4-osx-$filever.zip"

######### SQL
echo "*********** Publish release? (Y/n)"
cd ..
read ok
if test "$ok" '!=' 'n'; then
	sh utils/publish_release.sh "$filever" "$ver"
fi
