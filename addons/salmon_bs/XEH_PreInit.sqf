#include "\a3\editor_f\Data\Scripts\dikCodes.h";

[
"TacSalmon Buttstroke", 
"Salmon_buttstroke", 
["Buttstroke", "Press to knock the shit out of people"], 
{[player, cursorTarget] spawn Salmon_fnc_buttStroke}, 
{}, 
[DIK, [false,false,false]]
] call cba_fnc_addKeybind;

if (isClass (configFile >> "cfgPatches" >> "ace_medical")) then {
["Salmon_bs_rd", "CHECKBOX", ["Ragdolling", "Allow target to ragdoll"], "TacSalmon Buttstroke", true] call cba_settings_fnc_init;
};
["Salmon_bs_ff", "CHECKBOX", ["Friendly Fire", "Allow target to be of same side"], "TacSalmon Buttstroke", true] call cba_settings_fnc_init;

Salmon_fnc_buttStroke	=	{
	// basic defines 
	private ["_animTimeOut", "_ace", "_skip", "_damage"];
	_player		=	_this select 0; 
	_target		=	_this select 1; 
	_rifle		=	primaryWeapon _player;
	_pistol		=	handgunWeapon _player; 
	_weapon		=	currentWeapon _player;	
	_ace		=	false;
	_timeout	=	5+random 10;
	_skip		=	false;
	if (isClass (configFile >> "cfgPatches" >> "ace_medical")) then {
		_ace = true;
	};
	if !(animationState _player == "Acts_Executioner_Forehand" || animationState _player == "Acts_Miller_Knockout" || _player getVariable ["ACE_isUnconscious", false] || _player getVariable ["ace_captives_isHandcuffed", false]) then {
		if (!Salmon_bs_ff && side _target == side _player) exitWith {};
		if (alive _player && alive _target && stance _player == "STAND" && _target isKindOf "Man" && _player distance _target <= 2) then {
			if (_weapon == _rifle || _weapon == _pistol) then {
				if (_weapon == _rifle) then {
					_player setAnimSpeedCoef 1.5;
					[_player, "Acts_Miller_Knockout"] remoteExec ["switchMove", 0];
					_damage = 0.2 + random 0.25;
					_animTimeOut = 1.3; 
				} else {
					_player setAnimSpeedCoef 1.2;
					[_player, "Acts_Executioner_Forehand"] remoteExec ["switchMove", 0];
					_damage = 0.15 + random 0.2;
					_animTimeOut = 0.9; 
				};
				sleep 1;
				if (_player distance _target <= 4 && alive _player) then {
					if (_ace) then {
						if (Salmon_bs_rd) then {
							_target setUnconscious true;
						};
						[_target, true, _timeout, true] call ace_medical_fnc_setUnconscious;
						_part = selectRandom ["leg_l", "leg_r", "hand_r", "hand_l", "body", "head"];
						_source = selectRandom ["falling", "stab", "punch"];
						[_target, _damage, _part, _source] call ace_medical_fnc_addDamageToUnit;
					} else {
						_skip = (lifeState _target isEqualTo "INCAPACITATED");
						_target setUnconscious true;
						_target setDamage (damage _target + _damage);
					};
				};
			};
			sleep _animTimeOut;
			_player setAnimSpeedCoef 1;
			[_player, ""] remoteExec ["switchMove", 0];
			if (!_ace && !_skip) then {
				sleep _timeout;
				_target setUnconscious false;
			};
		};
	};
};