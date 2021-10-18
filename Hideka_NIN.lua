--Disclaimer: this is a heavily modified version of a random lua found out on the internet years ago. 
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
include('organizer-lib')

organizer_items = {
    Consumables={"Echo Drops","Holy Water", "Remedy"},
    NinjaTools={"Shihei","Inoshishinofuda","Shikanofuda","Chonofuda"},
	  Food={"Tropical Crepe", "Sublime Sushi", "Om. Sandwich"},
	  Storage={"Storage Slip 16","Storage Slip 18","Storage Slip 21","Storage Slip 23","Storage Slip 24",
			"Storage Slip 25","Storage Slip 26","Storage Slip 27","Storage Slip 28"}
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_sets()
	mote_include_version = 2
	include('Mote-Include.lua')
	require('vectors')

end

function get_gear()
--'//gs c getgear' to retrieve/pack gear manually. Only works in PortTowns list
    if PortTowns:contains(world.area) then
		send_command('wait 3;input //gs org') 
		send_command('wait 6;input //po repack') 
    else
		add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
    end
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

	gear.RegularAmmo = 'Date Shuriken'
	gear.SangeAmmo = 'Happo Shuriken'
	gear.MovementFeet = {name="Danzo Sune-ate"}
	gear.DayFeet = "Danzo Sune-ate"
	gear.NightFeet = "Hachiya Kyahan +1"
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Orpheus Sash"
	
	update_combat_form()
	ninbuff_status()
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
	state.OffenseMode:options ('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'MAXBUFF')
	state.HybridMode:options('Normal', 'PDT', 'MEVA','PEVA')
	state.CastingMode:options('Normal', 'Resistant', 'Burst')
	state.IdleMode:options('Normal')
	mainweapon={}
	subWeapon={}
	state.mainWeapon = M('Heishi Shorinken','Gokotai','Tauret','Naegling','Hachimonji','Karambit')
	state.subWeapon = M('Kunimitsu','Tsuru','Ternion Dagger +1','Gokotai','Tauret','Bloodrain Strap','')	
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds

	send_command('bind numpad7 gs c cycle OffenseMode')
	send_command('bind numpad9 gs c cycle RangedMode')
	send_command('bind numpad5 gs c cycle WeaponskillMode')
	send_command('bind numpad8 gs c cycle HybridMode')
	send_command('bind numpad4 gs c cycle CastingMode')
	send_command('bind numpad/ gs c cycle mainWeapon')
	send_command('bind numpad* gs c cycle subWeapon')
	send_command('bind numpad- gs c cycle HasteMode')
	send_command('bind numpad+ gs c cycle MarchMode')
	send_command('unbind ^r')
	
	
	
	select_movement_feet()
	select_default_macro_book()
	use_UI = true
	hud_x_pos = 1680    --important to update these if you have a smaller screen
	hud_y_pos = 300     --important to update these if you have a smaller screen
	hud_draggable = true
	hud_font_size = 10
	hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
	hud_font = 'Impact'
	setupTextWindow()
	
	stance = "No Stance"
	stance_status()
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
	Andartia = {}
	Andartia.DA 	= {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	Andartia.STP 	= {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	Andartia.AGIWS	= {name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Weapon skill damage +10%',}}
	Andartia.DEXWS 	= {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Andartia.STRWS 	= {name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Andartia.MAB 	= {name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}
	Andartia.FC 	= {name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}}

	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA['Mijin Gakure'] = {legs="Mochi. Hakama +3"}
	sets.precast.JA['Futae'] = {hands="Hattori Tekko +1"}
	sets.precast.JA['Sange'] = {ammo="Happo Shuriken",body="Mochi. Chainmail +3"}
	
	sets.precast.JA['Provoke'] = {
		ammo="Sapience Orb",
		head="Nyame Helm",
		body="Emet Harness",
		hands="Kurys Gloves",
		legs="Zoar Subligar",
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Provocare Ring",
		right_ring="Begrudging Ring",
		back="Reiki Cloak",
	}
	sets.midcast.Flash = set_combine(sets.precast.JA['Provoke'], {})

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
	
	sets.midcast.RA = {
		ammo="Happo Shuriken",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Enervating Earring",
		right_ear="Telos Earring",
		left_ring="Hajduk Ring",
		right_ring="Paqichikaji Ring",
		back=Andartia.DEXWS
	}
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})
	sets.midcast.RA.TH = set_combine(sets.midcast.RA, sets.TreasureHunter)

	----------------------------------
    -- Casting
	----------------------------------
	-- Precasts
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Oneiros Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back=Andartia.FC
	}
	
	sets.precast.FC.ElementalNinjutsuSan = set_combine(sets.precast.FC, {})
	
	--[Alternative Utsusemi fast casting Sets]

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {Body="Mochi. Chainmail +3", neck="Magoraga Beads"})
	
	-- Midcasts
	-- FastRecast (A set to end in when no other specific set is built to reduce recast time)
	sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Oneiros Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back=Andartia.FC	
	}

	-- Magic Accuracy Focus 
	sets.midcast.Ninjutsu = {
		ammo="Yamarang",
		head="Hachiya Hatsu. +3",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Incanter's Torque",
		waist="Eschan Stone",
		left_ear="Gwati Earring", --get digni earring you lazy fuck
		right_ear="Tuisto Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},
		back= Andartia.MAB 
	}
	
	-- Any ninjutsu cast on self - Recast Time Focus - Effects items that dont scale with Ninjutsu Skill, but not utsusemi
	sets.midcast.SelfNinjutsu = set_combine(sets.midcast.Ninjutsu, {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Oneiros Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back=Andartia.FC
	})
	
	sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {feet="Hattori Kyahan +1",back = Andartia.FC})
	--Migawari Scales with Skill. Migawari + Pieces Do nothing if you arent wearing them when you are hit
	sets.midcast.Migawari = set_combine(sets.midcast.SelfNinjutsu, {back = Andartia.FC}, {
		head="Hachiya Hatsu. +3",
		feet="Mochi. Kyahan +3",
		neck="Incanter's Torque",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},		
		back=Andartia.FC
	})

	-- Nuking Ninjutsu (skill & magic attack) - Scales Ton line spells
		sets.midcast.ElementalNinjutsu = {
		ammo="Pemphredo Tathlum",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Gyve Doublet",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Shiva Ring +1",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}

	--Ni spells benefit from Higher INT and Magic damage
	sets.midcast.ElementalNinjutsu.Burst 		= set_combine(sets.midcast.ElementalNinjutsu, 			{    
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		left_ring="Mujin Band",
		right_ring="Locus Ring",
		})
	sets.midcast.ElementalNinjutsu.Resistant 	= set_combine(sets.midcast.Ninjutsu, 					{})
	
	--San Spells Benefit from Higher MAB
	sets.midcast.ElementalNinjutsuSan 			= set_combine(sets.midcast.ElementalNinjutsu, 			{})
	sets.midcast.ElementalNinjutsuSan.Burst 	= set_combine(sets.midcast.ElementalNinjutsuSan, 		{
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		left_ring="Mujin Band",
		right_ring="Locus Ring",	
		})
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
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet=gear.MovementFeet,
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Cryptic Earring",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Reiki Cloak",
	}

    sets.idle.PDT = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet=gear.MovementFeet,
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	}

	----------------------------------
	-- full Defense sets for react and other things
	----------------------------------
	-- 51% PDT + Nullification(Mantle)
	sets.defense.PDT = {
		ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back=Andartia.DA
	}

	-- 25% MDT + Absorb + Nullification + MEva
	sets.defense.PEVA = {
		ammo="Staunch Tathlum",
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet="Mpaca's Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back=Andartia.DA	
	}
		
	sets.MEva = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hachi. Kyahan +1",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
	
	sets.Death = set_combine(sets.MEva, {left_ring="Warden's Ring"})
	sets.Resist = set_combine(sets.MEva, {})
	sets.Resist.Stun = set_combine(sets.MEva, {})
	sets.DayMovement = {feet="Danzo Sune-ate"}
	sets.NightMovement = {feet="Hachiya Kyahan +1"}

	--------------------------------------------------------------------
	-- Generic Armor Sets used for Micromanaging Haste DW ACC and DT tiers
	--------------------------------------------------------------------
	sets.malig={}
		sets.malig.head	= {head = "Malignance Chapeau"}
		sets.malig.body	= {body = "Malignance Tabard"}
		sets.malig.hands= {hands= "Malignance Gloves"}
		sets.malig.legs	= {legs = "Malignance Tights"}
		sets.malig.feet	= {legs = "Malignance Tights"}
		sets.malig.full	= set_combine(sets.malig.head, sets.malig.body, sets.malig.hands, sets.malig.legs, sets.malig.feet)
	sets.ken={}
		sets.ken.head	= {head = "Mpaca's Cap"}
		sets.ken.body	= {body = "Mpaca's Doublet"}
		sets.ken.hands	= {hands= "Mpaca's Gloves"}
		sets.ken.legs	= {legs = "Mpaca's Hose"}
		sets.ken.feet	= {feet = "Mpaca's Boots"}
		sets.ken.full	= set_combine(sets.ken.head,sets.ken.body,sets.ken.hands,sets.ken.legs,sets.ken.feet)
	sets.mpaca={}
		sets.mpaca.head	= {head = "Mpaca's Cap"}
		sets.mpaca.body	= {body = "Mpaca's Doublet"}
		sets.mpaca.hands= {hands= "Mpaca's Gloves"}
		sets.mpaca.legs	= {legs = "Mpaca's Hose"}
		sets.mpaca.feet	= {feet = "Mpaca's Boots"}
		sets.mpaca.full	= set_combine(sets.mpaca.head,sets.mpaca.body,sets.mpaca.hands,sets.mpaca.legs,sets.mpaca.feet)
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
		sets.acc.low = set_combine(sets.ken.legs,{
			left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
			right_ring	= {name="Chirich Ring +1", bag="wardrobe3"}
		})
	--[ACC+140] - need 1300 Total once Combined into parent set
		sets.acc.mid = set_combine(sets.ken.head,sets.ken.legs,{
			left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
			right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
			waist		= "Grunfeld Rope", 
			right_ear	= {name="Mache Earring +1",bag="wardrobe3"}
		})
	--[ACC+200] - need 1400 total once combined into parent set
		sets.acc.high=set_combine(sets.ken.head,sets.ken.legs,sets.ken.feet, {
			left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
			right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
			waist		= "Grunfeld Rope",
			left_ear	= "Telos Earring",
			right_ear	= {name="Mache Earring +1",bag="wardrobe3"}
		})
	----------------------------------
	--DW SETS
	----------------------------------		
	--[[Use DW Sets to cap haste. if you are missing pieces from these sets, or have downgraded pieces, you can change out the slot with a new piece of gear. 
		just be sure to balance the T12,T22,T32,T39 sets to match as close as possible to the required DW]]
	sets.dw={}
		sets.dw.head = {head 	 = "Ryuo Somen +1"}		--+9
		sets.dw.body = {body 	 = "Adhemar Jacket +1"} --+6
		sets.dw.legs = {legs 	 = "Mochi. Hakama +3"}	--+10
		sets.dw.feet = {feet 	 = "Hiza. Sune-Ate +2"}	--+8
		sets.dw.ear1 = {left_ear = "Suppanomimi"}		--+5
		sets.dw.ear2 = {right_ear= "Eabani Earring"}	--+4
		sets.dw.waist= {waist 	 = "Reiki Yotai"}		--+7		
		sets.dw.t12	 = set_combine(sets.dw.ear1, sets.dw.waist) --Need 12 total DW
		sets.dw.t16  = set_combine(sets.dw.ear1, sets.dw.ear2, sets.dw.waist)--Alt used for MEVA/PDT Sets, Cant Natively Hit Capped DW in those full Hybrid sets
		sets.dw.t22  = set_combine(sets.dw.head, sets.dw.body, sets.dw.waist)--Need 22 Total DW
		sets.dw.t24	 = set_combine(sets.dw.ear1, sets.dw.ear2, sets.dw.waist,sets.dw.feet)--Alt used for MEVA/PDT Sets, Cant Natively Hit Capped DW in those full Hybrid sets
		sets.dw.t32	 = set_combine(sets.dw.head, sets.dw.ear1, sets.dw.ear2, sets.dw.body, sets.dw.waist)--32 DW To cap
		sets.dw.t39  = set_combine(sets.dw.head, sets.dw.ear1, sets.dw.ear2, sets.dw.body, sets.dw.waist, sets.dw.feet)--39 DW To cap
		
	----------------------------------
	-- No Haste - Requires 39 total DW to cap. use sets.dw.t39 as primary set join
	----------------------------------	
	sets.engaged = set_combine(sets.dw.t39, {
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=Andartia.DA
	})


	----------------------------------
	-- No Haste SetVariants
	----------------------------------
	--Accuracy Variants
	sets.engaged.LowAcc 		= set_combine(sets.engaged, sets.acc.low,	{})
	sets.engaged.MidAcc 		= set_combine(sets.engaged,	sets.acc.mid,	{})
	sets.engaged.HighAcc 		= set_combine(sets.engaged,	sets.acc.high,	{})

	sets.engaged.PEVA 			= set_combine(sets.engaged, sets.mpaca.full,	{})
	sets.engaged.LowAcc.PEVA	= set_combine(sets.engaged, sets.acc.low,	sets.mpaca.full,	{})
	sets.engaged.MidAcc.PEVA 	= set_combine(sets.engaged, sets.acc.mid,	sets.mpaca.full,	{})
	sets.engaged.HighAcc.PEVA 	= set_combine(sets.engaged, sets.acc.high,	sets.mpaca.full,	{})
	
	sets.engaged.MEVA 			= set_combine(sets.engaged, sets.ken.full,	{})
	sets.engaged.LowAcc.MEVA	= set_combine(sets.engaged, sets.acc.low,	sets.ken.full,	{})
	sets.engaged.MidAcc.MEVA 	= set_combine(sets.engaged, sets.acc.mid,	sets.ken.full,	{})
	sets.engaged.HighAcc.MEVA 	= set_combine(sets.engaged, sets.acc.high,	sets.ken.full,	{})
	
	sets.engaged.PDT 			= set_combine(sets.engaged,	sets.malig.full,{})
	sets.engaged.LowAcc.PDT		= set_combine(sets.engaged,	sets.acc.low,	sets.malig.full,{})
	sets.engaged.MidAcc.PDT		= set_combine(sets.engaged, sets.acc.mid,	sets.malig.full,{})
	sets.engaged.HighAcc.PDT	= set_combine(sets.engaged, sets.acc.high,	sets.malig.full,{})

    
	----------------------------------
	-- Kannagi
	----------------------------------
	sets.engaged.Kannagi = {}
	sets.engaged.Kannagi.AM3 = {}

	----------------------------------
	-- GKT
	----------------------------------

	sets.engaged.GKT = {
	    head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},
	}
	sets.engaged.H2H = {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Mpaca's Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist= "Windbuffet Belt +1",
		left_ear={name="Mache Earring +1",bag="wardrobe2"},
		right_ear={name="Mache Earring +1",bag="wardrobe3"},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back=Andartia.DA
	}


 --[[Set Build order: [Melee Set] > [Accuracy set] > [DW Sets] > [DT Set] > [Custom Sets]
	* DW > ACC- Most DW Gear has native acc, so stack it after ACC gear to prevent mis-equips
	* Stack DT Last to prevent DT overwrites. Current DT Set keeps 43% PDT and 50% MDT under shell 5 at all times. 
	Use 10PDT Capes over 5 DT Capes. 5DT capes are for Malignanceless noobs.]]	
	
	--------------------------------------------------------------------
	-- MaxHaste Sets (0%DW Needed)
	--------------------------------------------------------------------
	-- DW Total in Gear: 0 DW / 1 DW Needed to Cap Delay Reduction
	
	sets.engaged.MaxHaste = {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+14','"Triple Atk."+4','Attack+15',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back= Andartia.DA
	}
	

	sets.engaged.LowAcc.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.acc.low,	{})
	sets.engaged.MidAcc.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	{})
	sets.engaged.HighAcc.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.acc.high,	{})

	sets.engaged.PEVA.MaxHaste 			= set_combine(sets.engaged.MaxHaste, sets.mpaca.full, {})	
	sets.engaged.LowAcc.PEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.low,	sets.mpaca.full, {})
	sets.engaged.MidAcc.PEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.mpaca.full, {})
	sets.engaged.HighAcc.PEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.mpaca.full, {})	 
	
	sets.engaged.MEVA.MaxHaste 			= set_combine(sets.engaged.MaxHaste, sets.ken.full, {})	
	sets.engaged.LowAcc.MEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.low,	sets.ken.full, {})
	sets.engaged.MidAcc.MEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.ken.full, {})
	sets.engaged.HighAcc.MEVA.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.ken.full, {})	
	 
	sets.engaged.PDT.MaxHaste 			= set_combine(sets.engaged.MaxHaste, sets.malig.full,	{right_ring="Defending Ring"})
	sets.engaged.LowAcc.PDT.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.MidAcc.PDT.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.HighAcc.PDT.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.malig.full, {right_ring="Defending Ring"})
 
	----------------------------------
    -- 35% Haste (~10-12%DW Needed)
	----------------------------------
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_35 				= set_combine(sets.engaged.MaxHaste, sets.dw.t12, {})
	
	sets.engaged.LowAcc.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t12, 	{})
	sets.engaged.MidAcc.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t12, 	{})
	sets.engaged.HighAcc.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.dw.t12, 	{})

	sets.engaged.PEVA.Haste_35 			= set_combine(sets.engaged.MaxHaste, sets.dw.t12,	sets.mpaca.full, 	{})
	sets.engaged.LowAcc.PEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t12, 	sets.mpaca.full, {})
	sets.engaged.MidAcc.PEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t12, 	sets.mpaca.full, {})
	sets.engaged.HighAcc.PEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t12, 	sets.mpaca.full, {})
	
	sets.engaged.MEVA.Haste_35 			= set_combine(sets.engaged.MaxHaste, sets.dw.t12,	sets.ken.full, 	{})
	sets.engaged.LowAcc.MEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t12, 	sets.ken.full, {})
	sets.engaged.MidAcc.MEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t12, 	sets.ken.full, {})
	sets.engaged.HighAcc.MEVA.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t12, 	sets.ken.full, {})
	
	sets.engaged.PDT.Haste_35 			= set_combine(sets.engaged.MaxHaste, sets.dw.t12,	sets.malig.full,{right_ring="Defending Ring"})
	sets.engaged.LowAcc.PDT.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t12, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.MidAcc.PDT.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t12, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.HighAcc.PDT.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t12, 	sets.malig.full, {right_ring="Defending Ring"})

	----------------------------------
    -- 30% Haste (~21-22%DW Needed)
	----------------------------------
	-- DW Total in Gear: 21 DW / 21 DW Needed to Cap Delay Reduction
	-- DW DT Sets CANT cap DW in this haste tier Without sacrificing DT. If you want to override a piece of DT Gear, simply include it. (Use DW Head, Ear2, and Waist if dropping malignance for DT)
	-- Use DW Cape 
	sets.engaged.Haste_30				= set_combine(sets.engaged.MaxHaste, sets.dw.t22, 	{})
	
	sets.engaged.LowAcc.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t22,	{})
	sets.engaged.MidAcc.Haste_30		= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t22,	{})
	sets.engaged.HighAcc.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t22,	{})

	sets.engaged.PEVA.Haste_30 			= set_combine(sets.engaged.MaxHaste, sets.dw.t22,	sets.mpaca.full, 	{})
	sets.engaged.LowAcc.PEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t22, 	sets.mpaca.full, {})
	sets.engaged.MidAcc.PEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t22, 	sets.mpaca.full, {})
	sets.engaged.HighAcc.PEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t22, 	sets.mpaca.full, {})	
	
	sets.engaged.MEVA.Haste_30 			= set_combine(sets.engaged.MaxHaste, sets.dw.t22,	sets.ken.full, 	{})
	sets.engaged.LowAcc.MEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t22, 	sets.ken.full, {})
	sets.engaged.MidAcc.MEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t22, 	sets.ken.full, {})
	sets.engaged.HighAcc.MEVA.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t22, 	sets.ken.full, {})	
	
	sets.engaged.PDT.Haste_30 			= set_combine(sets.engaged.MaxHaste, sets.dw.t22, 	sets.malig.full,{right_ring="Defending Ring"})
	sets.engaged.LowAcc.PDT.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t22, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.MidAcc.PDT.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t22, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.HighAcc.PDT.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.acc.high, sets.dw.t22, 	sets.malig.full, {right_ring="Defending Ring"})
	----------------------------------
	-- 15% Haste (~32%DW Needed)
	----------------------------------
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_15 				= set_combine(sets.engaged.MaxHaste, sets.dw.t32, 	{})

	sets.engaged.LowAcc.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.acc.low, 	sets.dw.t32, 	{})
	sets.engaged.MidAcc.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.acc.mid, 	sets.dw.t32, 	{})
	sets.engaged.HighAcc.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.dw.t32,	{})

	sets.engaged.PEVA.Haste_15 			= set_combine(sets.engaged.MaxHaste, sets.dw.t32,	sets.mpaca.full, 	{})
	sets.engaged.LowAcc.PEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.low,	sets.dw.t32, 	sets.mpaca.full, {})
	sets.engaged.MidAcc.PEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.dw.t32, 	sets.mpaca.full, {})
	sets.engaged.HighAcc.PEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.dw.t32, 	sets.mpaca.full, {})	
	
	sets.engaged.MEVA.Haste_15 			= set_combine(sets.engaged.MaxHaste, sets.dw.t32,	sets.ken.full, 	{})
	sets.engaged.LowAcc.MEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.low,	sets.dw.t32, 	sets.ken.full, {})
	sets.engaged.MidAcc.MEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.dw.t32, 	sets.ken.full, {})
	sets.engaged.HighAcc.MEVA.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.dw.t32, 	sets.ken.full, {})	
	
	sets.engaged.PDT.Haste_15 			= set_combine(sets.engaged.MaxHaste, sets.dw.t32,	sets.malig.full,{})
	sets.engaged.LowAcc.PDT.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.low,	sets.dw.t32, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.MidAcc.PDT.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.mid,	sets.dw.t32, 	sets.malig.full, {right_ring="Defending Ring"})
	sets.engaged.HighAcc.PDT.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.acc.high,	sets.dw.t32, 	sets.malig.full, {right_ring="Defending Ring"})
	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	sets.precast.WS = {
		ammo = "Coiste Bodhar",
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back=Andartia.DEXWS
	}
    
	sets.precast.WS.MAXBUFF = set_combine(sets.precast.WS, {})
    
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Blade: Hi'] 		= set_combine(sets.precast.WS, {
		ammo="Yetshila",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Mpaca's Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Mache Earring +1",
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	})
	sets.precast.WS['Blade: Hi'].MAXBUFF 	= set_combine(sets.precast.WS['Blade: Hi'], {
		head="Hachiya Hatsu. +3",
	})
	
	sets.precast.WS['Blade: Ten'] 		={
		ammo="C. Palug Stone",
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Ten'].MAXBUFF = set_combine(sets.precast.WS['Blade: Ten'], {
		hands="Malignance Gloves",
		feet="Nyame Sollerets",
		left_ring="Epaminondas's Ring",
	})
	
	sets.precast.WS['Blade: Jin'] 		= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands="Mummu Wrists +2",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Mache Earring +1",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Jin'].MAXBUFF = set_combine(sets.precast.WS['Blade: Jin'],{})
	
	sets.precast.WS['Blade: Kamu'] 		= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},	
	}
	sets.precast.WS['Blade: Kamu'].MAXBUFF 	= set_combine(sets.precast.WS['Blade: Kamu'], {})
	
	sets.precast.WS['Blade: Metsu'] 	= set_combine(sets.precast.WS['Blade: Ten'], {})
	sets.precast.WS['Blade: Metsu'].MAXBUFF = set_combine(sets.precast.WS['Blade: Metsu'], {})

	sets.precast.WS['Blade: Shun'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Shun'].MAXBUFF = set_combine(sets.precast.WS['Blade: Shun'], {
		body="Nyame Mail",
		hands="Malignance Gloves",
		legs="Jokushu Haidate",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		right_ear="Mache Earring +1",
	})
	
	sets.precast.WS['Blade: Ku'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Mochi. Chainmail +3", augments={'Enhances "Sange" effect',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Mache Earring +1",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Ku'].MAXBUFF = set_combine(sets.precast.WS['Blade: Ku'], {
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Nyame Flanchard",
		feet={ name="Ryuo Sune-Ate +1", augments={'STR+12','DEX+12','Accuracy+20',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		right_ear="Brutal Earring",
	
	})	

	sets.precast.WS['Blade: Yu'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Dingir Ring",
		right_ring="Shiva Ring +1",
		back=Andartia.MAB--DEXWS(alt needs testing)
	}

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {
		ammo="Pemphredo Tathlum",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Ninja Nodowa +2",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	})
	sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Blade: Ei'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Magic burst dmg.+7%','"Mag.Atk.Bns."+15',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Shiva Ring +1",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Blade: Yu']
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS['Blade: Hi'], {})
	-- USE MACC FOR AGEHA TO STICK DEBUFF. NOT USED FOR DAMAGE EVER.
	sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS,{
		Ammo="Yetshila",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=Andartia.DEXWS
	})
	sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS['Blade: Ten'], {})
	sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS['Blade: Ten'], {})
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Blade: Chi'],{})
	
 	sets.precast.WS['Asuran Fists'] = {
		ammo="Yamarang",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Nyame Mail",
		hands="Malignance Gloves",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Gere Ring",
		back=Andartia.DA
	}
 	sets.precast.WS['Raging Fists'] = {
		ammo = "Coiste Bodhar",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Jokushu Haidate",
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Gere Ring",
		back=Andartia.DEXWS
	}
 	sets.precast.WS['Savage Blade'] = {
		ammo = "Coiste Bodhar",
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands={ name="Herculean Gloves", augments={'Accuracy+10','Weapon skill damage +4%','STR+5',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Lugra Earring +1",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back=Andartia.DEXWS
	}	
 	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Blade: Ei'], {})

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
	-- Ranged Attacks 
	if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'LowAcc' then
		equip(sets.SangeAmmo)
	end
	
	-- Protection for lag
	if spell.name == 'Sange' and player.equipment.ammo == gear.RegularAmmo then
		state.Buff.Sange = false
		eventArgs.cancel = true
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
	stance_status()

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
ninbuff_status()
stance_status()
tool_counter()
validateTextInformation()
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

function ninbuff_status()
	if buffactive['Copy Image'] then
		shadows='1 Shadow'
	elseif buffactive['Copy Image (2)'] then
		shadows='2 Shadows'
	elseif buffactive['Copy Image (3)'] then
		shadows='3 Shadows'
	elseif buffactive['Copy Image (4+)'] then
		shadows='4 Shadows' 
	else
		shadows='No Shadows'
	end
	
	if buffactive['Migawari'] then
		migawari='Active'
	else
		migawari='Inactive'
	end
end

function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		update_combat_form()
	end
select_weapons()
end

function stance_status()

	if buffactive['Innin'] then
		stance = 'Innin'
	elseif buffactive['Yonin'] then
		stance = 'Yonin'
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
	select_ammo()
	select_movement_feet()
	determine_haste_group()
	update_combat_form()
	th_update(cmdParams, eventArgs)
	tool_counter()
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

function select_weapons()
	if player.equipment.main ~= state.mainWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end
	if player.equipment.sub ~= state.subWeapon.current then 
		equip({Main=state.mainWeapon.current,sub=state.subWeapon.current})
	end

end

function update_combat_form()
	--if state.Buff.Innin then
	--	state.CombatForm:set('Innin')
	--end
	--if player.equipment.main == 'Kannagi' then
	--	state.CombatWeapon:set('Kannagi')
	if player.equipment.main == 'Beryllium Tachi' then
		state.CombatWeapon:set('GKT')	
	elseif player.equipment.main == "Hachimonji" then
		state.CombatWeapon:set('GKT')
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


function tool_counter()

	local inv = windower.ffxi.get_items(0) -- get main inventory
	
	shihei.count = 0
	shihei.id = 1179
	
	inoshi.count = 0
	inoshi.id = 2971
	
	chono.count = 0
	chono.id = 2973
	
	shika.count = 0
	shika.id = 2972
	
	happo.count = 0
	happo.id = 21353
	
	for b,v in ipairs(inv) do
		if v.id == shihei.id then
			shihei.count = shihei.count + v.count
		elseif v.id == inoshi.id then
			inoshi.count = inoshi.count + v.count
		elseif v.id == chono.id then
			chono.count = chono.count + v.count
		elseif v.id == shika.id then
			shika.count = shika.count + v.count
		elseif v.id == happo.id then
			happo.count = happo.count + v.count
		end
	end
--[[
Debug Viewer
	windower.add_to_chat(8,'shihei:' ..shihei.count)
	windower.add_to_chat(8,'inoshi:' ..inoshi.count)
	windower.add_to_chat(8,'chono:' ..chono.count)
	windower.add_to_chat(8,'shika:' ..shika.count)
	windower.add_to_chat(8,'happo:' ..happo.count)
]]
end


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
		\cs(175, 125, 225)${KB_Melee_M}\cs(0, 150, 175)Melee Mode:\cr     ${player_current_melee}
		\cs(175, 125, 225)${KB_WS_M}\cs(0, 150, 175)WS Mode:\cr            ${player_current_ws}
		\cs(175, 125, 225)${KB_PDT_M}\cs(0, 150, 175)Hybrid Mode:\cr    ${player_current_Hybrid}
		\cs(175, 125, 225)${KB_RA_M}\cs(0, 150, 175)Ranged Mode:\cr  ${player_current_Ranged}
		\cs(175, 125, 225)${KB_CAST_M}\cs(0, 150, 175)Casting Mode:\cr  ${player_current_casting}
		\cs(175, 125, 225)${KB_Haste_M}\cs(0, 150, 175)Haste Mode:\cr       ${player_current_Haste}
		\cs(175, 125, 225)${KB_March_M}\cs(0, 150, 175)March Mode:\cr     ${player_current_March}
		\cs(204, 0, 0)Item    \cs(255, 115, 0)                            Count: \cr 	
		\cs(255, 150, 0)   Shihei:\cr \cs${shihei_color}                            ${Shihei_Left}
		\cs(255, 150, 0)   Inoshinofuda:\cr \cs${ino_color}            ${inoshi_Left}
		\cs(255, 150, 0)   Shikanofuda:\cr \cs${shika_color}              ${shika_left}
		\cs(255, 150, 0)   Chonofuda:\cr \cs${chono_color}                  ${chono_left}
		\cs(255, 150, 0)   Happo Shuriken:\cr \cs${happo_color}      ${happo_left}
		\cs(204, 0, 0)Job Info\cs(255, 115, 0)                           Detail: \cr 	
		\cs(255, 150, 200)   Stance:\cr \cs${stance_color}                            ${stance_value}
		\cs(255, 150, 200)   Shadows:\cr \cs${shadow_color}                       ${shadow_value}
		\cs(255, 150, 200)   Migiwari:\cr \cs${migawari_color}                        ${migawari_value}
]]



-- init style
hub_mode = hub_mode_std
hub_options = hub_options_std
hub_job = hub_job_std
hub_battle = hub_battle_std

KB = {}
KB['KB_C_MH'] = 	'   (NUM /)         '
KB['KB_C_OH'] = 	'   (NUM *)          '
KB['KB_Melee_M'] = '   (NUM 7)         '
KB['KB_WS_M'] = '   (NUM 5)        '
KB['KB_PDT_M'] = 	'   (NUM 8)        '
KB['KB_RA_M'] = 	'   (NUM 9)        '
KB['KB_CAST_M'] = 	'   (NUM 4)        '
KB['KB_Haste_M'] = '   (NUM -)         '
KB['KB_March_M'] = '   (NUM +)        '



function validateTextInformation()
	
	local stancecolor 	={}
	local shiheicolor	={}
	local inocolor		={}
	local chonocolor	={}
	local shikacolor	={}
	local happocolor	={}
	local shadowcolor	={}
	local migawaricolor ={}

	
	if stance == "No Stance"	then
		stancecolor = color.grey
	elseif stance == "Innin" then
		stancecolor = color.ltblue
	elseif stance == "Yonin"	then
		stancecolor = color.ltred
	else
		stancecolor=color.white
	end

	if shihei.count ~= nil then
		if shihei.count == 0 then
			shiheicolor = color.red
		elseif shihei.count <= 20 then
			shiheicolor = color.ltred
		elseif shihei.count <= 50 then
			shiheicolor = color.ltyellow
		else
			shiheicolor = color.white
		end
	else
		shiheicolor = color.white
	end
	if inoshi.count ~= nil then		
		if inoshi.count == 0 then
			inocolor = color.red
		elseif inoshi.count <= 20 then
			inocolor = color.ltred
		elseif inoshi.count <= 50 then
			inocolor = color.ltyellow
		else
			inocolor = color.white
		end
	else
		inocolor = color.white
	end
	if  shika.count ~= nil then
		if shika.count == 0 then
			shikacolor = color.red
		elseif shika.count <= 20 then
			shikacolor = color.ltred
		elseif shika.count <= 50 then
			shikacolor = color.ltyellow
		else
			shikacolor = color.white
		end
	else
		shikacolor = color.white
	end
	
	if chono.count ~= nil then
		if chono.count == 0 then
			chonocolor = color.red
		elseif chono.count <= 20 then
			chonocolor = color.ltred
		elseif chono.count <= 50 then
			chonocolor = color.ltyellow
		else
			chonocolor = color.white
		end
	else
		chonocolor = color.white
	end
	
	if happo.count ~=nil then
		if happo.count == 0 then
			happocolor = color.red
		elseif happo.count <= 20 then
			happocolor = color.ltred
		elseif happo.count <= 50 then
			happocolor = color.ltyellow
		else
			happocolor = color.white
		end
	else
		happocolor = color.white
	end

	if shadows =='1 Shadow' then
		shadowcolor=color.ltred
	elseif shadows=='2 Shadows' then
		shadowcolor=color.ltyellow
	elseif shadows=='3 Shadows' then
		shadowcolor=color.ltgreen
	elseif shadows=='4 Shadows' then
		shadowcolor=color.ltblue
	elseif shadows=='No Shadows' then
		shadowcolor=color.red
	else 
		shadowcolor=color.white
	end
	
	if migawari=='Active' then
		migawaricolor=color.ltblue
	elseif migawari=='Inactive' then
		migawaricolor=color.red
	else
		migawaricolor=color.white
	end


    --Mode Information
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
    main_text_hub.player_current_mainweapon = state.mainWeapon.current
    main_text_hub.player_current_subweapon = state.subWeapon.current
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Ranged = state.RangedMode.current	
    main_text_hub.player_current_casting = state.CastingMode.current
	main_text_hub.player_current_Haste = state.HasteMode.value
	main_text_hub.player_current_March = state.MarchMode.current    
	
	--inventory counts
	main_text_hub.Shihei_Left=shihei.count
	main_text_hub.inoshi_Left=inoshi.count
	main_text_hub.chono_left=chono.count
	main_text_hub.shika_left=shika.count
	main_text_hub.happo_left=happo.count
	
	--job details
	main_text_hub.stance_value=stance
	main_text_hub.shadow_value=shadows
	main_text_hub.migawari_value=migawari
	
	main_text_hub.stance_color=stancecolor
	main_text_hub.shihei_color=shiheicolor
	main_text_hub.ino_color=inocolor
	main_text_hub.chono_color=chonocolor
	main_text_hub.shika_color=shikacolor
	main_text_hub.happo_color=happocolor
	main_text_hub.shadow_color=shadowcolor
	main_text_hub.migawari_color=migawaricolor

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
