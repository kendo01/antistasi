if (!isServer and hasInterface) exitWith {};

params ["_originMarker", "_targetMarker"];
private ["_posOrigin","_posTarget","_artillery","_ammo","_size","_spawnPos","_vehicleData","_vehicle","_vehGroup","_objective","_rounds","_vehCrew","_nrOfUnits","_groupSize","_timer"];

_posOrigin = getMarkerPos _originMarker;
_posTarget = getMarkerPos _targetMarker;

_artillery = opArtillery;
_ammo = opArtilleryAmmoHE;
_size = [_originMarker] call sizeMarker;

_spawnPos = [_posOrigin, 50, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
_vehicleData = [_spawnPos, [_posOrigin, _posTarget] call BIS_fnc_dirTo, _artillery, side_red] call bis_fnc_spawnvehicle;
_vehicle = _vehicleData select 0;
_vehCrew = _vehicleData select 1;
_vehGroup = _vehicleData select 2;
{[_x] spawn CSATinit} forEach _vehCrew;
[_vehicle] call CSATVEHinit;

_size = [_targetMarker] call sizeMarker;

diag_log (_posTarget inRangeOfArtillery [[_vehicle], ((getArtilleryAmmo [_vehicle]) select 0)]);
if (_posTarget inRangeOfArtillery [[_vehicle], ((getArtilleryAmmo [_vehicle]) select 0)]) then {
	while {(alive _vehicle) and ({_x select 0 == _ammo} count magazinesAmmo _vehicle > 0)} do {
		_objective = objNull;
		_rounds = 1;
		_objectives = vehicles select {(side driver _x == side_blue) and (_x distance _posTarget <= _size * 2) and ((side_red knowsAbout _x >= 1.4) or (side_green knowsAbout _x >= 1.4)) and (speed _x < 1)};
		if (count _objectives > 0) then {
			{
				if ((_x isKindOf "Tank") or (_x isKindOf "Car")) exitWith {_objective = _x; _rounds = 4};
			} forEach _objectives;
			if (isNull _objective) then {_objective = selectRandom _objectives};
		} else {
			_objectives = allUnits select {(side _x == side_blue) and (_x distance _posTarget <= _size * 2) and ((side_red knowsAbout _x >= 1.4) or (side_green knowsAbout _x >= 1.4))};
			diag_log format ["obj: %1; size: %2", _objectives, _size];
			if (count _objectives > 0) then {
				_nrOfUnits = 0;
				{
					if (_x == leader group _x) then {
						_groupSize = {(alive _x) and (!captive _x)} count units group _x;
						if (_groupSize > _nrOfUnits) then {
							_objective = _x;
							if (_groupSize > 6) then {_rounds = 2};
						};
					};
				} forEach _objectives;
			};
		};

		if !(isNull _objective) then {
			diag_log format ["target: %1", _objective];
			_vehicle commandArtilleryFire [position _objective, _ammo, _rounds];
			_timer = _vehicle getArtilleryETA [position _objective, ((getArtilleryAmmo [_vehicle]) select 0)];
			sleep 9 + ((_rounds - 1) * 3);
		} else {
			sleep 29;
		};
		sleep 1;
	};
};

if !([distanciaSPWN,1,_vehicle,"BLUFORSpawn"] call distanceUnits) then {deleteVehicle _vehicle};

{
	_vehicle = _x;
	waitUntil {sleep 1; !([distanciaSPWN,1,_vehicle,"BLUFORSpawn"] call distanceUnits)};
	deleteVehicle _vehicle;
} forEach _vehCrew;

deleteGroup _vehGroup;