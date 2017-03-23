side_blue = independent;
guer_respawn = "respawn_guerrila";
guer_marker_colour = "ColorGUER";
guer_marker_type = "flag_FIA";
guer_flag_texture = "\A3\Data_F\Flags\Flag_FIA_CO.paa";

guer_rem_des = "O_Static_Designator_02_F";

guer_veh_truck = "I_G_Van_01_transport_F"; // default transport for squads
guer_veh_engineer = "B_G_Offroad_01_repair_F";
guer_veh_technical = "I_G_Offroad_01_armed_F";
guer_veh_quad = "I_G_Quadbike_01_F"; // default transport for snipers
guer_veh_offroad = "I_G_Offroad_01_F"; // default transport for teams

misVehicleBox = "C_Van_01_box_F";

guer_sol_AA = "I_G_Soldier_lite_F"; // AA trooper in player groups
guer_sol_AM = "I_G_Soldier_A_F"; // playable, player-only
guer_sol_AR = "I_G_Soldier_AR_F"; // playable
guer_sol_ENG = "I_G_engineer_F"; // playable
guer_sol_EXP = "I_G_Soldier_exp_F"; //
guer_sol_GL = "I_G_Soldier_GL_F"; //
guer_sol_LAT = "I_G_Soldier_LAT_F"; // playable
guer_sol_MED = "I_G_medic_F"; // playable
guer_sol_MRK = "I_G_Soldier_M_F"; // playable
guer_sol_OFF = "I_G_officer_F"; // playable, Petros
guer_sol_R_L = "I_G_Soldier_lite_F"; // driver/crew
guer_sol_RFL = "I_G_Soldier_F"; // playable
guer_sol_SL = "I_G_Soldier_SL_F"; //
guer_sol_SN = "I_G_Sharpshooter_F"; //
guer_sol_TL = "I_G_Soldier_TL_F"; // playable, player-only
guer_sol_UN = "I_G_Soldier_unarmed_F"; // mortar gunner

guer_POW = "I_G_Survivor_F"; //

guer_stat_mortar = "I_G_Mortar_01_F";
guer_stat_MGH = "I_HMG_01_high_F";
guer_stat_AT = "I_static_AT_F";
guer_stat_AA = "I_static_AA_F";

allStatMGs pushBackUnique guer_stat_MGH;
allStatATs pushBackUnique guer_stat_AT;
allStatAAs pushBackUnique guer_stat_AA;
allStatMortars pushBackUnique guer_stat_mortar;

guer_cfg_inf = (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry"); //unused

guer_grp_sniper = 		[guer_sol_MRK, guer_sol_SN]; // sniper team, Sgt, Cpl
guer_grp_sentry = 		[guer_sol_GL, guer_sol_RFL]; // Cpl, Pvt
guer_grp_AT = 			[guer_sol_SL, guer_sol_LAT]; // Cpl, Pvt
guer_grp_squad = 		[guer_sol_SL, guer_sol_GL, guer_sol_LAT, guer_sol_AR]; // Sgt, Cpl, Pvt, Pvt
guer_grp_team = 		[guer_sol_SL, guer_sol_GL, guer_sol_LAT, guer_sol_AR, guer_sol_MRK, guer_sol_MED, guer_sol_RFL, guer_sol_ENG]; // Sgt, Cpl, Pvt, Pvt, cpl, pvt, pvt, pvt

/*
These are the vehicles and statics that you can buy at HQ. Currently, the array requires a strict(!) order.
0-2: civilian vehicles
3-10: military vehicles and statics
*/
vfs = [
	"C_Offroad_01_F",
	"C_Van_01_transport_F",
	"C_Heli_Light_01_civil_F",
	"I_G_Quadbike_01_F",
	"I_G_Offroad_01_F",
	"I_G_Van_01_transport_F",
	"I_G_Offroad_01_armed_F",
	"I_HMG_01_high_F",
	"I_G_Mortar_01_F",
	"I_static_AT_F",
	"I_static_AA_F"
];

guer_flag = "Flag_FIA_F";

// ===== GEAR ===== \\
guer_vestAdv = "V_PlateCarrierSpec_mtp";
guer_AT = "launch_B_Titan_short_F";
guer_LAT = "launch_NLAW_F";
guer_AA = "launch_B_Titan_F";
guer_SNPR = "srifle_LRR_F";
guer_SNPR_camo = "srifle_LRR_F";
guer_GL_gren = "1Rnd_HE_Grenade_shell";
guer_grenSmoke = "SmokeShell";
guer_grenHE = "HandGrenade";

guer_FAK = "FirstAidKit";

guer_BP = "B_AssaultPack_blk";
guer_BP_AT = "B_AssaultPack_blk";

if (hayRHS) then {
	vfs = [
		"C_Offroad_01_F",
		"C_Van_01_transport_F",
		"RHS_Mi8amt_civilian",
		"B_G_Quadbike_01_F",
		"rhs_uaz_open_MSV_01",
		"rhs_gaz66o_msv",
		"B_G_Offroad_01_armed_F",
		"rhs_DSHKM_ins",
		"rhs_2b14_82mm_msv",
		"rhs_Metis_9k115_2_vdv",
		"RHS_ZU23_VDV",
		"rhs_bmd1_chdkz",
		"rhs_gaz66_r142_vdv"
	];
};

// Name of the faction
A3_Str_PLAYER = localize "STR_GENIDENT_RES";