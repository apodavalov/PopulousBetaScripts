--[[
	Authors: Toxicity & Zyraw
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 28.12.2020
	Last revision: 04.01.2021
]]

import(Module_Game)
import(Module_DataTypes)
import(Module_Map)
import(Module_Objects)
import(Module_Defines)
import(Module_Table)
import(Module_MapWho)
import(Module_Globals)
import(Module_Players)
import(Module_Level)
import(Module_System)
import(Module_Package)
import(Module_Draw)
import(Module_Math)
import(Module_Shapes)
import(Module_String)
import(Module_Sound)
import(Module_PopScript)
import(Module_Person)
require("Scripts\\LibFlags")
require("Scripts\\LibSpells")
require("Scripts\\LibBuildings")

_gnsi = gnsi();
_gsi = gsi();
_pti = people_type_info();
_sti = spells_type_info();

_sti[M_SPELL_VOLCANO].AvailableSpriteIdx = _sti[M_SPELL_TELEPORT].AvailableSpriteIdx;
_sti[M_SPELL_VOLCANO].NotAvailableSpriteIdx = _sti[M_SPELL_TELEPORT].NotAvailableSpriteIdx;
_sti[M_SPELL_VOLCANO].ClickedSpriteIdx = _sti[M_SPELL_TELEPORT].ClickedSpriteIdx;
_sti[M_SPELL_VOLCANO].ToolTipStrIdx = _sti[M_SPELL_TELEPORT].ToolTipStrIdx;
_sti[M_SPELL_VOLCANO].ToolTipStrIdxLSME = _sti[M_SPELL_TELEPORT].ToolTipStrIdxLSME;
_sti[M_SPELL_VOLCANO].CursorSpriteNum = _sti[M_SPELL_TELEPORT].CursorSpriteNum;
_sti[M_SPELL_VOLCANO].DiscoveryDrawIdx = _sti[M_SPELL_TELEPORT].DiscoveryDrawIdx;

_sti[M_SPELL_CONVERT_WILD].AvailableSpriteIdx = _sti[M_SPELL_BLAST].ClickedSpriteIdx;
_sti[M_SPELL_CONVERT_WILD].NotAvailableSpriteIdx = _sti[M_SPELL_BLAST].NotAvailableSpriteIdx;
_sti[M_SPELL_CONVERT_WILD].ClickedSpriteIdx = _sti[M_SPELL_BLAST].ClickedSpriteIdx;
_sti[M_SPELL_CONVERT_WILD].ToolTipStrIdx = _sti[M_SPELL_BLAST].ToolTipStrIdx;
_sti[M_SPELL_CONVERT_WILD].ToolTipStrIdxLSME = _sti[M_SPELL_BLAST].ToolTipStrIdxLSME;
_sti[M_SPELL_CONVERT_WILD].CursorSpriteNum = _sti[M_SPELL_BLAST].CursorSpriteNum;
_sti[M_SPELL_CONVERT_WILD].DiscoveryDrawIdx = _sti[M_SPELL_BLAST].DiscoveryDrawIdx;
_sti[M_SPELL_CONVERT_WILD].Flags = _sti[M_SPELL_BLAST].Flags;

_pti[M_PERSON_ANGEL].DefaultLife = 400; -- 10.000 default
scores_width = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 }; 
strings_name_width = { [0]= 85, 85, 85, 85, 85, 85, 85, 85 };
char_width = {
	["A"] = 10,
	["B"] = 9,
	["C"] = 12,
	["D"] = 11,
	["E"] = 8,
	["F"] = 8,
	["G"] = 12,
	["H"] = 10,
	["I"] = 4,
	["J"] = 4,
	["K"] = 10,
	["L"] = 8,
	["M"] = 14,
	["N"] = 10,
	["O"] = 14,
	["P"] = 9,
	["Q"] = 13,
	["R"] = 10,
	["S"] = 9,
	["T"] = 10,
	["U"] = 11,
	["V"] = 11,
	["W"] = 16,
	["X"] = 11,
	["Y"] = 12,
	["Z"] = 11,
	["["] = 7,
	["\\"] = 11,
	["]"] = 7,
	["_"] = 16,
	["'"] = 5,
	[" "] = 8,
	["!"] = 4,
	["\""] = 8,
	["#"] = 14,
	["$"] = 11,
	["%"] = 16,
	["&"] = 15,
	["("] = 6,
	[")"] = 6,
	["*"] = 9,
	["+"] = 10,
	[","] = 5,
	["-"] = 11,
	["."] = 4,
	["/"] = 11,
	["0"] = 11,
	["1"] = 4,
	["2"] = 11,
	["3"] = 11,
	["4"] = 11,
	["5"] = 11,
	["6"] = 11,
	["7"] = 11,
	["8"] = 12,
	["9"] = 11,
	[":"] = 4,
	[";"] = 4,
	["<"] = 7,
	["="] = 14,
	[">"] = 7,
	["?"] = 11,
	["@"] = 17,
};

Font = {
	Large = P3_LARGE_FONT;
	Small = P3_SMALL_FONT_NORMAL;
};

MAX_SCORE = 3;
Players = {
	[0]= 
	{
		Score = -1,
		Color = CLR_BLUE,
		Name = "Player 0",
		CanGivePoint = true,
		ID = 0;
	},
	{
		Score = -1,
		Color = CLR_RED,
		Name = "Player 1",
		CanGivePoint= true,
		ID = 1;
	},
	{
		Score = -1,
		Color = CLR_YELLOW,
		Name = "Player 2",
		CanGivePoint = true,
		ID = 2;
	},
	{
		Score = -1,
		Color = CLR_GREEN,
		Name = "Player 3",
		CanGivePoint = true,
		ID = 3;
	},
	{
		Score = -1,
		Color = CLR_TURQUOISE,
		Name = "Player 4",
		CanGivePoint = true, 
		ID = 4;
	},
	{
		Score = -1,
		Color = CLR_DARK_PURPLE,
		Name = "Player 5",
		CanGivePoint = true,
		ID = 5;
	},
	{
		Score = -1,
		Color = CLR_BLACK,
		Name = "Player 6",
		CanGivePoint = true,
		ID = 6;
	},
	{
		Score = -1,
		Color = 14,
		Name = "Player 7",
		CanGivePoint = true,
		ID = 7;
	};
};

local positions = {}

power_up_mode = 1; -- 0 old, 1 new
powerup_markers = 14; -- 0 ~ 14
POWERUP_CD = 10*12;
powerup_cds = { [0]= 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
spawn_zone = { x = 96, z = 22, marker = 34 };
start_zone = Coord3D.new();
start_zone = MAP_XZ_2_WORLD_XYZ(96, 28)
end_zone = Coord3D.new();
end_zone = MAP_XZ_2_WORLD_XYZ(98, 4);
boats_spawn = { x = 96, z = 36 };

local last_model = M_SPELL_NONE;
local function GetRandomSpellModel()
	local model = M_SPELL_BLAST;
	local very_rare = G_RANDOM(11);
	if (very_rare >= 9) then
		model = M_SPELL_ANGEL_OF_DEATH;
	else
		local medium_rare_steak = G_RANDOM(10);
		if (medium_rare_steak >= 8) then
			model = M_SPELL_FIRESTORM;
		else
			local rare = G_RANDOM(7);
			if (rare >= 5) then
				model = M_SPELL_SHIELD;
			else
				local common = G_RANDOM(4);
				if (common >= 2) then
					model = M_SPELL_WHIRLWIND;
				else
					model = M_SPELL_LIGHTNING_BOLT;
				end
			end
		end
	end
	if (model == last_model) then
		local new = G_RANDOM(10);
		if (new >= 5) then
			model = M_SPELL_CONVERT_WILD;
		else
			model = GetRandomSpellModel(); -- second try, adds some variety
		end
	end
	last_model = model;
	return model;
end

local function ProcessPowerUps()
	-- for new powerups method
	if (power_up_mode == 1) then
		for i=0,powerup_markers,1 do
			local spawned_effects = 0;
			local exit_block = false;
			--local e_c3d = Coord3D.new();
			--map_idx_to_world_coord3d(_gnsi.ThisLevelHeader.Markers[i], e_c3d);
			--createThing(T_EFFECT, M_EFFECT_FIREBALL, 0, e_c3d, false, false);
			if (powerup_cds[i] == 0) then
				SearchMapCells(CIRCULAR, 0, 0, 2, _gnsi.ThisLevelHeader.Markers[i], function(me)
					if (_gsi.Counts.ProcessThings & 12 == 0) then
						if (spawned_effects % 2 == 0) then
							local c3d = Coord3D.new();
							local map_idx = MAP_ELEM_PTR_2_IDX(me);
							map_idx_to_world_coord3d(map_idx, c3d);
							createThing(T_EFFECT, M_EFFECT_SMALL_SPARKLE, 0, c3d, false, false);
						end
						spawned_effects = spawned_effects + 1;
					end

					me.MapWhoList:processList(function(t)
						if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
							if (i <= 2) then
								for j=2,0,-1 do
									powerup_cds[2-j] = POWERUP_CD;
								end
							elseif (i <= 5) then
								for j=2,0,-1 do
									powerup_cds[5-j] = POWERUP_CD;
								end
							elseif (i <= 8) then
								for j=2,0,-1 do
									powerup_cds[8-j] = POWERUP_CD;
								end
							elseif (i <= 11) then
								for j=2,0,-1 do
									powerup_cds[11-j] = POWERUP_CD;
								end
							elseif (i <= 14) then
								for j=2,0,-1 do
									powerup_cds[14-j] = POWERUP_CD;
								end
							end
							--[[
							if (G_RANDOM(2) == 1) then
								ProcessGlobalTypeList(T_VEHICLE, function(_t)
									if (_t.u.Vehicle.NumOccupants > 0) then
										createThing(T_EFFECT, M_EFFECT_SIMPLE_BLAST, TRIBE_HOSTBOT, _t.Pos.D3, false, false);
									end
									return true
								end)
							end
							]]

							local spell = GetRandomSpellModel();
							if (spell == M_SPELL_SHIELD) then
								t.u.Pers.u.Owned.ShieldCount = 20;
								t.Flags3 = Flags:Set(t.Flags3, TF3_SHIELD_ACTIVE);
								return false;
							end

							if (spell == M_SPELL_WHIRLWIND) then
								GIVE_ONE_SHOT(spell, t.Owner); -- Double shots
							end
							GIVE_ONE_SHOT(spell, t.Owner);
							exit_block = true;
							return false;
						end
						return true;
					end)
					if (exit_block) then
						return false;
					end
					return true;
				end)
			else
				powerup_cds[i] = powerup_cds[i] - 1;
			end
		end
	end
end

local function CreatePowerUp(marker, model)
	local c3d = Coord3D.new();
	map_idx_to_world_coord3d(_gnsi.ThisLevelHeader.Markers[marker], c3d);
	local d = createThing(T_GENERAL, M_GENERAL_DISCOVERY, 0, c3d, false, false);
	local t = createThing(T_GENERAL, M_GENERAL_TRIGGER, 0, c3d, false, false);
	d.u.Discovery.DiscoveryType = T_SPELL;
	d.u.Discovery.DiscoveryModel = model;
	d.u.Discovery.AvailabilityType = AVAILABLE_ONCE; -- 3
	d.u.Discovery.TriggerType = DISCOVERY_TRIGGER_IMMEDIATE; -- 1
	t.u.Trigger.EditorThingIdxs[0] = d.ThingNum;
	t.u.Trigger.CreatePlayerOwned = 1;
end

local function CheckPowerUpReplenishment()
	if (power_up_mode == 0) then

	end
end

-- Don't forget to disable createThing
local function CacheSafeZones()
	--[[
	-- Start zone
	SearchMapCells(SQUARE, 0, 0, 8, world_coord3d_to_map_idx(start_zone), function(me)
		local c3d = Coord3D.new();
		local map_idx = MAP_ELEM_PTR_2_IDX(me);
		map_idx_to_world_coord3d(map_idx, c3d);
		createThing(T_EFFECT, M_EFFECT_FIREBALL, 0, c3d, false, false);
	    return true;
	end)

	-- End zone
	SearchMapCells(SQUARE, 0, 0, 6, world_coord3d_to_map_idx(end_zone), function(me)
		local c3d = Coord3D.new();
		local map_idx = MAP_ELEM_PTR_2_IDX(me);
		map_idx_to_world_coord3d(map_idx, c3d);
		createThing(T_EFFECT, M_EFFECT_FIREBALL, 0, c3d, false, false);
	    return true;
	end)
	]]

	if (#positions == 0) then
		-- Start zone
		SearchMapCells(SQUARE, 0, 0, 8, world_coord3d_to_map_idx(start_zone), function(me)
			local map_idx = MAP_ELEM_PTR_2_IDX(me);
			table.insert(positions, map_idx);
			return true;
		end)
	
		-- End zone
		SearchMapCells(SQUARE, 0, 0, 6, world_coord3d_to_map_idx(end_zone), function(me)
			local map_idx = MAP_ELEM_PTR_2_IDX(me);
			table.insert(positions, map_idx);
			return true;
		end)
	end
end

local function GetStringWidth(str)
	local w = 0;
	for i=1,#str,1 do
		local c = str:sub(i,i)
		c = string.upper(c);
		if (char_width[c] ~= nil) then
			w = w + char_width[c];
		else
			w = w + 10 + 2;
		end
	end
	return w;
end

local function CachePlayerNameWidth(str, pn)
	local w = GetStringWidth(str);
	strings_name_width[pn] = w;
end

local function GivePoint(pn)
	Players[pn].Score = Players[pn].Score + 1;
	local tmp = deepcopy(Players);
	PlayersHighestScore = quicksort(tmp, "Score", 0);
	scores_width[pn] = GetStringWidth(string.format(": %s/%s", Players[pn].Score, 3)) + 10;

	if (Players[pn].Score >= MAX_SCORE) then
		for pn2=0,7,1 do
			if (pn2 ~= pn) then
				local shaman = getShaman(pn2);
				getPlayer(pn2).ShamanLives = 0;
				destroy_reinc(getPlayer(pn2));
				if (shaman ~= nil) then
					damage_person(shaman, TRIBE_HOSTBOT, 9999, TRUE);
				end
			end
		end
	end
end

angel_cd = 0;
local function ProcessAngelSpawn(x, z)
	if (angel_cd > 0) then
		angel_cd = angel_cd - 1;
	end
	local shaman_in_area = false;
	local shaman_pos = Coord3D.new();
	local owner = 0;
	if (angel_cd == 0) then
		SearchMapCells(SQUARE, 0, 0, 8, world_coord3d_to_map_idx(MAP_XZ_2_WORLD_XYZ(x, z)), function(me)
			me.MapWhoList:processList(function(t)
				if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
					shaman_in_area = true;
					shaman_pos = t.Pos.D3;
					owner = t.Owner;
					return false;
				end
				return true;
			end)
			if (shaman_in_area == true) then
				--local c3d = Coord3D.new();
				--local map_idx = MAP_ELEM_PTR_2_IDX(me);
				--map_idx_to_world_coord3d(map_idx, c3d);
				--createThing(T_EFFECT, M_EFFECT_FIREBALL, 0, c3d, false, false);
				owner = owner + 1;
				if (owner > 7) then
					owner = 0;
				end
				createThing(T_PERSON, M_PERSON_ANGEL, owner, MAP_XZ_2_WORLD_XYZ(168, 166), false, false)
				angel_cd = 12*3;
				return false;
			end
			return true;
		end)
	end
end

local function CheckMS(pn) 
	if (I_HAVE_ONE_SHOT(pn, T_SPELL, M_SPELL_SHIELD) == true) then
		Spells:Disable(pn, M_SPELL_SHIELD, true);
		local shaman = getShaman(pn);
		if (shaman ~= nil) then
			shaman.u.Pers.u.Owned.ShieldCount = 20;
			shaman.Flags3 = Flags:Set(shaman.Flags3, TF3_SHIELD_ACTIVE);
		end
	end
end

local function ProcessBoats(x, z)
	local boats = 0;
	SearchMapCells(SQUARE, 0, 0, 7, world_coord3d_to_map_idx(MAP_XZ_2_WORLD_XYZ(x, z)), function(me)
		me.MapWhoList:processList(function(t)
			if (t.Type == T_VEHICLE and t.Model == M_VEHICLE_BOAT_1) then
				boats = boats + 1;
			end
			return true;
		end)
		return true;
	end)

	if (boats < 8) then
		for i=boats,8,1 do
			createThing(T_VEHICLE, M_VEHICLE_BOAT_1, TRIBE_NEUTRAL, MAP_XZ_2_WORLD_XYZ(x, z), false, false)
		end
	end
end

local function ProcessAngelsInSafeZones()
	ProcessGlobalTypeList(T_PERSON, function(t)
		if (t.Model == M_PERSON_ANGEL) then
			local pos = world_coord3d_to_map_idx(t.Pos.D3);
			for k, v in pairs(positions) do
				if (v == pos) then
					t.u.Pers.Life = 0;
					break;
				end
			end
		end
		return true
	end)

	-- Start zone
	--[[
	SearchMapCells(SQUARE, 0, 0, 8, world_coord3d_to_map_idx(start_zone), function(me)
		me.MapWhoList:processList(function(t)
			if (t.Type == T_PERSON and t.Model == M_PERSON_ANGEL) then
				t.u.Pers.Life = 0;
			end
			return true;
		end)
	    return true;
	end)

	-- End zone
	SearchMapCells(SQUARE, 0, 0, 6, world_coord3d_to_map_idx(end_zone), function(me)
		me.MapWhoList:processList(function(t)
			if (t.Type == T_PERSON and t.Model == M_PERSON_ANGEL) then
				t.u.Pers.Life = 0;
			end
			return true;
		end)
	    return true;
	end)
	]]
end

local function ProcessEndZone()
	SearchMapCells(CIRCULAR, 0, 0, 2, world_coord3d_to_map_idx(MAP_XZ_2_WORLD_XYZ(96, 6)), function(me)
		local c3d = Coord3D.new();
		local map_idx = MAP_ELEM_PTR_2_IDX(me);
		map_idx_to_world_coord3d(map_idx, c3d);
		createThing(T_EFFECT, M_EFFECT_FIREBALL, 0, c3d, false, false);
		me.MapWhoList:processList(function(t)
			if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
				if (Players[t.Owner].CanGivePoint == true) then
					createThing(T_EFFECT, M_EFFECT_TELEPORT, t.Owner, MAP_XZ_2_WORLD_XYZ(spawn_zone.x, spawn_zone.z), false, false);
					GivePoint(t.Owner);
					Players[t.Owner].CanGivePoint = false;
				end
			end
			return true;
		end)
	    return true;
	end)
end

local function ProcessSpawnZone()
	for pn=0,7,1 do
		if (Players[pn].CanGivePoint == false) then
			if (IS_SHAMAN_IN_AREA(pn, spawn_zone.marker, 4) > 0) then
				Players[pn].CanGivePoint = true;
			end
		end
	end
end

starting = 12*15
local function ProcessStartingTimer()
	if (starting > 0) then
		starting = starting - 1;
		if (starting == 12*12) then
			log_msg(TRIBE_NEUTRAL, "First message.");
		elseif (starting == 12*10) then
			log_msg(TRIBE_NEUTRAL, "Second message.");
		elseif (starting == 12*8) then
			log_msg(TRIBE_NEUTRAL, "Third message.");
		elseif (starting == 12*5) then
			log_msg(TRIBE_NEUTRAL, "Fourth message.");
		elseif (starting == 0) then
			log_msg(TRIBE_NEUTRAL, "Start!");
			ProcessBoats(boats_spawn.x, boats_spawn.z);
		end
	end
end

local function Initialize()
	CacheSafeZones();
	CreatePowerUp(36, GetRandomSpellModel());
	CreatePowerUp(27, GetRandomSpellModel());
	CreatePowerUp(37, GetRandomSpellModel());
	CreatePowerUp(37, GetRandomSpellModel());
	CreatePowerUp(38, GetRandomSpellModel());

	for pn=0,7,1 do
		if ((_gnsi.Flags & GNS_NETWORK) == GNS_NETWORK) then
			Players[pn].Name = get_player_name(pn, true);
			CachePlayerNameWidth(Players[pn].Name, pn);
		end
		for m=M_SPELL_BLAST,NUM_SPELL_TYPES,1 do
			Spells:Disable(pn, m, true);
		end
		for m=0,NUM_BUILDING_TYPES,1 do
			if (m ~= M_BUILDING_GUARD_POST) then
				Bldg:Disable(pn, m);
			end
		end
		Spells:Enable(pn, M_SPELL_BLAST);
	end

	for pn=0,7,1 do
		local shaman = getShaman(pn);
		if (shaman ~= nil) then
			getPlayer(pn).ShamanLives = 99;
			GivePoint(pn);
		end
	end

	for i=0,powerup_markers,1 do
		if (power_up_mode == 0) then
			CreatePowerUp(i, GetRandomSpellModel())
		end
	end

	--GIVE_ONE_SHOT(M_SPELL_CONVERT_WILD, 0);
end

blast_timer = 2*12;
function OnTurn()
	ProcessStartingTimer();
	if (EVERY_2POW_TURNS(1)) then
		ProcessPowerUps();
	end

	if (EVERY_2POW_TURNS(2)) then
		--CacheSafeZones();
		ProcessEndZone();
		ProcessSpawnZone();
		for pn=0,7,1 do
			CheckMS(pn);
		end
	end

	if (EVERY_2POW_TURNS(5)) then
		ProcessAngelsInSafeZones();
		ProcessAngelSpawn(144, 178);
		if (starting == 0) then
			ProcessBoats(boats_spawn.x, boats_spawn.z);
		end
	end

	if (starting == 0) then
		if (blast_timer > 0) then
			blast_timer = blast_timer - 1;
			if (blast_timer == 0) then
				for pn=0,7,1 do
					GIVE_ONE_SHOT(M_SPELL_BLAST, pn);
					GIVE_ONE_SHOT(M_SPELL_VOLCANO, pn);
				end
				blast_timer = 2*12;
			end
		end
	end
end

bar_h = 15;
box_y_offset = 20;
offset_incr = 30;
function OnFrame()
	offset = 0;
	for i=0,7,1 do
		local pn = PlayersHighestScore[i].ID;
		if (Players[pn].Score ~= -1) then -- Show only active players (or previously active but now dead)
			PopSetFont(Font.Large);
			local str = string.format(": %s/%s", Players[pn].Score, 3);
			local score_width = scores_width[pn];
			-- Player box
			DrawBox(ScreenWidth()-score_width-47-strings_name_width[pn], ScreenHeight()-box_y_offset-offset, 25, bar_h, Players[pn].Color);
			-- Name
			LbDraw_Text(ScreenWidth()-score_width-strings_name_width[pn]-15, ScreenHeight()-box_y_offset-offset, Players[pn].Name, 0);
			-- Score
			LbDraw_Text(ScreenWidth()-score_width, ScreenHeight()-box_y_offset-offset, str, 0);
			offset = offset + offset_incr;
		end
	end
end

function OnCreateThing(t)
	if (t.Type == T_SPELL) then
		if (t.Model == M_SPELL_VOLCANO) then
			createThing(T_EFFECT, M_EFFECT_TELEPORT, t.Owner, MAP_XZ_2_WORLD_XYZ(spawn_zone.x, spawn_zone.z), false, false);
			t.Model = M_SPELL_NONE;
		else
			local pos = world_coord3d_to_map_idx(t.Pos.D3);
			for k, v in pairs(positions) do
				if (v == pos) then
					t.Model = M_SPELL_NONE;
					break;
				end
			end

			if (t.Model == M_SPELL_CONVERT_WILD) then
				--t.Model = M_SPELL_NONE;
				createThing(T_EFFECT, M_EFFECT_SIMPLE_BLAST, t.Owner, t.Pos.D3, false, false);
				ProcessGlobalTypeList(T_VEHICLE, function(_t)
				--	if (is_thing_on_ground(_t) > 0) then
						if (_t.u.Vehicle.NumOccupants > 0) then
							createThing(T_EFFECT, M_EFFECT_SIMPLE_BLAST, _t.Owner, _t.Pos.D3, false, false);
						end
				--	end
					return true
				end)
			end
		end
	end
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

-- Stackoverflow
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Stackoverflow
function quicksort(t, sortname, start, endi)
	start, endi = start or 1, endi or #t
	sortname = sortname or 1
	if(endi - start < 1) then return t end
	local pivot = start
	for i = start + 1, endi do
	  if  t[i][sortname] <= t[pivot][sortname] then
		local temp = t[pivot + 1]
		t[pivot + 1] = t[pivot]
		if(i == pivot + 1) then
		  t[pivot] = temp
		else
		  t[pivot] = t[i]
		  t[i] = temp
		end
		pivot = pivot + 1
	  end
	end
	t = quicksort(t, sortname, start, pivot - 1)
	return quicksort(t, sortname, pivot + 1, endi)
end  

PlayersHighestScore = deepcopy(Players);
Initialize();