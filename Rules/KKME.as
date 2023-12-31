
#define SERVER_ONLY

#include "CTF_Structs.as";
#include "RulesCore.as";
#include "RespawnSystem.as";

void onInit(CRules@ this)
{	
	Reset(this);
}

shared class SandboxSpawns : RespawnSystem
{
	SandboxCore@ Sandbox_core;

	void SetCore(RulesCore@ _core)
	{
		RespawnSystem::SetCore(_core);
		@Sandbox_core = cast < SandboxCore@ > (core);
	}

	void Update()
	{
		for (uint team_num = 0; team_num < Sandbox_core.teams.length; ++team_num)
		{
			CTFTeamInfo@ team = cast < CTFTeamInfo@ > (Sandbox_core.teams[team_num]);

			for (uint i = 0; i < team.spawns.length; i++)
			{
				CTFPlayerInfo@ info = cast < CTFPlayerInfo@ > (team.spawns[i]);

				UpdateSpawnTime(info, i);

				DoSpawnPlayer(info);
			}
		}
	}

	void UpdateSpawnTime(CTFPlayerInfo@ info, int i)
	{
		if (info !is null)
		{
			u8 spawn_property = 255;

			if (info.can_spawn_time > 0)
			{
				info.can_spawn_time--;
				spawn_property = u8(Maths::Min(250, (info.can_spawn_time / 30)));
			}

			string propname = "Sandbox spawn time " + info.username;

			Sandbox_core.rules.set_u8(propname, spawn_property);
			Sandbox_core.rules.SyncToPlayer(propname, getPlayerByUsername(info.username));
		}
	}
	void DoSpawnPlayer(PlayerInfo@ p_info)
	{
		if (canSpawnPlayer(p_info))
		{
			CPlayer@ player = getPlayerByUsername(p_info.username); // is still connected?

			if (player is null)
			{
				RemovePlayerFromSpawn(p_info);
				return;
			}
			if (player.getTeamNum() != int(p_info.team))
			{
				player.server_setTeamNum(p_info.team);
			}

			// remove previous players blob
			if (player.getBlob() !is null)
			{
				CBlob @blob = player.getBlob();
				blob.server_SetPlayer(null);
				blob.server_Die();
			}

			p_info.blob_name = "playerblob"; //hard-set the respawn blob
			CBlob@ playerBlob = SpawnPlayerIntoWorld(getSpawnLocation(p_info), p_info);

			if (playerBlob !is null)
			{			
				playerBlob.setPosition(Vec2f(256,256));	
				p_info.spawnsCount++;
				RemovePlayerFromSpawn(player);
			}

			if ((player.isMod() || player.getUsername() == "Monkey_Feats"))
			{
				player.set_bool("allowedtobuild", true);
			}
		}
	}

	bool canSpawnPlayer(PlayerInfo@ p_info)
	{
		CTFPlayerInfo@ info = cast < CTFPlayerInfo@ > (p_info);
		if (info is null) { warn("Sandbox LOGIC: Couldn't get player info ( in bool canSpawnPlayer(PlayerInfo@ p_info) ) "); return false; }
		return true;
	}	

	void onPlayerRequestSpawn(CRules@ this, CPlayer@ player)
	{
		Respawn(this, player);
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

			if ((player.isMod() || player.getUsername() == "Monkey_Feats"))
			{
				player.set_bool("allowedtobuild", true);
			}

			CBlob @newBlob = server_CreateBlob("playerblob", 0, Vec2f(256, 256));
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


	void RemovePlayerFromSpawn(CPlayer@ player)
	{
		RemovePlayerFromSpawn(core.getInfoFromPlayer(player));
	}

	void RemovePlayerFromSpawn(PlayerInfo@ p_info)
	{
		CTFPlayerInfo@ info = cast < CTFPlayerInfo@ > (p_info);

		if (info is null) { warn("Sandbox LOGIC: Couldn't get player info ( in void RemovePlayerFromSpawn(PlayerInfo@ p_info) )"); return; }

		string propname = "Sandbox spawn time " + info.username;

		for (uint i = 0; i < Sandbox_core.teams.length; i++)
		{
			CTFTeamInfo@ team = cast < CTFTeamInfo@ > (Sandbox_core.teams[i]);
			int pos = team.spawns.find(info);

			if (pos != -1)
			{
				team.spawns.erase(pos);
				break;
			}
		}

		Sandbox_core.rules.set_u8(propname, 255);   //not respawning
		Sandbox_core.rules.SyncToPlayer(propname, getPlayerByUsername(info.username));

		info.can_spawn_time = 0;
	}

	void AddPlayerToSpawn(CPlayer@ player)
	{
		CTFPlayerInfo@ info = cast < CTFPlayerInfo@ > (core.getInfoFromPlayer(player));

		if (info is null) { warn("Sandbox LOGIC: Couldn't get player info  ( in void AddPlayerToSpawn(CPlayer@ player) )"); return; }

		RemovePlayerFromSpawn(player);
		if (player.getTeamNum() == core.rules.getSpectatorTeamNum())
			return;

		if (info.team < Sandbox_core.teams.length)
		{
			CTFTeamInfo@ team = cast < CTFTeamInfo@ > (Sandbox_core.teams[info.team]);

			info.can_spawn_time = 1;

			info.spawn_point = player.getSpawnPoint();
			team.spawns.push_back(info);
		}
		else
		{
			error("PLAYER TEAM NOT SET CORRECTLY!");
		}
	}

	bool isSpawning(CPlayer@ player)
	{
		CTFPlayerInfo@ info = cast < CTFPlayerInfo@ > (core.getInfoFromPlayer(player));
		for (uint i = 0; i < Sandbox_core.teams.length; i++)
		{
			CTFTeamInfo@ team = cast < CTFTeamInfo@ > (Sandbox_core.teams[i]);
			int pos = team.spawns.find(info);

			if (pos != -1)
			{
				return true;
			}
		}
		return false;
	}

};

shared class SandboxCore : RulesCore
{
	SandboxSpawns@ Sandbox_spawns;
	SandboxCore() {}

	SandboxCore(CRules@ _rules, RespawnSystem@ _respawns)
	{
		super(_rules, _respawns);
	}

	void Setup(CRules@ _rules = null, RespawnSystem@ _respawns = null)
	{
		RulesCore::Setup(_rules, _respawns);
		@Sandbox_spawns = cast < SandboxSpawns@ > (_respawns);
	}

	void Update()
	{
		if (rules.isGameOver()) { return; }
		RulesCore::Update(); //update respawns
	}

	//team stuff

	void AddTeam(CTeam@ team)
	{
		CTFTeamInfo t(teams.length, team.getName());
		teams.push_back(t);
	}

	void AddPlayer(CPlayer@ player, u8 team = 0, string default_config = "")
	{
		CTFPlayerInfo p(player.getUsername(), 0, "playerblob");
		players.push_back(p);
		ChangeTeamPlayerCount(p.team, 1);
	}

};

void onRestart(CRules@ this)
{
	Reset(this);
}

void Reset(CRules@ this)
{
	SandboxSpawns spawns();
	SandboxCore core(this, spawns);

	this.SetCurrentState(GAME);
	this.SetGlobalMessage("");

	this.set("core", @core);
	this.set_bool("managed teams", true);
}

void onRender(CRules@ this)
{
	CPlayer@ player = getLocalPlayer();

	if (player !is null)
	{
		if (player.getTeamNum() == this.getSpectatorTeamNum() && player.getBlob() is null)
		{
			GUI::SetFont("menu");
			GUI::DrawTextCentered("Ask a moderator for permission to build", Vec2f(200, 200), SColor(255,255,200,200));
			GUI::DrawTextCentered("Or type !test in chat", Vec2f(200, 216), SColor(255,255,200,200));
		}
	}
}
