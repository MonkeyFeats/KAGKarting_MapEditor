//#define SERVER_ONLY

#include "AutoTile.as";

void onInit(CRules@ this)
{
	this.addCommandID("SetTileFlags");
	this.addCommandID("SmoothMap");
	this.addCommandID("AutoTile");
}
void onCommand(CRules@ this, u8 cmd, CBitStream@ params)
{
//	if (cmd == this.getCommandID("SmoothMap"))
//    {
//    	if (!getNet().isServer()) return;
//
//    	CMap@ map = getMap();
//    	u32 offset = params.read_u32();	
//    	
//		Vec2f tpos = map.getTileWorldPosition(offset);
//		AutoTile( map, offset, map.tilemapwidth, tpos);	
//	}

	if (cmd == this.getCommandID("AutoTile"))
    {
    	CMap@ map = getMap();
    	Vec2f tpos = params.read_Vec2f();
    	u16 buildtile = params.read_u16();
    	bool canAuto = params.read_bool();    	

    	if (!canAuto)
    	{
    		map.server_SetTile( tpos, getBlockType(buildtile));
    	}
    	else
    	{
			AutoTile( map, tpos, buildtile);

			AutoTile( map, tpos+Vec2f( 0,-8), 1);
			AutoTile( map, tpos+Vec2f(-8, 0), 1);
			AutoTile( map, tpos+Vec2f( 8, 0), 1);
			AutoTile( map, tpos+Vec2f( 0, 8), 1);

			AutoTile( map, tpos+Vec2f( -8,-8), 1);
			AutoTile( map, tpos+Vec2f(-8, 8), 1);
			AutoTile( map, tpos+Vec2f( 8, 8), 1);
			AutoTile( map, tpos+Vec2f( 8, -8), 1);
    	}
	}
    if (cmd == this.getCommandID("SetTileFlags"))
    {
        Vec2f tilepos = params.read_Vec2f();
        u16 angle = params.read_u16();
        bool reversed = params.read_bool();
        bool background = params.read_bool();

    	SetTileFlags(tilepos, angle, reversed, background);
    }
}

void SetTileFlags(Vec2f pos, u16 angle, bool reversed, bool background)
{
	CMap@ map = getMap();

	Vec2f tilespace = map.getTileSpacePosition(pos);
	const int offset = map.getTileOffsetFromTileSpace(tilespace);

	map.RemoveTileFlag(offset, Tile::MIRROR | Tile::FLIP | Tile::ROTATE | Tile::SPARE_0 | Tile::SOLID | Tile::COLLISION);

	if (reversed)
	{
		switch (angle/90)
		{
			case 0: {map.AddTileFlag(offset, Tile::SPARE_0 | Tile::MIRROR);} break;
			case 1: {map.AddTileFlag(offset, Tile::SPARE_0 | Tile::ROTATE| Tile::FLIP);} break;
			case 2: {map.AddTileFlag(offset, Tile::SPARE_0 | Tile::FLIP);} break;
			case 3: {map.AddTileFlag(offset, Tile::SPARE_0 | Tile::ROTATE | Tile::MIRROR);} break;
		}
	}
	else
	{
		switch (angle/90)
		{
			case 0: {} break;
			case 1: {map.AddTileFlag(offset, Tile::ROTATE);} break;
			case 2: {map.AddTileFlag(offset, Tile::FLIP | Tile::MIRROR);} break;
			case 3: {map.AddTileFlag(offset, Tile::ROTATE | Tile::FLIP | Tile::MIRROR);} break;
		}
	}

	map.AddTileFlag(offset, Tile::LIGHT_PASSES | Tile::LIGHT_SOURCE);

	if (background)
	{
		map.AddTileFlag(offset, Tile::BACKGROUND);
	}
}