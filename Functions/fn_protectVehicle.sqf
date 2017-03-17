params ["_vehicles"];

if !(typeName _vehicles == "ARRAY") then {_vehicles = [_vehicles]};

{
	_x allowDamage false;
	_x setDamage 0;
} forEach _vehicles;

sleep 5;

{
	_x allowDamage true;
} forEach _vehicles;