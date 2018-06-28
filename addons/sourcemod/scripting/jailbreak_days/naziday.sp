#define NAZI1 "NAZI1"
#define NAZI2 "NAZI2"

void NaziDay_OnMapStart()
{
	
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerbody_colspec.vmt");
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerhead_colspec.vmt");
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerbody_colspec.vtf");
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerbody_normal.vtf");
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerhead_colspec.vtf");
	AddFileToDownloadsTable("materials/models/player/kuristaja/hitler/hitlerhead_normal.vtf");
	
	AddFileToDownloadsTable("models/player/custom_player/kuristaja/hitler/hitler.dx90.vtx");
	AddFileToDownloadsTable("models/player/custom_player/kuristaja/hitler/hitler.mdl");
	AddFileToDownloadsTable("models/player/custom_player/kuristaja/hitler/hitler.phy");
	AddFileToDownloadsTable("models/player/custom_player/kuristaja/hitler/hitler.vvd");
	
	PrecacheModel("models/player/custom_player/kuristaja/hitler/hitler.dx90.vtx", true);
	PrecacheModel("models/player/custom_player/kuristaja/hitler/hitler.mdl", true);
	PrecacheModel("models/player/custom_player/kuristaja/hitler/hitler.phy", true);
	PrecacheModel("models/player/custom_player/kuristaja/hitler/hitler.vvd", true);

}


public int Nazi_Menu_Handler(Menu menu_nazi, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu_nazi.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, NAZI1))
		{
			AtivarNazi();
		}
		if(StrEqual(info, NAZI2))
		{
			DesativarNazi();
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu_nazi;
	}
}

public Action Menu_Nazi(int client, int args)
{
	if(g_nazi_enable)
	{
		if(num_special_days < GetConVarInt(g_days_time))
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Só poderás ativar este dia daqui a \x0E%d\x01 rondas!", (GetConVarInt(g_days_time) - num_special_days));
		}
		else
		{
			if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
			{
				Menu menu_nazi = new Menu(Nazi_Menu_Handler);
				menu_nazi.SetTitle("Menu do Nazi Day da PT'Fun");
				if(g_nazi_handle)
				{
					menu_nazi.AddItem("NAZI1", "Ativar O Nazi Day", ITEMDRAW_DISABLED);
					menu_nazi.AddItem("NAZI2", "Desativar O Nazi Day");
				}
				else
				{
					menu_nazi.AddItem("NAZI1", "Ativar O Nazi Day");
					menu_nazi.AddItem("NAZI2", "Desativar O Nazi Day", ITEMDRAW_DISABLED);
				}
				menu_nazi.ExitButton = true;
				menu_nazi.Display(client, 20);
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

public Action AtivarNazi()
{		
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(warden_iswarden(i))
			{
					SetEntityModel(i, "models/player/custom_player/kuristaja/hitler/hitler.mdl");	
			}
		}
	}
	
	g_nazi_handle = true;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 0, 255, 0, "O Nazi Day foi ativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Nazi Day foi ativado!");
}

public Action DesativarNazi()
{
	
	for (int i = 0; i < MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			if(warden_iswarden(i))
			{
					SetEntityModel(i, "models/player/custom_player/legacy/ctm_sas.mdl");	
			}
		}
	}
	
	g_nazi_handle = false;
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			ShowNewHud(i, 255, 0, 0, "O Nazi Day foi desativado!");
		}
	}
	
	PrintToChatAll("[\x04Jailbreak Days\x01] O Nazi Day foi desativado!");
	
	/* 
		Forward to set when this day is enabled;
		Since it's NAzi Day, the index is 6 (check the include to check the day's index);
	*/
	Forward_OnDayActivate(6);
}