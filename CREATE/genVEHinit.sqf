params ["_vehicle"];
private ["_vehicleType"];


if ((_vehicle isKindOf "FlagCarrier") OR (_vehicle isKindOf "Building")) exitWith {};
if (_vehicle isKindOf "ReammoBox_F") exitWith {[_vehicle] call cajaAAF};

_vehicleType = typeOf _vehicle;

if ((activeACE) AND (random 8 < 7)) then {_vehicle setVariable ["ace_cookoff_enable", false, true]};

if (_vehicleType in (vehTrucks+vehPatrol+vehSupply+enemyMotorpool+vehPatrolBoat)) then {
	if !(_vehicleType in enemyMotorpool) then {
		if (_vehicleType == vehAmmo) then {
			if (_vehicle distance getMarkerPos guer_respawn > 50) then {[_vehicle] call cajaAAF};
		};
		if (_vehicle isKindOf "Car") then {
			_vehicle addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
		};

		_vehicle addEventHandler ["killed",{
			[-1000] remoteExec ["resourcesAAF",2];
			if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
		}];
	} else {
		if (_vehicleType in (vehAPC+vehIFV)) then {
			_vehicle addEventHandler ["killed",{
				if (side (_this select 1) == side_blue) then {
					[_this select 0] call AS_fnc_AAFassets;
					[-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
					if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
				}
			}];
			_vehicle addEventHandler ["HandleDamage",{_vehicle = _this select 0; if (!canFire _vehicle) then {[_vehicle] call smokeCoverAuto}}];
		};
		if (_vehicleType in vehTank) then {
			_vehicle addEventHandler ["killed",{
				if (side (_this select 1) == side_blue) then {
					[_this select 0] call AS_fnc_AAFassets; call AS_fnc_AAFassets;
					[-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
					if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
				}
			}];
			_vehicle addEventHandler ["HandleDamage",{_vehicle = _this select 0; if (!canFire _vehicle) then {[_vehicle] call smokeCoverAuto}}];
		};
	};
} else {
	if (_vehicleType in indAirForce) then {
		_vehicle addEventHandler ["GetIn", {
			_crewPos = _this select 1;
			if (_crewPos == "driver") then {
				_unit = _this select 2;
				if ((!isPlayer _unit) AND (_unit getVariable ["BLUFORSpawn",false])) then {
					moveOut _unit;
					hint format ["AI is not capable of flying %1 vehicles.", A3_Str_INDEP];
				};
			};
		}];

		if (_vehicleType in heli_unarmed) then {
			_vehicle addEventHandler ["killed",{
				[-4000] remoteExec ["resourcesAAF",2];
				if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
			}];
		} else {
			if (_vehicle isKindOf "Helicopter") then {_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets;[1,1] remoteExec ["prestige",2]; [-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]};
			if (_vehicle isKindOf "Plane") then {_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets; call AS_fnc_AAFassets;[2,1] remoteExec ["prestige",2]; [-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]};
		};
	} else {
		if (_vehicleType == indUAV_large) then{
			_vehicle addEventHandler ["killed",{[-2500] remoteExec ["resourcesAAF",2]}];
		} else {
			if (_vehicle isKindOf "StaticWeapon") then {
				[[_vehicle,"steal"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			}
		};
	};
};

[_vehicle] spawn vehicleRemover;

if ((count crew _vehicle) > 0) then {
	[_vehicle] spawn VEHdespawner
} else {
	_vehicle addEventHandler ["GetIn", {
		_vehicle = _this select 0;
		[_vehicle] spawn VEHdespawner;
	}];
};