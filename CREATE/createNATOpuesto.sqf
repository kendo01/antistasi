if (!isServer and hasInterface) exitWith {};

params [
	"_marker",

	["_markerPos", getMarkerPos _marker],
	["_objs", []],
	["_APC", objNull],
	["_allAAs", []],
	["_infPos", []],
	["_groupType", [bluATTeam, side_blue] call AS_fnc_pickGroup]
];

private ["_group", "_unit", "_AA1", "_AA2", "_HMG","_APC", "_infGroup"];

_group = createGroup side_blue;

([_markerPos, [ciudades, _markerPos] call BIS_fnc_nearestPosition] call AS_fnc_findRoadspot) params ["_spawnPos", "_spawnDir"];


if (activeUSAF) then {
	_objs = [_spawnPos, _spawnDir + 180, call (compile (preprocessFileLineNumbers "Compositions\cmpUSAF_RB.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	_objs = [_spawnPos, _spawnDir + 180, call (compile (preprocessFileLineNumbers "Compositions\cmpNATO_RB.sqf"))] call BIS_fnc_ObjectsMapper;
};

{
	call {
		_x setVectorUp (surfaceNormal (position _x));
		if (typeOf _x in bluAPC) exitWith {_APC = _x};
		if (typeOf _x in bluStatHMG) exitWith {_HMG = _x};
		if (typeOf _x in bluStatAA) exitWith {_allAAs pushBack _x};
		if (typeOf _x == "Land_Camping_Light_F") exitWith {_infPos = getPosATL _x};
	};
} forEach _objs;

_AA1 = _allAAs select 0;
if (count _allAAs > 1) then {
	_AA2 = _allAAs select 1;
};

if ((server getVariable ["prestigeNATO", 0]) < 50) then {
	_AA1 enableSimulation false;
    _AA1 hideObjectGlobal true;

	if !(activeUSAF) then {
   		_AA2 enableSimulation false;
    	_AA2 hideObjectGlobal true;
	};
} else {
	_unit = ([_markerPos, 0, bluCrew, _group] call bis_fnc_spawnvehicle) select 0;
	_unit assignAsGunner _AA1;
	_unit moveInGunner _AA1;

	if !(activeUSAF) then {
		_unit = ([_markerPos, 0, bluCrew, _group] call bis_fnc_spawnvehicle) select 0;
		_unit assignAsGunner _AA2;
		_unit moveInGunner _AA2;
	};
};

_unit = ([_markerPos, 0, bluCrew, _group] call bis_fnc_spawnvehicle) select 0;
_unit assignAsGunner _HMG;
_unit moveInGunner _HMG;
_unit = ([_markerPos, 0, bluCrew, _group] call bis_fnc_spawnvehicle) select 0;
_unit assignAsGunner _APC;
_unit moveInGunner _APC;
_unit = ([_markerPos, 0, bluCrew, _group] call bis_fnc_spawnvehicle) select 0;
_unit assignAsCommander _APC;
_unit moveInCommander _APC;

[_APC] spawn NATOVEHinit;
_APC allowCrewInImmobile true;
sleep 1;

_infGroup = [_infPos, side_blue, _groupType] call BIS_Fnc_spawnGroup;
_infGroup setFormDir _spawnDir;

{[_x] spawn NATOinitCA} forEach ((units _group) + (units _infGroup));

waitUntil {sleep 1; !(spawner getVariable _marker) OR {({alive _x} count units _group == 0) AND ({alive _x} count units _infGroup == 0)} OR !(_marker in puestosNATO)};

if (({alive _x} count units _group == 0) AND ({alive _x} count units _infGroup == 0)) then {
	puestosNATO = puestosNATO - [_marker]; publicVariable "puestosNATO";
	marcadores = marcadores - [_marker]; publicVariable "marcadores";
	[5,-5,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	deleteMarker _marker;
	[["TaskFailed", ["", "Roadblock Lost"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
};

{deleteVehicle _x} forEach ((units _group) + (units _infGroup) + [_APC, _HMG] + _objs + _allAAs);
deleteGroup _group;
deleteGroup _infGroup;