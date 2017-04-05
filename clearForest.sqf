if (player != slowhand) exitWith {hint "Only Commanders can order to clear the forest"};
if (!isMultiplayer) then {{ _x hideObject true } foreach (nearestTerrainObjects [getMarkerPos "respawn_west",["tree","bush"],20])} else {{[_x,true] remoteExec ["hideObjectGlobal",2]} foreach (nearestTerrainObjects [getMarkerPos "respawn_west",["tree","bush"],20])};
hint "You've cleared the surroundings of trees and bushes";
chopForest = true; publicVariable "chopForest";
