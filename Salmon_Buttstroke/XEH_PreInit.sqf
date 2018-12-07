#include "\a3\editor_f\Data\Scripts\dikCodes.h";

[
"TacSalmon Buttstroke", 
"Salmon_buttstroke", 
["Buttstroke", "Press to knock the shit out of people"], 
{[player, cursorTarget] spawn Salmon_fnc_buttStroke}, 
{}, 
[DIK, [false,false,false]]
] call cba_fnc_addKeybind;

["Salmon_bs_rd", "CHECKBOX", ["Ragdolling", "Allow target to ragdoll"], "TacSalmon Buttstroke", true] call cba_settings_fnc_init;
["Salmon_bs_ff", "CHECKBOX", ["Friendly Fire", "Allow target to be of same side"], "TacSalmon Buttstroke", true] call cba_settings_fnc_init;

Salmon_fnc_buttStroke	=	{
	// basic defines 
	private "_animTimeOut";
	_player		=	_this select 0; 
	_target		=	_this select 1; 
	_rifle		=	primaryWeapon _player;
	_pistol		=	handgunWeapon _player; 
	_weapon		=	currentWeapon _player;	
	if !(animationState _player == "Acts_Executioner_Forehand" || animationState _player == "Acts_Miller_Knockout" || _player getVariable ["ACE_isUnconscious", false] || _player getVariable ["ace_captives_isHandcuffed", false]) then {
	if (!Salmon_bs_ff && side _target == side _player) exitWith {};
	if (stance _player == "STAND" && _target isKindOf "Man" && _player distance _target <= 2 && alive _player) then {
	if (_weapon == _rifle || _weapon == _pistol) then {
	if (_weapon == _rifle) then {
		[_player, "Acts_Miller_Knockout"] remoteExec ["switchMove", 0];
		_animTimeOut = 2; 
	} else {
		[_player, "Acts_Executioner_Forehand"] remoteExec ["switchMove", 0];
		_animTimeOut = 1.1; 
	};
	sleep 1;
	if (_player distance _target <= 4 && alive _player) then {
	if (Salmon_bs_rd) then {
		_target setUnconscious true;
	};
	[_target, true, (round(random(10)+5)), true] call ace_medical_fnc_setUnconscious;
	sleep _animTimeOut;
	[_player, ""] remoteExec ["switchMove", 0];
	} else {
	[_player, ""] remoteExec ["switchMove", 0];
	};
};
};
};
};