// Jailbreak Days's Gun Menu
public int SelecionarArmaPistol_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu.GetItem(param2, info, sizeof(info));
		strcopy(g_PistolWeapon_Name, sizeof(g_PistolWeapon_Name), info);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}
public int SelecionarArmaPrimary_Handler(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char info[32];
		menu.GetItem(param2, info, sizeof(info));
		strcopy(g_PrimeWeapon_Name, sizeof(g_PrimeWeapon_Name), info);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

void WeaponsMenuItems_Primary(int client)
{
	Menu menu = new Menu(SelecionarArmaPrimary_Handler);
	menu.SetTitle("Select the Primary Gun for the day:");
	KeyValues kv = CreateKeyValues("jailbreak_days_guns");
	menu.AddItem("none", "No Primary Guns");
	
	kv.ImportFromFile(Guns_Path);
	
	
	char ClassID[150];
	char name[150];
	
	if(kv.JumpToKey("Primary Guns"))
	{
		kv.GotoFirstSubKey();
		do
		{
			kv.GetSectionName(ClassID, sizeof(ClassID));
			kv.GetString("weapon_name", name, sizeof(name));
			menu.AddItem(ClassID, name);
		}while (kv.GotoNextKey());
		kv.Rewind();
		delete kv;
	}
	
	menu.ExitButton = true;
	menu.Display(client, 20);
}

void WeaponsMenuItems_Pistol(int client)
{
	Menu menu = new Menu(SelecionarArmaPistol_Handler);
	menu.SetTitle("Select the Pistol for the Day:");
	menu.AddItem("none", "No Pistols");
	
	KeyValues kv = CreateKeyValues("jailbreak_days_guns");
	
	kv.ImportFromFile(Guns_Path);
	
	
	char ClassID[150];
	char name[150];
	
	if(kv.JumpToKey("Pistols"))
	{
		kv.GotoFirstSubKey();
		do
		{
			kv.GetSectionName(ClassID, sizeof(ClassID));
			kv.GetString("weapon_name", name, sizeof(name));
			menu.AddItem(ClassID, name);
		}while (kv.GotoNextKey());
		kv.Rewind();
		delete kv;
	}
	menu.ExitButton = true;
	menu.Display(client, 20);
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
	if(!g_JailbreakDays_FDCommand)
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Lamento, mas este comando encontra-se desativado pelo servidor!");
		return;
	}
	
	if(num_special_days == g_JailbreakDays_Days_Time)
	{
		if((warden_iswarden(client)) || (g_JailbreakDays_Admins_EnableDays && CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC)))
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
			PrintToChat(client, "[\x04Jailbreak Days\x01] You need to be an \x0BWarden\x01 %s to use this command!", g_JailbreakDays_Admins_EnableDays?"or an \x07Admin\x01":"");
		}
	}
	else
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Este comando não pode ser usado nesta ronda!");
	}
}

public int Freeday_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		if(choice == 0)
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
	}
	else
	{
		Days_Music[client] = true;
		SetClientCookie(client, cookie_daysmusics, "1");
	}
	
	PrintToChat(client, "[\x04Jailbreak Days\x01] You have \x0E%sabled\x01 the Day's Music!", Days_Music[client]?"en":"dis");
}

public bool HasPlayerFlags(int client, char flags[40])
{
	int flag = ReadFlagString(flags);
	
	if(CheckCommandAccess(client, "", flag, true))
	{
		return true;
	}
	
	return false;
}