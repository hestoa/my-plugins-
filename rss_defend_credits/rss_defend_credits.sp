#include <zombiereloaded>
#include <sourcemod>
#include <sdktools>
#include <donator_z>
#include <sdkhooks>
#include <cstrike> 
#include <utilshelper>

int g_iPlayerDamage[MAXPLAYERS+1];
int rPlayer = 0;

public Plugin myinfo =  
{ 
	name = "money and zombie", 
	author = "h", 
	description = "i want credits", 
	version = "2000K", 
	url = "www.rssgo.co.kr" 
}

public void OnPluginStart()
{

    RegConsoleCmd("sm_dtc", damagetocredits, "check damage");
    HookEvent("round_start",  OnRoundStart);
    HookEvent("round_end",    OnRoundEnding);
    HookEvent("player_hurt",  OnClientHurt);
}

public void OnClientDisconnect(int client)
{
	g_iPlayerDamage[client] = 0;
}


public void OnRoundStart(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		g_iPlayerDamage[client] = 0;
	}
}



public void OnClientHurt(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
	int client = GetClientOfUserId(hEvent.GetInt("attacker"));
	int victim = GetClientOfUserId(hEvent.GetInt("userid"));

	if (client < 1 || client > MaxClients || victim < 1 || victim > MaxClients)
		return;

	if (client == victim || (IsPlayerAlive(client) && ZR_IsClientZombie(client)))
		return;

	int iDamage = hEvent.GetInt("dmg_health");
    if(iDamage == 1000)//칼질못하게
    {
        return;
    }
    else
    {
        g_iPlayerDamage[client] += iDamage;
    }
}


public void OnRoundEnding(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
    rPlayer = GetPlayerCount();
    if (rPlayer < 28)
    {
        PrintToChatAll("\x04[\x01RSS\x04] 현재 플레이어가 %d명이라 크레딧을 받지 않습니다. 최소인원 : 28 ",rPlayer);
        return;
    }
    else
    {
        for (int client = 1; client <= MaxClients; client++)
	    {
            if((g_iPlayerDamage[client] < 1000))
            {
               PrintToChat(client,"\x04[\x01RSS\x04] 현재 좀비에게 가한데미지 : \x0F%d \n \x04[\x01RSS\x04] 좀비에게 가한 데미지가 \x0F 1000 \x04 보다 작아 크레딧이 들어오지 않습니다.",g_iPlayerDamage[client]);
            }
	    	else
            {
                PrintToChat(client,"\x04[\x01RSS\x04] 이번라운드에 가한데미지 : \x0F%d \n \x04[\x01RSS\x04] 이번라운드에 받을 크레딧 : \x0F%d",g_iPlayerDamage[client],(g_iPlayerDamage[client] / 100));
                GivePlayerCredits(client,(g_iPlayerDamage[client] / 100));
            }
	    }
    }
}


public Action damagetocredits(int client, int args)
{
	if (!client) return Plugin_Handled;
	rPlayer = GetPlayerCount();

    if (rPlayer < 28)
    {
        PrintToChatAll("\x04[\x01RSS\x04] 현재 플레이어가 %d명이라 크레딧을 받지 않습니다. 최소인원 : 28 ",rPlayer);
        return Plugin_Handled;
    }
    else
    {
        if(g_iPlayerDamage[client] < 1000)
        {
            PrintToChat(client, "\x04[\x01RSS\x04]이번라운드 좀비에게 가한 데미지 : \x0F%d \n \x04[\x01RSS\x04] 이번라운드에 획득할 수 있는 크레딧 : 0",g_iPlayerDamage[client]);
            return Plugin_Handled;
        }
        else
        {
            PrintToChat(client, "\x04[\x01RSS\x04]\x0F이번 라운드 좀비에게 가한 데미지 : \x0F%d, \n \x04[\x01RSS\x04] 이번라운드에 획득할 수 있는 크레딧 : \x0F%d",g_iPlayerDamage[client],(g_iPlayerDamage[client] / 100));
            return Plugin_Handled;
        }
    }
}
