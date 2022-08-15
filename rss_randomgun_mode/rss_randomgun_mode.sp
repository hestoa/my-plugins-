#include <zombiereloaded>
#include <sourcemod>
#include <sdktools>
#include <donator_z>
#include <sdkhooks>
#include <cstrike> 
#include <utilshelper>



static char all_weapons[49][] = {
    "weapon_m4a1", "weapon_m4a1_silencer", "weapon_ak47", "weapon_aug", "weapon_awp", "weapon_bizon", "weapon_deagle", "weapon_elite", "weapon_famas",
    "weapon_fiveseven", "weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hkp2000", "weapon_usp_silencer", "weapon_knife", "weapon_m249", "weapon_mac10",
    "weapon_mag7", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p90", "weapon_p250", "weapon_cz75a", "weapon_sawedoff", "weapon_scar20",
    "weapon_sg556", "weapon_ssg08", "weapon_mp5sd", "weapon_tec9", "weapon_ump45", "weapon_xm1014" ,"weapon_deagle", "weapon_elite", "weapon_fiveseven", "weapon_glock", 
	"weapon_hkp2000", "weapon_p250", "weapon_tec9", "weapon_cz75a", "weapon_usp_silencer" , "weapon_hegrenade" , "weapon_incgrenade", "weapon_smokegrenade" , "weapon_tagrenade" ,
	"weapon_snowball" , "weapon_fists"
};

public Plugin myinfo =  
{ 
	name = "gun and zombie", 
	author = "h", 
	description = "i want gunsssss", 
	version = "1000K", 
	url = "www.rssgo.co.kr" 
}


public void OnPluginStart()
{
    RegAdminCmd("sm_randomgun", randomGun, ADMFLAG_GENERIC, "test>");
	HookEvent("round_end",    OnRoundEnding);
}

public void OnMapEnd()
{
	CreateTimer(5.3, ResetTimer);
}


public Action randomGun(int client, int args)
{
	if (!client) return Plugin_Handled;
	CreateTimer(0.1, StartTimer);
	return Plugin_Handled;
}




stock void GiveClientWeapons(int client)
{
    int Random =-1;
	Random = GetRandomInt(0, 48);
	GivePlayerItem(client, all_weapons[Random]);
}
stock bool CheckPlayer(int client)
{
    if(IsClientInGame(client) && IsPlayerAlive(client) && !ZR_IsClientZombie(client))
	{
		return true;
	}
	else
	{
		return false;
	}
}
stock void StripAllWeapons(int client) 
{
	for(int j = 0; j < 5; j++)
	{
		int w = -1;
		while ((w = GetPlayerWeaponSlot(client, j)) != -1)
		{
			if(IsValidEntity(w) && IsValidEdict(w))
			{
				RemovePlayerItem(client, w);
				RemoveEdict(w);
			}
		}
	}
}


public void OnRoundEnding(Event hEvent, const char[] sEvent, bool bDontBroadcast)
{
	ServerCommand("sm_rcon sm plugins load fastbuy");
	ServerCommand("sm_rcon sm plugins load zzzfastbuy");
	ServerCommand("sm_rcon zr_config_path_weapons configs/zr/weapons.txt");
	ServerCommand("sm_rcon zr_config_reloadall");
}

public Action ResetTimer(Handle hTimer)
{
    ServerCommand("sm_rcon sm plugins load fastbuy");
	ServerCommand("sm_rcon sm plugins load zzzfastbuy");
	ServerCommand("sm_rcon zr_config_path_weapons configs/zr/weapons.txt");
	ServerCommand("sm_rcon zr_config_reloadall");
	ServerCommand("sm_rcon sm plugins unload disabled/rss_randomgun_mode");
}

public Action StartTimer(Handle hTimer)
{
	ServerCommand("sm_rcon sm plugins unload fastbuy");
	ServerCommand("sm_rcon sm plugins unload zzzfastbuy");
	ServerCommand("sm_rcon zr_config_path_weapons configs/zr/maps/random_weapons.txt");
	ServerCommand("sm_rcon zr_config_reloadall");

	for(int i = 1; i <= MaxClients; i++)
	{
		if(CheckPlayer(i))
		{
			StripAllWeapons(i);
			GiveClientWeapons(i);
		}
	}
}