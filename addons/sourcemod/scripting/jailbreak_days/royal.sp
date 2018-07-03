public int Royal_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:
			{
				SelecionarArmaRoyal(client);
			}
			case 1:
			{
				DesativarRoyalDay();
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Royal(int client, int args)
{
	if(g_JailbreakDays_Royal_enable)
	{
		if(num_special_days < g_JailbreakDays_Days_Time)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You can only enable this day after \x0E%d\x01 rounds!", (g_JailbreakDays_Days_Time - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))))
			{
				Menu menu = new Menu(Royal_Menu_Handler);
				menu.SetTitle("Royal Day Menu");
				menu.AddItem("1", "Enable Royal Day", g_royalday_handle?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				menu.AddItem("2", "Disable Royal Day", g_royalday_handle ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
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

public Action AtivarRoyalDay(char[] primary, char[] secondary)
{	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
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
				
				Hide(i);
			}
			else if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
			}
			
			if(ThirdPerson[i])
			{
				ThirdPerson[i] = false;
				ClientCommand(i, "firstperson");
			}
		}
	}
	
	ThirdPerson_Handle = false;
	
	SetConVarInt(g_friendlyfire, 1);
	SetConVarInt(g_ff_damage_reduction_other, 1);
	SetConVarInt(g_ff_damage_reduction_grenade_self, 1);
	SetConVarInt(g_ff_damage_reduction_grenade, 1);
	SetConVarInt(g_ff_damage_reduction_bullets, 1);
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "Royal Day has been enabled!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] Royal Day has been enabled!");
	g_royalday_handle = true;
	
	/* 
		Forward to set when this day is enabled;
		Since it's Royal Day, the Day's index is 1 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(1);
}

public Action DesativarRoyalDay()
{	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				UnHide(i);
			}
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
		}
	}
	
	ThirdPerson_Handle = true;
	
	SetConVarInt(g_friendlyfire, 0);
	SetConVarInt(g_ff_damage_reduction_other, 0);
	SetConVarInt(g_ff_damage_reduction_grenade_self, 0);
	SetConVarInt(g_ff_damage_reduction_grenade, 0);
	SetConVarInt(g_ff_damage_reduction_bullets, 0);
	
	g_royalday_handle = false;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "Royal Day has been disabled!");
		}
	}
	PrintToChatAll("[\x04Jailbreak Days\x01] Royal Day has been disabled!");
}


public Action SelecionarArmaRoyal(int client)
{
	if(g_JailbreakDays_Royal_enable)
	{
		if((warden_iswarden(client)) || (GetUserFlagBits(client) && ADMFLAG_GENERIC))
		{
			WeaponsMenuItems_Primary(client);
			WeaponsMenuItems_Pistol(client);
			AtivarRoyalDay(g_PrimeWeapon_Name, g_PistolWeapon_Name);
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