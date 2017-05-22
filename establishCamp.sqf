if (!isServer) exitWith {};

params [
	["_action", "delete", [""]],
	"_position",

	["_cost", 0],
	["_hr", 0],
	["_nameOptions", campNames - usedCN],
	["_tskTitle", localize "STR_TSK_EMP_CAMP"],
	["_tskDesc", localize "STR_TSKDESC_EMP_CAMP"]
];

private ["_zone", "_groupType", "_campName", "_endTime", "_group", "_truck", "_driver", "_tempGroup", "_crate", "_owner"];

#define DURATION 60

if (_action == "delete") exitWith {
	_zone = [campsFIA,_position] call BIS_fnc_nearestPosition;
	hint format ["Deleting %1", markerText _zone];

	_groupType = ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup);
	if !(typeName _groupType == "ARRAY") then {
		_groupType = [_groupType] call groupComposition;
	};

	{
		_cost = _cost + (server getVariable [_x, 100]);
		_hr = _hr + 1;
	} forEach _groupType;

	[_hr, _cost] remoteExec ["resourcesFIA", 2];
	campsFIA = campsFIA - [_zone]; publicVariable "campsFIA";
	campList = campList - [[_zone, markerText _zone]]; publicVariable "campList";
	usedCN = usedCN - [markerText _zone]; publicVariable "usedCN";
	marcadores = marcadores - [_zone]; publicVariable "marcadores";
	deleteMarker _zone;
};

_zone = createMarker [format ["FIACamp%1", random 1000], _position];
_zone setMarkerShape "ICON";

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + DURATION];
_endTime = dateToNumber _endTime;

_tsk = ["campsFIA", [side_blue, civilian], [_tskDesc, _tskTitle, _zone], _position, "CREATED", 5, true, true, "Move"] call BIS_fnc_setTask;
misiones pushBackUnique _tsk; publicVariable "misiones";

([getMarkerPos guer_respawn, _position] call AS_fnc_findRoadspot) params ["_spawnPos", "_spawnDir"];
_spawnPos = ([_spawnPos, getMarkerPos guer_respawn] select (count _spawnPos == 0)) findEmptyPosition [1, 50, guer_veh_truck];

_group = createGroup side_blue;
_truck = guer_veh_truck createVehicle _spawnPos;
_truck setDir _spawnDir;
_driver = _group createUnit [guer_sol_R_L, _spawnPos, [], 0, "FORM"];
_driver assignAsDriver _truck;
_driver moveInDriver _truck;
_group selectLeader _driver;
_driver action ["engineOn", _truck];

_tempGroup = [getMarkerPos guer_respawn, side_blue, ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup)] call BIS_Fnc_spawnGroup;
{
	_x moveInCargo _truck;
} forEach (units _tempGroup);

(units _tempGroup) joinsilent _group;

{[_x] call AS_fnc_initialiseFIAUnit;} forEach units _group;

_group setGroupId ["Watch"];
[_group] spawn dismountFIA;

leader _group setBehaviour "SAFE";
Slowhand hcSetGroup [_group];
_group setVariable ["isHCgroup", true, true];

_crate = "Box_FIA_Support_F" createVehicle _spawnPos;
_crate attachTo [_truck,[0.0,-1.4,0.5]];

waitUntil {sleep 1; ({alive _x} count units _group == 0) OR {{(alive _x) AND {_x distance _position < 10}} count units _group > 0} OR {dateToNumber date > _endTime}};

if ({(alive _x) AND {_x distance _position < 10}} count units _group > 0) then {
	if (isPlayer leader _group) then {
		_owner = (leader _group) getVariable ["owner",leader _group];
		(leader _group) remoteExec ["removeAllActions",leader _group];
		_owner remoteExec ["selectPlayer",leader _group];
		(leader _group) setVariable ["owner",_owner,true];
		{[_x] joinsilent group _owner} forEach units group _owner;
		[group _owner, _owner] remoteExec ["selectLeader", _owner];
		"" remoteExec ["hint",_owner];
		waitUntil {!(isPlayer leader _group)};
	};

	_campName = selectRandom _nameOptions;
	campsFIA = campsFIA + [_zone]; publicVariable "campsFIA";
	campList = campList + [[_zone, _campName]]; publicVariable "campList";
	mrkFIA = mrkFIA + [_zone]; publicVariable "mrkFIA";
	marcadores = marcadores + [_zone];
	publicVariable "marcadores";
	spawner setVariable [_zone,false,true];
	_tsk = ["campsFIA", [side_blue, civilian], [_tskDesc, _tskTitle, _zone], _position, "SUCCEEDED", 5, true, true, "Move"] call BIS_fnc_setTask;
	_zone setMarkerType "loc_bunker";
	_zone setMarkerColor "ColorOrange";
	_zone setMarkerText _campName;
	usedCN pushBack _campName;
} else {
	_tsk = ["campsFIA", [side_blue, civilian], [_tskDesc, _tskTitle, _zone], _position, "FAILED", 5, true, true, "Move"] call BIS_fnc_setTask;
	sleep 3;
	deleteMarker _zone;
};

Slowhand hcRemoveGroup _group;
{deleteVehicle _x} forEach ((units _group) + [_truck, _crate]);
deleteGroup _group;
sleep 15;

[0,_tsk] spawn borrarTask;