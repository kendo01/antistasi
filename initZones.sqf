private ["_allMarkers","_sizeX","_sizeY","_size","_name","_pos","_roads","_numCiv","_roadsProv","_roadcon","_numVeh","_nroads","_nearRoadsFinalSorted","_mrk","_dmrk","_info","_antennaArray","_antenna","_bankArray","_bank"];

{
    missionNamespace setVariable [_x, []];
} forEach ["AS_destroyedZones","forcedSpawn","ciudades","colinas","colinasAA","power","bases","aeropuertos","recursos","fabricas","puestos","puestosAA","puertos","controles","artyEmplacements","seaMarkers","puestosFIA","puestosNATO","campsFIA","mrkAAF","destroyedCities","posAntenas","antenas","mrkAntenas","bancos"];

// Search the markers placed within the SQM for each type and create corresponding lists. A pre-defined list is available for Altis.
if (worldName == "Altis") then {
    call compile preprocessFileLineNumbers "Zones\AltisZones.sqf";
} else {
    _allMarkers = allMapMarkers;
    {
        call {
            if (toLower _x find "control" >= 0) exitWith {controles pushBackUnique _x};
            if (toLower _x find "puestoAA" >= 0) exitWith {puestosAA pushBackUnique _x};
            if (toLower _x find "puesto" >= 0) exitWith {puestos pushBackUnique _x};
            if (toLower _x find "seaPatrol" >= 0) exitWith {seaMarkers pushBackUnique _x};
            if (toLower _x find "base" >= 0) exitWith {bases pushBackUnique _x};
            if (toLower _x find "power" >= 0) exitWith {power pushBackUnique _x};
            if (toLower _x find "airport" >= 0) exitWith {aeropuertos pushBackUnique _x};
            if (toLower _x find "resource" >= 0) exitWith {recursos pushBackUnique _x};
            if (toLower _x find "factory" >= 0) exitWith {fabricas pushBackUnique _x};
            if (toLower _x find "artillery" >= 0) exitWith {artyEmplacements pushBackUnique _x};
            if (toLower _x find "mtn_comp" >= 0) exitWith {colinasAA pushBackUnique _x};
            if (toLower _x find "mtn" >= 0) exitWith {colinas pushBackUnique _x};
            if (toLower _x find "puerto" >= 0) exitWith {puertos pushBackUnique _x};
        };
    } forEach _allMarkers;
};

mrkFIA = ["FIA_HQ"];
garrison setVariable ["FIA_HQ",[],true];
marcadores = power + bases + aeropuertos + recursos + fabricas + puestos + puertos + controles + colinasAA + puestosAA + ["FIA_HQ"];

// Make sure all markers are invisible and not currently marked as having been spawned in.
{_x setMarkerAlpha 0;
    spawner setVariable [_x,false,true];
} forEach (marcadores + artyEmplacements);
{_x setMarkerAlpha 0} forEach seaMarkers;

// Detect cities, set their population to the number of houses within their city limits, create a database of roads, set number of civilian vehicles to spawn with regards to number of roads. Pre-defined for Altis.
{
    _name = [text _x, true] call AS_fnc_location;
    if ((_name != "") and (_name != "sagonisi") and (_name != "hill12")) then {
        _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
        _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
        _size = [_sizeX, _sizeY] select (_sizeX < _sizeY);
        if (_size < 200) then {_size = 200};

        _pos = getPos _x;
        _roads = [];
        _numCiv = 0;
        if (worldName != "Altis") then {
            _numCiv = (count (nearestObjects [_pos, ["house"], _size]));
            _roadsProv = _pos nearRoads _size;
            {
                _roadcon = roadsConnectedto _x;
                if (count _roadcon == 2) then {
                    _roads pushBack (getPosATL _x);
                };
            } forEach _roadsProv;
            carreteras setVariable [_name,_roads];
        } else {
            _roads = carreteras getVariable _name;
            _numCiv = server getVariable _name;
            if (isNil "_numCiv") then {hint format ["Error in initZones.sqf -- population not set for: %1",_name]};
            if (typeName _numCiv != typeName 0) then {hint format ["Error in initZones.sqf -- wrong datatype for population. City: %1; datatype: %2",_name, typeName _numCiv]};
        };

        _numVeh = round (_numCiv / 3);
        _nroads = count _roads;
        _nearRoadsFinalSorted = [_roads, [], { _pos distance _x }, "ASCEND"] call BIS_fnc_sortBy;
        _pos = _nearRoadsFinalSorted select 0;
        _mrk = createmarker [format ["%1", _name], _pos];
        _mrk setMarkerSize [_size, _size];
        _mrk setMarkerShape "RECTANGLE";
        _mrk setMarkerBrush "SOLID";
        _mrk setMarkerColor IND_marker_colour;
        _mrk setMarkerText _name;
        _mrk setMarkerAlpha 0;
        ciudades pushBack _name;
        spawner setVariable [_name,false,true];
        _dmrk = createMarker [format ["Dum%1",_name], _pos];
        _dmrk setMarkerShape "ICON";
        _dmrk setMarkerType "loc_Cross";
        _dmrk setMarkerColor IND_marker_colour;

        if (_nroads < _numVeh) then {_numVeh = _nroads};
        _info = [_numCiv, _numVeh, prestigeOPFOR,prestigeBLUFOR];
        server setVariable [_name,_info,true];
    };
} foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCityCapital","NameCity","NameVillage","CityCenter"], worldSize/1.414]);

// Detect named mountaintops and automatically add them as zones to spawn a watchpost at. If your map has a shortage of named mountains, place markers within the SQM, with incremental names starting with "mtn_1" for automatic watchpost placement or "mtn_comp_1" for positions with pre-defined compositions.
{
    _name = text _x;
    if ((_name != "Magos") AND !(_name == "")) then {
        _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
        _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
        if (_sizeX > _sizeY) then {_size = _sizeX} else {_size = _sizeY};
        _pos = getPos _x;
        if (_size < 10) then {_size = 50};

        _mrk = createmarker [format ["%1", _name], _pos];
        _mrk setMarkerSize [_size, _size];
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "SOLID";
        _mrk setMarkerColor "ColorRed";
        _mrk setMarkerText _name;
        colinas pushBack _name;
        spawner setVariable [_name,false,true];
        _mrk setMarkerAlpha 0;
    };
} foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["Hill"], worldSize/1.414]);

colinas = colinas arrayIntersect colinasAA;

marcadores = marcadores + colinas + ciudades;

planesAAFmax = count aeropuertos;
helisAAFmax = 2* (count aeropuertos);
tanksAAFmax = count bases;
APCAAFmax = 2* (count bases);

// Place visible markers on the map for zones of interest. Additional roadblocks will be created automatically on every map except Altis, where enough have been placed in the SQM.
_fnc_marker = {};
if (worldName == "Altis") then {
    _fnc_marker = {
        params ["_loc", "_type", "_text"];

        _pos = getMarkerPos _loc;
        _dmrk = createMarker [format ["Dum%1",_loc], _pos];
        _dmrk setMarkerShape "ICON";
        _dmrk setMarkerColor IND_marker_colour;
        garrison setVariable [_loc,[],true];
        _dmrk setMarkerType _type;
        _dmrk setMarkerText _text;
    };
} else {
    _fnc_marker = {
        params ["_loc", "_type", "_text"];

        _pos = getMarkerPos _loc;
        _dmrk = createMarker [format ["Dum%1",_loc], _pos];
        _dmrk setMarkerShape "ICON";
        _dmrk setMarkerColor IND_marker_colour;
        [_loc] call AS_fnc_createRoadblocks;
        garrison setVariable [_loc,[],true];
        _dmrk setMarkerType _type;
        _dmrk setMarkerText _text;
    };
};

{
    [_x, "loc_power", "Power Plant"] call _fnc_marker;
} forEach power;

{
    [_x, IND_marker_type, format ["%1 Airport", A3_Str_INDEP]] call _fnc_marker;
    server setVariable [_x,dateToNumber date,true];
} forEach aeropuertos;

{
    [_x, IND_marker_type, format ["%1 Base", A3_Str_INDEP]] call _fnc_marker;
    server setVariable [_x,dateToNumber date,true];
} forEach bases;

{
    [_x, "loc_rock", "Resources"] call _fnc_marker;
} forEach recursos;

{
    [_x, "u_installation", "Factory"] call _fnc_marker;
} forEach fabricas;

{
    [_x, "loc_bunker", format ["%1 AA OP", A3_Str_INDEP]] call _fnc_marker;
} forEach puestosAA;

{
    [_x, "loc_bunker", format ["%1 Outpost", A3_Str_INDEP]] call _fnc_marker;
} forEach puestos;

{
    [_x, "b_naval", "Sea Port"] call _fnc_marker;
} forEach puertos;

marcadores = marcadores arrayIntersect marcadores;
mrkAAF = marcadores - ["FIA_HQ"];
publicVariable "mrkAAF";
publicVariable "mrkFIA";
publicVariable "marcadores";
publicVariable "ciudades";
publicVariable "colinas";
publicVariable "colinasAA";
publicVariable "power";
publicVariable "bases";
publicVariable "aeropuertos";
publicVariable "recursos";
publicVariable "fabricas";
publicVariable "puestos";
publicVariable "puestosAA";
publicVariable "controles";
publicVariable "puertos";
publicVariable "destroyedCities";
publicVariable "forcedSpawn";
publicVariable "puestosFIA";
publicVariable "seaMarkers";
publicVariable "campsFIA";
publicVariable "puestosNATO";

// Pre-defined radio tower positions, you'll have to define your own.
call {
    /*if (worldName == "Altis") exitWith {
        posAntenas = [[16085.1,16998,7.08781],[14451.5,16338,0.000358582],[15346.7,15894,-3.62396e-005],[9496.2,19318.5,0.601898],[20944.9,19280.9,0.201118],[17856.7,11734.1,0.863045],[20642.7,20107.7,0.236603],[9222.87,19249.1,0.0348206],[18709.3,10222.5,0.716034],[6840.97,16163.4,0.0137177],[19319.8,9717.04,0.215622],[19351.9,9693.04,0.639175],[10316.6,8703.94,0.0508728],[8268.76,10051.6,0.0100708],[4583.61,15401.1,0.262543],[4555.65,15383.2,0.0271606],[4263.82,20664.1,-0.0102234],[26274.6,22188.1,0.0139847],[26455.4,22166.3,0.0223694]];
    };*/
    if (worldName == "Napf") exitWith {
        posAntenas = [[16070.8,18728.7,0.954071],[16105.7,18770.7,1.18446],[15110.4,16165.1,0.776001],[16855,13751.4,0.000402451],[11110.4,11832.6,0],[10978.9,16997.1,7.60431],[9907.12,16868.7,0],[8410.67,17166.2,-3.8147e-006],[5809.04,15678,-1.90735e-005],[6539.08,13680.5,0],[6993.03,9640.53,-3.8147e-006],[4971,12145.6,19.5774],[8862.57,11069.1,-0.00062561],[10142.6,7573.33,0.892677],[13022.3,7666.49,0],[16135.4,8015.4,0.00234985],[17036.6,9705.19,-0.00144958],[15731.1,11408.6,0.000213623],[14745.5,14058.3,15.58],[12787.8,5307.9,0.67067],[8886.64,5414,-8.39233e-005],[5151.94,4478.55,0.272263],[8086.47,2926.47,0],[9683.31,2941.17,1.07095],[1915.22,2531.94,4.76837e-007],[2911.67,6244.56,-0.000724792],[2484.53,8348.84,3.8147e-006],[2339.39,11281.3,-0.00195313],[14653,3201.34,0.000709534],[18109.9,2065.21,0.470627],[17163.8,3466.25,0.000549316],[19112.5,6732.14,0],[11691.7,10256.6,-0.00038147]];
    };
    if (worldName == "Tanoa") exitWith {
        posAntenas = [[10113.9,11743.3,0],[2682.73,2592.63,0],[10950,11518,0],[9118.67,10182,0.000680923],[9565.26,9109.53,2.04544],[12705.9,7460.76,-0.00025177],[6882.55,7518.02,-2.38419e-007],[10756.4,6314,0.000848293],[6029.12,10158.8,0],[14183.9,8544.25,-3.91006e-005],[13186.6,11974.7,0],[11741.6,13086.5,-1.04904e-005],[11527.3,13155.8,0],[8379.38,13613,-0.000881195],[4209.16,11728.2,0.00281525],[2666.99,11680,0],[2671.42,12314.2,-0.000335693],[2327.81,13462.8,2.00272e-005],[2196.15,13196,9.53674e-007],[3921.22,13869.6,0.000519753],[2012.83,6502.85,0.914762],[2068.3,3431.05,1.77652],[5468.16,4848.56,0],[9350.2,4185.88,0.991756],[12528.7,2441.39,-0.000589848],[11770.4,2975.41,-7.39098e-005],[11196.7,5084.55,0.000939369],[12806.7,4898.42,3.98159e-005],[12432.9,14247.8,1.07415]];
    };
};

for "_i" from 0 to (count posantenas - 1) do {
    _antennaArray = nearestObjects [posantenas select _i,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], 25];
    if (count _antennaArray > 0) then {
        _antenna = _antennaArray select 0;
        antenas = antenas + [_antenna];
        _mrkfin = createMarker [format ["Ant%1", _i], posantenas select _i];
        _mrkfin setMarkerShape "ICON";
        _mrkfin setMarkerType "loc_Transmitter";
        _mrkfin setMarkerColor "ColorBlack";
        _mrkfin setMarkerText "Radio Tower";
        mrkAntenas = mrkAntenas + [_mrkfin];
        _antenna addEventHandler ["Killed", {
            _antenna = _this select 0;
            _mrk = [mrkAntenas, _antenna] call BIS_fnc_nearestPosition;
            antenas = antenas - [_antenna]; antenasmuertas = antenasmuertas + [getPos _antenna]; deleteMarker _mrk;
            if (hayBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
            [["TaskSucceeded", ["", localize "STR_TSK_RADIO_DESTROYED"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
        }];
    };
};
publicVariable "antenas";
antenasmuertas = [];

// Pre-defined bank positions, you'll have to define your own.
call {
    if (worldName == "Altis") exitWith {
        // posbancos = [[16633.3,12807,-0.635017],[3717.34,13391.2,-0.164862],[3692.49,13158.3,-0.0462093],[3664.31,12826.5,-0.379545]];
    };
};

bancos = [];
for "_i" from 0 to (count posbancos - 1) do {
    _bankArray = nearestObjects [posbancos select _i,["Land_Offices_01_V1_F"], 25];
    if (count _bankArray > 0) then {
        _bank = _bankArray select 0;
        bancos = bancos + [_bank];
    };
};

//the following is the console code snippet I use to pick positions of any kind of building. You may do this for gas stations, banks, radios etc.. markerPos "Base_4" is because it's in the middle of the island, and inside the array you may find the type of building I am searching for. Paste the result in a txt and add it to the corresponding arrays.
/*
pepe = nearestObjects [markerPos "base_4", ["Land_Offices_01_V1_F"], 16000];
pospepe = [];
{pospepe = pospepe + getPos _x} forEach pepe;
copytoclipboard str pospepe;
*/
if (isMultiplayer) then {[[petros,"hint", localize "STR_INFO_INITZONES"],"commsMP"] call BIS_fnc_MP;}