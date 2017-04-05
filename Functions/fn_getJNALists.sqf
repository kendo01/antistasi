params ["_source"];
[[],[],[],[]] params ["_launcherArray","_rifleArray","_itemArray","_returnArray"];

call {
	if (_source isEqualTo "initFIA") exitWith {
		if (count (jna_dataList select 0) > 0) then {
			{
				_rifleArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 0);
		};

		if (count (jna_dataList select 1) > 0) then {
			{
				_launcherArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 1);
		};

		if (count (jna_dataList select 8) > 0) then {
			{
				_itemArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 8);
		};

		if (count (jna_dataList select 12) > 0) then {
			{
				_itemArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 12);
		};

		if (count (jna_dataList select 9) > 0) then {
			{
				_itemArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 9);
		};

		if (count (jna_dataList select 19) > 0) then {
			{
				_itemArray pushBackUnique (_x select 0);
			} forEach (jna_dataList select 19);
		};

	_returnArray = [_rifleArray,_launcherArray,_itemArray];
	};
};

_returnArray