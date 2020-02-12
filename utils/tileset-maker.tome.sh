#!/bin/bash

cd game/modules/tome/data/gfx/
rm -f ts-gfx-*
lua ../../../../../utils/tileset-maker.lua 4096 4096 ts-gfx-terrain /data/gfx/ shockbolt/invis.png `find shockbolt/terrain/ -name '*png'`
lua ../../../../../utils/tileset-maker.lua 2048 2048 ts-gfx-npc /data/gfx/ `find shockbolt/npc/ -name '*png'`
lua ../../../../../utils/tileset-maker.lua 2048 2048 ts-gfx-object /data/gfx/ `find shockbolt/object/ -name '*png'`
lua ../../../../../utils/tileset-maker.lua 1024 512 ts-gfx-trap /data/gfx/ `find shockbolt/trap/ -name '*png'`
lua ../../../../../utils/tileset-maker.lua 4096 2048 ts-gfx-talents-effects /data/gfx/ `find talents/ -name '*png'` `find effects/ stats/ -name '*png'`
