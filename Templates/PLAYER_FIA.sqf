side_blue = west;
guer_respawn = "respawn_west";
guer_marker_colour = "ColorWEST";
guer_marker_type = "flag_FIA";
guer_flag_texture = "\A3\Data_F\Flags\Flag_FIA_CO.paa";

guer_rem_des = "B_Static_Designator_01_F";

guer_veh_truck = "B_G_Van_01_transport_F"; // default transport for squads
guer_veh_engineer = "B_G_Offroad_01_repair_F";
guer_veh_technical = "B_G_Offroad_01_armed_F";
guer_veh_quad = "B_G_Quadbike_01_F"; // default transport for snipers
guer_veh_offroad = "B_G_Offroad_01_F"; // default transport for teams

guer_sol_AA = "B_G_Soldier_lite_F"; // AA trooper in player groups
guer_sol_AM = "B_G_Soldier_A_F"; // playable, player-only
guer_sol_AR = "B_G_Soldier_AR_F"; // playable
guer_sol_ENG = "B_G_engineer_F"; // playable
guer_sol_EXP = "B_G_Soldier_exp_F"; //
guer_sol_GL = "B_G_Soldier_GL_F"; //
guer_sol_LAT = "B_G_Soldier_LAT_F"; // playable
guer_sol_MED = "B_G_medic_F"; // playable
guer_sol_MRK = "B_G_Soldier_M_F"; // playable
guer_sol_OFF = "B_G_officer_F"; // playable, Petros
guer_sol_R_L = "B_G_Soldier_lite_F"; // driver/crew
guer_sol_RFL = "B_G_Soldier_F"; // playable
guer_sol_SL = "B_G_Soldier_SL_F"; //
guer_sol_SN = "B_G_Sharpshooter_F"; //
guer_sol_TL = "B_G_Soldier_TL_F"; // playable, player-only
guer_sol_UN = "B_G_Soldier_unarmed_F"; // mortar gunner

guer_POW = "B_G_Survivor_F"; //

guer_stat_mortar = "B_G_Mortar_01_F";
guer_stat_MGH = "B_HMG_01_high_F";
guer_stat_AT = "B_static_AT_F";
guer_stat_AA = "B_static_AA_F";

allStatMGs pushBackUnique guer_stat_MGH;
allStatATs pushBackUnique guer_stat_AT;
allStatAAs pushBackUnique guer_stat_AA;
allStatMortars pushBackUnique guer_stat_mortar;

guer_cfg_inf = (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry");

guer_grp_sniper = "IRG_SniperTeam_M";
guer_grp_sentry = "IRG_InfSentry";
guer_grp_AT = "IRG_InfTeam_AT";
guer_grp_squad = "IRG_InfSquad";
guer_grp_team = "IRG_InfTeam";

/*
These are the vehicles and statics that you can buy at HQ. Currently, the array requires a strict(!) order.
0-2: civilian vehicles
3-10: military vehicles and statics
*/
vfs = [
	"C_Offroad_01_F",
	"C_Van_01_transport_F",
	"C_Heli_Light_01_civil_F",
	"B_G_Quadbike_01_F",
	"B_G_Offroad_01_F",
	"B_G_Van_01_transport_F",
	"B_G_Offroad_01_armed_F",
	"B_HMG_01_high_F",
	"B_G_Mortar_01_F",
	"B_static_AT_F",
	"B_static_AA_F"
];

guer_flag = "Flag_FIA_F";

// ===== GEAR ===== \\
guer_vestAdv = "V_PlateCarrierIAGL_oli";
guer_AT = "launch_I_Titan_short_F";
guer_LAT = "launch_NLAW_F";
guer_AA = "launch_I_Titan_F";
guer_SNPR = "srifle_GM6_F";
guer_SNPR_camo = "srifle_GM6_SOS_F";
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
A3_Str_PLAYER = localize "STR_GENIDENT_FIA";