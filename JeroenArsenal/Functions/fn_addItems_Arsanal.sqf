{

	_index = _forEachIndex;

	{
		_item = _x select 0;
		_amount = _x select 1;

		[_index, _item, _amount] remoteExecCall ["jna_fnc_addItem_Arsanal"];
	} forEach _x;
}foreach _this;