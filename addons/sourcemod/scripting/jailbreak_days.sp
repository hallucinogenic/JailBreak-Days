#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <clientprefs>
#include <cstrike>
#include <emitsoundany>

#undef REQUIRE_PLUGIN
#include <cstrike_weapons>
#include <warden>
#include <hosties>
#include <restrict>

// Just to make sure that the code is pretty :3
#pragma semicolon 1
#pragma newdecls required


// Includes of Jailbreak Days Functions
#include "jailbreak_days/variables.sp"
#include "jailbreak_days/globals.sp"
#include "jailbreak_days/natives.sp"
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
	
	// Days Customization ConVar
	g_days_time = CreateConVar("sm_days_time", "2", "How many rounds between days", _, true, 0.0, false);
	
	// ConVar to set if the Warden/Admin wants to set a special day the next round;
	g_fd_command_enable = CreateConVar("sm_fd_command_enable", "1", "Enables the !fd command, to use in case that the day goes wrong (then you can repeat in the next round)", _, true, 0.0, true, 1.0);
	
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
	
	// Command to use in case that the day goes wrong and to try again in the next round;
	RegConsoleCmd("sm_fd", Command_Freeday, "Freeday");
	
	RegConsoleCmd("sm_dhelp", Command_DayHelp, "Day's Help Menu");
	
	// Skins Commands
	RegConsoleCmd("sm_zskins", Menu_ZombieDay_Skins, "Zombie Skins Menu");
	
	// Third Person Commands
	RegConsoleCmd("sm_tp", Command_ThirdPerson, "Third Person Command");
	
	cookie_zombieskins = RegClientCookie("zombie_skins", "Jailbreak Days Zombie Skins", CookieAccess_Public);
	cookie_daysmusics = RegClientCookie("days_musics", "JailBreak Days Musics", CookieAccess_Public);
	
	// Events to Disable All the Days
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	
	// Gun's Menu CFG Path
	BuildPath(Path_SM, Guns_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/guns.cfg");
	
	// Zombie Skins Menu CFG Path
	BuildPath(Path_SM, Zombies_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/zombie_skins.cfg");
	
	// Downloads Path (It will everything you want to the downloads table);
	BuildPath(Path_SM, DownloadsPath, PLATFORM_MAX_PATH, "configs/jailbreak_days/downloads.txt");
	
	// Creates the forwards, to when a day has been enabled;
	g_forward_OnDayActivate = CreateGlobalForward("JailBreakDays_OnDayActivate", ET_Ignore, Param_Cell);
	
	AutoExecConfig(true, "main", "jailbreak_days");
}

public void OnClientPostAdminCheck(int client)
{	
	g_ZombieSkins[client] = 0;
	Days_Music[client] = true;
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
			
			GetClientCookie(client, cookie_daysmusics, cookiebuffer, sizeof(cookiebuffer));
			if(StrEqual(cookiebuffer, "0"))
			{
				Days_Music[client] = false;
			}
			else
			{
				Days_Music[client] = true;
			}			
		}
	}
}

public void OnMapStart()
{
	Downloads();
	Precache();
	NaziDay_OnMapStart();
	
	PrecacheModel("models/player/custom_player/legacy/ctm_sas.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix.mdl");
	
	PrecacheSoundAny("misc/ptfun/jailbreak/apanhadas/music1.mp3", true);
	PrecacheSoundAny("misc/ptfun/jailbreak/zombieday/v2/music1.mp3", true);
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
			PrintToChatAll("[\x04Jailbreak Days\x01] Primeira Ronda - \x0BFreeday Normal\x01!");
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
			PrintToChatAll("[\x04Jailbreak Days\x01] Nesta ronda já podem ativar um dia especial!");
		}
		else if ((GetConVarInt(g_days_time) - num_special_days) == 1)
		{
			PrintToChatAll("[\x04Jailbreak Days\x01] Falta \x0E1 ronda\x01 para ativar um dia especial!");
		}
		else
		{
			PrintToChatAll("[\x04Jailbreak Days\x01] Faltam \x0E%d rondas\x01 para ativar um dia especial!", (GetConVarInt(g_days_time) - num_special_days));
		}
	}
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) 
{
	if(g_warday_handle)
	{
		g_warday_handle = false;
	}
	if(g_royalday_handle)
	{
		DesativarRoyalDay();
		g_royalday_handle = false;
	}
	if(g_escondidas_handle)
	{
		DesativarEscondidas();
		g_escondidas_handle = false;
	}
	if(g_apanhadas_handle)
	{
		DesativarApanhadas();
		g_apanhadas_handle = false;
	}
	if(g_zombie_handle)
	{
		DesativarZombie();
		g_zombie_handle = false;
	}
	if(g_nazi_handle)
	{
		DesativarNazi();
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

public int OnAvailableLR(int Announced)
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
		PrintToChatAll("[\x04Jailbreak Days\x01] O Warday Continua!");
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
			Menu menu_dias = new Menu(Dias_Menu_Handler);
			menu_dias.SetTitle("Menu dos Dias da PT'Fun");
			menu_dias.AddItem("DIAS1", "Royal Day", (num_special_days == GetConVarInt(g_days_time))?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS2", "War Day", (num_special_days == GetConVarInt(g_days_time))?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS3", "Escondidas", (num_special_days == GetConVarInt(g_days_time))?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS4", "Apanhadas", (num_special_days == GetConVarInt(g_days_time))?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS5", "Zombie", (num_days == 1)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.AddItem("DIAS6", "Nazi",( num_special_days == GetConVarInt(g_days_time))?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu_dias.ExitButton = true;
			menu_dias.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Necessitas de ser \x0BWarden\x01 ou \x07Admin\x01 para usar este comando!");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este comando encontra-se \x07desativado\x01 durante a ronda de \x0BWarmup\x01!");
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

public Action Command_DayHelp(int client, int args)
{
	Menu menu = new Menu(Day_HelpMenu_Handler);
	menu.SetTitle("Menu de Ajuda dos Dias de Jailbreak");
	menu.AddItem("1", "Menu dos Dias de Warden", (((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)) == true)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("2", "Escolher as Skins de Zombie Day");
	menu.AddItem("3", "Ativar/Desativar a primeira pessoa");
	menu.AddItem("4", "Ativar/Desativar as musicas dos dias");
	menu.ExitButton = true;
	menu.Display(client, 20);
}

public int Day_HelpMenu_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, "1"))
		{
			Menu_Dias(param1, param2);
		}
		if(StrEqual(info, "2"))
		{
			Menu_ZombieDay_Skins(param1, param2);
		}
		if(StrEqual(info, "3"))
		{
			Command_ThirdPerson(param1, param2);
		}
		if(StrEqual(info, "4"))
		{
			Command_DaysMusic(param1, param2);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}