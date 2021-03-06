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


//items that need to be removed from arsenal
_arrayPlaced = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
_arrayTaken = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
_arrayMissing = [];
_arrayReplaced = [];

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

_removeFromArray = {
	private ["_array","_index","_item","_amount"];
	_array = _this select 0;
	_index = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;

	if!(_index == -1 || _item isEqualTo ""|| _amount == 0)then{
		_array set [_index,[_array select _index,[_item,_amount]] call jna_fnc_removeFromArray];
	};
};

_addArrays = {
	_array1 = +(_this select 0);
	_array2 = +(_this select 1);
	{
		_index = _foreachindex;
		{
			_item = _x select 0;
			_amount = _x select 1;
			[_array1,_index,_item,_amount]call _addToArray;
		} forEach _x;
	} forEach _array2;
	_array1;
};

_subtractArrays = {
	_array1 = +(_this select 0);
	_array2 = +(_this select 1);
	{
		_index = _foreachindex;
		{
			_item = _x select 0;
			_amount = _x select 1;
			[_array1,_index,_item,_amount]call _removeFromArray;
		} forEach _x;
	} forEach _array2;
	_array1;
};

//name that needed to be loaded
_saveName = _this;
_saveData = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
_inventory = [];
{
	if(typename _x  == "STRING" && {_x == _saveName})exitWith{
		_inventory = _saveData select (_foreachindex + 1);
	};
} forEach _saveData;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// REMOVE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// magazines (loaded)
{

	//["30Rnd_65x39_caseless_green",30,false,-1,"Uniform"]

	_loaded = _x select 2;
	if(_loaded)then{
		_item = _x select 0;
		_amount = _x select 1;
		_index = [_item,[
			IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL
		]] call jna_fnc_itemType;
		//no need to remove because uniform, vest and backpack get replaced.
		[_arrayPlaced,_index,_item,_amount]call _addToArray;
	};
}foreach magazinesAmmoFull player;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// assinged items
_assignedItems_old = assignedItems player + [headgear player] + [goggles player] + [hmd player] + [binocular player];
{
	_item = _x;
	_amount = 1;
	_index = [_item,[
		IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,
		IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,
		IDC_RSCDISPLAYARSENAL_TAB_NVGS,
		IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,\
		IDC_RSCDISPLAYARSENAL_TAB_MAP,
		IDC_RSCDISPLAYARSENAL_TAB_GPS,
		IDC_RSCDISPLAYARSENAL_TAB_RADIO,
		IDC_RSCDISPLAYARSENAL_TAB_COMPASS,
		IDC_RSCDISPLAYARSENAL_TAB_WATCH
	]] call jna_fnc_itemType;
	player unlinkItem _item;

	//TFAR fix
	if(_index == -1)then{
		_radioName = getText(configfile >> "CfgWeapons" >> _item >> "tf_parent");
		if!(_radioName isEqualTo "")then{
			_item =_radioName;
			_index = IDC_RSCDISPLAYARSENAL_TAB_RADIO;
		};
	};

	[_arrayPlaced,_index,_item,_amount]call _addToArray;
} forEach _assignedItems_old - [""];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  weapon attachments
_attachments = primaryWeaponItems player + secondaryWeaponItems player + handgunItems player;
{
	_item = _x;
	_amount = 1;
	_index = [_item,[
		IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
	]] call jna_fnc_itemType;
	[_arrayPlaced,_index,_item,_amount]call _addToArray;
} forEach _attachments;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	weapons
_weapons = [primaryWeapon player, secondaryWeapon player, handgunWeapon player];
{
	_item = _x;
	_amount = 1;
	_index = _foreachindex;
	player removeWeapon _item;
	[_arrayPlaced,_index,_item,_amount]call _addToArray;
} forEach _weapons;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	uniform backpack vest (inc itmes)
_uniform_old = uniform player;
_vest_old = vest player;
_backpack_old = backpack player;

//remove items from containers
{
	_array = (_x call jna_fnc_cargoToArray);
	//remove because they where already added
	_arrayPlaced = [_arrayPlaced, _array] call _addArrays;
} forEach [uniformContainer player, vestContainer player, backpackContainer player];

//remove containers
removeuniform player;
[_arrayPlaced,IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,_uniform_old,1]call _addToArray;
removevest player;
[_arrayPlaced,IDC_RSCDISPLAYARSENAL_TAB_VEST,_vest_old,1]call _addToArray;
removebackpack player;
[_arrayPlaced,IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,_backpack_old,1]call _addToArray;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  ADD
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_isMember = [player] call isMember;
_availableItems = [jna_dataList, _arrayPlaced] call _addArrays;
_itemCounts =+ _availableItems;
{
	_index = _foreachindex;
	_subArray = _x;
	{
		_item = _x select 0;
		_amount = (_x select 1);
		if (_amount != -1) then {
			_amount = [(_x select 1) - (jna_minItemMember select _index),(_x select 1)] select _isMember;
		};
		_subArray set [_foreachindex, [_item,_amount]];
	} forEach _subArray;
	_availableItems set [_index, _subArray];
} forEach _availableItems;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  assinged items
_assignedItems = ((_inventory select 9) + [_inventory select 3] + [_inventory select 4] + [_inventory select 5]);					//todo add binocular batterys
{
	_item = _x;
	_amount = 1;
	_index = [_item,[
		IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,
		IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,
		IDC_RSCDISPLAYARSENAL_TAB_NVGS,
		IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,\
		IDC_RSCDISPLAYARSENAL_TAB_MAP,
		IDC_RSCDISPLAYARSENAL_TAB_GPS,
		IDC_RSCDISPLAYARSENAL_TAB_RADIO,
		IDC_RSCDISPLAYARSENAL_TAB_COMPASS,
		IDC_RSCDISPLAYARSENAL_TAB_WATCH
	]] call jna_fnc_itemType;

	//TFAR fix
	if(_index == -1)then{
		_radioName = getText(configfile >> "CfgWeapons" >> _item >> "tf_parent");
		if!(_radioName isEqualTo "")then{
			_item =_radioName;
			_index = IDC_RSCDISPLAYARSENAL_TAB_RADIO;
		};
	};


	if(_index == -1) then {
		_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
	} else {
		call {
			if ([_itemCounts select _index, _item] call jna_fnc_ItemCount == -1) exitWith {
				player linkItem _item;
			};
			if ([_availableItems select _index, _item] call jna_fnc_ItemCount > 0) then {
				player linkItem _item;
				[_arrayTaken,_index,_item,_amount]call _addToArray;
				[_availableItems,_index,_item,_amount]call _removeFromArray;
			} else {
				_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
			};
		};

	};

} forEach _assignedItems - [""];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// weapons and attachments
removebackpack player;
player addBackpack "B_Carryall_oli"; //add ammo to gun, can only be done by first adding a mag.
_weapons = [_inventory select 6,_inventory select 7,_inventory select 8];
{
	private ["_item"];
	_item = _x select 0;

	if!(_item isEqualTo "")then{
		private ["_itemAttachmets","_itemMag","_amount","_amountMag","_index","_indexMag"];
		_itemAttachmets = _x select 1;
		_itemMag = _x select 2;
		_amount = 1;
		_amountMag = getNumber (configfile >> "CfgMagazines" >> _itemMag >> "count");
		_index = _foreachindex;
		_indexMag = IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL;

		//add ammo to backpack, which need to be loaded in the gun.
		call {
			if ([_itemCounts select _indexMag, _itemMag] call jna_fnc_ItemCount == -1) exitWith {
				player addMagazine [_itemMag, _amountMag];
			};

			_amountMagAvailable = [_availableItems select _indexMag, _itemMag] call jna_fnc_ItemCount;
			if (_amountMagAvailable > 0) then {
				if (_amountMagAvailable < _amountMag) then {
					_arrayMissing = [_arrayMissing,[_itemMag,_amountMag]] call jna_fnc_addToArray;
					_amountMag = _amountMagAvailable;
				};
			[_arrayTaken,_indexMag,_itemMag,_amountMag] call _addToArray;
			[_availableItems,_indexMag,_itemMag,_amountMag] call _removeFromArray;
			player addMagazine [_itemMag, _amountMag];
			} else {
				_arrayMissing = [_arrayMissing,[_itemMag,_amountMag]] call jna_fnc_addToArray;
			};
		};

		//adding the gun
		call {
			if ((_index != -1) AND ([_itemCounts select _index, _item] call jna_fnc_ItemCount == -1)) exitWith {
				player addWeapon _item;
			};

			if ((_index != -1) AND {[_availableItems select _index, _item] call jna_fnc_ItemCount > 0}) then {
				player addWeapon _item;
				[_arrayTaken,_index,_item,_amount] call _addToArray;
				[_availableItems,_index,_item,_amount] call _removeFromArray;
			} else {
				_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
			};
		};

		//add attachments
		{
			_itemAcc = _x;
			if!(_itemAcc isEqualTo "")then{
				_amountAcc = 1;

				_indexAcc = [_itemAcc,[
					IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
				]] call jna_fnc_itemType;

				call {
					if ((_indexAcc != -1) AND ([_itemCounts select _indexAcc, _itemAcc] call jna_fnc_ItemCount == -1)) exitWith {
						switch _index do{
							case IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON:{player addPrimaryWeaponItem _itemAcc;};
							case IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON:{player addSecondaryWeaponItem _itemAcc;};
							case IDC_RSCDISPLAYARSENAL_TAB_HANDGUN:{player addHandgunItem _itemAcc;};
						};
					};

					if ((_indexAcc != -1) AND {[_availableItems select _indexAcc, _itemAcc] call jna_fnc_ItemCount != 0}) then {
						switch _index do{
							case IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON:{player addPrimaryWeaponItem _itemAcc;};
							case IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON:{player addSecondaryWeaponItem _itemAcc;};
							case IDC_RSCDISPLAYARSENAL_TAB_HANDGUN:{player addHandgunItem _itemAcc;};
						};
						[_arrayTaken,_indexAcc,_itemAcc,_amountAcc] call _addToArray;
						[_availableItems,_indexAcc,_itemAcc,_amountAcc] call _removeFromArray;
					} else {
						_arrayMissing = [_arrayMissing,[_itemAcc,_amountAcc]] call jna_fnc_addToArray;
					};
				};
			};
		}foreach _itemAttachmets;
	};
} forEach _weapons;
removebackpack player;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  vest, uniform and backpack
_uniform = _inventory select 0 select 0;
_vest = _inventory select 1 select 0;
_backpack = _inventory select 2 select 0;

_uniformItems = _inventory select 0 select 1;
_vestItems = _inventory select 1 select 1;
_backpackItems = _inventory select 2 select 1;

//add containers
_containers = [_uniform,_vest,_backpack];
{
	_item = _x;
	if!(_item isEqualTo "")then{
		_amount = 1;
		_index = [
			IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,
			IDC_RSCDISPLAYARSENAL_TAB_VEST,
			IDC_RSCDISPLAYARSENAL_TAB_BACKPACK
		] select _foreachindex;

		call {
			if ([_itemCounts select _index, _item] call jna_fnc_ItemCount == -1) exitWith {
				call ([
					{player forceAddUniform _uniform;},//todo remove
					{player addVest _vest;},
					{player addBackpack _backpack;}
				] select _foreachindex);
			};

			if ([_availableItems select _index, _item] call jna_fnc_ItemCount > 0) then {
				call ([
					{player forceAddUniform _uniform;},//todo remove
					{player addVest _vest;},
					{player addBackpack _backpack;}
				] select _foreachindex);
				[_arrayTaken,_index,_item,_amount] call _addToArray;
				[_availableItems,_index,_item,_amount] call _removeFromArray;
			} else {
				_oldItem = [_uniform_old,_vest_old,_backpack_old] select _foreachindex;
				if !(_oldItem isEqualTo "") then {
					call ([
						{player forceAddUniform _uniform_old;}, //todo remove
						{player addVest _vest_old;},
						{player addBackpack _backpack_old;}
					] select _foreachindex);
					_arrayReplaced = [_arrayReplaced,[_item,_oldItem]] call jna_fnc_addToArray;
					[_arrayTaken,_index,_oldItem,1] call _addToArray;
				} else {
					_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
				};
			};
		};
	};
} forEach _containers;

//add items to containers
{
	_container = call (_x select 0);
	_items = _x select 1;

	{
		_item = _x;
		_index = _item call jna_fnc_itemType;
		if(_index == -1)then{
			_amount = 1; // we will never know the ammo count in the magazines anymore :c
			_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
		} else {
			_amountAvailable = [_availableItems select _index, _item] call jna_fnc_ItemCount;
			if (_index == IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL) then {
				_amount = getNumber (configfile >> "CfgMagazines" >> _item >> "count");
				call {
					if ([_itemCounts select _index, _item] call jna_fnc_ItemCount == -1) exitWith {
						_container addMagazineAmmoCargo  [_item,1, _amount];
					};

					if(_amountAvailable < _amount) then {
						_amount = _amountAvailable;
						_arrayMissing = [_arrayMissing,[_item,(_amount - _amountAvailable)]] call jna_fnc_addToArray;
					};
					[_arrayTaken,_index,_item,_amount] call _addToArray;
					[_availableItems,_index,_item,_amount] call _removeFromArray;
					if (_amount>0) then {//prevent empty mags
						_container addMagazineAmmoCargo  [_item,1, _amount];
					};
				};
			} else {
				_amount = 1;
				call {
					if ([_itemCounts select _index, _item] call jna_fnc_ItemCount == -1) exitWith {
						_container addItemCargo [_item, 1];
					};

					if (_amountAvailable > _amount) then {
						_container addItemCargo [_item,_amount];
						[_arrayTaken,_index,_item,_amount] call _addToArray;
						[_availableItems,_index,_item,_amount] call _removeFromArray;
					} else {
						_arrayMissing = [_arrayMissing,[_item,_amount]] call jna_fnc_addToArray;
					};
				};
			};
		};
	} forEach _items;
} forEach [
	[{uniformContainer player},_uniformItems],
	[{vestContainer player},_vestItems],
	[{backpackContainer player},_backpackItems]
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  Update global
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_arrayAdd = [_arrayPlaced, _arrayTaken] call _subtractArrays; //remove items that where not added
_arrayRemove = [_arrayTaken, _arrayPlaced] call _subtractArrays;

[_arrayAdd] call jna_fnc_addItems_Arsanal;
_arrayRemove call jna_fnc_removeItems_Arsanal;

//create text for missing and replaced items
//we could use ingame names here but some items might not be ingame(disabled mod), but if you feel like it you can still add it.

_reportTotal = "";
_reportReplaced = "";
{
	_nameNew = _x select 0;
	_nameOld = _x select 1;
	_reportReplaced = _reportReplaced + _nameOld + " instead of " + _nameNew + "\n";
} forEach _arrayReplaced;

if!(_reportReplaced isEqualTo "")then{
	_reportTotal = ("I keep this items because i couldn't find the other ones:\n" + _reportReplaced+"\n");
};

_reportMissing = "";
{
	_name = _x select 0;
	_amount = _x select 1;
	_reportMissing = _reportMissing + _name + " (" + (str _amount) + "x)\n";
}forEach _arrayMissing;

if!(_reportMissing isEqualTo "")then{
	_reportTotal = (_reportTotal+"I couldn't find the following items:\n" + _reportMissing+"\n");
};

if!(_reportTotal isEqualTo "")then{
	titleText[_reportTotal, "PLAIN"];
};
