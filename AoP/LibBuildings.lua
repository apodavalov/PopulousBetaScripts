
--[[
	Author: Toxicity
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 25.12.2020
]]

import(Module_Globals)
import(Module_Level)
require("Scripts\\LibFlags")


Bldg = {}

local _gsi = gsi();

function Bldg:Enable(pn, model)
	_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailable = Flags:Set(_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailable, (1 << model));
end

function Bldg:Disable(pn, model)
	_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailable = Flags:Unset(_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailable, (1 << model));
	_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailableOnce = Flags:Unset(_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailableOnce, (1 << model));
	_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailableLevel = Flags:Unset(_gsi.ThisLevelInfo.PlayerThings[pn].BuildingsAvailableLevel, (1 << model));
end

-- All type of tepees
function Bldg:GetTepees(pn, fully_built)
	huts = 0;
	if (fully_built == true) then 
		huts = _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEPEE];
		huts = huts + _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEPEE_2];
		huts = huts + _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEPEE_3];
	else 
		huts = _gsi.Players[pn].NumBuiltOrPartBuiltBuildingsOfType[M_BUILDING_TEPEE];
		huts = huts + _gsi.Players[pn].NumBuiltOrPartBuiltBuildingsOfType[M_BUILDING_TEPEE_2];
		huts = huts + _gsi.Players[pn].NumBuiltOrPartBuiltBuildingsOfType[M_BUILDING_TEPEE_3];
	end
	return huts;
end


return Bldg