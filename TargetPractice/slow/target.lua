--[[
	Author: Toxicity
	Idea & Map: Keith52
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 31.12.2020
	Last revision: 31.12.2020
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

MODE_FAST = 0;
MODE_LAST_STANDING = 1;
mode = MODE_LAST_STANDING; -- 0 fast charge, 1 last standing
_gsi = gsi();
_gnsi = gnsi();
strings_name_width = { [0]= 85, 85, 85, 85, 85, 85, 85, 85 };
people_width = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
killed_width = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
score_width = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
score_str= { [0]= "", "", "", "", "", "", "", "" };
initial_people = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
last_gain = 0;
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

Players = {
	[0]= 
	{
		Population = -1,
		Kills = -1,
		Color = CLR_BLUE,
		Name = "Player 0",
		ID = 0;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_RED,
		Name = "Player 1",
		ID = 1;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_YELLOW,
		Name = "Player 2",
		ID = 2;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_GREEN,
		Name = "Player 3",
		ID = 3;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_TURQUOISE,
		Name = "Player 4",
		ID = 4;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_DARK_PURPLE,
		Name = "Player 5",
		ID = 5;
	},
	{
		Population = -1,
		Kills = -1,
		Color = CLR_BLACK,
		Name = "Player 6",
		ID = 6;
	},
	{
		Population = -1,
		Kills = -1,
		Color = 14,
		Name = "Player 7",
		ID = 7;
	};
};

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

function GetKills(pn)
	local killed = 0;
	for i=0,7,1 do
		if (pn ~= i) then
			killed = killed + _gsi.Players[pn].PeopleKilled[i];
			Players[pn].Kills = killed;
		--	killed_width[pn] = GetStringWidth(to_string(killed));
		end
	end

	return Players[pn].Kills;
end

function GetPeople(pn)
	local people = _gsi.Players[pn].NumPeopleOfType[M_PERSON_BRAVE];
	--people_width[pn] = GetStringWidth(to_string(people));
	return people;
end

local function CachePlayerNameWidth(str, pn)
	local w = GetStringWidth(str);
	strings_name_width[pn] = w;
end

local function CalculateScore(pn)
	--local str = string.format("People %s/%s - Kills %s", GetPeople(pn), initial_people[pn], GetKills(pn));
	local str = string.format("People %s/%s - Kills %s", GetPeople(pn), initial_people[pn], GetKills(pn));
	score_str[pn] = str;
	score_width[pn] = GetStringWidth(str) + 15;
end

function Initialize()
	log_msg(TRIBE_NEUTRAL, "Starting in 5");
	for pn=0,7,1 do
		for m=M_SPELL_BLAST,NUM_SPELL_TYPES,1 do
			Spells:Disable(pn, m, true);
		end
		for m=0,NUM_BUILDING_TYPES,1 do
			if (m ~= M_BUILDING_GUARD_POST) then
				Bldg:Disable(pn, m);
			end
		end
		Spells:Enable(pn, M_SPELL_BLAST);
		for i=0,3,1 do	
			GIVE_ONE_SHOT(M_SPELL_BLAST, pn);
		end
		Players[pn].Kills = 0; 
		initial_people[pn] = GetPeople(pn);
		if (_gnsi.Flags & GNS_NETWORK == 1) then
			Players[pn].Name = get_player_name(pn, true);
			CachePlayerNameWidth(Players[pn].Name, pn);
		end
	end
end

sec = 12*1;
countdown = 12*5;
function OnTurn()
	if (EVERY_2POW_TURNS(2)) then
		for pn=0,7,1 do
			CalculateScore(pn);
		end
		local tmp = deepcopy(Players);
		PlayersHighestScore = quicksort(tmp, "Kills", 0);
	end

	if (countdown > 0) then
		countdown = countdown - 1;
		if (countdown % 12 == 0) then
			if (countdown ~= 0) then
				log_msg(TRIBE_NEUTRAL, "Starting in " .. math.floor(countdown/12));
			else
				log_msg(TRIBE_NEUTRAL, "START");
			end
		end
	end

	if (sec > 0) then
		sec = sec - 1;
		if (sec == 0) then
			sec = 12*1;
			for pn=0,7,1 do
				local gain = 0;
				if (mode == MODE_FAST) then
					gain = math.floor((10 + _gsi.Players[pn].NumPeopleOfType[M_PERSON_BRAVE]) * 250);
				else 
					gain = math.floor((5 + _gsi.Players[pn].NumPeopleOfType[M_PERSON_BRAVE]) * 150);
				end
				--if (gain < 5000) then
				--	gain = 5000;
				--end
				if (pn == _gnsi.PlayerNum) then
					last_gain = gain;
				end
				_gsi.Players[pn].ManaUnspent = gain;
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
		if (initial_people[pn] ~= 0) then -- Show only active players (or previously active but now dead)
			PopSetFont(Font.Large);
			-- Player box
			DrawBox(ScreenWidth()-score_width[pn]-47-strings_name_width[pn], ScreenHeight()-box_y_offset-offset-5, 25, bar_h, Players[pn].Color);
			-- Name
			LbDraw_Text(ScreenWidth()-score_width[pn]-strings_name_width[pn]-15, ScreenHeight()-box_y_offset-offset-5, Players[pn].Name, 0);
			-- Score
			LbDraw_Text(ScreenWidth()-score_width[pn], ScreenHeight()-box_y_offset-offset-5, score_str[pn], 0);
			offset = offset + offset_incr;
		end
	end

	--if (_gnsi.Flags & GNS_NETWORK == 0) then
		local str = string.format("Generated Mana: %s", last_gain);
		local w = GetStringWidth(str);
		LbDraw_Text(ScreenWidth()-w-25, 25, str, 0);
	--end
end

function OnCreateThing(t)
	if (t.Type == T_SPELL) then
		if (countdown ~= 0) then
			t.Model = M_SPELL_NONE;
		end
	end
end

import(Module_Helpers)
function OnKeyDown(k)
	if (_gnsi.Flags & GNS_NETWORK == 0) then
		if k == LB_KEY_1 then
			ProcessGlobalSpecialList(0, PEOPLELIST, function(t)
				if (t.Model == M_PERSON_BRAVE) then
					t.u.Pers.Life = 0;
					return false;
				end
				return true
			end);
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