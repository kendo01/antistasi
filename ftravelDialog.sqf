params [
	["_action", "create", [""]],

	["_markers", mrkAAF],
	["_maxCamps", 4],
	["_permission", true],
	["_text", "Error in permission system, module ft."],
	["_position", []],
	["_mapPos", []],
	["_cost", 500],
	["_hr", 0],
	["_groupType", [guer_grp_sniper, "guer"] call AS_fnc_pickGroup]
];

private ["_zone"];

if !([player] call hasRadio) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

_action = toLower _action;

// BE module
if ((activeBE) AND {_action isEqualTo "create"}) then {
	_permission = ["camp"] call fnc_BE_permission;
	_text = "We cannot maintain any additional camps.";
	_maxCamps = 100;
};

if !(_permission) exitWith {hint _text};
// BE module

openMap true;
posicionTel = [];
if (_action isEqualTo "create") then {hint "Click on the position you wish to establish the camp."};
if (_action isEqualTo "delete") then {hint "Click on the camp to abandon a camp."};
if (_action isEqualTo "rename") then {hint "Click on the camp to rename a camp."};

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

if (getMarkerPos guer_respawn distance posicionTel < 100) exitWith {hint "Location is too close to base"; openMap false;};

openMap false;
_mapPos = posicionTel;

if ((_action isEqualTo "delete") AND {count campsFIA < 1}) exitWith {hint "No camps to abandon."};
if ((_action isEqualTo "delete") AND ({(alive _x) AND {!captive _x} AND ((side _x == side_green) OR (side _x == side_red)) AND {_x distance _mapPos < 500}} count allUnits > 0)) exitWith {hint "You cannot delete a camp while enemies are near it."};
if ((_action == "create") AND {count campsFIA >= _maxCamps}) exitWith {hint format ["You can only sustain a maximum of %1 camps.", _maxCamps]};

if (_action isEqualTo "create") then {
	if !(typeName _groupType == "ARRAY") then {
		_groupType = [_groupType] call groupComposition;
	};
	{
		_cost = _cost + (server getVariable [_x, 100]);
		_hr = _hr + 1;
	} forEach _groupType;
};

if (_action isEqualTo "delete") exitWith {
	_zone = [campsFIA, _mapPos] call BIS_fnc_nearestPosition;
	_position = getMarkerPos _zone;
	if (_position distance _mapPos > 50) then {
		openMap false;
		hint "No camp nearby.";
	} else {
		[_action, _position] remoteExec ["establishCamp", 2];
	};
};

if (_action isEqualTo "rename") exitWith {
	_zone = [campsFIA, _mapPos] call BIS_fnc_nearestPosition;
	_position = getMarkerPos _zone;
	if (_position distance _mapPos > 50) then {
		openMap false;
		hint "No camp nearby.";
	} else {
		createDialog "rCamp_Dialog";

		((uiNamespace getVariable "rCamp") displayCtrl 1400) ctrlSetText cName;

		waitUntil {dialog};
		waitUntil {!dialog};
		if (cName == "") exitWith {hint "No name entered..."};
		_zone setMarkerText cName;
		for "_i" from 0 to (count campList - 1) do {
			if ((campList select _i) select 0 == _zone) then {
				(campList select _i) set [1, cName];
			};
		};
		publicVariable "campList";
		cName = "";
		hint "Camp renamed";
	};
};

if (((server getVariable ["resourcesFIA", 0]) < _cost) OR {server getVariable ["hr", 0] < _hr}) exitWith {hint format ["You lack of resources to build this camp. \n %1 HR and %2 € needed",_hr,_cost]};

[-_hr,-_cost] remoteExec ["resourcesFIA", 2];
[_action, _mapPos] remoteExec ["establishCamp", 2];