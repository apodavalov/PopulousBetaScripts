--[[
	Scripted by Toxicity.
	27.01.2020
]]

import(Module_Defines);
import(Module_DataTypes);
import(Module_MapWho);
import(Module_Person);
import(Module_Helpers);
import(Module_System);
import(Module_Game);
import(Module_Objects);
import(Module_Globals);
import(Module_Map);
import(Module_Level);
import(Module_String);
import(Module_Table);
import(Module_Math);
import(Module_Players);
import(Module_PopScript);
import(Module_ImGui);
import(Module_Draw);

log_msg(TRIBE_NEUTRAL, "Press 'TAB' to toggle the Statistics window.")
local MAX_POINTS = 5;
local TIMER_RESET = -1;
local _gnsi = gnsi();
local _gsi = gsi();
local g_DrawMenu = false;
local g_Turn = 0;
local g_TurnBegin = _gsi.Counts.GameTurn;
local g_TurnEnd = 0;
local g_Exit = false;
local g_Winner = TRIBE_NEUTRAL;
local g_ArenaCenter = MapPosXZ.new();
g_ArenaCenter.XZ.X = 28;
g_ArenaCenter.XZ.Z = 78;
--_gnsi.GameParams.Flags2 = _gnsi.GameParams.Flags2 | GPF2_GAME_NO_WIN;
local g_Init = false;

-- Index starting at 1
local g_SpawnPositions =
{
	MAP_XZ_2_WORLD_XYZ(42, 64),
	MAP_XZ_2_WORLD_XYZ(28, 64),
	MAP_XZ_2_WORLD_XYZ(14, 64),
	MAP_XZ_2_WORLD_XYZ(42, 78),
	MAP_XZ_2_WORLD_XYZ(14, 78),
	MAP_XZ_2_WORLD_XYZ(42, 92),
	MAP_XZ_2_WORLD_XYZ(28, 92),
	MAP_XZ_2_WORLD_XYZ(14, 92)
}
local g_ShamansAlive = { false, false, false, false, false, false, false, false };
local g_Points = { 0, 0, 0, 0, 0, 0, 0, 0 };
local g_ShamansKilled = { 0, 0, 0, 0, 0, 0, 0, 0 };
local g_PlayerNames = { "Blue",	"Red", "Yellow", "Green", "Cyan", "Pink", "Black", "Orange" };
local g_Manager = nil;

CHelpers = {};
CHelpers.new = function()
	local self = {};

	function self.copy_c3d(_c)
		local r = Coord3D.new();
		r.Xpos = _c.Xpos;
		r.Zpos = _c.Zpos;
		r.Ypos = _c.Ypos;
		return r
	end

	function self.copy_c2d(_c)
		local r = Coord2D.new();
		r.Xpos = _c.Xpos;
		r.Zpos = _c.Zpos;
		return r
	end

	function self.enable_flag(_f1, _f2)
		if _f1 & _f2 == 0 then
			_f1 = _f1 | _f2;
		end
		return _f1;
	end

	function self.disable_flag(_f1, _f2)
		if _f1 & _f2 == _f2 then
			_f1 = _f1 ~ _f2;
		end
		return _f1;
	end

	return self;
end
hlp = CHelpers.new();

CRoundManager = {};
CRoundManager.new = function(_Countdown)
    local m = {};

	m.TurnStart = 0;
    m.Started = false; -- Starts the countdown
    m.Timer = _Countdown;
	m.BlastTimer = TIMER_RESET;
	m.SprBank = 0;
	m.Winner = -1;
	m.Ended = false;
	m.InvisibleTimer = TIMER_RESET;
	m.TexBank = 0;

	function m.ShowCheckRadius(me)
		local c3d = Coord3D.new();
		map_idx_to_world_coord3d(MAP_ELEM_PTR_2_IDX(me), c3d);
		createThing(T_EFFECT, M_EFFECT_SMOKE, TRIBE_HOSTBOT, c3d, false, false);
	end

	function m.RoundStarted()
		return m.Started;
	end

	function m.RoundEnded()
		return m.Ended;
	end

	function m.StartRound(turn)
		for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
			_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailable = 0;
			for i=0,NUM_SPELL_TYPES-1,1 do
				_gsi.ThisLevelInfo.PlayerThings[pn].SpellsAvailableOnce[i+1] = 0;
			end
		end
		m.Started = true;
		m.TurnStart = turn;
	end

	function m.EndRound()
		log_msg(TRIBE_NEUTRAL, "Player [" .. tostring(m.Winner) .. "] won this round! (+1 Point)");
		g_Points[m.Winner+1] = g_Points[m.Winner+1] + 1;

		if (g_Points[m.Winner+1] == MAX_POINTS) then
			log_msg(TRIBE_NEUTRAL, "Player [" .. tostring(m.Winner) .. "]" .. " is victorious!");

			--_gnsi.GameParams.Flags2 = _gnsi.GameParams.Flags2 ~ GPF2_GAME_NO_WIN;

			for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
				local shaman = getShaman(pn);
				if (shaman ~= nil and shaman.u.Pers.u.Owned.InvisibleCount > 0) then
					shaman.Flags2 = hlp.disable_flag(shaman.Flags2, TF2_THING_IS_AN_INVISIBLE_PERSON);
					shaman.u.Pers.u.Owned.InvisibleCount = 0;
				end
				if (pn ~= m.Winner) then
					getPlayer(pn).ShamanLives = 0;
					destroy_reinc(getPlayer(pn));
					if (shaman ~= nil) then
						damage_person(shaman, TRIBE_HOSTBOT, 9999, TRUE);
					end
				end
			end

			createThing(T_SPELL, M_SPELL_VOLCANO, m.Winner, getShaman(m.Winner).Pos.D3, false, false);
			g_Exit = true;
			g_Winner = m.Winner;
		else
			SearchMapCells(CIRCULAR, 0, 0, 13, g_ArenaCenter.Pos, function(me)
				me.MapWhoList:processList(function(t)
					if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
						damage_person(t, TRIBE_HOSTBOT, 9999, TRUE);
					end
				return true;
				end);
			return true;
			end);

			_gsi.ThisLevelInfo.PlayerThings[m.Winner].SpellsAvailable = 0;
			for i=0,NUM_SPELL_TYPES-1,1 do
				_gsi.ThisLevelInfo.PlayerThings[m.Winner].SpellsAvailableOnce[i+1] = 0;
			end
		end

		m.setBank(0);
		m.Ended = true;
	end

	function m.CheckForRound()
	    if (m.Started == false) then
	        local start = true;
	        SearchMapCells(CIRCULAR, 0, 0, 13, g_ArenaCenter.Pos, function(me)
	            --m.ShowCheckRadius(me);
	            me.MapWhoList:processList(function(t)
	                if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
	                	start = false;
	            	end
	            return true;
	        	end);
	        return true;
	    	end);
	    	return start;
	    end
	    return false;
	end

	function m.setBank(bank)
		if (m.SprBank ~= bank) then
			change_sprite_bank(0, bank);
			change_sprite_bank(1, bank);
			m.SprBank = bank;
			--log_msg(TRIBE_NEUTRAL, "Using bank.. " .. tostring(bank) .. " and " .. tostring(bank))
		end
	end

	function m.setTexture(bank)
		if (m.TexBank ~= bank) then
			set_level_type(bank);
			m.TexBank = bank;
		end
	end

	-- Invisibility starts to wear off at around 6 seconds.
	function m.setInvisible(count, cooldown)
		if (m.InvisibleTimer <= 0) then
			for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
				if (g_ShamansAlive[pn+1] == true) then
					local shaman = getShaman(pn);
					if (shaman ~= nil) then
						--if (shaman.u.Pers.u.Owned.InvisibleCount == 0) then
							shaman.Flags2 = hlp.enable_flag(shaman.Flags2, TF2_THING_IS_AN_INVISIBLE_PERSON);
							shaman.u.Pers.u.Owned.InvisibleCount = count + 6;
							m.InvisibleTimer = count + cooldown;
						--end
					end
				end
			end
		else
			m.InvisibleTimer = m.InvisibleTimer - 1;
			--log_msg(TRIBE_NEUTRAL, "Invisibility remaining: " .. tostring(m.InvisibleTimer))
			if (m.InvisibleTimer == 0) then
				for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
					local shaman = getShaman(pn);
					if (shaman ~= nil) then
						shaman.Flags2 = hlp.disable_flag(shaman.Flags2, TF2_THING_IS_AN_INVISIBLE_PERSON);
						shaman.u.Pers.u.Owned.InvisibleCount = 0;
					end
				end
			end
		end
	end

	function m.ProcessRound(turn)
		turn = (turn - m.TurnStart);

		-- Logging system messages
		if (m.Timer >= 0) then
			if (m.Timer == _Countdown) then
				log_msg(TRIBE_NEUTRAL, "Round is about to begin!");
			elseif (m.Timer > 0) then
				log_msg(TRIBE_NEUTRAL, tostring(m.Timer))
			elseif (m.Timer == 0) then
				log_msg(TRIBE_NEUTRAL, "START!");
				m.setTexture(30);
				for pn=1,#g_SpawnPositions do
					--createThing(T_EFFECT, M_EFFECT_TELEPORT, pn-1, g_SpawnPositions[pn], false, false)
					local shaman = getShaman(pn-1);
					if (shaman ~= nil) then
						local pos = hlp.copy_c3d(g_SpawnPositions[pn]);
						move_thing_within_mapwho(shaman, pos);
						ensure_thing_on_ground(shaman);
					end
				end
			end
			m.Timer = m.Timer - 1;
		end

		-- Give everyone a Blast shot
		if (m.BlastTimer == 3) then
			for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
				GIVE_ONE_SHOT(M_SPELL_BLAST, pn);
				m.BlastTimer = TIMER_RESET;
			end
		end

		for pn=1,#g_ShamansAlive do
			g_ShamansAlive[pn] = false;
		end

		-- Check for Shamans inside the arena
		local numOfShamans = 0;
		SearchMapCells(SQUARE, 0, 0, 13, g_ArenaCenter.Pos, function(me)
			--m.ShowCheckRadius(me);
			me.MapWhoList:processList(function(t)
				if (t.Type == T_PERSON and t.Model == M_PERSON_MEDICINE_MAN) then
					numOfShamans = numOfShamans + 1;
					g_ShamansAlive[t.Owner + 1] = true;
					m.Winner = t.Owner;
				end
			return true;
			end);
		return true;
		end);

		for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
			for pn_enemy=0,MAX_NUM_REAL_PLAYERS-1,1 do
				if (pn ~= pn_enemy) then
					if (_gsi.Players[pn].PeopleKilled[pn_enemy] > 0) then
						g_ShamansKilled[pn+1] = g_ShamansKilled[pn+1] + _gsi.Players[pn].PeopleKilled[pn_enemy];
						local shaman = getShaman(pn);
						if (shaman ~= nil) then
							shaman.Flags3 = hlp.enable_flag(shaman.Flags3, TF3_SHIELD_ACTIVE);
							shaman.u.Pers.u.Owned.ShieldCount = (shaman.u.Pers.u.Owned.ShieldCount + (_gsi.Players[pn].PeopleKilled[pn_enemy] * 10));
						end
						_gsi.Players[pn].PeopleKilled[pn_enemy] = 0;
					end
				end
			end
		end

		-- Dead players should have no spell shots
		for pn=1,#g_ShamansAlive do
			if (g_ShamansAlive[pn] == false) then
				_gsi.ThisLevelInfo.PlayerThings[pn-1].SpellsAvailable = 0;
				for i=0,NUM_SPELL_TYPES-1,1 do
					_gsi.ThisLevelInfo.PlayerThings[pn-1].SpellsAvailableOnce[i+1] = 0;
				end
			end
		end

		if (numOfShamans <= 1 and m.Winner ~= -1) then
			if (m.Ended == false) then
				m.EndRound();
				g_TurnEnd = turn;
			end
		else
			if (numOfShamans == 2) then
				m.setBank(0);
				m.setTexture(3);
			elseif (numOfShamans <= 4) then
				m.setBank(1);
				m.setInvisible(6, 3);
			else
				m.setBank(1);
				m.setInvisible(8, 3);
			end

			m.BlastTimer = m.BlastTimer + 1;
		end
	end

	return m;
end

function OnTurn()
	g_Turn = ((_gsi.Counts.GameTurn - g_TurnBegin) / 12);

	if (g_Turn == 0) then
		return;
	end

	if (g_Init == false) then
		for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
			local shaman = getShaman(pn);
			if (shaman ~= nil) then
				getPlayer(pn).ShamanLives = 99;
			end
		end
		g_Init = true;
	end

	if (g_Exit == false) then
		if (g_Manager == nil) then
			g_Manager = CRoundManager.new(6);
		end

		if (g_Manager.RoundEnded() == true) then
			g_Manager = nil;
		else
			if (g_Manager.RoundStarted() == false) then
				if ((g_Turn % 5) == 0) then
					if (g_Manager.CheckForRound() == true) then
						g_Manager.StartRound(g_Turn);
					end
				end
			else
				if ((g_Turn % 1) == 0) then
					g_Manager.ProcessRound(g_Turn);
				end
			end
		end
	else
		if (g_Turn % 1) then
			if (g_Turn > (g_TurnEnd + 3)) then
				ProcessGlobalTypeList(T_PERSON, function(t)
					if (t.Owner ~= g_Winner) then
						damage_person(t, TRIBE_HOSTBOT, 9999, TRUE);
					end
					return true
				end)
			end
		end
	end
end

function OnKeyDown(key)
    if (key == LB_KEY_TAB) then
        g_DrawMenu = not g_DrawMenu;
    end
	--[[
	if (key == LB_KEY_1) then
		for i=0,MAX_NUM_REAL_PLAYERS-1,1 do
			if (i ~= 0) then
				local shaman = getShaman(i);
				if (shaman ~= nil) then
					damage_person(shaman, TRIBE_HOSTBOT, 9999, TRUE);
				end
			end
		end
	end
	]]
end

function OnImGuiFrame()
    if (g_DrawMenu) then
        imgui.Begin('Statistics', nil, ImGuiWindowFlags_AlwaysAutoResize);

		imgui.Columns(4, "Stats");
	   	imgui.TextUnformatted("Player");
	   	imgui.NextColumn();
		imgui.TextUnformatted("Playing");
		imgui.NextColumn();
	   	imgui.TextUnformatted("Points");
		imgui.NextColumn();
		imgui.TextUnformatted("Kills");
		imgui.Separator();
		imgui.NextColumn();

		for pn=0,MAX_NUM_REAL_PLAYERS-1,1 do
			imgui.TextUnformatted(g_PlayerNames[pn+1] .. " [" .. tostring(pn+1) .. "]");
			imgui.NextColumn();
			imgui.TextUnformatted(tostring(g_ShamansAlive[pn+1]));
			imgui.NextColumn();
			imgui.TextUnformatted(tostring(g_Points[pn+1]) .. "/" .. tostring(MAX_POINTS));
			imgui.NextColumn();
			imgui.TextUnformatted(tostring(g_ShamansKilled[pn+1]));
			imgui.NextColumn();
		end

        imgui.End();
    end
end
