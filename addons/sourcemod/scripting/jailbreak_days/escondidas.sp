#define ESCONDIDAS1 "ESCONDIDAS1"
#define ESCONDIDAS2 "ESCONDIDAS2"

public int Escondidas_Menu_Handler(Menu menu_escondidas, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_escondidas.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, ESCONDIDAS1))
		{
			AtivarEscondidas();
		}
		if(StrEqual(info, ESCONDIDAS2))
		{
			DesativarEscondidas();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_escondidas;
	}
}

public Action Menu_Escondidas(int client, int args)
{
	if(g_escondidas_enable)
	{
		if(num_special_days < GetConVarInt(g_days_time))
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a \x0E%d\x01 rondas!", (GetConVarInt(g_days_time) - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_escondidas = new Menu(Escondidas_Menu_Handler);
				menu_escondidas.SetTitle("Menu das Escondidas da PT'Fun");
				if(g_escondidas_handle)
				{
					menu_escondidas.AddItem("ESCONDIDAS1", "Ativar as Escondidas", ITEMDRAW_DISABLED);
					menu_escondidas.AddItem("ESCONDIDAS2", "Desativar as Escondidas");
				}
				else
				{
					menu_escondidas.AddItem("ESCONDIDAS1", "Ativar as Escondidas");
					menu_escondidas.AddItem("ESCONDIDAS2", "Desativar as Escondidas", ITEMDRAW_DISABLED);
				}
				menu_escondidas.ExitButton = true;
				menu_escondidas.Display(client, 20);
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

public Action AtivarEscondidas()
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
		}
	}
	
	ThirdPerson_Handle = false;
	
	
	//SetConVarBool(g_AFKManager, false);
	
	
	g_escondidas_handle = true;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "As Escondidas foram ativadas!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Escondidas foram ativadas!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's Escondidas, the index is 3 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(3);
}

public Action DesativarEscondidas()
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
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 3)
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
		}
	}
	
	//SetConVarBool(g_AFKManager, true);
	
	ThirdPerson_Handle = true;
	g_escondidas_handle = false;
	
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "As Escondidas foram desativadas!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] As Escondidas foram desativadas!");
}