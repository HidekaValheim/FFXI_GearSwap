-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
include('organizer-lib')
include('Modes.lua')
--For Some reason enabling these lines crashes windower
--include('packets.lua')
--packets = require('packets')


organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Reraiser","Hi-Reraiser"},
    NinjaTools={"Shihei","Inoshishinofuda","Shikanofuda","Chonofuda", "Toolbag (Shihe)", "Toolbag (Ino)", "Toolbag (Shika)", "Toolbag (Cho)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
	Bullets={"Happo Shuriken", "Hap. Sh. Pouch"},
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

	gear.RegularAmmo = 'Seki Shuriken'
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
	state.OffenseMode:options ('Normal', 'ACC')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'MAXBUFF')
	state.HybridMode:options('Normal', 'Hybrid', 'TANK', 'CRIT','Subtle')
	state.CastingMode:options('Normal','Burst')
	state.IdleMode:options('Normal','Recover','DT','Buff')
	mainweapon={}
	subWeapon={}
	state.mainWeapon = M('Heishi Shorinken','Gokotai','Tauret','Naegling','Hachimonji','Karambit')
	state.subWeapon = M('Yagyu Darkblade','Kunimitsu','Tsuru','Uzura +2',"Gleti's Knife",'Bloodrain Strap','')	
	
	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds
	
	send_command('bind numpad0 input /ja provoke <t>')
	send_command('bind numpad1 gs c KatanaMode')
	send_command('bind numpad2 gs c GktMode')
	send_command('bind numpad3 gs c SwordMode')
	send_command('bind numpad4 gs c cycle CastingMode')
	send_command('bind numpad5 gs c cycle WeaponskillMode')
	send_command('bind numpad6 gs c cycle IdleMode')
	send_command('bind numpad7 gs c cycle OffenseMode')
	send_command('bind numpad9 gs c cycle RangedMode')

	send_command('bind numpad8 gs c cycle HybridMode')

	send_command('bind numpad/ gs c cycle mainWeapon')
	send_command('bind numpad* gs c cycle subWeapon')
	send_command('bind numpad- gs c cycle HasteMode')
	send_command('bind numpad+ gs c cycle MarchMode')

	send_command('unbind ^r')

	
	
	select_movement_feet()
	select_default_macro_book()
	use_UI = true
	hud_x_pos = 1515    --important to update these if you have a smaller screen
	hud_y_pos = 300     --important to update these if you have a smaller screen
	hud_draggable = true
	hud_font_size = 9
	hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
	hud_font = 'Impact'
	setupTextWindow()
	
	stance = "No Stance"
	stance_status()
	send_command('wait 10;input /lockstyleset 8')	
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
	Andartia = {}
	Andartia.DA 	= {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	Andartia.STP 	= {name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	Andartia.AGIWS	= {name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Weapon skill damage +10%',}}
	Andartia.DEXWS 	= {name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Andartia.STRWS 	= {name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	Andartia.MAB 	= {name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}
	Andartia.FC 	= {name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}}

	--------------------------------------
	-- Job Abilties
	--------------------------------------
	sets.precast.JA['Mijin Gakure'] = {legs="Mochi. Hakama +3"}
	sets.precast.JA['Futae'] = {hands="Hattori Tekko +1"}
	sets.precast.JA['Sange'] = {ammo="Happo Shuriken",body="Mochi. Chainmail +3"}
	
	sets.precast.JA['Provoke'] = --{waist="Chaac Belt", ammo="Per. Lucky egg", head = "Wh. Rarab Cap +1", feet="Volte Boots"}
	
	{
		ammo="Sapience Orb",
		head="Nyame Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Zoar Subligar +1",
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Trance Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Supershear Ring", --+5
		right_ring="Eihwaz Ring", --+5
		back="Reiki Cloak"
	}
	sets.midcast.Flash = set_combine(sets.precast.JA['Provoke'], {})

	-- Waltz (chr and vit)
	sets.precast.Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin can drop acc
	sets.precast.Step = {}	
	sets.precast.Flourish1 = set_combine(sets.precast.Step, {waist="Chaac Belt"})
	sets.midcast["Apururu (UC)"] = {}

	--------------------------------------
	-- Utility Sets for rules below
	--------------------------------------
	sets.TreasureHunter = {waist="Chaac Belt", ammo="Per. Lucky egg", head = "Wh. Rarab Cap +1", feet="Volte Boots"}
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
	sets.precast.RA = {ammo="Happo Shuriken",waist="Chaac Belt", ammo="Per. Lucky egg", head = "Wh. Rarab Cap +1", feet="Volte Boots"}
	
	sets.midcast.RA = {
		ammo="Happo Shuriken",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Crep. Earring",
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
		ammo="Sapience Orb", 																							--+2
		head={ name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+5','MND+8','"Mag.Atk.Bns."+14',}}, 			--+12
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},					--+10
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},	--+7/8
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+5','INT+1','"Mag.Atk.Bns."+8',}},						--+5/6
		feet={ name="Herculean Boots", augments={'Mag. Acc.+23','"Fast Cast"+6','MND+1',}},								--+6
		neck="Orunmila's Torque",																						--+5
		waist="Svelt. Gouriz +1",																						--+0
		left_ear="Enchntr. Earring +1",																					--+2			
		right_ear="Loquac. Earring",																					--+2
		left_ring="Rahab Ring",																							--+2
		right_ring="Kishar Ring",																						--+4
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}}, -- +10
	}
	
	sets.precast.FC.ElementalNinjutsuSan = set_combine(sets.precast.FC, {})
	
	--[Alternative Utsusemi fast casting Sets]

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Mochi. Chainmail +3", neck="Magoraga Beads", left_ring="Weatherspoon Ring",})
	
	-- Midcasts
	-- FastRecast (A set to end in when no other specific set is built to reduce recast time)
	sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+5','MND+8','"Mag.Atk.Bns."+14',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+5','INT+1','"Mag.Atk.Bns."+8',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+23','"Fast Cast"+6','MND+1',}},
		neck="Orunmila's Torque",
		waist="Svelt. Gouriz +1",
		left_ear="Enchntr. Earring +1",	
		right_ear="Loquac. Earring",
		left_ring="Weatherspoon Ring",
		right_ring="Kishar Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}},
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
		right_ear="Hattori Earring +1",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back= Andartia.MAB 
	}
	
	-- Any ninjutsu cast on self - Recast Time Focus - Effects items that dont scale with Ninjutsu Skill, but not utsusemi
	sets.midcast.SelfNinjutsu = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Svelt. Gouriz +1",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Hizamaru Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {feet="Hattori Kyahan +3"})
	--Migawari Scales with Skill. Migawari + Pieces Do nothing if you arent wearing them when you are hit
	sets.midcast.Migawari = set_combine(sets.midcast.SelfNinjutsu, {
		head="Hachiya Hatsu. +3",
		feet="Mochi. Kyahan +3",
		neck="Incanter's Torque",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},		
		back=Andartia.FC
	})

	-- Nuking Ninjutsu (skill & magic attack) - Scales Ton line spells
	sets.midcast.ElementalNinjutsu = {
		ammo="Ghastly Tathlum +1",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Shiva Ring +1",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}

	--Ni spells benefit from Higher INT and Magic damage
	sets.midcast.ElementalNinjutsu.Burst 		= set_combine(sets.midcast.ElementalNinjutsu, 			{    
		--body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		--neck="Warder's Charm +1",
		left_ring="Mujin Band",
		})
	--San Spells Benefit from Higher MAB
	sets.midcast.ElementalNinjutsuSan 			= set_combine(sets.midcast.ElementalNinjutsu, 			{right_ring="Metamorph Ring +1",})
	sets.midcast.ElementalNinjutsuSan.Burst 	= set_combine(sets.midcast.ElementalNinjutsuSan, 		{
		--body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		left_ring="Mujin Band",
		right_ring="Metamorph Ring +1",	
		})
		
	-- Effusions
	sets.precast.Effusion = {}
	sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
	sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

	----------------------------------
	-- Idle Sets
	----------------------------------
	sets.idle = {}
	sets.idle.Normal = {	
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Mpaca's Doublet",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Svelt. Gouriz +1",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Hizamaru Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    sets.idle.Recover = {
		ammo="Staunch Tathlum +1",
		head="Rao Kabuto +1",
		body="Hiza. Haramaki +2",
		hands="Rao Kote +1",
		legs="Malignance Tights",
		feet="Rao Sune-Ate +1",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    sets.idle.DT = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Shadow Ring",
		back="Moonbeam Cape",	
	}
    sets.idle.Buff = {
		ammo="Yamarang",
		head={ name="Taeon Chapeau", augments={'Attack+10','"Triple Atk."+2','Phalanx +3',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'Phalanx +2',}},
		legs={ name="Taeon Tights", augments={'Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Phalanx +2',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring="Sheltered Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Evasion+9','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}	
	----------------------------------
	-- full Defense sets for react and other things
	----------------------------------
	-- 51% PDT + Nullification(Mantle)
	sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Warden's Ring",
		back=Andartia.DA
	}

	-- 25% MDT + Absorb + Nullification + MEva
	sets.defense.PEVA = {
		ammo="Staunch Tathlum +1",
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet="Mpaca's Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Warden's Ring",
		back=Andartia.DA	
	}
		
	sets.MEva = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hachi. Kyahan +1",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Warden's Ring",
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
	-- All DW DA STP Capes should have 10 PDT. 21 MDT/DT is needed to cap, 40 PDT is needed to cap with cape. use a +5 DT Cape with D Ring instead of gelatinous, and malignance body if worried about no Shell V
	sets.TANK={
		head = "Malignance Chapeau", 	--6  DT	|16	PDT - 6	 MDT
		body = "Mpaca's Doublet", 		--10 PDT|26 PDT - 6  MDT
		hands= "Malignance Gloves",		--5  DT	|31 PDT - 11 MDT
		legs = "Malignance Tights",		--7  DT	|38 PDT	- 18 MDT
		feet = "Malignance Boots",		--4	 DT	|42 PDT	- 22 MDT
		right_ring="Gelatinous Ring +1"	--7	 PDT|49 PDT - 21 MDT
	}
	sets.Hybrid={
		head = "Malignance Chapeau", 	--6  DT	|16	PDT - 6	 MDT
		body = "Mpaca's Doublet", 		--10 PDT|26 PDT - 6  MDT
		hands= "Mpaca's Gloves",		--8  PDT|34 PDT - 6 MDT
		legs = "Malignance Tights",		--7  DT	|38 PDT	- 13 MDT
		feet = "Malignance Boots",		--4	 DT	|42 PDT	- 17 MDT
	}
	sets.CRIT={
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Ken. Tekko +1",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		left_ring="Lehko's Ring",	
	}
	----------------------------------
	--Generic Accuracy Sets
	----------------------------------
	--[[ACC Guidelines Before Food(AfterFood) - Content
		Normal: 1000 (1100) - casual/solo
		Low:	1100 (1200) - Omen bosses, Geas Fete T3
		Mid:	1200 (1300) - VD Ambuscade (normal Month), Wave 3 Dyna D
		High:	1300 (1400) - Helms, VD Ambuscade (Hard month)
	Buff tiers assume No external buffs. Lower the tier if recieving madrigals or hunters.]]
	
	-- NIN is not hurting for ACC Gear right now. Chirich swaps put most sets in the 1200 range natively. 
	sets.ACC ={
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},	
	}
	sets.Subtle = {
	
	}

	----------------------------------
	--DW SETS
	----------------------------------		
	--[[Use DW Sets to cap haste. if you are missing pieces from these sets, or have downgraded pieces, you can change out the slot with a new piece of gear. 
		just be sure to balance the T12,T22,T32,T39 sets to match as close as possible to the required DW]]
	sets.dw={}
		sets.dw.head = {head 	 = "Ryuo Somen +1"}		--+9
		sets.dw.body = {body 	 = "Mochi. Chainmail +3"} --+9
		sets.dw.legs = {legs 	 = "Mochi. Hakama +3"}	--+10
		sets.dw.feet = {feet 	 = "Hiza. Sune-Ate +2"}	--+8
		sets.dw.ear1 = {left_ear = "Suppanomimi"}		--+5
		sets.dw.ear2 = {right_ear= "Eabani Earring"}	--+4
		sets.dw.waist= {waist 	 = "Reiki Yotai"}		--+7	
		sets.dw.back = {back	 = { name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} -- +10DW
		sets.dw.t12	 = set_combine(sets.dw.waist,sets.dw.ear1,{}) --Need 12 total DW
		sets.dw.t22  = set_combine(sets.dw.waist,sets.dw.ear1,sets.dw.back, {})--Need 22 Total DW
		sets.dw.t32	 = set_combine(sets.dw.waist,sets.dw.ear1,sets.dw.back, sets.dw.body, {})--32 DW To cap
		sets.dw.t35	 = set_combine(sets.dw.waist,sets.dw.ear1,sets.dw.back, sets.dw.body, {})--Special 0 haste Hybrid Join, gets 35 DW, 50 dt
		sets.dw.t39A = set_combine(sets.dw.waist,sets.dw.ear1,sets.dw.ear2, sets.dw.back, sets.dw.body, {})--Special 0 haste Hybrid Join, gets 35 DW, 50 dt
		sets.dw.t39  = set_combine(sets.dw.waist,sets.dw.ear1,sets.dw.ear2, sets.dw.back, sets.dw.head, sets.dw.body, {})--39 DW To cap
	----------------------------------
	-- No Haste - Requires 39 total DW to cap. use sets.dw.t39 as primary set join
	----------------------------------	
	sets.engaged = set_combine(sets.dw.t39, {
		neck		= "Ninja Nodowa +2", 
		right_ear	= "Telos Earring",
		left_ring	= "Gere Ring",
		right_ring	= "Epona's Ring",
		hands		= { name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs		= "Samnuha Tights",
		feet		= "Malignance Boots",
	})
	----------------------------------
	-- No Haste SetVariants
	----------------------------------
	--Accuracy Variants
	sets.engaged.ACC 		= set_combine(sets.engaged, sets.ACC, sets.dw.t39, {})
	sets.engaged.Hybrid 	= set_combine(sets.engaged,	sets.hybrid, sets.dw.t35, {left_ring="Defending Ring"})
	sets.engaged.ACC.Hybrid	= set_combine(sets.engaged,	sets.ACC, sets.hybrid, sets.dw.t35, {left_ring="Defending Ring"})
	sets.engaged.TANK 		= set_combine(sets.engaged,	sets.TANK, sets.dw.t39A, {left_ring="Defending Ring"})
	sets.engaged.ACC.TANK	= set_combine(sets.engaged,	sets.ACC, sets.TANK, sets.dw.t39A, {left_ring="Defending Ring"})
	sets.engaged.CRIT 		= set_combine(sets.engaged,	sets.CRIT, sets.dw.t39A, {})
	sets.engaged.ACC.CRIT	= set_combine(sets.engaged,	sets.ACC, sets.CRIT, sets.dw.t39A, {})
	sets.engaged.Subtle		= set_combine(sets.engaged,	sets.Subtle, sets.dw.t39A, {})
	sets.engaged.ACC.Subtle	= set_combine(sets.engaged,	sets.ACC, sets.Subtle, sets.dw.t39A, {})	
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
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
	}
	sets.engaged.H2H = {
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={name="Mache Earring +1",bag="wardrobe2"},
		right_ear={name="Mache Earring +1",bag="wardrobe7"},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
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
		head="Malignance Chapeau",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Samnuha Tights",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
	}
	

	sets.engaged.ACC.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.ACC	, {})
	sets.engaged.Hybrid.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.hybrid, {})
	sets.engaged.ACC.Hybrid.MaxHaste= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.hybrid, {})
	sets.engaged.TANK.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.TANK, {})
	sets.engaged.ACC.TANK.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.TANK, {})
 	sets.engaged.CRIT.MaxHaste 		= set_combine(sets.engaged.MaxHaste, sets.CRIT, {})
	sets.engaged.ACC.CRIT.MaxHaste	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.CRIT, {})
 	sets.engaged.Subtle.MaxHaste 	= set_combine(sets.engaged.MaxHaste, sets.Subtle, {})
	sets.engaged.ACC.Subtle.MaxHaste= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle, {})	
	----------------------------------
    -- 35% Haste (~10-12%DW Needed)
	----------------------------------
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_35 			= set_combine(sets.engaged.MaxHaste, sets.dw.t12, {})
	sets.engaged.ACC.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.dw.t12, {})
	sets.engaged.Hybrid.Haste_35 	= set_combine(sets.engaged.MaxHaste, sets.dw.t12, sets.hybrid, {})
	sets.engaged.ACC.Hybrid.Haste_35= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.hybrid,sets.dw.t12, {})
	sets.engaged.TANK.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.dw.t12, sets.TANK	 , {})
	sets.engaged.ACC.TANK.Haste_35	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.TANK	 ,sets.dw.t12, {})
	sets.engaged.CRIT.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.dw.t12, sets.CRIT	 , {})
	sets.engaged.ACC.CRIT.Haste_35	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.CRIT	 ,sets.dw.t12, {})
	sets.engaged.Subtle.Haste_35 		= set_combine(sets.engaged.MaxHaste, sets.dw.t12, sets.Subtle	 , {})
	sets.engaged.ACC.Subtle.Haste_35	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle	 ,sets.dw.t12, {})
	
	----------------------------------
    -- 30% Haste (~21-22%DW Needed)
	----------------------------------
	-- DW Total in Gear: 21 DW / 21 DW Needed to Cap Delay Reduction
	-- DW DT Sets CANT cap DW in this haste tier Without sacrificing DT. If you want to override a piece of DT Gear, simply include it. (Use DW Head, Ear2, and Waist if dropping malignance for DT)
	-- Use DW Cape 
	sets.engaged.Haste_30			= set_combine(sets.engaged.MaxHaste, sets.dw.t22, {})
	sets.engaged.ACC.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.dw.t22, {})
	sets.engaged.Hybrid.Haste_30 	= set_combine(sets.engaged.MaxHaste, sets.hybrid, sets.dw.t22, {})
	sets.engaged.ACC.Hybrid.Haste_30= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.hybrid, sets.dw.t22, {})
	sets.engaged.TANK.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.TANK	, sets.dw.t22, {})
	sets.engaged.ACC.TANK.Haste_30	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.TANK, sets.dw.t22, {})
	sets.engaged.CRIT.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.CRIT	, sets.dw.t22, {})
	sets.engaged.ACC.CRIT.Haste_30	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.CRIT, sets.dw.t22, {})
	sets.engaged.Subtle.Haste_30 		= set_combine(sets.engaged.MaxHaste, sets.Subtle	, sets.dw.t22, {})
	sets.engaged.ACC.Subtle.Haste_30	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle, sets.dw.t22, {})	
	----------------------------------
	-- 15% Haste (~32%DW Needed)
	----------------------------------
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.Haste_15 			= set_combine(sets.engaged.MaxHaste, sets.dw.t32, {})
	sets.engaged.ACC.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.dw.t32, {})
	sets.engaged.Hybrid.Haste_15 	= set_combine(sets.engaged.MaxHaste, sets.hybrid, sets.dw.t32, {})
	sets.engaged.ACC.Hybrid.Haste_15= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.hybrid, sets.dw.t32,  {})
	sets.engaged.TANK.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.TANK	, sets.dw.t32, {})
	sets.engaged.ACC.TANK.Haste_15	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.TANK	 , sets.dw.t32,  {})
	sets.engaged.CRIT.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.CRIT	, sets.dw.t32, {})
	sets.engaged.ACC.CRIT.Haste_15	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.CRIT	 , sets.dw.t32,  {})
	sets.engaged.Subtle.Haste_15 		= set_combine(sets.engaged.MaxHaste, sets.Subtle	, sets.dw.t32, {})
	sets.engaged.ACC.Subtle.Haste_15	= set_combine(sets.engaged.MaxHaste, sets.ACC	, sets.Subtle	 , sets.dw.t32,  {})	
	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	sets.precast.WS = {
		ammo = "Coiste Bodhar",
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Hattori Kyahan +3",
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
		ammo="Yetshila +1",
		head="Hachiya Hatsu. +3",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Ishvara Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Lehko's Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}},
	})
	sets.precast.WS['Blade: Hi'].MAXBUFF 	= {
		ammo="Yetshila +1",
		head="Hachiya Hatsu. +3",
		body="Nyame Mail",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Ishvara Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Lehko's Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}},
	}	
	sets.precast.WS['Blade: Ten'] 		={
		ammo="Seething Bomblet +1",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Ten'].MAXBUFF = set_combine(sets.precast.WS['Blade: Ten'], {
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		left_ring="Epaminondas's Ring",
	})
	sets.precast.WS['Blade: Jin'] 		= {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Lehko's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Jin'].MAXBUFF = set_combine(sets.precast.WS['Blade: Jin'],{})
	sets.precast.WS['Blade: Kamu'] 		= {
	-- NEEDS SRODA RING, Hattori Earring +1
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Brutal Earring",
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Kamu'].MAXBUFF 	= set_combine(sets.precast.WS['Blade: Kamu'], {})	
	sets.precast.WS['Blade: Metsu'] 	= set_combine(sets.precast.WS['Blade: Ten'], {})
	sets.precast.WS['Blade: Metsu'].MAXBUFF = set_combine(sets.precast.WS['Blade: Metsu'], {})
	sets.precast.WS['Blade: Shun'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Shun'].MAXBUFF ={
		ammo="Crepuscular Pebble",
		head="Ken. Jinpachi +1",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Ku'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Brutal Earring",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Blade: Ku'].MAXBUFF = set_combine(sets.precast.WS['Blade: Ku'], {
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
	})	
    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {
		ammo="Seething Bomblet +1",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Lugra Earring +1",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Gere Ring",
		right_ring="Epaminondas's Ring",
		back=Andartia.STRWS,
	})
	sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Blade: Ei'] = {
		ammo="Seething Bomblet +1",
		head="Pixie Hairpin +1",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
	sets.precast.WS['Blade: Yu'] = {
		ammo="Ghastly Tathlum +1",
		head="Mochi. Hatsuburi +3",
		neck="Sibyl Scarf",
		ear1="Moonshade Earring",
		ear2="Lugra Earring +1",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		ring1="Epaminondas's Ring",
		ring2="Shiva Ring +1",
		waist="Orpheus's Sash",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		back=Andartia.MAB--DEXWS(alt needs testing)
	}
	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Blade: Yu'],{})
	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Lehko's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.precast.WS['Evisceration'].MAXBUFF = {
		neck="Ninja Nodowa +2",
	}
	-- USE MACC FOR AGEHA TO STICK DEBUFF. NOT USED FOR DAMAGE EVER.
	sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS,{
		ammo="Yamarang",
		head="Mpaca's Cap",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Hattori Kyahan +3",
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
	sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS['Blade: Chi'],{})
	sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS['Blade: Chi'],{})
	sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS['Blade: Chi'],{})
	sets.precast.WS['Tachi: Jinpu'].MAXBUFF = set_combine(sets.precast.WS['Blade: Chi'].MAXBUFF,{})
	sets.precast.WS['Tachi: Koki'].MAXBUFF = set_combine(sets.precast.WS['Blade: Chi'].MAXBUFF,{})
	sets.precast.WS['Tachi: Kagero'].MAXBUFF = set_combine(sets.precast.WS['Blade: Chi'].MAXBUFF,{})
	sets.precast.WS['Tachi: Goten'].MAXBUFF = set_combine(sets.precast.WS['Blade: Chi'].MAXBUFF,{})	
	
 	sets.precast.WS['Asuran Fists'] = {
		ammo="Crepuscular Pebble",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Mochi. Chainmail +3", augments={'Enhances "Sange" effect',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
 	sets.precast.WS['Raging Fists'] = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
 	sets.precast.WS['Savage Blade'] = {
		ammo = "Seething Bomblet +1",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Lugra Earring +1",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=Andartia.DEXWS
	}	
 	sets.precast.WS['Savage Blade'].MAXBUFF = set_combine(sets.precast.WS['Savage Blade'],{
		neck="Ninja Nodowa +2",
		head="Hachiya Hatsu. +3",
		right_ring="Epaminondas's Ring",
	})
 	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Blade: Ei'], {})
	sets.WSDayBonus = {head="Gavialis Helm"}
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
	-- if spell.name == 'Spectral Jig' and buffactive.sneak then
		-- send_command('cancel 71')
	-- end
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

    if spell.type == 'WeaponSkill' then
        if spell.english == 'Blade: Shun' then
            if world.day_element == 'Fire' or world.day_element == 'Thunder' or world.day_element == 'Wind' or world.day_element == 'Light' then
                equip(sets.WSDayBonus)
           end
		elseif spell.english == 'Blade: Ku' then
            if world.day_element == 'Earth' or world.day_element == 'Light' or world.day_element == 'Dark' then
                equip(sets.WSDayBonus)
           end
		elseif spell.english == 'Blade: Jin' then
            if world.day_element == 'Thunder' or world.day_element == 'Wind' then
                equip(sets.WSDayBonus)
           end
		elseif spell.english == 'Exenterator' then
            if world.day_element == 'Earth' or world.day_element == 'Thunder' or world.day_element == 'Wind' then
                equip(sets.WSDayBonus)
           end
		elseif spell.english == 'Evisceration' then
            if world.day_element == 'Earth' or world.day_element == 'Light' or world.day_element == 'Dark' then
                equip(sets.WSDayBonus)
           end
		end
    end


end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

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

	-- for _,v in pairs(watch_slots) do
		-- if lockables:contains(player.equipment[v]) then
			-- disable(v)
			-- if has_charges(player.equipment[v]) and (not is_enchant_ready(player.equipment[v])) then
				-- enable(v)
			-- end
		-- else
			-- enable(v)
		-- end
	-- end
ninbuff_status()
stance_status()
tool_counter()
validateTextInformation()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HybridMode.value == 'DT' then
		if state.Buff.Migawari then
			idleSet = set_combine(idleSet, sets.buff.Migawari)
		else 
			idleSet = set_combine(idleSet, sets.idle.PDT)
		end
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
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'GktMode' then
		state.mainWeapon:set('Hachimonji')
		state.subWeapon:set('Bloodrain strap')
		state.CombatWeapon:set('GKT')	
		select_weapons()
		setupTextWindow()
		update_combat_form()
	elseif cmdParams[1] == 'KatanaMode' then
		state.mainWeapon:set('Heishi Shorinken')
		state.subWeapon:set('Yagyu Darkblade')
		state.CombatWeapon:reset()
		select_weapons()
		setupTextWindow()
		update_combat_form()
	elseif cmdParams[1] == 'SwordMode' then
		state.mainWeapon:set('Naegling')
		state.subWeapon:set("Uzura +2")
		state.CombatWeapon:reset()
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
		\cs(175, 125, 225)${KB_Idle_M}\cs(0, 150, 175)Idle Mode:\cr         ${player_current_idle}
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
KB['KB_C_MH'] 	= '   (NUM /)         '
KB['KB_C_OH'] 	= '   (NUM *)          '
KB['KB_Idle_M'] = '   (NUM 6)         '
KB['KB_Melee_M']= '   (NUM 7)         '
KB['KB_WS_M'] 	= '   (NUM 5)        '
KB['KB_PDT_M'] 	= '   (NUM 8)        '
KB['KB_RA_M'] 	= '   (NUM 9)        '
KB['KB_CAST_M'] = '   (NUM 4)        '
KB['KB_Haste_M']= '   (NUM -)         '
KB['KB_March_M']= '   (NUM +)        '



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
    main_text_hub.player_current_idle =  state.IdleMode.current
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