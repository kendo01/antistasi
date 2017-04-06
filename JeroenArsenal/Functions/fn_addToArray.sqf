/*
    By: Jeroen Notenbomer

    add amounts of same name togetter
    also removes all empty names
    Use amount (-1) to set to unlimited

    Inputs:
        1: list         [["name1",amount1],["name2",amount2]]
        2: item         "name1" or ["name1",amount1] or [["name1",amount1],["name2",amount2]]

    Outputs
        list = Input1+Input2
*/

private ["_add","_list","_notFound","_addName","_addAmount","_listName","_listAmount"];

_list = +(_this select 0);
_add = _this select 1;

if(typeName _add isEqualTo "STRING")then{_add = [_add,1];};
if(typeName (_add select 0) isEqualTo "STRING")then{_add = [_add]};

_add = +_add;

//remove empty
{
    _listName = _x select 0;
    if(_listName isEqualTo "")then{
        _list set [_forEachIndex,-1];
    };

} forEach _list;
_list = _list - [-1];

{
    _notFound = true;
    _addName = _x select 0;
    _addAmount = _x select 1;

    if!(_addName isEqualTo "")then{//remove "" in add
        scopename "foundIt";
        {
            _listName = _x select 0;
            _listAmount = _x select 1;

            if(_listName isEqualTo _addName)then{
                //found now update amount
                if(_listAmount == -1|| _addAmount == -1)then{
                    _list set [_forEachIndex, [_listName,-1]];
                }else{
                    _list set [_forEachIndex, [_listName,(_listAmount + _addAmount)]];
                };

                _notFound = false;
                breakTo "foundIt";
            };

        }forEach _list;

        if(_notFound)then{
            //not found add new
            _list append [[_addName, _addAmount]];
        };
    };
}forEach _add;

_list = _list - [-1];
_list; //return
