-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- Haste II has the same buff ID [33], so we have to use a toggle. 
-- Self-Command for Haste: //gs c toggle hastemode 
-- Toggles whether or not you're getting Haste II

function get_sets()
	mote_include_version = 2
	include('Mote-Include.lua')
	require('vectors')
end

-- Setup vars that are user-independent.
function job_setup()
	state.Buff.Migawari = buffactive.migawari or false
	state.Buff.Doomed = buffactive.doomed or false
	state.Buff.Sange = buffactive.Sange or false
	state.Buff.Yonin = buffactive.Yonin or false
	state.Buff.Innin = buffactive.Innin or false
	state.Buff.Futae = buffactive.Futae or false

	include('Mote-TreasureHunter')
	state.TreasureMode:set('None')
	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Trusts', 'Dunna', 'Idris'}

	select_ammo()
	LugraMoonList = S{'Blade: Ten',}
	LugraLugraList = S{'Blade: Ku', 'Blade: Jin', 'Blade: Chi', 'Blade: Shun', 'Blade: Metsu'}
	gavialis_ws = S{'Blade: Shun'}

	gear.RegularAmmo = 'Happo Shuriken'
	gear.SangeAmmo = 'Happo Shuriken'
	gear.MovementFeet = {name="Danzo Sune-ate"}
	gear.DayFeet = "Danzo Sune-ate"
	gear.NightFeet = "Hachiya Kyahan +1"
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Eschan Stone"
	
	update_combat_form()

	state.warned = M(false)
	options.ammo_warning_limit = 25
	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	windower.register_event('time change', time_change)	
	-- Options: Override default values
	state.OffenseMode:options ('Normal', 'Acc', 'Acc2', 'Acc3')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'PDT', 'Crit')
	state.CastingMode:options('Normal', 'Resistant', 'Burst')
	state.IdleMode:options('Normal')
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds
	send_command('bind ^= gs c cycle treasuremode')
	send_command('bind ^[ input /lockstyle on')
	send_command('bind ![ input /lockstyle off')
	send_command('bind !` gs c cycle HasteMode')
	send_command('bind @` gs c cycle MarchMode')
	send_command('bind @1 gs c cycle HybridMode')
	send_command('bind ` input /jump')
	
	select_movement_feet()
	select_default_macro_book()
end

function file_unload()
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind ^=')
	send_command('unbind !=')
	send_command('unbind @f9')
	send_command('unbind @[')
	send_command('unbind `')
end

-- Define sets and vars used by this job file.
-- sets.engaged[state.CombatForm][state.CombatWeapon][state.OffenseMode][state.HybridMode][classes.CustomMeleeGroups] (any number)
-- Ninjutsu tips
-- To stick Slow (Hojo) lower earth resist with Raiton: Ni
-- To stick poison (Dokumori) or Attack down (Aisha) lower water resist with Katon: Ni
-- To stick paralyze (Jubaku) lower ice resistence with Huton: Ni
function init_gear_sets()
	--------------------------------------
	-- Augments
	--------------------------------------
	JSECAPE = {}
	JSECAPE.DA 	= {}
	JSECAPE.STP 	= {}
	JSECAPE.AGIWS	= {}
	JSECAPE.DEXWS 	= {}
	JSECAPE.MAB 	= {}
	JSECAPE.FC 	= {}
	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA['Mijin Gakure'] = {}
	sets.precast.JA['Futae'] = {}
	sets.precast.JA['Sange'] = {}
	
	sets.precast.JA['Provoke'] = {}
	sets.midcast.Flash = set_combine(sets.precast.JA['Provoke'], {})
	sets.precast.Waltz = {}
	sets.precast.Waltz['Healing Waltz'] = {}
	sets.precast.Step = {}	
	sets.precast.Flourish1 = set_combine(sets.precast.Step, {})
	sets.midcast["Apururu (UC)"] = {body="Apururu Unity shirt"}

	--------------------------------------
	-- Utility Sets for rules below
	--------------------------------------
	sets.TreasureHunter = {waist="Chaac Belt"}
	sets.WSDayBonus     = {}
	sets.BrutalLugra    = {ear1="Lugra Earring +1",		ear2="Brutal Earring"}
	sets.BrutalTrux     = {ear1="Trux Earring",			ear2="Brutal Earring"}
	sets.BrutalMoon     = {ear1="Moonshade Earring",	ear2="Brutal Earring"}
	sets.IshvaraMoon	= {ear1="Moonshade Earring",	ear2="Ishvara Earring"}
	sets.LugraMoon		= {ear1="Moonshade Earring",	ear2="Lugra Earring +1"}
	sets.DualLugra		= {ear1="Lugra Earring +1",		ear2="Brutal Earring"}
	sets.IshvaraCessance= {ear1="Ishvara Earring", 		ear2="Brutal Earring"}
	sets.IshvaraBrutal  = {ear1="Ishvara Earring", 		ear2="Brutal Earring"}
	
	sets.RegularAmmo    = {ammo=gear.RegularAmmo}
	sets.SangeAmmo      = {ammo=gear.SangeAmmo}

	--------------------------------------
	-- Ranged
	--------------------------------------
	-- Snapshot for ranged
	sets.precast.RA = {ammo="Happo Shuriken"}
	
	sets.midcast.RA = {}
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})
	sets.midcast.RA.TH = set_combine(sets.midcast.RA, sets.TreasureHunter)

	----------------------------------
    -- Casting
	----------------------------------
	-- Precasts
	sets.precast.FC = {
	    ammo="Sapience Orb",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Odyss. Chestplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Orunmila's Torque",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Rahab Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",
	}
	
	sets.precast.FC.ElementalNinjutsuSan = set_combine(sets.precast.FC, {})
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",})
	
	-- Midcasts
	-- FastRecast (A set to end in when no other specific set is built to reduce recast time)
	sets.midcast.FastRecast = {}

	-- Magic Accuracy Focus 
	sets.midcast.Ninjutsu = {}
	
	-- Any ninjutsu cast on self - Recast Time Focus
	sets.midcast.SelfNinjutsu = set_combine(sets.midcast.Ninjutsu, {})
	sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {})
	sets.midcast.Migawari = set_combine(sets.midcast.SelfNinjutsu, {})

	-- Nuking Ninjutsu (skill & magic attack)
	sets.midcast.ElementalNinjutsu = {}

	sets.midcast.ElementalNinjutsu.Burst 		= set_combine(sets.midcast.ElementalNinjutsu, 			{})
	sets.midcast.ElementalNinjutsu.Resistant 	= set_combine(sets.midcast.Ninjutsu, 					{})
	sets.midcast.ElementalNinjutsuSan 			= set_combine(sets.midcast.ElementalNinjutsu, 			{})
	sets.midcast.ElementalNinjutsuSan.Burst 	= set_combine(sets.midcast.ElementalNinjutsuSan, 		{})
	sets.midcast.ElementalNinjutsuSan.Resistant = set_combine(sets.midcast.ElementalNinjutsu.Resistant, {})

	-- Effusions
	sets.precast.Effusion = {}
	sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
	sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

	----------------------------------
	-- Idle Sets
	----------------------------------
	sets.idle = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",	
	}
    sets.idle.PDT = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",
	}

	----------------------------------
	-- Defense sets
	----------------------------------
	sets.defense.PDT = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",	
	}
	sets.defense.MDT = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",	
	}
	sets.MEva = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",	
	}
	
	sets.Death = set_combine(sets.MEva, {})
	sets.Resist = set_combine(sets.MEva, {})
	sets.Resist.Stun = set_combine(sets.MEva, {})
	sets.DayMovement = {}
	sets.NightMovement = {}

	--------------------------------------------------------------------
	-- Engaged (No Haste) -- Base Sets (Kikoku/Heishi)
	--------------------------------------------------------------------
	-- Variations for TP weapon and (optional) offense/deafense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	-- The equip order is: CombatForm > Combat Weapon > Offense Mode > Hybrid Mode > Custom Melee Groups

	-- Acc 1183/1158 (Heishi/Ochu|Kikoku/Ochu)) :: Acc 1223/1186 (Heishi/Shigi|Kikoku/Shigi)
	-- DW Total in Gear: 39 DW / 39 DW Needed to Cap Delay Reduction
	sets.engaged = {}
	
	sets.engaged.Crit 	= set_combine(sets.engaged, 		{})
	sets.engaged.Acc 	= set_combine(sets.engaged, 		{})
	sets.engaged.Acc2 	= set_combine(sets.engaged.Acc, 	{})
	sets.engaged.Acc3 	= set_combine(sets.engaged.Acc2, 	{})
	sets.engaged.Acc.Crit = sets.engaged.Crit
	sets.engaged.Acc2.Crit = sets.engaged.Crit
	sets.engaged.Acc3.Crit = sets.engaged.Crit

	----------------------------------
	-- Kannagi
	----------------------------------
	sets.engaged.Kannagi = {}
	sets.engaged.Kannagi.AM3 = {}

	----------------------------------
	-- GKT
	----------------------------------
	sets.engaged.TWH ={
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +1",
		feet="Pumm. Calligae +2",
		neck="Asperity Necklace",
		waist="Ioskeha Belt",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Flamma Ring",
		back="Bleating Mantle",
	}
	sets.engaged.PLM = set_combine(sets.engaged.TWH,{})
	sets.engaged.H2H = set_combine(sets.engaged.TWH,{left_ear="Mache Earring +1",right_ear="Mache Earring +1",})
	sets.engaged.GAX = set_combine(sets.engaged.TWH,{})
	sets.engaged.GSD = set_combine(sets.engaged.TWH,{})
	sets.engaged.PLM.Acc = set_combine(sets.engaged.PLM, {})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.H2H, {})
	sets.engaged.GAX.Acc = set_combine(sets.engaged.GAX, {})
	sets.engaged.GSD.Acc = set_combine(sets.engaged.GSD, {})

	----------------------------------
	-- Hybrid(Defensive)
	----------------------------------
	sets.engaged.PDT = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",
	}

	--------------------------------------------------------------------
	-- MaxHaste Sets (0%DW Needed)
	--------------------------------------------------------------------
	-- Acc 1179/1154 (Heishi/Ochu|Kikoku/Ochu))
	-- DW Total in Gear: 0 DW / 1 DW Needed to Cap Delay Reduction
	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breast.",
		hands="Sulev. Gauntlets +2",
		legs="Pumm. Cuisses +1",
		feet="Flam. Gambieras +2",
		neck="Asperity Necklace",
		waist="Ioskeha Belt",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	
	sets.engaged.Crit.MaxHaste 	= set_combine(sets.engaged.MaxHaste, 		{})
	sets.engaged.Acc.MaxHaste 	= set_combine(sets.engaged.MaxHaste, 		{})
	sets.engaged.Acc2.MaxHaste 	= set_combine(sets.engaged.Acc.MaxHaste, 	{})
	sets.engaged.Acc3.MaxHaste 	= set_combine(sets.engaged.Acc2.MaxHaste,	{})
 
	----------------------------------
    -- 35% Haste (~10-12%DW Needed)
	----------------------------------
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_35 		= set_combine(sets.engaged.MaxHaste, 		{
	    left_ear="Eabani Earring",
		right_ear="Suppanomimi",
	})
	sets.engaged.Crit.Haste_35 	= set_combine(sets.engaged, 				{})
	sets.engaged.Acc.Haste_35 	= set_combine(sets.engaged.Acc.MaxHaste, 	{})
	sets.engaged.Acc2.Haste_35 	= set_combine(sets.engaged.Acc2.MaxHaste, 	{})
	sets.engaged.Acc3.Haste_35 	= set_combine(sets.engaged.Acc3.MaxHaste, 	{})

	----------------------------------
    -- 30% Haste (~21-22%DW Needed)
	----------------------------------
	-- Acc  (Heishi/Ochu)) 1210/1185
	-- DW Total in Gear: 21 DW / 21 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_30		= set_combine(sets.engaged.MaxHaste, {
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",	
	})
	sets.engaged.Crit.Haste_30 	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc.Haste_30 	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc2.Haste_30	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc3.Haste_30 	= set_combine(sets.engaged.MaxHaste, {})

	----------------------------------
	-- 15% Haste (~32%DW Needed)
	----------------------------------
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_15 		= set_combine(sets.engaged.MaxHaste, {
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",	
	})
	sets.engaged.Crit.Haste_15 	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc.Haste_15 	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc2.Haste_15 	= set_combine(sets.engaged.MaxHaste, {})
	sets.engaged.Acc3.Haste_15 	= set_combine(sets.engaged.MaxHaste, {})

	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body="Sulevia's Plate. +2",
		hands={ name="Lustr. Mittens +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		legs="Sulev. Cuisses +2",
		feet="Sulev. Leggings +2",
		neck="Asperity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Karieyh Ring",
		right_ring="Shukuyu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
    
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Impulse Drive'] 		= set_combine(sets.precast.WS, {})

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = true
	end
	if (spell.type:endswith('Magic') or spell.type == "Ninjutsu") and buffactive.silence then
		cancel_spell()
		send_command('input /item "Echo Drops" <me>')
	end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "Utsusemi" then
		if spell.english == "Migawari" then
			classes.CustomClass = "Migawari"
		else
			classes.CustomClass = "SelfNinjutsu"
		end
	end
	if spell.name == 'Spectral Jig' and buffactive.sneak then
		send_command('cancel 71')
	end
	if string.find(spell.english, 'Utsusemi') then
		if buffactive['Copy Image (4)'] then
			cancel_spell()
			eventArgs.cancel = true
			return
		end
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Ranged Attacks 
	if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'Acc' then
		equip(sets.SangeAmmo)
	end
	
	-- Protection for lag
	if spell.name == 'Sange' and player.equipment.ammo == gear.RegularAmmo then
		state.Buff.Sange = false
		eventArgs.cancel = true
	end
	
	-- Start of WS Branch of Post Precast Modifications
	if spell.type == 'WeaponSkill' then
	
		if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
			equip(sets.TreasureHunter)
		end
		
		-- Gavialis Helm rule
		--if is_sc_element_today(spell) then
		--	if gavialis_ws:contains(spell.english) then
				equip(sets.WSDayBonus)
		--	end
		--end
		
		-- Lugra Earring for some WS during Nighttime
		if world.time >= (17*60) or world.time <= (7*60) then
			if LugraLugraList:contains(spell.english) then
				equip(sets.DualLugra)
			end
			if LugraMoonList:contains(spell.english) then
				equip(sets.LugraMoon)
			end
		else -- And Other Sets for daytime
			if LugraLugraList:contains(spell.english) then
				equip(sets.BrutalMoon)
			end
			if LugraMoonList:contains(spell.english) then
				equip(sets.IshvaraMoon)
			end
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.english == "Monomi: Ichi" then
		if buffactive['Sneak'] then
			send_command('@wait 1;cancel 71')
		end
	end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.Buff.Futae and spellMap == 'ElementalNinjutsu' then
		 equip(sets.precast.JA['Futae'])
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if midaction() then
		return
	end
	-- Aftermath timer creation
	aw_custom_aftermath_timers_aftercast(spell)
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
	local lockables = T{'Mamool Ja Earring', 'Aptitude Mantle', 'Nexus Cape', 'Aptitude Mantle +1', 'Warp Ring', 'Vocation Ring', 'Reraise Earring', 'Capacity Ring', 'Trizek Ring', 'Echad Ring', 'Facility Ring', 'Dim. Ring (Holla)', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)'}
	local watch_slots = T{'lear','rear','ring1','ring2','back','head'}

	for _,v in pairs(watch_slots) do
		if lockables:contains(player.equipment[v]) then
			disable(v)
			if has_charges(player.equipment[v]) and (not is_enchant_ready(player.equipment[v])) then
				enable(v)
			end
		else
			enable(v)
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HybridMode.value == 'PDT' then
		if state.Buff.Migawari then
			idleSet = set_combine(idleSet, sets.buff.Migawari)
		else 
			idleSet = set_combine(idleSet, sets.idle.PDT)
		end
	else
		idleSet = idleSet
	end
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	meleeSet = set_combine(meleeSet, select_ammo())
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	if player.equipment.main == 'Kannagi' then
		if buffactive['Aftermath: Lv.3'] then
			meleeSet = set_combine(meleeSet, sets.engaged.Kannagi.AM3)
		end
	end
	if state.HybridMode.value == 'PDT' then
		meleeSet = set_combine(meleeSet, sets.engaged.PDT)
	end
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
	if (buff == 'Innin' and gain or buffactive['Innin']) then
		state.CombatForm:set('Innin')
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	else
		state.CombatForm:reset()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end

	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
end

function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		update_combat_form()
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	select_ammo()
	select_movement_feet()
	determine_haste_group()
	update_combat_form()
	th_update(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Facing ratio
-------------------------------------------------------------------------------------------------------------------
function facing_away(spell)
	if spell.target.type == 'MONSTER' then
		local dir = V{spell.target.x, spell.target.y} - V{player.x, player.y}
		local heading = V{}.from_radian(player.facing)
		local angle = V{}.angle(dir, heading):degree():abs()
		if angle > 90 then
			add_to_chat(8, 'Aborting... angle > 90')
			return true
		else
			return false
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
	if state.Buff[buff_name] then
		equip(sets.buff[buff_name] or {})
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
		eventArgs.handled = true
	end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
	if category == 2 or -- any ranged attack
		--category == 4 or -- any magic action
		(category == 3 and param == 30) or -- Aeolian Edge
		(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
		(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
		then 
			return true
    end
end

function select_movement_feet()
	if world.time >= (17*60) or world.time < (7*60) then
		gear.MovementFeet.name = gear.NightFeet
	else
		gear.MovementFeet.name = gear.DayFeet
	end
end

function determine_haste_group()
	classes.CustomMeleeGroups:clear()
	
	h = 0
	-- Spell Haste 15/30
	if buffactive[33] then
		if state.HasteMode.value == 'Haste I' then
			h = h + 15
		elseif state.HasteMode.value == 'Haste II' then
			h = h + 30
		end
	end
	-- Geo Haste 29/35/40 (assumes dunna and idris have 900 skill)
	if buffactive[580] then
		if state.GeoMode.value == 'Trusts' then
			h = h + 29.9
		elseif state.GeoMode.value == 'Dunna' then
			h = h + 35.4
		elseif state.GeoMode.value == 'Idris' then
			h = h + 40
		end
	end
	-- Mighty Guard 15
	if buffactive[604] then
		h = h + 15
	end
	-- Embrava 25.9
	if buffactive.embrava then
		h = h + 25.9
	end
	-- March(es) 
	if buffactive.march then
		if state.MarchMode.value == 'Honor' then
			if buffactive.march == 2 then
				h = h + 27 + 16
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == 'Trusts' then
			if buffactive.march == 2 then
				h = h + 26
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '7' then
			if buffactive.march == 2 then
				h = h + 27 + 17
			elseif buffactive.march == 1 then
				h = h + 27
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '3' then
			if buffactive.march == 2 then
				h = h + 13.5 + 20.6
			elseif buffactive.march == 1 then
				h = h + 20.6
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		end
	end

	-- Determine CustomMeleeGroups
	if h >= 15 and h < 30 then 
		classes.CustomMeleeGroups:append('Haste_15')
		add_to_chat('Haste Group: 15% -- From Haste Total: '..h)
	elseif h >= 30 and h < 35 then 
		classes.CustomMeleeGroups:append('Haste_30')
		add_to_chat('Haste Group: 30% -- From Haste Total: '..h)
	elseif h >= 35 and h < 40 then 
		classes.CustomMeleeGroups:append('Haste_35')
		add_to_chat('Haste Group: 35% -- From Haste Total: '..h)
	elseif h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

end

-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
	if spell.type == 'Trust' then
		return 'Trust'
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
	msg = msg .. 'Offense: '..state.OffenseMode.current

	if state.CombatWeapon.value == 'Kannagi' or state.CombatWeapon.value == 'GKT' then
		msg = msg..' --'..state.CombatWeapon.value..'-- '
	end
	
	if state.DefenseMode.value ~= 'None' then
		local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
		msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
	end
	if state.HasteMode.value ~= 'Normal' then
		msg = msg .. ', Haste: '..state.HasteMode.current
	end
	if state.MarchMode.value ~= 'Normal' then
		msg = msg .. ', March Mode: '..state.MarchMode.current
	end
	if state.RangedMode.value ~= 'Normal' then
		msg = msg .. ', Rng: '..state.RangedMode.current
	end
	if state.Kiting.value then
		msg = msg .. ', Kiting'
	end
	if state.PCTargetMode.value ~= 'default' then
		msg = msg .. ', Target PC: '..state.PCTargetMode.value
	end
	if state.SelectNPCTargets.value then
		msg = msg .. ', Target NPCs'
	end
	add_to_chat(123, msg)
	eventArgs.handled = true
end

-- Call from job_precast() to setup aftermath information for custom timers.
function aw_custom_aftermath_timers_precast(spell)
	if spell.type == 'WeaponSkill' then
		info.aftermath = {}

		local empy_ws = "Blade: Hi"

		info.aftermath.weaponskill = empy_ws
		info.aftermath.duration = 0

		info.aftermath.level = math.floor(player.tp / 1000)
		if info.aftermath.level == 0 then
			info.aftermath.level = 1
		end

		if spell.english == empy_ws and player.equipment.main == 'Kannagi' then
			-- nothing can overwrite lvl 3
			if buffactive['Aftermath: Lv.3'] then
				return
			end
			-- only lvl 3 can overwrite lvl 2
			if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
				return
			end

			-- duration is based on aftermath level
			info.aftermath.duration = 30 * info.aftermath.level
		end
	end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
	-- prevent gear being locked when it's currently impossible to cast 
	if not spell.interrupted and spell.type == 'WeaponSkill' and
		info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then

		local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
		send_command('timers d "Aftermath: Lv.1"')
		send_command('timers d "Aftermath: Lv.2"')
		send_command('timers d "Aftermath: Lv.3"')
		send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')

		info.aftermath = {}
	end
end

function select_ammo()
	if state.Buff.Sange then
		return sets.SangeAmmo
	else
		return sets.RegularAmmo
	end
end

function update_combat_form()
	--if state.Buff.Innin then
	--	state.CombatForm:set('Innin')
	--end
	--if player.equipment.main == 'Kannagi' then
	--	state.CombatWeapon:set('Kannagi')
	if player.equipment.main == 'Reikiono' then
		state.CombatWeapon:set('GAX')	
	elseif player.equipment.main == "Montante +1" then
		state.CombatWeapon:set('GSD')
	elseif player.equipment.main == "Shining One" then
		state.CombatWeapon:set('PLM')
	elseif player.equipment.main == "Karambit" then
		state.CombatWeapon:set('H2H')
	else
		state.CombatWeapon:reset()
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 8)
	elseif player.sub_job == 'THF' then
		set_macro_page(1, 8)
	else
		set_macro_page(1, 8)
	end
end