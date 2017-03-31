private ["_type","_text"];

_type = typeOf player;
_text = "";
switch (_type) do {
	case guer_sol_OFF: {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.4]; _text = "Officer role.\n\nOfficers have bonuses on both silent sneaking and camouflage, but cannot carry too much items"};
	case guer_sol_RFL:  {player setUnitTrait ["audibleCoef",0.8]; player setUnitTrait ["loadCoef",1.2]; _text = "Rifleman role.\n\nRiflemen are more suitable to silent sneak but have less carryng capacity"};
	case guer_sol_LAT: {player setUnitTrait ["camouflageCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _text = "AT Man role.\n\nAT men have a slight bonus on carry capacity, but are easy to spot"};
	case guer_sol_AR: {player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.8]; _text = "Autorifleman role.\n\nAutoriflemen have a slight bonus on carry capacity, but make too much noise when they move"};
	case guer_sol_ENG:  {_text = "Engineer role.\n\nEngineers do not have any bonus or penalties, but have the ability to use Repair Kits for vehicle repair"};
	case guer_sol_MED:  {_text = "Medic role.\n\nMedics do not have any bonus or penalties, but have the ability to use Medikits for full health restoration"};
	case guer_sol_AM:  {player setUnitTrait ["camouflageCoef",1.2]; player setUnitTrait ["audibleCoef",1.2]; player setUnitTrait ["loadCoef",0.6]; _text = "Ammo bearer role.\n\nAmmo bearers have a great strenght but are easy to spot and easy to hear."};
	case guer_sol_MRK:  {player setUnitTrait ["camouflageCoef",0.8]; player setUnitTrait ["loadCoef",1.2]; _text = "Marksman role.\n\nMarksmen know well how to hide, but have less carry capacity."};
	case guer_sol_TL: {_text = "Team leader role.\n\nTeam leaders are scapegoats for the commander."};
};

if (isMultiPlayer) then {
	sleep 5;
	hint format ["You have selected %1",_text];
};