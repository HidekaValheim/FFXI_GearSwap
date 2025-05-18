-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
include('organizer-lib')
include('Modes.lua')
-- include('packets.lua')
-- packets = require('packets')

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Reraiser","Hi-Reraiser"},
	Food={"Grape Daifuku", "Red Curry Bun"},
	Bullets={"Yoichi Arrow"},
	Odyssey={"Tumult's Blood","Hidhaegg's Scale","Sovereign's Hide","Sarama's Hide"},
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_sets()
	mote_include_version = 2
	include('Mote-Include.lua')
	require('vectors')

end

function get_gear()
	send_command('wait 3;input //gs org')
	add_to_chat(8,'REMEMBER TO REPACK GEAR') 
end

-- Setup vars that are user-independent.
function job_setup()
	state.Buff.Doomed = buffactive.doomed or false
	state.Buff.Asleep = buffactive.asleep or false

	include('Mote-TreasureHunter')
	state.TreasureMode:set('None')
	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Honor', 'Trusts', '3', '7'}
	state.GeoMode = M{['description']='Geo Haste', 'Trusts', 'Dunna', 'Idris'}

	gear.MovementFeet = {name="Danzo Sune-ate"}
	gear.DayFeet = "Danzo Sune-ate"
	gear.NightFeet = "Danzo Sune-ate"
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Orpheus's Sash"
	
	update_combat_form()
	stance_status()

	state.warned = M(false)
	options.ammo_warning_limit = 25
	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
	get_gear()

end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	windower.register_event('time change', time_change)	
	-- Options: Override default values
	state.OffenseMode:options ('Normal', 'ACC')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'MAXBUFF')
	state.HybridMode:options('Normal','Critical', 'Hybrid', 'Counter', 'Subtle','SubtleTank','Ranged')
	state.CastingMode:options('Normal','Burst')
	state.IdleMode:options('Normal','Recover','DT','Buff','Ranged')
	mainweapon={}
	subWeapon={}
	state.mainWeapon = M('Masamune','Shining One','Norifusa +1','Hachimonji','Soboro Sukehiro')
	state.subWeapon = M('Utu grip')	
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds
	
	send_command('bind numpad0 input /ja Meditate <me>')
	send_command('bind numpad. input /ja Sekkanoki <me>')
	send_command('bind numpad1 input /ja Blade Bash <t> ')
	send_command('bind numpad2 input /ja Jump <t>')
	send_command('bind numpad3 input /ja High Jump <t>')
	send_command('bind numpad4 input /ja Sengikori <me> ')
	send_command('bind numpad5 gs c cycle WeaponskillMode')
	send_command('bind numpad6 gs c cycle IdleMode')
	send_command('bind numpad7 gs c cycle OffenseMode')
	send_command('bind numpad8 gs c cycle HybridMode')
	send_command('bind numpad9 gs c cycle RangedMode')

	send_command('bind numpad/ gs c cycle mainWeapon')
	send_command('bind numpad* gs c cycle subWeapon')
	send_command('bind numpad- gs c cycle HasteMode')
	send_command('bind numpad+ gs c cycle MarchMode')

	send_command('unbind ^r')

	
	
	select_movement_feet()
	select_default_macro_book()
	use_UI = true
	hud_x_pos = 1500    --important to update these if you have a smaller screen
	hud_y_pos = 300     --important to update these if you have a smaller screen
	hud_draggable = true
	hud_font_size = 9
	hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
	hud_font = 'Lucida Sans Typewriter'
	setupTextWindow()
	
	stance = "No Stance"
	stance_status()
	send_command('wait 10;input /lockstyleset 11')	
end

function file_unload()
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind ^=')
	send_command('unbind !=')
	send_command('unbind @f9')
	send_command('unbind @[')
	send_command('unbind `')
	send_command('unbind numpad7')
	send_command('unbind numpad9')
	send_command('unbind numpad5')
	send_command('unbind numpad8')
	send_command('unbind numpad4')
	send_command('unbind numpad1')
	send_command('unbind numpad2')
	send_command('unbind numpad3')
	send_command('unbind numpad/')
	send_command('unbind numpad*')
	send_command('unbind numpad-')
	send_command('unbind numpad+')
	send_command('unbind numpad.')
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

	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA["Meikyo Shisui"] = {feet="Sak. Sune-Ate +3"}
	sets.precast.JA["Third Eye"] = {legs="Sakonji Haidate +3"}
	sets.precast.JA["Meditate"] = {hands="Sakonji Kote +3", head="Wakido Kabuto +2", back ="Smertrios's Mantle"}
	sets.precast.JA["Warding Circle"] = {head="Wakido Kabuto +2"}
	sets.precast.JA["Blade Bash"] = {hands="Sakonji Kote +3"}
	sets.precast.JA["Sekkanoki"] = {hands="Kasuga Kote +3"}
	sets.precast.JA["Shikikoyo"] = {legs="Sakonji Haidate +3"}
	sets.precast.JA["Sengikori"] = {feet="Kasuga Sune-Ate +2"}

	sets.precast.JA["Jump"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Lehko's Ring",
		back="Moonbeam Cape",	
	}
	sets.precast.JA["High jump"] = set_combine(sets.precast.JA["Jump"],{})
	sets.precast.JA['Provoke'] = {
		ammo="Sapience Orb",
		head={ name="Loess Barbuta +1", augments={'Path: A',}},
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Trance Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back="Reiki Cloak",
	}
	-- Waltz (chr and vit)
	sets.precast.Waltz = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Dashing Subligar",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Aristo Belt",
		left_ear={ name="Handler's Earring +1", augments={'Path: A',}},
		right_ear="Tuisto Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",	
	}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
	
	sets.precast.Step = {
		ammo="Amar Cluster",
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Kasuga Kote +3",
		legs="Kasuga Haidate +2",
		feet="Kas. Sune-Ate +2",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Moonbeam Cape",		
	}	
	sets.precast.Flourish1 = set_combine(sets.precast.Step, {})
	sets.midcast["Apururu (UC)"] = {}
	sets.asleep={neck="Vim Torque"}
	sets.doomed={
		neck="Nicander's Necklace",
		waist="Gishdubar Sash",
		left_ring="Purity Ring",
		right_ring="Blenmot's Ring +1",	
	}
	--------------------------------------
	-- Utility Sets for rules below
	--------------------------------------
	sets.TreasureHunter = {waist="Chaac Belt", ammo="Per. Lucky egg", head = "Wh. Rarab Cap +1", feet="Volte Boots"}

	--------------------------------------
	-- Ranged
	--------------------------------------
	-- Snapshot for ranged
	sets.precast.RA = {
		ranged= "Yoichinoyumi",
		ammo="Yoichi's Arrow",
		head={ name="Acro Helm", augments={'"Rapid Shot"+4','"Snapshot"+5',}},
		body={ name="Acro Surcoat", augments={'"Rapid Shot"+5','"Snapshot"+5',}},
		hands={ name="Acro Gauntlets", augments={'"Rapid Shot"+5','"Snapshot"+5',}},
		legs={ name="Acro Breeches", augments={'"Rapid Shot"+4','"Snapshot"+5',}},
		feet={ name="Acro Leggings", augments={'"Rapid Shot"+4','"Snapshot"+5',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring="Crepuscular Ring",
		back={ name="Smertrios's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Snapshot"+10','Damage taken-5%',}},	
	}
	sets.midcast.RA = {
		ranged= "Yoichinoyumi",
		ammo="Yoichi's Arrow",
		head="Sakonji Kabuto +3",
		body="Ken. Samue +1",
		hands="Ken. Tekko +1",
		legs="Ken. Hakama +1",
		feet="Ken. Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Regal Ring",
		right_ring="Crepuscular Ring",
		back={ name="Smertrios's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})
	sets.midcast.RA.TH = set_combine(sets.midcast.RA, sets.TreasureHunter)

	----------------------------------
    -- Casting
	----------------------------------
	sets.precast['Holy Water'] = sets.doomed
	sets.midcast['Holy Water'] = sets.doomed
	-- Precasts
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Weather. Ring",
		right_ring="Rahab Ring",
		back="Moonbeam Cape",	
	}
	
	sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Weather. Ring",
		right_ring="Rahab Ring",
		back="Moonbeam Cape",	
	}

	----------------------------------
	-- Idle Sets
	----------------------------------
	sets.idle = {}
	sets.idle.Normal = {	
		ammo="Staunch Tathlum +1",
		head="Wakido Kabuto +2",
		body="Sacro Breastplate",
		hands={ name="Rao Kote +1", augments={'Accuracy+12','Attack+12','Evasion+20',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Rao Sune-Ate +1", augments={'HP+65','Crit. hit rate+4%','"Dbl.Atk."+4',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Infused Earring",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",
	}
    sets.idle.Recover = {
		ammo="Staunch Tathlum +1",
		head="Rao Kabuto +1",
		body="Sacro Breastplate",
		hands={ name="Rao Kote +1", augments={'Accuracy+12','Attack+12','Evasion+20',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Rao Sune-Ate +1", augments={'HP+65','Crit. hit rate+4%','"Dbl.Atk."+4',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Infused Earring",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",
	}
    sets.idle.DT = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sacro Breastplate",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",	
	}
    sets.idle.Buff = {
		waist="Gishdubar Sash",
		left_ring="Sheltered Ring",
	}
	sets.idle.Ranged =set_combine(sets.idle.Normal ,{	
		ranged= "Yoichinoyumi",
		ammo="Yoichi's Arrow",
	})
	----------------------------------
	-- full Defense sets for react and other things
	----------------------------------
	-- 51% PDT + Nullification(Mantle)
	sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sacro Breastplate",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",
	}

	-- 25% MDT + Absorb + Nullification + MEva
	sets.defense.PEVA = set_combine(sets.defense.PDT,{})
	sets.MEva = set_combine(sets.defense.PDT,{})
	sets.Death = set_combine(sets.MEva, {left_ring="Warden's Ring"})
	sets.Resist = set_combine(sets.MEva, {})
	sets.Resist.Stun = set_combine(sets.MEva, {})
	sets.DayMovement = {feet="Danzo Sune-ate"}
	sets.NightMovement = {feet="Danzo Sune-ate"}

	sets.ACC ={
		--hands		="Wakido Kote +3",
		waist		= "Ioskeha Belt +1",
		left_ring	= "Regal Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		left_ear	= "Schere Earring",
		back		={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},		
	}
	sets.Hybrid	={
		hands	  = "Mpaca's Gloves",
		feet 	  = "Mpaca's Boots",
		back		={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},
	}
--BASE 18.75% Formula is (Zanshin rate *1.25)/4. each +1 zanshin grants 0.3 Counter. Full zanshin merits grant 1.5 counter for total of 20.25% Base counter. 
	sets.Counter={
		ammo 	= "Amar Cluster", --+2
		head 	= "Kasuga Kabuto +2", --+16
		body 	= "Mpaca's Doublet", -- +10
		legs 	= "Sakonji Haidate +3",
		waist	= "Cornelia's Belt",-- +5
		neck 	= "Bathy Choker +1", -- +10
		left_ear= "Cryptic Earring", --+3
		back={ name="Smertrios's Mantle", augments={'HP+60','Accuracy+2','"Store TP"+10','System: 1 ID: 640 Val: 3',}},
	}
	sets.HassoMAX ={
		--hands	= "Wakido Kote +3",
		legs 	= "Kasuga Haidate +2", 
		--feet 	= "Wakido Sune-Ate +3",
	}
	sets.Critical = {
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Ken. Tekko +1",
		legs="Ken. Hakama +1",
		feet="Ken. Sune-Ate +1",
		left_ring="Hetairoi Ring",
		right_ring="Lehko's Ring",
	}
	sets.Subtle ={
		head 	  = "Ken. Jinpachi +1",
		body 	  = "Dagon Breastplate",
		hands 	  ="Ken. Tekko +1",
		--hands 	  = "Wakido Kote +3",
		legs 	  = "Mpaca's Hose",
		feet 	  = "Ryuo Sune-Ate +1",
		--left_ear  = "Dignitary's Earring",
		right_ear = "Schere Earring",
		left_ring = "Niqmaddu Ring",
		right_ring= "Chirich Ring +1",
		neck="Bathy Choker +1",
		--waist   = "Sarissapho. Belt",
	}
	sets.Ranged={
		ranged="Yoichinoyumi",
		ammo="Yoichi's Arrow",
	}
	sets.SubtleTank={
		ammo="Staunch Tathlum +1",
		head="Kasuga Kabuto +2",
		body="Dagon Breast.",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Digni. Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back		={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},
	}
	sets.ThirdEye={legs="Sakonji Haidate +3"}
	----------------------------------
	-- No Haste - Requires 39 total DW to cap. use sets.dw.t39 as primary set join
	----------------------------------	
	sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs="Kasuga Haidate +2",
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Lehko's Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},
	}
	sets.FULLSTP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs="Kasuga Haidate +2",
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Lehko's Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}
	----------------------------------
	-- No Haste SetVariants
	----------------------------------
	--Accuracy Variants
	sets.engaged.ACC 			= set_combine(sets.engaged, sets.ACC	, sets.HassoMAX	, {})
	sets.engaged.Hybrid 		= set_combine(sets.engaged,	 sets.HassoMAX	,sets.Hybrid	, {})
	sets.engaged.ACC.Hybrid		= set_combine(sets.engaged,	sets.ACC	,  sets.HassoMAX,sets.Hybrid	, {})
	sets.engaged.Critical 		= set_combine(sets.engaged,	sets.Critical,sets.HassoMAX	, {})
	sets.engaged.ACC.Critical	= set_combine(sets.engaged, sets.ACC	, sets.Critical	, sets.HassoMAX, {})	
	sets.engaged.Counter 		= set_combine(sets.engaged,	sets.Counter, sets.HassoMAX	, {})
	sets.engaged.ACC.Counter	= set_combine(sets.engaged,	sets.ACC	, sets.Counter	, sets.HassoMAX, {})
	sets.engaged.Subtle 		= set_combine(sets.Subtle,{})
	sets.engaged.ACC.Subtle 	= set_combine(sets.Subtle,{})
	sets.engaged.SubtleTank 	= set_combine(sets.SubtleTank,{})
	sets.engaged.ACC.SubtleTank	= set_combine(sets.SubtleTank,{})
	sets.engaged.Ranged 		= set_combine(sets.engaged,	sets.Ranged, {})
	sets.engaged.ACC.Ranged		= set_combine(sets.engaged, sets.ACC, sets.Ranged,{})
	sets.engaged.FULLSTP		= set_combine(sets.engaged,	sets.FULLSTP, {})
	sets.engaged.ACC.FULLSTP	= set_combine(sets.engaged, sets.ACC, sets.FULLSTP,{})
	
	sets.engaged.ThirdEye				= set_combine(sets.engaged, sets.HassoMAX, sets.ThirdEye, {})
	sets.engaged.ACC.ThirdEye			= set_combine(sets.engaged, sets.ACC	, sets.HassoMAX	, sets.ThirdEye, {})
	sets.engaged.Hybrid.ThirdEye 		= set_combine(sets.engaged,	 sets.HassoMAX	,sets.Hybrid	, sets.ThirdEye, {})
	sets.engaged.ACC.Hybrid.ThirdEye	= set_combine(sets.engaged,	sets.ACC	,  sets.HassoMAX,sets.Hybrid	, sets.ThirdEye, {})
	sets.engaged.Critical.ThirdEye 		= set_combine(sets.engaged,	sets.Critical,sets.HassoMAX	, sets.ThirdEye, {})
	sets.engaged.ACC.Critical.ThirdEye	= set_combine(sets.engaged, sets.ACC	, sets.Critical	, sets.HassoMAX, sets.ThirdEye, {})	
	sets.engaged.Counter.ThirdEye 		= set_combine(sets.engaged,	sets.Counter, sets.HassoMAX	, sets.ThirdEye, {})
	sets.engaged.ACC.Counter.ThirdEye	= set_combine(sets.engaged,	sets.ACC	, sets.Counter	, sets.HassoMAX, sets.ThirdEye, {})
	sets.engaged.Subtle.ThirdEye 		= set_combine(sets.Subtle, 	sets.ThirdEye,{})
	sets.engaged.ACC.Subtle.ThirdEye 	= set_combine(sets.Subtle, sets.ThirdEye,{})
	sets.engaged.SubtleTank.ThirdEye 	= set_combine(sets.SubtleTank, sets.ThirdEye,{})
	sets.engaged.ACC.SubtleTank.ThirdEye= set_combine(sets.SubtleTank, sets.ThirdEye,{})
	sets.engaged.Ranged.ThirdEye		= set_combine(sets.engaged,	sets.Ranged, sets.ThirdEye,{})
	sets.engaged.ACC.Ranged.ThirdEye	= set_combine(sets.engaged, sets.ACC, sets.Ranged, sets.ThirdEye,{})
	sets.engaged.FULLSTP.ThirdEye		= set_combine(sets.engaged,	sets.FULLSTP, sets.ThirdEye,{})
	sets.engaged.ACC.FULLSTP.ThirdEye	= set_combine(sets.engaged, sets.ACC, sets.FULLSTP, sets.ThirdEye,{})
	--------------------------------------------------------------------
	-- MaxHaste Sets No Hasso Gear Needed
	--------------------------------------------------------------------
	sets.engaged.MaxHaste = set_combine(sets.engaged, {})
	

	sets.engaged.ACC.MaxHaste 			= set_combine(sets.engaged.MaxHaste, sets.ACC	, {})
	sets.engaged.Hybrid.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.Hybrid, {})
	sets.engaged.ACC.Hybrid.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Hybrid, {})
	sets.engaged.Counter.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.Counter, {})
	sets.engaged.ACC.Counter.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Counter, {})
	sets.engaged.Critical.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.Critical, {})
	sets.engaged.ACC.Critical.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Critical, {})
 	sets.engaged.Subtle.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.Subtle, {})
	sets.engaged.ACC.Subtle.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle, {})
 	sets.engaged.SubtleTank.MaxHaste 	= set_combine(sets.SubtleTank, {})
	sets.engaged.ACC.SubtleTank.MaxHaste= set_combine(sets.SubtleTank, {})
	sets.engaged.Ranged.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.Ranged, {})
	sets.engaged.ACC.Ranged.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC, sets.Ranged,{})
	sets.engaged.FULLSTP.MaxHaste		= set_combine(sets.engaged.MaxHaste, sets.FULLSTP, {})
	sets.engaged.ACC.FULLSTP.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC, sets.FULLSTP,{})

	sets.engaged.ACC.MaxHaste.ThirdEye 			 = set_combine(sets.engaged.MaxHaste,sets.ThirdEye, {})
	sets.engaged.ACC.MaxHaste.ThirdEye 			 = set_combine(sets.engaged.MaxHaste, sets.ACC	,sets.ThirdEye, {})
	sets.engaged.Hybrid.MaxHaste.ThirdEye 		 = set_combine(sets.engaged.MaxHaste, sets.Hybrid,sets.ThirdEye, {})
	sets.engaged.ACC.Hybrid.MaxHaste.ThirdEye	 = set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Hybrid,sets.ThirdEye, {})
	sets.engaged.Counter.MaxHaste.ThirdEye 		 = set_combine(sets.engaged.MaxHaste, sets.Counter,sets.ThirdEye, {})
	sets.engaged.ACC.Counter.MaxHaste.ThirdEye	 = set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Counter,sets.ThirdEye, {})
	sets.engaged.Critical.MaxHaste.ThirdEye 	 = set_combine(sets.engaged.MaxHaste, sets.Critical,sets.ThirdEye, {})
	sets.engaged.ACC.Critical.MaxHaste.ThirdEye	 = set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Critical,sets.ThirdEye, {})
 	sets.engaged.Subtle.MaxHaste.ThirdEye 		 = set_combine(sets.engaged.MaxHaste, sets.Subtle,sets.ThirdEye, {})
	sets.engaged.ACC.Subtle.MaxHaste.ThirdEye	 = set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle,sets.ThirdEye, {})
 	sets.engaged.SubtleTank.MaxHaste.ThirdEye 	 = set_combine(sets.SubtleTank,sets.ThirdEye, {})
	sets.engaged.ACC.SubtleTank.MaxHaste.ThirdEye= set_combine(sets.SubtleTank,sets.ThirdEye, {})
	sets.engaged.Ranged.MaxHaste.ThirdEye 		 = set_combine(sets.engaged.MaxHaste, sets.Ranged, sets.ThirdEye,{})
	sets.engaged.ACC.Ranged.MaxHaste.ThirdEye	 = set_combine(sets.engaged.MaxHaste, sets.ACC, sets.Ranged, sets.ThirdEye,{})
	sets.engaged.FULLSTP.MaxHaste.ThirdEye		= set_combine(sets.engaged.MaxHaste, sets.FULLSTP,  sets.ThirdEye,{})
	sets.engaged.ACC.FULLSTP.MaxHaste.ThirdEye	= set_combine(sets.engaged.MaxHaste, sets.ACC, sets.FULLSTP, sets.ThirdEye,{})
	
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
    
	sets.precast.WS.MAXBUFF 		= set_combine(sets.precast.WS, {})
 	sets.precast.WS['Tachi: Fudo']  = set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS,{})	
	sets.precast.WS['Tachi: Yuki']  = set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Rana']  = set_combine(sets.precast.WS,{head="Nyame Helm", right_ear="Lugra Earring +1"})
	sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS,{right_ring="Niqmaddu Ring"})
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS,{})
	sets.precast.WS['Impulse Drive']= set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Fudo'].MAXBUFF 	= set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Gekko'].MAXBUFF = set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Kasha'].MAXBUFF = set_combine(sets.precast.WS,{})	
	sets.precast.WS['Tachi: Yuki'].MAXBUFF 	= set_combine(sets.precast.WS,{})
	sets.precast.WS['Tachi: Rana'].MAXBUFF 	= set_combine(sets.precast.WS,{head="Nyame Helm", right_ear="Lugra Earring +1"})
	sets.precast.WS['Tachi: Shoha'].MAXBUFF = set_combine(sets.precast.WS,{right_ring="Niqmaddu Ring"})
	sets.precast.WS['Sonic Thrust'].MAXBUFF = set_combine(sets.precast.WS,{})
	sets.precast.WS['Impulse Drive'].MAXBUFF= set_combine(sets.precast.WS,{})	
	
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS,{
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	})	
	
	sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS,{
		ammo="Pemphredo Tathlum",
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	})
	
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS,{
		ammo="Knobkierrie",
		head= "Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist= "Orpheus's Sash",
		left_ear= "Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	})
	sets.precast.WS['Tachi: Koki'] 	 = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Goten']  = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Jinpu'].MAXBUFF  = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Koki'].MAXBUFF 	 = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Kagero'].MAXBUFF = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	sets.precast.WS['Tachi: Goten'].MAXBUFF  = set_combine(sets.precast.WS['Tachi: Jinpu'],{})
	

 	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,{})	
 	sets.precast.WS['Savage Blade'].MAXBUFF = set_combine(sets.precast.WS,{})
 	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})

	sets.precast.WS['Namas Arrow'] = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Regal Ring",
		right_ring={ name="Beithir Ring", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}
	
	sets.precast.WS['Apex Arrow'] = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Regal Ring",
		right_ring={ name="Beithir Ring", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}
	
	sets.precast.WS['Empyreal Arrow'] = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Crep. Earring",
		left_ring="Regal Ring",
		right_ring={ name="Beithir Ring", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}	
	sets.WSDayBonus = {head="Gavialis Helm"}
	

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)

end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if player.equipment.ranged == 'Yoichinoyumi' or player.equipment.ranged =='Ullr' then 
		disable('ranged','ammo')
	else
		enable('ranged','ammo')
	end	
end

function job_post_precast(spell, action, spellMap, eventArgs)

     if spell.type == 'WeaponSkill' then
		if buffactive["Sekkanoki"] then
			equip(sets.precast.JA["Sekkanoki"])
		end
		if buffactive["Sengikori"] then
			equip(sets.precast.JA["Sengikori"])
		end
		if buffactive["Meikyo Shisui"] then 
			equip(sets.precast.JA["Meikyo Shisui"])
		end
     end


end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if player.equipment.ranged == 'Yoichinoyumi' or player.equipment.ranged =='Ullr' then 
		disable('ranged','ammo')
	else
		enable('ranged','ammo')
	end	
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- if state.Buff.Futae and spellMap == 'ElementalNinjutsu' then
		 -- equip(sets.precast.JA['Futae'])
	-- end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if midaction() then
		return
	end
	-- Aftermath timer creation
	aw_custom_aftermath_timers_aftercast(spell)
	stance_status()
	enable('ranged','ammo')
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
	local lockables = T{'Yoichinoyumi'}
	local watch_slots = T{'ranged'}

	-- for _,v in pairs(watch_slots) do
		-- if lockables:contains(player.equipment[v]) then
			-- disable(v)
		-- else
			-- enable(v)
		-- end
	-- end
    -- if player.equipment.ranged == 'Yoichinoyumi' or player.equipment.ranged =='Ullr' then 
		-- disable('ranged','ammo')
	-- else
		-- enable('ranged','ammo')
	-- end	
	
stance_status()
validateTextInformation()

end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HybridMode.value == 'DT' then
	else
		idleSet = idleSet
	end
    if moving then
		idleSet=set_combine(idleSet, {feet=gear.MovementFeet.name})
	end
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	meleeSet = set_combine(meleeSet,{})
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
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
	if (buff == 'Hasso' and gain or buffactive['Hasso']) then
		state.CombatForm:set('Hasso')
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	else
		state.CombatForm:reset()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
	if ((buff== 'Sleep' or buff == 'Asleep') and gain) or (buffactive['Asleep'] or buffactive['sleep']) then
		equip(sets.alseep)
		disable('neck')
	elseif ((buff== 'Sleep' or buff == 'Asleep') and not gain)  or (not buffactive['Asleep'] and not buffactive['sleep']) then
		enable('neck')
	end
	if ((buff== 'doom' or buff == 'doomed') and gain) or (buffactive['doom'] or buffactive['doomed']) then
		equip(sets.alseep)
		disable('neck','ring1','ring2','waist')
	elseif ((buff== 'doom' or buff == 'doomed') and not gain)  or (not buffactive['doom'] and not buffactive['doomed']) then
		enable('neck','ring1','ring2','waist')
	end
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end
	if (S{'third eye'}:contains(buff:lower()) and gain) or (S{'third eye'}:contains(buff:lower()) and not gain)  then 
		determine_haste_group()
	end
end


function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		update_combat_form()
	end
select_weapons()
end

function stance_status()

	if buffactive['Hasso'] then
		stance = 'Hasso'
	elseif buffactive['Seigan'] then
		stance = 'Seigan'
	else
		stance = 'No Stance'
	end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	select_weapons()
	select_movement_feet()
	determine_haste_group()
	update_combat_form()
	th_update(cmdParams, eventArgs)
	validateTextInformation()
	stance_status()
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
	if h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	elseif state.Buff.Hasso == false then 
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)	
	end
	
	if buffactive[67] and buffactive[354] then
		classes.CustomMeleeGroups:append('ThirdEye')
		add_to_chat('trying third eye set'..h)
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

function select_weapons()
	if player.equipment.main ~= state.mainWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end
	if player.equipment.sub ~= state.subWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end
    -- if player.equipment.ranged == 'Yoichinoyumi' or player.equipment.ranged =='Ullr' then 
		-- disable('ranged','ammo')
	-- else
		-- enable('ranged','ammo')
	-- end		
end

function update_combat_form()
	-- --if state.Buff.Innin then
	-- --	state.CombatForm:set('Innin')
	-- --end
	-- --if player.equipment.main == 'Kannagi' then
	-- --	state.CombatWeapon:set('Kannagi')
	-- if player.equipment.main == 'Beryllium Tachi' then
		-- state.CombatWeapon:set('GKT')	
	-- elseif player.equipment.main == "Hachimonji" then
		-- state.CombatWeapon:set('GKT')
	-- elseif player.equipment.main == "Karambit" then
		-- state.CombatWeapon:set('H2H')
	-- else
		-- state.CombatWeapon:reset()
	-- end
end
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'GktMode' then
		state.mainWeapon:set('Masamune')
		state.subWeapon:set('Utu Grip')	
		select_weapons()
		setupTextWindow()
		update_combat_form()
	elseif cmdParams[1] == 'PolearmMode' then
		state.mainWeapon:set('Shining One')
		state.subWeapon:set('Utu Grip')
		select_weapons()
		setupTextWindow()
		update_combat_form()
	elseif cmdParams[1] == 'SwordMode' then
		state.mainWeapon:set('Naegling')
		select_weapons()
		setupTextWindow()
		update_combat_form()
	elseif cmdParams[1] == 'runspeed' then
		runspeed:toggle()
		updateRunspeedGear(runspeed.value) 
	end

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 12)
	elseif player.sub_job == 'THF' then
		set_macro_page(1, 12)
	else
		set_macro_page(1, 12)
	end
end
function Auto_Stance()
	local ability_recasts = windower.ffxi.get_ability_recasts()

	if buffactive['Seigan'] and player.status=='Engaged' then
		if  ability_recasts[133] == 0 then
			send_command('@input /ja "Third Eye" <me> ;wait 1')
		end
	elseif not buffactive['Seigan'] and not buffactive['Hasso'] and player.status=='Engaged' then
		if  ability_recasts[138] == 0 then
			send_command('@input /ja "Hasso" <me> ;wait 1')
		end
	end
end

--NIN_HUD--
--------------------------------------------------------------------------------------------------------------
-- HUD STUFF
--------------------------------------------------------------------------------------------------------------
require('logger')
require('tables')
require('strings')
--global tool placeholder
shihei 	= {}
inoshi 	= {}
chono 	= {}
shika 	= {}
happo 	= {}
stance	= {}
shadows = {}
Migiwari = {}
--global colors
color={}
color.red		='(255,0,0)'
color.yellow 	='(0,255,0)'
color.blue		='(0,0,255)'
color.white		='(255,255,255)'
color.black		='(0,0,0)'
color.grey		='(175,175,175)'
color.ltred		='(255,125,125)'
color.ltblue	='(125,125,255)'
color.ltyellow	='(125,255,125)'


const_on = "\\cs(32, 255, 32)ON\\cr"
const_off = "\\cs(255, 32, 32)OFF\\cr"

hud_x_pos_og = hud_x_pos
hud_y_pos_og = hud_y_pos
hud_font_size_og = hud_font_size
hud_padding_og = hud_padding
hud_transparency_og = hud_transparency

MB_Window = 0
time_start = 0
hud_padding = 10

-- Standard Mode
hub_mode_std = [[\cs(204, 0, 0)Mode Binds    \cs(255, 115, 0)     GS Info: \cr
		\cs(175, 125, 225)${KB_C_MH}\cs(100, 150, 0)Main:\cr \cs(125,255,125)      ${player_current_mainweapon|Kannagi}
		\cs(175, 125, 225)${KB_C_OH}\cs(100, 150, 0)Sub:\cr \cs(125,255,125)       ${player_current_subweapon|Kannagi}
		\cs(175, 125, 225)${KB_WS_M}\cs(100, 150, 0)WS Mode:\cr    ${player_current_ws}
		\cs(175, 125, 225)${KB_Idle_M}\cs(100, 150, 0)Idle Mode:\cr  ${player_current_idle}
		\cs(175, 125, 225)${KB_Melee_M}\cs(100, 150, 0)Melee Mode:\cr ${player_current_melee}
		\cs(175, 125, 225)${KB_PDT_M}\cs(100, 150, 0)Hybrid Mode:\cr${player_current_Hybrid}
		\cs(175, 125, 225)${KB_Haste_M}\cs(100, 150, 0)Haste Mode:\cr ${player_current_Haste}
		\cs(175, 125, 225)${KB_March_M}\cs(100, 150, 0)March Mode:\cr ${player_current_March}
		\cs(204, 0, 0)Ability Binds\cr
		\cs(175, 125, 225)${KB_MEDITATE}\cs(200, 200, 200)Meditate\cr
		\cs(175, 125, 225)${KB_SEKKANOKI}\cs(200, 200, 200)Sekkanoki\cr
		\cs(175, 125, 225)${KB_BASH}\cs(200, 200, 200)Blade Bash\cr
		\cs(175, 125, 225)${KB_JUMP}\cs(200, 200, 200)Jump\cr
		\cs(175, 125, 225)${KB_HI_JUMP}\cs(200, 200, 200)High Jump\cr
		\cs(175, 125, 225)${KB_SENGIKORI}\cs(200, 200, 200)Sengikori\cr
]]


-- init style
hub_mode = hub_mode_std
hub_options = hub_options_std
hub_job = hub_job_std
hub_battle = hub_battle_std

KB = {}
KB['KB_C_MH'] 	  = ' (NUM /) '
KB['KB_C_OH'] 	  = ' (NUM *) '
KB['KB_Idle_M']   = ' (NUM 6) '
KB['KB_Melee_M']  = ' (NUM 7) '
KB['KB_WS_M'] 	  = ' (NUM 5) '
KB['KB_PDT_M'] 	  = ' (NUM 8) '
KB['KB_RA_M'] 	  = ' (NUM 9) '
KB['KB_CAST_M']   = ' (NUM 4) '
KB['KB_Haste_M']  = ' (NUM -) '
KB['KB_March_M']  = ' (NUM +) '
KB['KB_MEDITATE'] = ' (NUM 0) '
KB['KB_SEKKANOKI']= ' (NUM .) '
KB['KB_SENGIKORI']= ' (NUM 4) '
KB['KB_BASH']	  = ' (NUM 1) '
KB['KB_JUMP']	  = ' (NUM 2) '
KB['KB_HI_JUMP']  = ' (NUM 3) '


function validateTextInformation()

    --Mode Information
    main_text_hub.player_current_idle =  state.IdleMode.current
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
    main_text_hub.player_current_mainweapon = state.mainWeapon.current
    main_text_hub.player_current_subweapon = state.subWeapon.current
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Haste = state.HasteMode.value
	main_text_hub.player_current_March = state.MarchMode.current    

end

function setupTextWindow()

    local default_settings = {}
    default_settings.pos = {}
    default_settings.pos.x = hud_x_pos
    default_settings.pos.y = hud_y_pos
	
    default_settings.bg = {}
    default_settings.bg.alpha = hud_transparency
    default_settings.bg.red = 30
    default_settings.bg.green = 20
    default_settings.bg.blue = 55
    default_settings.bg.visible = true
    
	default_settings.flags = {}
    default_settings.flags.right = false
    default_settings.flags.bottom = false
    default_settings.flags.bold = true
    default_settings.flags.draggable = hud_draggable
    default_settings.flags.italic = false
    
	default_settings.padding = hud_padding
    
	default_settings.text = {}
    default_settings.text.size = hud_font_size
    default_settings.text.font = hud_font
    default_settings.text.fonts = {}
    default_settings.text.alpha = 255
    default_settings.text.red = 147
    default_settings.text.green = 161
    default_settings.text.blue = 161
    
	default_settings.text.stroke = {}
    default_settings.text.stroke.width = 1
    default_settings.text.stroke.alpha = 255
    default_settings.text.stroke.red = 0
    default_settings.text.stroke.green = 0
    default_settings.text.stroke.blue = 0

    --Creates the initial Text Object will use to create the different sections in
    if not (main_text_hub == nil) then
        texts.destroy(main_text_hub)
    end
    main_text_hub = texts.new('', default_settings, default_settings)

    --Appends the different sections to the main_text_hub
    texts.append(main_text_hub, hub_mode)
	texts.update(main_text_hub, KB)
    --We then do a quick validation
    validateTextInformation()

    --Finally we show this to the user
    main_text_hub:show()
    
end
--[AUTO MOVEMENT SPEED LOGIC]

runspeed = M(false)
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
	mov.x = windower.ffxi.get_mob_by_index(player.index).x
	mov.y = windower.ffxi.get_mob_by_index(player.index).y
	mov.z = windower.ffxi.get_mob_by_index(player.index).z
end
moving = false

windower.raw_register_event('prerender',function()
	mov.counter = mov.counter + 1;
	if mov.counter>10 then
		local pl = windower.ffxi.get_mob_by_index(player.index)
		if pl and pl.x and mov.x then
			local movement = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 ) > 0.1
			if movement and not moving then
				send_command('gs c runspeed')
				moving = true
			elseif not movement and moving then
				send_command('gs c runspeed')
				moving = false
			end
		end

		if pl and pl.x then
			mov.x = pl.x
			mov.y = pl.y
			mov.z = pl.z
		end
		mov.counter = 0
	end
	Auto_Stance()
end)

function updateRunspeedGear()   
	handle_equipping_gear(player.status, pet.status)
end