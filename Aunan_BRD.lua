-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]
	-- windower.send_command('lua u NyzulHelper')
	-- windower.send_command('lua u Omen')
	-- windower.send_command('lua u Plugin_Manager')
	-- windower.send_command('lua u PointWatch')
	-- windower.send_command('lua u Pouches')
	-- windower.send_command('lua u Pouches')
	-- windower.send_command('lua u RollTracker')
	-- windower.send_command('lua u THTracker')
	-- windower.send_command('lua u Treasury')
	-- windower.send_command('lua u xivbar')
	-- windower.send_command('lua u Equipviewer')
	-- windower.send_command('lua u giltracker')
	-- windower.send_command('lua u infobar')
	-- windower.send_command('lua u invtracker')
	-- windower.send_command('lua u Distance')
	-- windower.send_command('lua u DistancePlus')
	-- windower.send_command('lua u EnemyBar')
	-- windower.send_command('lua u clock')
	-- windower.send_command('lua u debuffed')
	-- windower.send_command('lua u capetrader')
	-- windower.send_command('lua u checkparam')
	-- windower.send_command('lua u azuresets')
	-- windower.send_command('lua u battlemod')
	-- windower.send_command('lua u autora')
	-- windower.send_command('lua u organizer')
	-- windower.send_command('lua u tparty')
	-- windower.send_command('lua u Parse')
	-- windower.send_command('unload FFXIDB')
	-- windower.send_command('unload infobar')	
	-- windower.send_command('unload timers')	
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
include('organizer-lib')
	send_command('wait 2;input /lockstyleset 1')	
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'Dummy', 'FullLength'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    -- For tracking current recast timers via the Timers plugin.
	
    custom_timers = {}
	
	state.Moving = M(false, "moving")
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

    state.OffenseMode:options('Normal', 'Acc', 'Hybrid')
	
    state.CastingMode:options('Normal', 'Resistant')
	
    state.IdleMode:options('Normal', 'Refresh')

    brd_daggers = S{'Izhiikoh', 'Vanir Knife', 'Atoyac', 'Aphotic Kukri', 'Sabebus'}
    pick_tp_weapon()
    
    -- Adjust this if using the Terpander (new +song instrument)
	
    info.ExtraSongInstrument = 'Daurdabla'
	
    -- How many extra songs we can keep from Daurdabla/Terpander
	
    info.ExtraSongs = 2
    
    -- Set this to false if you don't want to use custom timers.
	
    state.UseCustomTimers = M(true, 'Use Custom Timers')
    
    -- Additional local binds
	
    send_command('bind ^` gs c cycle ExtraSongsMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    sets.precast.Org = {
	main="Ternion Dagger +1",
	
	}  
    -- Precast Sets

    -- Fast cast sets for spells
	
    sets.precast.FC = {
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},	
    range={ name="Linos", augments={'"Fast Cast"+6',}},
    head="Nahtirah Hat",
    body="Inyanga Jubbah +2",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Aya. Cosciales +2",
    feet={ name="Chironic Slippers", augments={'"Mag.Atk.Bns."+4','"Fast Cast"+7','INT+6','Mag. Acc.+3',}},
    neck="Orunmila's Torque",
    waist="Witful Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Rahab Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}
	

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {

	})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
	waist="Siegel Sash"
	})

    sets.precast.FC.BardSong = {
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},	
    range={ name="Linos", augments={'"Fast Cast"+6',}},
    head="Nahtirah Hat",
    body="Inyanga Jubbah +2",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Aya. Cosciales +2",
    feet={ name="Chironic Slippers", augments={'"Mag.Atk.Bns."+4','"Fast Cast"+7','INT+6','Mag. Acc.+3',}},
    neck="Orunmila's Torque",
    waist="Witful Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Rahab Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}


    sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, {
	range=info.ExtraSongInstrument
	})
        
    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {
	feet="Bihu slippers +3"
	}
	
    sets.precast.JA.Troubadour = {
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
	}
	
    sets.precast.JA['Soul Voice'] = {	
	legs="Bihu cannions +3"
	}

    -- Waltz set (chr and vit)
	
    sets.precast.Waltz = {}
    
       
    -- Weaponskill sets
	
    -- Default set for any weaponskill that isn't any more specifically defined
	
    sets.precast.WS = {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head={ name="Lustratio Cap +1", augments={'INT+35','STR+8','DEX+8',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Lustr. Mittens +1", augments={'Accuracy+30','VIT+13','DEX+10',}},
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Mache Earring +1",
    left_ring="Ilabrat Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	
	}
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Aeolian Edge'] = {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Acuity Belt +1",
    left_ear="Regal Earring",
    right_ear="Friomisi Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
	
	}	
	
	sets.precast.WS['Evisceration'] = {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head={ name="Lustratio Cap +1", augments={'INT+35','STR+8','DEX+8',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Lustr. Mittens +1", augments={'Accuracy+30','VIT+13','DEX+10',}},
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Epaminondas's Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
	
	}
	
    sets.precast.WS['Evisceration'] = {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Ayanmo Corazza +2",
    hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet="Ayanmo gambieras +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Begrudging Ring",
    right_ring="Hetairoi Ring",
    back={ name="Intarabus's Cape", augments={'DEX+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
	}
	

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS)

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Ishvara Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},	
    right_ring="Karieyh Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
	})
	
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    range={ name="Linos", augments={'Attack+17','Weapon skill damage +3%','STR+8',}},
    head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Ifrit Ring +1",
    right_ring="Karieyh Ring +1",
    back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
	})
	
	--sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    --range={ name="Linos", augments={'Attack+17','Weapon skill damage +3%','STR+8',}},
    --head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
    --body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    --hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    --legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    --feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    --neck={ name="Bard's Charm +2", augments={'Path: A',}},
    --waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    --left_ear="Ishvara Earring",
    -- right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    --    left_ring="Ifrit Ring +1",
    --right_ring="Karieyh Ring +1",
    --back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
	--})	
    
 	sets.precast.WS['Shell Crusher'] = set_combine(sets.precast.WS, {
    range={ name="Linos", augments={'Accuracy+15 Attack+15','Weapon skill damage +3%','DEX+8',}},
    head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    neck="Bard's Charm +2",
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Digni. Earring",
    right_ear="Regal Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	})
       
    -- Midcast Sets

    -- General set for recast times.
	
    sets.midcast.FastRecast = {}
   
	sets.precast.FC["Honor March"] = set_combine(sets.precast.FC.BardSong,{
	ammo=empty,
	range="Marsyas"})

    

    -- For song buffs (duration and AF3 set bonus)
	
    sets.midcast.SongEffect = {	
    main="Carnwenhan",
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
	ammo=empty,
    range="Gjallarhorn",
    head="Fili Calot +1",
    body="Fili Hongreline +1",
    hands="Fili Manchettes +1",
    legs="Inyanga Shalwar +2",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    waist="Flume Belt +1",
    left_ear="Genmei Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}

    -- For song defbuffs (duration primary, accuracy secondary)
	
    sets.midcast.SongDebuff = {
    main="Carnwenhan",
    sub={ name="Atoyac", augments={'Mag. Acc.+30','Mag. Acc.+15',}},
    range="Gjallarhorn",
    head="Brioso Roundlet +3",
    body="Brioso Justau. +3",
    hands="Brioso Cuffs +3",
    legs="Brioso Cannions +3",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Digni. Earring",
    right_ear="Regal Earring",
    left_ring="Metamorph ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}

    -- For song defbuffs (accuracy primary, duration secondary)
	
    sets.midcast.ResistantSongDebuff = {
    main="Carnwenhan",
    sub={ name="Atoyac", augments={'Mag. Acc.+30','Mag. Acc.+15',}},
    range="Gjallarhorn",
    head="Brioso Roundlet +3",
    body="Brioso Justau. +3",
    hands="Brioso Cuffs +3",
    legs="Brioso Cannions +3",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Digni. Earring",
    right_ear="Regal Earring",
    left_ring="Metamorph ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}

    -- Gear to enhance certain classes of songs.
	
    sets.midcast.Ballad = set_combine(sets.midcast.SongEffect,{
	legs="Fili Rhingrave +1"
	})
	
    sets.midcast.Lullaby = set_combine(sets.midcast.SongDebuff, {
    body="Fili Hongreline +1",
    legs="Inyanga Shalwar +2",	
	})
	
    sets.midcast.Madrigal = sets.midcast.SongEffect
	
    sets.midcast.March = sets.midcast.SongEffect
	
    sets.midcast.Minuet = sets.midcast.SongEffect
	
    sets.midcast.Minne = sets.midcast.SongEffect
	
    sets.midcast.Paeon = sets.midcast.SongEffect
	
    sets.midcast.Carol = sets.midcast.SongEffect
	
    sets.midcast["Sentinel's Scherzo"] = sets.midcast.SongEffect
	
    sets.midcast['Magic Finale'] = sets.midcast.SongDebuff
	
    sets.midcast.Threnody = sets.midcast.SongDebuff	
	
    sets.midcast.Elegy = sets.midcast.SongDebuff	

    sets.midcast.Requiem = sets.midcast.SongDebuff		

    sets.midcast.Mazurka = set_combine(sets.midcast.SongEffect, {
	ammo=empty,
	
	range="Marsyas"	
	
	})

	sets.midcast.Dirge = set_combine(sets.midcast.SongEffect, {
	
	range="Marsyas" 
	
	})

    -- Song-specific recast reduction
	
    sets.midcast.SongRecast = {}


    -- Cast spell with normal gear, except using Daurdabla
	
    sets.midcast.DummySong = {
		ammo=empty,
		range="Daurdabla",
		legs=empty,
		neck=empty,
		feet=empty
	}

	sets.midcast["Army's Paeon"] =sets.midcast.DummySong
	sets.midcast["Army's Paeon II"] =sets.midcast.DummySong
	sets.midcast["Army's Paeon III"] =sets.midcast.DummySong
	sets.midcast["Army's Paeon IV"] =sets.midcast.DummySong
	
	
	sets.midcast["Honor March"] = set_combine(sets.midcast.SongEffect,{
	
	range="Marsyas"
	})
	
    -- Other general spells and classes.
	
    sets.midcast.Cure = {

	}
        
    sets.midcast.Curaga = sets.midcast.Cure
	
	
	sets.midcast["Enhancing Magic"] = {
	}
	
	sets.midcast['Haste'] = sets.midcast["Enhancing Magic"]
        
    sets.midcast.Stoneskin = {

	}
        
    sets.midcast.Cursna = {

	}

	sets.midcast["Horde Lullaby"] = set_combine(sets.midcast.SongDebuff,{
		body= "Fili hongreline +1",
		legs= "Inyanga shalwar +2"
	})
 

	sets.midcast["Horde Lullaby II"] = {
    main="Carnwenhan",
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    range="Daurdabla",
    head="Brioso Roundlet +3",
    body="Fili Hongreline +1",
    hands="Brioso Cuffs +3",
    legs="Inyanga Shalwar +2",
    feet="Brioso Slippers +3",
    neck="Mnbw. Whistle +1",
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Gersemi Earring",
    right_ear="Regal Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	}
	
	
    -- Sets to return to when not performing an action.
    
    -- Resting sets
	
    sets.resting = {}
    
    
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	
    sets.idle = {
	main="Carnwenhan",
	sub="Twashtar",
	ammo=empty,
    range={ name="Nibiru Harp", augments={'Mag. Evasion+20','Phys. dmg. taken -3','Magic dmg. taken -3',}},
    head="Inyanga Tiara +2",
    body="Ashera Harness",
    hands="Inyan. Dastanas +2",
    legs="Inyanga Shalwar +2",
    feet="Inyan. Crackows +2",
    neck="Warder's Charm +1",
    waist="Flume Belt +1",
    left_ear="Sanare Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
	}

    sets.idle.Refresh = {

	}

    sets.idle.Town = set_combine(sets.idle, {
	ammo=empty,
    range={ name="Linos", augments={'Accuracy+19','"Store TP"+4','Quadruple Attack +3',}},
    head="Aya. Zucchetto +2",
    body="Ashera harness",
    hands="Volte Mittens",
    legs="Volte Tights",
    feet="Volte Spats",
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
	})
    
    sets.idle.Weak = {}
    
    
    -- Defense sets

    sets.defense.PDT = {    
	ammo=empty,
    range={ name="Linos", augments={'Accuracy+19','"Store TP"+4','Quadruple Attack +3',}},
    head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
    body="Ashera Harness",
    hands="Volte Mittens",
    legs="Volte Tights",
    feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
    neck="Loricate Torque +1",
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}

    sets.defense.MDT = {

	
	}

    sets.Kiting = {
	feet="Fili Cothurnes +1",
	}

	sets.MoveSpeed = {
	feet="Fili Cothurnes +1",
	}
	
    sets.latent_refresh = {
	}

    -- Engaged sets

    
    sets.engaged = {
	ammo=empty,
    range={ name="Linos", augments={'Accuracy+19','"Store TP"+4','Quadruple Attack +3',}},
    head="Aya. Zucchetto +2",
    body="Ashera harness",
    hands="Volte Mittens",
    legs="Volte Tights",
    feet="Volte Spats",
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}


    -- Set if dual-wielding
    sets.engaged.DW = {
	ammo=empty,
    range={ name="Linos", augments={'Accuracy+19','"Store TP"+4','Quadruple Attack +3',}},
    head="Aya. Zucchetto +2",
    body="Ashera harness",
    hands="Volte Mittens",
    legs="Volte Tights",
    feet="Volte Spats",
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}

	sets.engaged.Acc = {
    range={ name="Linos", augments={'Accuracy+19','"Store TP"+4','Quadruple Attack +3',}},
    head="Aya. Zucchetto +2",
    body="Ashera Harness",
    hands={ name="Gazu Bracelet +1", augments={'Path: A',}},
    legs="Volte Tights",
    feet="Volte Spats",
    neck={ name="Bard's Charm +2", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
	sets.engaged.Hybrid = {
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
    hands={ name="Gazu Bracelet +1", augments={'Path: A',}},
    legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
    feet="Aya. Gambieras +2",
    neck="Loricate Torque +1",
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	
	}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
 
		if spell.name == 'Honor March' then
        equip({range="Marsyas"})
	end
		-- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
 
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end

        state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','ammo')
        else
            enable('main','sub','ammo')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    pick_tp_weapon()
end


-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end


-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name,expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end
    
    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).
        
        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end
        
        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        else
            local rep,repsong
            for song_name,expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "'..repsong..'"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "'..spell.name..'" '..dur..' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Aoidos' Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Aoidos' Rhing. +2" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Aoidos' Cothrn. +2" then mult = mult + 0.1 end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spellName == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
    
    local totalDuration = math.floor(mult*120)

    return totalDuration
end


-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()
    if brd_daggers:contains(player.equipment.main) then
        state.CombatWeapon:set('Dagger')
        
        if S{'NIN','DNC'}:contains(player.sub_job) and brd_daggers:contains(player.equipment.sub) then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    else
        state.CombatWeapon:reset()
        state.CombatForm:reset()
    end
end

-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(2, 18)
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

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)

