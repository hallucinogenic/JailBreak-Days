public Action Command_ThirdPerson(int client, int args)
{
	if(!ThirdPerson_Handle)
	{
		PrintToChat(client, "[\x04Jailbreak Days\x01] Lamento mas este comando encontra-se \x07desativado\x01 durante este dia!");
		return;
	}
	
	if(IsValidClient(client))
	{
		if(ThirdPerson[client])
		{
			ThirdPerson[client] = false;
			ClientCommand(client, "firstperson");
			PrintToChat(client, "[\x04Jailbreak Days\x01] A tua câmara encontra-se na \x0Eprimeira\x01 pessoa!");
		}
		else
		{
			ThirdPerson[client] = true;
			ClientCommand(client, "thirdperson");
			PrintToChat(client, "[\x04Jailbreak Days\x01] A tua câmara encontra-se na \x0Eterceira\x01 pessoa!");
		}
	}
}