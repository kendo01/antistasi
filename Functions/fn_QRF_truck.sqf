params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration"];

diag_log format ["QRF - truck // veh: %1; origin: %2; destination: %3; mark: %4; inf group: %5; duration: %6", _vehGroup, _origin, _dest, _mrk, _infGroups, _duration];

[_vehGroup, _origin, _dest, _mrk, _infGroups, _duration, "ground"] call AS_fnc_QRF_dismountTroops;