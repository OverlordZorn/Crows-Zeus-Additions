/*/////////////////////////////////////////////////
Author: Crowdedlight

File: fn_registerSettingsCBA.sqf
Parameters: none
Return: none

Register all settings for CBA - As this is run in preStart

*///////////////////////////////////////////////

// check for CBA
if !(isClass (configFile >> "CfgPatches" >> "cba_main")) exitWith
{
	diag_log "[Crows Zeus Additions]: CBA not detected.";
};

// only load for players
if (!hasInterface) exitWith {};

// register CBA keybinding to toggle zeus-drawn text
[
	["Crows Zeus Additions", "Zeus"],
	"zeus_text_medical_display",
	["Show medical overlay", "Shows medical info for players in zeus view for units. (medical status)"],
	{crowsZA_zeusTextMedicalDisplay = !crowsZA_zeusTextMedicalDisplay},
	"",
	[DIK_H, [true, true, false]], // [DIK code, [Shift?, Ctrl?, Alt?]] => default: ctrl + shift + h
false] call CBA_fnc_addKeybind;

// setting CBA settings
[
	"crowsZA_zeusTextLine1", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Show No. of wounds and HR.","Show line with number of wounds and heart rate."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + h)"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
	"crowsZA_zeusTextLine2", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Show pain and bleeding rate", "Show if player is in pain and bleeding rate"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + h)"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
	"crowsZA_zeusTextLine3", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Show medications","Show what medications is effecting the player"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Medical HUD (default:  Ctrl + Shift + h)"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    false, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    //FUNC(spectrumEnableSettingChanged) // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

// ZEUS RC HELPER
[
	"crowsZA_zeus_rc_helper", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    ["Show RC Icon","Shows an zeus icon over units currently being RC'ed by any zeus"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Zeus RC"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;

// ZEUS RC HELPER - COLOR
[
	"crowsZA_zeus_rc_helper_color", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "COLOR", // setting type
    ["Icon Colour","What colour the icon is shown with"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["Crows Zeus Additions","Zeus RC"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [1,1,1,1], // data for this setting:
    nil // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;

// custom CBA setting to disable pingbox
[
	"crowsZA_CBA_Setting_pingbox_enabled", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"CHECKBOX", // setting type
	["Enable PingBox", "Pingbox sits in lower left corner and shows the last 3 zeus pings and how long since it was pinged"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
	["Crows Zeus Additions", "PingBox"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
	true, // data for this setting: [min, max, default, number of shown trailing decimals]
	nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	crowsZA_fnc_enablePingBoxHUD // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;
// TIME before removing old entries
[
	"crowsZA_CBA_Setting_pingbox_oldLimit",
	"SLIDER",
	["Remove Threshold", "Time before a ping will automatically be removed from the PingBox"],
	["Crows Zeus Additions", "PingBox"],
	[1, 900, 600, 0], // data for this setting: [min, max, default, number of shown trailing decimals]
	nil
] call CBA_fnc_addSetting;
// FADE OUT for pingbox
[
	"crowsZA_CBA_Setting_pingbox_fade_enabled",
	"CHECKBOX",
	["Enable Fading", "PingBox will fade from view after set duration, and reappear when a new ping is received"],
	["Crows Zeus Additions", "PingBox"],
	true,
	nil,
	{
		params ["_value"];
		// if we are faded and disable fading, we should redraw
		if (!_value && crowsZA_pingbox_faded) then {crowsZA_pingbox_faded = false; "crowsZA_pingbox_layer" cutRsc ["crowsZA_pingbox_hud","PLAIN", 0, true];};
	}
] call CBA_fnc_addSetting;
// TIME BEFORE FADEOUT
[
	"crowsZA_CBA_Setting_pingbox_fade_duration",
	"SLIDER",
	["Duration Before Fade", "Time before the PingBox will fade from view if Fading is enabled"],
	["Crows Zeus Additions", "PingBox"],
	[1, 900, 300, 0],
	nil
] call CBA_fnc_addSetting;
