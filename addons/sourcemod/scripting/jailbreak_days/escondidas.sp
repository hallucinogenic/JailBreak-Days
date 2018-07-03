public int Escondidas_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:AtivarEscondidas();
			case 1:DesativarEscondidas();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Escondidas(int client, int args)
{
	if(g_JailbreakDays_HideAndSeek_enable)
	{
		if(num_special_days < g_JailbreakDays_Days_Time)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You can only enable this day after \x0E%d\x01 rounds!", (g_JailbreakDays_Days_Time - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
			{
				Menu menu = new Menu(Escondidas_Menu_Handler);
				menu.SetTitle("Hide and Seek Day Menu");
				menu.AddItem("1", "Enable Hide and Seek Day", g_escondidas_handle?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
				menu.AddItem("2", "Disable Hide and Seek Day", g_escondidas_handle?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
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

public Action AtivarEscondidas()
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
		
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				DisarmPlayerWeapons(i);
				GivePlayerItem(i, "weapon_knife");
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
			ShowNewHud(i, 0, 255, 0, "As Escondidas foram ativadas!");
		}
	}
	
	ThirdPerson_Handle = false;
	
	g_escondidas_handle = true;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Escondidas foram ativadas!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Escondidas, the index is 3 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(3);
}

public Action DesativarEscondidas()
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
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
			ShowNewHud(i, 255, 0, 0, "As Escondidas foram desativadas!");
		}
	}
	
	
	ThirdPerson_Handle = true;
	g_escondidas_handle = false;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Escondidas foram desativadas!");
}