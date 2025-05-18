include('organizer-lib')
include('Modes.lua')
res = require('resources')
texts = require('texts')

send_command('input //send @all lua l superwarp') 

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei","Toolbag (Shihe)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

send_command('wait 3;input //gs org')
add_to_chat(8,'REMEMBER TO REPACK GEAR') 

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('Recover','DT','PreBuff')
meleeModes = M('DPS','Hybrid','ACC')
nukeModes = M('normal', 'acc')
wsModes = M('Min','Max')

------------------------------------------------------------------------------------------------------
-- Important to read!
------------------------------------------------------------------------------------------------------
-- This will be used later down for weapon combos, here's mine for example, you can add your REMA+offhand of choice in there
-- Add you weapons in the Main list and/or sub list.
-- Don't put any weapons / sub in your IDLE and ENGAGED sets'
-- You can put specific weapons in the midcasts and precast sets for spells, but after a spell is 
-- cast and we revert to idle or engaged sets, we'll be checking the following for weapon selection. 
-- Defaults are the first in each list
mainWeapon = M('Apocalypse','Montante +1','Naegling','Loxotic Mace +1','Dolichenus','Lycurgos','Hepatizon Axe +1')
subWeapon = M('Utu Grip','Blurred Shield +1')
WeaponSet1={'Apocalypse','Utu Grip'}
WeaponSet2={'Montante +1','Utu Grip'}
WeaponSet3={'Hepatizon Axe +1','Utu Grip'}
WeaponSet4={'Dolichenus','Blurred Shield +1'}
WeaponSet5={'Naegling','Blurred Shield +1'}
WeaponSet6={'Loxotic Mace +1','Blurred Shield +1'}
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
DYNA_NECK = ""
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1560    --important to update these if you have a smaller screen
hud_y_pos = 300     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 8
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
	windower.send_command('bind home gs c nuke enspellup')		-- Home Cycle Enspell Up
	windower.send_command('bind PAGEUP gs c nuke enspelldown')  -- PgUP Cycle Enspell Down
	windower.send_command('bind ^f10 gs c toggle mb')           -- F10 toggles Magic Burst Mode on / off.
	windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode
	windower.send_command('bind F10 gs c toggle matchsc')		-- CTRL-F10 to change Match SC Mode      	
	windower.send_command('bind !end gs c hud lite')            -- Alt-End to toggle light hud version       
	windower.send_command('bind ^end gs c hud keybinds')        -- CTRL-End to toggle Keybinds  
	windower.send_command('bind f11 parse report damage p')
	windower.send_command('bind ^f11 parse reset')
	windower.send_command('bind f12 gs c schere')
	windower.send_command('bind numpad1 gs c WS1')
	windower.send_command('bind numpad2 gs c WS2')
	windower.send_command('bind numpad3 gs c WS3')
	windower.send_command('bind numpad4 gs c WS4')
	windower.send_command('bind numpad5 gs c WS5')
	windower.send_command('bind numpad6 gs c WS6')
	windower.send_command('bind numpad* gs c toggle wsModes')
	windower.send_command('bind numpad0 input /ma Stun <t>')
	windower.send_command('bind numpad. input /ja "Weapon Bash" <t>')
	
	send_command('unbind ^r')
	
--[[
    This gets passed in when the Keybinds is turned on.
    IF YOU CHANGED ANY OF THE KEYBINDS ABOVE, edit the ones below so it can be reflected in the hud using the "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_melee'] = '(F8)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_wsMode'] = '(NUM *)'
keybinds_on['key_bind_schere_lock'] = '(F12)'
keybinds_on['key_bind_mainweapon'] = '(ALT-F8)'
keybinds_on['key_bind_subweapon'] = '(CTRL-F8)'
keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_enspell_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_lock_weapon'] = '(ALT-F9)'
keybinds_on['key_bind_matchsc'] = '(F10)'
keybinds_on['key_bind_schere'] = '(F12)'

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
	send_command('unbind numpad*')	
	send_command('lua u gearinfo')
	send_command('lua u equipviewer')
	send_command('lua u parse')
	send_command('unbind f11 parse reset')
	send_command('unbind ^f11 parse reset')
	windower.send_command('unbind numpad1')
	windower.send_command('unbind numpad2')
	windower.send_command('unbind numpad3')
	windower.send_command('unbind numpad4')
	windower.send_command('unbind numpad5')
	windower.send_command('unbind numpad6')
end

include('DRK_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,18) -- Sheet, Book
send_command('wait 10;input /lockstyleset 17')
refreshType = idleModes[1] -- leave this as is  
  
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 17')
end
-- Setup your Gear Sets below:
function get_sets()
--///////////////////
--Gear Sets
--///////////////////
	--This creates a constant of whole armor sets, so that when you upgrade a piece, its much simpler, 
	--and upgrades that piece through all of your sets. 
	--ADD +1/2 TO ARMOR SET TO UPGRADE IT. 
	--ADD NEW .TYPE TO CREATE AUGMENT VARIATIONS OF THE SAME PIECE. 
	--EG. SUC.TP ={name="",augments={}}
	--SOME ARMOR SETS USE ABREVIATIONS FOR THEIR +1/2/3 VARIANTS. 
	--MAKE SURE YOU USE THE ABREVIATED FORMAT. E.G "Atro. Chapeau +1"
---------------
--GENERIC SETS
---------------
    sets.me = {}        		-- leave this empty
	sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty
    sets.me.melee = {}          -- leave this empty
    sets.weapons = {}			-- leave this empty
	sets.schere={left_ear="Schere Earring"}
--//////////////
--IDLE SETS
--//////////////	
	--USE HOTKEY TO CYCLE IDLE SETS BASED ON CONTENT. 
	--USE PDT/MDT IF FACING AN AOE HAZARD AS A CASTER. 
	--USE REFRESH ALL OTHER TIMES. 	
	--DT/PDT/MDT/BDT CAP AT 50%
	--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
	--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 
---------------
--[IDLE]
---------------
 	sets.me.idle.Recover = {
		ammo="Staunch Tathlum +1",
		body="Lugra Cloak +1",
		hands="Sakpata's Gauntlets",
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Infused Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
	}		

	sets.me.idle.DT={
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Warder's Charm +1",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
		back="Moonbeam Cape",
	}
	sets.me.idle.PreBuff = {
		ammo="Staunch Tathlum +1",
		head={ name="Yorium Barbuta", augments={'Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'Phalanx +3',}},
		hands={ name="Yorium Gauntlets", augments={'Phalanx +3',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Yorium Sabatons", augments={'Phalanx +3',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Earthcry Earring",
		right_ear="Tuisto Earring",
		left_ring="Sheltered Ring",
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",	
	}
---------------
--[RESTING]
---------------
    sets.me.resting = {}
---------------
--[LATENT]-[REFRESH]
---------------
    sets.me.latent_refresh = {waist="Fucho-no-obi"}  

--//////////////
--MELEE SETS
--//////////////
	--USE HOTKEY TO CYCLE MELEE SETS BASED ON CONTENT. 
	--USE ACC WHEN YOU CANT HIT, AND PDT/MDT IF FACING AN AOE HAZARD	
	--DT/PDT/MDT/BDT CAP AT 50%
		--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
		--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 
	--NOTE:DONT DISCOUNT SWORD AND BOARD SUB PLD/WAR/BLU TANKING, OR /THF FARMING. 
---------------
--[MELEE]-[DUALWIELD]-[DPS]
---------------
    sets.me.melee.DPSdw = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet="Flam. Gambieras +2",
		neck="Asperity Necklace",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
---------------
--[MELEE]-[SWORD&BOARD]-[DPS]
---------------
    sets.me.melee.DPSsw = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet="Flam. Gambieras +2",
		neck="Asperity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
---------------
--[MELEE]-[SWORD&BOARD]-[AM3 DPS]
---------------
    sets.me.melee.DPSAM3 = {
	
    }
---------------
--[MELEE]-[DUALWIELD]-[Hybrid]
---------------
    sets.me.melee.Hybriddw ={
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck="Asperity Necklace",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Brutal Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
---------------
--[MELEE]-[SWORD&BOARD]-[Hybrid]
---------------
    sets.me.melee.Hybridsw = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck="Asperity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
---------------
--[MELEE]-[SWORD&BOARD]-[AM3 Hybrid]
---------------
    sets.me.melee.HybridAM3 = {

    }
---------------
--[MELEE]-[DUALWIELD]-[ACC]
---------------
    sets.me.melee.ACCdw ={
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet="Flam. Gambieras +2",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Telos Earring",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
---------------
--[MELEE]-[DUALWIELD]-[ACC]
---------------

    sets.me.melee.ACCsw ={
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet="Sakpata's Leggings",
		neck="Sanctity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear="Telos Earring",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
---------------
--[MELEE]-[DUALWIELD]-[ACC]
---------------
    sets.me.melee.ACCAM3 ={

	}

--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]-[Base]-[Physical]
---------------
	sets.me.STRWSD = {}
	sets.me["Slice"]={}
	sets.me["Spinning Scythe"]= {}
	sets.me["Cross Reaper"]   = {}
	sets.me["Spiral Hell"] 	  = {}
	sets.me["Catastrophe"] 	  = {}
	sets.me["Quietus"] 		  = {}
	sets.me["Hard Slash"] 	  = {}
	sets.me["Sickle Moon"] 	  = {}
	sets.me["Spinning Slash"] = {}
	sets.me["Ground Strike"]  = {}
	sets.me["Torcleaver"]	  = {}
	sets.me["Raging Axe"]  	  = {}
	sets.me["Smash Axe"] 	  = {}
	sets.me["Avalanche Axe"]  = {}
	sets.me["Spinning Axe"]   = {}
	sets.me["Bora Axe"]  	  = {}
	sets.me["Shield Break"]   = {}
	sets.me["Iron Tempest"]   = {}
	sets.me["Sturmwind"]  	  = {}
	sets.me["Armor Break"]    = {}
	sets.me["Weapon Break"]   = {}
	sets.me["Full Break"]	  = {}
	sets.me["Upheaval"]	  	  = {}
	sets.me["Fell Cleave"]	  = {}
	sets.me["Steel Cyclone"]  = {}
    sets.me["Savage Blade"]	  = {}
	sets.me["Fast Blade"]	  = {}
	sets.me["Flat Blade"]	  = {}
	sets.me["Circle Blade"]	  = {}
	sets.me["Brain Shaker"]	  = {}
	sets.me["Skull Breaker"]  = {}
	sets.me["Truestrike"]	  = {}
	sets.me["Judgment"]		  = {}

	sets.me.STRWSD.Min = {
		ammo		= "Knobkierrie",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Heath. Sollerets +3",
		neck		= "Rep. Plat. Medal",
		waist		= "Sailfi Belt +1",
		left_ear	={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear	={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring	= "Epaminondas's Ring",
		right_ring	= "Niqmaddu Ring",
		back		={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
	sets.me.STRWSD.MAX = {
		ammo		= "Knobkierrie",
		head		= "Heath. Bur. +3",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Sakpata's Cuisses",
		feet		= "Heath. Sollerets +3",
		neck		= "Rep. Plat. Medal",
		waist		= "Sailfi Belt +1",
		left_ear	={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear	={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring	= "Epaminondas's Ring",
		right_ring	= "Niqmaddu Ring",
		back		={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}	
---------------
--[WEAPONSKILL]-[Scythe]-[Physical]
---------------
	sets.me["Slice"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Scythe"].Min = set_combine(sets.me.STRWSD.Min ,{})
	sets.me["Cross Reaper"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Spiral Hell"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Catastrophe"].Min = set_combine(sets.me.STRWSD.Min ,{})
	sets.me["Quietus"].Min = set_combine(sets.me.STRWSD.Min ,{})
	
	sets.me["Slice"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Scythe"].Max = set_combine(sets.me.STRWSD.Max ,{})
	sets.me["Cross Reaper"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Spiral Hell"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Catastrophe"].Max = set_combine(sets.me.STRWSD.Max ,{})
	sets.me["Quietus"].Max = set_combine(sets.me.STRWSD.Max ,{})


---------------
--[WEAPONSKILL]-[Great Sword]-[Physical]
---------------
	sets.me["Hard Slash"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Sickle Moon"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Slash"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Ground Strike"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Torcleaver"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring", right_ring="Niqmaddu Ring"})
	
	sets.me["Hard Slash"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Sickle Moon"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Slash"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Ground Strike"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Torcleaver"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring", right_ring="Niqmaddu Ring"})
---------------
--[WEAPONSKILL]-[Axe]-[Physical]
---------------
	sets.me["Raging Axe"].Min 	 = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Smash Axe"].Min 	 = set_combine(sets.me.STRWSD.Min ,{})
	sets.me["Avalanche Axe"].Min = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Axe"].Min  = set_combine(sets.me.STRWSD.Min ,{right_ear="Moonshade Earring"})
	sets.me["Bora Axe"].Min 	 = set_combine(sets.me.STRWSD.Min ,{})

	sets.me["Raging Axe"].Max 	 = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Smash Axe"].Max 	 = set_combine(sets.me.STRWSD.Max ,{})
	sets.me["Avalanche Axe"].Max = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Spinning Axe"].Max  = set_combine(sets.me.STRWSD.Max ,{right_ear="Moonshade Earring"})
	sets.me["Bora Axe"].Max 	 = set_combine(sets.me.STRWSD.Max ,{})
---------------
--[WEAPONSKILL]-[Great Axe]-[Physical]
---------------
	sets.me["Shield Break"].Min  = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Iron Tempest"].Min  = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring"})
	sets.me["Sturmwind"].Min 	 = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring"})
	sets.me["Armor Break"].Min   = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Weapon Break"].Min  = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Full Break"].Min 	 = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Upheaval"].Min 	 = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring",right_ring="Niqmaddu Ring"})
	sets.me["Fell Cleave"].Min 	 = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring"})
	sets.me["Steel Cyclone"].Min = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring"})

	sets.me["Shield Break"].Max  = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Iron Tempest"].Max  = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring"})
	sets.me["Sturmwind"].Max 	 = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring"})
	sets.me["Armor Break"].Max   = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Weapon Break"].Max  = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Full Break"].Max 	 = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Upheaval"].Max 	 = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring",right_ring="Niqmaddu Ring"})
	sets.me["Fell Cleave"].Max 	 = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring"})
	sets.me["Steel Cyclone"].Max = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring"})
---------------
--[WEAPONSKILL]-[SWORD]-[Physical]
---------------	
    sets.me["Savage Blade"].Min  = set_combine(sets.me.STRWSD.Min, {right_ear="Moonshade Earring"})
	sets.me["Fast Blade"].Min 	 = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Flat Blade"].Min 	 = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Circle Blade"].Min  = set_combine(sets.me.STRWSD.Min, {})
	
    sets.me["Savage Blade"].Max  = set_combine(sets.me.STRWSD.Max, {right_ear="Moonshade Earring"})
	sets.me["Fast Blade"].Max 	 = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Flat Blade"].Max 	 = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Circle Blade"].Max  = set_combine(sets.me.STRWSD.Max, {})
---------------
--[WEAPONSKILL]-[CLUB]-[Physical]
---------------
	sets.me["Brain Shaker"].Min  = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Skull Breaker"].Min = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Truestrike"].Min 	 = set_combine(sets.me.STRWSD.Min, {})
	sets.me["Judgment"].Min 	 = set_combine(sets.me.STRWSD.Min, {})

	sets.me["Brain Shaker"].Max  = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Skull Breaker"].Max = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Truestrike"].Max 	 = set_combine(sets.me.STRWSD.Max, {})
	sets.me["Judgment"].Max 	 = set_combine(sets.me.STRWSD.Max, {})


---------------
--[WEAPONSKILL]-[BASE]-[MULTIHIT]
---------------
	sets.me["Guillotine"]={}
	sets.me["Entropy"]={}
	sets.me["Insurgency"]={}
	sets.me["Resolution"]={}
	sets.me["Decimation"]={}
	sets.me["Ruinator"]={}
	sets.me["Swift Blade"]={}
	sets.me["Requiescat"]={}

	sets.me.MULTI = {
		ammo="Knobkierrie",
		head="Fall. Burgeonet +3",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet="Heath. Sollerets +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
---------------
--[WEAPONSKILL]-[Scythe]-[MULTI]
---------------
	sets.me["Guillotine"].Min = set_combine(sets.me.MULTI ,{})
	sets.me["Entropy"].Min = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
	sets.me["Insurgency"].Min = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
	
	sets.me["Guillotine"].Max = set_combine(sets.me.MULTI ,{})
	sets.me["Entropy"].Max = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
	sets.me["Insurgency"].Max = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
---------------
--[WEAPONSKILL]-[Great Sword]-[Physical]
---------------
	sets.me["Resolution"].Min = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
	
	sets.me["Resolution"].Max = set_combine(sets.me.MULTI ,{right_ear="Moonshade Earring"})
---------------
--[WEAPONSKILL]-[Axe]-[Physical]
---------------
	sets.me["Decimation"].Min = set_combine(sets.me.MULTI ,{})
	sets.me["Ruinator"].Min = set_combine(sets.me.MULTI ,{})
	
	sets.me["Decimation"].Max = set_combine(sets.me.MULTI ,{})
	sets.me["Ruinator"].Max = set_combine(sets.me.MULTI ,{})
---------------
--[WEAPONSKILL]-[SWORD]-[Physical]
---------------	
	sets.me["Swift Blade"].Min = set_combine(sets.me.MULTI ,{})
	sets.me["Requiescat"].Min = set_combine(sets.me.MULTI ,{})
	
	sets.me["Swift Blade"].Max = set_combine(sets.me.MULTI ,{})
	sets.me["Requiescat"].Max = set_combine(sets.me.MULTI ,{})
---------------
--[WEAPONSKILL]-[BASE]-[CRIT]
---------------
	sets.me["Vorpal Scythe"]= {}
	sets.me["Power Slash"] 	= {}
	sets.me["Rampage"] 		= {}
	sets.me["Keen Edge"] 	= {}
	sets.me["Vorpal Blade"] = {}
	
	sets.me.CRIT = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Hjarrandi Breast.",
		hands="Flam. Manopolas +2",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring="Lehko's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}
---------------
--[WEAPONSKILL]-[Scythe]-[CRIT]
---------------
	sets.me["Vorpal Scythe"].Min = set_combine(sets.me.CRIT ,{})
	sets.me["Vorpal Scythe"].Max = set_combine(sets.me.CRIT ,{})
---------------
--[WEAPONSKILL]-[Great Sword]-[CRIT]
---------------
	sets.me["Power Slash"].Min = set_combine(sets.me.CRIT ,{})
	sets.me["Power Slash"].Max = set_combine(sets.me.CRIT ,{})
---------------
--[WEAPONSKILL]-[Axe]-[CRIT]
---------------
	sets.me["Rampage"].Min = set_combine(sets.me.CRIT ,{})
	sets.me["Rampage"].Max = set_combine(sets.me.CRIT ,{})
---------------
--[WEAPONSKILL]-[Great Axe]-[CRIT]
---------------
	sets.me["Keen Edge"].Min = set_combine(sets.me.CRIT ,{})
	sets.me["Keen Edge"].Max = set_combine(sets.me.CRIT ,{})
---------------
--[WEAPONSKILL]-[SWORD]-[CRIT]
---------------
	sets.me["Vorpal Blade"].Min = set_combine(sets.me.MULTI ,{})
	sets.me["Vorpal Blade"].Max = set_combine(sets.me.MULTI ,{})
---------------
--[WEAPONSKILL]-[BASE]-[Magical]
---------------

	sets.me["Dark Harvest"] = {}
	sets.me["Shadow of Death"] = {}
	sets.me["Infernal Scythe"] = {}
	sets.me["Frostbite"] = {}
	sets.me["Freezebite"] = {}
	sets.me["Herculean Slash"] = {}
	sets.me["Gale Axe"] = {}
    sets.me["Sanguine Blade"] = {}
	sets.me["Burning Blade"] = {}
    sets.me["Red Lotus Blade"] = {}
	sets.me["Shining Blade"] = {}
    sets.me["Seraph Blade"] = {}
    sets.me["Shining Strike"] = {}
	sets.me["Seraph Strike"] = {}
	sets.me["Flash Nova"] = {}
	sets.me["Starlight"] = {}
	sets.me["Moonlight"] = {}
	
	sets.me.MAGWS = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Heath. Sollerets +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},	
	}
	
---------------
--[WEAPONSKILL]-[Scythe]-[Magical]
---------------
	sets.me["Dark Harvest"].Min = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Shadow of Death"].Min = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Infernal Scythe"].Min = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring", ammo="Knobkierrie", neck="Baetyl Pendant"})

	sets.me["Dark Harvest"].Max = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Shadow of Death"].Max = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Infernal Scythe"].Max = set_combine(sets.me.MAGWS ,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring", ammo="Knobkierrie", neck="Baetyl Pendant"})

---------------
--[WEAPONSKILL]-[Great Sword]-[Magical]
---------------
	sets.me["Frostbite"].Min = set_combine(sets.me.MAGWS ,{})
	sets.me["Freezebite"].Min = set_combine(sets.me.MAGWS ,{})
	sets.me["Herculean Slash"].Min = set_combine(sets.me.MAGWS ,{})

	sets.me["Frostbite"].Max = set_combine(sets.me.MAGWS ,{})
	sets.me["Freezebite"].Max = set_combine(sets.me.MAGWS ,{})
	sets.me["Herculean Slash"].Max = set_combine(sets.me.MAGWS ,{})
---------------
--[WEAPONSKILL]-[Axe]-[Magical]
---------------
	sets.me["Gale Axe"].Min = set_combine(sets.me.MAGWS ,{})
	
	sets.me["Gale Axe"].Max = set_combine(sets.me.MAGWS ,{})
---------------
--[WEAPONSKILL]-[SWORD]-[MAGICAL]
---------------
    sets.me["Sanguine Blade"].Min = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Burning Blade"].Min = set_combine(sets.me.MAGWS, {})
    sets.me["Red Lotus Blade"].Min = set_combine(sets.me.MAGWS, {})
	sets.me["Shining Blade"].Min = set_combine(sets.me.MAGWS, {right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
    sets.me["Seraph Blade"].Min = set_combine(sets.me.MAGWS, {right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})

    sets.me["Sanguine Blade"].Max = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Archon Ring"})
	sets.me["Burning Blade"].Max = set_combine(sets.me.MAGWS, {})
    sets.me["Red Lotus Blade"].Max = set_combine(sets.me.MAGWS, {})
	sets.me["Shining Blade"].Max = set_combine(sets.me.MAGWS, {right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
    sets.me["Seraph Blade"].Max = set_combine(sets.me.MAGWS, {right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
---------------
--[WEAPONSKILL]-[CLUB]-[MAGICAL]
---------------
    sets.me["Shining Strike"].Min = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Seraph Strike"].Min = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Flash Nova"].Min = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Starlight"].Min = set_combine(sets.me.MAGWS,{})
	sets.me["Moonlight"].Min = set_combine(sets.me.MAGWS,{})	
	
    sets.me["Shining Strike"].Max = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Seraph Strike"].Max = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Flash Nova"].Max = set_combine(sets.me.MAGWS,{right_ear="Moonshade Earring",head="Pixie Hairpin +1",left_ring="Weather. Ring"})
	sets.me["Starlight"].Max = set_combine(sets.me.MAGWS,{})
	sets.me["Moonlight"].Max = set_combine(sets.me.MAGWS,{})	
	
---------------
--[WEAPONSKILL]-[BASE]-[MACC]
---------------
	sets.me["Nightmare Scythe"]={}
	sets.me["Shockwave"]={}
	sets.me.MACC = {
		ammo="Pemphredo Tathlum",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Heath. Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Weather. Ring",
		back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},
	}

---------------
--[WEAPONSKILL]-[Scythe]-[MACC]
---------------
	sets.me["Nightmare Scythe"].Min = set_combine(sets.me.MACC ,{})
	sets.me["Nightmare Scythe"].Max = set_combine(sets.me.MACC ,{})
---------------
--[WEAPONSKILL]-[Great Sword]-[MACC]
---------------
	sets.me["Shockwave"].Min = set_combine(sets.me.MACC ,{})
	sets.me["Shockwave"].Max = set_combine(sets.me.MACC ,{})


--////////////////
--Spellcasting sets
--////////////////
---------------
--[CASTING SETS]
---------------
    sets.precast = {}   			--Leave This Empty
    sets.midcast = {}    			--Leave This Empty
    sets.aftercast = {}  			--Leave This Empty
    sets.midcast.nuking = {}		--Leave This Empty
    sets.midcast.MB	= {}			--Leave This Empty  
    sets.midcast.enhancing = {} 	--Leave This Empty
	sets.midcast.Enfeebling = {} 	--Leave This Empty
	sets.midcast.cure = {} 			--Leave This Empty
	
	sets.midcast.Enmity ={
		ammo="Sapience Orb",
		head={ name="Loess Barbuta +1", augments={'Path: A',}},
		body="Emet Harness +1",
		hands="Yorium Gauntlets",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Trance Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back="Reiki Cloak",
	}
	sets.me["Provoke"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Warcry"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Sentinel"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Shield Bash"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Vallation"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Pflug"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Valiance"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Swipe"] = {}
	sets.me["Lunge"] = set_combine(sets.me["Swipe"],{})
	sets.me["Last Resort"]={back="Ankou's Mantle"}
	sets.me["Soul Eater"]={head="Igno. Burgeonet +1"}
	sets.me["Weapon Bash"]=sets.midcast.Enmity
	-- {
		-- ammo="Pemphredo Tathlum",
		-- head="Heath. Burgeon. +2",
		-- body="Heath. Cuirass +2",
		-- -- hands="Igno. Gauntlets +1"
		-- hands="Heath. Gauntlets +2",
		-- legs="Heath. Flanchard +2",
		-- feet="Heath. Sollerets +3",
		-- neck="Erra Pendant",
		-- waist="Eschan Stone",
		-- left_ear="Malignance Earring",
		-- right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		-- left_ring="Stikini Ring +1",
		-- right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		-- back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},
	-- }
	sets.me["Arcane Circle"]={feet="Igno. Sollerets +1"}
	sets.me["Arcane Crest"]={}
	sets.me["Consume Mana"]={}
	sets.me["Dark Seal"]={head="Fall. Burgeonet +3"}
	sets.me["Diabolic Eye"]={hands="Fall. Fin. Gaunt. +3"}
	sets.me["Nether Void"]={legs="Heath. Flanchard +2"}
	sets.me["Scarlet Delirium"]={}
	sets.me["Blood Weapon"]={body="Fall. Cuirass +1"}
	sets.me["Soul Enslavement"]={}

	
---------------
--[PRECASTING]-[FAST CAST]
--[FAST CAST]: +30TRAIT|+8GIFT|GEAR NEEDS MIN+42 MAX+50, REDUCE FOR GIFTS
--	[TRAIT TOTAL]	: +30
--	[GIFT TOTAL]	: +0
--	[GEAR TOTAL]	: +50 (Exactly at cap)
--[RECAST] - RECAST CAPS AT 80%
--	[TRAIT TOTAL]			: +15
--	[GIFT TOTAL]			: +0
--	[GEAR HASTE TOTAL]		: +22
--	[GEAR FAST CAST TOTAL]	: +25
--	[MAGIC HASTE2]			: +30
--	[GRAND TOTAL]			: +92 (overcapped by 10)
--WITH MAX FAST CAST GIFTS, GEAR, AND SPELL HASTE, YOU NEED 20 HASTE ON YOUR GEAR TO CAP RECASTING TIME
--RECASTING TIME ONLY BENEFITS SPELLS WITH NO DIRECT MODIFIERS, LIKE UTSUSEMI. IT IS POSSIBLE TO GET A 9 SECOND RECAST ON UTSU NI. 
--NON MOD SPELLS DEFAULT TO PRECASTING FOR THEIR MIDCASTING SETS
--TL/DR GET 20-24 HASTE, AND CAP FASTCAST ON THIS SET NO MATTER WHAT. 
---------------
    sets.precast.casting = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Odyssean Cuisses", augments={'Accuracy+20','"Fast Cast"+4','STR+5',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Orunmila's Torque",
		waist="Carrier's Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back={ name="Ankou's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
    }											
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
	sets.precast.Impact = {
		ammo="Sapience Orb",
		body="Twilight Cloak",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Odyssean Cuisses", augments={'Accuracy+20','"Fast Cast"+4','STR+5',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Orunmila's Torque",
		waist="Carrier's Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back={ name="Ankou's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},	
	}
---------------
--[PRECASTING]-[ENHANCING]
--LEAVE THIS BLANK UNLESS USING AN ENHANCING MAGIC SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
---------------
--[PRECASTING]-[STONESKIN]
--LEAVE THIS BLANK UNLESS USING A STONESKIN SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
---------------
--[PRECASTING]-[CURE]
--LEAVE THIS BLANK UNLESS USING A CURE SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.cure = set_combine(sets.precast.casting,{})


--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	
	
	sets.midcast.Impact= {
		ammo="Pemphredo Tathlum",
		body="Twilight Cloak",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[ELEMENTAL OBI]
--USE THIS IF YOU HAVE YOUR OBI
---------------
    sets.midcast.Obi = {Waist = "Hachirin-no-obi"}
---------------
--[MIDCASTING]-[ORPHEUS SASH]
--USE THIS IF USING AN ORPHEUS SASH
---------------
    sets.midcast.Orpheus = {waist="Orpheus's Sash"}  
---------------
--[MIDCASTING]-[HELIX]
--DONT USE ELEMENTAL OBI'S FOR THIS SPELL CLASS. SELECT AN INT/MAB BELT
---------------
    sets.midcast.DarkHelix = {}
---------------
--[MIDCASTING]-[DEFAULT]
--GENERAL CASTING - WILL BE THE DEFAULT SET UNLESS SPELL BEING CAST IS A PART OF ANOTHER SPECIFIED GROUP.
--EG. GETS REPLACED BY ANY SPELLS IN THE NUKING CATEGORY WITH THE NUKING NORMAL SET. 
---------------
    sets.midcast.casting = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sakpata's Plate",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Volte Boots",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Enchntr. Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Gelatinous Ring +1",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }
	sets.midcast.StatusRemoval=set_combine(sets.midcast.casting,{})
---------------
--[MIDCASTING]-[NUKING]                                                      
---------------
    sets.midcast.nuking.normal = {
		ammo="Pemphredo Tathlum",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		left_ring="Shiva Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[MAGIC BURSTING]
--USES MAGIC BURST PIECES WHEN CASTING A MAGIC BURST. 
--USE F10 TO TURN ON MAGIC BURSTING. THIS WILL TURN OFF NORMAL NUKING, 
--SHOULD ONLY BE USED IF PURELY BURSTING. ALL OTHER SITUATIONS KEEP IT OFF. 
--RECCOMENDED TO SWAP INTO A STAFF IF DOING FULL BURSTING OFF OF YOUR OWN SC. 
--GS WILL AUTO RE-EQUIP MELEE WEAPONS AFTER CAST. 
---------------
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {left_ring="Mujin Band"})
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal, {})
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {left_ring="Mujin Band"})	
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast.Drain = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Carm. Sc. Mail +1", augments={'HP+80','STR+12','INT+12',}},
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs="Heath. Flanchard +2",
		feet="Ratri Sollerets",
		neck="Erra Pendant",
		waist="Orpheus's Sash",
		left_ear="Hirudinea Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Niht Mantle", augments={'Attack+15','Dark magic skill +5','"Drain" and "Aspir" potency +23',}},
	}
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast.Aspir = sets.midcast.Drain
---------------
--[MIDCASTING]-[Absorb]
---------------
    sets.midcast.Absorb = {
		ammo="Pemphredo Tathlum",
		head={ name="Fall. Burgeonet +3", augments={'Enhances "Dark Seal" effect',}},
		body={ name="Carm. Sc. Mail +1", augments={'HP+80','STR+12','INT+12',}},
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs="Heath. Flanchard +2",
		feet="Ratri Sollerets",
		neck="Erra Pendant",
		waist="Casso Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back="Chuparrosa Mantle",
	}
	sets.midcast["Absorb-TP"] = set_combine(sets.midcast.Absorb,{hands="Heath. Gauntlets +2"})
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
	
    sets.midcast.Enfeebling.Dia = {}

    sets.midcast.Bio = {
		ammo="Pemphredo Tathlum",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Carm. Sc. Mail +1", augments={'HP+80','STR+12','INT+12',}},
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Erra Pendant",
		waist="Casso Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring="Evanescence Ring",
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Niht Mantle", augments={'Attack+15','Dark magic skill +5','"Drain" and "Aspir" potency +23',}},
    }
------------------------------------------
--------------[PURE ACC]------------------
	sets.midcast.MACC = {
		ammo="Pemphredo Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Heath. Cuirass +2",
		hands="Heath. Gauntlets +2",
		legs="Heath. Flanchard +2",
		feet="Heath. Sollerets +3",
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},	
	}
    sets.midcast.Enfeebling.Dispel	= set_combine(sets.midcast.MACC,{})		
	sets.midcast["Stun"] 			= sets.midcast.Enmity --set_combine(sets.midcast.MACC,{})	
    sets.midcast.Enfeebling.Silence = set_combine(sets.midcast.MACC,{})	
------------------------------------------
---------[MND + ACC + POTENCY]------------
    sets.midcast.Enfeebling.Paralyze = set_combine(sets.midcast.MACC,{})
    sets.midcast.Enfeebling.Slow 	 = set_combine(sets.midcast.MACC,{})
    sets.midcast.Enfeebling.Blind 	 = set_combine(sets.midcast.MACC,{})
------------------------------------------
-------------[MND + POTENCY]--------------	
    sets.midcast.Enfeebling.FrazzleII = set_combine(sets.midcast.MACC,{})
    sets.midcast.Enfeebling.Distract  = set_combine(sets.midcast.MACC,{})
-------------------------------------------
---------[INT + Skill + DURATION]----------
    sets.midcast.Enfeebling.Poison 	= set_combine(sets.midcast.MACC,{})
-------------------------------------------
-------------[INT + DURATION]--------------		
    sets.midcast.Enfeebling.Bind 	= set_combine(sets.midcast.MACC,{})	
    sets.midcast.Enfeebling.Sleep 	= set_combine(sets.midcast.MACC,{})	
    sets.midcast.Enfeebling.Break 	= set_combine(sets.midcast.MACC,{})	
    sets.midcast.Enfeebling.Gravity = set_combine(sets.midcast.MACC,{})	
---------------
--[MIDCASTING]-[DARK DURATION (SELF)]
	
---------------
	sets.midcast.Spikes= {
		main={ name="Montante +1", augments={'Path: A',}},
		sub="Utu Grip",
		ammo="Pemphredo Tathlum",
		head="Ratri Sallet",
		body="Heath. Cuirass +2",
		hands="Ratri Gadlings",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Ratri Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",
    }
	sets.midcast.Endark = {
		ammo="Staunch Tathlum +1",
		head="Igno. Burgeonet +1",
		body={ name="Carm. Sc. Mail +1", augments={'HP+80','STR+12','INT+12',}},
		hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
		legs="Heath. Flanchard +2",
		feet="Ratri Sollerets",
		neck="Erra Pendant",
		waist="Casso Sash",
		left_ear="Etiolation Earring",
		right_ear="Infused Earring",
		left_ring="Stikini Ring +1",
		right_ring="Evanescence Ring",
		back={ name="Niht Mantle", augments={'Attack+15','Dark magic skill +5','"Drain" and "Aspir" potency +23',}},	
	}
---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {
		main="Apocalypse",
		sub="Utu Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Heath. Cuirass +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Malignance Earring",
		right_ear="Andoaa Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back="Merciful Cape",
    }
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration ,{})

---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.Regen = set_combine(sets.midcast.enhancing.duration,{ })

---------------
--[MIDCASTING]-[OHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={
		ammo="Staunch Tathlum +1",
		head={ name="Yorium Barbuta", augments={'Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'Phalanx +3',}},
		hands={ name="Yorium Gauntlets", augments={'Phalanx +3',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Yorium Sabatons", augments={'Phalanx +3',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear={ name="Heath. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh =set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil =set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[Protect]
---------------
    sets.midcast.protect = set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[SHELL]
---------------
    sets.midcast.shell = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = {}
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{waist= "Hachirin-no-obi"})  
	sets.midcast.cure.normal.self={}
	sets.midcast.cure.weather.self = set_combine(sets.midcast.cure.normal.self,{waist= "Hachirin-no-obi"}) 

	sets.midcast["Stone"] ={
		ammo = "Per. Lucky Egg",
		head = "Wh. Rarab Cap +1",
		feet = "Volte Boots",
		waist="Chaac Belt",
		}
    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Purity ring",	--7
        ring2="Haoma's ring",
        waist="Gishdubar Sash", --10
        }
	sets.midcast.BlueCure={
	
	}
	sets.midcast.BlueENH={}
	sets.midcast.BlueACC={

	}
	sets.midcast.BlueNuke={

	}
end