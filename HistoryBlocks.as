
shared class HistoryBlock
{
	TileType tile;
	string name;
	u8 team;
	Vec2f pos;
	f32 angle;
	bool reversed;

	HistoryBlock() {} // required for handles to work

	HistoryBlock(TileType _tile, string _name, u8 _team, Vec2f _pos, f32 _angle, bool _reversed)
	{
		tile = _tile;
		name = _name;
		team = _team;
		pos = _pos;
		angle = _angle;
		reversed = _reversed;
	}
};

shared class HistoryInfo
{
	HistoryBlock@[][] historyblocks;
	u16 currentHistoryTimeline;

	void setTimeline()
	{			
		currentHistoryTimeline++;
		historyblocks.set_length(currentHistoryTimeline+2);
		historyblocks[currentHistoryTimeline-1].clear();
		historyblocks[currentHistoryTimeline].clear();
		historyblocks[currentHistoryTimeline+1].clear();
	}

	void PushHistory(Vec2f tilepos, TileType maptile, string name, u8 teamnum, f32 angle, bool reversed)
	{
		CBlob@ underblob = getMap().getBlobAtPosition(tilepos);	
		if (name != "")
		{
			HistoryBlock b( maptile, name, teamnum, tilepos, angle, reversed);
			historyblocks[currentHistoryTimeline-1].push_back( b );
		}
		else if (underblob !is null && !underblob.hasTag("player") && !underblob.isAttached())
		{
			HistoryBlock b( maptile, underblob.getName(), underblob.getTeamNum(), tilepos, underblob.getAngleDegrees(), false);
			historyblocks[currentHistoryTimeline-1].push_back( b );	
		}
		else
		{
			HistoryBlock b( maptile, "", 0, tilepos, angle, reversed);
			historyblocks[currentHistoryTimeline-1].push_back( b );	
		}
	}
}


void doUndo(HistoryInfo@ history)
{
	if (history.currentHistoryTimeline-1 > 0)
	{
		history.currentHistoryTimeline--;
	
		for(uint i = 0; i < history.historyblocks[history.currentHistoryTimeline].length; i++)
		{
			HistoryBlock@ historyblock = history.historyblocks[history.currentHistoryTimeline][i];
	
			TileType maptile = getMap().getTile(historyblock.pos).type;
			Vec2f tpos = historyblock.pos;
			//string bname = historyblock.name;
			//u8 teamnum = historyblock.team;
			CBlob@ underblob = getMap().getBlobAtPosition(historyblock.pos);
			if (underblob !is null && !underblob.hasTag("player") && !underblob.isAttached())
			{
				HistoryBlock b( maptile, underblob.getName(), underblob.getTeamNum(), underblob.getPosition(), underblob.getAngleDegrees(), false);
				history.historyblocks[history.currentHistoryTimeline+1].insertAt(i,b);	
			}	
			else
			{
				HistoryBlock b( maptile, "", 0, tpos, historyblock.angle, historyblock.reversed);
				history.historyblocks[history.currentHistoryTimeline+1].insertAt(i,b);	
			}

			getMap().server_SetTile(historyblock.pos , historyblock.tile);
			//SetTileFlags(getMap(), historyblock.pos, historyblock.angle, historyblock.reversed);
			//CBitStream params;
			//params.write_Vec2f(tilepos);
			//params.write_u16(angle);
			//params.write_bool(reversed);
			//getRules().SendCommand(getRules().getCommandID("SetTileFlags"), params);	

			CBlob@[] overlapping;
			getMap().getBlobsAtPosition(historyblock.pos, @overlapping);
			for(uint i = 0; i < overlapping.length; i++)
			{
				CBlob@ underblob = overlapping[i];
				if (underblob !is null && !underblob.hasTag("player") && !underblob.isAttached())
				{ 
					underblob.server_Die();
				}
			}			

			if (historyblock.name != "" && underblob is null)
			{					
				CBlob@ undoBlob = server_CreateBlob(historyblock.name, historyblock.team, historyblock.pos);
				if (undoBlob !is null)
				{
					undoBlob.setAngleDegrees(historyblock.angle);
					undoBlob.getShape().SetStatic(true);
				}
			}					
		}
		history.historyblocks[history.currentHistoryTimeline+1].set_length(history.historyblocks[history.currentHistoryTimeline].length);
	}
}

void doRedo(HistoryInfo@ history)
{	
	if (history.historyblocks[history.currentHistoryTimeline+1].length != 0)
	{
		history.currentHistoryTimeline++;
		for(uint i = 0; i < history.historyblocks[history.currentHistoryTimeline].length; i++)
		{
			HistoryBlock@ historyblock = history.historyblocks[history.currentHistoryTimeline][i];
		
			TileType maptile = getMap().getTile(historyblock.pos).type;
			Vec2f tpos = historyblock.pos;
			//string bname = historyblock.name;
			//u8 teamnum = historyblock.team;

			CBlob@ underblob = getMap().getBlobAtPosition(historyblock.pos);
			if (underblob !is null && !underblob.hasTag("player") && !underblob.isAttached())
			{
				HistoryBlock b( maptile, underblob.getName(), underblob.getTeamNum(), underblob.getPosition(), underblob.getAngleDegrees(), false);
				history.historyblocks[history.currentHistoryTimeline-1].insertAt(i,b);	

				underblob.server_Die();
			}	
			else
			{
				HistoryBlock b( maptile, "", 0, tpos, historyblock.angle, historyblock.reversed);
				history.historyblocks[history.currentHistoryTimeline-1].insertAt(i,b);	
			}	

			getMap().server_SetTile(historyblock.pos , historyblock.tile);
			//SetTileFlags(getMap(), historyblock.pos, historyblock.angle, historyblock.reversed);
					

			CBlob@[] overlapping;
			getMap().getBlobsAtPosition(historyblock.pos, @overlapping);
			for(uint i = 0; i < overlapping.length; i++)
			{
				CBlob@ underblob = overlapping[i];
				if (underblob !is null && !underblob.hasTag("player") && !underblob.isAttached())
				{ 
					underblob.server_Die();
				}
			}			

			if (historyblock.name != "" && underblob is null)
			{					
				CBlob@ redoBlob = server_CreateBlob(historyblock.name, historyblock.team, historyblock.pos); // add team
				if (redoBlob !is null)
				{
					redoBlob.setAngleDegrees(historyblock.angle);
					redoBlob.getShape().SetStatic(true);
				}
			}		
		}
		history.historyblocks[history.currentHistoryTimeline-1].set_length(history.historyblocks[history.currentHistoryTimeline].length);		
	}	
}

