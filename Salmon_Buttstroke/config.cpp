class CfgPatches
{
	class Salmon_bs_main
	{
		name="Salmon ButtStroke";
		requiredVersion=1.88;
		requiredAddons[]=
		{
			"ace_medical",
			"cba_keybinding",
			"cba_main",
			"cba_main_a3",
			"cba_settings",
			"extended_eventhandlers"
		};
		author="Green";
		authorUrl="http://TacSalmon.me";
	};
};
class Extended_PreInit_EventHandlers
{
	class Salmon_BS
	{
		init="call compile preprocessFileLineNumbers 'Salmon_BS\XEH_PreInit.sqf'";
	};
};