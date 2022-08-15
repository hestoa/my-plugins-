#include <zombiereloaded>
#include <sourcemod>
#include <sdktools>
#include <donator_z>
#include <sdkhooks>
#include <cstrike> 
#include <utilshelper>

bool bVampire = false;
bool bStart = false;

public Plugin myinfo =  
{ 
	name = "heal and zombie", 
	author = "h", 
	description = "i want hpppppp", 
	version = "3000K", 
	url = "www.rssgo.co.kr" 
}

public void OnPluginStart()
{
    RegAdminCmd("sm_startvampire", startVampire, ADMFLAG_ROOT);
    RegAdminCmd("sm_stopvampire", stopVampire, ADMFLAG_ROOT);
    HookEvent("round_start",OnRoundStart, EventHookMode_Post);
    HookEvent("round_end",OnRoundEnd, EventHookMode_Post);
    HookEvent("player_hurt",  OnClientHurt);
    HookEvent("player_spawn", OnPlayerSpawn);
}


public Action startVampire(int client, int args)
{
	if (!client) return Plugin_Handled;
    bVampire = true;

    PrintToChat(client,"이 숫자가 >>\x0F%d<< \x091이면 켜진거임 dd 담라부터 적용됨",bVampire);
    return Plugin_Handled;

}
public Action stopVampire(int client, int args)
{
	if (!client) return Plugin_Handled;

    bVampire = false;
    int iEntity = INVALID_ENT_REFERENCE;
    iEntity = FindEntityByTargetName("vampire_hurt_rss");
    AcceptEntityInput(iEntity, "Disable");
    PrintToChat(client,"이 숫자가 >>\x0F%d<<\x09 0이면 켜진거임 dd 담라부터 적용됨",bVampire);
    return Plugin_Handled;
}

public void OnClientHurt(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
    if (bVampire)
    {
        int client = GetClientOfUserId(hEvent.GetInt("attacker"));
        int victim = GetClientOfUserId(hEvent.GetInt("userid"));

	    if (client < 1 || client > MaxClients || victim < 1 || victim > MaxClients)
        return;

	    if (client == victim || (IsPlayerAlive(client) && ZR_IsClientZombie(client)))
        return;

	    int iDamage = hEvent.GetInt("dmg_health");
        int iCHealth = GetClientHealth(client);
        //int iCHealth = hEvent.GetInt("m_iHealth");

        if(iDamage == 1000)//칼질이였을경우
        {
            int GettingHealth = (iCHealth += iDamage);
            SetEntProp(client, Prop_Data, "m_iHealth", (GettingHealth += 1000));
        }
        else
        {
            int GettingHealth = (iCHealth += iDamage);
            SetEntProp(client, Prop_Data, "m_iHealth", GettingHealth);
        }
    }
    else
    {
        return;
    }
}


public void OnRoundStart(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
    CreateTimer(0.3, DisableTimer);
    CreateTimer(5.3, DisableTimer);
    bStart = true;
}

public Action OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
    if (!bVampire)
    {
        return;        
    }
    else 
    {
        CreateTimer(0.3, DisableTimer);
        return;
    }
}
public ZR_OnClientInfected(client, attacker, bool:motherInfect, bool:respawnOverride, bool:respawn)
{
    //PrintToChatAll("test");
	if(bVampire)
    {
        if(bStart)
        {
            CreateTimer(0.3, HumanTimer);
            CreateTimer(0.3, ZombieTimer);
            CreateTimer(5.3, EnableTimer);
            bStart = false;
            //PrintToChatAll("test2");
        }
        else
        {
            CreateTimer(0.3, ZombieTimer);
            //PrintToChatAll("test3");
        }
    }
}


public Action EnableTimer(Handle hTimer)
{
    int iEntity = INVALID_ENT_REFERENCE;
    iEntity = FindEntityByTargetName("vampire_hurt_rss");
    AcceptEntityInput(iEntity, "Enable");
}
public Action DisableTimer(Handle hTimer)
{
    int iEntity = INVALID_ENT_REFERENCE;
    iEntity = FindEntityByTargetName("vampire_hurt_rss");
    AcceptEntityInput(iEntity, "Disable");
}
public Action HumanTimer(Handle hTimer)
{
        for(int client = 1; client <= MaxClients; client++)
	    {
            if ((IsPlayerAlive(client) && !ZR_IsClientZombie(client) && IsValidClient(client)))
            {
                SetEntProp(client, Prop_Send, "m_iHealth", 10000);
            }
	    }
}
public Action ZombieTimer(Handle hTimer)
{
        for(int client = 1; client <= MaxClients; client++)
	    {
            if ((IsPlayerAlive(client) && ZR_IsClientZombie(client) && IsValidClient(client)))
            {
                SetEntProp(client, Prop_Send, "m_iHealth", 999999);
            }
	    }
}

public int FindEntityByTargetName(const char[] sTargetnameToFind)

{

	int iEntity = INVALID_ENT_REFERENCE;

	while((iEntity = FindEntityByClassname(iEntity, "*")) != INVALID_ENT_REFERENCE)

	{

		char sTargetname[64];

		GetEntPropString(iEntity, Prop_Data, "m_iName", sTargetname, sizeof(sTargetname));


		if (strcmp(sTargetnameToFind, sTargetname, false) == 0)

		{

			return iEntity;

		}

	}


	PrintToChatAll("[r] Error! Could not find entity: %s", sTargetnameToFind);

	return INVALID_ENT_REFERENCE;

}

public Action OnPlayerSpawn(Event hEvent, const char[] sName, bool bDontBroadCast)
{
    int client = GetClientOfUserId(hEvent.GetInt("userid"));

    if((IsPlayerAlive(client) && ZR_IsClientZombie(client) && IsValidClient(client)))
    SetEntProp(client, Prop_Send, "m_iHealth", 999999);
}
