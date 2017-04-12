if !(isServer) exitWith {};

private ["_currentTime","_colinas","_blueUnits", "_opforUnits", "_marker", "_markerPos"];

debugperf = false;
_currentTime = time;
_colinas = colinas - colinasAA;

while {true} do {
	sleep 1;
	if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 marcadores", time - _currentTime, count marcadores]};
	_currentTime = time;

	waitUntil {!isNil "Slowhand"};

	_blueUnits = [];
	_opforUnits = [];
	{
		if (_x getVariable ["BLUFORSpawn",false]) then {
			_blueUnits pushBack _x;
			if (isPlayer _x) then {
				if !(isNull (getConnectedUAV _x)) then {
					_blueUnits pushBack (getConnectedUAV _x);
				};
			};
		} else {
			if (_x getVariable ["OPFORSpawn",false]) then {
				_opforUnits pushBack _x;
			};
		}
	} forEach allUnits;

	{
		_marker = _x;
		_markerPos = getMarkerPos (_marker);

		call {
			if (_marker in mrkAAF) exitWith {
				if !(spawner getVariable _marker) then {
					if (({(_x distance _markerPos < distanciaSPWN)} count _blueUnits > 0) OR (_marker in forcedSpawn)) then {
						spawner setVariable [_marker,true,true];
						call {
							if (_marker in _colinas) exitWith {[_marker] remoteExec ["createWatchpost",HCGarrisons]};
							if (_marker in colinasAA) exitWith {[_marker] remoteExec ["createAAsite",HCGarrisons]};
							if (_marker in ciudades) exitWith {[_marker] remoteExec ["createCIV",HCciviles]; [_marker] remoteExec ["createCity",HCGarrisons]};
							if (_marker in power) exitWith {[_marker] remoteExec ["createPower",HCGarrisons]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createBase",HCGarrisons]};
							if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock",HCGarrisons]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createAirbase",HCGarrisons]};
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createResources",HCGarrisons]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createOutpost",HCGarrisons]};
							if ((_marker in artyEmplacements) AND (_marker in forcedSpawn)) exitWith {[_marker] remoteExec ["createArtillery",HCGarrisons]};
						};
					};
				} else {
					if (({_x distance _markerPos < distanciaSPWN} count _blueUnits == 0) AND !(_marker in forcedSpawn)) then {
						spawner setVariable [_marker,false,true];
					};
				};
			};

			if !(spawner getVariable _marker) then {
				if (({_x distance _markerPos < distanciaSPWN} count _opforUnits > 0) OR ({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _blueUnits > 0) OR (_marker in forcedSpawn)) then {
					spawner setVariable [_marker,true,true];
					if (_marker in ciudades) then {
						if (({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _blueUnits > 0) OR (_marker in forcedSpawn)) then {[_marker] remoteExec ["createCIV",HCciviles]};
						[_marker] remoteExec ["createCity",HCGarrisons]
					} else {
						call {
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createFIArecursos",HCGarrisons]};
							if ((_marker in power) OR (_marker == "FIA_HQ")) exitWith {[_marker] remoteExec ["createFIApower",HCGarrisons]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createNATOaerop",HCGarrisons]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createNATObases",HCGarrisons]};
							if (_marker in puestosFIA) exitWith {[_marker] remoteExec ["createFIAEmplacement",HCGarrisons]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createFIAOutpost",HCGarrisons]};
							if (_marker in campsFIA) exitWith {[_marker] remoteExec ["createCampFIA",HCGarrisons]};
							if (_marker in puestosNATO) exitWith {[_marker] remoteExec ["createNATOpuesto",HCGarrisons]};
						};
					};
				};
			} else {
				if ((({_x distance _markerPos < distanciaSPWN} count _opforUnits == 0) AND ({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _blueUnits == 0)) AND !(_marker in forcedSpawn)) then {
					spawner setVariable [_marker,false,true];
				};
			};
		};
	} forEach marcadores;
};