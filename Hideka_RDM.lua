include('organizer-lib')
include('Modes.lua')
res = require('resources')
texts = require('texts')

send_command('input //send @all lua l superwarp') 

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei","Toolbag (Shihe)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
	Odyssey={"Tumult's Blood","Hidhaegg's Scale","Sovereign's Hide","Sarama's Hide"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

send_command('wait 3;input //gs org')
add_to_chat(8,'REMEMBER TO REPACK GEAR') 

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh','dt','Reraise','TANK','HP','Town')
meleeModes = M('Enspell', 'FullHaste','Haste30', 'dt','TANK')
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
mainWeapon = M('Crocea Mors','Naegling','Excalibur','Tauret','Mandau','Maxentius','Daybreak','Aern Dagger')
subWeapon = M('Demers. Degen +1','Machaera +3','Daybreak','Sacro Bulwark','Qutrub Knife')
WeaponSet1={"Naegling","Machaera +3"}
WeaponSet2={"Excalibur","Demers. Degen +1"}
WeaponSet3={"Tauret","Machaera +3"}
WeaponSet4={"Maxentius","Sacro Bulwark"}
WeaponSet5={"Crocea Mors","Daybreak"}
WeaponSet6={"Excalibur","Sacro Bulwark"}
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
DYNA_NECK = "Duelist's Torque +2"
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
	windower.send_command('bind numpad1 gs c WS1')
	windower.send_command('bind numpad2 gs c WS2')
	windower.send_command('bind numpad3 gs c WS3')
	windower.send_command('bind numpad4 gs c WS4')
	windower.send_command('bind numpad5 gs c WS5')
	windower.send_command('bind numpad6 gs c WS6')
	windower.send_command('bind numpad0 input /ma Dia III <t>')
	windower.send_command('bind numpad. input /ma silence <t>')
	
	send_command('unbind ^r')
	
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
	windower.send_command('unbind numpad1')
	windower.send_command('unbind numpad2')
	windower.send_command('unbind numpad3')
	windower.send_command('unbind numpad4')
	windower.send_command('unbind numpad5')
	windower.send_command('unbind numpad6')
end

include('RDM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,1) -- Sheet, Book
send_command('wait 10;input /lockstyleset 31')
refreshType = idleModes[1] -- leave this as is  
  
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 31')
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
--------------------
--//////////////////
--JSE GEAR
--//////////////////		
--------------------
--------------------
--[ARTIFACT ARMOR]-[ART]
--------------------    
	ART = {}		--Leave This Empty
		ART.HED	= "Atro. Chapeau +2"
		ART.BOD	= "Atrophy Tabard +3"
		ART.HND	= "Atrophy Gloves +3"
		ART.LEG	= "Atrophy Tights +2"
		ART.FEE	= "Atrophy Boots +3"
		
--------------------
--[RELIC ARMOR]-[REL]
--------------------    
	REL = {}		--Leave This Empty
		REL.HED	= "Viti. Chapeau +3"
		REL.BOD	= "Viti. Tabard +3"
		REL.HND	= "Viti. Gloves +3"
		REL.LEG	= "Viti. Tights +3"
		REL.FEE	= "Vitiation Boots +3"
		REL.NEK = "Duelist's Torque +2"

--------------------
--[EMPERYAN ARMOR]-[EMP]
--------------------    
	EMP = {}		--Leave This Empty
		EMP.HED	= "Leth. Chappel +3"
		EMP.BOD	= "Lethargy Sayon +3"
		EMP.HND	= "Leth. Ganth. +3"
		EMP.LEG	= "Leth. Fuseau +2"
		EMP.FEE	= "Leth. Houseaux +3"
--------------------
--[SUCCELLOS CAPES]-[JSE]
--------------------  

	JSE = {}		--Leave This Empty
		JSE.WSD = {}
			JSE.WSD.MNDMAG 	= {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}}
			JSE.WSD.INTMAG  = {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+8','Weapon skill damage +10%',}}
			JSE.WSD.STRATK 	= {name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
			JSE.WSD.DEXMAG 	= {name="Sucellos's Cape", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+8','Weapon skill damage +10%',}}
			JSE.WSD.AGIATK 	= {name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Atk.+10','Weapon skill damage +10%',}}
		JSE.MAG = {}
			JSE.MAG.NUKE 	= {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}}
			JSE.MAG.CURE 	= {}
			JSE.MAG.FAST 	= {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}}
			JSE.MAG.MND 	= {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}}
			JSE.MAG.INT 	= {name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10',}}
		JSE.MELEE = {}
			JSE.MELEE.STP 	= {name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
			JSE.MELEE.DW 	= {name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','"Dual Wield"+10','Phys. dmg. taken-2%',}}
			JSE.MELEE.CRIT 	= {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}

---------------
--GENERIC SETS
---------------
    sets.me = {}        		-- leave this empty
	sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty
    sets.me.melee = {}          -- leave this empty
    sets.weapons = {}			-- leave this empty
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
--[IDLE]-[REFRESH]-[NORMAL]
---------------
 	sets.me.idle.refresh = {
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Merlinic Shalwar", augments={'Attack+14','MND+8','"Refresh"+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Merlinic Crackows", augments={'AGI+7','"Refresh"+2','Accuracy+11 Attack+11',}},
		neck="Warder's Charm +1",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
	}		

---------------
--[IDLE]-[REFRESH]-[PDT]
---------------
	sets.me.idle.dt = {
		ammo="Staunch Tathlum +1",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Cryptic Earring",
		left_ring = {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring = "Defending Ring",
		back="Moonbeam Cape",
	}
	sets.me.idle.TANK={
		ammo="Eluder's Sachet",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Lethargy Sayon +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Malignance Tights",
		feet="Atro. Boots +3",
		neck="Warder's Charm +1",
		waist="Plat. Mog. Belt",
		left_ear="Eabani Earring",
		right_ear="Ethereal Earring",
		left_ring="Warden's Ring",
		right_ring="Shadow Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Chance of successful block +5',}},	
	}
	sets.me.idle.HP={
		ammo="Homiliary",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Meridian Ring",
		back="Moonbeam Cape",
	}
	sets.me.idle.Reraise = {
		ammo="Staunch Tathlum +1",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Annoint. Kalasiris",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Cryptic Earring",
		left_ring = {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring = "Defending Ring",
		back="Moonbeam Cape",	
	}
	sets.me.idle.Town = {
		ammo="Regal Gem",
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Dls. Torque +2",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Leth. Earring +1",
		left_ring="Epaminondas's Ring",
		right_ring="Ilabrat Ring",
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
--[MELEE]-[DUALWIELD]-[ACC]
---------------
    sets.me.melee.FullHastedw = {
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",				
		right_ear="Eabani Earring",
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back=JSE.MELEE.STP 
	}
    sets.me.melee.FullHastedw = {
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",				
		right_ear="Eabani Earring",
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back=JSE.MELEE.STP 
	}
    sets.me.melee.Haste30dw = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Defending Ring",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','"Dual Wield"+10','Phys. dmg. taken-2%',}},
	}
---------------
--[MELEE]-[SWORD&BOARD]-[ACCURACY]
---------------
    sets.me.melee.FullHastesw = {
		main={ name="Excalibur", augments={'Path: A',}},
		sub="Sacro Bulwark",
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Goading Belt",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
    }
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.dtdw ={
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring	= "Lehko's Ring",
		right_ring="Defending Ring",
		back=JSE.MELEE.STP
    }
---------------
--[MELEE]-[SWORD&BOARD]-[PDT]
---------------
    sets.me.melee.dtsw = {
		ammo="Eluder's Sachet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Atro. Boots +3",
		neck="Warder's Charm +1",
		waist="Goading Belt",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring	= "Lehko's Ring",
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
    }
---------------
--[MELEE]-[DUALWIELD]-[Enspell]
---------------
    sets.me.melee.Enspelldw ={
		ammo="Sroda Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Ayanmo Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back = JSE.MELEE.DW

	}
---------------
--[MELEE]-[DUALWIELD]-[Enspell II]
---------------

    sets.me.melee.Enspellsw ={
		ammo="Sroda Tathlum",
		head="Malignance Chapeau",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Aya. Manopolas +2",
		legs={ name="Viti. Tights +3", augments={'Enspell Damage','Accuracy',}},
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring	= "Lehko's Ring",
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}
---------------
--[MELEE]-[DUALWIELD]-[Enspell]
---------------
    sets.me.melee.TANKdw ={
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Warder's Charm +1",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back=JSE.MELEE.STP 
	}
---------------
--[MELEE]-[DUALWIELD]-[Enspell II]
---------------

    sets.me.melee.TANKsw ={
		ammo="Eluder's Sachet",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Lethargy Sayon +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Malignance Tights",
		feet="Atro. Boots +3",
		neck="Warder's Charm +1",
		waist="Flume Belt",
		left_ear="Eabani Earring",
		right_ear="Ethereal Earring",
		left_ring="Warden's Ring",
		right_ring="Shadow Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Chance of successful block +5',}},
	}


--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]-[CLUB]-[BLACK HALO]-[MOD:70%MND/30%STR/P.ATTK]-[ELEMENT:Fragmentation/compression]
---------------
	sets.me.STRWSD = {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Leth. Houseaux +3",
		neck		= "Rep. Plat. Medal",
		waist		= "Sailfi Belt +1",
		left_ear	= {name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear	= "Ishvara Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Epaminondas's Ring",
		back		= JSE.WSD.STRATK	
	}

	sets.me["Black Halo"] = set_combine(sets.me.STRWSD ,{right_ear="Regal Earring", left_ring="Metamorph Ring +1"})
    sets.me["Savage Blade"] = set_combine(sets.me.STRWSD ,{right_ear="Regal Earring", left_ring="Metamorph Ring +1"})
    sets.me["Knights of Round"] = set_combine(sets.me.STRWSD ,{right_ear="Regal Earring", left_ring="Metamorph Ring +1"})	


	sets.me.MAGWS = {
		ammo		= "Sroda Tathlum",
		head		= "Leth. Chappel +3",
		body		= "Nyame Mail",
		hands		= "Jhakri Cuffs +2",
		legs		= "Lethargy Fuseau +2",
		feet		= "Leth. Houseaux +3",
		neck		= "Sibyl Scarf",
		waist		= "Orpheus's Sash",
		left_ear	= "Malignance Earring",
		right_ear	= "Moonshade Earring",
		left_ring	= "Metamorph Ring +1",
		right_ring	= "Epaminondas's Ring",
		back		= JSE.WSD.MNDMAG,
	
	}
---------------
--[WEAPONSKILL]-[SWORD]-[SANGUINE BLADE]-[MOD:30%STR/50%MND/M.ATTK]-[ELEMENT: DARK (NO SC ELEMENT)]
---------------
    sets.me["Sanguine Blade"] = {
		ammo="Sroda Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
	}
---------------
--[WEAPONSKILL]-[SWORD]-[RED LOTUS BLADE]-[MOD:40%STR/40%INT/M.ATTK]-[ELEMENT:Liquefaction]
---------------
    sets.me["Red Lotus Blade"] = set_combine(sets.me.MAGWS, {back=JSE.WSD.INTMAG})
    sets.me["Seraph Blade"] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Leth. Ganth. +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Weather. Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},	
	
	}
    sets.me["Aeolian Edge"] = set_combine(sets.me.MAGWS, {ammo="Sroda Tathlum", left_ring= "Freke Ring",back=JSE.WSD.INTMAG})

    sets.me["Asuran Fists"] = {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Leth. Houseaux +3",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Petrov Ring",
		back		= JSE.WSD.STRATK
	}

    sets.me["Raging Fists"] = {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet="Leth. Houseaux +3",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Petrov Ring",
		back		= JSE.WSD.STRATK
	}

---------------
--[WEAPONSKILL]-[SWORD]-[REQUIESCAT]-[MOD:85%MND/P.ATTK/Gorget]-[ELEMENT:Gravitation/Scission]
---------------
    sets.me["Requiescat"] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Regal Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back=JSE.WSD.MNDMAG
    }
---------------
--[WEAPONSKILL]-[SWORD]-[CHANT DU CYGNE]-[MOD:80%DEX/P.ATTK/Gorget]-[ELEMENT:Light/Distortion]
---------------
    sets.me["Chant du Cygne"] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Bunzi's Gloves",
		legs="Zoar Subligar +1",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Lehko's Ring",
		right_ring="Ilabrat Ring",
		back=JSE.MELEE.CRIT
    }

---------------
--[WEAPONSKILL]-[SWORD]-[DEATH BLOSSOM]-[MOD:50%MND/30%STR/P.ATTK]-[ELEMENT:FRAGMENTATION/DISTORTION]
---------------
    sets.me["Death Blossom"] = {
		ammo="Regal Gem",
		head= "Nyame Helm",
		body= "Nyame Mail",
		hands= "Nyame Gauntlets",
		legs= "Nyame Flanchard",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Sherida Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Metamorph Ring +1",
		back=JSE.WSD.STRATK
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SWIFT BLADE]-[MOD:50%MND/50%STR/P.ATTK/GORGET]-[ELEMENT:GRAVITATION] -[REQUIRES HOMINILARY SWORD]
---------------
    sets.me["Circle Blade"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head= "Nyame Helm",
		body= "Nyame Mail",
		hands= "Nyame Gauntlets",
		legs= "Nyame Flanchard",
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Ishvara Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov ring",
		right_ring="Epaminondas's Ring",
		back=JSE.WSD.STRATK
    }

---------------
--[WEAPONSKILL]-[DAGGER]-[EVISCERATION]-[MOD:50%DEX/P.ATTK/GORGET]-[ELEMENT:GRAVITATION/TRANSFIXION]
---------------
    sets.me["Evisceration"] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Lehko's Ring",
		right_ring="Ilabrat Ring",
		back=JSE.MELEE.CRIT,
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[EXTENERATOR]-[MOD:85%AGI/P.ATTK/GORGET]-[ELEMENT:FRAGMENTATION/SCISSION]
---------------
    sets.me["Exenterator"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Ilabrat Ring",
		back= JSE.WSD.AGIATK,
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Drain"] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Atrophy Tights +2",
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back=JSE.WSD.MNDMAG,
    }
	sets.me["Mercy Stroke"]={
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear="Odnowa Earring +1",
		
		
		left_ring="Ilabrat Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}

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
		main="Mafic Cudgel", --+6
		sub="Evalach +1", --+6
		ammo="Sapience Orb", --+2
		head="Halitus Helm", -- +8
		body="Emet Harness +1", -- +10
		hands="Dux Fng. Gnt.", --+4
		legs={ name="Zoar Subligar +1", augments={'Path: A',}}, --6
		feet="Rager Ledel. +1",--+7
		neck={ name="Unmoving Collar +1", augments={'Path: A',}}, --+10
		waist="Trance Belt", --+3
		left_ear="Friomisi Earring", --+2
		right_ear="Cryptic Earring", --+4
		left_ring="Supershear Ring", --+5
		right_ring="Eihwaz Ring", --+5
		back="Reiki Cloak",	--+10 (need to fix with correct JSE Cloak)
	}
	sets.me["Provoke"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Warcry"] = set_combine(sets.midcast.Enmity,{})
	
	sets.me["Sentinel"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Shield Bash"] = set_combine(sets.midcast.Enmity,{})

	sets.me["Vallation"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Pflug"] = set_combine(sets.midcast.Enmity,{})
	sets.me["Valiance"] = set_combine(sets.midcast.Enmity,{})
	
	sets.me["Swipe"] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
	sets.me["Lunge"] = set_combine(sets.me["Swipe"],{})
	
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
		ammo="Staunch Tathlum +1",
		head="Atro. Chapeau +2",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Malignance Earring",
		left_ring="Supershear Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }											
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{ Range="Ullr"})
    sets.precast["Dispelga"] = set_combine(sets.precast.casting,{main = "Daybreak",})
	sets.precast.Impact = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Sacro Bulwark",
		ammo="Sapience Orb",
		head=none,
		body="Twilight Cloak",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Meridian Ring",
		right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",	
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

---------------
--[PRECASTING]-[CHAINSPELL]
---------------
    sets.me["Chainspell"] = {body = REL.Body}
--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	
	
	sets.midcast.Impact= {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		range="Ullr",
		body="Twilight Cloak",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
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
		head="Atro. Chapeau +2",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
	sets.midcast.StatusRemoval={
		main="Crocea Mors",
		sub="Sacro Bulwark",
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Meridian Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},		
	}
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[MAGIC BURSTING]
--USES MAGIC BURST PIECES WHEN CASTING A MAGIC BURST. 
--USE F10 TO TURN ON MAGIC BURSTING. THIS WILL TURN OFF NORMAL NUKING, 
--SHOULD ONLY BE USED IF PURELY BURSTING. ALL OTHER SITUATIONS KEEP IT OFF. 
--RECCOMENDED TO SWAP INTO A STAFF IF DOING FULL BURSTING OFF OF YOUR OWN SC. 
--GS WILL AUTO RE-EQUIP MELEE WEAPONS AFTER CAST. 
---------------
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
	 })
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Ullr",
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		range="Ullr",
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Ea Slops +1",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Sibyl Scarf",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
    })	
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast["Drain"] = {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Ammurapi Shield",
		range="Ullr",
		head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+13','"Drain" and "Aspir" potency +11','"Mag.Atk.Bns."+13',}},
		hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +10','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		legs="Malignance Tights",
		feet={ name="Merlinic Crackows", augments={'AGI+7','"Refresh"+2','Accuracy+11 Attack+11',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring= "Archon Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast["Aspir"] = sets.midcast["Drain"]
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
	
    sets.midcast.Enfeebling.Dia = {
		main="Daybreak",
		sub="Sacro Bulwark",
		ammo="Regal Gem",
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Dls. Torque +2",
		waist="Obstin. Sash",
		left_ear="Snotra Earring",		
		right_ear="Tuisto Earring",
		left_ring="Weatherspoon Ring",		
		right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
	}
    sets.midcast.Enfeebling.Inundation = set_combine(sets.midcast.Enfeebling.Dia,{})	
    sets.midcast.Bio = {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Ammurapi Shield",
		range="Ullr",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Erra Pendant",
		waist="Acuity Belt +1",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},

    }
------------------------------------------
--------------[PURE ACC]------------------
    sets.midcast["Repose"] = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head="Leth. Chappel +3",
		body="Atrophy Tabard +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
    sets.midcast.Enfeebling.Dispel = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		range="Ullr",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands=EMP.HND,
		legs=EMP.LEG,
		feet=EMP.FEE,
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
    sets.midcast.Enfeebling.Dispelga = {
		main = "Daybreak",
		sub="Ammurapi Shield",
		range="Ullr",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands=EMP.HND,
		legs=EMP.LEG,
		feet=EMP.FEE,
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.FrazzleII = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.Silence = set_combine(sets.midcast.Enfeebling.Dispel,{legs="Chironic Hose"})
------------------------------------------
---------[MND + ACC + POTENCY]------------
    sets.midcast.Enfeebling.Addle = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands=EMP.HND,
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
    sets.midcast.Enfeebling.Paralyze = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Slow = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Blind = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands=EMP.HND,
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
------------------------------------------
-------------[MND + POTENCY]--------------	
    sets.midcast.Enfeebling.FrazzleIII = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands=EMP.HND,
		legs=EMP.LEG,
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstinate Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring = {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring = {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }		
    sets.midcast.Enfeebling.Distract = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands=EMP.HND,
		legs=EMP.LEG,
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstinate Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring = {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring = {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
-------------------------------------------
---------[INT + Skill + DURATION]----------
    sets.midcast.Enfeebling.Poison = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Mephitis Grip",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
    }	
-------------------------------------------
-------------[INT + DURATION]--------------		
    sets.midcast.Enfeebling.Bind = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands = "Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
    }	
    sets.midcast.Enfeebling.Sleep 	= set_combine(sets.midcast.Enfeebling.Bind,{})
    sets.midcast.Enfeebling.Break 	= set_combine(sets.midcast.Enfeebling.Bind,{})
    sets.midcast.Enfeebling.Gravity = set_combine(sets.midcast.Enfeebling.Bind,{body="Lethargy Sayon +3"})
	sets.midcast.Absorb = {
	    main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head="Atro. Chapeau +2",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
		-- main={ name="Contemplator +1", augments={'Path: A',}},
		-- sub="Enki Strap",
		-- ammo="Regal Gem",
		-- head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		-- body="Lethargy Sayon +3",
		-- hands="Atrophy Gloves +3",
		-- legs="Leth. Fuseau +2",
		-- feet="Leth. Houseaux +3",
		-- neck={ name="Dls. Torque +2", augments={'Path: A',}},
		-- waist={ name="Acuity Belt +1", augments={'Path: A',}},
		-- left_ear="Regal Earring",
		-- right_ear="Malignance Earring",
		-- left_ring="Stikini Ring +1",
		-- right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		-- back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+5','"Mag.Atk.Bns."+20','DMG:+6',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Lethargy Earring +1",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +7','Enha.mag. skill +9','Mag. Acc.+4','Enh. Mag. eff. dur. +20',}},
    }
	 sets.midcast.BarElement=set_combine(sets.midcast.enhancing.duration,{legs="Shedir Seraweels"})
	 sets.midcast.BarStatus=set_combine(sets.midcast.enhancing.duration,{neck="Sroda Necklace"})
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = {
		main		= "Pukulatmuj +1",
		sub			= "Forfend +1",
		head		= "Befouled Crown",
		body		= REL.BOD,
		hands		= "Viti. Gloves +3",
		legs		= ART.LEG,
		feet		= EMP.FEE,
		neck		= "Incanter's Torque",
		waist		= "Olympus Sash",
		left_ear	= "Andoaa earring",
		right_ear	= "Mimir Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +7','Enha.mag. skill +9','Mag. Acc.+4','Enh. Mag. eff. dur. +20',}},
    }

---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------
    sets.midcast.enhancing.composure = set_combine(sets.midcast.enhancing.duration, {
		head		=	EMP.HED,
		body		=	EMP.BOD,
		hands		=	ART.HND,
		legs		=	EMP.LEG,
		feet		=	EMP.FEE,
    })
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.Regen = set_combine(sets.midcast.enhancing.duration,{    
		main="Bolelabunga",
		sub="Ammurapi Shield",
	})

---------------
--[MIDCASTING]-[OHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={
		main="Sakpata's Sword",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Taeon Chapeau", augments={'Attack+10','"Triple Atk."+2','Phalanx +3',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'Phalanx +2',}},
		legs={ name="Taeon Tights", augments={'Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Phalanx +2',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Leth. Earring +1",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +7','Enha.mag. skill +9','Mag. Acc.+4','Enh. Mag. eff. dur. +20',}},
    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {
		neck="Nodens Gorget", 			--30
		waist="Siegel Sash", 			--20
		right_ear="Earthcry Earring",	--10
		legs="Shedir Seraweels",		--35
		--hands="Stone Mufflers"
	})
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh ={
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+5','"Mag.Atk.Bns."+20','DMG:+6',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head="Amalric Coif +1",
		body="Atrophy Tabard +3",
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Malignance Earring",
		right_ear="Leth. Earring +1",
		left_ring="Kishar Ring",
		right_ring = "Defending Ring",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +7','Enha.mag. skill +9','Mag. Acc.+4','Enh. Mag. eff. dur. +20',}},
    }
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {hands = "Regal Cuffs", legs="Shedir Seraweels",waist="Emphatikos Rope", left_ear="Tuisto Earring"})
---------------
--[MIDCASTING]-[Protect]
---------------
    sets.midcast.protect = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+5','"Mag.Atk.Bns."+20','DMG:+6',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Lethargy Earring +1",
		left_ring="Sheltered Ring",
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back		= "Ghostfyre Cape",
	}
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
    sets.midcast.cure.normal = {
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Loricate Torque +1",
		waist="Plat. Mog. Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Eihwaz Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{main="Iridal Staff", sub="Enki Strap", waist= "Hachirin-no-obi"})  

	sets.midcast.cure.normal.self={
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Loricate Torque +1",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Eihwaz Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
		waist="Gishdubar Sash",
	}
	sets.midcast.cure.weather.self = set_combine(sets.midcast.cure.normal.self,{main="Iridal Staff", sub="Enki Strap", waist= "Hachirin-no-obi"}) 

	sets.midcast["Stone"] ={
		ammo = "Per. Lucky Egg",
		head = "Wh. Rarab Cap +1",
		feet = "Volte Boots",
		waist="Chaac Belt",
		}
	sets.midcast["Diaga"] ={
		ammo = "Per. Lucky Egg",
		head = "Wh. Rarab Cap +1",
		feet = "Volte Boots",
		waist="Chaac Belt",
		}
    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Purity Ring",	--7
        ring2="Blenmot's Ring +1", --10
        waist="Gishdubar Sash", --10
        }
	sets.midcast.BlueCure={
		main="Daybreak",
		sub="Sacro Bulwark",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Aurist's Cape +1",	
	}
	sets.midcast.BlueENH={}
	sets.midcast.BlueACC={
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		range="Ullr",
		head="Malignance Chapeau",
		body="Atrophy Tabard +3",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},	
	}
	sets.midcast.BlueNuke={
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +2",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},	
	}
end