private _objs = [];
{
	if ((  str typeof _x find "Land_Camping_Light_F" > -1
	    or str typeof _x find "Land_BagFence_Round_F" > -1
    	or str typeof _x find "CamoNet_BLUFOR_open_F" > -1))
	then {
    	_objs pushBack _x;
		};
} forEach nearestObjects [getPos fuego, [], 60];
{
	removeAllActions _x;
	_x addAction [localize "Str_act_moveAsset", "moveObject.sqf","static",0,false,true,"","(_this == stavros)", 5];
} forEach staticsToSave + _objs;