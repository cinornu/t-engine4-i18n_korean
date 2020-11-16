local class = require"engine.class"
local FontPackage = require "engine.FontPackage"

class:bindHook("I18N:listLanguages", function(self, data)
    data.list[#data.list+1] = {name = "Korean Translation (Temp_v1)", locale="ko_KR", font=FontPackage:get("default", nil, "korean")}
end)
