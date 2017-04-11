['statSave\loadAccount.sqf','BIS_fnc_execVM'] call BIS_fnc_MP;
//placementDone = true; publicVariable 'placementDone';
waitUntil {sleep 0.5; !(isNil "ASA3_saveLoaded")};
ASA3_saveLoaded = nil;
