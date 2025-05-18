 include('organizer-lib') -- optional
res = require('resources')
texts = require('texts')
include('Modes.lua')

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh', 'dt', 'town')
meleeModes = M('FullHaste','FULLACC', 'dt')
nukeModes = M('normal', 'acc')

------------------------------------------------------------------------------------------------------
-- Important to read!
------------------------------------------------------------------------------------------------------
-- This will be used later down for weapon combos, here's mine for example, you can add your REMA+offhand of choice in there
-- Add you weapons in the Main list and/or sub list.
-- Don't put any weapons / sub in your IDLE and ENGAGED sets'
-- You can put specific weapons in the midcasts and precast sets for spells, but after a spell is 
-- cast and we revert to idle or engaged sets, we'll be checking the following for weapon selection. 
-- Defaults are the first in each list
mainWeapon = M("Terra's Staff", "Maxentius", "Yagrush")
subWeapon = M("Mensch Strap", "Magesmasher +1", "Sors Shield")
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
DYNA_NECK = "Cleric's Torque +2"
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1765    --important to update these if you have a smaller screen
hud_y_pos = 300     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'


-- Setup your Key Bindings here:
	windower.send_command('bind insert gs c nuke cycle')        -- insert to Cycles Nuke element
	windower.send_command('bind delete gs c nuke cycledown')    -- delete to Cycles Nuke element in reverse order   
	windower.send_command('bind f9 gs c toggle idlemode')       -- F9 to change Idle Mode    
	windower.send_command('bind f8 gs c toggle meleemode')      -- F8 to change Melee Mode  
	windower.send_command('bind !f9 gs c toggle melee') 		-- Alt-F9 Toggle Melee mode on / off, locking of weapons
	windower.send_command('bind !f8 gs c toggle mainweapon')	-- Alt-F8 Toggle Main Weapon
	windower.send_command('bind ^f8 gs c toggle subweapon')		-- CTRL-F8 Toggle sub Weapon.
	windower.send_command('bind !` input /ma Stun <t>') 		-- Alt-` Quick Stun Shortcut.
	windower.send_command('bind home gs c nuke enspellup')		-- Home Cycle Enspell Up
	windower.send_command('bind PAGEUP gs c nuke enspelldown')  -- PgUP Cycle Enspell Down
	windower.send_command('bind ^f10 gs c toggle mb')           -- F10 toggles Magic Burst Mode on / off.
	windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode
	windower.send_command('bind F10 gs c toggle matchsc')		-- CTRL-F10 to change Match SC Mode      	
	windower.send_command('bind !end gs c hud lite')            -- Alt-End to toggle light hud version       
	windower.send_command('bind ^end gs c hud keybinds')        -- CTRL-End to toggle Keybinds  
	windower.send_command('bind f11 parse report damage p')
	windower.send_command('bind ^f11 parse reset')
	windower.send_command('bind numpad- gs c toggle autows')
	windower.send_command('bind numpad* gs c toggle autosamba')
	windower.send_command('lua l superwarp')

--[[
    This gets passed in when the Keybinds is turned on.
    IF YOU CHANGED ANY OF THE KEYBINDS ABOVE, edit the ones below so it can be reflected in the hud using the "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_melee'] = '(F8)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mainweapon'] = '(ALT-F8)'
keybinds_on['key_bind_subweapon'] = '(CTRL-F8)'
keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_enspell_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_lock_weapon'] = '(ALT-F9)'
keybinds_on['key_bind_matchsc'] = '(F10)'

send_command('gs c hud hidejob')

-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')	
    send_command('unbind f9')
    send_command('unbind !f9')
    send_command('unbind f8')
    send_command('unbind !f8')
    send_command('unbind ^f8')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind !`')
    send_command('unbind home')
    send_command('unbind !f10')	
    send_command('unbind `f10')
    send_command('unbind !end')  
    send_command('unbind ^end')  	
	send_command('lua u gearinfo')
	send_command('lua u equipviewer')
	send_command('lua u parse')
	send_command('unbind f11 parse reset')
	send_command('unbind ^f11 parse reset')
end

include('WHM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,1) -- Sheet, Book
send_command('wait 10;input /lockstyleset 13')
refreshType = idleModes[1] -- leave this as is  
   
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 13')
end
-- Setup your Gear Sets below:
function get_sets()
    sets.me 		= {} -- leave this empty
	sets.buff 		= {} -- leave this empty
    sets.me.idle	= {} -- leave this empty
    sets.me.melee 	= {} -- leave this empty
    sets.weapons 	= {} -- leave this empty
--//////////////
--IDLE SETS
--//////////////	
	--USE HOTKEY TO CYCLE IDLE SETS BASED ON CONTENT. 
	--USE PDT/MDT IF FACING AN AOE HAZARD AS A CASTER. 
	--USE REFRESH ALL OTHER TIMES. 	
	--DT/PDT/MDT/BDT CAP AT 50%
	--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
	--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 

	sets.me.idle.town = {

	}	
 	sets.me.idle.refresh = {

	}
	sets.me.idle.dt = {

	}
    sets.me.resting = { 

    }
---------------
--[LATENT]-[REFRESH]
---------------
    sets.me.latent_refresh = {waist="Korin obi"} 
	sets.me.sublimation ={waist="Embla Sash"}
--//////////////
--MELEE SETS
---------------	
--Dualwield Sets
---------------
    sets.me.melee.FullHastedw = {

	}
    sets.me.melee.FULLACCdw =set_combine(sets.me.melee.FullHastedw,{})
    sets.me.melee.dtdw = set_combine(sets.me.melee.FullHastedw,{})
---------------
--1H Shield Melee
---------------
    sets.me.melee.FULLACCsw = set_combine(sets.me.melee.FULLACCdw,{})
    sets.me.melee.FullHastesw = set_combine(sets.me.melee.FullHastedw,{})
    sets.me.melee.dtsw = set_combine(sets.me.melee.dtdw,{})
--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]-[CLUB]-[BLACK HALO]-[MOD:70%MND/30%STR/P.ATTK]-[ELEMENT:Fragmentation/compression]
---------------
	sets.me["Black Halo"] = {

	}
	sets.me["Skull Breaker"] = set_combine(sets.me["Black Halo"], {})
	sets.me["True Strike"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Judgement"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Heavy Swing"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Spirit Taker"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Shell Crusher"] = set_combine(sets.me["Black Halo"], {})	
	sets.me["Retribution"] = set_combine(sets.me["Black Halo"], {})
	
	sets.me["Hexastrike"] = {

	}
	sets.me["Realmrazer"] = set_combine(sets.me["Hexastrike"], {})
	sets.me["Shattersoul"] = set_combine(sets.me["Hexastrike"], {})	
	
	sets.me["Mystic Boon"] = {

	}	
	sets.me["Flash Nova"] = {

	}
	sets.me["Shining Strike"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Seraph Strike"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Rock Crusher"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Earth Crusher"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Starburst"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Sunburst"] = set_combine(sets.me["Flash Nova"], {})
	sets.me["Cataclysm"] = set_combine(sets.me["Flash Nova"], {})

--////////////////
--Spellcasting sets
--////////////////
---------------
--[CASTING SETS]
---------------
    sets.precast			= {} --Leave This Empty
    sets.midcast 			= {} --Leave This Empty
    sets.aftercast 			= {} --Leave This Empty
    sets.midcast.nuking 	= {} --Leave This Empty
    sets.midcast.MB			= {} --Leave This Empty  
    sets.midcast.enhancing	= {} --Leave This Empty
	sets.midcast.Enfeebling = {} --Leave This Empty
	sets.midcast.cure 		= {} --Leave This Empty
	sets.midcast.Curaga		= {}

    sets.precast.casting = {
		main="C. Palug Hammer",
		sub="Culminus",
		ammo="Sapience Orb",
		head="C. Palug Crown",
		body="Zendik Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet="Regal Pumps",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Malignance Earring",
		left_ring="Rahab Ring",
		right_ring="Kishar Ring",
		back="Moonbeam Cape",
    }											
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
    sets.precast["Dispelga"] = set_combine(sets.precast.casting,{main = "Daybreak",})
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
    sets.precast.cure =  set_combine(sets.precast.casting ,{

	})
	sets.precast.StatusRemoval = set_combine(sets.precast.casting ,{})
	sets.precast.Raise = set_combine(sets.precast.casting,{
		
	})
	sets.precast.Reraise = set_combine(sets.precast.casting,{		

	})
	sets.precast.Teleport = set_combine(sets.precast.casting,{

	})	
--//////////////////
--MIDCASTING
    sets.midcast.Dispelga = set_combine(sets.midcast.Enfeebling.macc ,{main = "Daybreak", sub="Ammurapi Shield"})
    sets.midcast.Obi 		= {Waist = "Hachirin-no-obi"}
    sets.midcast.Orpheus	= {}  
    sets.midcast.casting 	= {

	}
    sets.midcast['Dispel'] 	= set_combine( sets.midcast.casting,{})	
    sets.midcast.nuking.normal = {

	}
    sets.midcast.MB.normal 	= set_combine(sets.midcast.nuking.normal, {})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal, {
	})
    sets.midcast.MB.acc 	= set_combine(sets.midcast.nuking.acc, {})	
	sets.midcast.Holy		= set_combine(sets.midcast.nuking.normal, {})
	sets.midcast.Banish		= set_combine(sets.midcast.nuking.normal, {

	})
    sets.midcast.Drain 		= set_combine( sets.midcast.casting,{})	
    sets.midcast.Aspir 		= set_combine( sets.midcast.casting,{})	
    sets.midcast.Enfeebling.macc = {

	}
    sets.midcast.Enfeebling.potency = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.mndpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.skillmndpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.intpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.skillpot = set_combine(sets.midcast.Enfeebling.macc,{})
	sets.midcast["Stun"] = set_combine( sets.midcast.casting,{})	
    sets.midcast.enhancing.potency = {
		main="C. Palug Hammer",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head="Befouled Crown",
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Perimede Cape",
	}   
	sets.midcast.enhancing.duration = set_combine(sets.midcast.enhancing.potency, {
		main="C. Palug Hammer",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Perimede Cape",
	})
    sets.midcast.phalanx = set_combine(sets.midcast.enhancing.potency,{})
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.potency, {})
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {waist = "Gishdubar Sash"})
    sets.midcast.aquaveil =set_combine(sets.midcast.enhancing.duration, {head = "Chironic Hat"})
    sets.midcast.protect = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
    sets.midcast.shell = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
	sets.midcast.BarElement = {

	}
    sets.midcast.cure.normal = {
		main="Iridal Staff",
		sub="Enki Strap",
		ammo="Sapience Orb",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Tuisto Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    }
    sets.midcast.Curaga.normal = {
		main="Iridal Staff",
		sub="Enki Strap",
		ammo="Sapience Orb",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Tuisto Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    }
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{ waist="Korin Obi"})
    sets.midcast.Curaga.weather = set_combine(sets.midcast.Curaga.normal,{ waist="Korin Obi"})     
	sets.midcast.regen ={

    }
	sets.midcast.Raise ={ 

	}
	sets.midcast.Reraise ={

	}
	sets.midcast.Erase ={

	}

	sets.midcast.StatusRemoval={

	}
	sets.midcast.Cursna ={

	}
end