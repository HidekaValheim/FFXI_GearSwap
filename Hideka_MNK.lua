--Disclaimer: this is a heavily modified version of a random lua found out on the internet years ago.  
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
include('organizer-lib')
include('Modes.lua')
--include('packets.lua')

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei","Inoshishinofuda","Shikanofuda","Chonofuda", "Toolbag (Shihe)", "Toolbag (Ino)", "Toolbag (Shika)", "Toolbag (Cho)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
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
	include('Mote-TreasureHunter')
	state.TreasureMode:set('None')
	state.Buff.impetus = buffactive.impetus or false
	state.Buff.counterstance = buffactive.counterstance or false
	state.Buff.footwork = buffactive.footwork or false
	state.Buff.Doomed = buffactive.doomed or false

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
	state.OffenseMode:options ('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'MAXBUFF')
	state.HybridMode:options('Normal', 'LowDT', 'MidDT','HiDT', 'Counter')
	state.CastingMode:options('Normal', 'Resistant', 'Burst')
	state.IdleMode:options('Normal','Recover','DT')
	mainweapon={}
	subWeapon={}
	state.mainWeapon = M('Karambit','Spharai', 'Malignance Pole')
	state.subWeapon = M('','Bloodrain Strap')	
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds
	
	send_command('bind numpad0 input /ja provoke <t>')
	send_command('bind numpad4 gs c cycle CastingMode')
	send_command('bind numpad5 gs c cycle WeaponskillMode')
	send_command('bind numpad6 gs c cycle IdleMode')
	send_command('bind numpad7 gs c cycle OffenseMode')
	send_command('bind numpad9 gs c cycle RangedMode')
	send_command('bind numpad8 gs c cycle HybridMode')
	send_command('bind numpad/ gs c cycle mainWeapon')
	send_command('bind numpad* gs c cycle subWeapon')

	send_command('unbind ^r')

	select_default_macro_book()
	use_UI = true
	hud_x_pos = 1515    --important to update these if you have a smaller screen
	hud_y_pos = 300     --important to update these if you have a smaller screen
	hud_draggable = true
	hud_font_size = 9
	hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
	hud_font = 'Impact'
	setupTextWindow()
	send_command('wait 2; input /lockstyleset 20')
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
	Segomo = {}
	Segomo.DA 	 = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	Segomo.CNTR	 = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Counter+10%',}}
	Segomo.CRIT  = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Crit.hit rate+10',}}
	Segomo.VITWS = {name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Segomo.DEXWS = {name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Segomo.STRWS = {name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Segomo.INTWS = {name="Segomo's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%',}}
	Segomo.FC	 = {name="Segomo's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}}

	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA['Hundred Fists'] = {legs="Hes. Hose +3"}
	sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1", waist="Ask Sash"}
	sets.precast.JA['Dodge'] = {feet="Anchorite's Gaiters +3"}
	sets.precast.JA['Focus'] = {head="Temple Crown"}
	--Chakra Formula: VIT*2*(1+M)*f(lv)
	--M= Equipment multiplier
	--f(lv) - Monks level
	sets.precast.JA['Chakra'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Anch. Cyclas +1",
		hands={ name="Hes. Gloves +1", augments={'Enhances "Invigorate" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Handler's Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back="Moonbeam Cape",
	}
	sets.precast.JA['Chi Blast'] = {hands="Anchorite's Gloves +1"}
	sets.precast.JA['Counterstance'] = {feet="Hesychast's Gaiters +3"}
	sets.precast.JA['Footwork'] = {feet="Bhikku Gaiters +1"}
	sets.precast.JA['Mantra'] = {feet="Hes. Gaiters +3"}
	sets.precast.JA['Formless Strikes'] = {body="Hes. Cyclas +1"}
	sets.precast.JA['Perfect Counter'] = {head="Bhikku Crown +1"}
	sets.precast.JA['Impetus'] = {body="Bhikku Cyclas +1"}
	sets.precast.JA['Inner Strength'] = {}

	
	sets.precast.JA['Provoke'] = {
		ammo="Sapience Orb",
		head="Nyame Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Zoar Subligar +1",
		feet="Ahosi Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back="Reiki Cloak",
	}

	-- Waltz (chr and vit)
	sets.precast.Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin can drop acc
	sets.precast.Step = {}	
	sets.precast.Flourish1 = set_combine(sets.precast.Step, {waist="Chaac Belt"})
	sets.midcast["Apururu (UC)"] = {body="Apururu Unity shirt"}

	--------------------------------------
	-- Utility Sets for rules below
	--------------------------------------
	sets.TreasureHunter = {waist="Chaac Belt", ammo="Per. Lucky egg", head = "Wh. Rarab Cap +1", feet="Volte Boots"}
	----------------------------------
    -- Casting
	----------------------------------
	-- Precasts
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+5','MND+8','"Mag.Atk.Bns."+14',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+5','INT+1','"Mag.Atk.Bns."+8',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Rahab Ring",
		right_ring="Weather. Ring",
		back=Segomo.FC
	}
	
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {Body="Passion Jacket", neck="Magoraga Beads"})
	
	-- Midcasts
	-- FastRecast (A set to end in when no other specific set is built to reduce recast time)
	sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+5','MND+8','"Mag.Atk.Bns."+14',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+5','INT+1','"Mag.Atk.Bns."+8',}},
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back=Segomo.FC	
	}


	----------------------------------
	-- Idle Sets
	----------------------------------
	sets.idle = {}
	sets.idle.Normal = {	
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
    sets.idle.Recover = {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Hiza. Haramaki +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Infused Earring",
		right_ear="Tuisto Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Moonbeam Cape",
	}
    sets.idle.DT = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Meridian Ring",
		back="Moonbeam Cape",	
	}
	
	----------------------------------
	-- full Defense sets for react and other things
	----------------------------------
	-- 51% PDT + Nullification(Mantle)
	sets.defense.PDT = {

	}

	-- 25% MDT + Absorb + Nullification + MEva
	sets.defense.PEVA = {

	}
		
	sets.MEva = {

	}
	
	sets.Death = set_combine(sets.MEva, {left_ring="Warden's Ring"})
	sets.Resist = set_combine(sets.MEva, {})
	sets.Resist.Stun = set_combine(sets.MEva, {})
	sets.movement = {feet="Herald's Gaiters"}
	
	sets.malig={}
		sets.malig.head	= {head = "Malignance Chapeau"}
		sets.malig.body	= {body = "Malignance Tabard"}
		sets.malig.hands= {hands= "Malignance Gloves"}
		sets.malig.legs	= {legs = "Malignance Tights"}
		sets.malig.feet	= {feet = "Malignance Boots"}
		sets.malig.full	= set_combine(sets.malig.head, sets.malig.body, sets.malig.hands, sets.malig.legs, sets.malig.feet)
	sets.mpaca={}
		sets.mpaca.head	= {head = "Mpaca's Cap"}
		sets.mpaca.body	= {body = "Mpaca's Doublet"}
		sets.mpaca.hands= {hands= "Mpaca's Gloves"}
		sets.mpaca.legs	= {legs = "Mpaca's Hose"}
		sets.mpaca.feet	= {feet = "Mpaca's Boots"}
		sets.mpaca.full	= set_combine(sets.mpaca.head,sets.mpaca.body,sets.mpaca.hands,sets.mpaca.legs,sets.mpaca.feet)
	sets.hybrid={
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
	}
	sets.counter={}
	sets.counterstance={}
	
	----------------------------------
	--Generic Accuracy Sets
	----------------------------------
	--[[ACC Guidelines Before Food(AfterFood) - Content
		Normal: 1000 (1100) - casual/solo
		Low:	1100 (1200) - Omen bosses, Geas Fete T3
		Mid:	1200 (1300) - VD Ambuscade (normal Month), Wave 3 Dyna D
		High:	1300 (1400) - Helms, VD Ambuscade (Hard month)
	Buff tiers assume No external buffs. Lower the tier if recieving madrigals or hunters.]]
	
	sets.acc ={}
	--[ACC+70] - Need 1200 total once combined into parent set
		sets.acc.low ={
			right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
			right_ear	= {name="Mache Earring +1",bag="wardrobe6"},		
		}
	--[ACC+140] - need 1300 Total once Combined into parent set
		sets.acc.mid = {
			left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
			right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
			right_ear	= {name="Mache Earring +1",bag="wardrobe6"},		
		}
	--[ACC+200] - need 1400 total once combined into parent set
		sets.acc.high={
			left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
			right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
			left_ear	= {name="Mache Earring +1",bag="wardrobe2"},
			right_ear	= {name="Mache Earring +1",bag="wardrobe6"},		
		}

	sets.engaged ={
		ammo = { name="Coiste Bodhar", augments={'Path: A',}},
		head = { name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body = { name="Tatena. Harama. +1", augments={'Path: A',}},
		hands= { name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Hes. Hose +3", augments={'Enhances "Hundred Fists" effect',}},
		feet="Anch. Gaiters +3",
		neck = { name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist= "Moonbow Belt +1",
		left_ear = "Sherida Earring",
		right_ear = { name="Schere Earring", augments={'Path: A',}},
		left_ring = "Niqmaddu Ring",
		right_ring = "Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	sets.engaged.Counter={
		ammo="Amar Cluster",
		head="Rao Kabuto +1",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Rao Kote +1",
		legs="Anch. Hose +1",
		feet="Malignance Boots",
		neck={ name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear="Bhikku Earring +2",
		left_ring="Niqmaddu Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},	
	}
	
	--Accuracy Variants
	sets.engaged.LowAcc 		= set_combine(sets.engaged, sets.acc.low, {})
	sets.engaged.MidAcc 		= set_combine(sets.engaged,	sets.acc.mid, {})
	sets.engaged.HighAcc 		= set_combine(sets.engaged,	sets.acc.high,{})

	sets.engaged.LowDT 			= set_combine(sets.engaged, sets.mpaca.full, {})
	sets.engaged.LowAcc.LowDT	= set_combine(sets.engaged, sets.mpaca.full, sets.acc.low, {})
	sets.engaged.MidAcc.LowDT 	= set_combine(sets.engaged, sets.mpaca.full, sets.acc.mid, {})
	sets.engaged.HighAcc.LowDT 	= set_combine(sets.engaged, sets.mpaca.full, sets.acc.high,{})
	
	sets.engaged.MidDT 			= set_combine(sets.engaged, sets.hybrid, {})
	sets.engaged.LowAcc.MidDT	= set_combine(sets.engaged, sets.hybrid, sets.acc.low, {})
	sets.engaged.MidAcc.MidDT	= set_combine(sets.engaged, sets.hybrid, sets.acc.mid, {})
	sets.engaged.HighAcc.MidDT 	= set_combine(sets.engaged, sets.hybrid, sets.acc.high,{})
	
	sets.engaged.HiDT 			= set_combine(sets.engaged, sets.malig.full, {right_ring="Defending Ring",left_ring="Gelatinous Ring +1"})
	sets.engaged.LowAcc.HiDT	= set_combine(sets.engaged,	sets.malig.full, sets.acc.low, {right_ring="Defending Ring", left_ring="Gelatinous Ring +1"})
	sets.engaged.MidAcc.HiDT	= set_combine(sets.engaged, sets.malig.full, sets.acc.mid, {right_ring="Defending Ring", left_ring="Gelatinous Ring +1"})
	sets.engaged.HighAcc.HiDT   = set_combine(sets.engaged, sets.malig.full, sets.acc.high,{right_ring="Defending Ring", left_ring="Gelatinous Ring +1"})
	
	sets.engaged.LowAcc.Counter	= set_combine(sets.counter, sets.acc.low, {})
	sets.engaged.MidAcc.Counter	= set_combine(sets.counter, sets.acc.mid, {})
	sets.engaged.HighAcc.Counter = set_combine(sets.counter, sets.acc.high,{})
	
	--These three sets will override all slots for all set configurations when their effects are active//- ONLY use the absolutely necessary gear items
	sets.impetus={body="Bhikku Cyclas +1"}

	sets.counterstance={
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Hes. Hose +3",
		feet={ name="Hes. Gaiters +3", augments={'Enhances "Mantra" effect',}},
		neck="Loricate Torque +1",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},
	}
	sets.footwork={feet="Anch. Gaiters +3", legs="Hes. Hose +3"}
	sets.kickattacks={feet="Anch. Gaiters +3"}

	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",
	}
    
	sets.precast.WS.MAXBUFF = set_combine(sets.precast.WS, {})
    
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Victory Smite'] 		= {
		ammo="Knobkierrie",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck={ name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},
	}
	sets.precast.WS['Raging Fists']	= {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},
	}
	sets.precast.WS['Shijin Spiral']	= {
		ammo="Knobkierrie",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Hes. Hose +3", augments={'Enhances "Hundred Fists" effect',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	sets.precast.WS['Howling Fist']	= {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck={ name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},
	}
	sets.precast.WS['Tornado Kick']	= {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},
	}
	sets.precast.WS['Dragon Kick']	= {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+9','"Dbl.Atk."+10',}},
	}
	sets.precast.WS['Final Heaven']	= {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear="Ishvara Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back="Sacro Mantle",
	}
	sets.precast.WS['Cataclysm']	= {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Sacro Mantle",
	}
	sets.precast.WS['Shell Crusher']	= {
		ammo="Pemphredo Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Sacro Mantle",
	}
	
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
	-- print('job_precast = '.. tostring(spell)..' | '..tostring(action)..' | '..tostring(spellMap)..' | '..tostring(eventArgs))
	if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "Utsusemi" then
			classes.CustomClass = "SelfNinjutsu"
	end
-- Cancel Sneak before reapplying spectral jig
	if spell.name == 'Spectral Jig' and buffactive.sneak then
		send_command('cancel 71')
	end
--Cancel Utsusemi Shadows during casting lower tier utsusemi spells. prevents re-casting utsusemi with more than 4 shadows remaining to prevent overbuffing
    if spell.name == 'Utsusemi: Ichi' then
		if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']  then
			send_command('cancel 66; cancel 444; cancel 445; cancel 446; cancel Copy Image; cancel Copy Image (2); cancel Copy Image (3);cancel Copy Image (4+)')
--[[debug	add_to_chat(123, '**!!CASTING UTSUSEMI: ICHI - REMOVING EXISTING SHADOWS!!**')]]
		end
	elseif spell.name == 'Utsusemi: Ni' then
		if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']  then
			send_command('cancel 66; cancel 444; cancel 445; cancel 446; cancel Copy Image; cancel Copy Image (2); cancel Copy Image (3);cancel Copy Image (4+)')
--[[debug	add_to_chat(123, '**!!CASTING UTSUSEMI: NI - REMOVING EXISTING SHADOWS!!**')]]
		end
	end



	
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- print('job_post_precast = '.. tostring(spell)..' | '..tostring(action)..' | '..tostring(spellMap)..' | '..tostring(eventArgs))
	if spell.name=='Victory Smite' and buffactive['Impetus'] then 
		equip(set_combine(sets.precast.WS['Victory Smite'],sets.impetus))
	end
	if spell.name=='Dragon Kick' and buffactive['Footwork']  then 
		equip(set_combine(sets.precast.WS['Dragon Kick'],sets.kickattacks))
	end
	if spell.name=='Tornado Kick' and buffactive['Footwork']  then
		equip(set_combine(sets.precast.WS['Tornado Kick'],sets.kickattacks))
	end	
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	-- print('job_midcast = '.. tostring(spell)..' | '..tostring(action)..' | '..tostring(spellMap)..' | '..tostring(eventArgs))
	if spell.english == "Monomi: Ichi" then
		if buffactive['Sneak'] then
			send_command('@wait 1;cancel 71')
		end
	end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- print('job_post_midcast = '.. tostring(spell)..' | '..tostring(action)..' | '..tostring(spellMap)..' | '..tostring(eventArgs))

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	-- print('job_aftercast = '.. tostring(spell)..' | '..tostring(action)..' | '..tostring(spellMap)..' | '..tostring(eventArgs))
	if midaction() then
		return
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
	-- validateTextInformation()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HybridMode.value == 'PDT' then
		idleSet = set_combine(idleSet, sets.idle.PDT)
	else
		idleSet = idleSet
	end
    if moving then
		idleSet=set_combine(idleSet, sets.movement)
	end
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	if buffactive['Footwork'] then 
		meleeSet=set_combine(meleeSet, sets.footwork)
	end
	if buffactive['Counterstance'] then 
		meleeSet=set_combine(meleeSet, sets.counterstance)
	end
	if buffactive['Impetus'] then 
		meleeSet=set_combine(meleeSet, sets.impetus)
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
	if not midaction() then
		handle_equipping_gear(player.status)
	end

end


function job_status_change(newStatus, oldStatus, eventArgs)
	select_weapons()
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called by the default 'update' self-command.

function job_update(cmdParams, eventArgs)
	select_weapons()
	select_movement_feet()
	th_update(cmdParams, eventArgs)
	validateTextInformation()
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

end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)

end


function select_weapons()
	if player.equipment.main ~= state.mainWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end
	if player.equipment.sub ~= state.subWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end

end


function job_self_command(cmdParams, eventArgs)
	if cmdParams[1] == 'runspeed' then
		runspeed:toggle()
		updateRunspeedGear(runspeed.value) 
	end

end

function stance_check()
 local ability_recasts = windower.ffxi.get_ability_recasts()
	if player.status=='Engaged' then
		if player.sub_job=='SAM' and ability_recasts[138] == 0 then
			send_command('@input /ja "Hasso" <me> ;wait 1')
		end
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(2, 16)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 16)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 16)
	else
		set_macro_page(1, 16)
	end
end

--NIN_HUD--
------------------------------------------------------------------------------------------------------------
--HUD STUFF
------------------------------------------------------------------------------------------------------------
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
hub_mode_std = [[\cs(204, 0, 0)KeyBinds    \cs(255, 115, 0)GS Info: \cr              
		\cs(175, 125, 225)${KB_C_MH}\cs(0, 150, 175)Main:\cr \cs(125,255,125)${player_current_mainweapon|Kannagi}
		\cs(175, 125, 225)${KB_C_OH}\cs(0, 150, 175)Sub:\cr \cs(125,255,125)  ${player_current_subweapon|Kannagi}
		\cs(175, 125, 225)${KB_Idle_M}\cs(0, 150, 175)Idle Mode:\cr         ${player_current_idle}
		\cs(175, 125, 225)${KB_Melee_M}\cs(0, 150, 175)Melee Mode:\cr     ${player_current_melee}
		\cs(175, 125, 225)${KB_WS_M}\cs(0, 150, 175)WS Mode:\cr            ${player_current_ws}
		\cs(175, 125, 225)${KB_PDT_M}\cs(0, 150, 175)Hybrid Mode:\cr    ${player_current_Hybrid}

]]



-- init style
hub_mode = hub_mode_std
hub_options = hub_options_std
hub_job = hub_job_std
hub_battle = hub_battle_std

KB = {}
KB['KB_C_MH'] 	= '   (NUM /)         '
KB['KB_C_OH'] 	= '   (NUM *)          '
KB['KB_Idle_M'] = '   (NUM 6)         '
KB['KB_Melee_M']= '   (NUM 7)         '
KB['KB_WS_M'] 	= '   (NUM 5)        '
KB['KB_PDT_M'] 	= '   (NUM 8)        '
KB['KB_RA_M'] 	= '   (NUM 9)        '
KB['KB_Haste_M']= '   (NUM -)         '
KB['KB_March_M']= '   (NUM +)        '



function validateTextInformation()


    --Mode Information
    main_text_hub.player_current_idle =  state.IdleMode.current
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
    main_text_hub.player_current_mainweapon = state.mainWeapon.current
    main_text_hub.player_current_subweapon = state.subWeapon.current
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Ranged = state.RangedMode.current	
    main_text_hub.player_current_casting = state.CastingMode.current
  

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
end)

function updateRunspeedGear()   
	handle_equipping_gear(player.status, pet.status)
end