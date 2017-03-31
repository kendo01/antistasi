private ["_allVehicles","_allGroups","_allSoldiers","_base","_spawnPosition","_vehicleArray","_vehicleType","_arrayBases","_arrayTargets","_distance","_spawnpositionData","_direction","_vehicleData","_vehicle","_groupVehicle","_beach","_groupType","_group","_target","_targetPosition","_wp_v_1","_object","_knowledge"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_vehicleArray = vehPatrol + vehPatrolBoat;

while {true} do {
	_vehicleType = selectRandom _vehicleArray;
	call {
		if (_vehicleType in heli_unarmed) exitWith {
			_arrayBases = aeropuertos - mrkFIA;
		};
		if (_vehicleType in vehPatrolBoat) exitWith {
			_arrayBases = puertos - mrkFIA;
		};
		_arrayBases = bases - mrkFIA;
	};

	if (count _arraybases == 0) then {
		_vehicleArray = _vehicleArray - [_vehicleType];
	} else {
		while {true} do {
			_base = [_arraybases,getMarkerPos guer_respawn] call BIS_fnc_nearestPosition;
			if !(spawner getVariable _base) exitWith {};
			if (spawner getVariable _base) then {_arraybases = _arraybases - [_base]};
			if (count _arraybases == 0) exitWith {};
		};
		if (count _arraybases == 0) then {_vehicleArray = _vehicleArray - [_vehicleType]};
	};
	if (count _vehicleArray == 0) exitWith {};
	if !(spawner getVariable _base) exitWith {};
};

if (count _vehicleArray == 0) exitWith {};

_spawnPosition = getMarkerPos _base;

_arrayTargets = [mrkAAF] call AS_fnc_getPatrolTargets;
_distance = 50;
if (_vehicleType isKindOf "helicopter") then {
	_arrayTargets = mrkAAF;
	_distance = 300;
};
if (_vehicleType in vehPatrolBoat) then {
	_arrayTargets = seaMarkers select {(getMarkerPos _x) distance _spawnPosition < 2500};
	_distance = 100;
};

if (count _arrayTargets < 1) exitWith {};

AAFpatrols = AAFpatrols + 1; publicVariableServer "AAFpatrols";

if !(_vehicleType isKindOf "helicopter") then {
	if (_vehicleType in vehPatrolBoat) then {
		_spawnPosition = [_spawnPosition,80,200,10,2,0,0] call BIS_Fnc_findSafePos;
	} else {
		_spawnpositionData = [_spawnPosition, getMarkerPos (selectRandom _arrayTargets)] call AS_fnc_findSpawnSpots;
		_spawnPosition = _spawnpositionData select 0;
		_direction = _spawnpositionData select 1;
	};
};

_vehicleData = [_spawnPosition, 0,_vehicleType, side_green] call bis_fnc_spawnvehicle;
_vehicle = _vehicleData select 0;
[_vehicle] spawn genVEHinit;
[_vehicle,"Patrol"] spawn inmuneConvoy;
_groupVehicle = _vehicleData select 2;
_allGroups pushBack _groupVehicle;
_allVehicles pushBack _vehicle;

if (_vehicle iskindof "ship") then {
	_beach = [_vehicle,0,200,0,0,90,1] call BIS_Fnc_findSafePos;
	_vehicle setdir ((_vehicle getRelDir _beach) + 180);
};


if (_vehicleType isKindOf "Car") then {
	sleep 1;
	_groupType = [infGarrisonSmall, side_green] call AS_fnc_pickGroup;
	_group = [_spawnPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
	{_x assignAsCargo _vehicle; _x moveInCargo _vehicle; [_x] join _groupVehicle;} forEach units _group;
	[_vehicle] spawn smokeCover;
};

{
	_group = _x;
	{
		[_x] spawn genInit;
		_allSoldiers pushBack _x;
	};
} forEach _allGroups;

{[_x] spawn genVEHinit} forEach _allVehicles;

while {alive _vehicle} do
	{
	_target = _arrayTargets call bis_Fnc_selectRandom;
	_targetPosition = getMarkerPos _target;
	deleteWaypoint [_groupVehicle, 1];
	_wp_v_1 = _groupVehicle addWaypoint [_targetPosition, 0];
	if (_vehicle isKindOf "helicopter") then {_wp_v_1 setWaypointType "LOITER"} else {_wp_v_1 setWaypointType "MOVE"};
	_wp_v_1 setWaypointBehaviour "SAFE";
	_wp_v_1 setWaypointSpeed "LIMITED";
	_vehicle setFuel 1;
	while {true} do {
		sleep 60;
		{
			if (_x select 2 == side_blue) then {
				_object = _x select 4;
				_knowledge = (driver _vehicle) knowsAbout _object;
				if (_knowledge > 1.4) then {
					{
						_group = _x;
						if (leader _group distance _vehicle < distanciaSPWN) then {_group reveal [_object,_knowledge]};
					} forEach allGroups;
				};
			};
		} forEach (driver _vehicle nearTargets distanciaSPWN);
		if ((_vehicle distance2d _targetPosition < _distance) OR ({alive _x} count _allSoldiers == 0) OR ({fleeing _x} count _allSoldiers == {alive _x} count _allSoldiers) OR !(canMove _vehicle)) exitWith {};
	};

	if (({alive _x} count _allSoldiers == 0) OR ({fleeing _x} count _allSoldiers == {alive _x} count _allSoldiers) OR !(canMove _vehicle)) exitWith {};
	_arrayTargets = [mrkAAF] call AS_fnc_getPatrolTargets;
	if (_vehicleType isKindOf "helicopter") then {
		_arrayTargets = mrkAAF;
	};
	if (_vehicleType in vehPatrolBoat) then {
		_arrayTargets = seaMarkers select {(getMarkerPos _x) distance position _vehicle < 2500};
	};
};


AAFpatrols = AAFpatrols - 1; publicVariableServer "AAFpatrols";

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;