-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
	windower.send_command('lua u NyzulHelper')
	windower.send_command('lua u Omen')
	windower.send_command('lua u Plugin_Manager')
	windower.send_command('lua u PointWatch')
	windower.send_command('lua u Pouches')
	windower.send_command('lua u RollTracker')
	windower.send_command('lua u THTracker')
	windower.send_command('lua u Treasury')
	windower.send_command('lua u xivbar')
	windower.send_command('lua u Equipviewer')
	windower.send_command('lua u giltracker')
	windower.send_command('lua u infobar')
	windower.send_command('lua u invtracker')
	windower.send_command('lua u Distance')
	windower.send_command('lua u DistancePlus')
	windower.send_command('lua u EnemyBar')
	windower.send_command('lua u clock')
	windower.send_command('lua u debuffed')
	windower.send_command('lua u capetrader')
	windower.send_command('lua u checkparam')
	windower.send_command('lua u azuresets')
	windower.send_command('lua u battlemod')
	windower.send_command('lua u autora')
	windower.send_command('lua u organizer')
	windower.send_command('lua u tparty')
	windower.send_command('lua u Parse')
	windower.send_command('unload FFXIDB')
	windower.send_command('unload infobar')	
	windower.send_command('unload timers')	
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
	send_command('wait 2;input /lockstyleset 25')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    indi_timer = ''
    indi_duration = 180
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
    state.CapacityMode = M(false, 'Capacity Point Mantle')
	state.Moving = M(false, "moving")
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.Buff.Poison = buffactive['Poison'] or false

    state.OffenseMode:options('None', 'Melee', 'DW')
    state.CastingMode:options('Normal', 'MagicBurst')
    state.IdleMode:options('Normal', 'PDT', 'PetDT')

    gear.default.weaponskill_waist = "Windbuffet Belt +1"

    geo_sub_weapons = S{"Nehushtan", "Bolelabunga"}

    select_default_macro_book()
    send_command('bind != gs c toggle CapacityMode')
end

function file_unload()
    send_command('unbind !=')
end







-- Define sets and vars used by this job file.

function init_gear_sets()

    lowTierNukes = S{
	'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
    'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
    'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
    'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II',
	'Stonera', 'Watera', 'Aera', 'Fira', 'Blizzara', 'Thundara',		
	'Stonera II', 'Watera II', 'Aera II', 'Fira II', 'Blizzara II', 'Thundara II',
	'Stonera III', 'Watera III', 'Aera III', 'Fira III', 'Blizzara III', 'Thundara III',
	}
	
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    
	sets.precast.JA.Bolster = {
	body="Bagua Tunic +3"
	}
    
	sets.precast.JA['Life Cycle'] = {
	body="Geomancy Tunic +3", 
	back="Nantosuelta's Cape"
	}
    
	sets.precast.JA['Full Circle'] = {
	head="Azimuth Hood +1", 
	hands="Bagua Mitaines +3"
	}
    
	sets.precast.JA['Radial Arcana'] = {
	feet="Bagua Sandals +3"
	}
	
    sets.CapacityMantle  = { 
	back="Mecistopins Mantle" 
	}

    sets.precast.JA['Concentric Pulse'] = {
	main="Idris",	
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands={ name="Bagua Mitaines +3", augments={'Enhances "Curative Recantation" effect',}},
    legs={ name="Bagua Pants +3", augments={'Enhances "Mending Halation" effect',}},
    feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
    neck="Saevus Pendant +1",
    waist="Refoccilation Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}}	
	}
	
    -- Fast cast sets for spells

    sets.precast.FC = {
    main="Sucellus",
    sub="Chanter's Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'"Fast Cast"+6','MND+9','Mag. Acc.+11','"Mag.Atk.Bns."+4',}},
    body="Zendik Robe",
    hands="Shrieker's Cuffs",
    legs="Geomancy Pants +3",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Fast Cast"+6','MND+6','"Mag.Atk.Bns."+12',}},
    neck="Orunmila's Torque",
    waist="Embla Sash",
    left_ear="Magnetic Earring",
    right_ear="Calamitous Earring",
    left_ring="Kishar Ring",
    right_ring="Weather. Ring",
    back={ name="Nantosuelta's Cape", augments={'Haste+10',}}
    }

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
    
	sets.precast.FC['Geomancy'] = {
    main="Sucellus",
	ranged="Dunna",
    head={ name="Merlinic Hood", augments={'"Fast Cast"+6','MND+9','Mag. Acc.+11','"Mag.Atk.Bns."+4',}},
    body="Zendik Robe",
    hands="Shrieker's Cuffs",
    legs="Geomancy Pants +3",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Fast Cast"+6','MND+6','"Mag.Atk.Bns."+12',}},
    neck="Orunmila's Torque",
    waist="Embla Sash",
    left_ear="Magnetic Earring",
    right_ear="Calamitous Earring",
    left_ring="Kishar Ring",
    right_ring="Weather. Ring",
    back={ name="Nantosuelta's Cape", augments={'Haste+10',}}
    }
	
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
	})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
	})

	
	sets.precast.FC['Raise'] = {
    main="Sucellus",
    sub="Chanter's Shield",
    ammo="Impatiens",
    head={ name="Merlinic Hood", augments={'"Fast Cast"+6','MND+9','Mag. Acc.+11','"Mag.Atk.Bns."+4',}},
    body="Zendik Robe",
    hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','DEX+6','Mag. Acc.+8',}},
    legs="Geomancy Pants +3",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Fast Cast"+6','MND+6','"Mag.Atk.Bns."+12',}},
    neck="Orunmila's Torque",
    waist="Witful Belt",
    left_ear="Magnetic Earring",
    right_ear="Calamitous Earring",
    left_ring="Lebeche Ring",
    right_ring="Weather. Ring",
    back={ name="Nantosuelta's Cape", augments={'Haste+10',}},
	 }	
	sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, {
    main="Daybreak",
	 })		 
    -- Weaponskill sets
	
    -- Default set for any weaponskill that isn't any more specifically defined
	
    sets.precast.WS = {}
	
	sets.precast.WS['Seraph Strike'] = {
    head="Bagua galero +3",
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands={ name="Bagua Mitaines +3", augments={'Enhances "Curative Recantation" effect',}},
    legs={ name="Bagua Pants +3", augments={'Enhances "Mending Halation" effect',}},
    feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
    neck="Saevus Pendant +1",
    waist="Refoccilation Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Ifrit Ring",
    right_ring="Weather. Ring",
    back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}}	
	}

    sets.precast.WS['Flash Nova'] = {
    head="Bagua galero +3",
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands={ name="Bagua Mitaines +3", augments={'Enhances "Curative Recantation" effect',}},
    legs={ name="Bagua Pants +3", augments={'Enhances "Mending Halation" effect',}},
    feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
    neck="Saevus Pendant +1",
    waist="Refoccilation Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Ifrit Ring",
    right_ring="Weather. Ring",
    back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}}	
	}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
	
    sets.midcast.FastRecast = {}
	
    sets.midcast.Trust =  {}
    
	sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
    })

    sets.midcast.Geomancy = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Chanter's Shield",
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
    body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    hands={ name="Merlinic Dastanas", augments={'MND+9','Mag. Acc.+2','"Treasure Hunter"+2','Accuracy+14 Attack+14','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Merlinic Crackows", augments={'MND+7','STR+10','"Treasure Hunter"+2',}},
    neck="Incanter's Torque",
    waist="Austerity Belt",
    left_ear="Magnetic Earring",
    right_ear="Calamitous Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    right_ring="Defending Ring",
    back={ name="Lifestream Cape", augments={'Geomancy Skill +10','Indi. eff. dur. +20','Pet: Damage taken -2%',}}
    }

    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
    legs="Bagua Pants +3",
    feet="Azimuth Gaiters +1",
	back={ name="Lifestream Cape", augments={'Geomancy Skill +10','Indi. eff. dur. +20','Pet: Damage taken -2%',}}
    })
	
	sets.buff['Entrust'] = set_combine(sets.midcast.Geomancy, {
    main={ name="Gada", augments={'Indi. eff. dur. +9','DEX+3','"Mag.Atk.Bns."+18','DMG:+2',}},
	legs="Bagua Pants +3",
	back={ name="Lifestream Cape", augments={'Geomancy Skill +10','Indi. eff. dur. +20','Pet: Damage taken -2%',}}
	})

	function job_midcast(spell, action, spellMap, eventArgs)
		if string.find(spell.english,'Indi') and buffactive['Entrust'] then
			equip(sets.buff['Entrust'])
			eventArgs.handled = true
		end
	end	

    sets.midcast.Cure = set_combine(sets.midcast.FastRecast, {
	ranged=empty,
    main="Daybreak",
    sub="Ammurapi Shield",
    ammo="Quartz Tathlum +1",
    head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    neck="Incanter's Torque",
    waist="Bishop's Sash",
    left_ear="Beatific Earring",
    right_ear="Meili Earring",
    left_ring="Menelaus's Ring",
    right_ring="Sirona's Ring",
    back="Tempered Cape +1"
    })
    
    sets.midcast.Curaga = sets.midcast.Cure
	
	sets.midcast.Protectra = {ring1="Sheltered Ring"}

    sets.midcast.Shellra = {ring1="Sheltered Ring"}

    sets.midcast.HighTierNuke = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Ammurapi Shield",
	ranged=empty,	
    ammo="Pemphredo Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body="Ea Houppelande",
    hands={ name="Bagua Mitaines +3", augments={'Enhances "Curative Recantation" effect',}},
    legs={ name="Bagua Pants +3", augments={'Enhances "Mending Halation" effect',}},
    feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Regal Earring",
    right_ear="Malignance Earring",
    left_ring="Weather. Ring",
    right_ring="Locus Ring",
    back={ name="Aurist's Cape +1", augments={'Path: A',}}
    }
	
    sets.midcast.HighTierNuke.MagicBurst = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Ammurapi Shield",
	ranged=empty,	
    ammo="Pemphredo Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body="Ea Houppelande",
    hands={ name="Bagua Mitaines +3", augments={'Enhances "Curative Recantation" effect',}},
    legs={ name="Bagua Pants +3", augments={'Enhances "Mending Halation" effect',}},
    feet={ name="Merlinic Crackows", augments={'STR+7','VIT+2','Magic burst dmg.+12%','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
    neck="Mizu. Kubikazari",
    waist="Refoccilation Stone",
    left_ear="Regal Earring",
    right_ear="Malignance Earring",
    left_ring="Mujin Band",
    right_ring="Locus Ring",
    back="Aurist's Cape +1"
    }
	
	sets.midcast.HighTierNuke.Seidr = set_combine(sets.midcast.HighTierNuke, { 
	body="Seidr cotehardie"
	})

    sets.midcast.LowTierNuke = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Culminus",
	ranged=empty,
    ammo="Pemphredo Tathlum",
    head="Mall. Chapeau +2",
    body="Seidr Cotehardie",
    legs="Mallquis Trews +2",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Malignance Earring",
    left_ring="Weather. Ring",
    right_ring="Shiva Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
	hands={ name="Merlinic Dastanas", augments={'MND+9','Mag. Acc.+2','"Treasure Hunter"+2','Accuracy+14 Attack+14','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'MND+7','STR+10','"Treasure Hunter"+2',}},
    }
    
    sets.midcast.LowTierNuke.Resistant = sets.midcast.LowTierNuke

    sets.midcast.Macc = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Ammurapi Shield",
	ammo=empty,
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head="Geo. Galero +3",
    body="Geomancy Tunic +3",
    hands="Geo. Mitaines +3",
    legs="Geomancy Pants +3",
    feet="Geo. Sandals +3",
    neck="Bagua Charm +1",
    waist="Luminary Sash",
    left_ear="Digni. Earring",
    right_ear="Malignance Earring",
    left_ring="Kishar Ring",
    right_ring="Weather. Ring",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
	}
	
    sets.midcast.Absorb = set_combine(sets.midcast.Macc, {})
    
    sets.midcast['Dispelga'] = set_combine(sets.midcast.Macc, {
	main = "Daybreak"
	})
	
    sets.midcast.Aspir = {																																	   -- +94 D&A Potency x +28 Dark Potency 
    main={ name="Rubicundity", augments={'Mag. Acc.+3','"Conserve MP"+5',}},                                                                                   -- +20 D&A Potency
    sub="Ammurapi Shield",																																	   
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",																																   --					+28 Dark Potency	
    body={ name="Merlinic Jubbah", augments={'Accuracy+12','"Drain" and "Aspir" potency +11','Mag. Acc.+8','"Mag.Atk.Bns."+14',}},							   -- +11 D&A Potency					
    hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+20','"Drain" and "Aspir" potency +11','INT+7',}},												   -- +11 D&A Potency	
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25','"Drain" and "Aspir" potency +11',}},															   -- +11 D&A Potency 
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+13','"Drain" and "Aspir" potency +11','"Mag.Atk.Bns."+4',}},	                                       -- +18 D&A Potency 
    neck="Bagua Charm +1",	
    waist="Fucho-no-Obi",																																	   -- + 8 D&A Potency 			
    left_ear="Digni. Earring",
    right_ear="Hirudinea Earring",
    left_ring="Evanescence Ring",																															   -- +10 D&A Potency	
    right_ring="Excelsis Ring",																																   -- +5 D&A Potency				
    back="Aurist's Cape +1"
	}	
	
    sets.midcast.Drain = sets.midcast.Aspir
	
    sets.midcast.Stun = sets.midcast.Macc
    
    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast.Macc, {
	left_ring="Kishar Ring",
	})
	
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast.Macc, {})

	sets.midcast['Enhancing Magic'] = {
    main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','CHR+4','Mag. Acc.+14','"Mag.Atk.Bns."+7',}},
    sub="Ammurapi Shield",
	range=empty,	
    ammo="Seraphic Ampulla",
    head="Befouled Crown",
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +9',}},
    body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +9',}},
    legs="Shedir seraweels",
    feet="Regal Pumps +1",
    neck="Incanter's Torque",
    waist="Embla Sash",
    left_ear="Andoaa Earring",
    right_ear="Calamitous Earring",
    left_ring="Ephedra Ring",
    right_ring="Sirona's Ring",
    back="Fi Follet Cape +1"
	}

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
    main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','CHR+4','Mag. Acc.+14','"Mag.Atk.Bns."+7',}},
    sub="Ammurapi Shield",
	ammo=empty,
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +9',}},
     body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +9',}},
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +9',}},
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
    neck="Incanter's Torque",
	waist="Embla Sash",
    left_ear="Calamitous Earring",
    right_ear="Magnetic Earring",
    back="Solemnity Cape"	
	})

	sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {
	main="Vadose Rod",
    sub="Ammurapi Shield",
	head="Amalric coif",
	waist="Emphatikos Rope",
	legs="Shedir seraweels"
	})
	
	sets.midcast['Stoneskin'] = set_combine(sets.midcast ['Enhancing Magic'], {
	neck="Nodens gorget",
	ear2="Earthcry Earring",
	waist="Siegel Sash",
	legs="Shedir seraweels"
	})
		
	sets.midcast['Phalanx'] = set_combine(sets.midcast ['Enhancing Magic'],{
    ammo="Seraphic Ampulla",
    head="Befouled Crown",
    body={ name="Merlinic Jubbah", augments={'MND+4','CHR+3','Phalanx +3','Accuracy+15 Attack+15',}},
    hands={ name="Merlinic Dastanas", augments={'DEX+7','Weapon Skill Acc.+15','Phalanx +3','Accuracy+5 Attack+5',}},
    legs="Shedir Seraweels",
    feet={ name="Merlinic Crackows", augments={'AGI+8','STR+4','Phalanx +4',}},
    neck="Incanter's Torque",
	waist="Embla Sash",
    left_ear="Andoaa Earring",
    right_ear="Calamitous Earring",
    left_ring="Star Ring",
    right_ring="Sirona's Ring",
    back="Fi Follet Cape +1"
	})
	
	sets.midcast['Dia II'] = {
    hands={ name="Merlinic Dastanas", augments={'MND+9','Mag. Acc.+2','"Treasure Hunter"+2','Accuracy+14 Attack+14','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'MND+7','STR+10','"Treasure Hunter"+2',}},
	}
	
	sets.midcast['Diaga'] = {
    hands={ name="Merlinic Dastanas", augments={'MND+9','Mag. Acc.+2','"Treasure Hunter"+2','Accuracy+14 Attack+14','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'MND+7','STR+10','"Treasure Hunter"+2',}},
	}
	
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
		
	sets.midcast['Refresh'] = sets.midcast.EnhancingDuration
	
	sets.midcast['Regen'] = sets.midcast.EnhancingDuration
	
	sets.midcast['Sneak'] = sets.midcast.EnhancingDuration
		
	sets.midcast['Invisible'] = sets.midcast.EnhancingDuration

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
	
    -- Resting sets
    sets.resting = {}

    -- Idle sets
    sets.idle = {
	main="Bolelabunga",
    sub="Genmei Shield",
    ammo=empty,
	range="Dunna",
    head="Befouled Crown",
    neck="Bathy Choker +1",
    ear1="Infused Earring",
    ear2="Moonshade Earring",
    body="Jhakri robe +2",
    hands="Bagua Mitaines +3",
    ring1="Sheltered Ring",
    ring2="Paguroidea Ring",
    back="Kumbira Cape",
    waist="Fucho-no-obi",
    legs={ name="Merlinic Shalwar", augments={'Rng.Atk.+14','Attack+22','"Refresh"+2','Accuracy+7 Attack+7',}},
    feet={ name="Merlinic Crackows", augments={'Phys. dmg. taken -1%','Pet: INT+10','"Refresh"+2',}},
    }
	
    sets.idle.PDT = set_combine(sets.idle, {
    main="Mafic Cudgel",
    sub="Genmei Shield",
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands="Geo. Mitaines +3",
    legs="Volte Brais",
    feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
    neck="Loricate Torque +1",
    waist="Luminary Sash",
    left_ear="Eabani Earring",
    right_ear="Flashward Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    right_ring="Defending Ring",
    back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Phys. dmg. taken-10%',}}
    })

    -- .Pet sets are for when Luopan is present.
	
    sets.idle.Pet = {
    main={ name="Idris", augments={'Path: A',}},
    sub="Genmei Shield",
    ammo="Staunch Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands="Geo. Mitaines +3",
    legs="Volte Brais",
    feet="Azimuth Gaiters +1",
    neck="Loricate Torque +1",
    waist="Isa Belt",
    left_ear="Eabani Earring",
    right_ear="Flashward Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    right_ring="Defending Ring",
    back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Phys. dmg. taken-10%',}}
    } 

    sets.idle.PDT.Pet = set_combine(sets.idle.Pet, {})

    sets.idle.Melee = set_combine(sets.idle, {})

    -- .Indi sets are for when an Indi-spell is active.
	
    sets.idle.Indi = set_combine(sets.idle, {
    main={ name="Idris", augments={'Path: A',}},
    sub="Genmei Shield",
    ammo="Staunch Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands="Geo. Mitaines +3",
    legs="Volte Brais",
    feet="Azimuth Gaiters +1",
    neck="Loricate Torque +1",
    waist="Isa Belt",
    left_ear="Eabani Earring",
    right_ear="Flashward Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    right_ring="Defending Ring",
    back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Phys. dmg. taken-10%',}}
	})
	
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {
    main={ name="Idris", augments={'Path: A',}},
    sub="Genmei Shield",
    ammo="Staunch Tathlum",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Bagua Tunic +3", augments={'Enhances "Bolster" effect',}},
    hands="Geo. Mitaines +3",
    legs="Volte Brais",
    feet="Azimuth Gaiters +1",
    neck="Loricate Torque +1",
    waist="Isa Belt",
    left_ear="Eabani Earring",
    right_ear="Flashward Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    right_ring="Defending Ring",
    back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Phys. dmg. taken-10%',}}
    })

	sets.idle.MDT = sets.idle.PDT

    sets.idle.Town = sets.idle.Pet


    -- Defense sets

    sets.defense.PDT = sets.idle.PDT
	
	sets.defense.MDT = sets.idle.PDT	

	sets.Kiting = {}

	sets.MoveSpeed = {
	feet = "Geo. sandals +3"
	}
	
    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
	
	sets.engaged = {
    ammo="Hasty Pinion +1",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Telchine Chas.", augments={'Attack+18','"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    hands={ name="Telchine Gloves", augments={'"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    legs="Volte Brais",
    feet="Battlecast Gaiters",
    neck="Asperity Necklace",
    waist="Shetal Stone",
    left_ear="Eabani Earring",
    right_ear="Digni. Earring",
    left_ring="Petrov Ring",
    right_ring="K'ayres Ring",
    back={ name="Nantosuelta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}	
	}
    sets.engaged.DW = {

    ammo="Hasty Pinion +1",
    head={ name="Bagua Galero +3", augments={'Enhances "Primeval Zeal" effect',}},
    body={ name="Telchine Chas.", augments={'Attack+18','"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    hands={ name="Telchine Gloves", augments={'"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    legs="Volte Brais",
    feet="Battlecast Gaiters",
    neck="Asperity Necklace",
    waist="Shetal Stone",
    left_ear="Eabani Earring",
    right_ear="Digni. Earring",
    left_ring="Petrov Ring",
    right_ring="K'ayres Ring",
    back={ name="Nantosuelta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    }
	
    sets.engaged.Melee = set_combine(sets.engaged, {
    main="Idris",
    sub="Genmei Shield",
    ammo="Hasty Pinion +1",
    head={ name="Telchine Cap", augments={'"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    body={ name="Telchine Chas.", augments={'Attack+18','"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    hands={ name="Telchine Gloves", augments={'"Store TP"+5','Enh. Mag. eff. dur. +9',}},
    legs="Volte Brais",
    feet="Battlecast Gaiters",
    neck="Cuamiz Collar",
    waist="Grunfeld Rope",
    left_ear="Steelflash Earring",
    right_ear="Bladeborn Earring",
    left_ring="Petrov Ring",
    right_ring="K'ayres Ring",
    back={ name="Nantosuelta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}	
    })
	
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
	refine_various_spells(spell, action, spellMap, eventArgs)
    --if state.Buff.Poison then
    --    classes.CustomClass = 'Mindmelter'
    --end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- Make sure abilities using head gear don't swap 
	if spell.type:lower() == 'weaponskill' then
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
--function job_status_change(newStatus, oldStatus, eventArgs)
--    if newStatus == 'Engaged' then
--        -- nothing yet
--        elseif newStatus == 'Idle' then
--            determine_idle_group()
--    end
--end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Melee' then
            disable('main','sub')
        else
            enable('main','sub')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
            return 'Absorb'
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
            if lowTierNukes:contains(spell.english) then
                return 'LowTierNuke'
            else
                return 'HighTierNuke'
            end
        elseif spell.type == 'Trust' then
            return 'Trust'

        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CapacityMode.value then
        idleSet = set_combine(idleSet, sets.CapacityMantle)
    end
    if state.OffenseMode.value == 'Melee' then
        idleSet = set_combine(sets.idle, sets.idle.Melee)
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    return meleeSet
end
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 6)
end
--Refine Nuke Spells
function refine_various_spells(spell, action, spellMap, eventArgs)
	aspirs = S{'Aspir','Aspir II','Aspir III'}
	sleeps = S{'Sleep II','Sleep'}
	sleepgas = S{'Sleepga II','Sleepga'}
	nukes = S{'Fire', 'Blizzard', 'Aero', 'Stone', 'Thunder', 'Water',
	'Fire II', 'Blizzard II', 'Aero II', 'Stone II', 'Thunder II', 'Water II',
	'Fire III', 'Blizzard III', 'Aero III', 'Stone III', 'Thunder III', 'Water III',
	'Fire IV', 'Blizzard IV', 'Aero IV', 'Stone IV', 'Thunder IV', 'Water IV',
	'Fire V', 'Blizzard V', 'Aero V', 'Stone V', 'Thunder V', 'Water V',
	'Fire VI', 'Blizzard VI', 'Aero VI', 'Stone VI', 'Thunder VI', 'Water VI',
	'Firaga', 'Blizzaga', 'Aeroga', 'Stonega', 'Thundaga', 'Waterga',
	'Firaga II', 'Blizzaga II', 'Aeroga II', 'Stonega II', 'Thundaga II', 'Waterga II',
	'Firaga III', 'Blizzaga III', 'Aeroga III', 'Stonega III', 'Thundaga III', 'Waterga III',	
	'Firaja', 'Blizzaja', 'Aeroja', 'Stoneja', 'Thundaja', 'Waterja',
	}
	cures = S{'Cure IV','Cure V','Cure IV','Cure III','Curaga III','Curaga II', 'Curaga',}
	
	if spell.skill == 'Healing Magic' then
		if not cures:contains(spell.english) then
			return
		end
		
		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
		
		if spell_recasts[spell.recast_id] > 0 then
			if cures:contains(spell.english) then
				if spell.english == 'Cure' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Cure IV' then
					newSpell = 'Cure V'
				elseif spell.english == 'Cure V' then
					newSpell = 'Cure IV'
				elseif spell.english == 'Cure IV' then
					newSpell = 'Cure III'
				end
			end
		end
		
		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	elseif spell.skill == 'Dark Magic' then
		if not aspirs:contains(spell.english) then
			return
		end
		
		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'

		if spell_recasts[spell.recast_id] > 0 then
			if aspirs:contains(spell.english) then
				if spell.english == 'Aspir' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Aspir II' then
					newSpell = 'Aspir'
				elseif spell.english == 'Aspir III' then
					newSpell = 'Aspir II'
				end
			end
		end
		
		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	elseif spell.skill == 'Elemental Magic' then
		if not sleepgas:contains(spell.english) and not sleeps:contains(spell.english) and not nukes:contains(spell.english) then
			return
		end

		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'

		if spell_recasts[spell.recast_id] > 0 then
			if sleeps:contains(spell.english) then
				if spell.english == 'Sleep' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Sleep II' then
					newSpell = 'Sleep'
				end
			elseif sleepgas:contains(spell.english) then
				if spell.english == 'Sleepga' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
					return
				elseif spell.english == 'Sleepga II' then
					newSpell = 'Sleepga'
				end
			elseif nukes:contains(spell.english) then	
				if spell.english == 'Fire' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Fire VI' then
					newSpell = 'Fire V'
				elseif spell.english == 'Fire V' then
					newSpell = 'Fire IV'
				elseif spell.english == 'Fire IV' then
					newSpell = 'Fire III'	
				elseif spell.english == 'Fire II' then
					newSpell = 'Fire'
				elseif spell.english == 'Firaja' then
					newSpell = 'Firaga III'
				elseif spell.english == 'Firaga II' then
					newSpell = 'Firaga'
				end 
				if spell.english == 'Blizzard' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Blizzard VI' then
					newSpell = 'Blizzard V'
				elseif spell.english == 'Blizzard V' then
					newSpell = 'Blizzard IV'
				elseif spell.english == 'Blizzard IV' then
					newSpell = 'Blizzard III'	
				elseif spell.english == 'Blizzard II' then
					newSpell = 'Blizzard'
				elseif spell.english == 'Blizzaja' then
					newSpell = 'Blizzaga III'
				elseif spell.english == 'Blizzaga II' then
					newSpell = 'Blizzaga'	
				end 
				if spell.english == 'Aero' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Aero VI' then
					newSpell = 'Aero V'
				elseif spell.english == 'Aero V' then
					newSpell = 'Aero IV'
				elseif spell.english == 'Aero IV' then
					newSpell = 'Aero III'	
				elseif spell.english == 'Aero II' then
					newSpell = 'Aero'
				elseif spell.english == 'Aeroja' then
					newSpell = 'Aeroga III'
				elseif spell.english == 'Aeroga II' then
					newSpell = 'Aeroga'	
				end 
				if spell.english == 'Stone' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Stone VI' then
					newSpell = 'Stone V'
				elseif spell.english == 'Stone V' then
					newSpell = 'Stone IV'
				elseif spell.english == 'Stone IV' then
					newSpell = 'Stone III'	
				elseif spell.english == 'Stone II' then
					newSpell = 'Stone'
				elseif spell.english == 'Stoneja' then
					newSpell = 'Stonega III'
				elseif spell.english == 'Stonega II' then
					newSpell = 'Stonega'	
				end 
				if spell.english == 'Thunder' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Thunder VI' then
					newSpell = 'Thunder V'
				elseif spell.english == 'Thunder V' then
					newSpell = 'Thunder IV'
				elseif spell.english == 'Thunder IV' then
					newSpell = 'Thunder III'	
				elseif spell.english == 'Thunder II' then
					newSpell = 'Thunder'
				elseif spell.english == 'Thundaja' then
					newSpell = 'Thundaga III'
				elseif spell.english == 'Thundaga II' then
					newSpell = 'Thundaga'	
				end 
				if spell.english == 'Water' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Water VI' then
					newSpell = 'Water V'
				elseif spell.english == 'Water V' then
					newSpell = 'Water IV'
				elseif spell.english == 'Water IV' then
					newSpell = 'Water III'	
				elseif spell.english == 'Water II' then
					newSpell = 'Water'
				elseif spell.english == 'Waterja' then
					newSpell = 'Waterga III'
				elseif spell.english == 'Waterga II' then
					newSpell = 'Waterga'	
				end 
			end
		end

		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	end
end

mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
mov.x = windower.ffxi.get_mob_by_index(player.index).x
mov.y = windower.ffxi.get_mob_by_index(player.index).y
mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
mov.counter = mov.counter + 1;
if mov.counter>15 then
local pl = windower.ffxi.get_mob_by_index(player.index)
if pl and pl.x and mov.x then
dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
if dist > 1 and not moving and player.status ~= "Engaged" then
state.Moving.value = true
send_command('gs c update')
send_command('gs equip sets.MoveSpeed')
moving = true

elseif dist < 1 and moving then
state.Moving.value = false
send_command('gs c update')
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
