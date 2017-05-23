if (isDedicated || !hasInterface) exitWith {};

/*
 	Description:
		Display local (<400m) city support and power supply to player, refreshed every 5 seconds.

	Parameters:
		Player

 	Returns:
		Nothing

 	Example:
		0 = [player] spawn localSupport;
*/

params [
	"_player",

	["_cityNames", []]
];
private ["_cities" ,"_location", "_data", "_prestigeOPFOR", "_prestigeBLUFOR", "_text", "_icon", "_power", "_info", "_colour"];

#define CGREY "#a44232"
#define CBLUE "#3399FF"
#define CGREEN "#1DA81D"

{
	_cityNames pushBack (getText (configfile >> "CfgWorlds" >> worldName >> "Names" >> _x >> "name"));
} forEach ciudades;

_fnc_getName = {
	params ["_city"];
	_cityNames select (ciudades find _city)
};

while {true} do {
	_cities = ciudades select {spawner getVariable [_x,false]};

	if (count _cities > 0) then {
		_location = [_cities, position _player] call BIS_Fnc_nearestPosition;

		if ((getMarkerPos _location distance _player) < 400) then {
			_power = [power, position _player] call BIS_fnc_nearestPosition;

			call {
				if (_power in destroyedCities) exitWith {_icon = '\A3\ui_f\data\map\mapcontrol\power_ca.paa'; _colour = CGREY};
				if (_power in mrkAAF) exitWith {_icon = '\A3\ui_f\data\map\mapcontrol\power_ca.paa'; _colour = ([CGREEN, CBLUE] select replaceFIA)};
				if (_power in mrkFIA) exitWith {_icon = '\A3\ui_f\data\map\mapcontrol\power_ca.paa'; _colour = ([CBLUE, CGREEN] select replaceFIA)};
			};

			while {(getMarkerPos _location distance _player) < 400} do {
				_data = server getVariable _location;
				_prestigeOPFOR = _data select 2;
				_prestigeBLUFOR = _data select 3;
				_info = format ["<img image='%1' size='0.4' color='%2' />", _icon, _colour];
				_text = format ["<t size='.4' align='center' color='#C1C0BB'>%1 %4 <br />%5: <t color='%6'>%2</t> / <t color='%7'>%3</t></t>", [_location] call _fnc_getName, _prestigeBLUFOR, _prestigeOPFOR, _info, localize "STR_INFO_LOCALSUPPORT", ([CBLUE, CGREEN] select replaceFIA), ([CGREEN, CBLUE] select replaceFIA)];
				[_text,[0.85 * safeZoneW + safeZoneX, 0.4 * safeZoneW + safeZoneX],[0.9 * safezoneH + safezoneY, 0.3 * safezoneH + safezoneY],7,0,0,1911] spawn BIS_fnc_dynamicText;
				sleep 5;
			};
		};
	};

	sleep 5;
};