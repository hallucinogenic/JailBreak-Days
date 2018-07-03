void NaziDay_Precache()
{
	KeyValues kv = CreateKeyValues("nazi_skins");
	
	kv.ImportFromFile(Nazi_Path);
	
	if (!kv.GotoFirstSubKey())
	{
			return;
	}
	
	char Model[150];
	char ModelName[PLATFORM_MAX_PATH];
	
	do
	{
		kv.GetString("name", ModelName, sizeof(ModelName));
		g_NaziDaySkinsList.PushString(ModelName);
		kv.GetString("model", Model, sizeof(Model));
		g_NaziDaySkins.PushString(Model);
		PrecacheModel(Model, true);
	} while (kv.GotoNextKey());
	
	delete kv;
	return;
}


public int Nazi_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:AtivarNazi();
			case 1:DesativarNazi();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Nazi(int client, int args)
{
	if(g_JailbreakDays_NaziDay_enable)
	{
		if(num_special_days < g_JailbreakDays_Days_Time)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You can only enable this day after \x0E%d\x01 rounds!", (g_JailbreakDays_Days_Time - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
			{
				Menu menu = new Menu(Nazi_Menu_Handler);
				menu.SetTitle("Nazi Day Menu");
				menu.AddItem("1", "Enable Nazi Day", g_nazi_handle?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				menu.AddItem("1", "Disable Nazi Day", g_nazi_handle?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
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

public Action AtivarNazi()
{		
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(warden_iswarden(i))
			{
				if(g_JailbreakDays_NaziDay_skins)
				{
					SetNaziPlayerModel(i);
				}
				ShowNewHud(i, 0, 255, 0, "Nazi Day has been enabled!");
			}
		}
	}
	
	g_nazi_handle = true;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] Nazi Day has been enabled!");
}

public Action DesativarNazi()
{
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(warden_iswarden(i))
			{
				if(g_JailbreakDays_NaziDay_skins)
				{
					SetEntityModel(i, "models/player/custom_player/legacy/ctm_sas.mdl");	
				}
				ShowNewHud(i, 255, 0, 0, "Nazi Day has been disabled!");
			}
		}
	}
	
	g_nazi_handle = false;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] Nazi Day has been disabled!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's NAzi Day, the index is 6 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(6);
}


void SetNaziPlayerModel(int client)
{
	char model[PLATFORM_MAX_PATH];
	g_NaziDaySkins.GetString(g_NaziSkins[client], model, sizeof(model));
	SetEntityModel(client, model);
}