  
-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+F ]           Toggle Closed Position (Facing) Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Primary step element cycle forward.
--              [ CTRL+= ]          Primary step element cycle backward.
--              [ ALT+- ]           Secondary step element cycle forward.
--              [ ALT+= ]           Secondary step element cycle backward.
--              [ CTRL+[ ]          Toggle step target type.
--              [ CTRL+] ]          Toggle use secondary step.
--              [ Numpad0 ]         Perform Current Step
--
--              [ CTRL+` ]          Saber Dance
--              [ ALT+` ]           Chocobo Jig II
--              [ ALT+[ ]           Contradance
--              [ CTRL+Numlock ]    Reverse Flourish
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--              [ CTRL+Numpad+ ]    Climactic Flourish
--              [ CTRL+NumpadEnter ]Building Flourish
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad6 ]    Pyrrhic Kleos
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c step                       Uses the currently configured step on the target, with either <t> or
--                                  <stnpc> depending on setting.
--  gs c step t                     Uses the currently configured step on the target, but forces use of <t>.
--
--  gs c cycle mainstep             Cycles through the available steps to use as the primary step when using
--                                  one of the above commands.
--  gs c cycle altstep              Cycles through the available steps to use for alternating with the
--                                  configured main step.
--  gs c toggle usealtstep          Toggles whether or not to use an alternate step.
--  gs c toggle selectsteptarget    Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
include('organizer-lib')
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
send_command('wait 31;input //gs equip sets.weapons') 

organizer_items = {
    Consumables={"Echo Drops","Holy Water", "Remedy", "Angon"},
	Food={"Sublime Sushi"},
	Storage={"Storage Slip 16","Storage Slip 18","Storage Slip 21","Storage Slip 23","Storage Slip 24",
			"Storage Slip 25","Storage Slip 26","Storage Slip 27","Storage Slip 28"}
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_gear()
--'//gs c getgear' to retrieve/pack gear manually. Only works in PortTowns list
    if PortTowns:contains(world.area) then
		send_command('wait 3;input //gs org') 
		send_command('wait 6;input //po repack') 
    else
		add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
    end
end

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
	
    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(true, 'Ignore Targetting')

    state.ClosedPosition = M(false, 'Closed Position')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
--  state.SkillchainPending = M(false, 'Skillchain Pending')

    state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 43
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT')

    -- Additional local binds

    send_command('lua l gearinfo')

    send_command('bind ^- gs c cycleback mainstep')
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind !- gs c cycleback altstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^] gs c toggle usealtstep')
    send_command('bind ![ input /ja "Contradance" <me>')
    send_command('bind ^` input /ja "Saber Dance" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')
    send_command('bind @f gs c toggle ClosedPosition')
    send_command('bind ^numlock input /ja "Reverse Flourish" <me>')

    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    elseif player.sub_job == 'THF' then
        send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
        send_command('bind ^numpad. input /ja "Trick Attack" <me>')
    end

    send_command('bind ^numpad+ input /ja "Climactic Flourish" <me>')
    send_command('bind ^numpadenter input /ja "Building Flourish" <me>')

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad6 input /ws "Pyrrhic Kleos" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')

    send_command('bind numpad0 gs c step t')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
	get_gear()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^]')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @f')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad+')
    send_command('unbind ^numpadenter')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind numpad0')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')

    send_command('lua u gearinfo')

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",			--+2	
		head="Halitus Helm",			--+8
		body="Emet Harness",			--+9
		hands="Kurys Gloves",			--+9
		legs="Zoar Subligar",			--+5	
		feet="Ahosi Leggings",			--+7	
		neck="Warder's Charm",			--+8
		waist="Trance Belt",			--+4
		left_ear="Friomisi Earring",	--+2
		right_ear="Cryptic Earring",	--+4
		left_ring="Provocare Ring",		--+5
		right_ring="Begrudging Ring",	--+5
		back="Reiki Cloak",				--+6
    }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque +3"}
    sets.precast.JA['Trance'] = {head="Horos Tiara +3"}

    sets.precast.Waltz = {
		ammo="Yamarang",
		head="Anwig Salade", 
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		legs="Dashing Subligar",
		feet="Maxixi Toe Shoes +3",
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear="Handler's Earring +1",
		right_ear="Odnowa Earring +1",
		left_ring="Metamorph Ring +1",
		right_ring="Meridian Ring",
		back={ name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Waltz" potency +10%',}},
	} -- Waltz Potency/CHR
    sets.precast.WaltzEnmity = set_combine(sets.precast.Waltz, {
		head="Halitus Helm",
		hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
		feet="Ahosi Leggings",
		waist="Trance Belt",
		left_ear="Cryptic Earring",
		left_ring="Provocare Ring",
	}) 
    sets.precast.WaltzSelf = set_combine(sets.precast.Waltz, {
        head="Mummu Bonnet +2", --(8)
    }) -- Waltz effects received
    sets.precast.WaltzSelfEnmity = set_combine(sets.precast.WaltzSelf, {
        head="Mummu Bonnet +2", --(8)
		hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
		feet="Ahosi Leggings",
		waist="Trance Belt",
		left_ear="Cryptic Earring",
		left_ring="Provocare Ring",
    })
	
    sets.precast.Waltz['Healing Waltz'] = {}
    sets.precast.Samba = {head="Maxixi Tiara +2", back={ name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Waltz" potency +10%',}}}
    sets.precast.Jig = {legs="Horos Tights +3", feet="Maxixi Toe Shoes +3"}
	
    sets.precast.Step = {
		ammo="Yamarang",
		head="Maxixi Tiara +2",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		legs="Maxixi Tights +2",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
    }

    sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Macu. Toe Shoes +1"})
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

    sets.precast.Flourish1['Violent Flourish'] = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Horos Casaque +3",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Etoile Gorget +1",
		waist="Salire Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe3"},
		back="Moonbeam Cape"
    } -- Magic Accuracy
	
    sets.precast.Flourish1['Desperate Flourish'] = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Etoile Gorget +1",
		waist="Reiki Yotai",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10',}}
        } -- Accuracy

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Macu. Bangles +1",    back="Toetapper Mantle"}
    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Macu. Casaque +1"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara +1",}

    sets.precast.FC = {
		ammo="Impatiens",
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body="Malignance Tabard",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Reiki Yotai",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Rahab Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape"
        }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        body="Passion Jacket",
        ring1="Lebeche Ring",
        })
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo = "Coiste Bodhar",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},	
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+5','"Rapid Shot"+6','Weapon skill damage +7%','Accuracy+7 Attack+7','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','Weapon skill damage +10%',}}
	} -- default set
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Maxixi Bangles +3",
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+14','"Triple Atk."+4','Attack+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Gere Ring",
		back="Sacro Mantle",
	})
    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
	})
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
	})
    sets.precast.WS['Shark Bite'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+5','"Rapid Shot"+6','Weapon skill damage +7%','Accuracy+7 Attack+7','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','Weapon skill damage +10%',}},
    })
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Meg. Cuirie +2",
		hands="Mummu Wrists +2",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Begrudging Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
	})
    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},	
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+5','"Rapid Shot"+6','Weapon skill damage +7%','Accuracy+7 Attack+7','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','Weapon skill damage +10%',}},
        })
    sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Herculean Helm", augments={'"Fast Cast"+4','CHR+5','Mag. Acc.+8','"Mag.Atk.Bns."+10',}},
		body={ name="Herculean Vest", augments={'Accuracy+7','Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +8%','Accuracy+19 Attack+19',}},
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Herculean Boots", augments={'Accuracy+14','"Triple Atk."+4','Attack+15',}},
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Regal Ring",
		right_ring="Shiva Ring +1",
		back="Sacro Mantle",
	}
    sets.precast.WS['Asuran Fists'] = {
		ammo="C. Palug Stone",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +5%','STR+5','Accuracy+15',}},
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Shukuyu Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','Weapon skill damage +10%',}},
	}
    sets.precast.WS['Raging Fists'] = {
		ammo="C. Palug Stone",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Maxixi Bangles +3",
		legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Shukuyu Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
	}
    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'],{neck="Etoile Gorget +1", ammo="Yamarang"})
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {neck="Etoile Gorget +1", ammo="Yamarang"})
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'], {neck="Etoile Gorget +1", ammo="Yamarang"})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {neck="Etoile Gorget +1", ammo="Yamarang"})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {neck="Etoile Gorget +1", ammo="Yamarang"})
    sets.precast.WS.Critical = {body="Meg. Cuirie +2"}
    
	sets.precast.Skillchain = {hands="Macu. Bangles +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {
		ammo="Staunch Tathlum",
		head="Meghanada Visor +2",
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Moonbeam Cape",	
	}

    sets.idle = {
		ammo="Staunch Tathlum",
		head="Meghanada Visor +2",
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Meg. Jam. +2",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }

    sets.idle.DT = set_combine(sets.idle, {		
		ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape"}
		)
    sets.idle.Town = set_combine(sets.idle, {})
    sets.idle.Weak = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Skd. Jambeaux +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo = "Coiste Bodhar",
		Head= "Adhemar Bonnet +1",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Mummu Wrists +2",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},	head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},	head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,{body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},	head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.STP = set_combine(sets.engaged, {})

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste ( > 40 to cap)
    sets.engaged.DW = {
		ammo = "Coiste Bodhar",
		Head= "Adhemar Bonnet +1",
		body="Adhemar Jacket +1", 	--6%
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Reiki Yotai", 		--7%
		left_ear="Eabani Earring", 	--4%
		right_ear="Suppanomimi", 	--5%
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
    } -- 36%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},	head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {})

    -- 15% Magic Haste (<=40% to cap >21% )
    sets.engaged.DW.LowHaste = {
		ammo = "Coiste Bodhar",
		Head="Adhemar Bonnet +1",
		body="Adhemar Jacket +1", 	--6%
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Reiki Yotai", 		--7%
		left_ear="Eabani Earring", 	--4%
		right_ear="Suppanomimi", 	--5%
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
    } -- 31%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {})

    -- 30% Magic Haste (<=21% DW To cap >=9)
    sets.engaged.DW.MidHaste = {
		ammo = "Coiste Bodhar",
		Head="Adhemar Bonnet +1",
		body="Adhemar Jacket +1", 	--6%
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Reiki Yotai", 		--7%
		left_ear="Eabani Earring", 	--4%
		right_ear="Suppanomimi", 	--5%
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
    } -- 22%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {})

    -- 35% Magic Haste (<=9% DW To cap >1%)
    sets.engaged.DW.HighHaste = {
		ammo = "Coiste Bodhar",
		Head="Adhemar Bonnet +1",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Reiki Yotai", --7%
		left_ear="Eabani Earring", --4%
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
      } -- 11% Gear

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {})

    -- 45% Magic Haste (1% DW to cap)
    sets.engaged.DW.MaxHaste = {
		ammo = "Coiste Bodhar",
		Head="Adhemar Bonnet +1",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Adhemar Wrist. +1",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
        } -- 0%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},head="Malignance Chapeau",hands="Malignance Gloves",legs="Malignance Tights",neck="Etoile Gorget +1",ammo="Yamarang",left_ear ="Telos Earring"})
    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {})
	
    sets.engaged.DW.Aftermath = {
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Senuna's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+1','"Store TP"+10','Phys. dmg. taken-10%',}}
	} -- 0%

    sets.engaged.DW.LowAcc.Aftermath = set_combine(sets.engaged.DW.Aftermath, {ammo="Yamarang"})
    sets.engaged.DW.MidAcc.Aftermath = set_combine(sets.engaged.DW.LowAcc.Aftermath, {ammo="Yamarang"})
    sets.engaged.DW.HighAcc.Aftermath = set_combine(sets.engaged.DW.MidAcc.Aftermath, {ammo="Yamarang"})
    sets.engaged.DW.STP.Aftermath = set_combine(sets.engaged.DW.Aftermath, {})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring", bag="wardrobe3"},
    }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.Aftermath = set_combine(sets.engaged.DW.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.Aftermath = set_combine(sets.engaged.DW.LowAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.Aftermath = set_combine(sets.engaged.DW.MidAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.Aftermath = set_combine(sets.engaged.DW.HighAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.Aftermath = set_combine(sets.engaged.DW.STP.Aftermath, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.buff['Saber Dance'] = {legs="Horos Tights +3"}
    sets.buff['Fan Dance'] = {body="Horos Bangles +3"}
    sets.buff['Climactic Flourish'] = {
		ammo="Charis Feather",
		head="Maculele Tiara +1",
		body="Meg. Cuirie +2"}
    sets.buff['Closed Position'] = {feet="Horos T. Shoes +3"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Ephedra ring",
        ring2="Ephedra ring",
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
    end
    if spell.type=='Waltz' and spell.english:startswith('Curing') and spell.target.type == 'SELF' and buffactive['Fan Dance'] then
        equip(sets.precast.WaltzSelfEnmity)
	elseif spell.type=='Waltz' and spell.english:startswith('Curing') and spell.target.type ~= 'SELF' and buffactive['Fan Dance'] then
        equip(sets.precast.WaltzEnmity)
	elseif spell.type=='Waltz' and spell.english:startswith('Curing') and spell.target.type == 'SELF' then
        equip(sets.precast.WaltzSelf)
	elseif spell.type=='Waltz' and spell.english:startswith('Divine') and buffactive['Fan Dance'] then
        equip(sets.precast.WaltzEnmity)
	elseif spell.type=='Waltz' and spell.english:startswith('Divine') then
        equip(sets.precast.Waltz)
	elseif spell.type=='Waltz' and spell.english:startswith('Divine') then
        equip(sets.precast.Waltz) 
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
        handle_equipping_gear(player.status)
    end

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function Aftermath_Overide()
	if  state.Buff['Aftermath: Lv.3'] == true then
		classes.CustomMeleeGroups:append('Aftermath')
	end
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end

end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.Buff['Climactic Flourish'] then
        meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
    end
    if state.ClosedPosition.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
    end

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local s_msg = state.MainStep.current
    if state.UseAltStep.value == true then
        s_msg = s_msg .. '/'..state.AltStep.current
    end

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Step: '  ..string.char(31,001)..s_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
		if state.Buff['Aftermath: Lv.3'] then
			classes.CustomMeleeGroups:append('Aftermath')
        elseif DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 9 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 9 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 39 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 39 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "'..doStep..'" <t>')
    end

    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
end

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'WAR' then
        set_macro_page(1, 7)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 2)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 2)
    elseif player.sub_job == 'RUN' then
        set_macro_page(4, 2)
    elseif player.sub_job == 'SAM' then
        set_macro_page(5, 2)
    else
        set_macro_page(1, 2)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end