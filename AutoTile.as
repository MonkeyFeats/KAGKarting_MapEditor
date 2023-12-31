
#include "KarPNGLoader.as";

u16 getBlockType(u16 type)
{	
	if ((type >= CMap::road && type <= CMap::road+3) || (type >= CMap::roadtograss && type <= CMap::roadtograss_7) || (type >= CMap::roadtosand && type <= CMap::roadtosand_7) || (type >= CMap::roadtodirt && type <= CMap::roadtodirt_7) || (type >= CMap::roadtowater && type <= CMap::roadtowater_7))
	{
		return CMap::road;
	}
	else if ((type >= CMap::grass && type <= CMap::grass+3) || (type >= CMap::grasstosand && type <= CMap::grasstosand_7) || (type >= CMap::grasstodirt && type <= CMap::grasstodirt_7) || (type >= CMap::grasstowater && type <= CMap::grasstowater_7)|| (type >= CMap::flowers_1 && type <= CMap::flowers_4))
	{
		return CMap::grass;
	}
	else if ((type >= CMap::sand && type <= CMap::sand+3) || (type >= CMap::sandtodirt && type <= CMap::sandtodirt_7) || (type >= CMap::sandtowater && type <= CMap::sandtowater_7))
	{
		return CMap::sand;
	}
	else if ((type >= CMap::dirt && type <= CMap::dirt+3) || (type >= CMap::dirttowater && type <= CMap::dirttowater_7))
	{
		return CMap::dirt;
	}
	else if ((type == CMap::rumbler) || (type >= CMap::rumblertograss && type <= CMap::rumblertograss_14) || (type >= CMap::rumblertoroad && type <= CMap::rumblertoroad_14) || (type >= CMap::rumblertosand && type <= CMap::rumblertosand_14) || (type >= CMap::rumblertodirt && type <= CMap::rumblertodirt_14))
	{
		return CMap::rumbler;
	}
	else if (type >= 752 && type <= 783)
	{
		return 752;
	}

	return type;
}

void AutoTile(CMap@ map, Vec2f tpos, uint buildtile)
{
	u16 t = map.tilesize;
	uint w = map.tilemapwidth;
	uint offset = map.getTileOffset(tpos);

	map.RemoveTileFlag(offset, Tile::MIRROR | Tile::FLIP | Tile::ROTATE | Tile::SPARE_0);

	u16 tile;

	if (buildtile == 1) 
	{ tile = getBlockType(map.getTile( tpos ).type); }
	else { tile =    getBlockType(buildtile); }

	u16 tile_R =  getBlockType(map.getTile( tpos+Vec2f(   t,    0)).type);
	u16 tile_RR = getBlockType(map.getTile( tpos+Vec2f( t+t,    0)).type);
	u16 tile_RU = getBlockType(map.getTile( tpos+Vec2f(   t,   -t)).type);
	u16 tile_U =  getBlockType(map.getTile( tpos+Vec2f(   0,   -t)).type);
	u16 tile_UU = getBlockType(map.getTile( tpos+Vec2f(   0,-(t+t))).type);
	u16 tile_LU = getBlockType(map.getTile( tpos+Vec2f(  -t,   -t)).type);
	u16 tile_L =  getBlockType(map.getTile( tpos+Vec2f(  -t,    0)).type);
	u16 tile_LL = getBlockType(map.getTile( tpos+Vec2f(-(t+t),  0)).type);
	u16 tile_LD = getBlockType(map.getTile( tpos+Vec2f(  -t,    t)).type);
	u16 tile_D =  getBlockType(map.getTile( tpos+Vec2f(   0,    t)).type);
	u16 tile_DD = getBlockType(map.getTile( tpos+Vec2f(   0,  t+t)).type);
	u16 tile_RD = getBlockType(map.getTile( tpos+Vec2f(   t,    t)).type);
	
	if (tile == CMap::sand) 
	{				
		//sandtodirt
		///// no side joins ///
		if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sand); //surrounded
		}
		/// one side joins ///
		else 
		if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::sand)
		{
			
		}	
		else if (tile_R == CMap::dirt  && tile_L == CMap::sand && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::sand  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::sand && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::sand  && tile_RR == CMap::dirt && tile_D == CMap::dirt && tile_RU == CMap::sand && tile_RD == CMap::dirt)
		{	
			if (tile_LU == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt)
			{					
				map.server_SetTile( tpos, CMap::sandtodirt+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::dirt && tile_U == CMap::sand && tile_RU == CMap::sand && tile_L == CMap::sand && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //br corner small left
		}				
		else if (tile_D == CMap::sand  && tile_DD == CMap::dirt && tile_R == CMap::dirt && tile_LD == CMap::sand && tile_RD == CMap::dirt)
		{
			if (tile_LU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 2); //half flat right
				map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);

			}
			else
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::dirt && tile_U == CMap::sand && tile_LD == CMap::sand && tile_L == CMap::sand && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::dirt && tile_U == CMap::sand && tile_LD == CMap::dirt && tile_L == CMap::sand && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::sand && tile_L == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::sandtodirt); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::sand  && tile_RR == CMap::dirt && tile_U == CMap::dirt && tile_RD == CMap::sand && tile_RU == CMap::dirt)
		{
			if (tile_LD == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand)
			{					
				map.server_SetTile( tpos, CMap::sandtodirt+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::dirt && tile_D == CMap::sand && tile_RD == CMap::sand && tile_L == CMap::sand && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::sand && tile_U == CMap::sand && tile_UU == CMap::dirt && tile_R == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::sand && tile_LU == CMap::sand && tile_L == CMap::sand && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::sand && tile_LU == CMap::dirt && tile_L == CMap::sand && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::sand && tile_D == CMap::sand && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::sand  && tile_LL == CMap::dirt && tile_D == CMap::dirt && tile_LU == CMap::sand && tile_LD == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::dirt && tile_U == CMap::sand && tile_LU == CMap::sand && tile_R == CMap::sand && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::sand  && tile_DD == CMap::dirt && tile_L == CMap::dirt && tile_RD == CMap::sand && tile_LD == CMap::dirt)
		{
			if (tile_RU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::sandtodirt+ 2); //half flat
			}
		}
		else if (tile_LU == CMap::dirt && tile_U == CMap::sand && tile_RD == CMap::sand && tile_R == CMap::sand && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::dirt && tile_U == CMap::sand && tile_RD == CMap::dirt && tile_R == CMap::sand && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::sand && tile_U == CMap::sand && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::sand  && tile_LL == CMap::dirt && tile_U == CMap::dirt && tile_LD == CMap::sand && tile_LU == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::dirt && tile_D == CMap::sand && tile_LD == CMap::sand  && tile_R == CMap::sand && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::dirt  && tile_U == CMap::dirt && tile_D == CMap::sand && tile_R == CMap::sand && tile_DD == CMap::dirt)
		{				
			map.server_SetTile( tpos, CMap::sandtodirt); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::sand && tile_U == CMap::sand && tile_UU == CMap::dirt && tile_L == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::dirt && tile_D == CMap::sand && tile_RU == CMap::sand  && tile_R == CMap::sand && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::dirt && tile_D == CMap::sand && tile_RU == CMap::dirt && tile_R == CMap::sand && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::sand && tile_D == CMap::sand && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::sandtodirt);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		//sandtowater
		/// no side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sand ); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 6 ); //single down
		}	
		else if (tile_R == CMap::water  && tile_L == CMap::sand && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 6 ); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::sand  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 6 ); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::sand && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 6 ); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::sand  && tile_RR == CMap::water && tile_D == CMap::water && tile_RU == CMap::sand && tile_RD == CMap::water)
		{	
			if (tile_LU == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::water)
			{					
				map.server_SetTile( tpos, CMap::sandtowater+ 2 ); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //br corner big left
			}
		}
		else if (tile_LD == CMap::water && tile_U == CMap::sand && tile_RU == CMap::sand && tile_L == CMap::sand && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //br corner small left
		}				
		else if (tile_D == CMap::sand  && tile_DD == CMap::water && tile_R == CMap::water && tile_LD == CMap::sand && tile_RD == CMap::water)
		{
			if (tile_LU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 2 ); //half flat right
				map.AddTileFlag( offset, Tile::MIRROR | Tile::ROTATE);
			}
			else
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::water && tile_U == CMap::sand && tile_LD == CMap::sand && tile_L == CMap::sand && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::water && tile_U == CMap::sand && tile_LD == CMap::water && tile_L == CMap::sand && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //br tiny corner big to big
		}
		else if ( tile_R == CMap::water && tile_D == CMap::water && tile_U == CMap::sand && tile_L == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::sandtowater ); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::sand  && tile_RR == CMap::water && tile_U == CMap::water && tile_RD == CMap::sand && tile_RU == CMap::water)
		{
			if (tile_LD == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand)
			{					
				map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 2 ); //half flat up
				map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::water && tile_D == CMap::sand && tile_RD == CMap::sand && tile_L == CMap::sand && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::sand && tile_U == CMap::sand && tile_UU == CMap::water && tile_R == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::sand && tile_LU == CMap::sand && tile_L == CMap::sand && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::sand && tile_LU == CMap::water && tile_L == CMap::sand && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::sand && tile_D == CMap::sand && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater );
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::sand  && tile_LL == CMap::water && tile_D == CMap::water && tile_LU == CMap::sand && tile_LD == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::water && tile_U == CMap::sand && tile_LU == CMap::sand && tile_R == CMap::sand && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::sand  && tile_DD == CMap::water && tile_L == CMap::water && tile_RD == CMap::sand && tile_LD == CMap::water)
		{
			if (tile_RU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 7 );
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::sandtowater+ 2 ); //half flat
			}
		}
		else if (tile_LU == CMap::water && tile_U == CMap::sand && tile_RD == CMap::sand && tile_R == CMap::sand && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::water && tile_U == CMap::sand && tile_RD == CMap::water && tile_R == CMap::sand && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::sand && tile_U == CMap::sand && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater );
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::sand  && tile_LL == CMap::water && tile_U == CMap::water && tile_LD == CMap::sand && tile_LU == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::water && tile_D == CMap::sand && tile_LD == CMap::sand  && tile_R == CMap::sand && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::water  && tile_U == CMap::water && tile_D == CMap::sand && tile_R == CMap::sand && tile_DD == CMap::water)
		{				
			map.server_SetTile( tpos, CMap::sandtowater ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::sand && tile_U == CMap::sand && tile_UU == CMap::water && tile_L == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 1 ); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::water && tile_D == CMap::sand && tile_RU == CMap::sand  && tile_R == CMap::sand && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 7 ); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::water && tile_D == CMap::sand && tile_RU == CMap::water && tile_R == CMap::sand && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::sand && tile_D == CMap::sand && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::sandtowater );
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}

		/// fill inner ///
		else
		{	
			map.server_SetTile( tpos, CMap::sand+ map_random.NextRanged(3));
			switch (map_random.NextRanged(6))
			{
				case 0: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR); break;
				case 1: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR | Tile::ROTATE); break;
				case 2: map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE); break;
				case 3: map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR); break;
				case 4: map.AddTileFlag( offset, Tile::ROTATE); break;
				case 5: break;
			}
		}
	}
	
	else if (tile == CMap::dirt) 
	{
		//dirttowater
		/// no side joins ///
		if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirt ); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 6 ); //single down
		}	
		else if (tile_R == CMap::water  && tile_L == CMap::dirt && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 6 ); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::dirt  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 6 ); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::dirt && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 6 ); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::dirt  && tile_RR == CMap::water && tile_D == CMap::water && tile_RU == CMap::dirt && tile_RD == CMap::water)
		{	
			if (tile_LU == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::water)
			{					
				map.server_SetTile( tpos, CMap::dirttowater+ 2 ); //half flat down
				map.AddTileFlag( offset, Tile::FLIP );
			}
			else
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //br corner big left
			}
		}
		else if (tile_LD == CMap::water && tile_U == CMap::dirt && tile_RU == CMap::dirt && tile_L == CMap::dirt && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //br corner small left
		}				
		else if (tile_D == CMap::dirt  && tile_DD == CMap::water && tile_R == CMap::water && tile_LD == CMap::dirt && tile_RD == CMap::water)
		{
			if (tile_LU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 2 ); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);				
			}
			else
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::water && tile_U == CMap::dirt && tile_LD == CMap::dirt && tile_L == CMap::dirt && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::water && tile_U == CMap::dirt && tile_LD == CMap::water && tile_L == CMap::dirt && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //br tiny corner big to big
		}
		else if ( tile_R == CMap::water && tile_D == CMap::water && tile_U == CMap::dirt && tile_L == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::dirttowater ); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::dirt  && tile_RR == CMap::water && tile_U == CMap::water && tile_RD == CMap::dirt && tile_RU == CMap::water)
		{
			if (tile_LD == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt)
			{					
				map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 2 ); //half flat up
				map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::water && tile_D == CMap::dirt && tile_RD == CMap::dirt && tile_L == CMap::dirt && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::dirt && tile_U == CMap::dirt && tile_UU == CMap::water && tile_R == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::dirt && tile_LU == CMap::dirt && tile_L == CMap::dirt && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::dirt && tile_LU == CMap::water && tile_L == CMap::dirt && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::dirt && tile_D == CMap::dirt && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater );
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::dirt  && tile_LL == CMap::water && tile_D == CMap::water && tile_LU == CMap::dirt && tile_LD == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::water && tile_U == CMap::dirt && tile_LU == CMap::dirt && tile_R == CMap::dirt && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::dirt  && tile_DD == CMap::water && tile_L == CMap::water && tile_RD == CMap::dirt && tile_LD == CMap::water)
		{
			if (tile_RU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 7 );
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::dirttowater+ 2 ); //half flat
			}
		}
		else if (tile_LU == CMap::water && tile_U == CMap::dirt && tile_RD == CMap::dirt && tile_R == CMap::dirt && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::water && tile_U == CMap::dirt && tile_RD == CMap::water && tile_R == CMap::dirt && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::dirt && tile_U == CMap::dirt && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater );
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::dirt  && tile_LL == CMap::water && tile_U == CMap::water && tile_LD == CMap::dirt && tile_LU == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::water && tile_D == CMap::dirt && tile_LD == CMap::dirt  && tile_R == CMap::dirt && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::water  && tile_U == CMap::water && tile_D == CMap::dirt && tile_R == CMap::dirt && tile_DD == CMap::water)
		{				
			map.server_SetTile( tpos, CMap::dirttowater ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::dirt && tile_U == CMap::dirt && tile_UU == CMap::water && tile_L == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 1 ); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::water && tile_D == CMap::dirt && tile_RU == CMap::dirt  && tile_R == CMap::dirt && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 7 ); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::water && tile_D == CMap::dirt && tile_RU == CMap::water && tile_R == CMap::dirt && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::dirt && tile_D == CMap::dirt && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::dirttowater );
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else
		{
			map.server_SetTile( tpos, CMap::dirt + map_random.NextRanged(3));
			switch (map_random.NextRanged(6))
			{
				case 0: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR); break;
				case 1: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR | Tile::ROTATE); break;
				case 2: map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE); break;
				case 3: map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR); break;
				case 4: map.AddTileFlag( offset, Tile::ROTATE); break;
				case 5: break;
			}
		}
	}
	else if (tile == CMap::grass) 
	{		
		//grasstodirt
		/// no side joins ///
		if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grass); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 6); //single down
		}	
		else if (tile_R == CMap::dirt  && tile_L == CMap::grass && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::grass  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::grass && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::grass  && tile_RR == CMap::dirt && tile_D == CMap::dirt && tile_RU == CMap::grass && tile_RD == CMap::dirt)
		{	
			if (tile_LU == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt)
			{					
				map.server_SetTile( tpos, CMap::grasstodirt+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::dirt && tile_U == CMap::grass && tile_RU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //br corner small left
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::dirt && tile_R == CMap::dirt && tile_LD == CMap::grass && tile_RD == CMap::dirt)
		{
			if (tile_LU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::dirt && tile_U == CMap::grass && tile_LD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::dirt && tile_U == CMap::grass && tile_LD == CMap::dirt && tile_L == CMap::grass && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::grass && tile_L == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstodirt); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::grass  && tile_RR == CMap::dirt && tile_U == CMap::dirt && tile_RD == CMap::grass && tile_RU == CMap::dirt)
		{
			if (tile_LD == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass)
			{					
				map.server_SetTile( tpos, CMap::grasstodirt+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::dirt && tile_D == CMap::grass && tile_RD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::dirt && tile_R == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::grass && tile_LU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::grass && tile_LU == CMap::dirt && tile_L == CMap::grass && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::grass && tile_D == CMap::grass && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::grass  && tile_LL == CMap::dirt && tile_D == CMap::dirt && tile_LU == CMap::grass && tile_LD == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::dirt && tile_U == CMap::grass && tile_LU == CMap::grass && tile_R == CMap::grass && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::dirt && tile_L == CMap::dirt && tile_RD == CMap::grass && tile_LD == CMap::dirt)
		{
			if (tile_RU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstodirt+ 2); //half flat
				map.AddTileFlag( offset, Tile::MIRROR );
			}
		}
		else if (tile_LU == CMap::dirt && tile_U == CMap::grass && tile_RD == CMap::grass && tile_R == CMap::grass && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::dirt && tile_U == CMap::grass && tile_RD == CMap::dirt && tile_R == CMap::grass && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::grass  && tile_LL == CMap::dirt && tile_U == CMap::dirt && tile_LD == CMap::grass && tile_LU == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::dirt && tile_D == CMap::grass && tile_LD == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::dirt  && tile_U == CMap::dirt && tile_D == CMap::grass && tile_R == CMap::grass && tile_DD == CMap::dirt)
		{				
			map.server_SetTile( tpos, CMap::grasstodirt); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::dirt && tile_L == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::dirt && tile_D == CMap::grass && tile_RU == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::dirt && tile_D == CMap::grass && tile_RU == CMap::dirt && tile_R == CMap::grass && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::grass && tile_D == CMap::grass && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::grasstodirt);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		//grasstosand
		/// no side joins ///
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grass ); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 6); //single down
		}	
		else if (tile_R == CMap::sand  && tile_L == CMap::grass && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);		
		}		
		else if (tile_R == CMap::grass  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::grass && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::grass  && tile_RR == CMap::sand && tile_D == CMap::sand && tile_RU == CMap::grass && tile_RD == CMap::sand)
		{	
			if (tile_LU == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand)
			{					
				map.server_SetTile( tpos, CMap::grasstosand+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::sand && tile_U == CMap::grass && tile_RU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //br corner small left
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::sand && tile_R == CMap::sand && tile_LD == CMap::grass && tile_RD == CMap::sand)
		{
			if (tile_LU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::sand && tile_U == CMap::grass && tile_LD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::sand && tile_U == CMap::grass && tile_LD == CMap::sand && tile_L == CMap::grass && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::sand && tile_D == CMap::sand && tile_U == CMap::grass && tile_L == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstosand); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::grass  && tile_RR == CMap::sand && tile_U == CMap::sand && tile_RD == CMap::grass && tile_RU == CMap::sand)
		{
			if (tile_LD == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass)
			{					
				map.server_SetTile( tpos, CMap::grasstosand+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 2); //half flat up
				map.AddTileFlag( offset, Tile::MIRROR |Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::sand && tile_D == CMap::grass && tile_RD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::sand && tile_R == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::grass && tile_LU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::grass && tile_LU == CMap::sand && tile_L == CMap::grass && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::grass && tile_D == CMap::grass && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::grass  && tile_LL == CMap::sand && tile_D == CMap::sand && tile_LU == CMap::grass && tile_LD == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::sand && tile_U == CMap::grass && tile_LU == CMap::grass && tile_R == CMap::grass && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::sand && tile_L == CMap::sand && tile_RD == CMap::grass && tile_LD == CMap::sand)
		{
			if (tile_RU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstosand+ 2); //half flat
			}
		}
		else if (tile_LU == CMap::sand && tile_U == CMap::grass && tile_RD == CMap::grass && tile_R == CMap::grass && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::sand && tile_U == CMap::grass && tile_RD == CMap::sand && tile_R == CMap::grass && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}
		/// top left ///
		else if (tile_L == CMap::grass  && tile_LL == CMap::sand && tile_U == CMap::sand && tile_LD == CMap::grass && tile_LU == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::sand && tile_D == CMap::grass && tile_LD == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::sand  && tile_U == CMap::sand && tile_D == CMap::grass && tile_R == CMap::grass && tile_DD == CMap::sand)
		{				
			map.server_SetTile( tpos, CMap::grasstosand); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::sand && tile_L == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::sand && tile_D == CMap::grass && tile_RU == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::sand && tile_D == CMap::grass && tile_RU == CMap::sand && tile_R == CMap::grass && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::grass && tile_D == CMap::grass && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::grasstosand);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		//grasstowater
		/// no side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grass ); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 6 ); //single down
		}	
		else if (tile_R == CMap::water  && tile_L == CMap::grass && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 6 ); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::grass  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 6 ); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::grass && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 6 ); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::grass  && tile_RR == CMap::water && tile_D == CMap::water && tile_RU == CMap::grass && tile_RD == CMap::water)
		{	
			if (tile_LU == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::water)
			{					
				map.server_SetTile( tpos, CMap::grasstowater+ 2 ); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //br corner big left
			}
		}
		else if (tile_LD == CMap::water && tile_U == CMap::grass && tile_RU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //br corner small left
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::water && tile_R == CMap::water && tile_LD == CMap::grass && tile_RD == CMap::water)
		{
			if (tile_LU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 2 ); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::water && tile_U == CMap::grass && tile_LD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::water && tile_U == CMap::grass && tile_LD == CMap::water && tile_L == CMap::grass && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //br tiny corner big to big
		}
		else if ( tile_R == CMap::water && tile_D == CMap::water && tile_U == CMap::grass && tile_L == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::grasstowater ); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::grass  && tile_RR == CMap::water && tile_U == CMap::water && tile_RD == CMap::grass && tile_RU == CMap::water)
		{
			if (tile_LD == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass)
			{					
				map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 2 ); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::water && tile_D == CMap::grass && tile_RD == CMap::grass && tile_L == CMap::grass && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::water && tile_R == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::grass && tile_LU == CMap::grass && tile_L == CMap::grass && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::grass && tile_LU == CMap::water && tile_L == CMap::grass && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::grass && tile_D == CMap::grass && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater );
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::grass  && tile_LL == CMap::water && tile_D == CMap::water && tile_LU == CMap::grass && tile_LD == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::water && tile_U == CMap::grass && tile_LU == CMap::grass && tile_R == CMap::grass && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::grass  && tile_DD == CMap::water && tile_L == CMap::water && tile_RD == CMap::grass && tile_LD == CMap::water)
		{
			if (tile_RU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 7 );
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::grasstowater+ 2 ); //half flat
			}
		}
		else if (tile_LU == CMap::water && tile_U == CMap::grass && tile_RD == CMap::grass && tile_R == CMap::grass && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::water && tile_U == CMap::grass && tile_RD == CMap::water && tile_R == CMap::grass && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater );
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::grass  && tile_LL == CMap::water && tile_U == CMap::water && tile_LD == CMap::grass && tile_LU == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::water && tile_D == CMap::grass && tile_LD == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::water  && tile_U == CMap::water && tile_D == CMap::grass && tile_R == CMap::grass && tile_DD == CMap::water)
		{				
			map.server_SetTile( tpos, CMap::grasstowater ); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::grass && tile_U == CMap::grass && tile_UU == CMap::water && tile_L == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 1 ); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::water && tile_D == CMap::grass && tile_RU == CMap::grass  && tile_R == CMap::grass && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 7 ); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::water && tile_D == CMap::grass && tile_RU == CMap::water && tile_R == CMap::grass && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater+ 4 ); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::grass && tile_D == CMap::grass && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::grasstowater );
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		/// fill inner ///
		else
		{	
			map.server_SetTile( tpos, CMap::grass + map_random.NextRanged(3));
			switch (map_random.NextRanged(6))
			{
				case 0: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR); break;
				case 1: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR | Tile::ROTATE); break;
				case 2: map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE); break;
				case 3: map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR); break;
				case 4: map.AddTileFlag( offset, Tile::ROTATE); break;
				case 5: break;
			}
		}

	}		

	else if (tile == CMap::road) 
	{		
		//roadtosand
		/// no side joins ///
		if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::road); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 6); //single down
		}	
		else if (tile_R == CMap::sand  && tile_L == CMap::road && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::road  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::road && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::road  && tile_RR == CMap::sand && tile_D == CMap::sand && tile_RU == CMap::road && tile_RD == CMap::sand)
		{	
			if (tile_LU == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand)
			{					
				map.server_SetTile( tpos, CMap::roadtosand+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::sand && tile_U == CMap::road && tile_RU == CMap::road && tile_L == CMap::road && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //br corner small left
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::sand && tile_R == CMap::sand && tile_LD == CMap::road && tile_RD == CMap::sand)
		{
			if (tile_LU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::sand && tile_U == CMap::road && tile_LD == CMap::road && tile_L == CMap::road && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::sand && tile_U == CMap::road && tile_LD == CMap::sand && tile_L == CMap::road && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::sand && tile_D == CMap::sand && tile_U == CMap::road && tile_L == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtosand); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::road  && tile_RR == CMap::sand && tile_U == CMap::sand && tile_RD == CMap::road && tile_RU == CMap::sand)
		{
			if (tile_LD == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::road)
			{					
				map.server_SetTile( tpos, CMap::roadtosand+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::sand && tile_D == CMap::road && tile_RD == CMap::road && tile_L == CMap::road && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::road && tile_U == CMap::road && tile_UU == CMap::sand && tile_R == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::road && tile_LU == CMap::road && tile_L == CMap::road && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::road && tile_LU == CMap::sand && tile_L == CMap::road && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::road && tile_D == CMap::road && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::sand && tile_D == CMap::sand && tile_LU == CMap::road && tile_LD == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::sand && tile_U == CMap::road && tile_LU == CMap::road && tile_R == CMap::road && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::sand && tile_L == CMap::sand && tile_RD == CMap::road && tile_LD == CMap::sand)
		{
			if (tile_RU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::road)
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtosand+ 2); //half flat
			}
		}
		else if (tile_LU == CMap::sand && tile_U == CMap::road && tile_RD == CMap::road && tile_R == CMap::road && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::sand && tile_U == CMap::road && tile_RD == CMap::sand && tile_R == CMap::road && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::sand && tile_U == CMap::sand && tile_LD == CMap::road && tile_LU == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::sand && tile_D == CMap::road && tile_LD == CMap::road  && tile_R == CMap::road && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::sand  && tile_U == CMap::sand && tile_D == CMap::road && tile_R == CMap::road && tile_DD == CMap::sand)
		{				
			map.server_SetTile( tpos, CMap::roadtosand); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_UU == CMap::sand && tile_L == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::sand && tile_D == CMap::road && tile_RU == CMap::road  && tile_R == CMap::road && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::sand && tile_D == CMap::road && tile_RU == CMap::sand && tile_R == CMap::road && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::road && tile_D == CMap::road && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::roadtosand);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		//roadtowater
		/// no side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::road); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 6); //single down
		}	
		else if (tile_R == CMap::water  && tile_L == CMap::road && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::road  && tile_L == CMap::water && tile_D == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::water  && tile_L == CMap::water && tile_D == CMap::road && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::road  && tile_RR == CMap::water && tile_D == CMap::water && tile_RU == CMap::road && tile_RD == CMap::water)
		{	
			if (tile_LU == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::water)
			{					
				map.server_SetTile( tpos, CMap::roadtowater+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::water && tile_U == CMap::road && tile_RU == CMap::road && tile_L == CMap::road && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //br corner small left
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::water && tile_R == CMap::water && tile_LD == CMap::road && tile_RD == CMap::water)
		{
			if (tile_LU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::water && tile_U == CMap::road && tile_LD == CMap::road && tile_L == CMap::road && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::water && tile_U == CMap::road && tile_LD == CMap::water && tile_L == CMap::road && tile_R == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::water && tile_D == CMap::water && tile_U == CMap::road && tile_L == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtowater); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::road  && tile_RR == CMap::water && tile_U == CMap::water && tile_RD == CMap::road && tile_RU == CMap::water)
		{
			if (tile_LD == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::water && tile_L == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::road)
			{					
				map.server_SetTile( tpos, CMap::roadtowater+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::water && tile_D == CMap::road && tile_RD == CMap::road && tile_L == CMap::road && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::road && tile_U == CMap::road && tile_UU == CMap::water && tile_R == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::road && tile_LU == CMap::road && tile_L == CMap::road && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::water && tile_D == CMap::road && tile_LU == CMap::water && tile_L == CMap::road && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::road && tile_D == CMap::road && tile_R == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::water && tile_D == CMap::water && tile_LU == CMap::road && tile_LD == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::water && tile_U == CMap::road && tile_LU == CMap::road && tile_R == CMap::road && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::water && tile_L == CMap::water && tile_RD == CMap::road && tile_LD == CMap::water)
		{
			if (tile_RU == CMap::water && tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::water)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::road)
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtowater+ 2); //half flat
			}
		}
		else if (tile_LU == CMap::water && tile_U == CMap::road && tile_RD == CMap::road && tile_R == CMap::road && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::water && tile_U == CMap::road && tile_RD == CMap::water && tile_R == CMap::road && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_L == CMap::water && tile_D == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::water && tile_U == CMap::water && tile_LD == CMap::road && tile_LU == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::water && tile_D == CMap::road && tile_LD == CMap::road  && tile_R == CMap::road && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::water  && tile_U == CMap::water && tile_D == CMap::road && tile_R == CMap::road && tile_DD == CMap::water)
		{				
			map.server_SetTile( tpos, CMap::roadtowater); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_UU == CMap::water && tile_L == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::water && tile_D == CMap::road && tile_RU == CMap::road  && tile_R == CMap::road && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::water && tile_D == CMap::road && tile_RU == CMap::water && tile_R == CMap::road && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::road && tile_D == CMap::road && tile_L == CMap::water && tile_U == CMap::water)
		{
			map.server_SetTile( tpos, CMap::roadtowater);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		//roadtodirt
		/// no side joins ///
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::road); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 6); //single down
		}	
		else if (tile_R == CMap::dirt  && tile_L == CMap::road && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::road  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::road && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::road  && tile_RR == CMap::dirt && tile_D == CMap::dirt && tile_RU == CMap::road && tile_RD == CMap::dirt)
		{	
			if (tile_LU == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt)
			{					
				map.server_SetTile( tpos, CMap::roadtodirt+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::dirt && tile_U == CMap::road && tile_RU == CMap::road && tile_L == CMap::road && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //br corner small left
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::dirt && tile_R == CMap::dirt && tile_LD == CMap::road && tile_RD == CMap::dirt)
		{
			if (tile_LU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::dirt && tile_U == CMap::road && tile_LD == CMap::road && tile_L == CMap::road && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::dirt && tile_U == CMap::road && tile_LD == CMap::dirt && tile_L == CMap::road && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::road && tile_L == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtodirt); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::road  && tile_RR == CMap::dirt && tile_U == CMap::dirt && tile_RD == CMap::road && tile_RU == CMap::dirt)
		{
			if (tile_LD == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::road)
			{					
				map.server_SetTile( tpos, CMap::roadtodirt+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 2); //half flat up
				map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::dirt && tile_D == CMap::road && tile_RD == CMap::road && tile_L == CMap::road && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::road && tile_U == CMap::road && tile_UU == CMap::dirt && tile_R == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::road && tile_LU == CMap::road && tile_L == CMap::road && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::road && tile_LU == CMap::dirt && tile_L == CMap::road && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::road && tile_D == CMap::road && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::dirt && tile_D == CMap::dirt && tile_LU == CMap::road && tile_LD == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::dirt && tile_U == CMap::road && tile_LU == CMap::road && tile_R == CMap::road && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::dirt && tile_L == CMap::dirt && tile_RD == CMap::road && tile_LD == CMap::dirt)
		{
			if (tile_RU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::road)
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtodirt+ 2); //half flat
				map.AddTileFlag( offset, Tile::MIRROR );
			}
		}
		else if (tile_LU == CMap::dirt && tile_U == CMap::road && tile_RD == CMap::road && tile_R == CMap::road && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::dirt && tile_U == CMap::road && tile_RD == CMap::dirt && tile_R == CMap::road && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::dirt && tile_U == CMap::dirt && tile_LD == CMap::road && tile_LU == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::dirt && tile_D == CMap::road && tile_LD == CMap::road  && tile_R == CMap::road && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::dirt  && tile_U == CMap::dirt && tile_D == CMap::road && tile_R == CMap::road && tile_DD == CMap::dirt)
		{				
			map.server_SetTile( tpos, CMap::roadtodirt); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_UU == CMap::dirt && tile_L == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::dirt && tile_D == CMap::road && tile_RU == CMap::road  && tile_R == CMap::road && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::dirt && tile_D == CMap::road && tile_RU == CMap::dirt && tile_R == CMap::road && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::road && tile_D == CMap::road && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::roadtodirt);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		// roadtograss
		/// no side joins ///
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::road); //surrounded
		}
		//// one side joins ///
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 6); //single down
		}	
		else if (tile_R == CMap::grass  && tile_L == CMap::road && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::road  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::road && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::road  && tile_RR == CMap::grass && tile_D == CMap::grass && tile_RU == CMap::road && tile_RD == CMap::grass)
		{	
			if (tile_LU == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass)
			{					
				map.server_SetTile( tpos, CMap::roadtograss+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::grass && tile_U == CMap::road && tile_RU == CMap::road && tile_L == CMap::road && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //br corner small left
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::grass && tile_R == CMap::grass && tile_LD == CMap::road && tile_RD == CMap::grass)
		{
			if (tile_LU == CMap::grass && tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::grass && tile_U == CMap::road && tile_LD == CMap::road && tile_L == CMap::road && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::grass && tile_U == CMap::road && tile_LD == CMap::grass && tile_L == CMap::road && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::grass && tile_D == CMap::grass && tile_U == CMap::road && tile_L == CMap::road)
		{
			map.server_SetTile( tpos, CMap::roadtograss); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::road  && tile_RR == CMap::grass && tile_U == CMap::grass && tile_RD == CMap::road && tile_RU == CMap::grass)
		{
			if (tile_LD == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::road)
			{					
				map.server_SetTile( tpos, CMap::roadtograss+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::grass && tile_D == CMap::road && tile_RD == CMap::road && tile_L == CMap::road && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::road && tile_U == CMap::road && tile_UU == CMap::grass && tile_R == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::grass && tile_D == CMap::road && tile_LU == CMap::road && tile_L == CMap::road && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::grass && tile_D == CMap::road && tile_LU == CMap::grass && tile_L == CMap::road && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::road && tile_D == CMap::road && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::grass && tile_D == CMap::grass && tile_LU == CMap::road && tile_LD == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::grass && tile_U == CMap::road && tile_LU == CMap::road && tile_R == CMap::road && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::road  && tile_DD == CMap::grass && tile_L == CMap::grass && tile_RD == CMap::road && tile_LD == CMap::grass)
		{
			if (tile_RU == CMap::grass && tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::road)
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::roadtograss+ 2); //half flat
				map.AddTileFlag( offset, Tile::ROTATE);
			}
		}
		else if (tile_LU == CMap::grass && tile_U == CMap::road && tile_RD == CMap::road && tile_R == CMap::road && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::grass && tile_U == CMap::road && tile_RD == CMap::grass && tile_R == CMap::road && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::road  && tile_LL == CMap::grass && tile_U == CMap::grass && tile_LD == CMap::road && tile_LU == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::grass && tile_D == CMap::road && tile_LD == CMap::road  && tile_R == CMap::road && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::grass  && tile_U == CMap::grass && tile_D == CMap::road && tile_R == CMap::road && tile_DD == CMap::grass)
		{				
			map.server_SetTile( tpos, CMap::roadtograss); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::road && tile_U == CMap::road && tile_UU == CMap::grass && tile_L == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::grass && tile_D == CMap::road && tile_RU == CMap::road  && tile_R == CMap::road && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::grass && tile_D == CMap::road && tile_RU == CMap::grass && tile_R == CMap::road && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::road && tile_D == CMap::road && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::roadtograss);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}

		/// fill inner ///
		else
		{					
			map.server_SetTile( tpos, CMap::road+ map_random.NextRanged(3));
			switch (map_random.NextRanged(6))
			{
				case 0: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR); break;
				case 1: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR | Tile::ROTATE); break;
				case 2: map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE); break;
				case 3: map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR); break;
				case 4: map.AddTileFlag( offset, Tile::ROTATE); break;
				case 5: break;
			}
		}

	}
	else if (tile == CMap::rumbler) 
	{
		// tiny rumbler between road and grass					
		if (tile_L == CMap::road  && tile_R == CMap::grass && tile_D == CMap::rumbler && tile_DD == CMap::road && tile_U == CMap::rumbler && tile_UU == CMap::grass)
		{
			map.server_SetTile( tpos, offset % 2 == 0 ? CMap::rumblertoroad+15 : CMap::rumblertograss+15); //road to rumbler to grass \			 
		}	
		else if (tile_L == CMap::grass  && tile_R == CMap::road && tile_U == CMap::rumbler && tile_UU == CMap::road && tile_U == CMap::rumbler && tile_DD == CMap::grass)
		{
			map.server_SetTile( tpos, offset % 2 == 0 ? CMap::rumblertograss+15 : CMap::rumblertoroad+15); //grass to rumbler to road \	
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP);		 
		}				
		else if (tile_L == CMap::grass  && tile_R == CMap::road && tile_U == CMap::rumbler && tile_UU == CMap::grass && tile_U == CMap::rumbler && tile_DD == CMap::road)
		{
			map.server_SetTile( tpos, offset % 2 != 0 ? CMap::rumblertograss+15 : CMap::rumblertoroad+15); //grass to rumbler to road /	
			map.AddTileFlag( offset, Tile::MIRROR);		 
		}				
		else if (tile_L == CMap::road  && tile_R == CMap::grass && tile_D == CMap::rumbler && tile_DD == CMap::grass && tile_U == CMap::rumbler && tile_UU == CMap::road)
		{
			map.server_SetTile( tpos, offset % 2 == 0 ? CMap::rumblertograss+15 : CMap::rumblertoroad+15); //road to rumbler to grass /	
			map.AddTileFlag( offset, Tile::FLIP);		 
		}
		//rumbler to grass //
		// half half enders
		else if (tile_R == CMap::rumbler  && tile_RR == CMap::grass && tile_L == CMap::rumbler  && tile_LL == CMap::grass && tile_D == CMap::rumbler && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+13 : CMap::rumblertograss+12 ); //up flat
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}	
		else if (tile_R == CMap::rumbler  && tile_L == CMap::grass && tile_D == CMap::rumbler && tile_DD == CMap::grass && tile_U == CMap::rumbler && tile_UU == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::rumblertograss+14); //left flat
			map.AddTileFlag( offset, Tile::MIRROR);
			if (offset % 2 != 0)				 
			map.AddTileFlag( offset, Tile::FLIP);
		}		
		else if (tile_R == CMap::grass  && tile_L == CMap::rumbler && tile_D == CMap::rumbler && tile_DD == CMap::grass && tile_U == CMap::rumbler && tile_UU == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::rumblertograss+14); //right flat				
			if (offset % 2 != 0)				 
			map.AddTileFlag( offset, Tile::FLIP);
		}				
		else if (tile_R == CMap::rumbler && tile_RR == CMap::grass && tile_L == CMap::rumbler && tile_LL == CMap::grass && tile_D == CMap::grass && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+13 : CMap::rumblertograss+12 ); //down flat
			map.AddTileFlag( offset, Tile::ROTATE);
		}
		// bottom right ///
		else if (tile_R == CMap::rumbler  && tile_RR == CMap::grass && tile_D == CMap::grass && tile_RU == CMap::rumbler && tile_RD == CMap::grass  && tile_L == CMap::rumbler)
		{				
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+5 : CMap::rumblertograss+4 ); //bl corner big left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}
		else if (tile_LD == CMap::grass && tile_U == CMap::rumbler && tile_RU == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+9 : CMap::rumblertograss+8 ); //bl corner small left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}				
		else if (tile_D == CMap::rumbler  && tile_DD == CMap::grass && tile_R == CMap::grass && tile_LD == CMap::rumbler && tile_RD == CMap::grass && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+3 : CMap::rumblertograss+2 ); //bl corner big up			
		}
		else if (tile_RU == CMap::grass && tile_U == CMap::rumbler && tile_LD == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+7 : CMap::rumblertograss+6 ); //bl corner small up
		}				
		else if (tile_RU == CMap::grass && tile_U == CMap::rumbler && tile_LD == CMap::grass && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+11 : CMap::rumblertograss+10 ); //bl corner tiny
		}
		else if (tile_L == CMap::rumbler && tile_U == CMap::rumbler && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+1 : CMap::rumblertograss);
		}
		//// top right ////
		else if (tile_R == CMap::rumbler && tile_RR == CMap::grass && tile_U == CMap::grass && tile_RD == CMap::rumbler && tile_RU == CMap::grass && tile_L == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+5 : CMap::rumblertograss+4 ); //tr corner big left
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
		}
		else if (tile_LU == CMap::grass && tile_D == CMap::rumbler && tile_RD == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+9 : CMap::rumblertograss+8 ); //tr corner small left
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
		}				
		else if (tile_U == CMap::rumbler && tile_UU == CMap::grass && tile_R == CMap::grass && tile_LU == CMap::rumbler && tile_RU == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+3 : CMap::rumblertograss+2 ); //tr corner big up
			map.AddTileFlag( offset, Tile::FLIP );				
		}
		else if (tile_RD == CMap::grass && tile_D == CMap::rumbler && tile_LU == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+7 : CMap::rumblertograss+6 ); //tr corner small up
			map.AddTileFlag( offset, Tile::FLIP );
		}				
		else if (tile_RD == CMap::grass && tile_D == CMap::rumbler && tile_LU == CMap::grass && tile_L == CMap::rumbler && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+11 : CMap::rumblertograss+10 ); //tr corner tiny
				map.AddTileFlag( offset, Tile::FLIP );
		}
		else if (tile_L == CMap::rumbler && tile_D == CMap::rumbler && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+1 : CMap::rumblertograss);
			map.AddTileFlag( offset, Tile::FLIP); //bl half half
		}
		/// bottom left ///
		else if (tile_L == CMap::rumbler && tile_LL == CMap::grass && tile_D == CMap::grass && tile_LU == CMap::rumbler && tile_LD == CMap::grass && tile_U == CMap::rumbler)
		{				
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+5 : CMap::rumblertograss+4 ); //bl corner big right
			map.AddTileFlag( offset, Tile::ROTATE);
		}
		else if (tile_RD == CMap::grass && tile_U == CMap::rumbler && tile_LU == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+9 : CMap::rumblertograss+8 ); //bl corner small right
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_D == CMap::rumbler && tile_DD == CMap::grass && tile_L == CMap::grass && tile_RD == CMap::rumbler && tile_LD == CMap::grass && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+3 : CMap::rumblertograss+2 ); //bl corner big up
			map.AddTileFlag( offset, Tile::MIRROR );				
		}
		else if (tile_LU == CMap::grass && tile_U == CMap::rumbler && tile_RD == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+7 : CMap::rumblertograss+6 ); //bl corner small up
			map.AddTileFlag( offset, Tile::MIRROR );
		}				
		else if (tile_LU == CMap::grass && tile_U == CMap::rumbler && tile_RD == CMap::grass && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+11 : CMap::rumblertograss+10 ); //bl corner tiny
			map.AddTileFlag( offset, Tile::MIRROR );
		}
		else if (tile_R == CMap::rumbler && tile_U == CMap::rumbler && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertograss+1 : CMap::rumblertograss);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half diagonal
		}
		/// top left ///
		else if (tile_L == CMap::rumbler && tile_LL == CMap::grass && tile_U == CMap::grass && tile_LD == CMap::rumbler && tile_LU == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+5 : CMap::rumblertograss+4 ); //tl corner big right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}
		else if (tile_RU == CMap::grass && tile_D == CMap::rumbler && tile_LD == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+9 : CMap::rumblertograss+8 ); //tl corner small right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_U == CMap::rumbler && tile_UU == CMap::grass && tile_L == CMap::grass && tile_RU == CMap::rumbler && tile_LU == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+3 : CMap::rumblertograss+2 ); //tl corner big up
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );				
		}
		else if (tile_LD == CMap::grass && tile_D == CMap::rumbler && tile_RU == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+7 : CMap::rumblertograss+6 ); //tl corner small up
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
		}				
		else if (tile_LD == CMap::grass && tile_D == CMap::rumbler && tile_RU == CMap::grass && tile_R == CMap::rumbler && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+11 : CMap::rumblertograss+10 ); //tl corner tiny
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
		}
		else if (tile_R == CMap::rumbler && tile_D == CMap::rumbler && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertograss+1 : CMap::rumblertograss);
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP); //tl half half
		}
		// rumbler to road //
		else if (tile_R == CMap::rumbler  && tile_RR == CMap::road && tile_L == CMap::rumbler  && tile_LL == CMap::road && tile_D == CMap::rumbler && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+13 : CMap::rumblertoroad+12 ); //up flat
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}	
		else if (tile_R == CMap::rumbler  && tile_L == CMap::road && tile_D == CMap::rumbler && tile_DD == CMap::road && tile_U == CMap::rumbler && tile_UU == CMap::road)
		{
			map.server_SetTile( tpos, CMap::rumblertoroad+14); //left flat
			map.AddTileFlag( offset, Tile::MIRROR);
			if (offset % 2 != 0)				 
			map.AddTileFlag( offset, Tile::FLIP);
		}		
		else if (tile_R == CMap::road  && tile_L == CMap::rumbler && tile_D == CMap::rumbler && tile_DD == CMap::road && tile_U == CMap::rumbler && tile_UU == CMap::road)
		{
			map.server_SetTile( tpos, CMap::rumblertoroad+14); //right flat				
			if (offset % 2 != 0)				 
			map.AddTileFlag( offset, Tile::FLIP);
		}				
		else if (tile_R == CMap::rumbler && tile_RR == CMap::road && tile_L == CMap::rumbler && tile_LL == CMap::road && tile_D == CMap::road && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+13 : CMap::rumblertoroad+12 ); //down flat
			map.AddTileFlag( offset, Tile::ROTATE);
		}
		// bottom right ///
		else if (tile_R == CMap::rumbler  && tile_RR == CMap::road && tile_D == CMap::road && tile_RU == CMap::rumbler && tile_RD == CMap::road  && tile_L == CMap::rumbler)
		{				
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+5 : CMap::rumblertoroad+4 ); //bl corner big left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}
		else if (tile_LD == CMap::road && tile_U == CMap::rumbler && tile_RU == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+9 : CMap::rumblertoroad+8 ); //bl corner small left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}				
		else if (tile_D == CMap::rumbler  && tile_DD == CMap::road && tile_R == CMap::road && tile_LD == CMap::rumbler && tile_RD == CMap::road && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+3 : CMap::rumblertoroad+2 ); //bl corner big up			
		}
		else if (tile_RU == CMap::road && tile_U == CMap::rumbler && tile_LD == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+7 : CMap::rumblertoroad+6 ); //bl corner small up
		}				
		else if (tile_RU == CMap::road && tile_U == CMap::rumbler && tile_LD == CMap::road && tile_L == CMap::rumbler && tile_R == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+11 : CMap::rumblertoroad+10 ); //bl corner tiny
		}
		else if (tile_L == CMap::rumbler && tile_U == CMap::rumbler && tile_R == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+1 : CMap::rumblertoroad);
		}
		//// top right ////
		else if (tile_R == CMap::rumbler && tile_RR == CMap::road && tile_U == CMap::road && tile_RD == CMap::rumbler && tile_RU == CMap::road && tile_L == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+5 : CMap::rumblertoroad+4 ); //tr corner big left
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
		}
		else if (tile_LU == CMap::road && tile_D == CMap::rumbler && tile_RD == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+9 : CMap::rumblertoroad+8 ); //tr corner small left
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
		}				
		else if (tile_U == CMap::rumbler && tile_UU == CMap::road && tile_R == CMap::road && tile_LU == CMap::rumbler && tile_RU == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+3 : CMap::rumblertoroad+2 ); //tr corner big up
			map.AddTileFlag( offset, Tile::FLIP );				
		}
		else if (tile_RD == CMap::road && tile_D == CMap::rumbler && tile_LU == CMap::rumbler && tile_L == CMap::rumbler && tile_R == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+7 : CMap::rumblertoroad+6 ); //tr corner small up
			map.AddTileFlag( offset, Tile::FLIP );
		}				
		else if (tile_RD == CMap::road && tile_D == CMap::rumbler && tile_LU == CMap::road && tile_L == CMap::rumbler && tile_R == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+11 : CMap::rumblertoroad+10 ); //tr corner tiny
				map.AddTileFlag( offset, Tile::FLIP );
		}
		else if (tile_L == CMap::rumbler && tile_D == CMap::rumbler && tile_R == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+1 : CMap::rumblertoroad);
			map.AddTileFlag( offset, Tile::FLIP); //bl half half
		}
		/// bottom left ///
		else if (tile_L == CMap::rumbler && tile_LL == CMap::road && tile_D == CMap::road && tile_LU == CMap::rumbler && tile_LD == CMap::road && tile_U == CMap::rumbler)
		{				
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+5 : CMap::rumblertoroad+4 ); //bl corner big right
			map.AddTileFlag( offset, Tile::ROTATE);
		}
		else if (tile_RD == CMap::road && tile_U == CMap::rumbler && tile_LU == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+9 : CMap::rumblertoroad+8 ); //bl corner small right
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_D == CMap::rumbler && tile_DD == CMap::road && tile_L == CMap::road && tile_RD == CMap::rumbler && tile_LD == CMap::road && tile_U == CMap::rumbler)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+3 : CMap::rumblertoroad+2 ); //bl corner big up
			map.AddTileFlag( offset, Tile::MIRROR );				
		}
		else if (tile_LU == CMap::road && tile_U == CMap::rumbler && tile_RD == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+7 : CMap::rumblertoroad+6 ); //bl corner small up
			map.AddTileFlag( offset, Tile::MIRROR );
		}				
		else if (tile_LU == CMap::road && tile_U == CMap::rumbler && tile_RD == CMap::road && tile_R == CMap::rumbler && tile_L == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+11 : CMap::rumblertoroad+10 ); //bl corner tiny
			map.AddTileFlag( offset, Tile::MIRROR );
		}
		else if (tile_R == CMap::rumbler && tile_U == CMap::rumbler && tile_L == CMap::road && tile_D == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 != 0) ? CMap::rumblertoroad+1 : CMap::rumblertoroad);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half diagonal
		}
		/// top left ///
		else if (tile_L == CMap::rumbler && tile_LL == CMap::road && tile_U == CMap::road && tile_LD == CMap::rumbler && tile_LU == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+5 : CMap::rumblertoroad+4 ); //tl corner big right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}
		else if (tile_RU == CMap::road && tile_D == CMap::rumbler && tile_LD == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+9 : CMap::rumblertoroad+8 ); //tl corner small right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_U == CMap::rumbler && tile_UU == CMap::road && tile_L == CMap::road && tile_RU == CMap::rumbler && tile_LU == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+3 : CMap::rumblertoroad+2 ); //tl corner big up
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );				
		}
		else if (tile_LD == CMap::road && tile_D == CMap::rumbler && tile_RU == CMap::rumbler && tile_R == CMap::rumbler && tile_L == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+7 : CMap::rumblertoroad+6 ); //tl corner small up
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
		}				
		else if (tile_LD == CMap::road && tile_D == CMap::rumbler && tile_RU == CMap::road && tile_R == CMap::rumbler && tile_L == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+11 : CMap::rumblertoroad+10 ); //tl corner tiny
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
		}
		else if (tile_R == CMap::rumbler && tile_D == CMap::rumbler && tile_L == CMap::road && tile_U == CMap::road)
		{
			map.server_SetTile( tpos, (offset % 2 == 0) ? CMap::rumblertoroad+1 : CMap::rumblertoroad);
			map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP); //tl half half
		}
		// full filled //
		else
		{	
			map.server_SetTile( tpos, CMap::rumbler );
			if (offset % 2 == 0)
			{
				map.AddTileFlag( offset, Tile::FLIP);
			}
		}

	}
	else if (tile == CMap::bushes) 
	{		
		//bushestosand
		/// no side joins ///
		if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushes); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 6); //single down
		}	
		else if (tile_R == CMap::sand  && tile_L == CMap::bushes && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::bushes  && tile_L == CMap::sand && tile_D == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::sand  && tile_L == CMap::sand && tile_D == CMap::bushes && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::bushes  && tile_RR == CMap::sand && tile_D == CMap::sand && tile_RU == CMap::bushes && tile_RD == CMap::sand)
		{	
			if (tile_LU == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand)
			{					
				map.server_SetTile( tpos, CMap::bushestosand+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::sand && tile_U == CMap::bushes && tile_RU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //br corner small left
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::sand && tile_R == CMap::sand && tile_LD == CMap::bushes && tile_RD == CMap::sand)
		{
			if (tile_LU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::sand && tile_U == CMap::bushes && tile_LD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::sand && tile_U == CMap::bushes && tile_LD == CMap::sand && tile_L == CMap::bushes && tile_R == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::sand && tile_D == CMap::sand && tile_U == CMap::bushes && tile_L == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestosand); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::bushes  && tile_RR == CMap::sand && tile_U == CMap::sand && tile_RD == CMap::bushes && tile_RU == CMap::sand)
		{
			if (tile_LD == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::sand && tile_L == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::bushes)
			{					
				map.server_SetTile( tpos, CMap::bushestosand+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::sand && tile_D == CMap::bushes && tile_RD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::sand && tile_R == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::bushes && tile_LU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::sand && tile_D == CMap::bushes && tile_LU == CMap::sand && tile_L == CMap::bushes && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::bushes && tile_D == CMap::bushes && tile_R == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::sand && tile_D == CMap::sand && tile_LU == CMap::bushes && tile_LD == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::sand && tile_U == CMap::bushes && tile_LU == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::sand && tile_L == CMap::sand && tile_RD == CMap::bushes && tile_LD == CMap::sand)
		{
			if (tile_RU == CMap::sand && tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::sand)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::bushes)
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestosand+ 2); //half flat
			}
		}
		else if (tile_LU == CMap::sand && tile_U == CMap::bushes && tile_RD == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::sand && tile_U == CMap::bushes && tile_RD == CMap::sand && tile_R == CMap::bushes && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_L == CMap::sand && tile_D == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::sand && tile_U == CMap::sand && tile_LD == CMap::bushes && tile_LU == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::sand && tile_D == CMap::bushes && tile_LD == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::sand  && tile_U == CMap::sand && tile_D == CMap::bushes && tile_R == CMap::bushes && tile_DD == CMap::sand)
		{				
			map.server_SetTile( tpos, CMap::bushestosand); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::sand && tile_L == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::sand && tile_D == CMap::bushes && tile_RU == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::sand && tile_D == CMap::bushes && tile_RU == CMap::sand && tile_R == CMap::bushes && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::bushes && tile_D == CMap::bushes && tile_L == CMap::sand && tile_U == CMap::sand)
		{
			map.server_SetTile( tpos, CMap::bushestosand);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		
		//bushestodirt
		/// no side joins ///
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushes); //surrounded
		}
		/// one side joins ///
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 6); //single down
		}	
		else if (tile_R == CMap::dirt  && tile_L == CMap::bushes && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::bushes  && tile_L == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::dirt  && tile_L == CMap::dirt && tile_D == CMap::bushes && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::bushes  && tile_RR == CMap::dirt && tile_D == CMap::dirt && tile_RU == CMap::bushes && tile_RD == CMap::dirt)
		{	
			if (tile_LU == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt)
			{					
				map.server_SetTile( tpos, CMap::bushestodirt+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::dirt && tile_U == CMap::bushes && tile_RU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //br corner small left
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::dirt && tile_R == CMap::dirt && tile_LD == CMap::bushes && tile_RD == CMap::dirt)
		{
			if (tile_LU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::dirt && tile_U == CMap::bushes && tile_LD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::dirt && tile_U == CMap::bushes && tile_LD == CMap::dirt && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::dirt && tile_D == CMap::dirt && tile_U == CMap::bushes && tile_L == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestodirt); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::bushes  && tile_RR == CMap::dirt && tile_U == CMap::dirt && tile_RD == CMap::bushes && tile_RU == CMap::dirt)
		{
			if (tile_LD == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::dirt && tile_L == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::bushes)
			{					
				map.server_SetTile( tpos, CMap::bushestodirt+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 2); //half flat up
				map.AddTileFlag( offset, Tile::MIRROR | Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::dirt && tile_D == CMap::bushes && tile_RD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::dirt && tile_R == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::bushes && tile_LU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::dirt && tile_D == CMap::bushes && tile_LU == CMap::dirt && tile_L == CMap::bushes && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::bushes && tile_D == CMap::bushes && tile_R == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::dirt && tile_D == CMap::dirt && tile_LU == CMap::bushes && tile_LD == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::dirt && tile_U == CMap::bushes && tile_LU == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::dirt && tile_L == CMap::dirt && tile_RD == CMap::bushes && tile_LD == CMap::dirt)
		{
			if (tile_RU == CMap::dirt && tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::dirt)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::bushes)
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestodirt+ 2); //half flat
				map.AddTileFlag( offset, Tile::MIRROR );
			}
		}
		else if (tile_LU == CMap::dirt && tile_U == CMap::bushes && tile_RD == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::dirt && tile_U == CMap::bushes && tile_RD == CMap::dirt && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_L == CMap::dirt && tile_D == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::dirt && tile_U == CMap::dirt && tile_LD == CMap::bushes && tile_LU == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::dirt && tile_D == CMap::bushes && tile_LD == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::dirt  && tile_U == CMap::dirt && tile_D == CMap::bushes && tile_R == CMap::bushes && tile_DD == CMap::dirt)
		{				
			map.server_SetTile( tpos, CMap::bushestodirt); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::dirt && tile_L == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::dirt && tile_D == CMap::bushes && tile_RU == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::dirt && tile_D == CMap::bushes && tile_RU == CMap::dirt && tile_R == CMap::bushes && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::bushes && tile_D == CMap::bushes && tile_L == CMap::dirt && tile_U == CMap::dirt)
		{
			map.server_SetTile( tpos, CMap::bushestodirt);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		// bushestograss
		/// no side joins ///
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushes); //surrounded
		}
		//// one side joins ///
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 6); //single down
		}	
		else if (tile_R == CMap::grass  && tile_L == CMap::bushes && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 6); //single right
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}		
		else if (tile_R == CMap::bushes  && tile_L == CMap::grass && tile_D == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 6); //single left
			map.AddTileFlag( offset, Tile::ROTATE | Tile::FLIP);
		}				
		else if (tile_R == CMap::grass  && tile_L == CMap::grass && tile_D == CMap::bushes && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 6); //single up
			map.AddTileFlag( offset, Tile::FLIP);
		}
		/// bottom right ///
		else if (tile_R == CMap::bushes  && tile_RR == CMap::grass && tile_D == CMap::grass && tile_RU == CMap::bushes && tile_RD == CMap::grass)
		{	
			if (tile_LU == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 7); //tl corner big down
				map.AddTileFlag( offset, Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass)
			{					
				map.server_SetTile( tpos, CMap::bushestograss+ 2); //half flat down
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 1); //br corner big left
			}
		}
		else if (tile_LD == CMap::grass && tile_U == CMap::bushes && tile_RU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //br corner small left
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::grass && tile_R == CMap::grass && tile_LD == CMap::bushes && tile_RD == CMap::grass)
		{
			if (tile_LU == CMap::grass && tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 4); //tiny corner br
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else if (tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 7); //small corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}				
			else if (tile_UU == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 2); //half flat right
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE | Tile::MIRROR);
			}
			else
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 1); //br corner big up
				map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
			}
		}
		else if (tile_RU == CMap::grass && tile_U == CMap::bushes && tile_LD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //br corner small up
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR);
		}	
		else if (tile_RU == CMap::grass && tile_U == CMap::bushes && tile_LD == CMap::grass && tile_L == CMap::bushes && tile_R == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 4); //br tiny corner big to big
		}
		else if ( tile_R == CMap::grass && tile_D == CMap::grass && tile_U == CMap::bushes && tile_L == CMap::bushes)
		{
			map.server_SetTile( tpos, CMap::bushestograss); //br corner half diagonal
		}
		//// top right ////
		else if (tile_R == CMap::bushes  && tile_RR == CMap::grass && tile_U == CMap::grass && tile_RD == CMap::bushes && tile_RU == CMap::grass)
		{
			if (tile_LD == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::grass && tile_L == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 7); //tr corner small right
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_LL == CMap::bushes)
			{					
				map.server_SetTile( tpos, CMap::bushestograss+ 1); //tr corner big
				map.AddTileFlag( offset, Tile::FLIP);
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 2); //half flat up
				map.AddTileFlag( offset, Tile::FLIP );
			}
		}
		else if (tile_LU == CMap::grass && tile_D == CMap::bushes && tile_RD == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //tr corner small
			map.AddTileFlag( offset, Tile::FLIP);
		}			
		else if (tile_L == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::grass && tile_R == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 1); //tr corner big down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::grass && tile_D == CMap::bushes && tile_LU == CMap::bushes && tile_L == CMap::bushes && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //tr corner small down
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}
		else if (tile_RD == CMap::grass && tile_D == CMap::bushes && tile_LU == CMap::grass && tile_L == CMap::bushes && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR | Tile::FLIP);
		}		
		else if (tile_L == CMap::bushes && tile_D == CMap::bushes && tile_R == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss);
			map.AddTileFlag( offset, Tile::FLIP); // tr half half
		}
		/// bottom left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::grass && tile_D == CMap::grass && tile_LU == CMap::bushes && tile_LD == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 1); //bl corner big right
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_RD == CMap::grass && tile_U == CMap::bushes && tile_LU == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //bl corner small right
			map.AddTileFlag( offset, Tile::MIRROR);
		}				
		else if (tile_D == CMap::bushes  && tile_DD == CMap::grass && tile_L == CMap::grass && tile_RD == CMap::bushes && tile_LD == CMap::grass)
		{
			if (tile_RU == CMap::grass && tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 4); //tiny corner
				map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR );
			}
			else if (tile_U == CMap::grass)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 7);
				map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
			}
			else if (tile_UU == CMap::bushes)
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 1); //bl corner big up
				map.AddTileFlag( offset, Tile::ROTATE );
			}				
			else
			{
				map.server_SetTile( tpos, CMap::bushestograss+ 2); //half flat
				map.AddTileFlag( offset, Tile::ROTATE);
			}
		}
		else if (tile_LU == CMap::grass && tile_U == CMap::bushes && tile_RD == CMap::bushes && tile_R == CMap::bushes && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //bl corner small up
			map.AddTileFlag( offset, Tile::ROTATE );
		}				
		else if (tile_LU == CMap::grass && tile_U == CMap::bushes && tile_RD == CMap::grass && tile_R == CMap::bushes && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 4); //bl tiny corner big to big
			map.AddTileFlag( offset, Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_L == CMap::grass && tile_D == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss);
			map.AddTileFlag( offset, Tile::MIRROR); //bl half half
		}

		/// top left ///

		else if (tile_L == CMap::bushes  && tile_LL == CMap::grass && tile_U == CMap::grass && tile_LD == CMap::bushes && tile_LU == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 1); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_RU == CMap::grass && tile_D == CMap::bushes && tile_LD == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //tl corner small
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_L == CMap::grass  && tile_U == CMap::grass && tile_D == CMap::bushes && tile_R == CMap::bushes && tile_DD == CMap::grass)
		{				
			map.server_SetTile( tpos, CMap::bushestograss); //tl corner big
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}
		else if (tile_R == CMap::bushes && tile_U == CMap::bushes && tile_UU == CMap::grass && tile_L == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 1); //tl corner big down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE );
		}
		else if (tile_LD == CMap::grass && tile_D == CMap::bushes && tile_RU == CMap::bushes  && tile_R == CMap::bushes && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 7); //tl corner small down
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}								
		else if (tile_LD == CMap::grass && tile_D == CMap::bushes && tile_RU == CMap::grass && tile_R == CMap::bushes && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss+ 4); //tr tiny corner big to big
			map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE);
		}	
		else if (tile_R == CMap::bushes && tile_D == CMap::bushes && tile_L == CMap::grass && tile_U == CMap::grass)
		{
			map.server_SetTile( tpos, CMap::bushestograss);
			map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR);
		}

		/// fill inner ///
		else
		{					
			map.server_SetTile( tpos, CMap::bushes+ map_random.NextRanged(8));
			switch (map_random.NextRanged(6))
			{
				case 0: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR); break;
				case 1: map.AddTileFlag( offset, Tile::FLIP | Tile::MIRROR | Tile::ROTATE); break;
				case 2: map.AddTileFlag( offset, Tile::FLIP | Tile::ROTATE); break;
				case 3: map.AddTileFlag( offset, Tile::ROTATE | Tile::MIRROR); break;
				case 4: map.AddTileFlag( offset, Tile::ROTATE); break;
				case 5: break;
			}
		}

	}
	map.AddTileFlag(offset, Tile::BACKGROUND | Tile::LIGHT_PASSES);	
}
