params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration", "_type"];

diag_log format ["QRF - air cav // veh: %1; origin: %2; destination: %3; mark: %4; inf group: %5; duration: %6", _vehGroup, _origin, _dest, _mrk, _infGroups, _duration];

if (_type == "rope") then {
	[_vehGroup, _origin, _dest, _mrk, _infGroups, _duration] call AS_fnc_QRF_fastrope;
};
if (_type == "land") then {
	 [_vehGroup, _origin, _dest, _mrk, _infGroups, _duration, "air"] call AS_fnc_QRF_dismountTroops;
};