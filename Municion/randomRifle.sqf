params ["_unit","_changeRifle","_changeHelmet","_changeUniform","_changeVest"];
private ["_newRifle","_compatibleOptics","_options","_radio"];

_skillFIA = server getVariable ["skillFIA", 1];

if (_changeVest) then {
	if (random 25 < _skillFIA) then {
		removeVest _unit;
		_unit addVest guer_gear_vestAdv;
		_unit addItemToVest "FirstAidKit";
	};
};

if (_changeHelmet) then {
	if (random 20 < _skillFIA) then {
		_unit addHeadgear (selectRandom genHelmets);
	} else {
		if (_changeUniform) then {
			// BE module
			if (hayBE) then {
				_result = ["outfit"] call fnc_BE_getCurrentValue;
				if (random 100 > _result) then {
					_unit forceAddUniform (selectRandom civUniforms);
					_unit addItemToUniform "FirstAidKit";
					_unit addMagazine [guer_gear_grenHE, 1];
					_unit addMagazine [guer_gear_grenSmoke, 1];
				};
			}
			// BE module
			else {
				if (random 10 > _skillFIA) then {
					_unit forceAddUniform (selectRandom civUniforms);
					_unit addItemToUniform "FirstAidKit";
					_unit addMagazine [guer_gear_grenHE, 1];
					_unit addMagazine [guer_gear_grenSmoke, 1];
				};
			};
		};
	};
};

if (_changeRifle) then {
	_unit removeMagazines (currentMagazine _unit);
	_unit removeWeaponGlobal (primaryWeapon _unit);
	_newRifle = selectRandom unlockedRifles;
	if (_newRifle in genGL) then {
		_unit addMagazine [guer_gear_GL_gren, 4];
	};
	[_unit, _newRifle, 5, 0] call BIS_fnc_addWeapon;

	if (count unlockedOptics > 0) then {
		_compatibleOptics = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
		_options = [];
		{
			if (_x in _compatibleOptics) then {_options pushBack _x};
		} forEach unlockedOptics;
		_unit addPrimaryWeaponItem (selectRandom _options);
	};
};

if (hayTFAR) then {
	_radio = [AS_radio_tfar_B, AS_radio_tfar_G] select replaceFIA;
	_unit addItem _radio;
	_unit assignItem _radio;
};