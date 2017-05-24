if (!isServer and hasInterface) exitWith {};

AS_fnc_resetHCs = {
	hcArray = [];

	if ((!isnil "HC1") AND {!isNull HC1}) then {hcArray pushBackUnique HC1};
	if ((!isnil "HC2") AND {!isNull HC2}) then {hcArray pushBackUnique HC2};
	if ((!isnil "HC3") AND {!isNull HC3}) then {hcArray pushBackUnique HC3};

	HCciviles = 2;
	HCgarrisons = 2;
	HCattack = 2;

	if (count hcArray > 0) then {
	    HCattack = hcArray select 0;
	    (format ["Attack module assigned to %1", hcArray select 0]) remoteExec ["systemChat", Slowhand];
	    diag_log "Antistasi MP Server: Headless Client 1 detected";
	    if (count hcArray > 1) then {
	        HCciviles = hcArray select 1;
	        (format ["Civilian module assigned to %1", hcArray select 1]) remoteExec ["systemChat", Slowhand];
	        diag_log "Antistasi MP Server: Headless Client 2 detected";
	        if (count hcArray > 2) then {
	            HCgarrisons = hcArray select 2;
	            (format ["Garrison module assigned to %1", hcArray select 2]) remoteExec ["systemChat", Slowhand];
	            diag_log "Antistasi MP Server: Headless Client 3 detected";
	        };
	    };
	} else {
		"All modules assigned to the server" remoteExec ["systemChat", Slowhand];
	    diag_log "No headless clients detected.";
	};

	publicVariable "HCciviles";
	publicVariable "HCgarrisons";
	publicVariable "HCattack";
	publicVariable "hcArray";
};

while {true} do {
	call {
		if (objNull in hcArray) exitWith {
			[] call AS_fnc_resetHCs;
		};

		if (count hcArray != count (entities "HeadlessClient_F")) exitWith {
			[] call AS_fnc_resetHCs;
		};
	};

	sleep 30;
};