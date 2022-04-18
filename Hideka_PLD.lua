res = require('resources')
texts = require('texts')
include('Modes.lua')
send_command('input //send @all lua l superwarp') 
include('organizer-lib')
send_command('input //lua l porterpacker') 

organizer_items = {
organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

if PortTowns:contains(world.area) then
	-- send_command('wait 3;input //gs org') 
-- else
	-- send_command('wait 3;input //gs org') 
end

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('dt','MPR','resist','REGAIN','refresh')
meleeModes = M('dt','DPS','HYBRID','MPR','resist')
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
--mainWeapon = M('Kaja Sword', 'Marin Staff','Earth Staff', 'Kaja Knife', 'Wind Knife')
--subWeapon = M('Kaja Knife',"Elder's Grip +1","Genbu's Shield",'Kaja Sword', 'Beatific Shield +1', 'Wind Knife')

mainWeapon = M('Excalibur','Naegling','Malignance Sword',"Sakpata's Sword",'Ternion Dagger +1','Montante +1','Shining one', 'Malignance Pole')
subWeapon = M('Ochain','Aegis','Priwen','Bloodrain Strap')
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1400    --important to update these if you have a smaller screen
hud_y_pos = 200     --important to update these if you have a smaller screen
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
end

include('PLD_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,4) -- Sheet, Book
send_command('wait 2;input /lockstyleset 98')
refreshType = idleModes[1] -- leave this as is     
function sub_job_change(new,old)
send_command('wait 2;input /lockstyleset 98')
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
		ART.HED	= "Rev. Coronet +1"
		ART.BOD	= "Rev. Surcoat +3"
		ART.HND	= "Rev. Gauntlets +1"
		ART.LEG	= "Rev. Breeches +1"
		ART.FEE	= "Rev. Leggings +3"
		
--------------------
--[RELIC ARMOR]-[REL]
--------------------    
	REL = {}		--Leave This Empty
		REL.HED	= "Cab. Coronet +1"
		REL.BOD	= "Cab. Surcoat +1"
		REL.HND	= "Cab. Gauntlets +2"
		REL.LEG	= "Cab. Breeches +1"
		REL.FEE	= "Cab. Leggings +2"

--------------------
--[EMPERYAN ARMOR]-[EMP]
--------------------    
	EMP = {}		--Leave This Empty
		EMP.HED	= "Chev. Armet +1"
		EMP.BOD	= "Chev. Surcoat +1"
		EMP.HND	= "Chev. Gauntlets +1"
		EMP.LEG	= "Chev. Cuisses +1"

--------------------
--[SUCCELLOS CAPES]-[SUC]
--------------------  
	JSE = {}		--Leave This Empty
		JSE.WSD	= {}	--WS damage Cape
		JSE.DWL	= {}	--Dual wield Cape
		JSE.FAS	= {}	--FAST CAST CAPE
		JSE.CRT	= {}	--CRITICAL HIT CAPE
		JSE.STP	= {}	--STORE TP CAPE
		JSE.MAB	= {}	--MAGIC ATTACK BONUS CAPE
		JSE.PDT	= {}	--PHYSICAL DAMAGE TAKEN CAPE
		JSE.MDT	= {}	--MAGICAL DAMAGE TAKEN CAPE
		JSE.ADT	= {}	--ALL DAMAGE TAKEN CAPE
		JSE.REG	= {}	--REGEN CAPE
		JSE.INT	= {}	--SPELL INTERRUPTION RATE CAPE
		JSE.HAS	= {}	--HASTE CAPE	
		
--------------------
--//////////////////
--AMBUSCADE GEAR
--//////////////////		
--------------------
--[Flamma ARMOR]-[FLA]
--------------------    
	FLA = {}		--Leave This Empty
		FLA.HED	= "Flam. Zucchetto +2"
		FLA.BOD	= "Flamma Korazin +2"
		FLA.HND	= "Flam. Manopolas +2"
		FLA.LEG	= "Flamma Dirs +2"
		FLA.FEE	= "Flam. Gambieras +2"
		FLA.RNG = "Flamma Ring"
		
--------------------
--[Sulevia ARMOR]-[SUL]
--------------------    
	SUL = {}		--Leave This Empty
		SUL.HED	= "Sulevia's Mask +2"
		SUL.BOD	= "Sulevia's Plate +2"
		SUL.HND	= "Sulev. Gauntlets +2"
		SUL.LEG	= "Sulev. Cuisses +2"
		SUL.FEE	= "Sulev. Leggins +2"
		SUL.RNG = "Sulevia's Ring"
		
--------------------
--//////////////////
--ABJURATION GEAR
--//////////////////	
--------------------
--[Souveran ARMOR]-[SOU]
--------------------    
	SOU = {}		--Leave This Empty
		SOU.HED	= "Souv. Schaller +1"
		SOU.BOD	= "Souv. Cuirass +1"
		SOU.HND	= "Souv. Handsch. +1"
		SOU.LEG	= "Souv. Diechlings +1"
		SOU.FEE	= "Souveran Schuhs +1"	
--------------------
--[CARMINE]-[CAR]
--------------------    
	CAR = {}		--Leave This Empty
		CAR.HED	= "Carmine Mask +1"
		CAR.BOD	= "Carmine Scale Mail"
		CAR.HND	= "Carmine Finger Gauntlets"
		CAR.LEG	= "Carmine Cuisses +1"
		CAR.FEE	= "Carmine Greaves"
--delete or remark '--' out any empty slots or else the gs will remove those slots when using that set
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
--[IDLE]-[REFRESH]
---------------
	sets.me.idle.refresh = {
		ammo="Homiliary",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Creed Collar",
		waist="Fucho-no-Obi",
		left_ear="Eabani Earring",
		right_ear="Tuisto Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
	}	
---------------
--[IDLE]-[PDT]
---------------
	sets.me.idle.dt = set_combine(sets.me.idle.refresh,{
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		-- feet="Sakpata's Leggings",
		feet="Souveran Schuhs +1",
		neck="Unmoving Collar +1",
		waist="Asklepian Belt",
		left_ear="Eabani Earring",
		right_ear="Tuisto Earring",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}) 
---------------
--[IDLE]-[REGAIN]
---------------
	sets.me.idle.REGAIN = set_combine(sets.me.idle.dt,{
		head="Valorous Mask",
		})
		
	sets.me.idle.MPR = {
		main={ name="Excalibur", augments={'Path: A',}},
		sub="Ochain",
		ammo="Staunch Tathlum",
		head="Chev. Armet +1",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Rev. Leggings +3",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Ethereal Earring",
		right_ear="Tuisto Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}		

	sets.me.idle.resist = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}			

---------------
--[RESTING]
---------------
    sets.me.resting = {}
---------------
--[LATENT]-[REFRESH]
---------------
    sets.me.latent_refresh = {}  

--//////////////
--MELEE SETS
--//////////////
	--USE HOTKEY TO CYCLE MELEE SETS BASED ON CONTENT. 
	--USE ACC WHEN YOU CANT HIT, AND PDT/MDT IF FACING AN AOE HAZARD	
	--DT/PDT/MDT/BDT CAP AT 50%
		--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
		--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 
	--NOTE:DONT DISCOUNT SWORD AND BOARD SUB PLD/WAR/BLU TANKING, OR /THF FARMING. 
		--WE GET A STUPID POWERFUL SHIELD IN THE BEATIFIC SHIELD, WHICH GIVES +25%MDT, AND BLOCK RATES. 
		--WE CAN EASILY SIT AT CAPPED REDUCTION WITHOUT HURTING OUR ABILITY TO PERFORM MUCH.
---------------	
--[MELEE]-[SWORD&BOARD]-[NORMAL]
---------------
	sets.me.melee.DPSsw = { 
		ammo = "Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Asperity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','HP+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}

---------------
--[MELEE]-[SWORD&BOARD]-[DT]
---------------
    sets.me.melee.dtsw = {   
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Unmoving Collar +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",bag="wardrobe2"},
		right_ring={name="Moonlight Ring",bag="wardrobe7"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
    }
	
---------------
--[MELEE]-[SWORD&BOARD]-[MEVA Focused]
---------------
    sets.me.melee.MEVAsw = set_combine(sets.me.melee.dtsw, {})
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.HYBRIDsw = {
		ammo = "Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Asperity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring={name="Moonlight Ring",bag="wardrobe2"},
		right_ring={name="Moonlight Ring",bag="wardrobe7"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','HP+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	sets.me.melee.MPRsw = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Chev. Armet +1",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Rev. Leggings +3",
		neck="Asperity Necklace",
		waist="Flume Belt",
		left_ear="Telos Earring",
		right_ear="Ethereal Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','HP+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},	
	}
	sets.me.melee.resistsw = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Hearty Earring",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}
---------------	
--[MELEE]-[DUALWIELD]-[NORMAL]
---------------
	sets.me.melee.DPSdw = set_combine(sets.me.melee.DPSsw ,{})

---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.dtdw = set_combine(sets.me.melee.dtsw,{})
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.MEVAdw = set_combine(sets.me.melee.lilithsw,{})
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.HYBRIDdw = set_combine(sets.me.melee.HYBRIDsw ,{})

--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]-[SWORD]-[SAVAGE BLADE]-[MOD:50%MND/50%STR/P.ATTK]-[ELEMENT:Fragmentation/Scission]
---------------
    sets.me["Savage Blade"] = {
		ammo = "Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
    sets.me["Impulse Drive"] = {
		ammo = "Coiste Bodhar",
		head="Blistering Sallet +1",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
	sets.me["Knights of Round"] = set_combine(sets.me["Savage Blade"],{})
	
---------------
--[WEAPONSKILL]-[SWORD]-[REQUIESCAT]-[MOD:85%MND/P.ATTK/Gorget]-[ELEMENT:Gravitation/Scission]
---------------
    sets.me["Requiescat"]  = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[SWORD]-[CHANT DU CYGNE]-[MOD:80%DEX/P.ATTK/Gorget]-[ELEMENT:Light/Distortion]
---------------
    sets.me["Chant du Cygne"]  = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[SWORD]-[SANGUINE BLADE]-[MOD:30%STR/50%MND/M.ATTK]-[ELEMENT: DARK (NO SC ELEMENT)]
---------------
    sets.me["Sanguine Blade"] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[RED LOTUS BLADE]-[MOD:40%STR/40%INT/M.ATTK]-[ELEMENT:Liquefaction]
---------------
    sets.me["Red Lotus Blade"] = {
		ammo="Pemphredo Tathlum",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SERAPH BLADE]-[MOD:40%STR/40%MND/M.ATTK]-[ELEMENT:Scission]
---------------
    sets.me["Seraph Blade"] = {
		ammo="Pemphredo Tathlum",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Weather. Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[Atonement]-[MOD: Enmity]-[ELEMENT:Fusion / Reverberation]
---------------
    sets.me["Atonement"] = {
		ammo="Sapience Orb",
		head="Loess Barbuta +1",
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonbeam Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Apeile Ring",
		right_ring="Apeile Ring +1",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SWIFT BLADE]-[MOD:50%MND/50%STR/P.ATTK/GORGET]-[ELEMENT:GRAVITATION] -[REQUIRES HOMINILARY SWORD]
---------------
    sets.me["SWIFT BLADE"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[DAGGER]-[AEOLIAN EDGE]-[MOD:40%DEX/40%INT/M.ATTK]-[ELEMENT: IMPACTION/SCISSION/DETONATION]
---------------
    sets.me["Aeolian Edge"] = set_combine(sets.me["Seraph Blade"],{})
---------------
--[WEAPONSKILL]-[DAGGER]-[EVISCERATION]-[MOD:50%DEX/P.ATTK/GORGET]-[ELEMENT:GRAVITATION/TRANSFIXION]
---------------
    sets.me["Evisceration"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Drain"] = set_combine(sets.me["Seraph Blade"],{})
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Steal"] = set_combine(sets.me["Seraph Blade"],{})
---------------
--[WEAPONSKILL]-[Greatsword]-[Torcleaver]-[MOD:80%VIT]-[Light/Distortion]
---------------
    sets.me["Torcleaver"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Greatsword]-[Resolution]-[MOD: 73~85%STR]-[Light/Fragmentation/Scission]
---------------
    sets.me["Resolution"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Greatsword]-[Groundstrike]-[50%STR/50%INT]-[Fragmentation/Distortion]
---------------
    sets.me["Groundstrike"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Greatsword]-[Spinning Slash]-[30%STR/30%INT]-[Fragmentation]
---------------
    sets.me["Spinning Slash"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Greatsword]-[Shockwave]-[30%STR/30%MND/Duration varies with TP.Use FTP Gear]-[Reverberation]
---------------
    sets.me["Shockwave"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Staff]-[Spirit Taker]-[50%INT/50%MND]-[NONE]
---------------
    sets.me["Spirit Taker"] = {
		ammo="Pemphredo Tathlum",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[Staff]-[Shattersoul]-[73~85%INT, Decreases Medf with TP. Use FTP]-[Darkness/Gravitation/Induration]
---------------
    sets.me["Shattersoul"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Staff]-[Cataclysm]-[30%STR/30%INT/MATTK]-[]
---------------
    sets.me["Cataclysm"] = set_combine(sets.me["Seraph Blade"],{})
---------------
--[WEAPONSKILL]-[Staff]-[Retribution]-[50%STR/30%MND]-[Gravitation/Reverberation]
---------------
    sets.me["Retribution"] = set_combine(sets.me["Savage Blade"],{})
-------
--[WEAPONSKILL]-[Club]-[Realmrazer]-[73~85%MND USE FTP]-[Light/Fusion/Impaction]
---------------
    sets.me["Realmrazer"] = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Club]-[Flash Nova]-[50%STR/50%MND/MAB/FTP]-[Reverberation/Induration]
---------------
    sets.me["Flash Nova"] = set_combine(sets.me["Seraph Blade"],{})
---------------
--[WEAPONSKILL]-[Club]-[Black Halo]-[70%MND/30%STR]-[Fragmentation/Compression]
---------------
    sets.me["Black Halo"]  = set_combine(sets.me["Savage Blade"],{})
---------------
--[WEAPONSKILL]-[Pole Arm]-[Impulse Drive]-[]-[]
---------------

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
---------------
--[Ability Precasting]
---------------
	sets.enmity={		
		ammo="Sapience Orb",
		head="Loess Barbuta +1",
		body=SOU.BOD,
		hands=SOU.HND,
		legs=SOU.LEG,
		feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
		neck="Moonbeam Necklace",
		waist="Creed Baudrier",
		left_ear="Tuisto Earring",
		right_ear="Cryptic Earring",
		left_ring="Apeile Ring",
		right_ring="Apeile Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}
		
    sets.me['Invincible'] 	= set_combine(sets.enmity, {Legs=REL.LEG})
	sets.me['Shield Bash'] 	= set_combine(sets.enmity, {sub = "Aegis", Body=ART.BOD, Hands= REL.HND, right_ear="Knightly Earring", left_ring="Fenian Ring",})
	sets.me['Holy Circle'] 	= set_combine(sets.enmity, {Feet=ART.FEE})
	sets.me['Sentinel'] 	= set_combine(sets.enmity, {feet=REL.FEE,})
	sets.me['Cover'] 		= set_combine(sets.enmity, {Head=ART.HED, Body=REL.BOD})
	sets.me['Rampart'] 		= set_combine(sets.enmity, {Head=REL.HED,})
	sets.me['Fealty'] 		= set_combine(sets.enmity, {Body=REL.BOD,})
	sets.me['Chivalry'] 	= set_combine(sets.enmity, {Hands=REL.HND,})
	sets.me['Divine Emblem']= set_combine(sets.enmity, {Feet=EMP.FEE,})
	sets.me['Sepulcher'] 	= set_combine(sets.enmity, {})
	sets.me['Palisade'] 	= set_combine(sets.enmity, {})
	sets.me['Intervene'] 	= set_combine(sets.enmity, {})
	sets.me['Provoke'] 		= set_combine(sets.enmity, {})
		

---------------
--[PRECASTING]-[FAST CAST]
--[FAST CAST]: +30TRAIT|+8GIFT|GEAR NEEDS MIN+42 MAX+50, REDUCE FOR GIFTS
--	[TRAIT TOTAL]	: +0
--	[GIFT TOTAL]	: +0
--	[GEAR TOTAL]	: +50 (Exactly at cap)
--[RECAST] - RECAST CAPS AT 80%
--	[TRAIT TOTAL]			: +0
--	[GIFT TOTAL]			: +0
--	[GEAR HASTE TOTAL]		: +0
--	[GEAR FAST CAST TOTAL]	: +0
--	[MAGIC HASTE2]			: +0
--	[GRAND TOTAL]			: +0 
---------------
    sets.precast.casting = {
		ammo="Sapience Orb", --2/2
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}}, --14/16
		body="Rev. Surcoat +3",--10/26
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}}, -- 7/33
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}}, 
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}}, --11/44
		neck="Orunmila's Torque", --5/49
		waist="Creed Baudrier",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back="Moonbeam Cape",
    }											
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
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
    sets.precast.cure = set_combine(sets.precast.casting, {})

--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	
---------------
--[MIDCASTING]-[DEFAULT]
--GENERAL CASTING - WILL BE THE DEFAULT SET UNLESS SPELL BEING CAST IS A PART OF ANOTHER SPECIFIED GROUP.
--EG. GETS REPLACED BY ANY SPELLS IN THE NUKING CATEGORY WITH THE NUKING NORMAL SET. 
---------------
    sets.midcast.casting = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+3','Mag. Acc.+3','Attack+7','Breath dmg. taken -1%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Moonbeam Necklace",
		waist="Rumination Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",bag="wardrobe2"},
		right_ring={name="Moonlight Ring",bag="wardrobe7"},
		back="Moonbeam Cape",
    }
---------------
--[MIDCASTING]-[ELEMENTAL OBI]
--USE THIS IF YOU HAVE YOUR OBI
---------------
    sets.midcast.Obi = {}
---------------
--[MIDCASTING]-[ORPHEUS SASH]
--USE THIS IF USING AN ORPHEUS SASH
---------------
    sets.midcast.Orpheus = {}  
---------------
--[MIDCASTING]-[HELIX]
--DONT USE ELEMENTAL OBI'S FOR THIS SPELL CLASS. SELECT AN INT/MAB BELT
---------------
    sets.midcast.DarkHelix = {}

---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.Holy = {
		ammo="Pemphredo Tathlum",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Mujin Band",
		right_ring="Weather. Ring",
		back="Moonbeam Cape",
    }
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.Banish ={
		ammo="Pemphredo Tathlum",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Shiva Ring +1",
		right_ring="Weather. Ring",
    }
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {})	
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast["Drain"] = set_combine(sets.midcast.nuking, {})
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast["Aspir"] = sets.midcast["Drain"]
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
    sets.midcast.Enfeebling.macc = {}
---------------
--[MIDCASTING]-[ENFEEBLING Raw Potency]
---------------
    sets.midcast.Enfeebling.potency = {}
---------------
--[MIDCASTING]-[ENFEEBLING MIND]
---------------
    sets.midcast.Enfeebling.mndpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING MIND & SKILL]
---------------
    sets.midcast.Enfeebling.skillmndpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING INTELLIGENCE]
---------------
    sets.midcast.Enfeebling.intpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING SKILL]
---------------
    sets.midcast.Enfeebling.skillpot = {}
---------------
--[MIDCASTING]-[STUN]
---------------
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.macc, {})

---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration =  set_combine(sets.midcast.casting,{
		main="Colada",
		sub="Priwen",
		ammo="Staunch Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs="Carmine Cuisses +1",
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Tuisto Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    })
	sets.midcast['Protect V']={
		main="Excalibur",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+3','Mag. Acc.+3','Attack+7','Breath dmg. taken -1%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Moonbeam Necklace",
		waist="Rumination Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring="Sheltered Ring",
		back="Moonbeam Cape",	
	}
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------
    sets.midcast.enhancing.composure = set_combine(sets.midcast.enhancing.duration, {})  
---------------
--[MIDCASTING]-[PHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx =  {    
		main="Sakpata's Sword",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Sapience Orb",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs="Sakpata's Cuisses",
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Creed Baudrier",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Weard Mantle", augments={'VIT+4','DEX+2','Enmity+4','Phalanx +5',}},
    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {right_ear="Earthcry Earring"})
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {})

---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands="Macabre Gaunt. +1",
		legs={ name="Founder's Hose", augments={'MND+3','Mag. Acc.+3','Attack+7','Breath dmg. taken -1%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Sacro Gorget",
		waist="Rumination Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Cure" potency +10%','Spell interruption rate down-10%',}},	
	}
---------------
--[MIDCASTING]-[FLASH]
---------------
    sets.midcast.Flash = {
		ammo="Sapience Orb",
		head={ name="Loess Barbuta +1", augments={'Path: A',}},
		body="Rev. Surcoat +3",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonbeam Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Tuisto Earring",
		left_ring="Apeile Ring",
		right_ring="Apeile Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},	
    }
---------------
--[MIDCASTING]-[NON-FLASH]
---------------
    sets.midcast.Enmity = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Rev. Surcoat +3",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+3','Mag. Acc.+3','Attack+7','Breath dmg. taken -1%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Moonbeam Necklace",
		waist="Rumination Sash",
		left_ear="Cryptic Earring",
		right_ear="Tuisto Earring",
		left_ring="Apeile Ring",
		right_ring="Apeile Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},	
    }
---------------
--[MIDCASTING]-[CRUSADE]
---------------
    sets.midcast.Crusade= {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Rev. Surcoat +3",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+3','Mag. Acc.+3','Attack+7','Breath dmg. taken -1%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Moonbeam Necklace",
		waist="Rumination Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Moonlight Ring", bag="wardrobe2"},
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Chance of successful block +5',}},
	}  
---------------
--[MIDCASTING]-[Reprisal]
---------------
    sets.midcast.Reprisal= {
		--main="Sakpata's Sword",

		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Rev. Surcoat +3",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Odyssean Cuisses", augments={'Accuracy+20','"Fast Cast"+4','STR+5',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+6','INT+5','Mag. Acc.+10',}},
		neck="Orunmila's Torque",
		waist="Creed Baudrier",
		left_ear="Loquac. Earring",
		right_ear="Tuisto Earring",
		left_ring="Kishar Ring",
		right_ring	= {name="Moonlight Ring", bag="wardrobe7"},
		back="Moonbeam Cape",
	}  	
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{})    
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.regen = set_combine(sets.midcast.enhancing.duration, {})

end