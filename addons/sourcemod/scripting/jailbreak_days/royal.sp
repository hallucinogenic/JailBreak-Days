#define ROYAL1 "ROYAL1"
#define ROYAL2 "ROYAL2"

public int Royal_Menu_Handler(Menu menu_royal, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_royal.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, ROYAL1))
		{
			SelecionarArmaRoyal(param1, param2);
		}
		if(StrEqual(info, ROYAL2))
		{
			DesativarRoyalDay();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_royal;
	}
}

public Action Menu_Royal(int client, int args)
{
	if(g_royalday_enable)
	{
		if(num_special_days < GetConVarInt(g_days_time))
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a \x0E%d\x01 rondas!", (GetConVarInt(g_days_time) - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_royal = new Menu(Royal_Menu_Handler);
				menu_royal.SetTitle("Menu do Royal Day da PT'Fun");
				
				if(g_royalday_handle)
				{
					menu_royal.AddItem("ROYAL1", "Ativar o Royal Day", ITEMDRAW_DISABLED);
					menu_royal.AddItem("ROYAL2", "Desativar o Royal Day");
				}
				else
				{
					menu_royal.AddItem("ROYAL1", "Ativar o Royal Day");
					menu_royal.AddItem("ROYAL2", "Desativar o Royal Day", ITEMDRAW_DISABLED);
				}
				menu_royal.ExitButton = true;
				menu_royal.Display(client, 20);
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

public Action AtivarRoyalDay(char [] weapon)
{	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(GetClientTeam(i) == 2)
			{
				DisarmPlayerWeapons(i);
				GivePlayerItem(i, "weapon_knife");
				GivePlayerItem(i, weapon);
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
			ShowNewHud(i, 0, 255, 0, "O Royal Day foi ativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Royal Day foi ativado!");
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
			ShowNewHud(i, 255, 0, 0, "O Royal Day foi desativado!");
		}
	}
	PrintToChatAll("[\x04Jailbreak Days\x01] O Royal Day foi desativado!");
}

public int SelecionarArmaRoyal_Handler(Menu menu_arma_royal_select, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_arma_royal_select.GetItem(param2, info, sizeof(info));
		AtivarRoyalDay(info);
	}
	else if (action == MenuAction_End)
	{
		delete menu_arma_royal_select;
	}
}

public Action SelecionarArmaRoyal(int client, int args)
{
	if(g_royalday_enable)
	{
		if((warden_iswarden(client)) || (GetUserFlagBits(client) && ADMFLAG_GENERIC))
		{
			Menu menu_arma_royal_select = new Menu(SelecionarArmaRoyal_Handler);
			menu_arma_royal_select.SetTitle("Seleciona a Arma do Dia");
			WeaponsMenuItems(menu_arma_royal_select);
			menu_arma_royal_select.ExitButton = true;
			menu_arma_royal_select.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Necessitas de ser \x0BWarden\x01 ou \x07Admin\x01 para usar este comando!");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este dia está desativado!");
	}
}