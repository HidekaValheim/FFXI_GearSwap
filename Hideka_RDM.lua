include('organizer-lib')
include('Modes.lua')
res = require('resources')
texts = require('texts')

send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
send_command('wait 30;input //gs validate') 

organizer_items = {
    Consumables={"Echo Drops","Holy Water", "Remedy"},
    NinjaTools={"Shihei"},
	Food={"Tropical Crepe", "Sublime Sushi", "Om. Sandwich"},
	Storage={"Storage Slip 16","Storage Slip 18","Storage Slip 21","Storage Slip 23","Storage Slip 24",
			"Storage Slip 25","Storage Slip 26","Storage Slip 27","Storage Slip 28"}
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

if PortTowns:contains(world.area) then
	send_command('wait 3;input //gs org') 
	send_command('wait 6;input //po repack') 
else
	add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
end

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh', 'dt','dt2','dt3')
meleeModes = M('Enspell', 'FullHaste', 'FULLACC', 'dt')
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
mainWeapon = M('Crocea Mors','Naegling','Excalibur','Tauret','Maxentius','Daybreak','Contemplator +1')
subWeapon = M('Demers. Degen +1',"Sakpata's Sword",'Daybreak','Machaera +3','Naegling','Ternion Dagger +1','Tauret','Sacro Bulwark','Ammurapi Shield', 'Enki Strap')
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

send_command('lua l gearinfo')
send_command('lua l equipviewer')
send_command('lua l parse')
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

include('RDM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,1) -- Sheet, Book
send_command('wait 10;input /lockstyleset 1')
refreshType = idleModes[1] -- leave this as is  
  
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 1')
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
		ART.HED	= "Atro. Chapeau +1"
		ART.BOD	= "Atrophy Tabard +3"
		ART.HND	= "Atrophy Gloves +3"
		ART.LEG	= "Atrophy Tights +2"
		ART.FEE	= "Atrophy Boots +1"
		
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
		EMP.HED	= "Leth. Chappel +1"
		EMP.BOD	= "Lethargy Sayon +1"
		EMP.HND	= "Leth. Gantherots +1"
		EMP.LEG	= "Leth. Fuseau +1"
		EMP.FEE	= "Leth. Houseaux +1"
--------------------
--[SUCCELLOS CAPES]-[JSE]
--------------------  
	JSE = {}		--Leave This Empty
		JSE.WSD = {}
			JSE.WSD.MNDMAG 	= {name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}}
			JSE.WSD.STRATK 	= {name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}}
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
			JSE.MELEE.DW 	= {name="Sucellos's Cape", augments={'DEX+15','Accuracy+20 Attack+20','"Dual Wield"+10',}}
			JSE.MELEE.CRIT 	= {name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}

--------------------
--//////////////////
--AMBUSCADE GEAR
--//////////////////		
--------------------
--[JHKARI ARMOR]-[JHA]
--------------------    
	JHA = {}		--Leave This Empty
		JHA.HED	= "Jhakri Coronal +2"
		JHA.BOD	= "Jhakri Robe +2"
		JHA.HND	= "Jhakri Cuffs +2"
		JHA.LEG	= "Jhakri Slops +2"
		JHA.FEE	= "Jhakri Pigaches +2"
		JHA.RNG = "Jhakri Ring"
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
 	sets.me.idle.refresh = {
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body=JHA.BOD,
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs={ name="Merlinic Shalwar", augments={'Attack+14','MND+8','"Refresh"+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Cryptic Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},
		back="Moonbeam Cape",
	}		

---------------
--[IDLE]-[REFRESH]-[PDT]
---------------
	sets.me.idle.dt = {
		ammo="Staunch Tathlum",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Jhakri Robe +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Cryptic Earring",
		left_ring="Stikini Ring +1",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}
	sets.me.idle.dt2 = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm",
		waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring="Stikini Ring +1",
		right_ring="Defending Ring",
		back="Aurist's Cape +1",
	}
	sets.me.idle.dt3 = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring="Purity Ring",
		right_ring="Defending Ring",
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
		--WE GET A STUPID POWERFUL SHIELD IN THE BEATIFIC SHIELD, WHICH GIVES +25%MDT, AND BLOCK RATES. 
		--WE CAN EASILY SIT AT CAPPED REDUCTION WITHOUT HURTING OUR ABILITY TO PERFORM MUCH.

---------------	
--[MELEE]-[DUALWIELD]-[NORMAL]
---------------
    sets.me.melee.FULLACCdw ={
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
		back=JSE.MELEE.STP
	}
---------------	
--[MELEE]-[DUALWIELD]-[NORMAL]
---------------
    sets.me.melee.FULLACCsw ={
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
		back=JSE.MELEE.STP
	}
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
		left_ear="Eabani Earring",				
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back=JSE.MELEE.STP 
		}
    sets.me.melee.FullHastesw = {
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Dedition Earring",				
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back=JSE.MELEE.STP 
		}
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.dtdw = set_combine(sets.me.melee.normaldw,{
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring="Defending Ring",
		back=JSE.MELEE.STP

    })
---------------
--[MELEE]-[DUALWIELD]-[ODIN]
---------------

    sets.me.melee.Enspelldw ={
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Ayanmo Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
		back={ name="Sucellos's Cape", augments={'DEX+15','Accuracy+20 Attack+20','"Dual Wield"+10',}},

	}
    sets.me.melee.Enspellsw ={
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Ayanmo Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe3"},
		back=JSE.MELEE.STP
	}
---------------
--[MELEE]-[SWORD&BOARD]-[NORMAL]
---------------
    sets.me.melee.FULLACCsw = set_combine(sets.me.melee.FULLACCdw,{   
		back=JSE.MELEE.STP
    })
---------------
--[MELEE]-[SWORD&BOARD]-[ACCURACY]
---------------
    sets.me.melee.FullHastesw = set_combine(sets.me.melee.FullHastedw,{
		back=JSE.MELEE.STP
    })
---------------
--[MELEE]-[SWORD&BOARD]-[PDT]
---------------
    sets.me.melee.dtsw = set_combine(sets.me.melee.dtdw,{
		head		= "Malignance Chapeau",
		body		= "Malignance Tabard",
		hands		= "Malignance Gloves",
		legs		= "Malignance Tights",
		feet		= "Malignance Boots",
		neck		= "Anu Torque",
		waist		= "Grunfeld Rope",
		left_ear	= "Telos Earring",
		right_ear	= "Sherida Earring",
		right_ring	= "Defending Ring",
		back		= JSE.MELEE.STP
    })

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
		head		= {name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body		= "Nyame Mail",
		hands		= "Atrophy Gloves +3",
		legs		= "Malignance Tights",
		feet		= {name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck		= REL.NEK,
		waist		= "Sailfi Belt +1",
		left_ear	= {name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear	= "Ishvara Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Epaminondas's Ring",
		back		= JSE.WSD.STRATK	
	}

	sets.me["Black Halo"] = set_combine(sets.me.STRWSD ,{ammo="Regal Gem", right_ear="Regal Earring", left_ring="Metamorph Ring +1"})
    sets.me["Savage Blade"] = set_combine(sets.me.STRWSD ,{ammo="Regal Gem", right_ear="Regal Earring", left_ring="Metamorph Ring +1"})
    sets.me["Knights of Round"] = set_combine(sets.me.STRWSD ,{ammo="Regal Gem", right_ear="Regal Earring", left_ring="Metamorph Ring +1"})	


	sets.me.MAGWS = {
		ammo		= "Regal Gem",
		head		= "C. Palug Crown",
		body		= "Nyame Mail",
		hands		= JHA.HND,
		legs		= AMA.LEG,
		feet		= "Nyame Sollerets",
		neck		= "Baetyl Pendant",
		waist		= "Orpheus's Sash",
		left_ear	= "Regal Earring",
		right_ear	= "Moonshade Earring",
		left_ring	= "Metamorph Ring +1",
		right_ring	= "Freke Ring",
		back		= JSE.WSD.MNDMAG,
	
	}
---------------
--[WEAPONSKILL]-[SWORD]-[SANGUINE BLADE]-[MOD:30%STR/50%MND/M.ATTK]-[ELEMENT: DARK (NO SC ELEMENT)]
---------------
    sets.me["Sanguine Blade"] = set_combine(sets.me.MAGWS,{
		head		= "Pixie Hairpin +1",
		right_ear	= "Malignance Earring",
		left_ring	= "Metamorph Ring +1",
		right_ring	= "Freke Ring",
		back		= JSE.MAG.NUKE
    })
---------------
--[WEAPONSKILL]-[SWORD]-[RED LOTUS BLADE]-[MOD:40%STR/40%INT/M.ATTK]-[ELEMENT:Liquefaction]
---------------
    sets.me["Red Lotus Blade"] = set_combine(sets.me.MAGWS, {})
    sets.me["Seraph Blade"] = set_combine(sets.me.MAGWS, {})
    sets.me["Aeolian Edge"] = set_combine(sets.me.MAGWS, {})

    sets.me["Asuran Fists"] = {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Nyame Sollerets",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Petrov Ring",
		back		= { name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}}
	}

    sets.me["Raging Fists"] = {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Nyame Sollerets",
		neck		= "Fotia Gorget",
		waist		= "Fotia Belt",
		left_ear	= "Moonshade Earring",
		right_ear	= "Sherida Earring",
		left_ring	= "Ilabrat Ring",
		right_ring	= "Petrov Ring",
		back		= { name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}}
	}

---------------
--[WEAPONSKILL]-[SWORD]-[REQUIESCAT]-[MOD:85%MND/P.ATTK/Gorget]-[ELEMENT:Gravitation/Scission]
---------------
    sets.me["Requiescat"] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Ilabrat Ring",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[CHANT DU CYGNE]-[MOD:80%DEX/P.ATTK/Gorget]-[ELEMENT:Light/Distortion]
---------------
    sets.me["Chant du Cygne"] = {
		ammo="Yetshila",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Begrudging Ring",
		right_ring="Ilabrat Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
    }

---------------
--[WEAPONSKILL]-[SWORD]-[DEATH BLOSSOM]-[MOD:50%MND/30%STR/P.ATTK]-[ELEMENT:FRAGMENTATION/DISTORTION]
---------------
    sets.me["Death Blossom"] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Nyame Mail",
		hands="Atrophy Gloves +3",
		legs="Nyame Flanchard",
		feet={ name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Sherida Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Metamorph Ring +1",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[SWORD]-[SWIFT BLADE]-[MOD:50%MND/50%STR/P.ATTK/GORGET]-[ELEMENT:GRAVITATION] -[REQUIRES HOMINILARY SWORD]
---------------
    sets.me["Circle Blade"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Nyame Mail",
		hands="Atrophy Gloves +3",
		legs="Nyame Flanchard",
		feet={ name="Chironic Slippers", augments={'"Conserve MP"+2','Pet: "Mag.Atk.Bns."+2','Weapon skill damage +8%','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Ishvara Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+19 Attack+19','STR+10','Weapon skill damage +10%',}},
    }

---------------
--[WEAPONSKILL]-[DAGGER]-[EVISCERATION]-[MOD:50%DEX/P.ATTK/GORGET]-[ELEMENT:GRAVITATION/TRANSFIXION]
---------------
    sets.me["Evisceration"] = {
		ammo="Yetshila",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Begrudging Ring",
		right_ring="Ilabrat Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
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
		back={ name="Sucellos's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Atk.+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Drain"] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring	= "Metamorph Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
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
	
	sets.me["Provoke"] = {
		ammo = "Sapience Orb",		--+2
	    head="Halitus Helm", 		--+8
		body="Emet Harness",		--+9
		hands="Malignance Gloves",	--+0
		legs="Zoar Subligar",		--+5
		feet="Nyame Sollerets",		
		neck="Warder's Charm",		--+9
		left_ear="Friomisi Earring",--+2	
		right_ear="Cryptic Earring",--+4
		left_ring="Provocare Ring",	--+5
		right_ring="Begrudging Ring",	--+4
		back="Reiki Cloak",			--+6
	}								--TOTAL:+55
	sets.me["Warcry"] = {
		ammo = "Sapience Orb",		--+2
	    head="Halitus Helm", 		--+8
		body="Emet Harness",		--+9
		hands="Malignance Gloves",	--+0
		legs="Zoar Subligar",		--+5
		feet="Nyame Sollerets",		
		neck="Warder's Charm",		--+9
		left_ear="Friomisi Earring",--+2	
		right_ear="Cryptic Earring",--+4
		left_ring="Provocare Ring",	--+5
		right_ring="Begrudging Ring",	--+4
		back="Reiki Cloak",			--+6
	}								--TOTAL:+55
	sets.me["Sentinel"] = {
		ammo = "Sapience Orb",		--+2
	    head="Halitus Helm", 		--+8
		body="Emet Harness",		--+9
		hands="Malignance Gloves",	--+0
		legs="Zoar Subligar",		--+5
		feet="Nyame Sollerets",		
		neck="Warder's Charm",		--+9
		left_ear="Friomisi Earring",--+2	
		right_ear="Cryptic Earring",--+4
		left_ring="Provocare Ring",	--+5
		right_ring="Begrudging Ring",	--+4
		back="Reiki Cloak",			--+6
	}								--TOTAL:+55
	sets.me["Shield Bash"] = {
		ammo = "Sapience Orb",		--+2
	    head="Halitus Helm", 		--+8
		body="Emet Harness",		--+9
		hands="Malignance Gloves",	--+0
		legs="Zoar Subligar",		--+5
		feet="Nyame Sollerets",		
		neck="Warder's Charm",		--+9
		left_ear="Friomisi Earring",--+2	
		right_ear="Cryptic Earring",--+4
		left_ring="Provocare Ring",	--+5
		right_ring="Begrudging Ring",	--+4
		back="Reiki Cloak",			--+6
	}								--TOTAL:+55
	
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
		ammo="Staunch Tathlum",
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
		right_ring="Defending Ring",
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
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head=none,
		body="Twilight Cloak",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Oneiros Belt",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
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
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
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
		ammo="Staunch Tathlum",
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
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
	sets.midcast.StatusRemoval={
		ammo="Staunch Tathlum",
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
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},		
	}
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Hachirin-no-Obi",
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
		main="Bunzi's Rod",  --10/0
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ea Hat +1", --7/7
		body="Ea Houppe. +1", --9/9
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},--0/6
		legs="Ea Slops +1", --8/8
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Mizu. Kubikazari",--10/0
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mujin Band",--0/5
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
		--Burst1:44/40
		--Burst2:35/XX
	 })
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		range="Ullr",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Sanctity Necklace",
		waist="Hachirin-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
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
		neck="Mizu. Kubikazari",
		waist="Orpheus's Sash",
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
		body="Atrophy Tabard +3",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring= "Metamorph Ring +1",
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
		ammo="Regal Gem",
		head="Leth. Chappel +1",
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Leth. Fuseau +1",
		feet="Leth. Houseaux +1",
		neck="Dls. Torque +2",
		waist="Obstin. Sash",
		left_ear="Snotra Earring",		
		right_ear="Tuisto Earring",
		left_ring="Meridian Ring",		
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
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Erra Pendant",
		waist="Channeler's Stone",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},

    }
------------------------------------------
--------------[PURE ACC]------------------
    sets.midcast.Enfeebling.Dispel = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		range="Ullr",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
    sets.midcast.Enfeebling.Dispelga = {
		main = "Daybreak",
		sub="Ammurapi Shield",
		range="Ullr",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Atrophy Tabard +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.FrazzleII = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.Silence = set_combine(sets.midcast.Enfeebling.Dispel,{})
------------------------------------------
---------[MND + ACC + POTENCY]------------
    sets.midcast.Enfeebling.Addle = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
    sets.midcast.Enfeebling.Paralyze = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Slow = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Blind = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Channeler's Stone",
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
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }		
    sets.midcast.Enfeebling.Distract = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }	
-------------------------------------------
---------[INT + Skill + DURATION]----------
    sets.midcast.Enfeebling.Poison = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Mephitis Grip",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
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
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Cure" potency +6%','CHR+3','Mag. Acc.+6','"Mag.Atk.Bns."+9',}},
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
    sets.midcast.Enfeebling.Gravity = set_combine(sets.midcast.Enfeebling.Bind,{})

---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+5','"Mag.Atk.Bns."+20','DMG:+6',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum",
		head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +9',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +1",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Meridian Ring",
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
    }
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration, {
		main		= "Pukulatmuj +1",
		sub			= "Secespita",
		head		= "Befouled Crown",
		body		= REL.BOD,
		hands		= "Viti. Gloves +3",
		legs		= ART.LEG,
		feet		= EMP.FEE,
		neck		= "Incanter's Torque",
		waist		= "Olympus Sash",
		left_ear	= "Etiolation earring",
		right_ear	= "Andoaa Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},
		back		= { name="Ghostfyre Cape", augments={'Enfb.mag. skill +2','Enha.mag. skill +10','Enh. Mag. eff. dur. +18',}},
    })

---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------
    sets.midcast.enhancing.composure = set_combine(sets.midcast.enhancing.duration, {
		head		=	EMP.HED,
		body		=	REL.BOD,
		hands		=	ART.HND,
		legs		=	EMP.LEG,
		feet		=	EMP.FEE,
    })  
---------------
--[MIDCASTING]-[OHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={
		main		= "Sakpata's Sword",
		sub			= "Secespita",
		head		= { name="Taeon Chapeau", augments={'Attack+10','"Triple Atk."+2','Phalanx +3',}},
		body		= { name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands		= { name="Taeon Gloves", augments={'Phalanx +2',}},
		legs		= { name="Taeon Tights", augments={'Phalanx +3',}},
		feet		= { name="Taeon Boots", augments={'Phalanx +2',}},
		neck		= "Incanter's Torque",
		waist		= "Olympus Sash",
		left_ear	= "Etiolation earring",
		right_ear	= "Andoaa Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},
		back		= "Ghostfyre Cape",
    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {
		neck="Nodens Gorget",
		right_ear="Earthcry Earring",	
	})
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
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {})
---------------
--[MIDCASTING]-[Protect]
---------------
    sets.midcast.protect = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
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
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Sakpata's Sword",
		ammo="Staunch Tathlum",
		head={ name="Vanya Hood", augments={'MP+49','"Cure" potency +7%','Enmity-5',}},
		body="Nyame Mail",
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+1','"Regen" potency+2',}},
		legs="Atrophy Tights +2",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Tuisto Earring",
		left_ring="Meridian Ring",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    })
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{waist= "Hachirin-no-obi"})    
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.Regen = {    
		main="Bolelabunga",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum",
		head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +9',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','"Regen" potency+3',}},
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+1','"Regen" potency+2',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Regen" potency+3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		right_ring="Meridian Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}},
	}

	sets.midcast["Stone"] ={		
		head = "Wh. Rarab Cap +1",
		hands={ name="Merlinic Dastanas", augments={'Magic dmg. taken -2%','Pet: VIT+6','"Treasure Hunter"+1','Accuracy+11 Attack+11','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		waist="Chaac Belt",
		}

end