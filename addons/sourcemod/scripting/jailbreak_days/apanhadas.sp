#define APANHADAS1 "APANHADAS1"
#define APANHADAS2 "APANHADAS2"

public int Apanhadas_Menu_Handler(Menu menu_apanhadas, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_apanhadas.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, APANHADAS1))
		{
			AtivarApanhadas();
		}
		if(StrEqual(info, APANHADAS2))
		{
			DesativarApanhadas();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_apanhadas;
	}
}

public Action Menu_Apanhadas(int client, int args)
{
	if(g_apanhadas_enable)
	{
		if(num_special_days < GetConVarInt(g_days_time))
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a \x0E%d\x01 rondas!", (GetConVarInt(g_days_time) - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_apanhadas = new Menu(Apanhadas_Menu_Handler);
				menu_apanhadas.SetTitle("Menu das Apanhadas da PT'Fun");
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

public Action AtivarApanhadas()
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
			SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 2.0);
			SetEntityGravity(i, 0.3);
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
			}
			EmitSoundToClientAny(i, "misc/ptfun/jailbreak/apanhadas/music1.mp3", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.25);
		}
	}
	
	SetConVarInt(g_gravity, 240);
	
	g_apanhadas_handle = true;
	
	
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "As Apanhadas foram ativadas!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Apanhadas foram ativadas!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Apanhadas, the index is 4 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(4);
}

public Action DesativarApanhadas()
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
			SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
			SetEntityGravity(i, 1.0);
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
		}
	}
	
	SetConVarInt(g_gravity, 800);
	
	g_apanhadas_handle = false;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "As Apanhadas foram desativadas!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Apanhadas foram desativadas!");
}