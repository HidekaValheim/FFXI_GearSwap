

--Relyk

-- Load and initialize the include file.
include('Mirdain-Include')
include('organizer-lib')
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker')  
send_command('wait 31;input //gs equip sets.weapons') 

organizer_items = {
    Consumables={"Echo Drops","Holy Water", "Remedy"},
    NinjaTools={"Shihei"},
	Food={"Sublime Sushi", "Om. Sandwich", "Grape Daifuku"},
	Storage={"Storage Slip 16","Storage Slip 17","Storage Slip 18","Storage Slip 21","Storage Slip 23","Storage Slip 24",
			"Storage Slip 25","Storage Slip 26","Storage Slip 27","Storage Slip 28"},
	Bullets={"Eminent Bullet", "Eminent Bullet Pouch"},
	Other={"Trump Card", "Trump Card Case"}
}

--Set to ingame lockstyle and Macro Book/Set
LockStylePallet = "3"
MacroBook = "6"  -- Sub Job macro pallets can be defined in the sub_job_change_custom function below
MacroSet = "1"

-- Use "gs c food" to use the specified food item 

--Set default mode (TP,ACC,DT)
state.OffenseMode:set('DT')

--Enable JobMode for UI
UI_Name = 'DPS'

--Modes for specific to Corsair
state.JobMode = M{['description']='Corsair Damage Mode'}
state.JobMode:options('RNGPHYS','RNGMAG','SWORD', 'DAGGER') -- Can add Wildfire
state.JobMode:set('RNGMAG')

elemental_ws = S{'Aeolian Edge', 'Leaden Salute', 'Wildfire','Earth Shot','Ice Shot','Water Shot','Fire Shot','Wind Shot','Thunder Shot'}

-- load addons


-- Initialize Player
jobsetup (LockStylePallet,MacroBook,MacroSet)

-- Threshold for Ammunition Warning
Ammo_Warning_Limit = 99

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

if PortTowns:contains(world.area) then
	send_command('wait 3;input //gs org') 
	send_command('wait 6;input //po repack') 
else
	add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
end

function get_sets()

	--Set the weapon options.  This is set below in job customization section

	-- Weapon setup
	sets.Weapons = {}

	sets.Weapons['SWORD'] = {
		main="Naegling",
		sub="Demersal Degen +1",
		range="Anarchy +2",
	}
	sets.Weapons['DAGGER'] = {
		main="Tauret",
		sub="Blurred Knife +1",
		range="Anarchy +2",		
	}
	sets.Weapons['RNGPHYS'] = {
		main="Kustawi +1",
		sub="Nusku Shield",
		range="Molybdosis",
		--range={ name="Fomalhaut", augments={'Path: A',}},
	}

	sets.Weapons['RNGMAG'] = {
		main="Naegling",
		sub="Tauret",
		range="Molybdosis",
	}
	sets.Weapons.Shield = {
		sub={ name="Nusku Shield", priority=1},
	}

	-- Ammo Selection
	Ammo.Bullet.RA 		= "Eminent Bullet"		-- TP Ammo
	Ammo.Bullet.WS 		= "Eminent Bullet"		-- Physical Weaponskills
	Ammo.Bullet.MAB 	= "Eminent Bullet"		-- Magical Weaponskills
	Ammo.Bullet.MACC	= "Eminent Bullet"		-- Magic Accuracy
	Ammo.Bullet.QD 		= "Eminent Bullet"		-- Quick Draw
	Ammo.Bullet.MAG_WS 	= "Eminent Bullet"	-- Magic Weapon Skills

	-- Standard Idle set with -DT,Refresh,Regen with NO movement gear
	sets.Idle = {
		ammo = Ammo.Bullet.RA,
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets", 
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
    }

	sets.Movement = {
		legs="Carmine Cuisses +1",
	}

	-- Set to be used if you get 
	sets.Cursna_Recieved = {
	    neck="Nicander's Necklace",
		right_ring="Purity Ring",
		waist="Gishdubar Sash",
	}

	sets.OffenseMode = {}

	--Base TP set to build off when melee'n
	sets.OffenseMode.TP = {
		ammo = Ammo.Bullet.RA,
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+14','"Triple Atk."+4','Attack+15',}},
		neck="Asperity Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Mache Earring +1",
		right_ear="Telos Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
	}

	--This set is used when OffenseMode is DT and Enaged
	sets.OffenseMode.DT = set_combine(sets.OffenseMode.TP, {
		head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Malignance Gloves", --5/5
        legs="Malignance Tights", --7/7
        feet="Malignance Boots",
	})

	--The following sets augment the base TP set above for Dual Wielding
	sets.DualWield = {
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
	}

	--This set is used when OffenseMode is ACC and Enaged (Augments the TP base set)
	sets.OffenseMode.ACC = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},	
	}

	sets.Precast = {}
	-- 70 snapshot is Cap.  Need 60 due to 10 from gifts
	-- Snapshot / Rapidshot
	-- Rapid shot is like quick magic
	-- Snapshot is like Fast Cast
	-- Flurry is 15% Snapshot
	-- Flurry II 30% Snapshot

	--No flurry - 60 Snapshot needed
	sets.Precast.RA = {
		ammo=Ammo.Bullet.RA,
		head="Chass. Tricorne +1",
		body="Ikenga's Vest",
		hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    } -- Totals 66/24

	-- Flurry - 45 Snapshot Needed
	sets.Precast.RA.Flurry = set_combine(sets.Precast.RA, {
		body="Laksa. Frac +3",
	}) -- Totals 52/54

	-- Flurry II - 30 Snapshot Needed
	sets.Precast.RA.Flurry_II = set_combine( sets.Precast.RA.Flurry, { 
		head="Chass. Tricorne +1", 
		feet={ name="Herculean Boots", augments={'Mag. Acc.+5','"Rapid Shot"+6','Weapon skill damage +7%','Accuracy+7 Attack+7','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
    }) -- Totals 32/78

	sets.Precast.RA.ACC = {}

	-- Fast Cast for Magic
	sets.Precast.FastCast = {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Tempus Fugit",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back="Moonbeam Cape",
	}

	sets.Midcast = {}

	-- Ranged Attack Gear (Normal Midshot)
    sets.Midcast.RA = {
		ammo=Ammo.Bullet.RA,
		head="Ikenga's Hat",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Ikenga's Trousers",
		feet="Malignance Boots",
		neck="Marked Gorget",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
    }

	-- Ranged Attack Gear (Triple Shot Midshot)
	sets.Midcast.RA.TripleShot = set_combine(sets.Midcast.RA, {
        body="Chasseur's Frac +1",
        hands="Lanun Gants +3", -- Tripple shot becomes Quad shot
        legs="Oshosi Trousers", 
		feet="Oshosi Leggings",
    }) --27

	-- Quick Draw Gear Sets
	sets.QuickDraw = {}

	sets.QuickDraw.ACC = {
			ammo = Ammo.Bullet.QD,
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Magic burst dmg.+7%','"Mag.Atk.Bns."+15',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+14 "Mag.Atk.Bns."+14','Magic burst dmg.+4%','STR+1','Mag. Acc.+7','"Mag.Atk.Bns."+7',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
	}
	sets.QuickDraw.DMG = {
		ammo=Ammo.Bullet.MAB,
	    feet="Chass. Bottes +1",
	}
	sets.QuickDraw.STP = {
		ammo=Ammo.Bullet.QD,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Marked Gorget",
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
	}

	-- Quick Draw 
	sets.Midcast.QuickDraw = {}
	sets.Midcast.QuickDraw["Fire Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Ice Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Wind Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Earth Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Thunder Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Water Shot"] = sets.QuickDraw.STP
	sets.Midcast.QuickDraw["Light Shot"] = sets.QuickDraw.ACC
	sets.Midcast.QuickDraw["Dark Shot"] = sets.QuickDraw.ACC

	-- Job Abilities
	sets.JA = {}
	sets.JA["Wild Card"] = {
	    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
	}
	sets.JA["Phantom Roll"] = {}
	sets.JA["Random Deal"] = {
	    body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
	}
	sets.JA["Snake Eye"] = {
	    legs={ name="Lanun Trews", augments={'Enhances "Snake Eye" effect',}},
	}
	sets.JA["Fold"] = {}			-- Use gloves for bust
	sets.JA["Triple Shot"] = {}		-- Gear to be worn during Midshot
	sets.JA["Cutting Cards"] = {}
	sets.JA["Crooked Cards"] = {}

	--Base Set used for all rolls
	sets.PhantomRoll = set_combine(sets.Idle, {
		main="Lanun Knife",
		range="Compensator",
		head="Lanun Tricorne +1",
        hands="Chasseur's Gants +1",
        neck="Regal Necklace",
		left_ring="Luzaf's Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
		})

	sets.PhantomRoll['Fighter\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Monk\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Healer\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Wizard\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Warlocks\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Rogue\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Gallant\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Chaos Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Beast Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Choral Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Hunters\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Samurai Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Ninja Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Drachen Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Evoker\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Magus\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Corsair\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Puppet Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Dancer\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Scholar\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Bolter\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll["Caster's Roll"] = set_combine(sets.PhantomRoll, {}) -- {legs="Chas. Culottes +1"}
	sets.PhantomRoll["Tactician's Roll"] = set_combine(sets.PhantomRoll, {body="Chasseur's Frac +1"})
	sets.PhantomRoll["Allies' Roll"] = set_combine(sets.PhantomRoll, {hands="Chasseur's Gants +1"})
	sets.PhantomRoll['Miser\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Companion\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Avenger\'s Roll'] = sets.PhantomRoll
	sets.PhantomRoll['Naturalist\'s Roll'] = sets.PhantomRoll
    sets.PhantomRoll["Courser's Roll"] = set_combine(sets.PhantomRoll, {feet="Chass. Bottes +1"})
    sets.PhantomRoll["Blitzer's Roll"] = set_combine(sets.PhantomRoll, {head="Chass. Tricorne +1"})

	sets.WS = {
		ammo=Ammo.Bullet.WS,
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'Weapon skill damage +5%','CHR+3','Accuracy+7',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
	}

	sets.WS.MAB = {
		ammo=Ammo.Bullet.MAB,
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+7','Weapon skill damage +10%',}},
	}

	sets.WS["Wildfire"] = set_combine(sets.WS.MAB,{})
	sets.WS["Leaden Salute"] = set_combine(sets.WS.MAB, {ammo=Ammo.Bullet.MAG_WS, head="Pixie Hairpin +1"})
	sets.WS['Aeolian Edge'] = set_combine(sets.WS.MAB, {ammo=Ammo.Bullet.MAG_WS, right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},	waist="Eschan Stone"})

	sets.WS.MACC = set_combine(sets.WS.MAB, {
		ammo=Ammo.Bullet.MACC,
	})

	sets.WS.WSD = {
		ammo=Ammo.Bullet.WS,
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'Weapon skill damage +5%','CHR+3','Accuracy+7',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
	}

	sets.WS["Savage Blade"] = sets.WS.WSD

	sets.WS["Last Stand"] = {
		ammo=Ammo.Bullet.WS,
		head="Ikenga's Hat",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs="Ikenga's Trousers",
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
	}

	-- Accuracy set used in OffenseMode.ACC
	sets.WS.ACC = {}

	-- Uses Default WS set
	sets.WS["Evisceration"] = { 
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Meg. Cuirie +2",
		hands="Mummu Wrists +2",
		legs="Nyame Flanchard",
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
	}
	sets.WS["Detonator"] = {		
		ammo=Ammo.Bullet.WS,
		head="Ikenga's Hat",
		body="Ikenga's Vest",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'Weapon skill damage +5%','CHR+3','Accuracy+7',}},
		feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
	}
	sets.WS["Sniper Shot"] = {
		ammo=Ammo.Bullet.RA,
		head="Ikenga's Hat",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Ikenga's Trousers",
		feet="Malignance Boots",
		neck="Marked Gorget",
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Hajduk Ring",
		right_ring="Paqichikaji Ring",
		back={ name="Camulus's Mantle", augments={'HP+60','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
	}
	sets.WS["Slug Shot"] = {}
	sets.WS["Numbing Shot"] = {}
	sets.WS["Fast Blade"] = {}
	sets.WS["Burning Blade"] = {}
	sets.WS["Flat Blade"] = {}
	sets.WS["Shining Blade"] = {}
	sets.WS["Circle Blade"] = {}
	sets.WS["Spirits Within"] = {}
	sets.WS["Requiescat"] = {}

	--Custom sets for each jobsetup
	sets.Custom = {}

	sets.Charm = {
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets", 
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	}

	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		waist="Chaac Belt",
	}

end

-------------------------------------------------------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE UNLESS YOU NEED TO MAKE JOB SPECIFIC RULES
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's subjob changes.
function sub_job_change_custom(new, old)
	-- Typically used for Macro pallet changing
end

--Adjust custom precast actions
function pretarget_custom(spell,action)

end
-- Augment basic equipment sets
function precast_custom(spell)
	equipSet = {}

	if spell.english == 'Fold' then
		equipSet = set_combine(equipSet, {hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}}})
    end

	if spell.id == 123 or spell.type == 'CorsairRoll' then -- Double up and bypass weapon check
		return equipSet
	end

	if spell.english == 'Wild Fire' or spell.english == 'Leaden Salute' then
		equipSet = set_combine(equipSet, Elemental_check(equipSet, spell))
	end

	return Weapon_Check(equipSet)
end
-- Augment basic equipment sets
function midcast_custom(spell)
	equipSet = {}

	if spell.id == 123 or spell.type == 'CorsairRoll' then -- Double up and bypass weapon check
		return equipSet
	end

	return Weapon_Check(equipSet)
end
-- Augment basic equipment sets
function aftercast_custom(spell)
	equipSet = {}

	return Weapon_Check(equipSet)
end
--Function is called when the player gains or loses a buff
function buff_change_custom(name,gain)
	equipSet = {}

	return Weapon_Check(equipSet)
end
--This function is called when a update request the correct equipment set
function choose_set_custom()
	equipSet = {}

	return Weapon_Check(equipSet)
end
--Function is called when the player changes states
function status_change_custom(new,old)
	equipSet = {}

	return Weapon_Check(equipSet)
end

--Function is called when a self command is issued
function self_command_custom(command)

end

function user_file_unload()
	send_command('lua u autocor')
end

function check_buff_JA()
	buff = 'None'
	local ja_recasts = windower.ffxi.get_ability_recasts()
	if player.sub_job == 'WAR' then
		if not buffactive['Berserk'] and ja_recasts[1] == 0 then
			buff = "Berserk"
		elseif not buffactive['Aggressor'] and ja_recasts[4] == 0 then
			buff = "Aggressor"
		elseif not buffactive['Warcry'] and ja_recasts[2] == 0 then
			buff = "Warcry"
		end
	end
	return buff
end

function check_buff_SP()
	buff = 'None'
	--local sp_recasts = windower.ffxi.get_spell_recasts()
	return buff
end

function Weapon_Check(equipSet)
	equipSet = set_combine(equipSet,sets.Weapons[state.JobMode.value])
	if DualWield == false then
		equipSet = set_combine(equipSet,sets.Weapons.Shield)
	end
	return equipSet
end

function Elemental_check(equipSet, spell)
	-- This function swaps in the Orpheus or Hachirin as needed
	if elemental_ws:contains(spell.name) then
		-- Matching double weather (w/o day conflict).
		if spell.element == world.weather_element and world.weather_intensity == 2 then
			equipSet = set_combine(equipSet, {waist="Hachirin-no-Obi",})
			windower.add_to_chat(8,'Weather is Double ['.. world.weather_element .. '] - using Hachirin-no-Obi')
		-- Matching day and weather.
		elseif spell.element == world.day_element and spell.element == world.weather_element then
			equipSet = set_combine(equipSet, {waist="Hachirin-no-Obi",})
			windower.add_to_chat(8,'[' ..world.day_element.. '] day and weather is ['.. world.weather_element .. '] - using Hachirin-no-Obi')
			-- Target distance less than 6 yalms
		elseif spell.target.distance < (6 + spell.target.model_size) then
			equipSet = set_combine(equipSet, {waist="Orpheus's Sash",})
			windower.add_to_chat(8,'Distance is ['.. round(spell.target.distance,2) .. '] using Orpheus Sash')
		-- Match day or weather.
		elseif spell.element == world.day_element or spell.element == world.weather_element then
			windower.add_to_chat(8,'[' ..world.day_element.. '] day and weather is ['.. world.weather_element .. '] - using Hachirin-no-Obi')
			equipSet = set_combine(equipSet, {waist="Hachirin-no-Obi",})
		end
	end
	return equipSet
end