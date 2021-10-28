 include('organizer-lib') -- optional
res = require('resources')
texts = require('texts')
include('Modes.lua')

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh', 'dt', 'town','dyna','H2H','BOW')
meleeModes = M('normal', 'FullHaste', 'dt', 'Odin','H2H','BOW')
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
mainWeapon = M('Crocea Mors','Naegling','Tauret','Kaja Rod','Daybreak','Wind Knife','Kaja knuckles')
subWeapon = M('Daybreak','Machaera +3','Naegling','Tauret',"Genbu's Shield","Ammurapi Shield", 'Wind Knife','')
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
send_command('lua l gearinfo')

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
end

include('RDM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,1) -- Sheet, Book
send_command('wait 2;input /lockstyleset 10')
refreshType = idleModes[1] -- leave this as is  
   
function sub_job_change(new,old)
send_command('wait 2;input /lockstyleset 10')
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
		ART.HED	= "Brioso Roundlet +3"
		ART.BOD	= "Brioso Justaucorps +3"
		ART.HND	= "Brioso Cuffs +3"
		ART.LEG	= "Brioso Cannions +3"
		ART.FEE	= "Brioso Slippers +3"
--------------------
--[RELIC ARMOR]-[REL]
--------------------    
	REL = {}		--Leave This Empty
		REL.HED	= "Bihu Roundlet +3"
		REL.BOD	= "Bihu Justaucorps +3"
		REL.HND	= "Bihu Cuffs +3"
		REL.LEG	= "Bihu Cannions +3"
		REL.FEE	= "Bihu Slippers +3"
		REL.NEK = "Bard's Charm"
--------------------
--[EMPERYAN ARMOR]-[EMP]
--------------------    
	EMP = {}		--Leave This Empty
		EMP.HED	= "Fili Calot +1"
		EMP.BOD	= "Fili Hongreline +1"
		EMP.HND	= "Fili Manchettes +1"
		EMP.LEG	= "Fili Rhingrave +1"
		EMP.FEE	= "Fili Cothurnes +1"
--------------------
--[SUCCELLOS CAPES]-[SUC]
--------------------  
	JSE = {}		--Leave This Empty
--[WS CAPES]
		JSE.STR.WSD	= "" --STR WS damage Cape
		JSE.DEX.WSD	= "" --DEX WS damage Cape	
		JSE.AGI.WSD	= "" --AGI WS damage Cape
		JSE.CHR.WSD	= "" --CHR WS damage Cape
		JSE.INT.WSD	= "" --INT WS damage Cape
		JSE.MND.WSD	= "" --MND WS damage Cape
--[CASTING CAPES]
		
		JSE.CHR.FAS	= "" --MND FAST CAST CAPE
		JSE.MND.FAS	= "" --MND FAST CAST CAPE
		JSE.INT.FAS	= "" --INT FAST CAST CAPE
		JSE.SID		= "" --SPELL INTERRUPTION RATE CAPE
		JSE.CHR.MAB = "" --MAGIC ATTACK BONUS CAPE
		JSE.INT.MAB = "" --MAGIC ATTACK BONUS CAPE
		JSE.MND.MAB = "" --MAGIC ATTACK BONUS CAPE
--[MELEE CAPES]		
		JSE.CRT		= "" --CRITICAL HIT CAPE
		JSE.STP		= "" --STORE TP CAPE
		JSE.DWL		= "" --Dual wield Cape
		JSE.HAS		= "" --HASTE CAPE	
--[IDLE CAPES]		
		JSE.IDL.REG	= "" --REGEN CAPE
		JSE.IDL.DT	= "" --REGEN CAPE
		JSE.IDL.RES	= "" --REGEN CAPE
--------------------
--//////////////////
--AMBUSCADE GEAR
--//////////////////		
--------------------
--[Inyanga ARMOR]-[INY]
--------------------    
	INY = {}		--Leave This Empty
		INY.HED	= "Inyanga Tiara +2"
		INY.BOD	= "Inyanga Jubbah +2"
		INY.HND	= "Inyanga Dastanas +2"
		INY.LEG	= "Inyanga Shalwar +2"
		INY.FEE	= "Inyanga Crackows +2"
		INY.RNG = "Inyanga Ring"
--------------------
--[AYANMO ARMOR]-[AYA]
--------------------    
	AYA = {}		--Leave This Empty
		AYA.HED	= "Ayanmo Zucchetto +2"
		AYA.BOD	= "Ayanmo Corazza +2"
		AYA.HND	= "Ayanmo Manopolas +2"
		AYA.LEG	= "Ayanmo Cosciales +2"
		AYA.FEE	= "Ayanmo Gambieras +2"
		AYA.RNG = "Ayanmo Ring"
--------------------
--//////////////////
--ESCHA GEAR
--//////////////////		
--------------------
--------------------
--[PSYCLOTH ARMOR]-[PSY]
--------------------    
	PSY = {}		--Leave This Empty
		PSY.HED	= "Psycloth Tiara"
		PSY.BOD	= "Psycloth vest"
		PSY.HND	= "Psycloth Manillas"
		PSY.LEG	= "Psycloth Lappas"
		PSY.FEE	= "Psycloth boots"
--------------------
--[VANYA ARMOR]-[VAN]
--------------------    
	VAN = {}		--Leave This Empty
		VAN.HED	= "Vanya Hood"
		VAN.BOD	= "Vanya Robe"
		VAN.HND	= "Vanya Cuffs"
		VAN.LEG	= "Vanya Slops"
		VAN.FEE	= "Vanya Clogs"
--------------------
--[DESPAIR ARMOR]-[DES]
--------------------    
	DES = {}		--Leave This Empty
		DES.HED	= "Despair Helm"
		DES.BOD	= "Despair Mail"
		DES.HND	= "Despair Finger Gauntlets"
		DES.LEG	= "Despair Cuisses"
		DES.FEE	= "Despair Greaves"
		
--------------------
--[CHIRONIC ARMOR]-[CHI]
--------------------    
	CHI = {}		--Leave This Empty
		CHI.HED	= "Chironic Hat"
		CHI.BOD	= "Chironic Doublet"
		CHI.HND	= "Chironic Gloves"
		CHI.LEG	= "Chironic Hose"
		CHI.FEE	= "Chironic Slippers"
--------------------
--[MERLINIC]-[MER]
--------------------    
	MER = {}		--Leave This Empty
		MER.HED	= "Merlinic Hood"
		MER.BOD	= "Merlinic Jubbah"
		MER.HND	= "Merlinic Dastanas"
		MER.LEG	= "Merlinic Shalwar"
		MER.FEE	= "Merlinic Crackows"
--------------------
--//////////////////
--ABJURATION GEAR
--//////////////////		
--------------------
--[CARMINE]-[CAR]
--------------------    
	CAR = {}		--Leave This Empty
		CAR.HED	= "Carmine Mask +1"
		CAR.BOD	= "Carmine Scale Mail"
		CAR.HND	= "Carmine Finger Gauntlets"
		CAR.LEG	= "Carmine Cuisses +1"
		CAR.FEE	= "Carmine Greaves"
--------------------
--[KAYKAUS]-[KAY]
--------------------    
	KAY = {}		--Leave This Empty
		KAY.HED	= "Kaykaus Mitra"
		KAY.BOD	= "Kaykaus Bliaut"
		KAY.HND	= "Kaykaus Cuffs"
		KAY.LEG	= "Kaykaus Tights"
		KAY.FEE	= "Kaykaus Boots"
--------------------
--[AMALRIC]-[AMA]
--------------------    
	AMA = {}		--Leave This Empty
		AMA.HED	= "Amalric Coif +1"
		AMA.BOD	= "Amalric Doublet +1"
		AMA.HND	= "Amalric Gages +1"
		AMA.LEG	= "Amalric Slops +1"
		AMA.FEE	= "Amalric Nails +1"
---------------------
--//////////////////
--SKIRMISH GEAR
--//////////////////		
--------------------
--[TAEON]-[TAE]
--------------------    
	TAE = {}
		TAE.HED	= "Taeon Chapeau"
		TAE.BOD	= "Taeon Tabard"
		TAE.HND	= "Taeon Gloves"
		TAE.LEG	= "Taeon Tights"
		TAE.FEE	= "Taeon Boots"	
--------------------
--[TELCHINE]-[TEL]
--------------------    
	TEL = {}
		TEL.HED	= "Telchine Cap"
		TEL.BOD	= "Telchine Chasuble"
		TEL.HND	= "Telchine Gloves"
		TEL.LEG	= "Telchine Braconi"
		TEL.FEE	= "Telchine Pigaches"	
--SETS
--Leave weapons out of the idles and melee sets. You can/should add weapons to the casting sets though
--BLANK FULL GEAR SET TEMPLATE
		--ammo		=	"",
		--head		=	"",
		--body		=	"",
		--hands		=	"",
		--legs		=	"",
		--feet		=	"",
		--neck		=	"",
		--waist		=	"",
		--left_ear	=	"",
		--right_ear	=	"",
		--left_ring	=	"",
		--right_ring	=	"",
		--back		=	""
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
--[IDLE]-[REFRESH]-[NORMAL]
---------------
	sets.me.idle.town = {
		head		=	"Malignance Chapeau",
		body		= 	"Malignance Tabard",
		hands		= 	"Malignance Gloves",
		legs		= 	"Malignance Tights",
		feet		= 	"Malignance Boots",
		neck		=	"Duelist's Torque +2",
		waist		=	"Reiki Yotai",
		left_ear	=	"Malignance Earring",
		right_ear	=	"Sherida Earring",
		left_ring	=	"Freke Ring",
		right_ring	=	"Defending Ring",
		back		=	"Moonbeam Cape",
	}	
---------------
--[IDLE]-[REFRESH]-[NORMAL]
---------------
 	sets.me.idle.refresh = {
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body=ART.BOD,
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Merlinic Shalwar", augments={'Attack+14','MND+8','"Refresh"+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Thureous Earring",
		left_ring="Karieyh Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}	
---------------
--[IDLE]-[REFRESH]-[NORMAL]
---------------
 	sets.me.idle.H2H = {
		ammo="Saunch Tathlum",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Thureous Earring",
		left_ring="Karieyh Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
---------------
--[IDLE]-[REFRESH]-[PDT]
---------------
	sets.me.idle.dt = {
		Ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body=ART.BOD,
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Thureous Earring",
		left_ring="Karieyh Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
---------------
--[IDLE]-[REFRESH]-[DYNA]
---------------
	sets.me.idle.dyna = {
		ammo="Staunch Tathlum",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
---------------
--[IDLE]-[REFRESH]-[DYNA]
---------------
	sets.me.idle.BOW = {
	    range="Kaja Bow",
		ammo="Chapuli Arrow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Jhakri Robe +2",
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Merlinic Shalwar", augments={'Attack+14','MND+8','"Refresh"+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Thureous Earring",
		left_ring="Karieyh Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
---------------
--[RESTING]
---------------
    sets.me.resting = { 

    }
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
		--WE GET A STUPID POWERFUL SHIELD IN THE BEATIFIC SHIELD, WHICH GIVES +25%MDT, AND BLOCK RATES. 
		--WE CAN EASILY SIT AT CAPPED REDUCTION WITHOUT HURTING OUR ABILITY TO PERFORM MUCH.
---------------	
--[MELEE]-[DUALWIELD]-[NORMAL]
---------------
    sets.me.melee.normaldw ={
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring",
		back={ name="Sucellos's Cape", augments={'DEX+15','Accuracy+20 Attack+20','"Dual Wield"+10',}},
	}
---------------
--[MELEE]-[DUALWIELD]-[ACC]
---------------
    sets.me.melee.FullHastedw = {
		ammo="Ginsen",	
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt",
		left_ear="Brutal Earring",				
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
		}
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.dtdw = set_combine(sets.me.melee.normaldw,{
		Ammo		=	"Staunch Tathlum",
		head		=	"Malignance Chapeau",
		body		=	"Malignance Tabard",
		hands		=	"Malignance Gloves",
		legs		=	"Malignance Tights",
		feet		=	"Malignance Boots",
		neck		=	"Loricate Torque +1",
		right_ring	=	"Defending Ring"
    })
---------------
--[MELEE]-[DUALWIELD]-[ODIN]
---------------
    sets.me.melee.Odindw ={
		range="Kaja Bow",
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck={ name="Duelist's Torque +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Sherida Earring",
		left_ring="Hetairoi Ring",
		right_ring="Jhakri Ring",
		back={ name="Sucellos's Cape", augments={'DEX+15','Accuracy+20 Attack+20','"Dual Wield"+10',}},
	}
    sets.me.melee.H2Hdw = {
		main="Kaja Knuckles",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Chiner's Belt +1",
		left_ear="Mache Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
		}
    sets.me.melee.H2Hsw = {
		main="Kaja Knuckles",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Chiner's Belt +1",
		left_ear="Mache Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
		}
    sets.me.melee.BOWdw = {
	    range="Kaja Bow",
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Chiner's Belt +1",
		left_ear="Mache Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
		}
    sets.me.melee.BOWsw = {
	    range="Kaja Bow",
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Chiner's Belt +1",
		left_ear="Mache Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
		}
---------------
--[MELEE]-[SWORD&BOARD]-[NORMAL]
---------------
    sets.me.melee.normalsw = set_combine(sets.me.melee.normaldw,{   
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
    })
---------------
--[MELEE]-[SWORD&BOARD]-[ACCURACY]
---------------
    sets.me.melee.FullHastesw = set_combine(sets.me.melee.accdw,{
		back={ name="Sucellos's Cape", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
    })
---------------
--[MELEE]-[SWORD&BOARD]-[PDT]
---------------
    sets.me.melee.dtsw = set_combine(sets.me.melee.dtdw,{
		head		=	"Malignance Chapeau",
		body		=	"Malignance Tabard",
		hands		=	"Malignance Gloves",
		legs		=	"Malignance Tights",
		feet		=	"Malignance Boots",
		neck		=	"Loricate Torque +1",
		waist		=	"Reiki Yotai",
		left_ear	=	"Infused Earring",
		right_ear	=	"Ethereal Earring",
		right_ring	=	"Defending Ring",
		back		=	"Moonbeam Cape"
    })

--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]-[CLUB]-[BLACK HALO]-[MOD:70%MND/30%STR/P.ATTK]-[ELEMENT:Fragmentation/compression]
---------------
	sets.me["Black Halo"] = {
		ammo="Ginsen",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet={ name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck=REL.NEK,
		waist="Prosilio Belt +1",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Karieyh Ring",
		right_ring="Shukuyu Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}},
    }
	sets.me["Empyreal Arrow"] = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Marked Gorget",
		waist="Caudata Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Enervating Earring",
		left_ring="Karieyh Ring",
		right_ring="Hajduk Ring",
		back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Atk.+10','Weapon skill damage +10%',}},
    }

    sets.me["Asuran Fists"] = {
		ammo		= "Ginsen",
		head		= "Viti. Chapeau +3",
		body		= "Viti. Tabard +3",
		hands		= "Atrophy Gloves +3",
		legs		= "Jhakri Slops +2",
		feet		= "Jhakri Pigaches +2",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Brutal Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Rufescent Ring",
		right_ring	= "Shukuyu Ring",
		back		= SUC.WSD
	}
    sets.me["Raging Fists"] = {
		ammo		= "Ginsen",
		head		= "Viti. Chapeau +3",
		body		= "Viti. Tabard +3",
		hands		= "Atrophy Gloves +3",
		legs		= "Jhakri Slops +2",
		feet		= "Jhakri Pigaches +2",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Rufescent Ring",
		right_ring	= "Shukuyu Ring",
		back		= SUC.WSD
	}
---------------
--[WEAPONSKILL]-[SWORD]-[SAVAGE BLADE]-[MOD:50%MND/50%STR/P.ATTK]-[ELEMENT:Fragmentation/Scission]
---------------
    sets.me["Savage Blade"] = {
		ammo="Ginsen",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet={ name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck=REL.NEK,
		waist="Prosilio Belt +1",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Karieyh Ring",
		right_ring="Shukuyu Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}},
	}
---------------
--[WEAPONSKILL]-[SWORD]-[REQUIESCAT]-[MOD:85%MND/P.ATTK/Gorget]-[ELEMENT:Gravitation/Scission]
---------------
    sets.me["Requiescat"] = {
		ammo="Ginsen",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Rufescent Ring",
		right_ring="Shukuyu Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[CHANT DU CYGNE]-[MOD:80%DEX/P.ATTK/Gorget]-[ELEMENT:Light/Distortion]
---------------
    sets.me["Chant du Cygne"] = {
		Ammo		= "Yetshila",
		head		= "Malignance Chapeau",
		body		= AYA.BOD,
		hands		= "Malignance Gloves",
		legs		= JHA.LEG,
		feet		= "Thereoid Greaves",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Mache Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Begrudging Ring",
		right_ring	= "Shukuyu Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+8','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SANGUINE BLADE]-[MOD:30%STR/50%MND/M.ATTK]-[ELEMENT: DARK (NO SC ELEMENT)]
---------------
    sets.me["Sanguine Blade"] = {
		head		= "Pixie Hairpin +1",
		body		= AMA.BOD,
		hands		= JHA.HND,
		legs		= AMA.LEG,
		feet		= AMA.FEE,
		neck		= "Baetyl Pendant",
		waist		= "Refoccilation Stone",
		left_ear	= "Malignance Earring",
		right_ear	= "Friomisi Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[RED LOTUS BLADE]-[MOD:40%STR/40%INT/M.ATTK]-[ELEMENT:Liquefaction]
---------------
    sets.me["Red Lotus Blade"] = {
		head		= "C. Palug Crown",
		body		= AMA.BOD,
		hands		= JHA.HND,
		legs		= AMA.LEG,
		feet		= AMA.FEE,
		neck		= "Baetyl Pendant",
		waist		= "Refoccilation Stone",
		left_ear	= "Malignance Earring",
		right_ear	= "Friomisi Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Freke Ring",
		back		= SUC.WSD,
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SERAPH BLADE]-[MOD:40%STR/40%MND/M.ATTK]-[ELEMENT:Scission]
---------------
    sets.me["Seraph Blade"] = {
		ammo		= "Pemphredo Tathlum",
		head		= "C. Palug Crown",
		body		= AMA.BOD,
		hands		= JHA.HND,
		legs		= AMA.LEG,
		feet		= AMA.FEE,
		neck		= "Baetyl Pendant",
		waist		= "Refoccilation Stone",
		left_ear	= "Malignance Earring",
		right_ear	= "Friomisi Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[DEATH BLOSSOM]-[MOD:50%MND/30%STR/P.ATTK]-[ELEMENT:FRAGMENTATION/DISTORTION]
---------------
    sets.me["Death Blossom"] = {
		ammo 		= "Ginsen",	
		head		= REL.HED,
		body		= REL.BOD,
		hands		= ART.HND,
		legs		= JHA.LEG,
		feet		= {name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck		= "Caro Necklace",
		waist		= "Prosilio Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Ishvara Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Shukuyu Ring",
		back		= SUC.WSD,
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SWIFT BLADE]-[MOD:50%MND/50%STR/P.ATTK/GORGET]-[ELEMENT:GRAVITATION] -[REQUIRES HOMINILARY SWORD]
---------------
    sets.me["SWIFT BLADE"] = {
		head		= REL.HED,
		body		= AYA.BOD,
		hands		= ART.HND,
		legs		= JHA.LEG,
		feet		= JHA.FEE,
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Shukuyu Ring",
		right_ring	= "Rufescent Ring",
		back		= SUC.WSD,
    }	
---------------
--[WEAPONSKILL]-[SWORD]-[SWIFT BLADE]-[MOD:50%MND/50%STR/P.ATTK/GORGET]-[ELEMENT:GRAVITATION] -[REQUIRES HOMINILARY SWORD]
---------------
    sets.me["Circle Blade"] = {
		ammo 		= "Ginsen",	
		head		= REL.HED,
		body		= REL.BOD,
		hands		= ART.HND,
		legs		= JHA.LEG,
		feet		= {name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck		= "Caro Necklace",
		waist		= "Prosilio Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Ishvara Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Shukuyu Ring",
		back		= SUC.WSD,
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[AEOLIAN EDGE]-[MOD:40%DEX/40%INT/M.ATTK]-[ELEMENT: IMPACTION/SCISSION/DETONATION]
---------------
    sets.me["Aeolian Edge"] = {
		head		= "C. Palug Crown",
		body		= AMA.BOD,
		hands		= JHA.HND,
		legs		= AMA.LEG,
		feet		= AMA.FEE,
		neck		= "Baetyl Pendant",
		waist		= "Refoccilation Stone",
		left_ear	= "Malignance Earring",
		right_ear	= "Moonshade Earring",
		left_ring	= "Karieyh Ring",
		right_ring	= "Freke Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+8','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[EVISCERATION]-[MOD:50%DEX/P.ATTK/GORGET]-[ELEMENT:GRAVITATION/TRANSFIXION]
---------------
    sets.me["Evisceration"] = {
		Ammo		= "Yetshila",
		head		= "Malignance Chapeau",
		body		= AYA.BOD,
		hands		= "Malignance Gloves",
		legs		= JHA.LEG,
		feet		= "Thereoid Greaves",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Mache Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Begrudging Ring",
		right_ring	= "Shukuyu Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+8','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[EXTENERATOR]-[MOD:85%AGI/P.ATTK/GORGET]-[ELEMENT:FRAGMENTATION/SCISSION]
---------------
    sets.me["Exenterator"] = {
		ammo		= "Ginsen",
		head		= "Viti. Chapeau +3",
		body		= "Viti. Tabard +3",
		hands		= "Atrophy Gloves +3",
		legs		= "Jhakri Slops +2",
		feet		= "Jhakri Pigaches +2",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Brutal Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Rufescent Ring",
		right_ring	= "Shukuyu Ring",
		back		= SUC.WSD
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Drain"] = {
		head		= REL.HED,
		body		= REL.BOD,
		hands		= ART.HND,
		legs		= JHA.LEG,
		feet		= JHA.FEE,
		neck		= "Nuna Gorget",
		waist		= "Luminary Sash",
		left_ear	= "Malignance Earring",
		right_ear	= "Moonshade Earring",
		left_ring	= "Levia. Ring",
		right_ring	= "Levia. Ring",
		back		= "Swith Cape",
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
	
	sets.precast[""] = {

	}

	
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
    sets.precast.cure = set_combine(sets.precast.casting,{})

---------------
--[PRECASTING]-[CHAINSPELL]
---------------
    sets.precast["Chainspell"] = {body = REL.Body}
--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	

	sets.midcast[""] = {

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
    sets.midcast.Orpheus = {}  
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

    }
	
    sets.midcast['Finale'] = {neck = REL.NEK}	
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {
		Main="Daybreak",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Friomisi Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
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
		neck="Mizu. Kubikazari"
    })
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = {
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet="Jhakri Pigaches +2",
		neck="Sanctity Necklace",
		waist="Refoccilation Stone",
		left_ear="Friomisi Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
	}
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {
		neck="Mizu. Kubikazari"
    })	
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast["Drain"] = {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Genbu's Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic burst dmg.+10%','Mag. Acc.+3','"Mag.Atk.Bns."+7',}},
		feet="Merlinic Crackows",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring",
		right_ring="Evanescence Ring",
		back="Merciful Cape",
	}
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast["Aspir"] = sets.midcast["Drain"]
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
    sets.midcast.Enfeebling.macc = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+8','Mag. Acc.+23','Magic Damage +1',}},
		sub="Enki Strap",
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[ENFEEBLING Raw Potency]
---------------
    sets.midcast.Enfeebling.potency = {
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},    }
---------------
--[MIDCASTING]-[ENFEEBLING MIND]
---------------
    sets.midcast.Enfeebling.mndpot = {
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[ENFEEBLING MIND & SKILL]
---------------
    sets.midcast.Enfeebling.skillmndpot = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+8','Mag. Acc.+23','Magic Damage +1',}},
		sub="Mephitis Grip",
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},    }
---------------
--[MIDCASTING]-[ENFEEBLING INTELLIGENCE]
---------------
    sets.midcast.Enfeebling.intpot = {
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[ENFEEBLING SKILL]
---------------
    sets.midcast.Enfeebling.skillpot = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+8','Mag. Acc.+23','Magic Damage +1',}},
		sub="Mephitis Grip",
		range="Kaja Bow",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands="Leth. Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Malignance Earring",
		right_ear="Aredan Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[STUN]
---------------
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.macc, {})

---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {
		Sub			= 	"Ammurapi Shield",
		head		=	TEL.HED,
		body		=	REL.BOD,
		hands		=	ART.HND,
		legs		=	TEL.LEG,
		feet		=	EMP.FEE,
		neck		=	REL.NEK,
		waist		=	"Olympus Sash",
		left_ear	=	"Etiolation earring",
		right_ear	=	"Andoaa Earring",
		left_ring	=	"Stikini Ring",
		right_ring	=	"Stikini Ring",
		back		=	SUC.MAB
    }
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration, {
		main		=	"Pukulatmuj +1",
		sub			=	"Secespita",
		head		=	"Befouled Crown",
		body		=	REL.BOD,
		hands		=	REL.HND,
		legs		=	ART.LEG,
		feet		=	EMP.FEE,
		neck		=	"Incanter's Torque",
		waist		=	"Olympus Sash",
		left_ear	=	"Etiolation earring",
		right_ear	=	"Andoaa Earring",
		left_ring	=	"Stikini Ring",
		right_ring	=	"Stikini Ring",
		back		=	"Estoqueur's Cape",
    })

---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------
    sets.midcast.enhancing.composure = set_combine(sets.midcast.enhancing.duration, {
		Sub			= 	"Ammurapi Shield",	
		head		=	EMP.HED,
		body		=	REL.BOD,
		hands		=	ART.HND,
		legs		=	EMP.LEG,
		feet		=	EMP.FEE,
		neck		=	"Duelist's Torque +2",
		waist		=	"Olympus Sash",
		left_ear	=	"Etiolation earring",
		right_ear	=	"Andoaa Earring",
		left_ring	=	"Stikini Ring",
		right_ring	=	"Stikini Ring",
		back		=	SUC.MAB,
    })  
---------------
--[MIDCASTING]-[OHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={
		main		= "Pukulatmuj +1",
		sub			= "Secespita",
		head		= { name="Taeon Chapeau", augments={'Attack+10','"Triple Atk."+2','Phalanx +3',}},
		body		= { name="Taeon Tabard", augments={'Accuracy+5','"Triple Atk."+1','Phalanx +3',}},
		hands		= { name="Taeon Gloves", augments={'Phalanx +2',}},
		legs		= { name="Taeon Tights", augments={'Phalanx +3',}},
		feet		= { name="Taeon Boots", augments={'Phalanx +2',}},
		neck		= "Incanter's Torque",
		waist		= "Olympus Sash",
		left_ear	= "Etiolation earring",
		right_ear	= "Andoaa Earring",
		left_ring	= "Stikini Ring",
		right_ring	= "Stikini Ring",
		back		= "Estoqueur's Cape",
    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {})
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {
	body=ART.BOD,
	legs="Leth. Fuseau +1",
	waist="Gishdubar Sash"
    })
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {
	})

---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
		head		=	VAN.HED,
		body		=	REL.BOD,
		hands		=	TEL.HND,
		legs		=	ART.LEG,
		feet		=	"Vanya Clogs",
		neck		=	"Incanter's Torque",
		waist		= 	"Gishdubar Sash",
		left_ear	=	"Etiolation Earring",
		right_ear	=   "Mendicant's Earring",
		left_ring	=	"Ephedra Ring",
		right_ring	=	"Ephedra Ring",	
		back		=	"Oretania's Cape", 	
    })
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{

    })    
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.regen = set_combine(sets.midcast.enhancing.duration, {
		body ="Telchine Chasuble",
    })
	
	sets.midcast["Inundation"] = set_combine(sets.midcast.Enfeebling.potency ,{
		hands={ name="Merlinic Dastanas", augments={'Magic dmg. taken -2%','Pet: VIT+6','"Treasure Hunter"+1','Accuracy+11 Attack+11','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		feet={ name="Chironic Slippers", augments={'MND+1','"Fast Cast"+1','"Treasure Hunter"+2','Accuracy+14 Attack+14','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		waist="Chaac Belt",
	})

end