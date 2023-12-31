#include "PlayerInfo.as";
#include "BaseTeamInfo.as";
#include "RulesCore.as";

#define SERVER_ONLY

void onInit(CRules@ this)
{
	this.set_bool("managed teams", true);
}

void onNewPlayerJoin(CRules@ this, CPlayer@ player)
{
	RulesCore@ core;
    this.get("core", @core);

	core.ChangePlayerTeam(player, 0);
}

void onPlayerRequestTeamChange(CRules@ this, CPlayer@ player, u8 newTeam)
{
	RulesCore@ core;
	this.get("core", @core);
	if (core is null) return;

	core.ChangePlayerTeam(player, 0);
}

void onPlayerRequestSpawn(CRules@ this, CPlayer@ player)
{
	RulesCore@ core;
    this.get("core", @core);

	if (core is null) return;

	if (player.getTeamNum() != this.getSpectatorTeamNum())
	{
		core.ChangePlayerTeam(player, player.getTeamNum() );
		Respawn(this, player);		
	}
}


CBlob@ Respawn(CRules@ this, CPlayer@ player)
{
	if (player !is null)
	{
		// remove previous players blob
		CBlob @blob = player.getBlob();

		if (blob !is null)
		{
			CBlob @blob = player.getBlob();
			blob.server_SetPlayer(null);
			blob.server_Die();
		}

		CBlob @newBlob = server_CreateBlob("playerblob", 0, getSpawnLocation(player));
		newBlob.server_SetPlayer(player);
		SetScreenFlash(0, 255, 255, 255);
		return newBlob;
	}

	return null;
}

Vec2f getSpawnLocation(CPlayer@ player)
{
	Vec2f[] spawns;

	if (getMap().getMarkers("blue spawn", spawns))
	{
		return spawns[ XORRandom(spawns.length) ];
	}
	else if (getMap().getMarkers("blue main spawn", spawns))
	{
		return spawns[ XORRandom(spawns.length) ];
	}

	return Vec2f(256, 256);
}




