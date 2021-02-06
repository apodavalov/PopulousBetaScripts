--[[
	Author: Toxicity
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 22.12.2020
]]

Flags = {}

function Flags:Set(_f1, _f2)
    if (_f1 & _f2 == 0) then
        _f1 = _f1 | _f2
    end
    return _f1
end

function Flags:Unset(_f1, _f2)
    if (_f1 & _f2 == _f2) then
        _f1 = _f1 ~ _f2
    end
    return _f1
end

return Flags