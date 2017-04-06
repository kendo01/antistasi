//create an array of items which are in the given container

#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

#define IDCS_LEFT\
	IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,\
	IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,\
	IDC_RSCDISPLAYARSENAL_TAB_VEST,\
	IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,\
	IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,\
	IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,\
	IDC_RSCDISPLAYARSENAL_TAB_NVGS,\
	IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,\
	IDC_RSCDISPLAYARSENAL_TAB_MAP,\
	IDC_RSCDISPLAYARSENAL_TAB_GPS,\
	IDC_RSCDISPLAYARSENAL_TAB_RADIO,\
	IDC_RSCDISPLAYARSENAL_TAB_COMPASS,\
	IDC_RSCDISPLAYARSENAL_TAB_WATCH,\
	IDC_RSCDISPLAYARSENAL_TAB_FACE,\
	IDC_RSCDISPLAYARSENAL_TAB_VOICE,\
	IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA

#define IDCS_RIGHT\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC\

private["_container","_array","_unloadContainer"];
_container = _this;
_array = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];


_addToArray = {
	private ["_array","_index","_item","_amount"];
	_array = _this select 0;
	_index = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;

	if!(_index == -1 || _item isEqualTo ""||_amount == 0)then{
		_array set [_index,[_array select _index,[_item,_amount]] call jna_fnc_addToArray];
	};
};

//recursion function to unload sub, sub,...
_unloadContainer = {
	_container_sub = _this;

	//magazines(exl. loaded ones)
	_mags = magazinesAmmoCargo _container_sub;
	{
		_item = _x select 0;
		_amount = _x select 1;
		_index = [_item,[
			IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW
		]] call jna_fnc_ItemType;
		[_array,_index,_item,_amount]call _addToArray;
	} forEach _mags;

	//items
	_items = itemCargo _container_sub;
	{
		_item = _x;
		_index = _item call jna_fnc_ItemType;
		[_array,_index,_item,1]call _addToArray;
	} forEach _items;

	//backpacks
	_backpacks = backpackCargo _container_sub;
	{
		_item = _x call BIS_fnc_basicBackpack;
		_index = IDC_RSCDISPLAYARSENAL_TAB_BACKPACK;
		[_array,_index,_item,1]call _addToArray;
	} forEach _backpacks;

	//weapons and attachmetns
	_attItems = weaponsItemsCargo _container_sub;
	// [["arifle_TRG21_GL_F","","","optic_DMS",["ammo"],""]]
	{
		{
			private["_index","_item","_amount"];
			if(typename _x  isEqualTo "ARRAY")then{
				if(count _x > 0)then{
					_item = _x select 0;
					_amount = _x select 1;
					_index = IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL;
					[_array,_index,_item,_amount]call _addToArray;
				};
			}else{
				if!(_x isEqualTo "")then{
					_item = _x;
					_amount = 1;
					_index = [_item,[
						IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
						IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
						IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
						IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,
						IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,
						IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,
						IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,
						IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS
					]] call jna_fnc_ItemType;

					if(_index in [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON, IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON, IDC_RSCDISPLAYARSENAL_TAB_HANDGUN])then{
						_item = _x call bis_fnc_baseWeapon;
					};


					if(_index != -1)then{
						[_array,_index,_item,_amount]call _addToArray;
					};
				};
			};
		}foreach _x;
	}foreach _attItems;



	//sub containers;
	{
		_x select 1 call _unloadContainer;
	}foreach (everyContainer _container_sub);
};

//startloop
_container call _unloadContainer;

//return array of items
_array;