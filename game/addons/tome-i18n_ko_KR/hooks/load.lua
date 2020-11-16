local class = require"engine.class"

class:bindHook("I18N:listLanguages", function(self, data)
    data.list[#data.list+1] = {name = "Korean Translation (Temp_v1)", locale="ko_KR"}
end)
