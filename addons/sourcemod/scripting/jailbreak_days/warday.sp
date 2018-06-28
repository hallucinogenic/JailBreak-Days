#define WARDAY1 "WARDAY1"
#define WARDAY2 "WARDAY2"

public int WarDay_Menu_Handler(Menu menu_warday, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_warday.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, WARDAY1))
		{
			SelecionarArmaWarday(param1, param2);
		}
		if(StrEqual(info, WARDAY2))
		{
			DesativarWarDay();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_warday;
	}
}

public Action Menu_Warday(int client, int args)
{
	if(g_warday_enable)
	{
		if(num_special_days < GetConVarInt(g_days_time))
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a \x0E%d\x01 rondas!", (GetConVarInt(g_days_time) - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_warday = new Menu(WarDay_Menu_Handler);
				menu_warday.SetTitle("Menu do War Day da PT'Fun");
				if(g_warday_handle)
				{
					menu_warday.AddItem("WARDAY1", "Ativar o War Day", ITEMDRAW_DISABLED);
					menu_warday.AddItem("WARDAY2", "Desativar o War Day");
				}
				else
				{
					menu_warday.AddItem("WARDAY1", "Ativar o War Day");
					menu_warday.AddItem("WARDAY2", "Desativar o War Day", ITEMDRAW_DISABLED);
				}
				menu_warday.ExitButton = true;
				menu_warday.Display(client, 20);
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

public Action AtivarWarDay(char [] weapon)
{	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			DisarmPlayerWeapons(i);
			GivePlayerItem(i, "weapon_knife");
			GivePlayerItem(i, weapon);
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

public int SelecionarArmaWarday_Handler(Menu menu_arma_w_select, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_arma_w_select.GetItem(param2, info, sizeof(info));
		AtivarWarDay(info);
	}
	else if (action == MenuAction_End)
	{
		delete menu_arma_w_select;
	}
}

public Action SelecionarArmaWarday(int client, int args)
{
	if(g_warday_enable)
	{
		if((warden_iswarden(client)))
		{
			Menu menu_arma_w_select = new Menu(SelecionarArmaWarday_Handler);
			WeaponsMenuItems(menu_arma_w_select);
			menu_arma_w_select.ExitButton = true;
			menu_arma_w_select.Display(client, 20);
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