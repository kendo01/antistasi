activeACE = false;
activeACEhearing = false;
activeACEMedical = false;
if !(isNil "ace_common_settingFeedbackIcons") then {
	activeACE = true;
	unlockedItems = unlockedItems + ["ACE_EarPlugs","ACE_RangeCard","ACE_Clacker","ACE_M26_Clacker","ACE_DeadManSwitch","ACE_DefusalKit","ACE_MapTools","ACE_Flashlight_MX991","ACE_Sandbag_empty","ACE_wirecutter","ACE_RangeTable_82mm","ACE_SpareBarrel","ACE_EntrenchingTool","ACE_Cellphone","ACE_ConcertinaWireCoil","ACE_CableTie","ACE_SpottingScope","ACE_Tripod","ACE_Chemlight_HiWhite","ACE_Chemlight_HiRed"];
	unlockedBackpacks pushBackUnique "ACE_TacticalLadder_Pack";
	unlockedWeapons pushBackUnique "ACE_VMH3";
	unlockedMagazines = unlockedMagazines + ["ACE_HandFlare_White","ACE_HandFlare_Red"];
	genItems = genItems + ["ACE_Kestrel4500","ACE_ATragMX"];

	if ((activeJNA) AND (isServer)) then {
		[] spawn {
			waitUntil {sleep 1; !(isNil "placementDone")};
			[caja,
			[["ACE_VMH3",500]],
			[["ACE_HandFlare_White",200],["ACE_HandFlare_Red",200]],
			[["ACE_EarPlugs",100],["ACE_RangeCard",100],["ACE_Clacker",100],["ACE_M26_Clacker",100],["ACE_DeadManSwitch",100],["ACE_DefusalKit",100],["ACE_MapTools",100],["ACE_Flashlight_MX991",100],["ACE_Sandbag_empty",100],["ACE_wirecutter",100],["ACE_RangeTable_82mm",100],["ACE_SpareBarrel",100],["ACE_EntrenchingTool",100],["ACE_Cellphone",100],["ACE_ConcertinaWireCoil",100],["ACE_CableTie",100],["ACE_SpottingScope",100],["ACE_Tripod",100],["ACE_Chemlight_HiWhite",100],["ACE_Chemlight_HiRed",100]],
			[["ACE_TacticalLadder_Pack",100]]
			] call AS_fnc_addGearToCrate;
		};
	};

	if (isClass (configFile >> "CfgSounds" >> "ACE_EarRinging_Weak")) then {
		activeACEhearing = true;
	};
	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")) then {
		if (ace_medical_level != 0) then {
			activeACEMedical = true;
			if ((activeJNA) AND (isServer)) then {
				[] spawn {
					waitUntil {sleep 1; !(isNil "placementDone")};
					[caja,[],[],
					[["ACE_fieldDressing",100],["ACE_bloodIV_500",100],["ACE_bloodIV",100],["ACE_epinephrine",100],["ACE_morphine",100],["ACE_bodyBag",100],["ACE_elasticBandage",100],["ACE_quikclot",100],["ACE_bloodIV_250",100],["ACE_packingBandage",100],["ACE_personalAidKit",100],["ACE_plasmaIV",100],["ACE_plasmaIV_500",100],["ACE_plasmaIV_250",100],["ACE_salineIV",100],["ACE_salineIV_500",100],["ACE_salineIV_250",100],["ACE_surgicalKit",100],["ACE_tourniquet",100],["ACE_adenosine",100]],
					[]
					] call AS_fnc_addGearToCrate;
				};
			};
			unlockedItems = unlockedItems + ["ACE_fieldDressing","ACE_bloodIV_500","ACE_bloodIV","ACE_epinephrine","ACE_morphine","ACE_bodyBag","ACE_elasticBandage","ACE_quikclot","ACE_bloodIV_250","ACE_packingBandage","ACE_personalAidKit","ACE_plasmaIV","ACE_plasmaIV_500","ACE_plasmaIV_250","ACE_salineIV","ACE_salineIV_500","ACE_salineIV_250","ACE_surgicalKit","ACE_tourniquet","ACE_adenosine"];
		};
	};
};

diag_log "Init: ACE detection done.";