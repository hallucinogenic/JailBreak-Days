#define ZOMBIE1 "ZOMBIE1"
#define ZOMBIE2 "ZOMBIE2"


void ZombieDay_Precache()
{
	KeyValues kv = CreateKeyValues("zombie_skins");
	
	kv.ImportFromFile(Zombies_Path);
	
	if (!kv.GotoFirstSubKey())
	{
			return;
	}
	
	char Model[150];
	char ModelName[PLATFORM_MAX_PATH];
	
	do
	{
		kv.GetString("name", ModelName, sizeof(ModelName));
		g_ZombieDaySkinsList.PushString(ModelName);
		kv.GetString("model", Model, sizeof(Model));
		g_ZombieDaySkins.PushString(Model);
		PrecacheModel(Model, true);
	} while (kv.GotoNextKey());
	
	delete kv;
	return;
}

public int Zombie_Menu_Handler(Menu menu_zombie, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_zombie.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, ZOMBIE1))
		{
			AtivarZombie();
		}
		if(StrEqual(info, ZOMBIE2))
		{
			DesativarZombie();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_zombie;
	}
}

public Action Menu_ZombieDay(int client, int args)
{
	if(g_zombie_enable)
	{
		if(num_days < 1)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a 1 ronda!");
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_zombie = new Menu(Zombie_Menu_Handler);
				menu_zombie.SetTitle("Menu do Zombie Day da PT'Fun");
				if(g_zombie_handle)
				{
					menu_zombie.AddItem("ZOMBIE1", "Ativar O Zombie Day", ITEMDRAW_DISABLED);
					menu_zombie.AddItem("ZOMBIE2", "Desativar O Zombie Day");
				}
				else
				{
					menu_zombie.AddItem("ZOMBIE1", "Ativar O Zombie Day");
					menu_zombie.AddItem("ZOMBIE2", "Desativar O Zombie Day", ITEMDRAW_DISABLED);
				}
				menu_zombie.ExitButton = true;
				menu_zombie.Display(client, 20);
			}
			else
			{
				PrintToChat(client, "[\x04Jailbreak Days\x01] Necessitas de ser \x0BWarden\x01 ou \x07Admin\x01 para usar este comando!");
			}
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este dia está desativado!");
	}
	return Plugin_Handled;
}

public Action AtivarZombie()
{
	
	if(g_restrict)
	{
		Restrict_SetGroupRestriction(WeaponTypePistol, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeSMG, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeShotgun, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeRifle, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeGrenade, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypePistol, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeSniper, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeMachineGun, 2, 0);
		Restrict_SetGroupRestriction(WeaponTypeOther, 2, 0);
	}
		
	SetConVarBool(g_parachute_check, false);
		
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				DisarmPlayerWeapons(i);
				GivePlayerItem(i, "weapon_knife");
				SetEntityGravity(i, 1.0);
				SetZombiePlayerModel(i);
			}
			
			EmitSoundToClientAny(i, "misc/ptfun/jailbreak/zombieday/v2/music1.mp3", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.25);
		}
	}
	
	
	g_zombie_handle = true;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "O Zombie Day foi ativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Zombie Day foi ativado!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Zombie Day, the index is 5 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(5);
}

public Action DesativarZombie()
{	
	if(g_restrict)
	{
		Restrict_SetGroupRestriction(WeaponTypePistol, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeSMG, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeShotgun, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeRifle, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeGrenade, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypePistol, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeSniper, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeMachineGun, 2, -1);
		Restrict_SetGroupRestriction(WeaponTypeOther, 2, -1);
	}
	
	SetConVarBool(g_parachute_check, true);
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				SetEntityModel(i, "models/player/custom_player/legacy/tm_phoenix.mdl");	
			}
		}
	}
	g_zombie_handle = false;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "O Zombie Day foi desativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Zombie Day foi desativado!");
}

public Action Menu_ZombieDay_Skins(int client, int args)
{
	if(g_zombie_enable)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM1, true))
		{
			Menu menu_zombie = new Menu(Zombie_Skin_Menu_Handler);
			menu_zombie.SetTitle("Menu das Skins de Zombie da PT'Fun");
			KeyValues kv = CreateKeyValues("zombie_skins");
	
			kv.ImportFromFile(Zombies_Path);
			
			if (!kv.GotoFirstSubKey())
			{
					return Plugin_Handled;
			}
			char ClassID[150];
			char model[150];
			char flags[40];
			char menu_phrase[150];
			
			char cookiebuffer[256];
			GetClientCookie(client, cookie_zombieskins, cookiebuffer, sizeof(cookiebuffer));
			
			do
			{
				kv.GetSectionName(ClassID, sizeof(ClassID));
				kv.GetString("flags", flags, sizeof(flags));
				kv.GetString("name", model, sizeof(model));
				if(StrEqual(flags, ""))
				{	
					Format(menu_phrase, 150, "%s%s", model, StrEqual(cookiebuffer, ClassID, false)?" (Atual)":"");
					menu_zombie.AddItem(ClassID, menu_phrase, StrEqual(cookiebuffer, ClassID, false)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				}
				else
				{
					if(HasPlayerFlags(client, flags))
					{
						menu_zombie.AddItem(ClassID, model);
					}
					else
					{
						Format(menu_phrase, 150, "%s (VIP)", model);
						menu_zombie.AddItem(ClassID, menu_phrase, ITEMDRAW_DISABLED);
					}
				}
			} while (kv.GotoNextKey());
			
			delete kv;
			menu_zombie.ExitButton = true;
			menu_zombie.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Necessitas de ser \x0BVIP\x01 para usar este comando!");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este comando encontra-se desativado!");
	}
	return Plugin_Handled;
}

public int Zombie_Skin_Menu_Handler(Menu menu_zombie, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_zombie.GetItem(choice, info, sizeof(info));
		SetClientCookie(client, cookie_zombieskins, info);
		g_ZombieSkins[client] = choice;
		
		char SkinName[256];
		g_ZombieDaySkinsList.GetString(choice, SkinName, sizeof(SkinName));
		
		if(g_zombie_handle)
		{
			SetZombiePlayerModel(client);
		}
		
		PrintToChat(client, "[\x04Jailbreak Days\x01] Escolheste a Skin \x0E%s\x01 para a tua skin de Zombie no Zombie Day!", SkinName);
		Menu_ZombieDay_Skins(client, choice);
	}
	else if (action == MenuAction_End)
	{
		delete menu_zombie;
	}
}

void SetZombiePlayerModel(int client)
{
	char model[PLATFORM_MAX_PATH];
	g_ZombieDaySkins.GetString(g_ZombieSkins[client], model, sizeof(model));
	SetEntityModel(client, model);	

	PrintToChat(client, "Skin Model: \x0E%s\x01", model);
}