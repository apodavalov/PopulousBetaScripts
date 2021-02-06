--[[
	Author: Toxicity
	Idea by: Craig (TheBeginning)
	Repository: https://github.com/Toksisitee/PopulousBetaScripts
	Written: 22.12.2020
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
require("Scripts\\LibFlags")
require("Scripts\\LibSpells")
require("Scripts\\LibBuildings")

_gsi = gsi();
_gnsi = gnsi();
_constants = constants();
_shapes = {};
_constants.InvisNumPeopleAffected = 3;
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
sprite_age_w = { [0]= 4, 2, 4, 4, 4, 4 };
strings_score_width = { [0]= 25, 35, 45, 55, 65, 75 };
strings_large_width = { [0]= 150, 100, 80, 93, 133, 80 };
strings_small_width = { [0]= 95, 63, 49, 59, 82, 50 };
strings_name_width = { [0]= 85, 85, 85, 85, 85, 85, 85, 85 };
scores_width = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 }; -- New method
Font = {
	Large = P3_LARGE_FONT;
	Small = P3_SMALL_FONT_NORMAL;
};

Age = {
	None = 0,
	Tribal = 1,
	Fire = 2,
	Divine = 3,
	Ascension = 4,
	Max = 4
 };

 AgeStrings = { [0]= "UNINITIALIZED", "TRIBAL", "FIRE", "DIVINE", "ASCENSION", "MAX" };

 AdvanceState = {
	Checking = 0,
	InProgress = 1,
	MaxAge = 2
 };

 AdvanceReq = {
	[0]= { People = 0, Tepees = 0 }, -- None
	{ People = 35, Tepees = 6 }, 	 -- Tribal
	{ People = 80, Tepees = 13 }, 	 -- Fire
	{ People = 150, Tepees = 20 }, 	 -- Divine
	{ People = 0, Tepees = 0 } 	 	 -- Ascension
};

AllowedSpells = {
	[0]= { M_SPELL_NONE },
	{ M_SPELL_CONVERT_WILD, M_SPELL_BLAST, M_SPELL_INVISIBILITY, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT },
	{ M_SPELL_BLAST, M_SPELL_INVISIBILITY, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, M_SPELL_LAND_BRIDGE, M_SPELL_WHIRLWIND },
	{ M_SPELL_BLAST, M_SPELL_INVISIBILITY, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, M_SPELL_LAND_BRIDGE, M_SPELL_WHIRLWIND, M_SPELL_GHOST_ARMY, M_SPELL_FLATTEN, M_SPELL_EARTHQUAKE, M_SPELL_EROSION },
	{ M_SPELL_BLAST, M_SPELL_INVISIBILITY, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, M_SPELL_LAND_BRIDGE, M_SPELL_WHIRLWIND, M_SPELL_GHOST_ARMY, M_SPELL_FLATTEN, M_SPELL_EARTHQUAKE, M_SPELL_EROSION, M_SPELL_HYPNOTISM, M_SPELL_FIRESTORM, M_SPELL_VOLCANO }
};

AllowedBuildings = {
	[0]= { 0 }, -- None
	{ M_BUILDING_TEPEE, M_BUILDING_TEPEE_2, M_BUILDING_TEPEE_3, M_BUILDING_DRUM_TOWER, M_BUILDING_SPY_TRAIN }, -- Tribal
	{ M_BUILDING_TEPEE, M_BUILDING_TEPEE_2, M_BUILDING_TEPEE_3, M_BUILDING_DRUM_TOWER, M_BUILDING_SPY_TRAIN, M_BUILDING_WARRIOR_TRAIN, M_BUILDING_SUPER_TRAIN }, -- Fire
	{ M_BUILDING_TEPEE, M_BUILDING_TEPEE_2, M_BUILDING_TEPEE_3, M_BUILDING_DRUM_TOWER, M_BUILDING_SPY_TRAIN, M_BUILDING_WARRIOR_TRAIN, M_BUILDING_SUPER_TRAIN, M_BUILDING_TEMPLE }, -- Divine
	{ M_BUILDING_TEPEE, M_BUILDING_TEPEE_2, M_BUILDING_TEPEE_3, M_BUILDING_DRUM_TOWER, M_BUILDING_SPY_TRAIN, M_BUILDING_WARRIOR_TRAIN, M_BUILDING_SUPER_TRAIN, M_BUILDING_TEMPLE } -- Ascension
};

MaxTepees = { 
	[0]= 0, -- None
	8, -- Tribal
	15, -- Fire,
	22, -- Divine,
	1000 -- Ascension
};

AdvanceTimers = { 
	[0]= 0, 	-- None
	60*12,  	-- Tribal
	120*12, 	-- Fire
	180*12, 	-- Divine
	0, 			-- Ascension
};

ScorePeople = {
	[0]= 0, -- M_PERSON_NONE
	0, -- M_PERSON_WILD
	1, -- M_PERSON_BRAVE
	2, -- M_PERSON_WARRIOR
	3, -- M_PERSON_RELIGIOUS
	2, -- M_PERSON_SPY
	2, -- M_PERSON_SUPER_WARRIOR
	10, -- M_PERSON_MEDICINE_MAN
	5  -- M_PERSON_ANGEL
};

ScoreBuildings = {
	[0]= 0, -- None 0
	1, -- M_BUILDING_TEPEE 1
	2, -- M_BUILDING_TEPEE_2 2
	3, -- M_BUILDING_TEPEE_3 3
	2, -- M_BUILDING_DRUM_TOWER 4
	3, -- M_BUILDING_TEMPLE 5
	2, -- M_BUILDING_SPY_TRAIN 6
	2, -- M_BUILDING_WARRIOR_TRAIN 7
	2, -- M_BUILDING_SUPER_TRAIN 8
	0, -- M_BUILDING_RECONVERSION 9
	0, -- M_BUILDING_WALL_PIECE 10
	0, -- M_BUILDING_GATE 11
	0, -- M_BUILDING_CURR_OE_SLOT 12
	3, -- M_BUILDING_BOAT_HUT_1 13
	3, -- M_BUILDING_BOAT_HUT_2 14
	5, -- M_BUILDING_AIRSHIP_HUT_1 15 
	5, -- M_BUILDING_AIRSHIP_HUT_2 16
	0, -- M_BUILDING_GUARD_POST 17
	0, -- M_BUILDING_LIBRARY 18
	0 -- M_BUILDING_PRISON 19
};

ScoreAges = { [0]= 0, 0, 100, 200, 350 };

AverageTeamScore = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
AverageTeamScoreDigits = { [0]= 0, 0, 0, 0, 0, 0, 0, 0 };
Players = {
	[0]= 
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_BLUE,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 0",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 0;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_RED,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 1",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 1;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_YELLOW,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 2",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 2;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_GREEN,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 3",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 3;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_TURQUOISE,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 4",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 4;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_DARK_PURPLE,
		Score = 0,
		MaxScore =0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 5",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 5;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = CLR_BLACK,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 6",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
		ID = 6;
	},
	{
		Age = Age.None,
		State = AdvanceState.Checking,
		Timer = 0,
		Color = 14,
		Score = 0,
		MaxScore = 0,
		ScoreDigits = 0,
		AdvanceAlertTimer = 0,
		Name = "Player 7",
		TrainedSpies = 0,
		TrainedWarriors = 0,
		TrainedFirewarriors = 0,
		TrainedPreachers = 0,
		SpellsCast = 0,
		BlastsCasts = 0,
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

local function CachePlayerNameWidth(str, pn)
	local w = GetStringWidth(str);
	strings_name_width[pn] = w;
end

local function GetRandomPlayerActive()
	while true do 
		pn = G_RANDOM(8);
		if (_gsi.Players[pn].PlayerActive ~= 0) then
			return pn;
		end
	end
end

local function StartAdvanceTimer(pn)
	Players[pn].State = AdvanceState.InProgress;
	Players[pn].Timer = AdvanceTimers[Players[pn].Age];
end

local function CheckAdvanceRequirements(pn, skip_timer)
	if (Players[pn].Age == Age.Max) or (Players[pn].State ~= AdvanceState.Checking) then
		return;
	end

	local advance = false;
	local tepees = Bldg:GetTepees(pn, true);

	if (Players[pn].Age == Age.Tribal) then
		if (_gsi.Players[pn].NumPeople >= AdvanceReq[Age.Tribal].People and tepees >= AdvanceReq[Age.Tribal].Tepees) then
			if (_gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SPY_TRAIN] > 0) then
				advance = true;
			end
		end
	elseif (Players[pn].Age == Age.Fire) then
		if (_gsi.Players[pn].NumPeople >= AdvanceReq[Age.Fire].People and tepees >= AdvanceReq[Age.Fire].Tepees) then
			if (_gsi.Players[pn].NumBuildingsOfType[M_BUILDING_WARRIOR_TRAIN] > 0 and _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SUPER_TRAIN] > 0) then
				advance = true;
			end
		end
	elseif (Players[pn].Age == Age.Divine) then
		if (_gsi.Players[pn].NumPeople >= AdvanceReq[Age.Divine].People and tepees >= AdvanceReq[Age.Divine].Tepees) then
			if (_gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEMPLE] > 0) then
				advance = true;
			end
		end
	end

	if (advance == true) then
		if (skip_timer ~= true) then
			StartAdvanceTimer(pn);
		else
			AdvanceAge(pn, Players[pn].Age + 1);
		end
	end
end

local function AdvanceAge(pn, age)
	if (age > Age.Max) then
		return;
	end

	for m=M_SPELL_BLAST,NUM_SPELL_TYPES,1 do
		Spells:Disable(pn, m, false);
	end

	for m=0,NUM_BUILDING_TYPES,1 do
		if (m ~= M_BUILDING_GUARD_POST) then
			Bldg:Disable(pn, m);
		end
	end

	for k,v in pairs(AllowedSpells[age]) do
		Spells:Enable(pn, v);
		Spells:StartCharging(pn, v);
	end

	for k,v in pairs(AllowedBuildings[age]) do
		Bldg:Enable(pn, v);
	end

	Players[pn].Age = age
	Players[pn].State = AdvanceState.Checking;
	Players[pn].AdvanceAlertTimer = 12*4;
	if (age > Age.Tribal) then
		play_sound_event(getShaman(pn), SND_EVENT_PLACE_BOAT_HUT, SEF_FIXED_VARS);
	end
end

local function AdvanceAlertTimerProcess(pn)
	if (Players[pn].AdvanceAlertTimer > 0) then
		Players[pn].AdvanceAlertTimer = Players[pn].AdvanceAlertTimer - 1;
	end
end

local function AdvanceProcess(pn)
	if (Players[pn].Timer ~= 0) then
		Players[pn].Timer = Players[pn].Timer - 1;
		if ((_gsi.Counts.ProcessThings & _constants.ManaUpdateFreq) == 0) then
			_gsi.Players[pn].ManaUnspent = -math.floor(_gsi.Players[pn].LastManaIncr/2);;
		end
		if (Players[pn].Timer == 0) then
			AdvanceAge(pn, Players[pn].Age + 1);
		end
	end
end

local function Initialize()
	log_msg(TRIBE_NEUTRAL, "Age of Populous!");
	local delete_shots = false;
	-- Ensuring this doesn't clear the spell shots in MP. I'm using this method to test locally a lot.
	if (_gsi.Counts.GameTurn < 12) then 
		delete_shots = true; 
	end

	for pn=0,7,1 do
		if ((_gnsi.Flags & GNS_NETWORK) == GNS_NETWORK) then
			Players[pn].Name = get_player_name(pn, true);
			CachePlayerNameWidth(Players[pn].Name, pn);
		end
		for m=M_SPELL_BLAST,NUM_SPELL_TYPES,1 do
			Spells:Disable(pn, m, delete_shots);
		end
		for m=0,NUM_BUILDING_TYPES,1 do
			if (m ~= M_BUILDING_GUARD_POST) then
				Bldg:Disable(pn, m);
			end
		end
		AdvanceAge(pn, Age.Tribal);
	end
end

local function CalculateScore()
	for pn=0,7,1 do
		Players[pn].Score = 0 + ScoreAges[Players[pn].Age] + (_gsi.Players[pn].LastManaIncr * 0.10);
		for e=0,7,1 do
			if (e ~= pn) then
				Players[pn].Score = Players[pn].Score + _gsi.Players[pn].PeopleKilled[e];
			end
		end
		for m=M_PERSON_BRAVE,NUM_PEOPLE_TYPES,1 do
			Players[pn].Score = Players[pn].Score + (_gsi.Players[pn].NumPeopleOfType[m] * ScorePeople[m]);
		end
		for m=M_BUILDING_TEPEE,NUM_BUILDING_TYPES,1 do
			Players[pn].Score = Players[pn].Score + (_gsi.Players[pn].NumBuildingsOfType[m] * ScoreBuildings[m]);
			if (ScoreBuildings[m] > 0) then
				Players[pn].Score = Players[pn].Score + (_gsi.Players[pn].NumBuiltOrPartBuiltBuildingsOfType[m] * (ScoreBuildings[m] - 1));
			end
		end
		if (Players[pn].Score > Players[pn].MaxScore) then
			Players[pn].MaxScore = math.ceil(Players[pn].Score);
		end
		Players[pn].Score = math.ceil(Players[pn].Score);
	end

	local avg_score;
	for i=0,7,1 do
		avg_score = 0;
		local allies = {};
		for j=0,7,1 do
			if ((are_players_allied(i, j) > 0) and (are_players_allied(j, i) > 0)) then
				table.insert(allies, j);
			end
		end
		for k=1,#allies,1 do
			avg_score = avg_score + Players[allies[k]].Score;
		end
		AverageTeamScore[i] = math.floor(avg_score / (#allies));
		AverageTeamScoreDigits[i] = #tostring(avg_score);
		Players[i].ScoreDigits = #tostring(Players[i].Score);
		scores_width[i] = GetStringWidth(string.format(": %s/%s", Players[i].Score, AverageTeamScore[i])) + 10;
	end

	local tmp = deepcopy(Players);
	PlayersHighestScore = quicksort(tmp, "Score", 0);
end

trivia = 0;
trivia_pos = 0;
trivia_str = "";
local function Trivia()
	trivia = trivia + 1;
	if (trivia > 12) then
		trivia = 0;
	end
	if (trivia == 0) then
		local pn = GetRandomPlayerActive();
		trivia_str = string.format("%s has so far cast %s Blasts!", Players[pn].Name, Players[pn].BlastsCasts);
	elseif (trivia == 1) then
		local pn = GetRandomPlayerActive();
		trivia_str = string.format("%s has so far cast %s spells!", Players[pn].Name, Players[pn].BlastsCasts);
	elseif (trivia == 2) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "TrainedWarriors", 0);
		trivia_str = string.format("%s trained the most Warriors so far with a staggering amount of %s units!", tmp2[7].Name, tmp2[7].TrainedWarriors);
	elseif (trivia == 3) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "BlastsCasts", 0);
		trivia_str = string.format("%s has cast the most Blast shots! ( %s ) !", tmp2[7].Name, tmp2[7].BlastsCasts);
	elseif (trivia == 4) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "TrainedSpies", 0);
		trivia_str = string.format("%s trained the most Spies so far with a staggering amount of %s units! <3 Spies", tmp2[7].Name, tmp2[7].TrainedSpies);
	elseif (trivia == 5) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "MaxScore", 0);
		if (tmp2[7].Score <  tmp2[7].MaxScore) then
			trivia_str = string.format("%s was once thriving and leading the charts with a score of %s", tmp2[7].Name, tmp2[7].MaxScore);
		else
			trivia_str = string.format("%s is currently leading the charts with a score of %s", tmp2[7].Name, tmp2[7].MaxScore);
		end
	elseif (trivia == 6) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "TrainedFirewarriors", 0);
		trivia_str = string.format("%s trained the most Firewarriors so far with a staggering amount of %s units!", tmp2[7].Name, tmp2[7].TrainedFirewarriors);
	elseif (trivia == 7) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "SpellsCast", 0);
		trivia_str = string.format("%s is leading with an impressive amount of %s spell casts!", tmp2[7].Name, tmp2[7].SpellsCast);
	elseif (trivia == 8) then
		local pn = GetRandomPlayerActive();
		trivia_str = string.format("%s has cast %s Blasts!", Players[pn].Name, Players[pn].BlastsCasts);
	elseif (trivia == 9) then
		local tmp = deepcopy(Players);
		local tmp2 = quicksort(tmp, "TrainedPreachers", 0);
		trivia_str = string.format("%s trained the most Preachers so far with a staggering amount of %s units!", tmp2[7].Name, tmp2[7].TrainedPreachers);
	elseif (trivia == 10) then
		local pn = GetRandomPlayerActive();
		local pn2 = 0;
		for i=0,10,1 do
			pn2 = GetRandomPlayerActive();
			if (pn ~= pn2) then
				break;
			end
		end
		trivia_str = string.format("%s murdered a total of %s units belonging to %s !", Players[pn].Name, _gsi.Players[pn].PeopleKilled[pn2], Players[pn2].Name);
	elseif (trivia == 11) then
		local mana_inc = {};
		for i=0,7,1 do 
			table.insert(mana_inc, { i, _gsi.Players[i].LastManaIncr });
		end
		local tmp2 = quicksort(mana_inc, 2, 1);
		trivia_str = string.format("%s is generating the most mana ( %s ) !", Players[mana_inc[8][1]].Name, mana_inc[8][2]);
	elseif (trivia == 12) then
		local pn = GetRandomPlayerActive();
		pn = 0;
		trivia_str = string.format("%s has lost %s units to enemy preachers!", Players[pn].Name, _gsi.Players[pn].NumPeopleConverted);
	end
	trivia_pos = -1000; -- Need to make sure long string don't spawn on screen
end

Initialize();

------------------------------------------------------------------------------------------------------------------------
------------------ Game Hooks ------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function OnCreateThing(t)
	if (t.Type == T_SPELL) then
		local allowed = false;
		for k,v in pairs(AllowedSpells[Players[t.Owner].Age]) do
			if (t.Model == v) then
				allowed = true;
				break;
			end
		end
		if (allowed ~= true) then
			if (t.Model == M_SPELL_CONVERT_WILD) then
				Spells:Disable(t.Owner, t.Model, true);
			else
				Spells:Disable(t.Owner, t.Model, false); -- -- Do not remove the spell shots, player might have gotten a Stonehead reward?
			end
			t.Model = M_SPELL_NONE;
		else 
			Players[t.Owner].SpellsCast = Players[t.Owner].SpellsCast + 1;
			if (t.Model == M_SPELL_BLAST) then
				Players[t.Owner].BlastsCasts = Players[t.Owner].BlastsCasts + 1;
			end
		end
	end
	if (t.Type == T_SHAPE) then
		if (t.u.Shape.BldgModel <= M_BUILDING_TEPEE_3) then
			if (Players[t.Owner].Age ~= Age.Max) then
				local existing = 1; -- This shape counts as 1, I later have a check (_t ~= t) to ensure I don't add the same shape twice
				local is_bldg = false;

				-- If you think this is not needed, think again
				-- Do not fucking touch, future me
				--local me = MAP_ELEM_IDX_2_PTR(world_coord2d_to_map_idx(t.Pos.D2));
				--local bldg = me.ShapeOrBldgIdx:get();
				--if (bldg ~= nil) then -- Need to make sure it's not a building under construction
					--is_bldg = true;
				--	existing = existing - 1;
				--end
				
				ProcessGlobalSpecialList(t.Owner, BUILDINGMARKERLIST, function(_t)
					if (_t.u.Shape.BldgModel <= M_BUILDING_TEPEE_3) then
						if (_t ~= t) then
							local me = MAP_ELEM_IDX_2_PTR(world_coord2d_to_map_idx(_t.Pos.D2));
							local bldg = me.ShapeOrBldgIdx:get();
							if (bldg ~= nil and bldg.Type == T_BUILDING and bldg.State == S_BUILDING_STAND) then -- Need to make sure it's not a building under construction
								existing = existing - 1;
								--local c3d = Coord3D.new();
								--map_idx_to_world_coord3d(world_coord2d_to_map_idx(_t.Pos.D2), c3d);
								--createThing(T_EFFECT, M_EFFECT_CONVERT_WILD, 0, c3d, false, false);
							end

							existing = existing + 1;
						end
					end
					return true
				end);

				existing = existing + Bldg:GetTepees(t.Owner, true);
				--log_msg(0, "Existing " .. existing .. ", Max: " .. MaxTepees[Players[t.Owner].Age])
				if (existing > MaxTepees[Players[t.Owner].Age]) then
					--if (is_bldg == false) then
						--log_msg(0, "Added to list")
						local objProxy = ObjectProxy.new();
						objProxy:set(t.ThingNum)
						table.insert(_shapes, objProxy);
					--end
				end
			end
		else
			local allowed = false;
			for k,v in pairs(AllowedBuildings[Players[t.Owner].Age]) do
				if (t.u.Shape.BldgModel == v) then
					allowed = true;
					break;
				end
			end
			if (allowed ~= true) then
				--Bldg:Disable(t.Owner, t.u.Shape.BldgModel); -- Do not remove the building discovery, player might have gotten a Stonehead reward?
				local objProxy = ObjectProxy.new();
				objProxy:set(t.ThingNum)
				table.insert(_shapes, objProxy);
			end
		end
	end
	if (t.Type == T_PERSON) then
		if (t.Model == M_PERSON_SPY) then
			Players[t.Owner].TrainedSpies = Players[t.Owner].TrainedSpies + 1;
		elseif (t.Model == M_PERSON_WARRIOR) then
			Players[t.Owner].TrainedWarriors = Players[t.Owner].TrainedWarriors + 1;
		elseif (t.Model == M_PERSION_SUPER_WARRIOR) then
			Players[t.Owner].TrainedFirewarriors = Players[t.Owner].TrainedFirewarriors + 1;
		elseif (t.Model == M_PERSON_RELIGIOUS) then
			Players[t.Owner].TrainedPreachers = Players[t.Owner].TrainedPreachers + 1;
		end
	end
end

local function CleanShapesTable()
	local tbl = {};
	for i=0,#_shapes,1 do
		if (_shapes[i] ~= nil) then
			table.insert(tbl, _shapes[i]);
		end
	end
	_shapes = tbl;
end

function OnTurn()
	if (#_shapes > 0) then
		local i = 1;
		for k,v in pairs(_shapes) do
			if (_shapes[i] ~= nil) then
				if (v:isNull() ~= true) then
					local t = v:get();
					local me = MAP_ELEM_IDX_2_PTR(world_coord2d_to_map_idx(t.Pos.D2));
					local bldg = me.ShapeOrBldgIdx:get();
					if (bldg == nil) then
						process_shape_map_elements(world_coord2d_to_map_idx(t.Pos.D2), t.u.Shape.BldgModel, t.u.Shape.Orient, t.Owner, SHME_MODE_REMOVE_PERM);
					elseif (bldg.Type ~= T_BUILDING) then
						--if (bldg.u.Bldg.HasBuildingExistedBefore == 0) then -- Doesn't make sense to check for this, since it's not a building
							process_shape_map_elements(world_coord2d_to_map_idx(t.Pos.D2), t.u.Shape.BldgModel, t.u.Shape.Orient, t.Owner, SHME_MODE_REMOVE_PERM);
						--end
					end
				
					_shapes[i] = nil;
					--[[
					local me = MAP_ELEM_IDX_2_PTR(world_coord2d_to_map_idx(t.Pos.D2));
					null = ObjectProxy.new();
					null:set(0);
					me.ShapeOrBldgIdx = null;
					set_map_elem_owner(me, 0);
					me.Flags = Flags:Unset(me.Flags, 1<<10);
					me.Flags = Flags:Set(me.Flags, 1<<4);
					me.Flags = Flags:Unset(me.Flags, 1<<14);
					_shapes[i] = nil;
					--DestroyThing(t);
					]]
				end
			end
			i = i + 1;
		end
	end

	CleanShapesTable();

	if (EVERY_2POW_TURNS(3)) then
		CalculateScore();
	end

	if (EVERY_2POW_TURNS(4)) then
		for pn=0,7,1 do
			CheckAdvanceRequirements(pn, false);
		end
	end

	-- Process each game turn
	for pn=0,7,1 do
		AdvanceProcess(pn);
		AdvanceAlertTimerProcess(pn);
	end

	if (EVERY_2POW_TURNS(10)) then
		Trivia();
	end
end

function CacheStringsWidth()
	SetFont(Font.Large);
	PopSetFont(Font.Large);
	local i = 0;
	local w = 0;
	for k,v in pairs(AgeStrings) do
		w = 0;
		local s = v .. " AGE";
		for j=1,#s,1 do
			w = w + CharWidth2();
			--w = w + GetCharWidth(s:sub(j,j)) + 1;
		end
		strings_large_width[i] = w;
		i = i + 1;
	end
	SetFont(Font.Small);
	PopSetFont(Font.Small);
	i = 0;
	for k,v in pairs(AgeStrings) do
		w = 0;
		local s = v .. " AGE";
		for j=1,#s,1 do
			w = w + CharWidth2();
			--w = w + GetCharWidth(s:sub(j,j)) + 1;
		end
		strings_small_width[i] = w; 
		i = i + 1;
	end
end

local function DrawRequirements(pn, offset)
	if (Players[pn].Age == Age.Max) then
		return;
	end

	local tepees = Bldg:GetTepees(pn, true);
	local str = string.format("Population: %s/%s  Huts: %s/%s  ", _gsi.Players[pn].NumPeople, AdvanceReq[Age.Tribal].People, tepees, AdvanceReq[Age.Tribal].Tepees);
	if (Players[pn].Age == Age.Tribal) then
		str = str .. string.format("Spy Hut: %s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SPY_TRAIN]);
	elseif (Players[pn].Age == Age.Fire) then
		str = str .. string.format("Warrior Hut: %s/1  FW Hut: %s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_WARRIOR_TRAIN], _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SUPER_TRAIN]);
	elseif (Players[pn].Age == Age.Divine) then
		str = str .. string.format("Temple: %s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEMPLE]);
	end

	LbDraw_Text(250, ScreenHeight()-20, str , 0);
end

bar_w = 200;
bar_h = 15;
box_y_offset = 20;
offset_incr = 30;
names_offset = 40;
function OnFrame()
	offset = 0;
	for i=0,7,1 do
		local pn = PlayersHighestScore[i].ID;
		if (Players[pn].MaxScore ~= 0) then -- Show only active players (or previously active but now dead)
			local age = Players[pn].Age;
			PopSetFont(Font.Large);
			local scale = math.floor(ScreenHeight() * 0.01);
			local score_width = scores_width[pn];
			local text_y_offset = 2 - math.ceil((bar_h/2)-2);
			if (Players[pn].AdvanceAlertTimer ~= 0) then
				DrawBox(ScreenWidth()-math.floor(bar_w*0.70), ScreenHeight()-box_y_offset-scale-offset, 25, bar_h+scale, Players[pn].Color);
				if (_gsi.Counts.GameTurn & 2 == 0) then
					LbDraw_Text(ScreenWidth()-math.floor(bar_w*0.50), ScreenHeight()-box_y_offset-scale-text_y_offset-offset, "ADVANCED!", 10); 
				end
				LbDraw_ScaledSprite(ScreenWidth()-math.floor(bar_w*0.55)-32+sprite_age_w[age], ScreenHeight()-box_y_offset-scale-offset+6, get_sprite(0, 219+age), 16, 16);
			elseif (Players[pn].State == AdvanceState.InProgress and AdvanceTimers[age] ~= 0) then
				DrawBox(ScreenWidth()-(bar_w+5), ScreenHeight()-box_y_offset-scale-offset, bar_w+2, bar_h+scale+2, 1);
				DrawBox(ScreenWidth()-(bar_w+5), ScreenHeight()-box_y_offset-scale-offset, bar_w, bar_h+scale, 0);
				local progress = Players[pn].Timer * 100 / AdvanceTimers[age];
				progress = (bar_w * Players[pn].Timer) / AdvanceTimers[age];
		
				DrawBox(ScreenWidth()-(bar_w+5), ScreenHeight()-box_y_offset-scale-offset, math.floor(bar_w-progress), bar_h+scale, Players[pn].Color);
				LbDraw_Text(ScreenWidth()-bar_w, ScreenHeight()-box_y_offset-scale-text_y_offset-offset, AgeStrings[age + 1] .. " AGE", 0);
			else
				-- Do not change this string without updating scores_width
				local str = string.format(": %s/%s",Players[pn].Score, AverageTeamScore[pn]);
				DrawBox(ScreenWidth()-score_width-32-strings_name_width[pn], ScreenHeight()-box_y_offset-scale-offset, 25, bar_h+scale, Players[pn].Color);
				LbDraw_Text(ScreenWidth()-score_width-strings_name_width[pn], ScreenHeight()-box_y_offset-scale-text_y_offset-offset, Players[pn].Name, 0);
				LbDraw_Text(ScreenWidth()-score_width, ScreenHeight()-box_y_offset-scale-text_y_offset-offset, str, 0);
				LbDraw_ScaledSprite(ScreenWidth()-score_width-32+sprite_age_w[age]-strings_name_width[pn], ScreenHeight()-box_y_offset-scale-offset+6, get_sprite(0, 219+age), 16, 16);
			end
			offset = offset + offset_incr;
		end
	end

	--if (GUICurrentMenu ~= nil) then
		if (_gnsi.Flags & GNS_PAUSED == 0) then
			local pn = _gnsi.PlayerNum;
			if (Players[pn].Age ~= Age.Max) then
				local gw = GFGetGuiWidth();
				local menu = GUICurrentMenu();
				if (menu== 3 or menu == 6) then
					if (Players[pn].Age ~= Age.Max) then
						local tepee_req = string.format("%s/%s", Bldg:GetTepees(pn, true), AdvanceReq[Players[pn].Age].Tepees);
						LbDraw_Text(math.floor(gw*0.26), math.floor(ScreenHeight()*0.51), tepee_req, 0);
						if (Players[pn].Age == Age.Tribal) then
							LbDraw_Text(math.floor(gw*0.34), math.floor(ScreenHeight()*0.735), string.format("%s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SPY_TRAIN]), 0);
						elseif (Players[pn].Age == Age.Fire) then
							LbDraw_Text(math.floor(gw*0.29), math.floor(ScreenHeight()*0.625), string.format("%s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_WARRIOR_TRAIN]), 0);
							LbDraw_Text(math.floor(gw*0.74), math.floor(ScreenHeight()*0.735), string.format("%s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_SUPER_TRAIN]), 0);
						elseif  (Players[pn].Age == Age.Divine) then
							LbDraw_Text(math.floor(gw*0.74), math.floor(ScreenHeight()*0.625), string.format("%s/1", _gsi.Players[pn].NumBuildingsOfType[M_BUILDING_TEMPLE]), 0);
						end
					end
				elseif (menu == 4) then
					local people_req = string.format("Population: %s/%s", _gsi.Players[pn].NumPeople, AdvanceReq[Players[pn].Age].People);
					local max_tepees = string.format("Max Huts: %s", MaxTepees[Players[pn].Age]);
					--DrawBox(math.floor(gw*0.04), math.floor(ScreenHeight()*0.396), GFGetGuiWidth()-13, 24, Players[pn].Color);
					DrawBox(0, math.floor(ScreenHeight()*0.78), gw, ScreenHeight(), 1);
					LbDraw_Text(7, math.floor(ScreenHeight()*0.80), people_req, 0);
					LbDraw_Text(7, math.floor(ScreenHeight()*0.83), max_tepees, 0);
				end
			end
		end
	--end
	--LbDraw_ScaledSprite(math.floor(ScreenWidth()*0.06), math.floor(ScreenHeight()*0.51), get_sprite(0, 219), 16, 16);


	if (trivia_pos < ScreenWidth() + 500) then
		PopSetFont(Font.Large);
		LbDraw_Text(trivia_pos, ScreenHeight()-20, trivia_str, 0);
		trivia_pos = trivia_pos + 1;
		--DrawRequirements(0, 20);	
	--else
	--	DrawRequirements(_gnsi.PlayerNum, 20);
	end
end
--[[
function OnChat(from, str)
	if (str == "/names") then
		if (gnsi.PlayerNum == from) then
			show_names = true;
		end
	end
end
]]
function OnSave(save)
	--log_msg(TRIBE_NEUTRAL, "OnSave");
	for pn=0,7,1 do
		-- Save timer first intentionally
		save:push_int(Players[pn].Timer);
		save:push_int(Players[pn].State);
		save:push_int(Players[pn].Age);
		save:push_int(Players[pn].MaxScore);
		save:push_int(Players[pn].TrainedSpies);
		save:push_int(Players[pn].TrainedWarriors);
		save:push_int(Players[pn].TrainedFirewarriors);
		save:push_int(Players[pn].TrainedPreachers);
		save:push_int(Players[pn].SpellsCast);
		save:push_int(Players[pn].BlastsCasts);
	end
	--log_msg(TRIBE_NEUTRAL, "OnSave Exit");
end

-- Do not call Initialize() in here. It's a bad idea.
function OnLoad(load)
	--log_msg(TRIBE_NEUTRAL, "OnLoad");
	for pn=7,0,-1 do
		for m=M_SPELL_BLAST,NUM_SPELL_TYPES,1 do
			Spells:Disable(pn, m, false);
		end
		for m=0,NUM_BUILDING_TYPES,1 do
			if (m ~= M_BUILDING_GUARD_POST) then
				Bldg:Disable(pn, m);
			end
		end
		Players[pn].BlastsCasts = load:pop_int();
		Players[pn].SpellsCast = load:pop_int();
		Players[pn].TrainedPreachers = load:pop_int();
		Players[pn].TrainedFirewarriors = load:pop_int();
		Players[pn].TrainedWarriors = load:pop_int();
		Players[pn].TrainedSpies = load:pop_int();
		Players[pn].MaxScore = load:pop_int();
		Players[pn].Age = load:pop_int();
		for i=1,Players[pn].Age,1 do
			AdvanceAge(pn, i); -- This clears the timer and state. Has to be processed first.
		end
		Players[pn].State = load:pop_int();
		Players[pn].Timer = load:pop_int();
	end
	--log_msg(TRIBE_NEUTRAL, "OnLoad Exit");
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

--[[
import(Module_Helpers)
pndbg = 0
function OnKeyDown(k)
	if k == LB_KEY_1 then
		if (pndbg > 7) then
			pndbg = 0;
		end
		StartAdvanceTimer(pndbg);
		pndbg = pndbg + 2;
		--AdvanceAge(0, Players[0].Age + 1)
	elseif k == LB_KEY_2 then
		log_msg(0, "GUICurrentMenu " .. GUICurrentMenu())
		--Trivia();
		--Initialize();
		--StartAdvanceTimer(0);
		--for i=0,1,1 do
		--AdvanceAge(i, Players[i].Age + 1)
		--end
	end
end
]]

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