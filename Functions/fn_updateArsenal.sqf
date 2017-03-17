if (!isServer) exitWith {};
private ["_weapons","_baseWeapons","_addedWeapons","_lockedWeapon","_weaponCargo","_precio","_weapon","_baseWeapon","_priceAdd","_updated","_magazines","_addedMagazines","_magazine","_magazineCargo","_items","_addedItems","_item","_cuenta","_itemCargo","_backpacks","_baseBackpacks","_addedBackpacks","_lockedBackpack","_backpackCargo","_mochi","_backpack","_weaponsItems","_wpnItem", "_itemReq"];

_updated = "";

_weapons = weaponCargo caja;
_backpacks = backpackCargo caja;
_magazines = magazineCargo caja;
_items = itemCargo caja;

_addedMagazines = [];
{
	_mag = _x;
	if !(_mag in unlockedMagazines) then {
		if ({_x == _mag} count _magazines >= ["magazines"] call AS_fnc_getUnlockRequirement) then {
			_addedMagazines pushBackUnique _mag;
			unlockedMagazines pushBackUnique _mag;
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _mag >> "displayName")]
		};
	};
} forEach AS_allMagazines;

_baseWeapons = [];
{
	_baseWeapon = [_x] call BIS_fnc_baseWeapon;
	_baseWeapons pushBack _baseWeapon;
} forEach _weapons;

_addedWeapons = [];
{
	_lockedWeapon = _x;

	if ({_x == _lockedWeapon} count _baseWeapons >= ["weapons"] call AS_fnc_getUnlockRequirement) then {
		_blockUnlock = true;
		_magazine = (getArray (configFile / "CfgWeapons" / _x / "magazines") select 0);
		if !(isNil "_magazine") then {
			if (_magazine in unlockedMagazines) then {
				_blockUnlock = false;
			} else {
				if ({_x == _magazine} count _magazines >= ["magazines"] call AS_fnc_getUnlockRequirement) then {
					_blockUnlock = false;
					_addedMagazines pushBackUnique _magazine;
					unlockedMagazines pushBackUnique _magazine;
					_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]
				};
			};

			if !(_blockUnlock) then {
				_addedWeapons pushBackUnique _lockedWeapon;
				unlockedWeapons pushBackUnique _lockedWeapon;
				_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _lockedWeapon >> "displayName")];
			};
		};
	};
} forEach lockedWeapons;

if (!("Rangefinder" in unlockedWeapons) || !(indRF in unlockedWeapons)) then {
	if ({(_x == "Rangefinder") or (_x == indRF)} count weaponCargo caja >= ["weapons"] call AS_fnc_getUnlockRequirement) then {
		_addedWeapons pushBack "Rangefinder";
		unlockedWeapons pushBack "Rangefinder";
		_addedWeapons pushBack indRF;
		unlockedWeapons pushBack indRF;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Rangefinder" >> "displayName")];
	};
};


if (count _addedMagazines > 0) then {
	if ((atMine in _addedMagazines) || (apMine in _addedMagazines)) then {
		if (hayBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
	};
	if (("AS_virtualArsenal" call BIS_fnc_getParamValue) == 1) then {
		// XLA fixed arsenal
		if (hayXLA) then {
			[caja,_addedMagazines,true,false] call XLA_fnc_addVirtualMagazineCargo;
		} else {
			[caja,_addedMagazines,true,false] call BIS_fnc_addVirtualMagazineCargo;
		};
	};
	publicVariable "unlockedMagazines";
};

_magazineCargo = [];

for "_i" from 0 to (count _magazines) - 1 do {
	_magazine = _magazines select _i;
	if !(_magazine in unlockedMagazines) then {
		_magazineCargo pushBack _magazine;
	};
};

if (count _addedWeapons > 0) then {
	lockedWeapons = lockedWeapons - _addedWeapons;
	if (hayBE) then {["unl_wpn", count _addedWeapons] remoteExec ["fnc_BE_XP", 2]};
	if (("AS_virtualArsenal" call BIS_fnc_getParamValue) == 1) then {
		// XLA fixed arsenal
		if (hayXLA) then {
			[caja,_addedWeapons,true,false] call XLA_fnc_addVirtualWeaponCargo;
		} else {
			[caja,_addedWeapons,true,false] call BIS_fnc_addVirtualWeaponCargo;
		};
	};
	publicVariable "unlockedWeapons";
	[_addedWeapons] spawn AS_fnc_weaponsCheck;
};

_weaponCargo = [];
_weaponsItems = weaponsItems caja;

for "_i" from 0 to (count _weapons) - 1 do {
	_weapon = _weapons select _i;
	_baseWeapon = _baseWeapons select _i;
	if (not(_baseWeapon in unlockedWeapons)) then {
		_weaponCargo pushBack _weapon;
	} else {
		if (_weapon != _baseWeapon) then {
			_wpnItem = _weaponsItems select _i;
			if ((_wpnItem select 0) == _weapon) then {
				{
					if (typeName _x != typeName []) then {_items pushBack _x};
				} forEach (_wpnItem - [_weapon]);
			};
		};
	};
};

_baseBackpacks = [];
{
	_backpack = _x call BIS_fnc_basicBackpack;
	_baseBackpacks pushBack _backpack;
} forEach _backpacks;

_addedBackpacks = [];
	{
	_lockedBackpack = _x;
	if ({_x == _lockedBackpack} count _baseBackpacks >= ["backpacks"] call AS_fnc_getUnlockRequirement) then {
		_addedBackpacks pushBackUnique _lockedBackpack;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgVehicles" >> _lockedBackpack >> "displayName")];
	};
} forEach genBackpacks;

if (count _addedBackpacks > 0) then {
	genBackpacks = genBackpacks - _addedBackpacks;
	if (("AS_virtualArsenal" call BIS_fnc_getParamValue) == 1) then {
		// XLA fixed arsenal
		if (hayXLA) then {
			[caja,_addedBackpacks,true,false] call XLA_fnc_addVirtualBackpackCargo;
		} else {
			[caja,_addedBackpacks,true,false] call BIS_fnc_addVirtualBackpackCargo;
		};
	};
	unlockedBackpacks = unlockedBackpacks + _addedBackpacks;
	publicVariable "unlockedBackpacks";
};

_backpackCargo = [];

for "_i" from 0 to (count _backpacks) - 1 do {
	_mochi = _backpacks select _i;
	_backpack = _baseBackpacks select _i;
	if (not(_backpack in unlockedBackpacks)) then {
		_backpackCargo pushBack _mochi;
	};
};

_addedItems = [];
{
	_item = _x;
	if !(_item in unlockedItems) then {
		_itemReq = ["items"] call AS_fnc_getUnlockRequirement;
		if !(_item in genItems) then {_itemReq = _itemReq + 10};
		if ((_item in genVests) || (_item in genOptics)) then {_itemReq = ["vests"] call AS_fnc_getUnlockRequirement;};
		if ({_x == _item} count _items >= _itemReq) then {
			_addedItems pushBackUnique _item;
			unlockedItems pushBackUnique _item;
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
			if (_item in genOptics) then {unlockedOptics pushBackUnique _item; publicVariable "unlockedOptics"};
			if (_item in genVests) then {
				if (hayBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
			};
		};
	};
} forEach allItems + ["bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp","bipod_02_F_blk","bipod_02_F_tan","bipod_02_F_hex","bipod_03_F_blk","B_UavTerminal"] + bluItems - ["NVGoggles","Laserdesignator"];

if !("NVGoggles" in unlockedItems) then {
	if ({(_x == "NVGoggles") or (_x == "NVGoggles_OPFOR") or (_x == "NVGoggles_INDEP") or (_x == indNVG)} count weaponCargo caja >= ["items"] call AS_fnc_getUnlockRequirement) then {
		_addedItems = _addedItems + ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",indNVG];
		unlockedItems = unlockedItems + ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",indNVG];
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "NVGoggles" >> "displayName")];
		if (hayBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
	};
};

if !("Laserdesignator" in unlockedItems) then {
	if ({(_x == "Laserdesignator") or (_x == "Laserdesignator_02") or (_x == "Laserdesignator_03")} count weaponCargo caja >= ["items"] call AS_fnc_getUnlockRequirement) then {
		_addedItems pushBack "Laserdesignator";
		unlockedItems pushBackUnique "Laserdesignator";
		unlockedMagazines pushBackUnique "Laserbatteries";
		publicVariable "unlockedMagazines";
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Laserdesignator" >> "displayName")];
	};
};

if !("Rangefinder" in unlockedItems) then {
	if ({(_x == "Rangefinder")} count weaponCargo caja >= ["items"] call AS_fnc_getUnlockRequirement) then {
		_addedItems pushBack "Rangefinder";
		unlockedItems pushBack "Rangefinder";
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Rangefinder" >> "displayName")];
	};
};

if ((hayACE) && ("ItemGPS" in unlockedItems)) then {
	unlockedItems pushBackUnique "ACE_DAGR";
};

if (count _addedItems >0) then {
	if (("AS_virtualArsenal" call BIS_fnc_getParamValue) == 1) then {
		// XLA fixed arsenal
		if (hayXLA) then {
			[caja,_addedItems,true,false] call XLA_fnc_addVirtualItemCargo;
		} else {
			[caja,_addedItems,true,false] call BIS_fnc_addVirtualItemCargo;
		};
	};
	publicVariable "unlockedItems";
};

_itemCargo = [];

for "_i" from 0 to (count _items) - 1 do {
	_item = _items select _i;
	if (!(_item in unlockedItems) && !(toLower _item find "tf_anprc" >= 0)) then {
		_itemCargo pushBack _item;
	};
};

if (("AS_virtualArsenal" call BIS_fnc_getParamValue) == 1) then {
	if (count _weapons != count _weaponCargo) then {
		clearWeaponCargoGlobal caja;
		{caja addWeaponCargoGlobal [_x,1]} forEach _weaponCargo;
		unlockedRifles = unlockedweapons -  hguns -  mlaunchers - rlaunchers - srifles - mguns; publicVariable "unlockedRifles";
	};

	if (count _backpacks != count _backpackCargo) then {
		clearBackpackCargoGlobal caja;
		{caja addBackpackCargoGlobal [_x,1]} forEach _backpackCargo;
	};

	if (count _magazines != count _magazineCargo) then {
		clearMagazineCargoGlobal caja;
		{caja addMagazineCargoGlobal [_x,1]} forEach _magazineCargo;
	};

	if (count _items != count _itemCargo) then {
		clearItemCargoGlobal caja;
		{caja addItemCargoGlobal [_x,1]} forEach _itemCargo;
	};
};

unlockedRifles = unlockedweapons -  hguns -  mlaunchers - rlaunchers - srifles - mguns; publicVariable "unlockedRifles";
publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";

_updated