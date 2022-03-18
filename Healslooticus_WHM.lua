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
	
	windower.send_command('lua u NyzulHelper')
	windower.send_command('lua u Omen')
	windower.send_command('lua u Plugin_Manager')
	windower.send_command('lua u PointWatch')
	windower.send_command('lua u RollTracker')
	windower.send_command('lua u THTracker')
	windower.send_command('lua u xivbar')
	windower.send_command('lua u equipviewer')
	windower.send_command('lua u giltracker')
	windower.send_command('lua u infobar')
	windower.send_command('lua u invtracker')
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
	windower.send_command('lua u partybuffs')	

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
		ammo="Staunch Tathlum",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Bunzi's Gloves",
		legs={ name="Chironic Hose", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Enmity-4','Quadruple Attack +3','Accuracy+1 Attack+1','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
		feet={ name="Chironic Slippers", augments={'INT+9','CHR+5','Quadruple Attack +2','Accuracy+4 Attack+4',}},
		neck="Sanctity Necklace",
		waist="Windbuffet Belt",
		left_ear="Brutal Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		right_ring="Rajas Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-6%',}},	
	}	
 	sets.me.idle.refresh = {
		ammo="Staunch Tathlum",
		head="Inyanga Tiara +2",
		body="Theo. Bliaut +3",
		hands="Inyan. Dastanas +2",
		legs="Assid. Pants +1",
		feet="Inyan. Crackows +2",
		neck="Loricate Torque +1",
		waist="Porous Rope",
		left_ear="Hearty Earring",
		right_ear="Eabani Earring",
		left_ring="Inyanga Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+5','Enmity-10','Phys. dmg. taken-10%',}},
	}
	sets.me.idle.dt = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",		
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",	
		neck="Loricate Torque +1",
		waist="Porous Rope",
		left_ear="Hearty Earring",
		right_ear="Eabani Earring",
		left_ring="Inyanga Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+5','Enmity-10','Phys. dmg. taken-10%',}},
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
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Bunzi's Gloves",
		legs="Aya. Cosciales +2",
		feet={ name="Chironic Slippers", augments={'INT+9','CHR+5','Quadruple Attack +2','Accuracy+4 Attack+4',}},
		neck="Sanctity Necklace",
		waist="Shetal Stone",
		left_ear="Brutal Earring",
		right_ear="Suppanomimi",
		left_ring="Petrov Ring",
		right_ring="Rajas Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-6%',}},
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
		ammo="Floestone",
		head={ name="Piety Cap +3", augments={'Enhances "Devotion" effect',}},
		body={ name="Piety Bliaut +3", augments={'Enhances "Benediction" effect',}},
		hands={ name="Piety Mitts +3", augments={'Enhances "Martyr" effect',}},
		legs={ name="Piety Pantaln. +3", augments={'Enhances "Afflatus Misery" effect',}},
		feet={ name="Piety Duckbills +3", augments={'Enhances "Afflatus Solace" effect',}},
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Brutal Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Apate Ring",
		right_ring="Rajas Ring",
		back={ name="Alaunus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+5','Weapon skill damage +10%',}},	
	}
	sets.me["Skull Breaker"] = set_combine(sets.me["Black Halo"], {})
	sets.me["True Strike"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Judgement"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Heavy Swing"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Spirit Taker"] = set_combine(sets.me["Black Halo"], {})
	sets.me["Shell Crusher"] = set_combine(sets.me["Black Halo"], {})	
	sets.me["Retribution"] = set_combine(sets.me["Black Halo"], {})
	
	sets.me["Hexastrike"] = {
		ammo="Floestone",
		head={ name="Piety Cap +3", augments={'Enhances "Devotion" effect',}},
		body={ name="Piety Bliaut +3", augments={'Enhances "Benediction" effect',}},
		hands={ name="Piety Mitts +3", augments={'Enhances "Martyr" effect',}},
		legs={ name="Piety Pantaln. +3", augments={'Enhances "Afflatus Misery" effect',}},
		feet={ name="Piety Duckbills +3", augments={'Enhances "Afflatus Solace" effect',}},
		neck="Sanctity Necklace",
		waist="Prosilio Belt +1",
		left_ear="Brutal Earring",
		right_ear="Assuage Earring",
		left_ring="Apate Ring",
		right_ring="Rufescent Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-6%',}},	
	}
	sets.me["Realmrazer"] = set_combine(sets.me["Hexastrike"], {})
	sets.me["Shattersoul"] = set_combine(sets.me["Hexastrike"], {})	
	
	sets.me["Mystic Boon"] = {
		ammo="Floestone",
		head="Nyame Helm",		
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",		
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Aredan Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Apate Ring",
		right_ring="Rajas Ring",
		back={ name="Alaunus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+5','Weapon skill damage +10%',}},
	}	
	sets.me["Flash Nova"] = {
		ammo="Hydrocera",
		head="Bunzi's Hat",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Sortiarius Earring",
		right_ear="Friomisi Earring",
		left_ring="Rufescent Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+5','Weapon skill damage +10%',}},	
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
		main="Terra's Staff",
		sub="Clerisy Strap",
		ammo="Staunch Tathlum",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -3%','"Cure" spellcasting time -5%',}},
		legs="Aya. Cosciales +2",
		feet="Regal Pumps +1",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Mendi. Earring",
		left_ring="Prolix Ring",
		right_ring="Evanescence Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }											
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
    sets.precast["Dispelga"] = set_combine(sets.precast.casting,{main = "Daybreak",})
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
    sets.precast.cure =  set_combine(sets.precast.casting ,{
		main="Ababinili +1",
		left_ear="Mendi. Earring",
		right_ear="Nourish. Earring +1",	
	})
	sets.precast.StatusRemoval = set_combine(sets.precast.casting ,{})
	sets.precast.Raise = set_combine(sets.precast.casting,{
		sub="Clemency Grip",
		ammo="Impatiens",
		right_ring="Lebeche Ring",
		waist="Witful Belt",
		back="Perimede Cape",		
	})
	sets.precast.Reraise = set_combine(sets.precast.casting,{		
		sub="Clemency Grip",
		ammo="Impatiens",
		right_ring="Lebeche Ring",
		waist="Witful Belt",
		back="Perimede Cape",
	})
	sets.precast.Teleport = set_combine(sets.precast.casting,{
		sub="Clemency Grip",
		ammo="Impatiens",
		right_ring="Lebeche Ring",
		waist="Witful Belt",
		back="Perimede Cape",
	})	
--//////////////////
--MIDCASTING
    sets.midcast.Dispelga = set_combine(sets.midcast.Enfeebling.macc ,{main = "Daybreak", sub="Ammurapi Shield"})
    sets.midcast.Obi 		= {Waist = "Hachirin-no-obi"}
    sets.midcast.Orpheus	= {}  
    sets.midcast.casting 	= {
		main="Maxentius",
		sub="Sors Shield",
		ammo="Hydrocera",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sanctity Necklace",
		waist="Luminary Sash",
		left_ear="Hearty Earring",
		right_ear="Eabani Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    sets.midcast['Dispel'] 	= set_combine( sets.midcast.casting,{})	
    sets.midcast.nuking.normal = {
			main="Maxentius",
		sub="Sors Shield",
		ammo="Hydrocera",
		head="Bunzi's Hat",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Sortiarius Earring",
		right_ear="Friomisi Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    sets.midcast.MB.normal 	= set_combine(sets.midcast.nuking.normal, {})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal, {
	})
    sets.midcast.MB.acc 	= set_combine(sets.midcast.nuking.acc, {})	
	sets.midcast.Holy		= set_combine(sets.midcast.nuking.normal, {})
	sets.midcast.Banish		= set_combine(sets.midcast.nuking.normal, {
		hands={ name="Piety Mitts +3", augments={'Enhances "Martyr" effect',}},
		neck="Jokushu Chain",	
	})
    sets.midcast.Drain 		= set_combine( sets.midcast.casting,{})	
    sets.midcast.Aspir 		= set_combine( sets.midcast.casting,{})	
    sets.midcast.Enfeebling.macc = {
		main="Maxentius",
		sub="Sors Shield",
		ammo="Hydrocera",
		head="Inyanga Tiara +2",
		body="Theo. Bliaut +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Chironic Hose",
		feet={ name="Piety Duckbills +3", augments={'Enhances "Afflatus Solace" effect',}},
		neck="Sanctity Necklace",
		waist="Luminary Sash",
		left_ear="Aredan Earring",
		right_ear="Eabani Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},	
	}
    sets.midcast.Enfeebling.potency = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.mndpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.skillmndpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.intpot = set_combine(sets.midcast.Enfeebling.macc,{})
    sets.midcast.Enfeebling.skillpot = set_combine(sets.midcast.Enfeebling.macc,{})
	sets.midcast["Stun"] = set_combine( sets.midcast.casting,{})	
    sets.midcast.enhancing.potency = {
		main="Terra's Staff",
		sub="Clerisy Strap",
		ammo="Staunch Tathlum",
		head="Befouled Crown",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs={ name="Piety Pantaln. +3", augments={'Enhances "Afflatus Misery" effect',}},
		feet="Theo. Duckbills +2",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}   
	sets.midcast.enhancing.duration = set_combine(sets.midcast.enhancing.potency, {
		feet="Theo. Duckbills +2",
		waist="Embla Sash",
	})
    sets.midcast.phalanx = set_combine(sets.midcast.enhancing.potency,{})
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.potency, {})
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {waist = "Gishdubar Sash"})
    sets.midcast.aquaveil =set_combine(sets.midcast.enhancing.duration, {head = "Chironic Hat"})
    sets.midcast.protect = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
    sets.midcast.shell = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
	sets.midcast.BarElement = {
		main="Maxentius",
		sub="Sors Shield",
		ammo="Staunch Tathlum",
		head="Ebers Cap +1",
		body="Ebers Bliaut +1",
		hands="Ebers Mitts +1",
		legs={ name="Piety Pantaln. +3", augments={'Enhances "Afflatus Misery" effect',}},
		feet="Theo. Duckbills +2",
		neck="Loricate Torque +1",
		waist="Olympus Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back="Perimede Cape",	
	}
    sets.midcast.cure.normal = {
		main="Chatoyant Staff",
		sub="Mensch Strap",
		ammo="Staunch Tathlum",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body="Ebers Bliaut +1",
		hands="Theophany Mitts +2",
		legs="Ebers Pant. +1",
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Korin Obi",
		left_ear="Nourish. Earring +1",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
    sets.midcast.Curaga.normal = {
		main="Chatoyant Staff",
		sub="Mensch Strap",
		ammo="Staunch Tathlum",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body="Theo. Bliaut +3",
		hands="Theophany Mitts +2",
		legs="Ebers Pant. +1",
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Korin Obi",
		left_ear="Nourish. Earring +1",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{ waist="Korin Obi"})
    sets.midcast.Curaga.weather = set_combine(sets.midcast.Curaga.normal,{ waist="Korin Obi"})     
	sets.midcast.regen ={
		main="Chatoyant Staff",
		sub="Mensch Strap",
		ammo="Impatiens",
		head="Inyanga Tiara +2",
		body="Piety Bliaut +3",
		hands="Ebers Mitts +1",
		waist="Embla Sash",
		legs="Th. Pantaloons +2",
		feet="Theo. Duckbills +2",
		left_ear="Assuage Earring",
		right_ear="Eabani Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
	sets.midcast.Raise ={ 
		main="Terra's Staff",
		sub="Clerisy Strap",
		ammo="Staunch Tathlum",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -3%','"Cure" spellcasting time -5%',}},
		legs="Aya. Cosciales +2",
		feet="Regal Pumps +1",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast.Reraise ={
			main="Terra's Staff",
		sub="Clerisy Strap",
		ammo="Staunch Tathlum",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -3%','"Cure" spellcasting time -5%',}},
		legs="Aya. Cosciales +2",
		feet="Regal Pumps +1",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast.Erase ={
		main="Yagrush",
		ammo="Staunch Tathlum",
		head="Ebers Cap +1",
		body="Inyanga Jubbah +2",
		hands="Gende. Gages +1",
		legs="Aya. Cosciales +2",
		feet="Regal Pumps +1",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}

	sets.midcast.StatusRemoval={
		main="Yagrush",
		ammo="Staunch Tathlum",
		head="Ebers Cap +1",
		body="Inyanga Jubbah +2",
		hands="Ebers Mitts +1",
		legs="Aya. Cosciales +2",
		feet="Regal Pumps +1",
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Eabani Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast.Cursna ={
		main="Yagrush",
		ammo="Staunch Tathlum",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body="Ebers Bliaut +1",
		hands="Inyan. Dastanas +2",
		legs="Th. Pantaloons +2",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Malison Medallion",
		waist="Embla Sash",
		left_ear="Beatific Earring",
		right_ear="Eabani Earring",
		left_ring="Menelaus's Ring",
		right_ring="Ephedra Ring",
		back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+5','Enmity-10','Phys. dmg. taken-10%',}},	
	}
end