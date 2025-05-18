-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
	send_command('wait 2;input /lockstyleset 9')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')

    determine_haste_group()
	state.Moving = M(false, "moving")
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Fotia Gorget"
    gear.default.weaponskill_waist = "Fotia Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {
	body="Horos Casaque +2"
	}

    sets.precast.JA['Trance'] = {
	head="Horos Tiara +3"
	}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
    ammo="Sapience Orb",
    head={ name="Horos Tiara +3", augments={'Enhances "Trance" effect',}},
    body="Maxixi Casaque +2",
    hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
    legs="Dashing Subligar",
    feet="Maxixi Toeshoes +2",
    neck="Unmoving Collar +1",
    waist="Shetal Stone",
    left_ear="Enchntr. Earring +1",
    right_ear="Handler's Earring +1",
    left_ring="Moonbeam Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Samba = {
	head="Maxixi Tiara +2"
	}

    sets.precast.Jig = {
	legs="Horos Tights +3", 	
	}

    sets.precast.Step = {
	feet="Horos T. Shoes +3"
	}
	
    sets.precast.Step['Feather Step'] = {
	feet="Macu. Toeshoes +1"
	}

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {

		} -- magic accuracy
		
    sets.precast.Flourish1['Desperate Flourish'] = {
	
		} -- acc gear

    sets.precast.Flourish2 = {}
	
    sets.precast.Flourish2['Reverse Flourish'] = {
	hands="Macu. Bangles +1",
	back="Toetapper Mantle"
	}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {
	body="Charis Casaque +2"
	}
	
    sets.precast.Flourish3['Climactic Flourish'] = {
	head="Maculele Tiara +1"
	}

    -- Fast cast sets for spells
    
    sets.precast.FC = {    
    ammo="Sapience Orb",
    head={ name="Herculean Helm", augments={'INT+10','STR+15','"Refresh"+2',}},
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Limbo Trousers",
    feet={ name="Taeon Boots", augments={'"Fast Cast"+1','Phalanx +3',}},
    neck="Orunmila's Torque",
    waist="Kasiri Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Rahab Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
	neck="Magoraga Beads"
	})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {    
    ammo="Aurgelmir Orb +1",
    head={ name="Herculean Helm", augments={'Accuracy+5','Weapon skill damage +5%','DEX+3',}},
    body={ name="Herculean Vest", augments={'Accuracy+15','Weapon skill damage +5%','STR+6','Attack+10',}},
    hands="Maxixi Bangles +3",
    legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck={ name="Etoile Gorget +1", augments={'Path: A',}},
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Regal Ring",
    right_ring="Ilabrat Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	}
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Fodder = set_combine(sets.precast.WS['Exenterator'], {waist=gear.ElementalBelt})

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
    ammo="Aurgelmir Orb +1",
    head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck={ name="Etoile Gorget +1", augments={'Path: A',}},
    waist="Fotia Belt",
    left_ear="Mache Earring +1",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	
	})
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine({
	})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
    ammo="Charis Feather",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Meg. Cuirie +2",
    hands="Mummu Wrists +2",
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15 Attack+15','Crit. hit damage +5%','STR+3',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Odr Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
	
	})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {

	})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
	})

    sets.precast.WS['Aeolian Edge'] = {}
    
    sets.precast.Skillchain = {}
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}
    

    -- Idle sets

    sets.idle = {
    ammo="Staunch Tathlum +1",
    head="Turms Cap",
    body="Malignance Tabard",
    hands="Turms Mittens +1",
    legs={ name="Horos Tights +3", augments={'Enhances "Saber Dance" effect',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Genmei Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}

    sets.idle.Town = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Etoile Gorget +1",
    waist="Windbuffet Belt +1",
    left_ear="Dedition Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
    
    sets.idle.Weak = {}
    
    -- Defense sets

    sets.defense.Evasion = sets.idle

    sets.defense.PDT = sets.idle

    sets.defense.MDT = {}

    sets.Kiting = "Tandava Crackows"
	
	sets.MoveSpeed = {
	feet = "Tandava Crackows"
	}	

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
	
    sets.engaged = sets.idle.Town

	sets.engaged.Acc = {
    ammo="Yamarang",
    head={ name="Horos Tiara +3", augments={'Enhances "Trance" effect',}},
    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck={ name="Etoile Gorget +1", augments={'Path: A',}},
    waist="Kentarch Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}
	
	sets.engaged.Fodder = {
    ammo="Aurgelmir Orb +1",
    head={ name="Dampening Tam", augments={'DEX+9','Accuracy+13','Mag. Acc.+14','Quadruple Attack +2',}},
    body={ name="Herculean Vest", augments={'Weapon skill damage +1%','MND+5','Quadruple Attack +3','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
    hands={ name="Herculean Gloves", augments={'DEX+9','"Triple Atk."+2','Quadruple Attack +1','Accuracy+9 Attack+9','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+7 Attack+7','Pet: "Store TP"+9','Quadruple Attack +3',}},
    neck={ name="Etoile Gorget +1", augments={'Path: A',}},
    waist="Windbuffet Belt +1",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
	
	}

    sets.engaged.PDT = {    
    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Meg. Chausses +2",
    feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    neck="Loricate Torque +1",
    waist="Windbuffet Belt +1",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}




    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {
	
	legs="Horos Tights +3"
	
	}
	
	sets.buff['Fan Dance'] ={
	
	hands="Horos Bangles +3"
	
	}
    sets.buff['Climactic Flourish'] = {

    ammo="Charis Feather",	
	head="Maculele Tiara +1",
	body="Meganada cuirie +2",
    feet={ name="Herculean Boots", augments={'Accuracy+15 Attack+15','Crit. hit damage +5%','STR+3',}},
    right_ring="Karieyh Ring +1",	
	}
	
	sets.buff['Sleep'] = {
	head= "Frenzy Sallet"
	}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end

if buff == "Sleep" then
        if gain then
            equip(sets.buff.Sleep)
            send_command('@input /echo Slept.')
            disable('head')
        else
            enable('head')
            handle_equipping_gear(player.status)
        end
    end

function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['Saber Dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end

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
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
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
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'SAM' then
        set_macro_page(10, 20)
    else
        set_macro_page(2, 20)
    end
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

