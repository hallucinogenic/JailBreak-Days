public int WarDay_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:SelecionarArmaWarDay(client);
			case 1:DesativarWarDay();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_WarDay(int client, int args)
{
	if(g_JailbreakDays_WarDay_enable)
	{
		if(num_special_days < g_JailbreakDays_Days_Time)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You can only enable this day after \x0E%d\x01 rounds!", (g_JailbreakDays_Days_Time - num_special_days));
			return Plugin_Continue;
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
			{
				Menu menu = new Menu(WarDay_Menu_Handler);
				menu.SetTitle("Menu do War Day");
				
				menu.AddItem("1", "Enable War Day", g_warday_handle?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				menu.AddItem("2", "Disable War Day", g_warday_handle?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
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
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

public Action AtivarWarDay(char[] primary, char[] secondary)
{	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			DisarmPlayerWeapons(i);
			GivePlayerItem(i, "weapon_knife");
			
			if(!StrEqual(primary, "none", true))
			{
				GivePlayerItem(i, primary);
			}
			
			if(!StrEqual(secondary, "none", true))
			{
				GivePlayerItem(i, secondary);
			}
		}
	}
	
	g_warday_handle = true;
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "O War Day foi ativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O War Day foi ativado!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's War Day, the index is 2 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(2);
}

public Action DesativarWarDay()
{	
	g_warday_handle = false;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "O War Day foi desativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O War Day foi desativado!");
}

public Action SelecionarArmaWarDay(int client)
{
	if(g_JailbreakDays_WarDay_enable)
	{
		if((warden_iswarden(client)))
		{
			if(g_JailbreakDays_WeaponMenu == 1 || g_JailbreakDays_WeaponMenu == 3)
			{
				WeaponsMenuItems_Primary(client);
			}
			else
			{
				strcopy(g_PrimeWeapon_Name, sizeof(g_primeWeapon_Name), "none");
			}
			
			if(g_JailbreakDays_WeaponMenu == 2 || g_JailbreakDays_WeaponMenu == 3)
			{
				WeaponsMenuItems_Pistol(client);
			}
			else
			{
				strcopy(g_PistolWeapon_Name, sizeof(g_PistolWeapon_Name), "none");
			}
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You need to be an \x0BWarden\x01 %s to use this command!", g_JailbreakDays_Admins_EnableDays?"or an \x07Admin\x01":"");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] This day is disabled!");
	}
}