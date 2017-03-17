params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroup", "_duration"];

diag_log format ["QRF - lead vehicle // veh: %1; origin: %2; destination: %3; mark: %4; inf group: %5; duration: %6", _vehGroup, _origin, _dest, _mrk, _infGroup, _duration];
[_vehGroup, _origin, _dest, _mrk, _infGroup, _duration] call AS_fnc_QRF_groundAssault;