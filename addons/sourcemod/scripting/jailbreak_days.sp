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
	name = "[CS:GO] Jailbreak Days",
	author = "Hallucinogenic Troll",
	description = "Gives some days to let an warden choose in Jailbreak",
	version = "1.1",
	url = "http://HallucinogenicTrollConfigs.com/"
};

public void OnPluginStart()
{		
	// Arrays to store Days;
	g_ZombieDaySkins = new ArrayList(PLATFORM_MAX_PATH);
	g_ZombieDaySkinsList = new ArrayList(256);
	g_NaziDaySkins = new ArrayList(PLATFORM_MAX_PATH);
	g_NaziDaySkinsList = new ArrayList(256);
	
	
	// Royal Day ConVars
	g_CVAR_JailbreakDays_Royal_enable = CreateConVar("jailbreak_days_royalday", "1", "Enables the Jailbreak Day named Royal Day", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_RoyalDay_AfterLR = CreateConVar("jailbreak_days_royalday_afterlr", "1", "It let's continue Royal Day after Last Request being activated", _, true, 0.0, true, 1.0);

	// War Day ConVars
	g_CVAR_JailbreakDays_WarDay_enable = CreateConVar("jailbreak_days_warday", "1", "Enables the Jailbreak Day named War Day", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_WarDay_AfterLR = CreateConVar("jailbreak_days_warday_afterlr", "1", "It let's continue War Day after Last Request being activated", _, true, 0.0, true, 1.0);
	
	// Hide and Seek ConVars
	g_CVAR_JailbreakDays_HideAndSeek_enable = CreateConVar("jailbreak_days_hideandseek", "1", "Enables the Jailbreak Day named Hide and Seek", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_HideAndSeek_AfterLR = CreateConVar("jailbreak_days_hideandseek_afterlr", "1", "It let's continue Hide and Seek Day after Last Request being activated", _, true, 0.0, true, 1.0);

	
	// Catch The Duck ConVars
	g_CVAR_JailbreakDays_CatchTheDuck_enable = CreateConVar("jailbreak_days_catchtheduck", "1", "Enables the Jailbreak Day named Catch The Duck", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_CatchTheDuck_AfterLR = CreateConVar("jailbreak_days_catchtheduck_afterlr", "1", "It let's continue Catch the Duck Day after Last Request being activated", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_CatchTheDuck_Gravity = CreateConVar("jailbreak_days_catchtheduck_gravity", "0.3", "Gravity of every player when Catch The Duck Day is enabled (0.0 doesn't change, 1.0 change to default gravity)", _, true, 0.0, false);
	g_CVAR_JailbreakDays_CatchTheDuck_Speed = CreateConVar("jailbreak_days_catchtheduck_speed", "1.0", "Speed of every player when Catch The Duck is enabled (0.0 doesn't change, 1.0 change to default speed)", _, true, 0.0, false);
	
	// Zombie Day ConVars
	g_CVAR_JailbreakDays_ZombieDay_enable = CreateConVar("jailbreak_days_zombieday", "1", "Enables the Jailbreak Day named Zombie Day", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_ZombieDay_AfterLR = CreateConVar("jailbreak_days_zombieday_afterlr", "1", "It let's continue Zombie Day after Last Request being activated", _, true, 0.0, true, 1.0);
	g_CVAR_JailbreakDays_ZombieDay_skins = CreateConVar("jailbreak_days_zombieday_skins", "1", "Enable Skins on Zombie Day (if enabled)", _, true, 0.0, true, 1.0);
	
	// Nazi Day ConVars
	g_CVAR_JailbreakDays_NaziDay_enable = CreateConVar("jailbreak_days_naziday", "1", "Enables the Jailbreak Day named Nazi Day", _, true, 0.0, true, 1.0);

	// Enable Admin's Permissions to enable/disable days
	g_CVAR_JailbreakDays_Admins_EnableDays = CreateConVar("jailbreak_days_admins_enabledays", "1", "It gives admins (with Generic flag) to (des)activate days", _, true, 0.0, true, 1.0);

	// Enable Weapon Restrictions by Weapon Restrict Plugin
	g_CVAR_JailbreakDays_WeaponRestrict = CreateConVar("jailbreak_days_weaponrestrict", "1", "It restricts Weapons on certain days (if 1, you need the Weapon Restrict Plugin)", _, true, 0.0, true, 1.0);

	// Enable Parachute Permissions
	g_CVAR_JailbreakDays_Parachute = CreateConVar("jailbreak_days_parachute", "1", "It disables the parachute plugin in certain days (you need the parachute plugin)", _, true, 0.0, true, 1.0);

	// Map Musics ConVar
	g_CVAR_JailbreakDays_Sounds_Enable = CreateConVar("jailbreak_days_sounds", "1", "Enables the Music Sounds for every Day", _, true, 0.0, true, 1.0);
	
	// Days Customization ConVar
	g_CVAR_JailbreakDays_Days_Time = CreateConVar("jailbreak_days_time", "2", "How many rounds between days", _, true, 0.0, false);
	
	// Set if the Warden/Admin wants to set a special day the next round;
	g_CVAR_JailbreakDays_FDCommand= CreateConVar("jailbreak_days_fdcommand", "1", "Enables the Freeday command (sm_fd), to use in case that the day goes wrong (then you can repeat in the next round)", _, true, 0.0, true, 1.0);
	
	// Enables ThirdPerson
	g_CVAR_JailbreakDays_ThirdPerson = CreateConVar("jailbreak_days_thirperson", "1", "It enables the ThirdPerson Toggle Command (sm_tp) implemented in the plugin (by enabling you have a better experience for certain days)", _, true, 0.0, true, 1.0);

	// Types of Weapons on Gun Menu
	g_CVAR_JailbreakDays_WeaponMenu = CreateConVar("jailbreak_days_weaponmenu", "3", "Type of menus with weapons (0 = No menu, Knife only, 1 = Only Primary guns, 2 = Only Pistol Guns, 3 = Both Primary and Pistol Guns)", true, 0.0, true, 3.0);
	
	// Parachute ConVar
	g_parachute_check = FindConVar("sm_parachute_enabled");
	
	
	// Friendly Fire ConVars
	g_friendlyfire = FindConVar("mp_friendlyfire");
	g_ff_damage_reduction_other = FindConVar("ff_damage_reduction_other");
	g_ff_damage_reduction_grenade_self = FindConVar("ff_damage_reduction_grenade_self");
	g_ff_damage_reduction_grenade = FindConVar("ff_damage_reduction_grenade");
	g_ff_damage_reduction_bullets = FindConVar("ff_damage_reduction_bullets");
	
	
	// Day's Commands
	RegConsoleCmd("sm_days", Menu_Dias, "Days Menu");
	RegConsoleCmd("sm_royal", Menu_Royal, "Royal Day Menu");
	RegConsoleCmd("sm_warday", Menu_WarDay, "War Day Menu");
	RegConsoleCmd("sm_hns", Menu_Escondidas, "Hide and Seek Day Menu");
	RegConsoleCmd("sm_catchduck", Menu_Apanhadas, "Catch the Duck Day Menu");
	RegConsoleCmd("sm_nazi", Menu_Nazi, "Nazi Day Menu");
	RegConsoleCmd("sm_zombie", Menu_ZombieDay, "Zombie Day Menu");
	
	// Command to use in case that the day goes wrong and to try again in the next round;
	RegConsoleCmd("sm_fd", Command_Freeday, "Freeday");
	
	RegConsoleCmd("sm_dhelp", Command_DayHelp, "Day's Help Menu");
	
	// Skins Commands
	RegConsoleCmd("sm_zskins", Menu_ZombieDay_Skins, "Zombie Skins Menu");
	
	// Third Person Commands
	RegConsoleCmd("sm_tp", Command_ThirdPerson, "Third Person Command");
	
	RegConsoleCmd("sm_dmusic", Command_DaysMusic, "Music Days Command");
	
	cookie_zombieskins = RegClientCookie("zombie_skins", "Jailbreak Days Zombie Skins", CookieAccess_Public);
	cookie_naziskins = RegClientCookie("nazi_skins", "Jailbreak Days Nazi Skins", CookieAccess_Public);
	cookie_daysmusics = RegClientCookie("days_musics", "JailBreak Days Musics", CookieAccess_Public);
	
	// Events to Disable All the Days
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	
	// Gun's Menu CFG Path
	BuildPath(Path_SM, Guns_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/guns.cfg");
	
	// Zombie Skins Menu CFG Path
	BuildPath(Path_SM, Zombies_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/zombie_skins.cfg");
	
	// NAzi Skins Menu CFG Path
	BuildPath(Path_SM, Nazi_Path, PLATFORM_MAX_PATH, "configs/jailbreak_days/nazi_skins.cfg");
	
	// Downloads Path (It will everything you want to the downloads table);
	BuildPath(Path_SM, DownloadsPath, PLATFORM_MAX_PATH, "configs/jailbreak_days/downloads.txt");
	
	// Creates the forwards, to when a day has been enabled;
	g_forward_OnDayActivate = CreateGlobalForward("JailBreakDays_OnDayActivate", ET_Ignore, Param_Cell);
	
	AutoExecConfig(true, "main", "jailbreak_days");
}

public void OnClientPostAdminCheck(int client)
{	
	g_ZombieSkins[client] = 0;
	g_NaziSkins[client] = 0;
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
			
			GetClientCookie(client, cookie_naziskins, cookiebuffer, sizeof(cookiebuffer));
			g_NaziSkins[client] = StringToInt(cookiebuffer);
			
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
	g_ZombieDaySkins.Clear();
	g_ZombieDaySkinsList.Clear();
	
	g_NaziDaySkins.Clear();
	g_NaziDaySkinsList.Clear();
	
	LoadCVARs();
	
	Downloads();
	Precache();
	
	// Just to be safe;
	PrecacheModel("models/player/custom_player/legacy/ctm_sas.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix.mdl");
	
	if(g_JailbreakDays_Sounds_Enable)
	{		
		PrecacheSoundAny("misc/ptfun/jailbreak/apanhadas/music1.mp3", true);
		PrecacheSoundAny("misc/ptfun/jailbreak/zombieday/v2/music1.mp3", true);
	}
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
			if(num_special_days == g_JailbreakDays_Days_Time)
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
		if((g_JailbreakDays_Days_Time - num_special_days) == 0)
		{
			PrintToChatAll("[\x04Jailbreak Days\x01] Nesta ronda já podem ativar um dia especial!");
		}
		else if ((g_JailbreakDays_Days_Time - num_special_days) == 1)
		{
			PrintToChatAll("[\x04Jailbreak Days\x01] Falta \x0E1 ronda\x01 para ativar um dia especial!");
		}
		else
		{
			PrintToChatAll("[\x04Jailbreak Days\x01] Faltam \x0E%d rondas\x01 para ativar um dia especial!", (g_JailbreakDays_Days_Time - num_special_days));
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
	if(g_royalday_handle && !g_JailbreakDays_RoyalDay_AfterLR)
	{
		DesativarRoyalDay();
	}
	if(g_zombie_handle && !g_JailbreakDays_ZombieDay_AfterLR)
	{
		DesativarZombie();
	}
	if(g_escondidas_handle && !g_JailbreakDays_HideAndSeek_AfterLR)
	{
		DesativarEscondidas();
	}
	if(g_apanhadas_handle && !g_JailbreakDays_CatchTheDuck_AfterLR)
	{
		DesativarApanhadas();
	}
	if(g_warday_handle && !g_JailbreakDays_WarDay_AfterLR)
	{
		DesativarWarDay();
	}
}

stock void ShowNewHud(int client, int red, int green, int blue, char[] message) 
{ 
	SetHudTextParams(0.35, 0.125, 5.0, red, green, blue, 255, 0, 0.25, 1.5, 0.5);
	ShowHudText(client, 5, message);
}

public int Dias_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:Menu_Royal(client, choice);
			case 1:Menu_WarDay(client, choice);
			case 2:Menu_Escondidas(client, choice);
			case 3:Menu_Apanhadas(client, choice);
			case 4:Menu_ZombieDay(client, choice);
			case 5:Menu_Nazi(client, choice);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Dias(int client, int args)
{
	if(GameRules_GetProp("m_bWarmupPeriod") == 0)
	{
		if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
		{
			Menu menu = new Menu(Dias_Menu_Handler);
			menu.SetTitle("Days Menu");
			menu.AddItem("1", "Royal Day", (num_special_days == g_JailbreakDays_Days_Time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.AddItem("2", "War Day", (num_special_days == g_JailbreakDays_Days_Time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.AddItem("3", "Hide and Seek Day", (num_special_days == g_JailbreakDays_Days_Time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.AddItem("4", "Catch the Duck Day", (num_special_days == g_JailbreakDays_Days_Time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.AddItem("5", "Zombie Day", (num_days == 1)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.AddItem("6", "Nazi Day",( num_special_days == g_JailbreakDays_Days_Time)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
			menu.ExitButton = true;
			menu.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You need to be an \x0BWarden\x01 %s to use this command!", g_JailbreakDays_Admins_EnableDays?"or an \x07Admin\x01":"");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este comando encontra-se \x07desativado\x01 durante a ronda de \x0BWarmup\x01!");
	}
}

void Precache()
{
	// Precache Days MDL Files;
	
	if(g_JailbreakDays_ZombieDay_skins)
	{
		ZombieDay_Precache();
	}
	
	if(g_JailbreakDays_NaziDay_skins)
	{
		NaziDay_Precache();
	}
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
	menu.AddItem("1", "Menu dos Dias de Warden", (((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))) == true)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.AddItem("2", "Escolher as Skins de Zombie Day");
	menu.AddItem("3", "Ativar/Desativar a primeira pessoa");
	menu.AddItem("4", "Ativar/Desativar as musicas dos dias");
	menu.ExitButton = true;
	menu.Display(client, 20);
}

public int Day_HelpMenu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:Menu_Dias(client, choice);
			case 1:Menu_ZombieDay_Skins(client, choice);
			case 2:Command_ThirdPerson(client, choice);
			case 3:Command_DaysMusic(client, choice);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public void LoadCVARs()
{
	g_JailbreakDays_Royal_enable = g_CVAR_JailbreakDays_Royal_enable.IntValue;
	g_JailbreakDays_RoyalDay_AfterLR = g_CVAR_JailbreakDays_RoyalDay_AfterLR.IntValue;
	
	g_JailbreakDays_WarDay_enable = g_CVAR_JailbreakDays_WarDay_enable.IntValue;
	g_JailbreakDays_WarDay_AfterLR = g_CVAR_JailbreakDays_WarDay_AfterLR.IntValue;
	
	g_JailbreakDays_HideAndSeek_enable = g_CVAR_JailbreakDays_HideAndSeek_enable.IntValue;
	g_JailbreakDays_HideAndSeek_AfterLR = g_CVAR_JailbreakDays_HideAndSeek_AfterLR.IntValue;
	
	g_JailbreakDays_CatchTheDuck_enable = g_CVAR_JailbreakDays_CatchTheDuck_enable.IntValue;
	g_JailbreakDays_CatchTheDuck_AfterLR = g_CVAR_JailbreakDays_CatchTheDuck_AfterLR.IntValue;
	g_JailbreakDays_CatchTheDuck_gravity = g_CVAR_JailbreakDays_CatchTheDuck_Gravity.FloatValue;
	g_JailbreakDays_CatchTheDuck_speed = g_CVAR_JailbreakDays_CatchTheDuck_Speed.FloatValue;
	
	g_JailbreakDays_ZombieDay_enable = g_CVAR_JailbreakDays_ZombieDay_enable.IntValue;
	g_JailbreakDays_ZombieDay_AfterLR = g_CVAR_JailbreakDays_ZombieDay_AfterLR.IntValue;
	g_JailbreakDays_ZombieDay_skins = g_CVAR_JailbreakDays_ZombieDay_skins.IntValue;
	
	g_JailbreakDays_NaziDay_enable = g_CVAR_JailbreakDays_NaziDay_enable.IntValue;
	g_JailbreakDays_NaziDay_skins = g_CVAR_JailbreakDays_NaziDay_skins.IntValue;
	
	g_JailbreakDays_Days_Time = g_CVAR_JailbreakDays_Days_Time.IntValue;
	
	g_JailbreakDays_Parachute = g_CVAR_JailbreakDays_Parachute.IntValue;
	
	g_JailbreakDays_WeaponMenu = g_CVAR_JailbreakDays_WeaponMenu.IntValue;
	g_JailbreakDays_WeaponRestrict = g_CVAR_JailbreakDays_WeaponRestrict.IntValue;
	g_JailbreakDays_Admins_EnableDays = g_CVAR_JailbreakDays_Admins_EnableDays.IntValue;
	g_JailbreakDays_Sounds_Enable = g_CVAR_JailbreakDays_Sounds_Enable.IntValue;
	g_JailbreakDays_FDCommand = g_CVAR_JailbreakDays_FDCommand.IntValue;
	g_JailbreakDays_ThirdPerson = g_CVAR_JailbreakDays_ThirdPerson.IntValue;
}