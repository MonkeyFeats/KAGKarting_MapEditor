
#include "KGUI.as";
#include "EditorMenuCommon.as";
#include "Placement.as";
#include "AutoTile.as";
#include "TeamColour.as"

bool showBlockMenu = true;
bool canDraw = true;

BuildBlock[][]@ blocks;

Vec2f aimpos;

void onDie( CBlob@ this )
{
	//if (!this.isMyPlayer()) return;
	CBlob@ CursorBlob = this.getCarriedBlob();
	if (CursorBlob !is null)
	{
		CursorBlob.server_Die();
	}
}
		
void onInit( CBlob@ this )
{		
	//if (!this.isMyPlayer()) return;
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";

	this.set_u16("build block", 0);
	this.set_u8("brush type", 2);
	this.set_u8("brushsize", 3);
	this.set_s8("blobteam", 0);
	this.set_bool("tile flipped", false);

	this.addCommandID("SetTimeline");
	this.addCommandID("PlaceBlocks");
	this.addCommandID("PlaceBlobs");
	this.addCommandID("SetAngle");
	this.addCommandID("Kill CursorBlob");
	this.addCommandID("PickBlob");
	this.addCommandID("undoHistory");
	this.addCommandID("redoHistory");
	this.set_bool("canceled", false);

	HistoryInfo history;
	history.currentHistoryTimeline = 1;
	this.set("historyInfo", @history);

    //AddIconToken("$down_arrow$", "GUI/GUIArrows.png", 	Vec2f(8, 8), 0);
    //AddIconToken("$up_arrow$", "GUI/GUIArrows.png", 		Vec2f(8, 8), 1);
    //AddIconToken("$left_arrow$", "GUI/GUIArrows.png", 	Vec2f(8, 8), 2);
    //AddIconToken("$right_arrow$", "GUI/GUIArrows.png", 	Vec2f(8, 8), 3);

	BuildBlock[][] _blocks();
	if (_blocks !is null)
	addMenuItems(_blocks);
	@blocks = _blocks;
	Driver@ driver = getDriver();  

	GUIContainer MenuContainer;

	if (MenuContainer !is null)
	{	
		Menu _blockmenu(Vec2f(16,driver.getScreenDimensions().y-128), Vec2f(driver.getScreenDimensions().x-16,driver.getScreenDimensions().y-48), Vec2f(64,64), 8);	
		if (_blockmenu !is null)
		{
			_blockmenu.addScrollX(blocks[0].length());
			for (int i = 0; i < blocks[0].length(); i++) // blocks
			{			
				BuildBlock@ block = blocks[0][i];
				AddIconToken(block.icon, "world.png", Vec2f(8, 8), block.tile);
				_blockmenu.addIconButton(Vec2f(i,0), block.icon, 2.5f, Vec2f(12, 12));
			}

			for (int i = 0; i < blocks[1].length(); i++) // blobs
			{
				BuildBlock@ block = blocks[1][i];
				//AddIconToken(block.icon, block.description+".png", Vec2f(8, 8), 0);
				_blockmenu.addIconButton2(Vec2f(i,0), block.icon, 1.0f, Vec2f(12, 12));
			}

			@MenuContainer.blockMenu = _blockmenu;

			Button _flipButton(Vec2f(_blockmenu.size.x-232, _blockmenu.position.y -48) , Vec2f(64,48), "Flip(Q)");	
			if (_flipButton !is null)
			{
				@MenuContainer.flipButton = _flipButton;
			}

			Menu _blocksubmenu(Vec2f(_blockmenu.size.x-168, _blockmenu.position.y -48), Vec2f(_blockmenu.size.x, _blockmenu.position.y ), Vec2f(64,32), 8);	
			if (_blocksubmenu !is null)
			{
				_blocksubmenu.addTextButton(Vec2f(0,0), "Tiles", color_white);
				_blocksubmenu.addTextButton(Vec2f(1,0), "Blobs", color_white);
				@MenuContainer.blockSubMenu = _blocksubmenu;
				MenuContainer.blockSubMenu.Buttons[0].toggled = true;
			} 
			Menu _teammenu(Vec2f(16, _blockmenu.position.y -48), Vec2f(344, _blockmenu.position.y ), Vec2f(32,32), 8);	
			if (_teammenu !is null)
			{
				AddIconToken("$team0$", "TeamPalette.png", Vec2f(1, 1), 0);
				AddIconToken("$team1$", "TeamPalette.png", Vec2f(1, 1), 1);

				_teammenu.addColorButton(Vec2f(0,0), getTeamColor(0));
				_teammenu.addColorButton(Vec2f(1,0), getTeamColor(1));
				_teammenu.addColorButton(Vec2f(2,0), getTeamColor(2));
				_teammenu.addColorButton(Vec2f(3,0), getTeamColor(3));
				_teammenu.addColorButton(Vec2f(4,0), getTeamColor(4));
				_teammenu.addColorButton(Vec2f(5,0), getTeamColor(5));
				_teammenu.addColorButton(Vec2f(6,0), getTeamColor(6));
				_teammenu.addColorButton(Vec2f(7,0), getTeamColor(7));

				@MenuContainer.teamMenu = _teammenu;
			} 

			Menu _waymenu(Vec2f(_blockmenu.size.x-296, _blockmenu.position.y -48), Vec2f(_blockmenu.size.x-168, _blockmenu.position.y ), Vec2f(32,32), 8);	
			if (_waymenu !is null)
			{
				AddIconToken("$circle_minus$", "BrushMenu.png", Vec2f(16, 16), 18);
				AddIconToken("$circle_plus$", "BrushMenu.png", Vec2f(16, 16), 19);

				_waymenu.addIconButton(Vec2f(0,0), "$circle_minus$", 0.5f, Vec2f(8, 8));
				_waymenu.addIconButton(Vec2f(2,0), "$circle_plus$", 0.5f, Vec2f(8, 8));

				@MenuContainer.wayMenu = _waymenu;
			} 
		}

		Menu _brushmenu(Vec2f(16,driver.getScreenDimensions().y-200), Vec2f(246,driver.getScreenDimensions().y-136), Vec2f(48,48), 8);	
		if (_brushmenu !is null)
		{
			AddIconToken("$rectangle_brush$", "BrushMenu.png", Vec2f(16, 16), 16);
			AddIconToken("$circle_brush$", "BrushMenu.png", Vec2f(16, 16), 17);
			AddIconToken("$pencil_brush$", "BrushMenu.png", Vec2f(16, 16), 20);
			AddIconToken("$line_brush$", "BrushMenu.png", Vec2f(16, 16), 21);

			_brushmenu.addIconButton(Vec2f(0,0), "$rectangle_brush$", 1.0f, Vec2f(8, 8));
			_brushmenu.addIconButton(Vec2f(1,0), "$circle_brush$", 1.0f, Vec2f(8, 8));
			_brushmenu.addIconButton(Vec2f(2,0), "$pencil_brush$", 1.0f, Vec2f(8, 8));
			_brushmenu.addIconButton(Vec2f(3,0), "$line_brush$", 1.0f, Vec2f(8, 8));
			@MenuContainer.brushMenu = _brushmenu;
			MenuContainer.brushMenu.Buttons[2].toggled = true; 

			Menu _brushsubmenu(_brushmenu.position+Vec2f(64,-88), _brushmenu.size+Vec2f(-114,-64), Vec2f(32,32), 8);	
			if (_brushsubmenu !is null)
			{
				_brushsubmenu.addIconButton(Vec2f(0,1), "$circle_minus$", 0.5f, Vec2f(8, 8));
				_brushsubmenu.addIconButton(Vec2f(0,0), "$circle_plus$", 0.5f, Vec2f(8, 8));
				@MenuContainer.brushSubMenu = _brushsubmenu;

				Button _autoButton(_brushsubmenu.position+Vec2f(_brushsubmenu.size.x+40,120), Vec2f(104, 32), "Auto Tiling");
				if (_autoButton !is null)
				{
					@MenuContainer.autoButton = _autoButton;
				}
			}
		}		

		this.set("GUI_Info", MenuContainer);
	}
}

u32 i = 0;

void onTick( CBlob@ this )
{
	if (!this.isMyPlayer() ) return;

	if (this.getPlayer() is null) return;
	//if (!this.getPlayer().get_bool("allowedtobuild")) return;

	GUIContainer@ GUI;
	if (!this.get("GUI_Info", @GUI))
	{
		return;
	}

	CControls@ controls = getControls();
	CMap@ map = getMap();
	CBlob@ CursorBlob = this.getCarriedBlob();

	if ( controls.isKeyJustPressed( KEY_KEY_F ) )
	{ showBlockMenu = !showBlockMenu; }	

	canDraw = (!GUI.brushMenu.isHovered && !GUI.blockMenu.isHovered && 
				!GUI.blockSubMenu.isHovered && !GUI.flipButton.isHovered);

	if (GUI.blockSubMenu.Buttons[0].toggled && (GUI.brushSubMenu.isHovered || GUI.autoButton.isHovered))
	canDraw = false;

	if (GUI.blockSubMenu.Buttons[1].toggled && (GUI.teamMenu.isHovered || GUI.wayMenu.isHovered))
	canDraw = false;

	// button selecting	

	if (GUI.blockSubMenu.Buttons[0].isHovered && this.isKeyJustReleased( key_action1 ))
	{
		GUI.blockSubMenu.Buttons[1].toggled = false;
		GUI.blockSubMenu.Buttons[0].toggled = true;
		GUI.blockMenu.page2 = false;

		CBitStream params;
		this.SendCommand(this.getCommandID("Kill CursorBlob"), params);
	}
	else if (GUI.blockSubMenu.Buttons[1].isHovered && this.isKeyJustReleased( key_action1 ))
	{
		GUI.blockSubMenu.Buttons[0].toggled = false;
		GUI.blockSubMenu.Buttons[1].toggled = true;
		GUI.blockMenu.page2 = true;		
	}

	if (GUI.blockSubMenu.Buttons[0].toggled)
	{
		if (GUI.brushMenu.Buttons[0].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_u8("brush type", 0);
			GUI.brushMenu.Buttons[0].toggled = true; 
			GUI.brushMenu.Buttons[1].toggled = false; 
			GUI.brushMenu.Buttons[2].toggled = false; 
			GUI.brushMenu.Buttons[3].toggled = false;
		}
		else if (GUI.brushMenu.Buttons[1].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_u8("brush type", 1);
			GUI.brushMenu.Buttons[0].toggled = false; 
			GUI.brushMenu.Buttons[1].toggled = true; 
			GUI.brushMenu.Buttons[2].toggled = false; 
			GUI.brushMenu.Buttons[3].toggled = false;
		}
		else if (GUI.brushMenu.Buttons[2].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_u8("brush type", 2);
			GUI.brushMenu.Buttons[0].toggled = false; 
			GUI.brushMenu.Buttons[1].toggled = false; 
			GUI.brushMenu.Buttons[2].toggled = true; 
			GUI.brushMenu.Buttons[3].toggled = false;
		}
		else if (GUI.brushMenu.Buttons[3].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_u8("brush type", 3);
			GUI.brushMenu.Buttons[0].toggled = false; 
			GUI.brushMenu.Buttons[1].toggled = false; 
			GUI.brushMenu.Buttons[2].toggled = false; 
			GUI.brushMenu.Buttons[3].toggled = true;
		}
		else if (GUI.brushSubMenu.Buttons[1].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			u8 radius = this.get_u8("brushsize");
			if(radius < 8) radius++;
			this.set_u8("brushsize", radius);
		}
		else if (GUI.brushSubMenu.Buttons[0].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			u8 radius = this.get_u8("brushsize");
			if(radius > 2) radius--;
			this.set_u8("brushsize", radius);
		}		
		else if (GUI.autoButton.isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_bool("autoing", !this.get_bool("autoing"));
			GUI.autoButton.toggled = !GUI.autoButton.toggled;
		}
		else if (controls.isKeyJustReleased( KEY_KEY_Q ) || (GUI.flipButton.isHovered && this.isKeyJustReleased( key_action1 )) )
		{
			this.set_bool("tile flipped", !this.get_bool("tile flipped"));
			GUI.flipButton.toggled = !GUI.flipButton.toggled;
		}
	}
	if (GUI.blockSubMenu.Buttons[1].toggled)
	{	
		if (GUI.teamMenu.Buttons[0].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 0);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[1].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 1);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[2].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 2);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[3].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 3);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[4].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 4);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[5].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 5);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[6].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 6);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.teamMenu.Buttons[7].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			this.set_s8("blobteam", 7);
			if(CursorBlob !is null)
			MakeNewCursorBlob(this, aimpos, CursorBlob.getName());
		}
		else if (GUI.wayMenu.Buttons[1].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			u8 num = this.get_u8("wayNum");
			if(num < 150) num++;
			this.set_u8("wayNum", num);
			CBlob@ CursorBlob = this.getCarriedBlob();
			if (CursorBlob !is null)
			CursorBlob.set_u8("wayNum",this.get_u8("wayNum"));
		}
		else if (GUI.wayMenu.Buttons[0].isHovered && this.isKeyJustReleased( key_action1 ))
		{
			u8 num = this.get_u8("wayNum");
			if(num > 0) num--;
			this.set_u8("wayNum", num);
			CBlob@ CursorBlob = this.getCarriedBlob();
			if (CursorBlob !is null)
			CursorBlob.set_u8("wayNum",this.get_u8("wayNum"));
		}
	}

	if (GUI.blockMenu.scroll.Handle.isDragging)
	{
		for (int i = 0; i < GUI.blockMenu.Buttons.length(); i++)
		{
			Vec2f bp = GUI.blockMenu.Buttons[i].localPosition;
			GUI.blockMenu.Buttons[i].position = bp+Vec2f(512-(GUI.blockMenu.scroll.size.x) * GUI.blockMenu.scroll.Handle.position.x / (GUI.blockMenu.Buttons.length()/8.4),0);
			GUI.blockMenu.Buttons[i].icon.position = bp+Vec2f(512-(GUI.blockMenu.scroll.size.x)* GUI.blockMenu.scroll.Handle.position.x / (GUI.blockMenu.Buttons.length()/8.4),0)+GUI.blockMenu.Buttons[i].IconOffset;
		}
		for (int i = 0; i < GUI.blockMenu.Buttons2.length(); i++)
		{
			Vec2f bp = GUI.blockMenu.Buttons[i].localPosition;
			GUI.blockMenu.Buttons2[i].position = bp+Vec2f(256-(GUI.blockMenu.scroll.size.x) * GUI.blockMenu.scroll.Handle.position.x / (GUI.blockMenu.Buttons2.length()/0.2),0);
			GUI.blockMenu.Buttons2[i].icon.position = bp+Vec2f(256-(GUI.blockMenu.scroll.size.x)* GUI.blockMenu.scroll.Handle.position.x / (GUI.blockMenu.Buttons2.length()/0.2),0)+GUI.blockMenu.Buttons2[i].IconOffset;
		}
		f32 mx = controls.getMouseScreenPos().x;
		float scrollpos = Maths::Clamp(mx, GUI.blockMenu.scroll.localPosition.x+32, GUI.blockMenu.scroll.size.x-16);
		controls.setMousePosition(Vec2f(scrollpos, GUI.blockMenu.scroll.position.y+12));
	}

	if (GUI.blockSubMenu.Buttons[0].toggled && this.isKeyJustReleased( key_action1 ))
	{	
		CBitStream params;

		for (int i = 0; i < GUI.blockMenu.Buttons.length(); i++)
		{
			if (GUI.blockMenu.Buttons[i].isHovered) 
			{
				canDraw = false;
				if (this.isKeyJustReleased( key_action1 ))
				{
					this.SendCommand(this.getCommandID("Kill CursorBlob"), params);
					this.set_u16("build block", bTiles[i]);
				}
			}
		}
	}
	else if (GUI.blockSubMenu.Buttons[1].toggled)
	{
		for (int i = 0; i < GUI.blockMenu.Buttons2.length(); i++)
		{
			if (GUI.blockMenu.Buttons2[i].isHovered)
			{
				canDraw = false;
				if (this.isKeyJustReleased( key_action1 ))
				{
					MakeNewCursorBlob(this, aimpos, blobNames[i]);
				}
			}
		}			
	}

	if (canDraw && (getNet().isClient()))
	{
		aimpos = map.getTileSpacePosition(this.getAimPos())*8+Vec2f(4,4);

		PickBlock(this, aimpos, map, GUI);

		CBlob@ CursorBlob = this.getCarriedBlob();
		if (CursorBlob !is null)
		{
			HandleBlobAngle(this);
			HandleBlobCursor(this, aimpos, map);
		}
		else if (this.get_u8("brush type") == 0)
		{
			HandleTileAngle(this);
			HandlePlacement0(this, aimpos, map);
		}
		else if (this.get_u8("brush type") == 1)
		{
			HandleTileAngle(this);
			HandlePlacement1(this, aimpos, map);
		}	
		else if (this.get_u8("brush type") == 2)
		{
			HandleTileAngle(this);
			HandlePlacement2(this, aimpos, map);
		} 	
		else if (this.get_u8("brush type") == 3)
		{
			HandleTileAngle(this);
			HandlePlacement3(this, aimpos, map);
		} 		
	}		
}

void MakeNewCursorBlob(CBlob@ this, Vec2f aimpos, string name)
{
	CBitStream params;
	this.SendCommand(this.getCommandID("Kill CursorBlob"), params);

	params.write_Vec2f(aimpos);	
	params.write_string(name);
	params.write_u16(this.get_u16("blob angle"));
	params.write_s8(this.get_s8("blobteam"));
	//params.write_bool(this.get_bool("tile flipped"));
	this.SendCommand(this.getCommandID("PickBlob"), params);
}

void onRender( CSprite@ this )
{		
	CBlob@ myBlob = this.getBlob();
	if (myBlob is null) return;
	if (!myBlob.isMyPlayer() ) return;
	GUIContainer@ GUI;
	if (!myBlob.get("GUI_Info", @GUI)) return; 
	if (myBlob.getPlayer() is null) return;

	//if (!this.getBlob().getPlayer().get_bool("allowedtobuild")) 
	//{
	//	GUI::DrawText("Ask a moderator for permission to build", Vec2f(16, 16), SColor(255,255,0,0));
	//	return;
	//}

	CBlob @CursorBlob = myBlob.getCarriedBlob();
	CMap@ map = getMap();

	if ( showBlockMenu )
	{		
		if (GUI.blockMenu !is null)
		{
			if (GUI.blockMenu.isEnabled)
			{
				GUI.blockMenu.draw();				
			} 

			if (GUI.blockSubMenu !is null)
			{
				if (GUI.blockSubMenu.isEnabled)
				{
					GUI.blockSubMenu.draw();				
				} 	

				if (GUI.blockSubMenu.Buttons[0].toggled)
				{
					if (GUI.brushMenu !is null)
					{
						if (GUI.brushMenu.isEnabled)
						{
							GUI.brushMenu.draw(); 

							if (GUI.brushMenu.Buttons[1].toggled && GUI.brushSubMenu !is null)
							{
								if (GUI.brushSubMenu.isEnabled)
								{
									GUI.brushSubMenu.draw();			
								} 
							}				
						}
					}
					if (GUI.autoButton !is null)
					{
						if (GUI.autoButton.isEnabled)
						{
							GUI.autoButton.draw();				
						} 
					}
					if (GUI.flipButton !is null)
					{
						if (GUI.flipButton.isEnabled)
						{
							GUI.flipButton.draw();				
						} 			
					}
				}
				else if (GUI.blockSubMenu.Buttons[1].toggled)
				{				
					if (GUI.wayMenu !is null && CursorBlob !is null && CursorBlob.getName() == "waymarkblob")
					{
						if (GUI.wayMenu.isEnabled)
						{
							GUI.wayMenu.draw();	
							GUI::DrawTextCentered(""+this.getBlob().get_u8("wayNum"), GUI.wayMenu.position+Vec2f(62,24), color_white);			
						} 			
					}
				
					if (GUI.teamMenu !is null)
					{
						if (GUI.teamMenu.isEnabled)
						{
							GUI.teamMenu.draw();			
						} 			
					}
				}		
			}
		}
				
		//if (smoothButton !is null)
		//{
		//	if (smoothButton.isEnabled)
		//	{
		//		smoothButton.draw();				
		//	} 
		//}		
		
	}	

	CBlob@[] waypoints;
	getBlobsByName("waymarkblob", @waypoints);
	for (uint i = 0; i < waypoints.length; i++)
	{
		CBlob@ way = waypoints[i];
		if (way !is null)
		{
			if (way is CursorBlob && !canDraw) continue;

			u8 wayNum = way.get_u8("wayNum");
			GUI::DrawTextCentered(""+wayNum, getDriver().getScreenPosFromWorldPos(way.getPosition()), color_white);
		}
	}
	if (!canDraw) return;

	GUI::DrawLine(aimpos+Vec2f(-4,-4), aimpos+Vec2f( 4,-4), SColor(150,255,255,255));
	GUI::DrawLine(aimpos+Vec2f( 4,-4), aimpos+Vec2f( 4, 4), SColor(150,255,255,255));
	GUI::DrawLine(aimpos+Vec2f( 4, 4), aimpos+Vec2f(-4, 4), SColor(150,255,255,255));
	GUI::DrawLine(aimpos+Vec2f(-4, 4), aimpos+Vec2f(-4,-4), SColor(150,255,255,255));

	if (myBlob.get_u8("brush type") == 3 && !myBlob.isKeyJustPressed( key_action1 ) && myBlob.isKeyPressed( key_action1 ))
	GUI::DrawLine(myBlob.get_Vec2f("temp start"), myBlob.get_Vec2f("temp finish"), SColor(150,255,255,255));	
}