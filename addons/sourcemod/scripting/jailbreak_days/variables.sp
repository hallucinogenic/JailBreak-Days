// Jailbreak Days ConVars
ConVar g_CVAR_JailbreakDays_Royal_enable;
ConVar g_CVAR_JailbreakDays_WarDay_enable;
ConVar g_CVAR_JailbreakDays_HideAndSeek_enable;
ConVar g_CVAR_JailbreakDays_CatchTheDuck_enable;
ConVar g_CVAR_JailbreakDays_ZombieDay_enable;
ConVar g_CVAR_JailbreakDays_NaziDay_enable;
ConVar g_CVAR_JailbreakDays_Days_Time;
ConVar g_CVAR_JailbreakDays_Sounds_Enable;
ConVar g_CVAR_JailbreakDays_ZombieDay_skins;
ConVar g_CVAR_JailbreakDays_NaziDay_skins;
ConVar g_CVAR_JailbreakDays_FDCommand;
ConVar g_CVAR_JailbreakDays_ThirdPerson;
ConVar g_CVAR_JailbreakDays_Admins_EnableDays;
ConVar g_CVAR_JailbreakDays_WeaponRestrict;
ConVar g_CVAR_JailbreakDays_CatchTheDuck_Gravity;
ConVar g_CVAR_JailbreakDays_Parachute;
ConVar g_CVAR_JailbreakDays_CatchTheDuck_Speed;
ConVar g_CVAR_JailbreakDays_WarDay_AfterLR;
ConVar g_CVAR_JailbreakDays_RoyalDay_AfterLR;
ConVar g_CVAR_JailbreakDays_ZombieDay_AfterLR;
ConVar g_CVAR_JailbreakDays_HideAndSeek_AfterLR;
ConVar g_CVAR_JailbreakDays_CatchTheDuck_AfterLR;
ConVar g_CVAR_JailbreakDays_WeaponMenu;

// Variables to store ConVars Values
int g_JailbreakDays_Royal_enable;
int g_JailbreakDays_WarDay_enable;
int g_JailbreakDays_HideAndSeek_enable;
int g_JailbreakDays_CatchTheDuck_enable;
int g_JailbreakDays_ZombieDay_enable;
int g_JailbreakDays_NaziDay_enable;
int g_JailbreakDays_Days_Time;
int g_JailbreakDays_Sounds_Enable;
int g_JailbreakDays_ZombieDay_skins;
int g_JailbreakDays_NaziDay_skins;
int g_JailbreakDays_FDCommand;
int g_JailbreakDays_ThirdPerson;
int g_JailbreakDays_Admins_EnableDays;
int g_JailbreakDays_WeaponRestrict;
int g_JailbreakDays_Parachute;
int g_JailbreakDays_WarDay_AfterLR;
int g_JailbreakDays_RoyalDay_AfterLR;
int g_JailbreakDays_HideAndSeek_AfterLR;
int g_JailbreakDays_ZombieDay_AfterLR;
int g_JailbreakDays_CatchTheDuck_AfterLR;
int g_JailbreakDays_WeaponMenu;

float g_JailbreakDays_CatchTheDuck_gravity;
float g_JailbreakDays_CatchTheDuck_speed;

// Jailbreak Days Bools
bool g_royalday_handle;
bool g_warday_handle;
bool g_escondidas_handle;
bool g_apanhadas_handle;
bool g_zombie_handle;
bool g_nazi_handle;

// Friendly Fire's Convars
ConVar g_friendlyfire;
ConVar g_ff_damage_reduction_other;
ConVar g_ff_damage_reduction_grenade_self;
ConVar g_ff_damage_reduction_grenade;
ConVar g_ff_damage_reduction_bullets;


// Parachute ConVar
ConVar g_parachute_check;

bool g_restrict;

// AFK Manager ConVar
//ConVar g_AFKManager;

// Bool to check if a Warden is set;
bool IsFirstWarden;

// Bool to check if is the First Round;
bool IsFirstRound = true;

// Guns Weapon Names;

char g_PrimeWeapon_Name[256];
char g_PistolWeapon_Name[256];


// ThirdPerson's Booleans
bool ThirdPerson_Handle = true;
bool ThirdPerson[MAXPLAYERS + 1];

// Day's Music Boolean
bool Days_Music[MAXPLAYERS + 1];

// Configs and Downloads Paths
char Guns_Path[PLATFORM_MAX_PATH];
char Zombies_Path[PLATFORM_MAX_PATH];
char Nazi_Path[PLATFORM_MAX_PATH];
char DownloadsPath[PLATFORM_MAX_PATH];

// Cookies Handles;
Handle cookie_zombieskins = INVALID_HANDLE;
Handle cookie_naziskins = INVALID_HANDLE;
Handle cookie_daysmusics = INVALID_HANDLE;

// Strings to store client's cookies;
int g_ZombieSkins[MAXPLAYERS + 1];
int g_NaziSkins[MAXPLAYERS + 1];

// Variable to Set days
int num_days = 0;
int num_special_days = 0;

// ArrayList related to players skins;
ArrayList g_ZombieDaySkins;
ArrayList g_ZombieDaySkinsList;
ArrayList g_NaziDaySkins;
ArrayList g_NaziDaySkinsList;

// Codes to use directly for the user's radar;
#define HIDEHUD_RADAR 1 << 12
#define SHOWHUD_RADAR 1 >> 12

// Handles to set forwards for this plugin;
Handle g_forward_OnDayActivate = INVALID_HANDLE;