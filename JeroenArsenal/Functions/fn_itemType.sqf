/*
    By: Jeroen Notenbomer

	Get the index of which item is part of

    Inputs:
        1: item			"name"
        2: (list)		[1,3,10]	index to search in, optional

    Outputs
        index or -1 if not found
*/


#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

private ["_item","_list","_type","_return","_index","_data","_dataSet"];

_data = (missionnamespace getvariable "bis_fnc_arsenal_data");

if(typeName _this isEqualTo "STRING")then{
	_item = _this;
	_list = [];
	{
		_list set [_forEachIndex,_forEachIndex];
	}forEach _data;
}else{
	_item = _this select 0;
	_list = _this select 1;
};

_type = _item call bis_fnc_itemType; //Todo check if bis_fnc_itemType is faster then looping all lists
_return = switch (_type select 1) do {
	case "AccessoryMuzzle": {IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE;};
	case "AccessoryPointer": {IDC_RSCDISPLAYARSENAL_TAB_ITEMACC;};
	case "AccessorySights": {IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC;};
	case "AccessoryBipod": {IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD;};
	default {-1};
};

if(_return == -1)then{
	{
		_dataSet = _data select _x;
		if(_item in _dataSet)exitwith{_return = _x};
	}forEach _list;
};

_return;