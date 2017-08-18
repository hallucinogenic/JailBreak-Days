#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <clientprefs>
#include <cstrike>
#include <cstrike_weapons>
#include <smlib>
#include <warden>
#include <hosties>
#include <restrict>
#include <emitsoundany>


#pragma newdecls required

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

// AFK Manager ConVar
//ConVar g_AFKManager;

// Bool to check if a Warden is set;
bool IsFirstWarden;

// Bool to check if is the First Round;
bool IsFirstRound = true;

// ThirdPerson's Booleans
bool ThirdPerson_Handle = true;
bool ThirdPerson[MAXPLAYERS + 1];

// Configs and Downloads Paths
char Guns_Path[PLATFORM_MAX_PATH];
char Zombies_Path[PLATFORM_MAX_PATH];
char DownloadsPath[PLATFORM_MAX_PATH];

// Cookies Handles;
Handle cookie_zombieskins = INVALID_HANDLE;

// Strings to store client's cookies;
int g_ZombieSkins[MAXPLAYERS + 1];

// Variable to Set days
int num_days = 0;
int num_special_days = 0;

ArrayList g_ZombieDaySkins;
ArrayList g_ZombieDaySkinsList;

#define HIDEHUD_RADAR 1 << 12
#define SHOWHUD_RADAR 1 >> 12



// Includes of Jailbreak Days Functions
#include "jailbreak_days/variables.sp"
#include "jailbreak_days/royal.sp"
#include "jailbreak_days/warday.sp"
#include "jailbreak_days/escondidas.sp"
#include "jailbreak_days/apanhadas.sp"
#include "jailbreak_days/zombieday.sp"
#include "jailbreak_days/naziday.sp"
#include "jailbreak_days/thirdperson.sp"

public Plugin myinfo = 
{
	name = "Jailbreak Days",
	author = "Hallucinogenic Troll",
	description = "Some bonus that can be given to an warden",
	version = "1.0",
	url = "http://PTFun.net/newsite/"
};

public void OnPluginStart()
{	
	
	g_ZombieDaySkins = new ArrayList(PLATFORM_MAX_PATH);
	g_ZombieDaySkinsList = new ArrayList(256);
	
	// Days Togglers ConVars
	g_royalday_enable = CreateConVar("sm_royalday_enable", "1", "Enables the Jailbreak Day named Royal Day", _, true, 0.0, true, 1.0);
	g_warday_enable = CreateConVar("sm_warday_enable", "1", "Enables the Jailbreak Day named War Day", _, true, 0.0, true, 1.0);
	g_escondidas_enable = CreateConVar("sm_escondidas_enable", "1", "Enables the Jailbreak Day named Escondidas", _, true, 0.0, true, 1.0);
	g_apanhadas_enable = CreateConVar("sm_apanhadas_enable", "1", "Enables the Jailbreak Day named Apanhadas", _, true, 0.0, true, 1.0);
	g_zombie_enable = CreateConVar("sm_zombieday_enable", "1", "Enables the Jailbreak Day named Zombie Day", _, true, 0.0, true, 1.0);
	g_nazi_enable = CreateConVar("sm_naziday_enable", "1", "Enables the Jailbreak Day named Nazi Day", _, true, 0.0, true, 1.0);
	
	// Days Customization Cvars
	g_days_time = CreateConVar("sm_days_time", "2", "How many rounds between days", _, true, 0.0, false);
	
	// Gravity ConVar
	
	g_gravity = FindConVar("sv_gravity");
	
	// Parachute ConVar
	
	g_parachute_check = FindConVar("sm_parachute_enabled");
	
	// AFK Manager ConVar
	//g_AFKManager = FindConVar("sm_afk_enable");
	
	// Friendly Fire ConVars
	
	g_friendlyfire = FindConVar("mp_friendlyfire");
	g_ff_damage_reduction_other = FindConVar("ff_damage_reduction_other");
	g_ff_damage_reduction_grenade_self = FindConVar("ff_damage_reduction_grenade_self");
	g_ff_damage_reduction_grenade = FindConVar("ff_damage_reduction_grenade");
	g_ff_damage_reduction_bullets = FindConVar("ff_damage_reduction_bullets");
	
	
	// Day's Commands
	RegConsoleCmd("sm_dias", Menu_Dias, "Days Menu");
	RegConsoleCmd("sm_royal", Menu_Royal, "Royal Day Menu");
	RegConsoleCmd("sm_warday", Menu_Warday, "War Day Menu");
	RegConsoleCmd("sm_escondidas", Menu_Escondidas, "Escondidas Menu");
	RegConsoleCmd("sm_apanhadas", Menu_Apanhadas, "Apanhadas Menu");
	RegConsoleCmd("sm_nazi", Menu_Nazi, "Apanhadas Menu");
	
	RegConsoleCmd("sm_zombie", Menu_ZombieDay, "Zombie Day Menu");
	RegConsoleCmd("sm_zombieday", Menu_ZombieDay, "Zombie Day Menu");
	
	RegConsoleCmd("sm_fd", Command_Freeday, "Freeday");
	
	// Skins Commands
	RegConsoleCmd("sm_zskins", Menu_ZombieDay_Skins, "Zombie Skins Menu");
	
	// Third Person Commands
	RegConsoleCmd("sm_tp", Command_ThirdPerson, "Third Person Command");
	
	cookie_zombieskins = RegClientCookie("Zombie Skins", "Jailbreak Days Zombie Skins", CookieAccess_Public);
	
	// Events to Disable All the Days
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	
	// Gun's Menu CFG Path
	BuildPath(Path_SM, Guns_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/guns.cfg");
	
	// Zombie Skins Menu CFG Path
	BuildPath(Path_SM, Zombies_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/zombie_skins.cfg");
	
	BuildPath(Path_SM, DownloadsPath, PLATFORM_MAX_PATH, "configs/jailbreak_days/downloads.txt");
	
	AutoExecConfig(true, "sm_jailbreak_days");
}

public void OnClientPostAdminCheck(int client)
{	
	g_ZombieSkins[client] = 0;
	CreateTimer(1.0, Timer_CookieCheck, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_CookieCheck(Handle timer, int client)
{
	if (IsClientInGame(client))
	{
		if (AreClientCookiesCached(client))
		{
			char cookiebuffer[512];
			GetClientCookie(client, cookie_zombieskins, cookiebuffer, sizeof(cookiebuffer));
			g_ZombieSkins[client] = StringToInt(cookiebuffer);
		}
	}
}

public void OnConfigsExecuted()
{
	Downloads();
	Precache();
}

public void OnMapStart()
{
	NaziDay_OnMapStart();
	
	PrecacheModel("models/player/custom_player/legacy/ctm_sas.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix.mdl");
}

public void warden_OnWardenCreated(int client)
{
	if(GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		if(!IsFirstWarden)
		{
			FakeClientCommandEx(client, "sm_dias");
			IsFirstWarden = true;
		}
	}
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(ThirdPerson[client])
	{
		ClientCommand(client, "firstperson");
	}
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast) 
{
	IsFirstWarden = false;
	g_royalday_handle = false;
	g_warday_handle = false;
	g_escondidas_handle = false;
	g_apanhadas_handle = false;
	g_zombie_handle = false;
	g_nazi_handle = false;
	
	if(GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		if(IsFirstRound)
		{
			PrintToChatAll("[\x04PT'Fun\x01] Primeira Ronda - \x0BFreeday Normal\x01!");
			IsFirstRound = false;
		}
		else
		{
			if(num_special_days == GetConVarInt(g_days_time))
			{
				num_special_days = 0;
			}
			
			if(num_days == 1)
			{
				num_days = 0;
			}
			
			num_special_days+=1;
			num_days+=1;
			CreateTimer(1.0, Timer_PrintRounds, _, TIMER_FLAG_NO_MAPCHANGE);
		}
		
	}
}

public Action Timer_PrintRounds(Handle timer)
{
	if(GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		if((GetConVarInt(g_days_time) - num_special_days) == 0)
		{
			PrintToChatAll("[\x04PT'Fun\x01] Nesta ronda já podem ativar um dia especial!");
		}
		else if ((GetConVarInt(g_days_time) - num_special_days) == 1)
		{
			PrintToChatAll("[\x04PT'Fun\x01] Falta \x0E1 ronda\x01 para ativar um dia especial!");
		}
		else
		{
			PrintToChatAll("[\x04PT'Fun\x01] Faltam \x0E%d rondas\x01 para ativar um dia especial!", (GetConVarInt(g_days_time) - num_special_days));
		}
	}
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) 
{
	if(g_warday_handle)
	{
		g_warday_handle = false;
	}
	if(g_zombie_handle)
	{
		DesativarZombie();
		g_zombie_handle = false;
	}
	if(g_nazi_handle)
	{
		g_nazi_handle = false;
	}
}

stock bool IsValidClient(int client)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client))
	{
		return true;
	}
	
	return false;
}

public void DisarmPlayerWeapons(int client)
{
	for(int i = 0; i < 5; i++)
	{
		int weapon = -1;
		while((weapon = GetPlayerWeaponSlot(client, i)) != -1)
		{
			if(IsValidEntity(weapon))
			{
				RemovePlayerItem(client, weapon);
			}
		}
	}
}

public int OnAvailableLR (int Announced)
{
	if(g_royalday_handle)
	{
		DesativarRoyalDay();
	}
	if(g_zombie_handle)
	{
		DesativarZombie();
	}
	if(g_escondidas_handle)
	{
		DesativarEscondidas();
	}
	if(g_apanhadas_handle)
	{
		DesativarApanhadas();
	}
	if(g_warday_handle)
	{
		PrintToChatAll("[\x04PT'Fun\x01] O Warday Continua!");
	}
}

stock void ShowNewHud(int client, int red, int green, int blue, char[] message) 
{ 
	SetHudTextParams(0.35, 0.125, 5.0, red, green, blue, 255, 0, 0.25, 1.5, 0.5);
	ShowHudText(client, 5, message);
}

public int Dias_Menu_Handler(Menu menu_dias, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_dias.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, DIAS1))
		{
			Menu_Royal(param1, param2);
		}
		if(StrEqual(info, DIAS2))
		{
			Menu_Warday(param1, param2);
		}
		if(StrEqual(info, DIAS3))
		{
			Menu_Escondidas(param1, param2);
		}
		if(StrEqual(info, DIAS4))
		{
			Menu_Apanhadas(param1, param2);
		}
		if(StrEqual(info, DIAS5))
		{
			Menu_ZombieDay(param1, param2);
		}
		if(StrEqual(info, DIAS6))
		{
			Menu_Nazi(param1, param2);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_dias;
	}
}

public Action Menu_Dias(int client, int args)
{
	if(GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
		{
			Menu menu_dias = new Menu(Dias_Menu_Handler)
			menu_dias.SetTitle("Menu dos Dias da PT'Fun");
			menu_dias.AddItem("DIAS1", "Royal Day", num_special_days == GetConVarInt(g_days_time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS2", "War Day", num_special_days == GetConVarInt(g_days_time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS3", "Escondidas", num_special_days == GetConVarInt(g_days_time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS4", "Apanhadas", num_special_days == GetConVarInt(g_days_time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS5", "Zombie", num_days == 1?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS6", "Nazi", num_special_days == GetConVarInt(g_days_time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.ExitButton = true;
			menu_dias.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04PT'Fun\x01] Necessitas de ser \x0BWarden\x01 ou \x07Admin\x01 para usar este comando!");
		}
	}
	else
	{
		PrintToChat(client, "[\x04PT'Fun\x01] Este comando encontra-se \x07desativado\x01 durante a ronda de \x0BWarmup\x01!");
	}
}

void Precache()
{
	// Precache Zombie Day MDL Files;
	ZombieDay_Precache();
}

void Downloads()
{
	char line[192];
	
	Handle file = OpenFile(DownloadsPath, "r");
	
	if(file != INVALID_HANDLE)
	{
		while (!IsEndOfFile(file))
		{
			if (!ReadFileLine(file, line, sizeof(line)))
			{
				break;
			}
			
			TrimString(line);
			if(strlen(line) > 0 && FileExists(line))
			{
				AddFileToDownloadsTable(line);
			}
		}

		CloseHandle(file);
	}
	else
	{
		LogError("[PT'Fun] no file found for downloads (configs/jailbreak_days/downloads.txt)");
	}
}

public bool HasPlayerFlags(int client, char flags[40])
{
	if(StrContains(flags, "a") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_RESERVATION))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "b") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_GENERIC))
		{
			return true;
		}
	}
	else if(StrContains(flags, "c") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_KICK))
		{
			return true;
		}
	}
	else if(StrContains(flags, "d") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_BAN))
		{
			return true;
		}
	}
	else if(StrContains(flags, "e") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_UNBAN))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "f") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_SLAY))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "g") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CHANGEMAP))
		{
			return true;
		}
	}
	else if(StrContains(flags, "h") != -1)
	{
		if(Client_HasAdminFlags(client, 128))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "i") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CONFIG))
		{
			return true;
		}
	}
	else if(StrContains(flags, "j") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CHAT))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "k") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_VOTE))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "l") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_PASSWORD))
		{
			return true;
		}
	}
	else if(StrContains(flags, "m") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_RCON))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "n") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CHEATS))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "z") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_ROOT))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "o") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM1))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "p") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM2))
		{
			return true;
		}
	}
	else if(StrContains(flags, "q") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM3))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "r") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM4))
		{
			return true;
		}
	}			
	else if(StrContains(flags, "s") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM5))
		{
			return true;
		}
	}			
	else if(StrContains(flags, "t") != -1)
	{
		if(Client_HasAdminFlags(client, ADMFLAG_CUSTOM6))
		{
			return true;
		}
	}
	
	return false;
}