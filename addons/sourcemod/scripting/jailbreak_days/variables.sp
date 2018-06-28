#define	DIAS1	"DIAS1"
#define	DIAS2	"DIAS2"
#define	DIAS3	"DIAS3"
#define	DIAS4	"DIAS4"
#define	DIAS5	"DIAS5"
#define	DIAS6	"DIAS6"


// Jailbreak Days ConVars
ConVar g_royalday_enable;
ConVar g_warday_enable;
ConVar g_escondidas_enable;
ConVar g_apanhadas_enable;
ConVar g_zombie_enable;
ConVar g_nazi_enable;
ConVar g_days_time;

// ConVar to set if the Warden/Admin wants to set a special day the next round;
ConVar g_fd_command_enable;

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

// Gravity ConVar
ConVar g_gravity;

// Parachute ConVar
ConVar g_parachute_check;

bool g_restrict;

// AFK Manager ConVar
//ConVar g_AFKManager;

// Bool to check if a Warden is set;
bool IsFirstWarden;

// Bool to check if is the First Round;
bool IsFirstRound = true;

// ThirdPerson's Booleans
bool ThirdPerson_Handle = true;
bool ThirdPerson[MAXPLAYERS + 1];

// Day's Music Boolean
bool Days_Music[MAXPLAYERS + 1];

// Configs and Downloads Paths
char Guns_Path[PLATFORM_MAX_PATH];
char Zombies_Path[PLATFORM_MAX_PATH];
char DownloadsPath[PLATFORM_MAX_PATH];

// Cookies Handles;
Handle cookie_zombieskins = INVALID_HANDLE;
Handle cookie_daysmusics = INVALID_HANDLE;

// Strings to store client's cookies;
int g_ZombieSkins[MAXPLAYERS + 1];

// Variable to Set days
int num_days = 0;
int num_special_days = 0;

// ArrayList related to players skins;
ArrayList g_ZombieDaySkins;
ArrayList g_ZombieDaySkinsList;

// Codes to use directly for the user's radar;
#define HIDEHUD_RADAR 1 << 12
#define SHOWHUD_RADAR 1 >> 12

// Handles to set forwards for this plugin;
Handle g_forward_OnDayActivate = INVALID_HANDLE;