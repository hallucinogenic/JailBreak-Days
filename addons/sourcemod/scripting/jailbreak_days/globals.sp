// Jailbreak Days's Gun Menu
void WeaponsMenuItems(Menu menu)
{
	KeyValues kv = CreateKeyValues("jailbreak_days_guns");
	
	kv.ImportFromFile(Guns_Path);
	
	if (!kv.GotoFirstSubKey())
	{
			return;
	}
	
	char ClassID[150];
	char name[150];
	
	do
	{		
		kv.GetSectionName(ClassID, sizeof(ClassID));
		kv.GetString("weapon_name", name, sizeof(name));
		menu.AddItem(ClassID, name);
	} while (kv.GotoNextKey());
	
	delete kv;
	return;
}

// Functions to toggle the radar's HUD
void Hide(int client)
{
	SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_RADAR);  
}

void UnHide(int client)
{
	SetEntProp(client, Prop_Send, "m_bSpotted", SHOWHUD_RADAR); 
}

// A Command to give the possibility to make again a specialday in the next round;
public Action Command_Freeday(int client, int args)
{
	if(!g_fd_command_enable)
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Lamento, mas este comando encontra-se desativado pelo servidor!");
		return;
	}
	
	if(num_special_days == GetConVarInt(g_days_time))
	{
		if((warden_iswarden(client)) || CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
		{
				Menu menu = new Menu(Freeday_Handler);
				menu.SetTitle("Queres descontar uma ronda para fazer um dia especial?\nPoderão fazer na próxima ronda");
				menu.AddItem("1", "Sim");
				menu.AddItem("2", "Não");
				menu.ExitButton = false;
				menu.Display(client, 20);
		}
		else
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Necessitas de ser \x0BWarden\x01 ou \x07Admin\x01 para usar este comando!");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este comando não pode ser usado nesta ronda!");
	}
}

public int Freeday_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu.GetItem(param2, info, sizeof(info));
		if(StrEqual(info, "1"))
		{
			num_special_days -= 1;
			PrintToChatAll("[\x04Jailbreak Days\x01] O \x0BWarden\x01 descontou uma ronda!");
			PrintToChatAll("[\x04Jailbreak Days\x01] Poderão fazer um \x0EDia Especial\x01 na próxima ronda!");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Command_DaysMusic(int client, int args)
{
	if (Days_Music[client])
	{
		Days_Music[client] = false;
		SetClientCookie(client, cookie_daysmusics, "0");
		PrintToChat(client, "[\x04Jailbreak Days\x01] Agora deixarás de \x04ouvir as músicas\x01 dos dias");
	}
	else
	{
		Days_Music[client] = true;
		SetClientCookie(client, cookie_daysmusics, "1");
		PrintToChat(client, "[\x04Jailbreak Days\x01] Agora passarás a \x04ouvir as músicas\x01 dos dias");
	}
}

public bool HasPlayerFlags(int client, char flags[40])
{
	if(StrContains(flags, "a") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_RESERVATION, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "b") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_GENERIC, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "c") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_KICK, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "d") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_BAN, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "e") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_UNBAN, true))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "f") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_SLAY, true))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "g") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CHANGEMAP, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "h") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CONVARS, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "i") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CONFIG, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "j") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CHAT, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "k") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_VOTE, true))
		{
			return true;
		}
	}	
	else if(StrContains(flags, "l") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_PASSWORD, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "m") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_RCON, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "n") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CHEATS, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "z") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_ROOT, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "o") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM1, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "p") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM2, true))
		{
			return true;
		}
	}
	else if(StrContains(flags, "q") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM3, true))
		{
			return true;
		}
	}		
	else if(StrContains(flags, "r") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM4, true))
		{
			return true;
		}
	}			
	else if(StrContains(flags, "s") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM5, true))
		{
			return true;
		}
	}			
	else if(StrContains(flags, "t") != -1)
	{
		if(CheckCommandAccess(client, "", ADMFLAG_CUSTOM6, true))
		{
			return true;
		}
	}
	
	return false;
}