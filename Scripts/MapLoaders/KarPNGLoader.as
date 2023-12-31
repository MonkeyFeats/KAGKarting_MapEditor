Random map_random(3253251239);

#include "LoadMapUtils.as";
#include "EditorMenuCommon.as";

namespace CMap
{	
	void SetupMap( CMap@ map, int width, int height )
	{
		map.CreateTileMap( width, height, 8.0f, "world.png" );
		map.CreateSky( SColor(0, 0, 0, 0) );
		map.topBorder = map.bottomBorder = map.rightBorder = map.leftBorder = true;
	} 

	enum Tiles
	{		
		water = 0,

		road = 384,
		roadtograss = 400,
		roadtograss_1 = 401,
		roadtograss_2 = 402,
		roadtograss_3 = 403,
		roadtograss_4 = 404,
		roadtograss_5 = 405,
		roadtograss_6 = 406,
		roadtograss_7 = 407,

		roadtosand = 416,
		roadtosand_1 = 417,
		roadtosand_2 = 418,
		roadtosand_3 = 419,
		roadtosand_4 = 420,
		roadtosand_5 = 421,
		roadtosand_6 = 422,
		roadtosand_7 = 423,

		roadtodirt = 432,
		roadtodirt_1 = 433,
		roadtodirt_2 = 434,
		roadtodirt_3 = 435,
		roadtodirt_4 = 436,
		roadtodirt_5 = 437,
		roadtodirt_6 = 438,
		roadtodirt_7 = 439,

		roadtowater = 464,
		roadtowater_1 = 465,
		roadtowater_2 = 466,
		roadtowater_3 = 467,
		roadtowater_4 = 468,
		roadtowater_5 = 469,
		roadtowater_6 = 470,
		roadtowater_7 = 471,

		grass = 388,
		grasstosand = 408,
		grasstosand_1 = 409,
		grasstosand_2 = 410,
		grasstosand_3 = 411,
		grasstosand_4 = 412,
		grasstosand_5 = 413,
		grasstosand_6 = 414,
		grasstosand_7 = 415,

		grasstodirt = 424,
		grasstodirt_1 = 425,
		grasstodirt_2 = 426,
		grasstodirt_3 = 427,
		grasstodirt_4 = 426,
		grasstodirt_5 = 429,
		grasstodirt_6 = 430,
		grasstodirt_7 = 431,

		grasstowater = 448,
		grasstowater_1 = 449,
		grasstowater_2 = 450,
		grasstowater_3 = 451,
		grasstowater_4 = 452,
		grasstowater_5 = 453,
		grasstowater_6 = 454,
		grasstowater_7 = 455,

		sand = 392,
		sandtodirt = 440,
		sandtodirt_1 = 441,
		sandtodirt_2 = 442,
		sandtodirt_3 = 443,
		sandtodirt_4 = 444,
		sandtodirt_5 = 445,
		sandtodirt_6 = 446,
		sandtodirt_7 = 447,

		sandtowater = 456,
		sandtowater_1 = 457,
		sandtowater_2 = 458,
		sandtowater_3 = 459,
		sandtowater_4 = 460,
		sandtowater_5 = 461,
		sandtowater_6 = 462,
		sandtowater_7 = 463,

		dirt = 396,
		dirttowater = 472,
		dirttowater_1 = 473,
		dirttowater_2 = 474,
		dirttowater_3 = 475,
		dirttowater_4 = 476,
		dirttowater_5 = 477,
		dirttowater_6 = 478,
		dirttowater_7 = 479,

		checkers = 560,
		checkers_1 = 561,
		checkers_2 = 562,
		checkers_3 = 563,

		rumbler_1 = 544,
		rumbler = 545,
		rumbler_2 = 546,
		rumbler_3 = 547,

		rumblertograss = 480,
		rumblertograss_1 = 481,
		rumblertograss_2 = 482,
		rumblertograss_3 = 483,
		rumblertograss_4 = 484,
		rumblertograss_5 = 485,
		rumblertograss_6 = 486,
		rumblertograss_7 = 487,
		rumblertograss_8 = 488,
		rumblertograss_9 = 489,
		rumblertograss_10 = 490,
		rumblertograss_11 = 491,
		rumblertograss_12 = 492,
		rumblertograss_13 = 493,
		rumblertograss_14 = 494,
		rumblertograss_15 = 496,

		rumblertoroad = 496,
		rumblertoroad_1 = 497,
		rumblertoroad_2 = 498,
		rumblertoroad_3 = 499,
		rumblertoroad_4 = 500,
		rumblertoroad_5 = 501,
		rumblertoroad_6 = 502,
		rumblertoroad_7 = 503,
		rumblertoroad_8 = 504,
		rumblertoroad_9 = 505,
		rumblertoroad_10 = 506,
		rumblertoroad_11 = 507,
		rumblertoroad_12 = 508,
		rumblertoroad_13 = 510,
		rumblertoroad_14 = 511,
		rumblertoroad_15 = 512,

		rumblertosand = 513,
		rumblertosand_1 = 514,
		rumblertosand_2 = 515,
		rumblertosand_3 = 516,
		rumblertosand_4 = 517,
		rumblertosand_5 = 518,
		rumblertosand_6 = 519,
		rumblertosand_7 = 520,
		rumblertosand_8 = 521,
		rumblertosand_9 = 522,
		rumblertosand_10 = 523,
		rumblertosand_11 = 524,
		rumblertosand_12 = 525,
		rumblertosand_13 = 526,
		rumblertosand_14 = 527,
		rumblertosand_15 = 528,

		rumblertodirt = 529,
		rumblertodirt_1 = 530,
		rumblertodirt_2 = 531,
		rumblertodirt_3 = 532,
		rumblertodirt_4 = 533,
		rumblertodirt_5 = 534,
		rumblertodirt_6 = 535,
		rumblertodirt_7 = 536,
		rumblertodirt_8 = 537,
		rumblertodirt_9 = 538,
		rumblertodirt_10 = 539,
		rumblertodirt_11 = 540,
		rumblertodirt_12 = 541,
		rumblertodirt_13 = 542,
		rumblertodirt_14 = 543,
		rumblertodirt_15 = 544,

		fence_gate = 564,
		fence_corner = 548,
		fence_grass = 549,
		fence_sand = 550,
		fence_dirt = 551,
		fence_water = 552,
		crop_red = 553,
		crop_green = 556,
		crop_empty = 565,
		crop_empty_grassy = 567,
		crop_empty_water = 568,
		crop_blue = 569,
		crop_yellow = 572,

		woodlogs = 576,
		woodlogs_1 = 577,
		woodbrick = 578,

		woodpath_1 = 579,
		woodpath_2 = 580,
		woodpath_3 = 581,
		woodpath_4 = 582,
		woodpath_5 = 583,
		woodpath_corner_1 = 584,
		woodpath_corner_2 = 585,
		woodpath_corner_3 = 586,
		woodpath_corner_4 = 587,				

		flowers_1 = 588,
		flowers_2 = 589,
		flowers_3 = 590,
		flowers_4 = 591,

		dirtwall = 592,
		dirtwall_1 = 593,
		dirtwall_2 = 594,
		dirtwall_3 = 595,
		dirtwall_4 = 596,
		dirtwall_5 = 597,	
		dirtwall_6 = 598,
		dirtwall_7 = 599,
		dirtwall_8 = 600,
		dirtwall_9 = 601,

		woodlogs2_1 = 602,
		woodlogs2_2 = 603,

		waterthing_1 = 604,
		waterthing_2 = 605,
		waterthing_3 = 606,
		waterthing_4 = 607,

		stonewall = 608,
		stonewall_1 = 609,
		stonewall_2 = 610,
		stonewall_3 = 611,
		stonewall_4 = 612,
		stonewall_5 = 613,
		stonewall_6 = 614,
		stonewall_7 = 615,
		stonewall_8 = 616,
		stonewall_9 = 617,

		stonething_1 = 618,
		stonething_2 = 619,
		rooftile_1 = 620,
		rooftile_2 = 621,

		mudtrack_1 = 622,
		mudtrack_2 = 623,

		traintracks_1 = 624,
		traintracks_2 = 625,
		traintracks_3 = 626,
		traintracks_4 = 627,
		traintracks_5 = 628,

		extabrick_1 = 629,
		extabrick_2 = 630,
		extabrick_3 = 631,
		extabrick_4 = 632,
		extabrick_5 = 633,
		extabrick_6 = 634,
		extabrick_7 = 635,
		extabrick_8 = 636,

		cobblestone_1 = 637,
		cobblestone_2 = 638,
		cobblestone_3 = 639,

		roof1_1 = 640,
		roof1_2 = 641,
		roof1_3 = 642,
		roof1_4 = 643,
		roof1_5 = 644,
		roof1_6 = 645,
		roof1_7 = 646,
		roof1_8 = 647,
		roof1_9 = 648,

		roof1_10 = 649,
		roof1_11 = 650,
		roof1_12 = 651,
		roof1_13 = 652,
		roof1_14 = 653,
		roof1_15 = 654,
		roof1_16 = 655,

		bushes = 752,
		bushestograss = 760,
		bushestosand = 768,
		bushestodirt = 776
	};

	void handlePixel( CMap@ map, CFileImage@ image, SColor pixel, int offset, Vec2f pixelPos)
	{	
		u8 Alpha = pixel.getAlpha(); // blob angle/team num/facing direction
		u8 Red = pixel.getRed(); // tile angle / tile set, if(red < 128) {tileset = 1} else if(red >= 128) {tileset = 2}
		u8 Green = pixel.getGreen(); // tile type
		u8 Blue = pixel.getBlue(); // blob type

		s32 tile = Green;

		if(tile > 0) tile += 383;
		if(Red >=  128) tile += 255;
		
		if (Blue > 0 && Blue != 255)
		spawnBlobFromBlue(Alpha, Blue, offset, map);

		map.SetTile(offset, tile);
		
		uint flags = 0;

		if(Red & 1 > 0) flags = flags | Tile::MIRROR;
		if(Red & 2 > 0) flags = flags | Tile::FLIP;
		if(Red & 4 > 0) flags = flags | Tile::ROTATE;		

		//map.getTile(offset).flags = flags;

		map.AddTileFlag(offset, flags);
		map.AddTileFlag(offset, Tile::LIGHT_PASSES | Tile::LIGHT_SOURCE);
	}
}

void spawnBlobFromBlue(u8 alpha, u8 blue, int offset, CMap@ map)
{
	//if(name == "waymarker") // waypoint marker
	//if (blue >= 100)

	int teamnum = ((alpha-10)/24);
	u16 ang = ((alpha-(teamnum*24))-10)*15;
	if (blue-1 >= blobNames.length())
	{
		CBlob@ blob = spawnBlob( map, "waymarkblob", offset, -1, false);
		if (blob !is null)
		{
			blob.set_u8("wayNum", (blue)-100);
			//u16 ang = (alpha-10)*15;
			blob.setPosition(map.getTileWorldPosition(offset)+Vec2f(4,4));
			blob.setAngleDegrees(0);
			blob.getShape().SetStatic(true);
		}	
	}
	else if (blue-1 == 99)
	{
		CBlob@ blob = spawnBlob( map, "spawnmarkblob", offset, 0, false);
		if (blob !is null)
		{
			blob.setPosition(map.getTileWorldPosition(offset)+Vec2f(4,4));
			blob.setAngleDegrees(ang);
			blob.server_setTeamNum(0);
			//bool facingleft = alpha > 207;
			//blob.SetFacingLeft(facingleft);
			blob.getShape().SetStatic(true);
		}		
	}
	else
	{		
		string name = blobNames[blue-1];
		CBlob@ blob = spawnBlob( map, name, offset, teamnum, false);
		if (blob !is null)
		{
			blob.setPosition(map.getTileWorldPosition(offset)+Vec2f(4,4));
			blob.setAngleDegrees(ang);
			blob.server_setTeamNum(teamnum);
			//bool facingleft = alpha > 207;
			//blob.SetFacingLeft(facingleft);
			blob.getShape().SetStatic(true);
		}	
	}	
}


uint getBlueFromBlob(string name)
{
	return 1+blobNames.find(name);
}

void SaveMap(CMap@ map, const string &in fileName)
{
	const u32 width = map.tilemapwidth;
	const u32 height = map.tilemapheight;
	const u32 space = width * height;

	CFileImage image(width, height, true);
	ImageFileBase base;
	//base.name = "";
	image.setFilename(fileName, base);

	// image starts at -1, 0
	image.nextPixel();

	// iterate through tiles
	for(uint i = 0; i < space; i++)
	{
		SColor color;
		u8 flags_col = 0;
		if(map.hasTileFlag( i, Tile::MIRROR)) flags_col = flags_col | 1;
		if(map.hasTileFlag( i, Tile::FLIP)) flags_col = flags_col | 2;
		if(map.hasTileFlag( i, Tile::ROTATE)) flags_col = flags_col | 4;
		if(map.getTile(i).type > 638) flags_col = flags_col | 128;

		uint tile_alpha = 255;
		uint tile_blue = 0;

		Vec2f tpos = (map.getTileSpacePosition(i)*8)+Vec2f(4,4);		
		
		color = getColorFromTile( tile_alpha, flags_col, map.getTile(i).type, tile_blue);		
		image.setPixelAndAdvance(color);
	}

	// iterate through blobs
	CBlob@[] blobs;
	getBlobs(@blobs);
	for(uint i = 0; i < blobs.length; i++)
	{
		CBlob@ blob = blobs[i];		
		if (blob !is null && !blob.hasTag("cursorblob") && !blob.hasTag("player") && !blob.isAttached())
		{
			const Vec2f position = map.getTileSpacePosition(blob.getPosition());
			uint Toffset = map.getTileOffsetFromTileSpace(position);
			SColor color;			
			u8 flags_col = 0;
			if(map.hasTileFlag( Toffset, Tile::MIRROR)) flags_col = flags_col | 1;
			if(map.hasTileFlag( Toffset, Tile::FLIP)) flags_col = flags_col | 2;
			if(map.hasTileFlag( Toffset, Tile::ROTATE)) flags_col = flags_col | 4;

			if(map.getTile(Toffset).type > 638) flags_col = flags_col | 128;

			uint tile_alpha = 255;
			uint tile_blue = 0;				
		
			if (blob.getName() == "waymarkblob")
			{
				//tile_alpha = 10;
				u8 wayNum = blob.get_u8("wayNum");
				tile_blue = 100+wayNum;
			}
			else if (blob.getName() == "waymarkblob")
			{
				//tile_alpha = 10;
				tile_alpha = 10+(24*blob.getTeamNum()+(blob.getAngleDegrees()/15));
				tile_blue = 99;
			}
			else
			{
				tile_alpha = 10+(24*blob.getTeamNum()+(blob.getAngleDegrees()/15));
				tile_blue = getBlueFromBlob(blob.getName());
			}
		
			color = getColorFromTile( tile_alpha, flags_col, map.getTile(Toffset).type, tile_blue);

			image.setPixelAtPosition(position.x, position.y, color, false);
		}
	}

	image.Save();
}

SColor getColorFromTile( uint tile_alpha, uint tile_flag, TileType tile, uint tile_blue)
{
	if (tile_flag >= 128) tile -= 255;

	if (tile == 0)
	{
		tile = 383; 
	}
			   // blob angle, tile angle, tile type, blob type
	return SColor(tile_alpha, tile_flag, tile -= 383, tile_blue);
}