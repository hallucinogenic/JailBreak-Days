public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("Restrict_SetGroupRestriction");
	
	CreateNative("JailBreakDays_Enabled", Native_DaysEnabled);
	CreateNative("JailBreakDays_GetDay", Native_GetDay);
	CreateNative("JailBreakDays_Activate", Native_ActivateDay);
	CreateNative("JailBreakDays_Deactivate", Native_DeactivateDay);

	RegPluginLibrary("jailbreak_days");
	return APLRes_Success;
}


public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "weaponrestrict"))
	{
		g_restrict = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "weaponrestrict"))
	{
		g_restrict = false;
	}
}

public int Native_DaysEnabled(Handle plugin, int numParams)
{	
	if(g_royalday_handle)
	{
		return view_as<int>(g_royalday_handle);
	}
	else if(g_warday_handle)
	{
		return view_as<int>(g_warday_handle);
	}
	else if(g_escondidas_handle)
	{
		return view_as<int>(g_escondidas_handle);
	}
	else if(g_apanhadas_handle)
	{
		return view_as<int>(g_apanhadas_handle);
	}
	else if(g_zombie_handle)
	{
		return view_as<int>(g_zombie_handle);
	}
	else if(g_nazi_handle)
	{
		return view_as<int>(g_nazi_handle);
	}
	
	return view_as<int>(false);
}

public int Native_GetDay(Handle plugin, int numParams)
{	
	if(g_royalday_handle)
	{
		return 1;
	}
	else if(g_warday_handle)
	{
		return 2;
	}
	else if(g_escondidas_handle)
	{
		return 3;
	}
	else if(g_apanhadas_handle)
	{
		return 4;
	}
	else if(g_zombie_handle)
	{
		return 5;
	}
	else if(g_nazi_handle)
	{
		return 6;
	}
	
	return 0;
}

public int Native_ActivateDay(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int day = GetNativeCell(2);
	
	switch(day)
	{
		case 1:SelecionarArmaRoyal(client);
		case 2:SelecionarArmaWarDay(client);
		case 3:AtivarEscondidas();
		case 4:AtivarApanhadas();
		case 5:AtivarZombie();
		case 6:AtivarNazi();
	}
	return 0;
}

public int Native_DeactivateDay(Handle plugin, int numParams)
{
	int day = GetNativeCell(1);
	
	switch(day)
	{
		case 1:DesativarRoyalDay();
		case 2:DesativarWarDay();
		case 3:DesativarEscondidas();
		case 4:DesativarApanhadas();
		case 5:DesativarZombie();
		case 6:DesativarNazi();
	}
	return 0;
}

public void Forward_OnDayActivate(int day)
{
	Call_StartForward(g_forward_OnDayActivate);
	Call_PushCell(day);
	Call_Finish();
}