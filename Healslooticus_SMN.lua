-- Summoner Gearswap Lua by Pergatory - http://pastebin.com/u/pergatory
-- IdleMode determines the set used after casting. You change it with "/console gs c <IdleMode>"
-- The modes are:
-- Refresh: Uses the most refresh available.
-- DT: A mix of refresh, PDT, and MDT to help when you can't avoid AOE.
-- PetDT: Sacrifice refresh to reduce avatar's damage taken. WARNING: Selenian Cap drops you below 119, use with caution!
-- DD: When melee mode is on and you're engaged, uses TP gear. Otherwise, avatar melee gear.
-- Favor: Uses Beckoner's Horn +1 and max smn skill to boost the favor effect.
-- Zendik: Favor build with the Zendik Robe added in, for Shiva's Favor in manaburn parties. (Shut up, it sounded like a good idea at the time)
 
-- Additional Bindings:
-- F9 - Toggles between a subset of IdleModes (Refresh > DT > PetDT)
-- F10 - Toggles MeleeMode (When enabled, equips Nirvana and Elan+1, then disables those 2 slots from swapping)
--       NOTE: If you don't already have the Nirvana & Elan+1 equipped, YOU WILL LOSE TP
 
-- Additional Commands:
-- /console gs c AccMode - Toggles high-accuracy sets to be used where appropriate.
-- /console gs c ImpactMode - Toggles between using normal magic BP set for Fenrir's Impact or a custom high-skill set for debuffs.
-- /console gs c ForceIlvl - I have this set up to override a few specific slots where I normally use non-ilvl pieces.
-- /console gs c TH - Treasure Hunter toggle. By default, this is only used for Dia, Dia II, and Diaga.
-- /console gs c LagMode - Used to help BPs land in the right gear in high-lag situations.
--                          Sets a timer to swap gear 0.5s after the BP is used rather than waiting for server response.
 
function file_unload()
    send_command('unbind f9')
    send_command('unbind ^f9')
    send_command('unbind f10')
    send_command('unbind ^f10')
end
 
function get_sets()
    send_command('bind f9 gs c ToggleIdle') -- F9 = Cycle through commonly used idle modes
    send_command('bind ^f9 gs c ForceIlvl') -- Ctrl+F9 = Toggle ForceIlvl
    send_command('bind f10 gs c MeleeMode') -- F10 = Toggle Melee Mode
    send_command('bind ^f10 gs c TH') -- Ctrl+F10 = Treasure Hunter toggle
 
    -- Set your merits here. This is used in deciding between Enticer's Pants or Apogee Slacks +1.
    -- To change in-game, "/console gs c MeteorStrike3" will change Meteor Strike to 3/5 merits.
    -- The damage difference is very minor unless you're over 2400 TP.
    -- It's ok to just always use Enticer's Pants and ignore this section.
    MeteorStrike = 1
    HeavenlyStrike = 1
    WindBlade = 1
    Geocrush = 1
    Thunderstorm = 5
    GrandFall = 1
 
    StartLockStyle = '85'
    IdleMode = 'Refresh'
    AccMode = false
    ImpactDebuff = false
    MeleeMode = false
    TreasureHunter = false
    THSpells = S{"Dia","Dia II","Diaga"} -- If you want Treasure Hunter gear to swap for a spell/ability, add it here.
    ForceIlvl = false
    LagMode = false -- Default LagMode. If you have a lot of lag issues, change to "true".
    AutoRemedy = false -- Auto Remedy when using an ability while Paralyzed.
    AutoEcho = false -- Auto Echo Drop when using an ability while Silenced.
    SacTorque = true -- If you have Sacrifice Torque, this will auto-equip it when slept in order to wake up.
 
    -- ===================================================================================================================
    --      Sets
    -- ===================================================================================================================
 
    -- Base Damage Taken Set - Mainly used when IdleMode is "DT"
    sets.DT_Base = {
		sub="Mensch Strap",
		ammo="Sancus Sachet +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Baaya. Sabots +1",
		neck="Sibyl Scarf",
		waist="Carrier's Sash",
		left_ear={ name="Moonshade Earring", augments={'HP+25','Latent effect: "Refresh"+1',}},
		right_ear="C. Palug Earring",
		left_ring="Defending Ring",
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
		back="Moonlight Cape",
    }
 
    -- Treasure Hunter set. Don't put anything in here except TH+ gear.
    -- It overwrites slots in other sets when TH toggle is on (Ctrl+F10).
    sets.TH = {
        -- head="Volte Cap",
        -- waist="Chaac Belt",
        -- hands="Volte Bracers",
        -- feet="Volte Boots"
    }
 
    sets.precast = {}
 
    -- Fast Cast
    sets.precast.FC = {
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+10','Pet: INT+3','Pet: "Mag.Atk.Bns."+17','DMG:+8',}},
		sub="Clerisy Strap",
		ammo="Sancus Sachet +1",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet="Regal Pumps +1",
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Campestres's Cape", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','HP+12','"Fast Cast"+10',}},
    }
 
    sets.precast["Dispelga"] = set_combine(sets.precast.FC, {
        main="Daybreak",
        sub="Ammurapi Shield"
    })
 
    sets.midcast = {}
 
    -- BP Timer Gear
    -- Use BP Recast Reduction here, along with Avatar's Favor gear.
    -- Avatar's Favor skill tiers are 512 / 575 / 670.
    sets.midcast.BP = {
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Vox Grip",
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +2",
		body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Baaya. Sabots +1",
		neck="Melic Torque",
		waist="Kobo Obi",
		left_ear="Lodurr Earring",
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+3','Blood Pact ab. del. II -1',}},
    }
 
    -- Elemental Siphon sets. Zodiac Ring is affected by day, Chatoyant Staff by weather, and Twilight Cape by both.
    sets.midcast.Siphon = {
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Vox Grip",
		ammo="Esper Stone +1",
		head="Baayami Hat +1",
		body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Beck. Pigaches +2",
		neck="Melic Torque",
		waist="Kobo Obi",
		left_ear="Loquac. Earring",
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+3','Blood Pact ab. del. II -1',}},
    }
 
    sets.midcast.SiphonZodiac = set_combine(sets.midcast.Siphon, { ring1="Zodiac Ring" })
 
    sets.midcast.SiphonWeather = set_combine(sets.midcast.Siphon, { main="Chatoyant Staff" })
    
    sets.midcast.SiphonWeatherZodiac = set_combine(sets.midcast.SiphonZodiac, { main="Chatoyant Staff" })
 
    -- Summoning Midcast, cap spell interruption if possible (Baayami Robe gives 100, need 2 more)
    -- PDT isn't a bad idea either, so don't overwrite a lot from the DT set it inherits from.
    sets.midcast.Summon = set_combine(sets.DT_Base, {
        body="Baayami Robe +1",
        left_ear="Halasz Earring"
    })
 
    -- If you ever lock your weapon, keep that in mind when building cure potency set.
    sets.midcast.Cure = {
		main="Bunzi's Rod",
		sub="Sors Shield",
		ammo="Sancus Sachet +1",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body="Bunzi's Robe",
		hands="Inyan. Dastanas +2",
		legs="Bunzi's Pants",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Clotharius Torque",
		waist="Acerbic Sash +1",
		left_ear="Eabani Earring",
		right_ear="Halasz Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
		back="Moonlight Cape",
    }
 
    sets.midcast.Cursna = {
		main="Mpaca's Staff",
		sub="Mensch Strap",
		ammo="Sancus Sachet +1",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body="Bunzi's Robe",
		hands="Inyan. Dastanas +2",
		legs="Bunzi's Pants",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Fucho-no-Obi",
		left_ear="Loquac. Earring",
		right_ear="C. Palug Earring",
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back="Moonlight Cape",    
	}
    
    -- Just a standard set for spells that have no set
    sets.midcast.EnmityRecast = set_combine(sets.precast.FC, {

    })
 
    -- Strong alternatives: Daybreak and Ammurapi Shield, Cath Crown, Gwati Earring
    sets.midcast.Enfeeble = {
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+10','Pet: INT+3','Pet: "Mag.Atk.Bns."+17','DMG:+8',}},
		sub="Enki Strap",
		ammo="Sancus Sachet +1",
		head="C. Palug Crown",
		body="Bunzi's Robe",
		hands="Inyan. Dastanas +2",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sanctity Necklace",
		waist="Luminary Sash",
		left_ear="Lempo Earring",
		right_ear="Gwati Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
		back="Aurist's Cape +1",
    }
    sets.midcast.Enfeeble.INT = set_combine(sets.midcast.Enfeeble, {
        waist="Acuity Belt +1"
    })
 
    sets.midcast.Enhancing = {
		main="Bunzi's Rod",
		sub="Sors Shield",
		ammo="Sancus Sachet +1",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +10',}},
		neck="Melic Torque",
		waist="Embla Sash",
		left_ear="Halasz Earring",
		right_ear="Eabani Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
		back="Moonlight Cape",
    }
 
    sets.midcast.Stoneskin = set_combine(sets.midcast.Enhancing, {
        -- neck="Nodens Gorget",
        -- ear2="Earthcry Earring",
        -- waist="Siegel Sash",
        -- legs="Shedir Seraweels"
    })
 
    sets.midcast.Nuke = {
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+10','Pet: INT+3','Pet: "Mag.Atk.Bns."+17','DMG:+8',}},
		sub="Enki Strap",
		ammo="Sancus Sachet +1",
		head="C. Palug Crown",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sanctity Necklace",
		waist="Refoccilation Stone",
		left_ear="Friomisi Earring",
		right_ear="Sortiarius Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
		back="Aurist's Cape +1",
    }
 
    sets.midcast["Refresh"] = set_combine(sets.midcast.Enhancing, {
        -- head="Amalric Coif +1",
        -- waist="Gishdubar Sash"
    })
 
    sets.midcast["Aquaveil"] = set_combine(sets.midcast.Enhancing, {
        -- main="Vadose Rod",
        -- head="Amalric Coif +1"
    })
 
    sets.midcast["Dispelga"] = set_combine(sets.midcast.Enfeeble, {
        main="Daybreak",
        sub="Ammurapi Shield"
    })
 
    sets.midcast["Mana Cede"] = { hands="Beckoner's Bracers +2" }
 
    sets.midcast["Astral Flow"] = { head="Glyphic Horn +1" }
    
    -- ===================================================================================================================
    --  Weaponskills
    -- ===================================================================================================================
 
    -- Magic accuracy can be nice here to land the defense down effect. Also keep in mind big damage Garland can make it
    -- harder for multiple people to get AM3 on trash mobs before popping an NM.
    sets.midcast["Garland of Bliss"] = {
        head="Nyame Helm",
        neck="Sanctity Necklace",
        ear1="Malignance Earring",
        ear2="Dignitary's Earring",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
        back="Aurist's Cape +1",
        waist="Eschan Stone",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets"
    }
 
    -- My set focuses on accuracy here to make skillchains with Ifrit
    -- Just like Garland, it's not hard to improve on the damage from this set if that's what you're after.
    sets.midcast["Shattersoul"] = {
        head="Convoker's Horn +3",
        -- neck="Fotia Gorget",
        -- ear1="Zennaroi Earring",
        -- ear2="Telos Earring",
        Body="Nyame Mail",
        hands="Nyame Gauntlets",
        -- ring1="Freke Ring",
        -- ring2="Shiva Ring +1",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
        back="Aurist's Cape +1",
        -- back={ name="Campestres's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        -- waist="Fotia Belt",
        waist="Eschan Stone",
        legs="Nyame Flanchard",
        feet="Convoker's Pigaches +2"
    }
 
    sets.midcast["Cataclysm"] = sets.midcast.Nuke
    
    sets.midcast["Shell Crusher"] = sets.midcast["Garland of Bliss"]
 
    sets.pet_midcast = {}
 
    -- Main physical pact set (Volt Strike, Pred Claws, etc.)
    -- Prioritize BP Damage & Pet: Double Attack
    -- Strong Alternatives:
    -- Gridarvor, Apogee Crown, Apogee Pumps, Convoker's Doublet, Apogee Dalmatica, Shulmanu Collar (equal to ~R15 Collar), Gelos Earring, Regal Belt
    sets.pet_midcast.Physical_BP = {
	--nirvana
		main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head={ name="Helios Band", augments={'Pet: Attack+30 Pet: Rng.Atk.+30','Pet: "Dbl. Atk."+8','Blood Pact Dmg.+7',}},
		body="Con. Doublet +2",
		hands={ name="Merlinic Dastanas", augments={'Pet: Attack+24 Pet: Rng.Atk.+24','Blood Pact Dmg.+10','Pet: STR+10',}},
		legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
		feet={ name="Helios Boots", augments={'Pet: Attack+30 Pet: Rng.Atk.+30','Pet: "Dbl. Atk."+8','Blood Pact Dmg.+6',}},
		neck={ name="Smn. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Lugalbanda Earring",
		right_ear="Kyrene's Earring",
		left_ring={name="Varar Ring +1", bag="wardrobe3"},
		right_ring="C. Palug Ring",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Attack+9 Pet: Rng.Atk.+9','Pet: Damage taken -5%',}},
    }
 
    -- Physical Pact AM3 set, less emphasis on Pet:DA
    sets.pet_midcast.Physical_BP_AM3 = set_combine(sets.pet_midcast.Physical_BP, {
        right_ear="Gelos Earring",
        body="Convoker's Doublet +2",
		right_ring={name="Varar Ring +1", bag="wardrobe4"},
    })
 
    -- Physical pacts which benefit more from TP than Pet:DA (like Spinning Dive and other pacts you never use except that one time)
    sets.pet_midcast.Physical_BP_TP = set_combine(sets.pet_midcast.Physical_BP, {
        right_ear="Gelos Earring",
        body="Convoker's Doublet +2",
		right_ring={name="Varar Ring +1", bag="wardrobe4"},
        waist="Regal Belt",
        legs="Enticer's Pants",
    })
 
    -- Used for all physical pacts when AccMode is true
    sets.pet_midcast.Physical_BP_Acc = set_combine(sets.pet_midcast.Physical_BP, {
        body="Convoker's Doublet +2",
        feet="Convoker's Pigaches +2"
    })
 
    -- Base magic pact set
    -- Prioritize BP Damage & Pet:MAB
    -- Strong Alternatives:
    -- Espiritus, Apogee Crown, Adad Amulet (equal to ~R12 Collar)
    sets.pet_midcast.Magic_BP_Base = {
-- NEED MAB APOGEE LEGS, Better augs on Hands/Weapon
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+10','Pet: INT+3','Pet: "Mag.Atk.Bns."+17','DMG:+8',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="C. Palug Crown",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands={ name="Merlinic Dastanas", augments={'Pet: Attack+29 Pet: Rng.Atk.+29','Blood Pact Dmg.+10','Pet: Mag. Acc.+11','Pet: "Mag.Atk.Bns."+14',}},
		legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		neck={ name="Smn. Collar +2", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring",
		left_ring={name="Varar Ring +1", bag="wardrobe3"},
		right_ring={name="Varar Ring +1", bag="wardrobe4"},
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Eva.+20 /Mag. Eva.+20','Pet: Magic Damage+10',}},
    }
    
    -- Some magic pacts benefit more from TP than others.
    -- Note: This set will only be used on merit pacts if you have less than 4 merits.
    --       Make sure to update your merit values at the top of this Lua.
    sets.pet_midcast.Magic_BP_TP = set_combine(sets.pet_midcast.Magic_BP_Base, {
        legs="Enticer's Pants"
    })
 
    -- NoTP set used when you don't need Enticer's
    sets.pet_midcast.Magic_BP_NoTP = set_combine(sets.pet_midcast.Magic_BP_Base, {
        legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}}
    })
 
    sets.pet_midcast.Magic_BP_TP_Acc = set_combine(sets.pet_midcast.Magic_BP_TP, {
        body="Convoker's Doublet +2",
    })
 
    sets.pet_midcast.Magic_BP_NoTP_Acc = set_combine(sets.pet_midcast.Magic_BP_NoTP, {
        body="Convoker's Doublet +2",
    })
 
    -- Favor BP Damage above all. Pet:MAB also very strong.
    -- Pet: Accuracy, Attack, Magic Accuracy moderately important.
    -- Strong Alternatives:
    -- Keraunos, Grioavolr, Espiritus, Was, Apogee Crown, Apogee Dalmatica, Adad Amulet
    sets.pet_midcast.FlamingCrush = {
-- NEED augs on Hands/Weapon
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+10','Pet: INT+3','Pet: "Mag.Atk.Bns."+17','DMG:+8',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="C. Palug Crown",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands={ name="Merlinic Dastanas", augments={'Pet: Attack+29 Pet: Rng.Atk.+29','Blood Pact Dmg.+10','Pet: Mag. Acc.+11','Pet: "Mag.Atk.Bns."+14',}},
		legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		neck={ name="Smn. Collar +2", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring",
		left_ring={name="Varar Ring +1", bag="wardrobe3"},
		right_ring={name="Varar Ring +1", bag="wardrobe4"},
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Eva.+20 /Mag. Eva.+20','Pet: Magic Damage+10',}},
    }
 
    sets.pet_midcast.FlamingCrush_Acc = set_combine(sets.pet_midcast.FlamingCrush, {
        ear2="Kyrene's Earring",
        body="Convoker's Doublet +2",
		feet="Convoker's Pigaches +2"
    })
 
    -- Pet: Magic Acc set - Mainly used for debuff pacts like Shock Squall
    sets.pet_midcast.MagicAcc_BP = {
        main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="Convoker's Horn +3",
		body="Con. Doublet +2",
		hands={ name="Lamassu Mitts +1", augments={'Path: A',}},
		legs="Convo. Spats +2",
		feet="Bunzi's Sabots",
		neck={ name="Smn. Collar +2", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Kyrene's Earring",
		left_ring="C. Palug Ring",
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Eva.+20 /Mag. Eva.+20','Pet: Magic Damage+10',}},
    }
 
    sets.pet_midcast.Debuff_Rage = sets.pet_midcast.MagicAcc_BP
 
    -- Pure summoning magic set, mainly used for buffs like Hastega II.
    -- Strong Alternatives:
    -- Andoaa Earring, Summoning Earring, Lamassu Mitts +1, Caller's Pendant
    sets.pet_midcast.SummoningMagic = {
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Vox Grip",
		ammo="Sancus Sachet +1",
		head="Baayami Hat +1",
		body="Baayami Robe +1",
		hands="Baayami Cuffs +1",
		legs="Baayami Slops +1",
		feet="Baaya. Sabots +1",
		neck="Melic Torque",
		waist="Kobo Obi",
		left_ear="Lodurr Earring",
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+3','Blood Pact ab. del. II -1',}},
    }
 
    sets.pet_midcast.Buff = sets.pet_midcast.SummoningMagic
    
    -- Wind's Blessing set. Pet:MND increases potency.
    sets.pet_midcast.Buff_MND = set_combine(sets.pet_midcast.Buff, {
        -- main="Nirvana",
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Vox Grip",
		ammo="Sancus Sachet +1",
		head="Baayami Hat +1",
		body={ name="Shomonjijoe +1", augments={'Path: A',}},
		hands={ name="Lamassu Mitts +1", augments={'Path: A',}},
		legs="Assid. Pants +1",
		feet="Baaya. Sabots +1",
		neck={ name="Smn. Collar +2", augments={'Path: A',}},
		waist="Kobo Obi",
		left_ear="Evans Earring",
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Eva.+20 /Mag. Eva.+20','Pet: Magic Damage+10',}},
    })
 
    -- Don't drop Avatar level in this set if you can help it.
    -- You can use Avatar:HP+ gear to increase the HP recovered, but most of it will decrease your own max HP.
    sets.pet_midcast.Buff_Healing = set_combine(sets.pet_midcast.Buff, {
        -- main="Nirvana",
		body="Shomonjijoe +1",
    })
 
    -- This set is used for certain blood pacts when ImpactDebuff mode is turned ON. (/console gs c ImpactDebuff)
    -- These pacts are normally used with magic damage gear, but they're also strong debuffs when enhanced by summoning skill.
    -- This set is safe to ignore.
    sets.pet_midcast.Impact = set_combine(sets.pet_midcast.SummoningMagic, {
        -- main="Nirvana",
        head="Convoker's Horn +3",
        ear1="Lugalbanda Earring",
        ear2="Enmerkar Earring",
        hands="Lamassu Mitts +1"
    })
 
    sets.aftercast = {}
 
    -- Idle set with no avatar out.
	sets.aftercast.Idle = {
		main="Mpaca's Staff",
		sub="Mensch Strap",
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +2",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Asteria Mitts +1",
		legs="Assid. Pants +1",
		feet="Baaya. Sabots +1",
		neck="Sibyl Scarf",
		waist="Fucho-no-Obi",
		left_ear={ name="Moonshade Earring", augments={'HP+25','Latent effect: "Refresh"+1',}},
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Shneddick Ring",
		back="Moonlight Cape",
    }
    
    -- Idle set used when ForceIlvl is ON. Use this mode to avoid Gaiters dropping ilvl.
    sets.aftercast.Idle_Ilvl = set_combine(sets.aftercast.Idle, {
        feet="Baayami Sabots +1"
    })
    
    sets.aftercast.DT = sets.DT_Base
 
    -- Main refresh set - Many idle sets inherit from this set.
    -- Put common items here so you don't have to repeat them over and over.
    -- Strong Alternatives:
    -- Gridarvor, Asteria Mitts, Shomonjijoe, Beckoner's Horn, Evans Earring, Isa Belt
    sets.aftercast.Perp_Base = {
        -- main="Nirvana",
		main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
		sub="Mensch Strap",
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +2",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Asteria Mitts +1",
		legs="Assid. Pants +1",
		feet="Baaya. Sabots +1",
		neck="Caller's Pendant",
		waist="Lucidity Sash",
		left_ear="Evans Earring",
		right_ear="C. Palug Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back="Moonlight Cape",
    }
 
    -- Avatar Melee set. Equipped when IdleMode is "DD" and MeleeMode is OFF.
    -- You really don't need this set. It's only here because I can't bring myself to throw it away.
    sets.aftercast.Perp_DD = set_combine(sets.aftercast.Perp_Base, {

    })
 
    -- Refresh set with avatar out. Equipped when IdleMode is "Refresh".
    sets.aftercast.Perp_Refresh = set_combine(sets.aftercast.Perp_Base, {
    })
 
    -- Refresh set when MP is under 50%
    -- If you have Fucho and don't need Lucidity Sash for perp down, you can uncomment the belt here to enable using it.
    sets.aftercast.Perp_RefreshSub50 = set_combine(sets.aftercast.Perp_Refresh, {
        --waist="Fucho-no-obi"
    })
    
    -- Used when IdleMode is "Favor" to maximize avatar's favor effect.
    -- Skill tiers are 512 / 575 / 670
    sets.aftercast.Perp_Favor = set_combine(sets.aftercast.Perp_Refresh, {
		sub="Vox Grip",
        head="Beckoner's Horn +2",
		body="Beckoner's Doublet +2",
		legs="Beckoner's Spats +2",
		hands="Asteria Mitts +1",
        left_ear="Moonshade Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring={name="Stikini Ring +1", bag="wardrobe4"},
    })
 
    sets.aftercast.Perp_Zendik = set_combine(sets.aftercast.Perp_Favor, {
        body="Zendik Robe"
    })
 
    -- TP set. Equipped when IdleMode is "DD" and MeleeMode is ON.
    sets.aftercast.Perp_Melee = set_combine(sets.aftercast.Perp_Refresh, {
        -- head="Convoker's Horn +3",
        -- neck="Shulmanu Collar",
        -- ear1="Telos Earring",
        -- ear2="Cessance Earring",
        -- body="Tali'ah Manteel +2",
        -- hands="Bunzi's Gloves",
        -- ring1={ name="Chirich Ring +1", bag="wardrobe2" },
        -- ring2={ name="Chirich Ring +1", bag="wardrobe4" },
        -- back={ name="Campestres's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        -- waist="Cetl Belt",
        -- legs="Convoker's Spats +3",
        -- feet="Convoker's Pigaches +3"
    })
 
    -- Pet:DT build. Equipped when IdleMode is "PetDT". Note: Avatars only need -31 PDT to cap, MDT is the hard one to cap.
    -- Strong alternatives:
    -- Selenian Cap, Enmerkar Earring, Handler's Earring, Rimeice Earring, Thurandaut Ring, Tali'ah Seraweels
    sets.aftercast.Avatar_DT = {
        -- main="Nirvana",
        -- sub="Oneiros Grip",
        -- ammo="Sancus Sachet +1",
        -- head={ name="Apogee Crown +1", augments={'Pet: Accuracy+25','"Avatar perpetuation cost"+7','Pet: Damage taken -4%',}},
        -- neck="Summoner's Collar +2",
        -- ear1="Cath Palug Earring",
        -- ear2="Enmerkar Earring",
        -- body={ name="Apo. Dalmatica +1", augments={'Summoning magic skill +20','Enmity-6','Pet: Damage taken -4%',}},
        -- hands={ name="Telchine Gloves", augments={'Pet: Mag. Evasion+18','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		-- left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		-- right_ring={name="Stikini Ring +1", bag="wardrobe4"},
        -- back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
        -- waist="Isa Belt",
        -- legs="Enticer's Pants",
        -- feet={ name="Telchine Pigaches", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -4%',}}
    }
 
    -- Perp down set used when ForceIlvl is ON. If you use Selenian Cap for Pet:DT, you can make another set here without it.
    sets.aftercast.Avatar_DT_Ilvl = set_combine(sets.aftercast.Avatar_DT, {
    })
 
    -- DT build with avatar out. Equipped when IdleMode is "DT".
    sets.aftercast.Perp_DT = set_combine(sets.DT_Base, {
        ear2="Evans Earring",
        -- body="Udug Jacket",
        waist="Lucidity Sash"
    })
 
    -- Idle set used when you have a spirit summoned. Glyphic Spats will make them cast more frequently.
    sets.aftercast.Spirit = {
        -- main="Nirvana",
		main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
        sub="Vox Grip",
        ammo="Sancus Sachet +1",
        head="Convoker's Horn +3",
        neck="Melic Torque",
        ear1="Cath Palug Earring",
        ear2="Evans Earring",
        body="Baayami Robe +1",
        hands="Baayami Cuffs +1",
		left_ring={name="Stikini Ring +1", bag="wardrobe3"},
		right_ring="Evoker's Ring",
		back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+3','Blood Pact ab. del. II -1',}},
        waist="Lucidity Sash",
        -- legs="Glyphic Spats +3",
        feet="Baayami Sabots +1"
    }
 
    -- ===================================================================================================================
    --      End of Sets
    -- ===================================================================================================================
 
    Buff_BPs_Duration = S{'Shining Ruby','Aerial Armor','Frost Armor','Rolling Thunder','Crimson Howl','Lightning Armor','Ecliptic Growl','Glittering Ruby','Earthen Ward','Hastega','Noctoshield','Ecliptic Howl','Dream Shroud','Earthen Armor','Fleet Wind','Inferno Howl','Heavenward Howl','Hastega II','Soothing Current','Crystal Blessing','Katabatic Blades'}
    Buff_BPs_Healing = S{'Healing Ruby','Healing Ruby II','Whispering Wind','Spring Water'}
    Buff_BPs_MND = S{"Wind's Blessing"}
    Debuff_BPs = S{'Mewing Lullaby','Eerie Eye','Lunar Cry','Lunar Roar','Nightmare','Pavor Nocturnus','Ultimate Terror','Somnolence','Slowga','Tidal Roar','Diamond Storm','Sleepga','Shock Squall','Bitter Elegy','Lunatic Voice'}
    Debuff_Rage_BPs = S{'Moonlit Charge','Tail Whip'}
 
    Magic_BPs_NoTP = S{'Holy Mist','Nether Blast','Aerial Blast','Searing Light','Diamond Dust','Earthen Fury','Zantetsuken','Tidal Wave','Judgment Bolt','Inferno','Howling Moon','Ruinous Omen','Night Terror','Thunderspark','Tornado II','Sonic Buffet'}
    Magic_BPs_TP = S{'Impact','Conflag Strike','Level ? Holy','Lunar Bay'}
    Merit_BPs = S{'Meteor Strike','Geocrush','Grand Fall','Wind Blade','Heavenly Strike','Thunderstorm'}
    Physical_BPs_TP = S{'Rock Buster','Mountain Buster','Crescent Fang','Spinning Dive','Roundhouse'}
    
    ZodiacElements = S{'Fire','Earth','Water','Wind','Ice','Lightning'}
 
    --TownIdle = S{"windurst woods","windurst waters","windurst walls","port windurst","bastok markets","bastok mines","port bastok","southern san d'oria","northern san d'oria","port san d'oria","upper jeuno","lower jeuno","port jeuno","ru'lude gardens","norg","kazham","tavnazian safehold","rabao","selbina","mhaura","aht urhgan whitegate","al zahbi","nashmau","western adoulin","eastern adoulin"}
    --Salvage = S{"Bhaflau Remnants","Zhayolm Remnants","Arrapago Remnants","Silver Sea Remnants"}
 
    -- Select initial macro set and set lockstyle
    -- This section likely requires changes or removal if you aren't Pergatory
    -- Note: This doesn't change your macro set for you during play, your macros have to do that. This is just for when the Lua is loaded.
    if pet.isvalid then
        if pet.name=='Fenrir' then
            send_command('input /macro book 10;wait .1;input /macro set 2;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Ifrit' then
            send_command('input /macro book 10;wait .1;input /macro set 3;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Titan' then
            send_command('input /macro book 10;wait .1;input /macro set 4;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Leviathan' then
            send_command('input /macro book 10;wait .1;input /macro set 5;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Garuda' then
            send_command('input /macro book 10;wait .1;input /macro set 6;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Shiva' then
            send_command('input /macro book 10;wait .1;input /macro set 7;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Ramuh' then
            send_command('input /macro book 10;wait .1;input /macro set 8;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Diabolos' then
            send_command('input /macro book 10;wait .1;input /macro set 9;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Cait Sith' then
            send_command('input /macro book 11;wait .1;input /macro set 2;wait 3;input /lockstyleset '..StartLockStyle)
        elseif pet.name=='Siren' then
            send_command('input /macro book 11;wait .1;input /macro set 4;wait 3;input /lockstyleset '..StartLockStyle)
        end
    else
        send_command('input /macro book 10;wait .1;input /macro set 1;wait 3;input /lockstyleset '..StartLockStyle)
    end
    -- End macro set / lockstyle section
end
 
-- ===================================================================================================================
--      Gearswap rules below this point - Modify at your own peril
-- ===================================================================================================================
 
function pretarget(spell,action)
    if not buffactive['Muddle'] then
        -- Auto Remedy --
        if AutoRemedy and (spell.action_type == 'Magic' or spell.type == 'JobAbility') then
            if buffactive['Paralysis'] or (buffactive['Silence'] and not AutoEcho) then
                cancel_spell()
                send_command('input /item "Remedy" <me>')
            end
        end
        -- Auto Echo Drop --
        if AutoEcho and spell.action_type == 'Magic' and buffactive['Silence'] then
            cancel_spell()
            send_command('input /item "Echo Drops" <me>')
        end
    end
end
 
function precast(spell)
    if (pet.isvalid and pet_midaction() and not spell.type=="SummonerPact") or spell.type=="Item" then
        -- Do not swap if pet is mid-action. I added the type=SummonerPact check because sometimes when the avatar
        -- dies mid-BP, pet.isvalid and pet_midaction() continue to return true for a brief time.
        return
    end
    -- Spell fast cast
    if sets.precast[spell.english] then
        equip(sets.precast[spell.english])
    elseif spell.action_type=="Magic" then
        if spell.name=="Stoneskin" then
            equip(sets.precast.FC,{waist="Siegel Sash"})
        else
            equip(sets.precast.FC)
        end
    end
end
 
function midcast(spell)
    if (pet.isvalid and pet_midaction()) or spell.type=="Item" then
        return
    end
    -- BP Timer gear needs to swap here
    if (spell.type=="BloodPactWard" or spell.type=="BloodPactRage") then
        if not buffactive["Astral Conduit"] then
            equip(sets.midcast.BP)
        end
        -- If lag compensation mode is on, set up a timer to equip the BP gear.
        if LagMode then
            send_command('wait 0.5;gs c EquipBP '..spell.name)
        end
    -- Spell Midcast & Potency Stuff
    elseif sets.midcast[spell.english] then
        equip(sets.midcast[spell.english])
    elseif spell.name=="Elemental Siphon" then
        if pet.element==world.day_element and ZodiacElements:contains(pet.element) then
            if pet.element==world.weather_element then
                equip(sets.midcast.SiphonWeatherZodiac)
            else
                equip(sets.midcast.SiphonZodiac)
            end
        else
            if pet.element==world.weather_element then
                equip(sets.midcast.SiphonWeather)
            else
                equip(sets.midcast.Siphon)
            end
        end
    elseif spell.type=="SummonerPact" then
        equip(sets.midcast.Summon)
    elseif string.find(spell.name,"Cure") or string.find(spell.name,"Curaga") then
        equip(sets.midcast.Cure)
    elseif string.find(spell.name,"Protect") or string.find(spell.name,"Shell") then
        equip(sets.midcast.Enhancing,{ring2="Sheltered Ring"})
    elseif spell.skill=="Enfeebling Magic" then
        equip(sets.midcast.Enfeeble)
    elseif spell.skill=="Enhancing Magic" then
        equip(sets.midcast.Enhancing)
    elseif spell.skill=="Elemental Magic" then
        equip(sets.midcast.Nuke)
    elseif spell.action_type=="Magic" then
        equip(sets.midcast.EnmityRecast)
    else
        idle()
    end
    -- Treasure Hunter
    if THSpells:contains(spell.name) then
        equip(sets.TH)
    end
    -- Auto-cancel existing buffs
    if spell.name=="Stoneskin" and buffactive["Stoneskin"] then
        windower.send_command('cancel 37;')
    elseif spell.name=="Sneak" and buffactive["Sneak"] and spell.target.type=="SELF" then
        windower.send_command('cancel 71;')
    elseif spell.name=="Utsusemi: Ichi" and buffactive["Copy Image"] then
        windower.send_command('wait 1;cancel 66;')
    end
end
 
function aftercast(spell)
    if pet_midaction() or spell.type=="Item" then
        return
    end
    if not string.find(spell.type,"BloodPact") then
        idle()
    end
end
 
function pet_change(pet,gain)
    if (not (gain and pet_midaction())) then
        idle()
    end
end
 
function status_change(new,old)
    if new=="Idle" then
        idle()
    end
end
 
function buff_change(name,gain)
    if name=="quickening" then
        idle()
    end
    if SacTorque and name=="sleep" and gain and pet.isvalid then
        equip({neck="Sacrifice Torque"})
        disable("neck")
        if buffactive["Stoneskin"] then
            windower.send_command('cancel 37;')
        end
    end
    if SacTorque and name=="sleep" and not gain then
        enable("neck")
    end
end
 
function pet_midcast(spell)
    if not LagMode then
        equipBPGear(spell.name)
    end
end
 
function pet_aftercast(spell)
    idle()
end
 
function equipBPGear(spell)
    if spell=="Perfect Defense" then
        equip(sets.pet_midcast.SummoningMagic)
    elseif Debuff_BPs:contains(spell) then
        equip(sets.pet_midcast.MagicAcc_BP)
    elseif Buff_BPs_Healing:contains(spell) then
        equip(sets.pet_midcast.Buff_Healing)
    elseif Buff_BPs_Duration:contains(spell) then
        equip(sets.pet_midcast.Buff)
    elseif Buff_BPs_MND:contains(spell) then
        equip(sets.pet_midcast.Buff_MND)
    elseif spell=="Flaming Crush" then
        if AccMode then
            equip(sets.pet_midcast.FlamingCrush_Acc)
        else
            equip(sets.pet_midcast.FlamingCrush)
        end
    elseif ImpactDebuff and (spell=="Impact" or spell=="Conflag Strike") then
        equip(sets.pet_midcast.Impact)
    elseif Magic_BPs_NoTP:contains(spell) then
        if AccMode then
            equip(sets.pet_midcast.Magic_BP_NoTP_Acc)
        else
            equip(sets.pet_midcast.Magic_BP_NoTP)
        end
    elseif Magic_BPs_TP:contains(spell) or string.find(spell," II") or string.find(spell," IV") then
        if AccMode then
            equip(sets.pet_midcast.Magic_BP_TP_Acc)
        else
            equip(sets.pet_midcast.Magic_BP_TP)
        end
    elseif Merit_BPs:contains(spell) then
        if AccMode then
            equip(sets.pet_midcast.Magic_BP_TP_Acc)
        elseif spell=="Meteor Strike" and MeteorStrike>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        elseif spell=="Geocrush" and Geocrush>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        elseif spell=="Grand Fall" and GrandFall>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        elseif spell=="Wind Blade" and WindBlade>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        elseif spell=="Heavenly Strike" and HeavenlyStrike>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        elseif spell=="Thunderstorm" and Thunderstorm>4 then
            equip(sets.pet_midcast.Magic_BP_NoTP)
        else
            equip(sets.pet_midcast.Magic_BP_TP)
        end
    elseif Debuff_Rage_BPs:contains(spell) then
        equip(sets.pet_midcast.Debuff_Rage)
    else
        if AccMode then
            equip(sets.pet_midcast.Physical_BP_Acc)
        elseif Physical_BPs_TP:contains(spell) then
            equip(sets.pet_midcast.Physical_BP_TP)
        elseif buffactive["Aftermath: Lv.3"] then
            equip(sets.pet_midcast.Physical_BP_AM3)
        else
            equip(sets.pet_midcast.Physical_BP)
        end
    end
end
 
-- This command is called whenever you input "gs c <command>"
function self_command(command)
    IdleModeCommands = {'DD','Refresh','DT','Favor','PetDT','Zendik'}
    is_valid = command:lower()=="idle"
    
    for _, v in ipairs(IdleModeCommands) do
        if command:lower()==v:lower() then
            IdleMode = v
            send_command('console_echo "Idle Mode: ['..IdleMode..']"')
            idle()
            return
        end
    end
    if string.sub(command,1,7)=="EquipBP" then
        equipBPGear(string.sub(command,9,string.len(command)))
        return
    elseif command:lower()=="accmode" then
        AccMode = AccMode==false
        is_valid = true
        send_command('console_echo "AccMode: '..tostring(AccMode)..'"')
    elseif command:lower()=="impactmode" then
        ImpactDebuff = ImpactDebuff==false
        is_valid = true
        send_command('console_echo "Impact Debuff: '..tostring(ImpactDebuff)..'"')
    elseif command:lower()=="forceilvl" then
        ForceIlvl = ForceIlvl==false
        is_valid = true
        send_command('console_echo "Force iLVL: '..tostring(ForceIlvl)..'"')
    elseif command:lower()=="lagmode" then
        LagMode = LagMode==false
        is_valid = true
        send_command('console_echo "Lag Compensation Mode: '..tostring(LagMode)..'"')
    elseif command:lower()=="th" then
        TreasureHunter = TreasureHunter==false
        is_valid = true
        send_command('console_echo "Treasure Hunter Mode: '..tostring(TreasureHunter)..'"')
    elseif command:lower()=="meleemode" then
        if MeleeMode then
            MeleeMode = false
            enable("main","sub")
            send_command('console_echo "Melee Mode: false"')
        else
            MeleeMode = true
            equip({main="Nirvana",sub="Elan Strap +1"})
            disable("main","sub")
            send_command('console_echo "Melee Mode: true"')
        end
        is_valid = true
    elseif command=="ToggleIdle" then
        is_valid = true
        -- If you want to change the sets cycled with F9, this is where you do it
        if IdleMode=="Refresh" then
            IdleMode = "Favor"
        elseif IdleMode=="Favor" then
            IdleMode = "DT"
        elseif IdleMode=="DT" then
            IdleMode = "PetDT"
        elseif IdleMode=="PetDT" then
            IdleMode = "DD"
        else
            IdleMode = "Refresh"
        end
        send_command('console_echo "Idle Mode: ['..IdleMode..']"')
    elseif command:lower()=="lowhp" then
        -- Use for "Cure 500 HP" objectives in Omen
        equip({head="Apogee Crown +1",body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},legs="Apogee Slacks +1",feet="Apogee Pumps +1",back="Campestres's Cape"})
        return
    elseif string.sub(command:lower(),1,12)=="meteorstrike" then
        MeteorStrike = string.sub(command,13,13)
        send_command('console_echo "Meteor Strike: '..MeteorStrike..'/5"')
        is_valid = true
    elseif string.sub(command:lower(),1,8)=="geocrush" then
        Geocrush = string.sub(command,9,9)
        send_command('console_echo "Geocrush: '..Geocrush..'/5"')
        is_valid = true
    elseif string.sub(command:lower(),1,9)=="grandfall" then
        GrandFall = string.sub(command,10,10)
        send_command('console_echo "Grand Fall: '..GrandFall..'/5"')
        is_valid = true
    elseif string.sub(command:lower(),1,9)=="windblade" then
        WindBlade = +string.sub(command,10,10)
        send_command('console_echo "Wind Blade: '..WindBlade..'/5"')
        is_valid = true
    elseif string.sub(command:lower(),1,14)=="heavenlystrike" then
        HeavenlyStrike = string.sub(command,15,15)
        send_command('console_echo "Heavenly Strike: '..HeavenlyStrike..'/5"')
        is_valid = true
    elseif string.sub(command:lower(),1,12)=="thunderstorm" then
        Thunderstorm = string.sub(command,13,13)
        send_command('console_echo "Thunderstorm: '..Thunderstorm..'/5"')
        is_valid = true
    end
 
    if is_valid then
        if not midaction() and not pet_midaction() then
            idle()
        end
    else
        sanitized = command:gsub("\"", "")
        send_command('console_echo "Invalid self_command: '..sanitized..'"')
    end
end
 
-- This function is for returning to aftercast gear after an action/event.
function idle()
    --if TownIdle:contains(world.area:lower()) then
    --  return
    --end
    if pet.isvalid then
        if IdleMode=='DT' then
            equip(sets.aftercast.Perp_DT)
        elseif string.find(pet.name,'Spirit') then
            equip(sets.aftercast.Spirit)
        elseif IdleMode=='PetDT' then
            if ForceIlvl then
                equip(sets.aftercast.Avatar_DT_Ilvl)
            else
                equip(sets.aftercast.Avatar_DT)
            end
        elseif IdleMode=='Refresh' then
            if player.mpp < 50 then
                equip(sets.aftercast.Perp_RefreshSub50)
            else
                equip(sets.aftercast.Perp_Refresh)
            end
        elseif IdleMode=='Favor' then
            equip(sets.aftercast.Perp_Favor)
        elseif IdleMode=='Zendik' then
            equip(sets.aftercast.Perp_Zendik)
        elseif MeleeMode then
            equip(sets.aftercast.Perp_Melee)
        elseif IdleMode=='DD' then
            equip(sets.aftercast.Perp_DD)
        end
        -- Gaiters if Fleet Wind is up
        if buffactive['Quickening'] and IdleMode~='DT' and not ForceIlvl then
            equip({right_ring="Shneddick Ring"})
        end
    else
        if IdleMode=='DT' then
            equip(sets.aftercast.DT)
        elseif MeleeMode and IdleMode=='DD' then
            equip(sets.aftercast.Perp_Melee)
        elseif ForceIlvl then
            equip(sets.aftercast.Idle_Ilvl)
        else
            equip(sets.aftercast.Idle)
        end
    end
    -- Balrahn's Ring
    --if Salvage:contains(world.area) then
    --  equip({ring2="Balrahn's Ring"})
    --end
    -- Maquette Ring
    --if world.area=='Maquette Abdhaljs-Legion' and not IdleMode=='DT' then
    --  equip({ring2="Maquette Ring"})
    --end
end
