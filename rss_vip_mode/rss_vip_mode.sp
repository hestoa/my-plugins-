
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike> 



int vipid = -1;

float inti = 1.0;
public OnPluginStart()
{
    RegAdminCmd("sm_randomvip", Random, ADMFLAG_ROOT);
    RegAdminCmd("sm_resetallvip", resetallvip, ADMFLAG_ROOT);
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
    HookEvent("round_start",Event_RoundStart, EventHookMode_Post);
}
public void OnMapEnd()
{
	CreateTimer(0.3, ResetTimer);
}

public Action:Random(client, args)
{
    vipid = -1;
    int rClient = GetRandomPlayer();
    
    char name[32];
    GetClientName(rClient, name, sizeof(name));
    vipid = GetClientUserId(rClient)

    float speed2 = 0.5;
    float model2 = 2.0;
    ServerCommand("sm_rcon sv_gravity 600");


    SetEntPropFloat(rClient, Prop_Data, "m_flLaggedMovementValue", speed2);
    SetEntPropFloat(rClient, Prop_Send, "m_flModelScale", model2);

    ServerCommand("sm_beacon #%d",vipid);

    PrintToChatAll("[VIP]\x04 %s \x07님이 \x02VIP\x07가 되었습니다!!", name);  
}

public Action:resetallvip(client, args)
{
    ServerCommand("sm_rcon sv_gravity 800");
    ServerCommand("sm_modelscale @ct %.2f",inti);
    ServerCommand("sm_speed @ct %.2f",inti);
    vipid = -1;
}
public Action:Timer_ReadyUp(Handle:hTimer)
{
    ServerCommand("sm_rcon sv_gravity 800");
    ServerCommand("sm_modelscale @ct %.2f",inti);
    ServerCommand("sm_speed @ct %.2f",inti);
    vipid = -1;
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
    CreateTimer(10.0 ,Timer_ReadyUp);
} 

public Action:Timer_EndUp(Handle:hTimer)
{
        ServerCommand("sm_slay @ct");
        PrintToChatAll("\x07------------------");
        PrintToChatAll("\x07------------------");
        PrintToChatAll("\x07------------------");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
        PrintToChatAll("[VIP] \x04 vip\x07가 사망했습니다!");
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int userid = GetEventInt(event, "userid");
    if(userid == vipid)
    {
        vipid = -1;
        ServerCommand("sm_rcon sv_gravity 800");
        ServerCommand("sm_modelscale @ct %.2f",inti);
        ServerCommand("sm_speed @ct %.2f",inti);

        CreateTimer(1.0 ,Timer_EndUp);
    }
    else
    {
        return;
    }
} 

stock GetRandomPlayer()
{
	int iNumPlayers;
	char iPlayers[MaxClients];
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			if (GetClientTeam(i) == 3)
			{
				iPlayers[iNumPlayers++] = i;
			}
		}
	}
	if (iNumPlayers == 0)
	{
		return -1;
	}
	return iPlayers[GetRandomInt(0, iNumPlayers - 1)];
}
public Action ResetTimer(Handle hTimer)
{
    ServerCommand("sm_rcon sm plugins unload disabled/rss_vip_mode");
}

