#include "RulesCore.as";

bool onServerProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	if (player is null)
		return true;

	CBlob@ blob = player.getBlob(); // now, when the code references "blob," it means the player who called the command

	if (blob is null || text_in.substr(0, 1) != "!") // dont continue if its not a command
	{
		return true;
	}
	
	if (text_in == "!test")
	{		
		Vec2f pos = blob.getPosition();
		int team = blob.getTeamNum(); 

		CBlob@ kar = server_CreateBlob('kar', 0, pos);

		if (kar !is null)
		{
			kar.server_SetPlayer(player);
			blob.server_Die();
		}
		return false;
	}
	else if (text_in == "!camrot")
	{
		if (blob.getName() == "kar")
		{			
			blob.set_bool("rotate camera", !blob.get_bool("rotate camera"));
			blob.Sync("rotate camera", true );
			return true;
		}
		return false;
	}
	else if ((player.isMod() || player.getUsername() == "Monkey_Feats"))
	{
		string[]@ tokens = text_in.split(" ");

		if (tokens.length > 1)
		{
			if (tokens[0] == "!allow")
			{
				string name = tokens[1];
				CPlayer@ tplayer = getPlayerByUsername(name);
				if (tplayer !is null)
				{
					RulesCore@ core;
						 this.get("core", @core);
					if (core is null) { warn("CORE NOT FOUND"); return false; }	

					tplayer.set_bool("allowedtobuild", true);
					client_AddToChat(name+" has been given the power to build!", SColor(255, 255, 0, 0));
					return true;
				}
				else 
				{
					client_AddToChat(name+" doesn't exist!", SColor(255, 255, 0, 0));
					return true;
				}
			}
			else if (tokens[0] == "!disallow")
			{
				string name = tokens[1];
				CPlayer@ tplayer = getPlayerByUsername(name);
				if (tplayer !is null)
				{
					RulesCore@ core;
						 this.get("core", @core);
					if (core is null) { warn("CORE NOT FOUND"); return false; }	

					tplayer.set_bool("allowedtobuild", false);
					client_AddToChat(name+" power to build has been taken away!", SColor(255, 255, 0, 0));
					return true;
				}
				else 
				{
					client_AddToChat(name+" doesn't exist!", SColor(255, 255, 0, 0));
					return true;
				}
			}
		}
	}
	return true;
}

bool onClientProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	return true;
}

Vec2f getSpawnLocation()
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