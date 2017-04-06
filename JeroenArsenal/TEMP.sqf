
_arrayNew = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
{
 _index = _foreachindex;
 if!(_index in [15,16,17])then{
  {
   _arrayNew select _index pushBack [_x,500];
  } forEach _x;
 };
} forEach (missionnamespace getvariable "bis_fnc_arsenal_data");
jna_dataList = _arrayNew


[[["srifle_DMR_01_F",1]],[],[],[["U_B_CombatUniform_mcam",1]],[],[],[],[],[],[],[["ItemMap",1]],[["ItemGPS",1]],[],[],[],[],[],[],[["optic_Arco",1]],[],[],[],[["HandGrenade",1]],[],[],[],[["10Rnd_762x54_Mag",10]]]


"SubmachineGun"

test2 = [];



{
	if((_x call BIS_fnc_itemType select 1) == "SubmachineGun")then{
		test2 pushBack _x;
	}
} forEach test1;

copyToClipboard ( missionnamespace getvariable "bis_fnc_arsenal_data" select 2);