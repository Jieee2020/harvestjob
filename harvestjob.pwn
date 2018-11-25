//Weed harvesting job by ConnorW




#include <a_samp>
#include <streamer>

//#define COMMAND_ENABLED //this will remove the auto-start working.
#define PLANT_OBJECT    3409 //If you'd like to put another object as plant, change this.
//-------------------------------
enum
{
    DIALOG_NOTHING,
	DIALOG_STARTJOB,
	DIALOG_ENDJOB
};
//-------------------------------

new HarvestJob,
StartPlant[MAX_PLAYERS],
OnPlant[MAX_PLAYERS],
CountPlant[MAX_PLAYERS],
InJob[MAX_PLAYERS],
PrinesPlantEx[MAX_PLAYERS],
CountPlantEx[MAX_PLAYERS],
ExtraPlants[MAX_PLAYERS],
JobSkin[MAX_PLAYERS],
skladplants;

enum harvestEnum
{
	text[32],
	Float:posX,
	Float:posY,
	Float:posZ
};

new const plantPositions[][harvestEnum] =
{
	//Text - PosX, PosY, PosZ, objectid
	{"{00FF00}Marijuana {FFFFFF}plant", -1030.6951, -1006.0359, 129.2126},
	{"{00FF00}Marijuana {FFFFFF}plant", -1060.9229, -928.9621, 129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1114.4142,-1030.7312,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1109.1970,-1003.3334,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1099.0498,-972.8215,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1103.1284,-954.1331,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1091.5793,-944.6408,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1062.3256,-945.2252,129.2188},
	{"{00FF00}Marijuana {FFFFFF}plant", -1060.9229, -928.9621, 129.2188}
};


//-------------------------------
forward ReloadPickup(playerid);
public ReloadPickup(playerid)
{
   	HarvestJob = CreatePickup(1275, 23, -1177.9513, -1139.6877, 129.2188, 0);
    return 1;
}

//-------------------------------
forward ProcessPlant(playerid);
public ProcessPlant(playerid)
{

	RemovePlayerAttachedObject(playerid, 3);
	SendClientMessage(playerid, -1, "You produced marijuana. Now, take them to the warehouse.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    ApplyAnimation(playerid, "KNIFE", "IDLE_tired", 4.0, 1, 0, 0, 0, 5000, 1);
	SetPlayerAttachedObject(playerid, 1, 2901, 5, 0.101, -0.0, 0.0, 5.50, 90, 90, 1, 1);
	SetPlayerCheckpoint(playerid, -1170.9009,-1095.8678,129.2188, 3.0);
	ExtraPlants[playerid] = 1; //to make sure player really did the job.
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/tpmetojob", true))
    {
        SetPlayerPos(playerid, -1177.9513, -1139.6877, 129.2188);
        return 1;
    }
    #if defined COMMAND_ENABLED
    if(!strcmp(cmdtext, "/harvestplant", true))
    {
		if(OnPlant[playerid] == 1 && StartPlant[playerid] == 0 && !IsPlayerInAnyVehicle(playerid))
		{
			for(new i = 0; i < sizeof(plantPositions); i ++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1, plantPositions[i][posX], plantPositions[i][posY], plantPositions[i][posZ]))
				{
					ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 5000, 1);
					GameTextForPlayer(playerid,"~w~Harvesting...",5000,3);
		   			ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 5000, 1);
		      		StartPlant[playerid] = 1;
					SetTimerEx("ProcessPlant", 5000, false, "i", playerid);
					return 1;
				}
			}
		}
	}
	#endif
    return 0;
}
//-------------------------------
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Weed Harvesting job by CW loaded sucessfully");
	print("--------------------------------------\n");
	for(new i = 0; i < sizeof(plantPositions); i ++)
	{
	    new string[164];
	    #if defined COMMAND_ENABLED
			format(string, sizeof string, "(%d)\n%s\n/harvestplant to begin", i, plantPositions[i][text]);
		    CreateDynamic3DTextLabel(string, 0xFFFF00AA, plantPositions[i][posX], plantPositions[i][posY], plantPositions[i][posZ], 10.0, .testlos = 1, .streamdistance = 10.0);
		#else
	 		format(string, sizeof string, "(%d)\n%s\n{C1C1C1}To get started, stay at the plant", i, plantPositions[i][text]);
		    CreateDynamic3DTextLabel(string, 0xFFFF00AA, plantPositions[i][posX], plantPositions[i][posY], plantPositions[i][posZ], 10.0, .testlos = 1, .streamdistance = 10.0);
		#endif
		CreateDynamicObject(PLANT_OBJECT, plantPositions[i][posX], plantPositions[i][posY], plantPositions[i][posZ] - 1.80, 0.0, 0.0, plantPositions[i][posZ], 0, 0);

	}
	HarvestJob = CreatePickup(1275, 23, -1177.9513, -1139.6877, 129.2188, 0);
	return 1;
}
//-------------------------------
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}
//-------------------------------
public OnPlayerConnect(playerid)
{
	InJob[playerid] = 0;
	OnPlant[playerid] = 0;
	StartPlant[playerid] = 0;

	CountPlant[playerid] = 0;
	PrinesPlantEx[playerid] = 0;
	CountPlantEx[playerid] = 0;
	ExtraPlants[playerid] = 0;
	return 1;
}
//-------------------------------
public OnPlayerDisconnect(playerid, reason)
{
    InJob[playerid] = 0;
	OnPlant[playerid] = 0;
	StartPlant[playerid] = 0;

	CountPlant[playerid] = 0;
	PrinesPlantEx[playerid] = 0;
	CountPlantEx[playerid] = 0;
	ExtraPlants[playerid] = 0;
	return 1;
}
//-------------------------------
public OnPlayerUpdate(playerid)
{
	#if !defined COMMAND_ENABLED
	if(OnPlant[playerid] == 1 && StartPlant[playerid] == 0 && !IsPlayerInAnyVehicle(playerid))
	{
		for(new i = 0; i < sizeof(plantPositions); i ++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1, plantPositions[i][posX], plantPositions[i][posY], plantPositions[i][posZ]))
			{
				ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 5000, 1);
				GameTextForPlayer(playerid,"~w~Harvesting..",5000,3);
	   			ApplyAnimation(playerid,"BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 5000, 1);
	      		StartPlant[playerid] = 1;
				SetTimerEx("ProcessPlant", 5000, false, "i", playerid);
				return 1;
			}
		}
	}
	#endif
	return 1;
}
//-------------------------------
public OnPlayerEnterCheckpoint(playerid)
{
	if(StartPlant[playerid] == 1)
	{
	    new string[256];
	    DisablePlayerCheckpoint(playerid);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ApplyAnimation(playerid, "KNIFE", "IDLE_tired", 4.0, 1, 0, 0, 0, 5000, 1);
		StartPlant[playerid] = 0;
	    RemovePlayerAttachedObject(playerid, 1);
	    SetPlayerAttachedObject(playerid, 3, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.000000, 1.000000, 1.000000);
        if(ExtraPlants[playerid] == 1) // just to make sure
	    {
		    PrinesPlantEx[playerid] = 130+random(130);
        	CountPlantEx[playerid] = CountPlantEx[playerid] + PrinesPlantEx[playerid];
	    	format(string, 256, "You brought {9ACD32}%d{FFFFFF} lb(s) marijuana plant.", PrinesPlantEx[playerid]);
		    SendClientMessage(playerid, -1, string);
	  		format(string, 256, "+%d", PrinesPlantEx[playerid]);
	  		SetPlayerChatBubble(playerid, string, 0x00FF00FF, 20.0, 3000);
	  		skladplants += PrinesPlantEx[playerid];
	    	PrinesPlantEx[playerid] = 0;
	    }
		return 1;
    }
	return 1;
}
//-------------------------------
public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == HarvestJob)
	{
		if(OnPlant[playerid] == 0) ShowPlayerDialog(playerid, DIALOG_STARTJOB, DIALOG_STYLE_MSGBOX, "{FFFFFF}Harvester Job", "{FFFFFF}Would you like this to be hired as {FFFF00}Weed Harvester{ffffff}?", "Yes", "No");
		else ShowPlayerDialog(playerid, DIALOG_ENDJOB, DIALOG_STYLE_MSGBOX, "{FFFFFF}Harvester Job", "{FFFFFF}Would you like to go off duty as {ffff00}Weed Harvester{ffffff}?", "Yes", "No");
	}
	return 1;
}
//-------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_NOTHING: // does nothing
		{
		    return 1;
		}
		case DIALOG_STARTJOB:
	    {
			if(!response) return 1;
			if(response)
			{
				StartPlant[playerid] = 0;
				OnPlant[playerid] = 1;
				JobSkin[playerid] = GetPlayerSkin(playerid);
				SetPlayerSkin(playerid, 158);
				SendClientMessage(playerid, 0x00FF00AA, "You are now on duty as plant harvester.");
		        InJob[playerid] = 1;
		        DestroyPickup(HarvestJob);
		        SetTimer("ReloadPickup", 7000, 0);
				return 1;
			}
	    }
	    case DIALOG_ENDJOB:
	    {
	        if(!response) return 1;
	        if(response)
	        {
		        new money = CountPlant[playerid]*1 + CountPlantEx[playerid]*4, string[128];
				StartPlant[playerid] = 0;
				OnPlant[playerid] = 0;
				CountPlant[playerid] = 0;
				PrinesPlantEx[playerid] = 0;
				CountPlantEx[playerid] = 0;
				ExtraPlants[playerid] = 0;
				SetPlayerSkin(playerid, JobSkin[playerid]);
				GivePlayerMoney(playerid, money);
				format(string, sizeof(string), "You've decided to leave the job.\n\nYou brought %dg marjuana in total\nPayment received: $%d", skladplants, money);
				ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Harvest Job", string, "Close", "");
	            skladplants = 0;
		        format(string, 128, "~g~+$%d", money);
		        GameTextForPlayer(playerid, string, 4000, 1);
				RemovePlayerAttachedObject(playerid, 3);
				RemovePlayerAttachedObject(playerid, 4);
				DisablePlayerCheckpoint(playerid);
				InJob[playerid] = 0;
		        DestroyPickup(HarvestJob);
		        SetTimer("ReloadPickup", 7000, 0);
			}
	        return 1;
	    }
    }
	return 1;
}
//------------------------------- The end, enjoy!
