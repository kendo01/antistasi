params ["_vehGroup", "_origin", "_dest", "_duration"];

diag_log format ["QRF - Gunship // veh: %1; origin: %2; destination: %3; duration: %4", _vehGroup, _origin, _dest, _duration];

[_vehGroup, _origin, _dest] call AS_fnc_QRF_approachTarget;
[_vehGroup, _origin, _dest, 300, _duration] call AS_fnc_QRF_loiter;