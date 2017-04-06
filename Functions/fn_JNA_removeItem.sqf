if !(isServer) exitWith {};

params ["_item",["_itemCategory","",jna_categories],["_itemCount",1,[0]]];
private ["_index","_data","_dataIndex"];

_itemCount = _itemCount max 1;

_index = missionNamespace getVariable [format ["jna_index_%1",_itemCategory],-1];
if (_index < 0) exitWith {format ["Error in JNA_removeItem: cannot find category index. Parameters: %1", _itemCategory]};

if (count (jna_dataList select _index) > 0) then {
	{
		if ((_x select 0) isEqualTo _item) exitWith {
			_dataIndex = _forEachIndex;
			_data =+ _x;
			_x set [1, ((_data select 1) - _itemCount) max 0];
		};
	} forEach (jna_dataList select _index);
};