--[[
	Author: Toxicity
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 22.12.2020
	Last revision: 25.12.2020
]]

import(Module_Globals)
import(Module_Level)
require("Scripts\\LibFlags")


Spells = {}

local _gsi = gsi();

-- When a spell is enabled, should it start charging by default? 
function Spells:StartCharging(pn, model)
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsNotCharging = Flags:Unset(_gsi.ThisLevelInfo.PlayerThings[pn].SpellsNotCharging, (1 << (model - 1)));
end

function Spells:StopCharging(pn, model)
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsNotCharging = Flags:Set(_gsi.ThisLevelInfo.PlayerThings[pn].SpellsNotCharging, (1 << (model - 1)));
end

function Spells:SetCharges(pn, model, num)
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailableOnce[model] = _gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailableOnce[model] & 240;
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailableOnce[model] = _gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailableOnce[model] | num;
end

function Spells:Enable(pn, model)
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailable = Flags:Set(_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailable, (1 << model));
end

function Spells:Disable(pn, model, do_remove_shots)
	_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailable = Flags:Unset(_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailable, (1 << model));
	if (do_remove_shots == true) then
		Spells:SetCharges(pn, model, 0)
	end
end

return Spells