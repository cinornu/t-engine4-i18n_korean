import os
import re
def copy_file(locale, part, path):
    try:
        os.makedirs(re.sub(r"[^\\/]+\.[^\\/]+$", "", path), True)
    except FileExistsError:
        pass
    fo = open(path, "w", encoding="utf-8")
    fo.write('locale "' + locale + '"\n')
    if os.path.exists(part + ".copy.lua"):
        f = open(part + ".copy.lua", "r", encoding="utf-8")
        fo.write(f.read())
    if os.path.exists(part + ".lua"):
        f = open(part + ".lua", "r", encoding="utf-8")
        fo.write(f.read())
    fo.close()

copyfile("ko_KR", "tome-items-vault", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\addons\\tome-items-vault")
copyfile("ko_KR", "tome-orcs", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\dlcs\\tome-orcs")
copyfile("ko_KR", "engine", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\engines\\default")
copyfile("ko_KR", "tome-ashes-urhrok", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\dlcs\\tome-ashes-urhrok")
copyfile("ko_KR", "mod-boot", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\engines\\default\\modules\\boot")
copyfile("ko_KR", "mod-example", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\modules\\example")
copyfile("ko_KR", "tome-cults", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\dlcs\\tome-cults")
copyfile("ko_KR", "tome-addon-dev", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\addons\\tome-addon-dev")
copyfile("ko_KR", "tome-possessors", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\addons\\tome-possessors")
copyfile("ko_KR", "mod-example_realtime", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\modules\\example_realtime")
copyfile("ko_KR", "mod-tome", "D:\\repos\\github\\t-engine4-i18n_korean\\game\\modules\\tome")
