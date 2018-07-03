public int Apanhadas_Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0:AtivarApanhadas();
			case 1:DesativarApanhadas();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Apanhadas(int client, int args)
{
	if(g_JailbreakDays_CatchTheDuck_enable)
	{
		if(num_special_days < g_JailbreakDays_Days_Time)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] You can only enable this day after \x0E%d\x01 rounds!", (g_JailbreakDays_Days_Time - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
			{
				Menu menu_apanhadas = new Menu(Apanhadas_Menu_Handler);
				menu_apanhadas.SetTitle("Menu das Apanhadas");
				if(g_apanhadas_handle)
				{
					menu_apanhadas.AddItem("APANHADAS1", "Ativar as Apanhadas", ITEMDRAW_DISABLED);
					menu_apanhadas.AddItem("APANHADAS2", "Desativar as Apanhadas");
				}
				else
				{
					menu_apanhadas.AddItem("APANHADAS1", "Ativar as Apanhadas");
					menu_apanhadas.AddItem("APANHADAS2", "Desativar as Apanhadas", ITEMDRAW_DISABLED);
				}
				menu_apanhadas.ExitButton = true;
				menu_apanhadas.Display(client, 20);
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

public Action AtivarApanhadas()
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
		
		Restrict_SetGroupRestriction(WeaponTypePistol, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeSMG, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeShotgun, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeRifle, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeGrenade, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypePistol, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeSniper, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeMachineGun, 3, 0);
		Restrict_SetGroupRestriction(WeaponTypeOther, 3, 0);
	}
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			DisarmPlayerWeapons(i);
			GivePlayerItem(i, "weapon_knife");
			
			if(g_JailbreakDays_CatchTheDuck_speed != 0.0)
			{
				SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", g_JailbreakDays_CatchTheDuck_speed);
			}
			
			if(g_JailbreakDays_CatchTheDuck_gravity != 0.0)
			{
				SetEntityGravity(i, g_JailbreakDays_CatchTheDuck_gravity);
			}
			
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
			}
			
			if(g_JailbreakDays_Sounds_Enable)
			{
				EmitSoundToClientAny(i, "misc/ptfun/jailbreak/apanhadas/music1.mp3", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.25);
			}
			ShowNewHud(i, 0, 255, 0, "As Apanhadas foram ativadas!");
		}
	}

	
	g_apanhadas_handle = true;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Apanhadas foram ativadas!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Apanhadas, the index is 4 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(4);
}

public Action DesativarApanhadas()
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
		
		Restrict_SetGroupRestriction(WeaponTypePistol, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeSMG, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeShotgun, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeRifle, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeGrenade, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypePistol, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeSniper, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeMachineGun, 3, -1);
		Restrict_SetGroupRestriction(WeaponTypeOther, 3, -1);
	}
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			
			if(g_JailbreakDays_CatchTheDuck_speed != 0.0)
			{
				SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
			}
			
			if(g_JailbreakDays_CatchTheDuck_gravity != 0.0)
			{
				SetEntityGravity(i, 1.0);
			}
			
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
			ShowNewHud(i, 255, 0, 0, "As Apanhadas foram desativadas!");
		}
	}
	
	g_apanhadas_handle = false;
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Apanhadas foram desativadas!");
}