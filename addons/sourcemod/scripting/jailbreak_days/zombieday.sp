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

public int Zombie_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:AtivarZombie();
			case 1:DesativarZombie();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_ZombieDay(int client, int args)
{
	if(g_JailbreakDays_ZombieDay_enable)
	{
		if(num_days < 1)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a 1 ronda!");
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
			{
				Menu menu= new Menu(Zombie_Menu_Handler);
				menu.SetTitle("Menu do Zombie Day");
				menu.AddItem("1", "Enable Zombie Day", g_zombie_handle?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				menu.AddItem("2", "Disable Zombie Day", g_zombie_handle ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
				menu.ExitButton = true;
				menu.Display(client, 20);
			}
			else
			{
				PrintToChat(client, "[\x04Jailbreak Days\x01] You need to be an \x0BWarden\x01 %s to use this command!", g_JailbreakDays_Admins_EnableDays?"or an \x07Admin\x01":"");
			}
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] This day is disabled!");
	}
	return Plugin_Handled;
}

public Action AtivarZombie()
{
	
	if(g_JailbreakDays_WeaponRestrict && g_restrict)
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
	
	if(g_JailbreakDays_Parachute && g_parachute_check != null)
	{
		SetConVarBool(g_parachute_check, false);
	}
		
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				DisarmPlayerWeapons(i);
				GivePlayerItem(i, "weapon_knife");
				SetEntityGravity(i, 1.0);
				
				if(g_JailbreakDays_ZombieDay_skins)
				{
					SetZombiePlayerModel(i);
				}
			}
			
			if(g_JailbreakDays_Sounds_Enable)
			{
				EmitSoundToClientAny(i, "misc/ptfun/jailbreak/zombieday/v2/music1.mp3", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.25);
			}
			ShowNewHud(i, 0, 255, 0, "O Zombie Day foi ativado!");
		}
	}
	
	
	g_zombie_handle = true;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Zombie Day foi ativado!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Zombie Day, the index is 5 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(5);
}

public Action DesativarZombie()
{	
	if(g_JailbreakDays_WeaponRestrict && g_restrict)
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
	
	if(g_JailbreakDays_Parachute && g_parachute_check != null)
	{
		SetConVarBool(g_parachute_check, true);
	}

	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				if(g_JailbreakDays_ZombieDay_skins)
				{
					SetEntityModel(i, "models/player/custom_player/legacy/tm_phoenix.mdl");	
				}
			}
			ShowNewHud(i, 255, 0, 0, "O Zombie Day foi desativado!");
		}
	}
	g_zombie_handle = false;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Zombie Day foi desativado!");
}

public Action Menu_ZombieDay_Skins(int client, int args)
{
	if(g_JailbreakDays_ZombieDay_enable)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM1, true))
		{
			Menu menu_zombie = new Menu(Zombie_Skin_Menu_Handler);
			menu_zombie.SetTitle("Menu das Skins de Zombie");
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
		char buffer[10];
		IntToString(choice, buffer, sizeof(buffer));
		SetClientCookie(client, cookie_zombieskins, buffer);
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