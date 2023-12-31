
#include "HistoryBlocks.as";
#include "RulesCommands.as";

void HandleTileAngle(CBlob@ this)
{
	if (this.isKeyJustPressed( key_action3 ))
	{
		u16 angle = this.get_u16("build angle");
		angle += 90;
		if (angle >= 360)
		angle = 0;
		this.set_u16("build angle", angle);
	}
}

void HandleBlobAngle(CBlob@ this)
{
	if (this.isKeyJustPressed( key_action3 ))
	{
		u16 angle = this.get_u16("blob angle");

		angle += 15;
		if (angle >= 360)
		angle = 0;
		
		CBitStream params;
		params.write_u16(angle);
		this.SendCommand(this.getCommandID("SetAngle"), params);
	}
}

void HandlePlacement0(CBlob@ this, Vec2f aimpos, CMap@ map) //rectangle brush
{		
	if (this.isKeyJustPressed( key_action1 ))
	{
		this.set_Vec2f("temp start", aimpos);
	}
	else if (this.isKeyPressed( key_action1 ) && aimpos != this.get_Vec2f("temp finish"))
	{
		this.set_Vec2f("temp finish", aimpos);
	}
	else if (this.isKeyJustReleased( key_action1 ))
	{
		u16 buildtile = this.get_u16("build block");
		u16 angle = this.get_u16("build angle");
		bool reversed = this.get_bool("tile flipped");
		u8 radius = this.get_u8("brushsize");	
		bool auto = this.get_bool("autoing");

		CBitStream params;
		params.write_Vec2f(aimpos);				
		params.write_Vec2f(this.get_Vec2f("temp start"));
		params.write_Vec2f(this.get_Vec2f("temp finish"));
		params.write_u8(radius);
		params.write_u16(angle);
		params.write_bool(reversed);
		params.write_u8(0);
		params.write_u16(buildtile);
		params.write_bool(auto);

		this.SendCommand(this.getCommandID("PlaceBlocks"), params);

		this.set_Vec2f("temp start", aimpos);
		this.set_Vec2f("temp finish", aimpos);
	}
}

void HandlePlacement1(CBlob@ this, Vec2f aimpos, CMap@ map) // circle brush
{		
	if (this.isKeyPressed( key_action1 ))
	{
		u16 buildtile = this.get_u16("build block");
		u16 angle = this.get_u16("build angle");
		bool reversed = this.get_bool("tile flipped");
		u8 radius = this.get_u8("brushsize");
		bool auto = this.get_bool("autoing");

		CBitStream params;
		params.write_Vec2f(aimpos);				
		params.write_Vec2f(this.get_Vec2f("temp start"));
		params.write_Vec2f(this.get_Vec2f("temp finish"));
		params.write_u8(radius);
		params.write_u16(angle);
		params.write_bool(reversed);
		params.write_u8(1);
		params.write_u16(buildtile);
		params.write_bool(auto);

		this.SendCommand(this.getCommandID("PlaceBlocks"), params);		
	}	
}

void HandlePlacement2(CBlob@ this, Vec2f aimpos, CMap@ map) //pencil
{	
	if (this.isKeyPressed( key_action1 ))
	{	
		u16 buildtile = this.get_u16("build block");
		u16 angle = this.get_u16("build angle");
		bool reversed = this.get_bool("tile flipped");
		u8 radius = this.get_u8("brushsize");
		bool auto = this.get_bool("autoing");	

		CBitStream params;
		params.write_Vec2f(aimpos);				
		params.write_Vec2f(this.get_Vec2f("temp start"));
		params.write_Vec2f(this.get_Vec2f("temp finish"));
		params.write_u8(radius);
		params.write_u16(angle);
		params.write_bool(reversed);
		params.write_u8(2);
		params.write_u16(buildtile);
		params.write_bool(auto);

		this.SendCommand(this.getCommandID("PlaceBlocks"), params);
	}	
}

void HandlePlacement3(CBlob@ this, Vec2f aimpos, CMap@ map) //rectangle brush
{		
	if (this.isKeyJustPressed( key_action1 ))
	{
		this.set_Vec2f("temp start", aimpos);
	}
	else if (this.isKeyPressed( key_action1 ) && aimpos != this.get_Vec2f("temp finish"))
	{
		this.set_Vec2f("temp finish", aimpos);
	}
	else if (this.isKeyJustReleased( key_action1 ))
	{
		u16 buildtile = this.get_u16("build block");
		u16 angle = this.get_u16("build angle");
		bool reversed = this.get_bool("tile flipped");
		u8 radius = this.get_u8("brushsize");	
		bool auto = this.get_bool("autoing");

		CBitStream params;
		params.write_Vec2f(aimpos);				
		params.write_Vec2f(this.get_Vec2f("temp start"));
		params.write_Vec2f(this.get_Vec2f("temp finish"));
		params.write_u8(radius);
		params.write_u16(angle);
		params.write_bool(reversed);
		params.write_u8(3);
		params.write_u16(buildtile);
		params.write_bool(auto);

		this.SendCommand(this.getCommandID("PlaceBlocks"), params);

		this.set_Vec2f("temp start", aimpos);
		this.set_Vec2f("temp finish", aimpos);
	}
	else if(!this.isKeyPressed( key_action1 ))
	{
		this.set_Vec2f("temp start", aimpos);
		this.set_Vec2f("temp finish", aimpos);
	}
}

void PickBlock(CBlob@ this, Vec2f aimpos, CMap@ map, GUIContainer@ GUI)
{
	if ( this.isKeyPressed( key_action2 ))
	{
		CBitStream params;
		this.SendCommand(this.getCommandID("Kill CursorBlob"), params);
	}
	if (this.isKeyJustReleased( key_action2 ))
	{					
		CBlob@[] overlapping;		
		if (map.getBlobsInBox(aimpos+Vec2f(-2,-2), aimpos+Vec2f(2,2), @overlapping))
		{
			for (uint i = 0; i < overlapping.length; i++)
			{
				CBlob@ CursorBlob = this.getCarriedBlob();
				CBlob@ b = overlapping[i];
				if (b !is null && b !is CursorBlob)
				{	
					if (b.hasTag("player")) continue;

					CBitStream params;
					params.write_Vec2f(aimpos);	
					params.write_string(b.getName());
					params.write_u16(b.getAngleDegrees());
					params.write_s8(b.getTeamNum());
					//params.write_bool(b.isFacingLeft());
					this.SendCommand(this.getCommandID("PickBlob"), params);

					GUI.blockSubMenu.Buttons[0].toggled = false;
					GUI.blockSubMenu.Buttons[1].toggled = true;
					GUI.blockMenu.page2 = true;

					return;								
				}
			}
		}
		else	
		{			
			u16 type = map.getTile(aimpos).type;			
			this.set_u16("build block", type);
			bool tileReversed;
			u16 tileAngle = getTileFlagsAngle(aimpos, tileReversed);
			this.set_u16("build angle", tileAngle);
			this.set_bool("tile flipped", tileReversed);


					GUI.blockSubMenu.Buttons[0].toggled = true;
					GUI.blockSubMenu.Buttons[1].toggled = false;
					GUI.blockMenu.page2 = false;
		}
	}
}

void HandleBlobCursor(CBlob@ this, Vec2f aimpos, CMap@ map)
{
	CBlob @CursorBlob = this.getCarriedBlob();
	if (CursorBlob !is null && getNet().isClient())
	{
		bool reversed = this.get_bool("tile flipped") && CursorBlob.getName() != "excavator";
		if (CursorBlob !is null)
		{
			//CursorBlob.SetFacingLeft(reversed);
			Vec2f pos = this.getPosition();
			Vec2f tilespace = (map.getTileSpacePosition(this.getAimPos())*8)+Vec2f(4,4);
			Vec2f aim_vec = (pos - tilespace);

			AttachmentPoint@ hands = this.getAttachments().getAttachmentPointByName("PICKUP");
			if (hands !is null)
			{
				hands.offset.x =  -aim_vec.x; // if blob config has offset other than 0,0 there is a desync on client, dont know why
				hands.offset.y =  -aim_vec.y;
			}
		}

		if (this.isKeyJustReleased( key_action1 ))
		{
			u16 angle = this.get_u16("blob angle");
			s8 team = this.get_s8("blobteam");

			CBitStream params;

			params.write_Vec2f(aimpos);	
			params.write_u16(angle);
			params.write_bool(reversed);
			params.write_s8(team);

			this.SendCommand(this.getCommandID("PlaceBlobs"), params);
		}		
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	CBlob @CursorBlob = this.getCarriedBlob();
	if (getNet().isServer() && cmd == this.getCommandID("SetTimeline"))
	{			
		HistoryInfo@ history;
		if (this.get("historyInfo", @history))
		{		
			history.setTimeline();
		}								
	}

	else if (getNet().isServer() && cmd == this.getCommandID("PlaceBlocks"))
	{			
		Vec2f pos = params.read_Vec2f();
		Vec2f ts = params.read_Vec2f();
		Vec2f tf = params.read_Vec2f();		
		u8 radius = params.read_u8();
		u16 angle = params.read_u16();
		bool reversed = params.read_bool();
		u8 brushtype = params.read_u8();
		u16 buildtile = params.read_u16();
		bool auto = params.read_bool();

		PlaceBlock(this, pos, ts, tf, radius, angle, reversed, brushtype, buildtile, auto);								
	}
	else if (getNet().isServer() && cmd == this.getCommandID("PlaceBlobs"))
	{			
		Vec2f pos = params.read_Vec2f();	
		u16 angle = params.read_u16();
		bool reversed = params.read_bool();
		s8 team = params.read_s8();

		PlaceBlob(CursorBlob, pos, angle, reversed, team);								
	}
	else if (cmd == this.getCommandID("SetAngle"))
	{		
		u16 angle = params.read_u16();		
		this.set_u16("blob angle", angle);
		this.getCarriedBlob().setAngleDegrees(angle);
	}
	else if (cmd == this.getCommandID("Kill CursorBlob"))
	{
		if (CursorBlob !is null)
		{
			CursorBlob.server_Die();
		}
	}
	else if (getNet().isServer() && cmd == this.getCommandID("PickBlob"))
	{
		Vec2f pos = params.read_Vec2f();	
		string name = params.read_string();
		u16 angle = params.read_u16();
		s8 team = params.read_s8();
		//bool reversed = params.read_bool();

		if (CursorBlob !is null)
		{
			CursorBlob.server_Die();
		}
	
		CBlob@ newb = server_CreateBlob(name, team, pos);
		if (newb !is null)
		{
			newb.setAngleDegrees(this.get_u16("blob angle"));
			//newb.SetFacingLeft(reversed);
			newb.setPosition(pos);
			newb.getShape().SetGravityScale(0.0f);
			newb.getSprite().SetZ(500);
			newb.Tag("cursorblob");
			this.set_s8("blobteam", team);

			CAttachment@ a = newb.getAttachments();
			if (a !is null)
			{
				AttachmentPoint@ ap = a.AddAttachmentPoint("PICKUP", false);
			}

			this.server_Pickup(newb);
		}
	}
	else if (getNet().isServer() && cmd == this.getCommandID("undoHistory"))
	{	
		HistoryInfo@ history;
		if (this.get("historyInfo", @history))
		{
			doUndo(history);
		}
	}
	else if (getNet().isServer() && cmd == this.getCommandID("redoHistory"))
	{				
		HistoryInfo@ history;
		if (this.get("historyInfo", @history))
		{
			doRedo(history);
		}
	}
}

void PlaceBlob(CBlob@ CursorBlob, Vec2f cursorPos, u16 angle, bool reversed, s8 team)
{
	if (CursorBlob is null) return;

	CMap@ map = getMap();
	CBlob@[] overlapping;
	map.getBlobsInBox(cursorPos+Vec2f(-2,-2), cursorPos+Vec2f(2,2), @overlapping);
	for (uint i = 0; i < overlapping.length; i++)
	{
		CBlob@ b = overlapping[i];
		if (b !is null)
		{
			if (CursorBlob is b) continue;

			TileType maptile = map.getTile(cursorPos).type;
			//PushHistory(cursorPos, maptile, b.getName(), -1, b.getAngleDegrees(), false);

			if (CursorBlob !is null && b !is CursorBlob)
			{ return;}
		}
	}
	
	CBlob@ blob = server_CreateBlob(CursorBlob.getName(), team, cursorPos);
	if (blob !is null)
	{	
		string name = CursorBlob.getName();
		if (name == "waymarkblob")
		blob.set_u8("wayNum", CursorBlob.get_u8("wayNum"));

		blob.server_setTeamNum(team);

		//if (reversed && name != "excavator")
		//blob.SetFacingLeft(true);

		blob.setAngleDegrees(angle);
		blob.getShape().SetGravityScale(0.0f);
		blob.getShape().SetStatic(true);
		//blob.getSprite().SetZ(400.0f);
	}
}

void PlaceBlock(CBlob@ this, Vec2f cursorPos, Vec2f temp_start, Vec2f temp_finish, u8 radius, u16 angle, bool reversed, u8 brushtype, u16 buildtile, bool auto)
{	
	CMap@ map = this.getMap();
	Vec2f tpos;

	if (brushtype == 0)
	{						 
		f32 Distance_x = (temp_finish.x - temp_start.x);
		f32 Distance_y = (temp_finish.y - temp_start.y);

		if( !this.get_bool("canceled"))
		{
			for (int x_step = 0; x_step-1 < (Distance_x < 0 ? -Distance_x/8 : Distance_x/8); ++x_step)
			{
				for (int y_step = 0; y_step-1 < (Distance_y < 0 ? -Distance_y/8 : Distance_y/8); ++y_step)
				{
					Vec2f off(((Distance_x < 0 ? -x_step : x_step) * map.tilesize), ((Distance_y < 0 ? -y_step : y_step) * map.tilesize));

					Vec2f tpos = cursorPos - off;
					if (tpos.x > -8 && tpos.x < (map.tilemapwidth*8)-8)
					{
						Paint(this, map, tpos, buildtile, angle, reversed, ( x_step == 0 || y_step == 0 || x_step == Maths::Abs(Distance_x/8) || y_step == Maths::Abs(Distance_y/8) ), auto);							
					}																	
				}	
			}			
		}
		else
		{
			this.set_bool("canceled",false);
		}
	}
	else if (brushtype == 1)
	{			
		f32 radsq = radius * radius;

		for (int x_step = -radius; x_step < radius; ++x_step)
		{
			for (int y_step = -radius; y_step < radius; ++y_step)
			{
				Vec2f off(x_step, y_step);

				if (off.LengthSquared() >= radsq-1)
					continue;

				Vec2f tpos = cursorPos+(off * map.tilesize);
				if (tpos.x < 0 && tpos.x >= map.tilemapwidth*map.tilesize) 
					continue;
			
				TileType maptile = map.getTile(tpos).type;
				
				bool tileReversed;
				u16 tileAngle = getTileFlagsAngle(tpos, tileReversed);
				

				//if (maptile == buildtile && (tileAngle == angle && tileReversed == reversed)) continue;
				//PushHistory(tpos, maptile, "", -1, angle, reversed);
				Paint(this, map, tpos, buildtile, angle, reversed, off.LengthSquared() >= radsq-(radius*2), auto);
								
			}			
		}
	}
	else if (brushtype == 2)
	{		
		Vec2f tpos = cursorPos;
		Paint(this, map, tpos, buildtile, angle, reversed, true, auto);
	}
	else if (brushtype == 3)
	{
		int dx = Maths::Abs(((temp_finish.x - temp_start.x)/8));
		int dy = -Maths::Abs((temp_finish.y - temp_start.y)/8);	
		int sx = temp_start.x < temp_finish.x ? 8 : -8;
 		int sy = temp_start.y < temp_finish.y ? 8 : -8;
 		int err = dx+dy; 
 		int e2;
 		int x0 = temp_start.x; 
 		int y0 = temp_start.y;
 		int x1 = temp_finish.x; 
 		int y1 = temp_finish.y;

 		int dubtap = auto ? 2:1;

 		int Len_steps = Maths::Abs(dx) > Maths::Abs(dy) ? Maths::Abs(dx) : Maths::Abs(dy);

		for (int dt = 0; dt < dubtap; dt++)
		for (int Len_step = 0; Len_step < Len_steps+1; Len_step++)
		{
			Vec2f off(x0, y0);

			Vec2f tpos = off;
			
			if (tpos.x > -8 && tpos.x < (map.tilemapwidth*8)-8)
			{
				Paint(this, map, tpos, buildtile, angle, reversed, dt == 1, auto);							
			}

		    if (x0==x1 && y0==y1) break;
		    e2 = 2*err;
		    if (e2 >= dy) { err += dy; x0 += sx; } /* e_xy+e_x > 0 */
		    if (e2 <= dx) { err += dx; y0 += sy; } /* e_xy+e_y < 0 */
		}	
	}
//	else if (brushtype == 3)
//	{
//		int dx = Maths::Abs(temp_finish.x - temp_start.x);
//		int dy = Maths::Abs(temp_finish.y - temp_start.y);
//
//		u16 lineangle = (temp_start - temp_finish).Angle();
//		int Len_steps = (temp_start - temp_finish).Length();
//		
//		int dubtap = auto ? 2:1;
//
//		for (int dt = 0; dt < dubtap; dt++)
//		for (int x_step = 0; x_step < Len_steps; ++x_step)
//		{
//			//for (int y_step = -radius; y_step < radius; ++y_step)
//			{
//				Vec2f off =  Vec2f(x_step, 0 /*y_step*8*/).RotateBy(-lineangle);
//
//				Vec2f tpos = (map.getTileSpacePosition(cursorPos + off)*8)+Vec2f(4,4);
//
//				//if (tpos.x > -8 && tpos.x < (map.tilemapwidth*8)-8)
//				{
//					Paint(this, map, tpos, buildtile, angle, reversed, dt == 1, auto);							
//				}	
//															
//			}	
//		}	
//	}
}

void Paint(CBlob@ this, CMap@ map, Vec2f tilepos, u16 buildtile, u16 angle, bool reversed, bool canAuto, bool auto)
{	
	TileType maptile = map.getTile(tilepos).type;

	CBlob@[] behindBlob;
	getMap().getBlobsAtPosition( tilepos, @behindBlob);	

	switch (buildtile)
	{
		case 384: //road
		case 385:
		case 386:
		case 387: {buildtile = 384 + XORRandom(4); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

		case 388: //grass
		case 389:
		case 390:
		case 391: {buildtile = 388 + XORRandom(4); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

		case 392: //sand
		case 393:
		case 394:
		case 395: {buildtile = 392 + XORRandom(4); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

		case 396: //dirt
		case 397:
		case 398:
		case 399: {buildtile = 396 + XORRandom(4); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

		case 588: //flowers
		case 589:
		case 590:
		case 591: { angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

			//crops empty
			case 565:
	 	case 566: {buildtile = 565+XORRandom(2); reversed = XORRandom(2) == 0; } break;

	 	//crops red
		case 553:
		case 554:
		case 555: {buildtile = 553+XORRandom(3); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

		//crops green
	 	case 556: 
	 	case 557:
	 	case 558: {buildtile = 556+XORRandom(3); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

	 	//crops blue
	  	case 569:
	  	case 570:
	  	case 571: {buildtile = 569+XORRandom(3); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

	  	//crops yellow
	  	case 572:
	  	case 573:
	   	case 574: {buildtile = 572+XORRandom(3); angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

	   	//crops grassy
	   	case 567: { angle = XORRandom(3)*90; reversed = XORRandom(2) == 0; } break;

	}

	HistoryInfo@ history;
	if (!this.get("historyInfo", @history))
	{ return; }

	if (auto)
	{
		CRules@ rules = getRules();
		CBitStream params;

		for(uint i = 0; i < behindBlob.length; i++)
		{
	        if (behindBlob[i].hasTag("player")) continue; 
	        behindBlob[i].server_Die();
		}

		params.write_Vec2f(tilepos);
		params.write_u16(buildtile);
		params.write_bool(canAuto);
		rules.SendCommand(rules.getCommandID("AutoTile"), params);
	}
	else if (!auto)
	{		
		bool tileReversed;
		u16 tileAngle = getTileFlagsAngle(aimpos, tileReversed);
		//if (maptile == buildtile && (tileAngle == angle && tileReversed == reversed)) return;

		for(uint i = 0; i < behindBlob.length; i++)
		{
	        if (behindBlob[i].hasTag("player")) continue;
	        behindBlob[i].server_Die();
		}
		
		//history.PushHistory( tilepos, maptile, "", -1);
		map.server_SetTile(tilepos , buildtile);


		bool background = true;
		if (buildtile >= 880)
		background = false;

		CBitStream params;
		params.write_Vec2f(tilepos);
		params.write_u16(angle);
		params.write_bool(reversed);
		params.write_bool(background);
		getRules().SendCommand(getRules().getCommandID("SetTileFlags"), params);			
	}
}

u16 getTileFlagsAngle(Vec2f pos, bool &out reversed)
{
	CMap@ map = getMap();
	Vec2f tilespace = map.getTileSpacePosition(pos);
	const int offset = map.getTileOffsetFromTileSpace(tilespace);

	if ( map.hasTileFlag(offset, Tile::SPARE_0) && map.hasTileFlag(offset, Tile::MIRROR) && !map.hasTileFlag(offset, Tile::FLIP)  && !map.hasTileFlag(offset, Tile::ROTATE) )
	{ reversed = true; return 0; }
	else if ( map.hasTileFlag(offset, Tile::SPARE_0) && map.hasTileFlag(offset, Tile::ROTATE) && map.hasTileFlag(offset, Tile::FLIP) && !map.hasTileFlag(offset, Tile::MIRROR))
	{ reversed = true; return 90; }
	else if ( map.hasTileFlag(offset, Tile::SPARE_0) && map.hasTileFlag(offset, Tile::FLIP) && !map.hasTileFlag(offset, Tile::ROTATE) && !map.hasTileFlag(offset, Tile::MIRROR))
	{ reversed = true; return 180; }
	else if ( map.hasTileFlag(offset, Tile::SPARE_0) && map.hasTileFlag(offset, Tile::ROTATE) && map.hasTileFlag(offset, Tile::MIRROR) && !map.hasTileFlag(offset, Tile::FLIP))
	{ reversed = true; return 270; }
	else if ( map.hasTileFlag(offset, Tile::ROTATE) && !map.hasTileFlag(offset, Tile::MIRROR) && !map.hasTileFlag(offset, Tile::FLIP)) 
	{ reversed = false; return 90; }
	else if ( map.hasTileFlag(offset, Tile::FLIP) && map.hasTileFlag(offset, Tile::MIRROR) && !map.hasTileFlag(offset, Tile::FLIP))
	{ reversed = false; return 180; }
	else if ( map.hasTileFlag(offset, Tile::ROTATE) &&  map.hasTileFlag(offset, Tile::FLIP) && map.hasTileFlag(offset, Tile::MIRROR))
	{ reversed = false; return 270; }
	reversed = false;
	return 0;
}