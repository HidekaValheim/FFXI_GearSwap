--NIN_HUD--
--------------------------------------------------------------------------------------------------------------
-- HUD STUFF
--------------------------------------------------------------------------------------------------------------

const_on = "\\cs(32, 255, 32)ON\\cr"
const_off = "\\cs(255, 32, 32)OFF\\cr"

hud_x_pos_og = hud_x_pos
hud_y_pos_og = hud_y_pos
hud_font_size_og = hud_font_size
hud_padding_og = hud_padding
hud_transparency_og = hud_transparency

MB_Window = 0
time_start = 0

-- Standard Mode
hub_mode_std = [[\cs(255, 115, 0)Modes: \cr              
\cs(200, 200, 200)Main Weapon:\cr \cs(125,125,255)${player_current_mainweapon|Kannagi}
\cs(200, 200, 200)Sub Weapon:\cr \cs(125,125,255)${player_current_subweapon|Kannagi}
\cs(255, 255, 64)${KB_Melee_M}\cs(200, 200, 200)Melee Mode:\cr ${player_current_melee}
\cs(255, 255, 64)${KB_PDT_M}\cs(200, 200, 200)PDT Mode:\cr ${player_current_Hybrid}
\cs(255, 255, 64)${KB_RA_M}\cs(200, 200, 200)Ranged Mode:\cr ${player_current_Ranged}
\cs(255, 255, 64)${KB_CAST_M}\cs(200, 200, 200)Casting Mode:\cr ${player_current_casting}
\cs(255, 255, 64)${KB_Haste_M}\cs(200, 200, 200)Melee Mode:\cr ${HasteMode}
\cs(255, 255, 64)${KB_March_M}\cs(200, 200, 200)Melee Mode:\cr ${MarchMode}
\cs(255, 255, 64)${KB_TH_M}\cs(200, 200, 200)Melee Mode:\cr ${treasuremode}
]]



-- init style
hub_mode = hub_mode_std
hub_options = hub_options_std
hub_job = hub_job_std
hub_battle = hub_battle_std
--[[
    This gets passed in when the Keybinds are turned off.
    For not it simply sets the variable to an empty string
    (Researching better way to handle this)
]]
keybinds_on = {}
keybinds_on['KB_Melee_M'] = '(PH)'
keybinds_on['KB_PDT_M'] = '(PH)'
keybinds_on['KB_RA_M'] = '(PH)'
keybinds_on['KB_CAST_M'] = '(PH)'
keybinds_on['KB_Haste_M'] = '(PH)'
keybinds_on['KB_March_M'] = '(PH)'
keybinds_on['KB_TH_M'] = '(PH)'



function validateTextInformation()

    --Mode Information
    main_text_hub.player_current_melee =  state.OffenseMode.current
    main_text_hub.player_current_mainweapon = player.equipment.main
    main_text_hub.player_current_subweapon = player.equipment.sub
	main_text_hub.player_current_Hybrid = HybridMode.current
	main_text_hub.player_current_Ranged = RangedMode.current	
    main_text_hub.player_current_casting = CastingMode.current
	main_text_hub.player_current_Haste = HasteMode.current
	main_text_hub.player_current_March = MarchMode.current
	main_text_hub.player_current_Treasure = treasuremode.current

end

--Default To Set Up the Text Window
function setupTextWindow()

    local default_settings = {}
    default_settings.pos = {}
    default_settings.pos.x = hud_x_pos
    default_settings.pos.y = hud_y_pos
    default_settings.bg = {}

    default_settings.bg.alpha = hud_transparency
    default_settings.bg.red = 40
    default_settings.bg.green = 40
    default_settings.bg.blue = 55
    default_settings.bg.visible = true
    default_settings.flags = {}
    default_settings.flags.right = false
    default_settings.flags.bottom = false
    default_settings.flags.bold = true
    default_settings.flags.draggable = hud_draggable
    default_settings.flags.italic = false
    default_settings.padding = hud_padding
    default_settings.text = {}
    default_settings.text.size = hud_font_size
    default_settings.text.font = hud_font
    default_settings.text.fonts = {}
    default_settings.text.alpha = 255
    default_settings.text.red = 147
    default_settings.text.green = 161
    default_settings.text.blue = 161
    default_settings.text.stroke = {}
    default_settings.text.stroke.width = 1
    default_settings.text.stroke.alpha = 255
    default_settings.text.stroke.red = 0
    default_settings.text.stroke.green = 0
    default_settings.text.stroke.blue = 0

    --Creates the initial Text Object will use to create the different sections in
    if not (main_text_hub == nil) then
        texts.destroy(main_text_hub)
    end
    main_text_hub = texts.new('', default_settings, default_settings)

    --Appends the different sections to the main_text_hub
    texts.append(main_text_hub, hub_mode)
    --We then do a quick validation
    validateTextInformation()

    --Finally we show this to the user
    main_text_hub:show()
    
end
