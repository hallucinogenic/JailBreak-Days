public Action Command_ThirdPerson(int client, int args)
{
	if(IsValidClient(client))
	{
		if(!g_JailbreakDays_ThirdPerson)
		{
			return;
		}
		
		if(!ThirdPerson_Handle)
		{
			PrintToChat(client, "[\x04Jailbreak Days\x01] Lamento mas este comando encontra-se \x07desativado\x01 durante este dia!");
			return;
		}
	
		if(ThirdPerson[client])
		{
			ThirdPerson[client] = false;
			ClientCommand(client, "firstperson");
		}
		else
		{
			ThirdPerson[client] = true;
			ClientCommand(client, "thirdperson");
		}
		
		PrintToChat(client, "[\x04Jailbreak Days\x01] Now your camera is in \x0E%s Person\x01!n", ThirdPerson[client]?"First":"Third");
	}
}