#define CLIENT_ONLY
//#include "AutoTile.as";

const string world_tex = "world.png";
Vertex[] cursortiles_raw;
const u16[] square_IDs = {0,1,2,2,3,0};
Vertex[] square_raw = {
		Vertex(-4, -4, 0, 0, 0),
		Vertex( 4, -4, 0, 0, 0),
		Vertex( 4,  4, 0, 0, 0),
		Vertex(-4,  4, 0, 0, 0)
};
float[] model;

void onInit( CBlob@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";

	cursortiles_raw.clear();
	for (uint i = 0; i < 3; i++)
	{			
		cursortiles_raw.push_back(Vertex(-4, -4, 0, 0, 0));
		cursortiles_raw.push_back(Vertex( 4, -4, 0, 0, 0));
		cursortiles_raw.push_back(Vertex( 4,  4, 0, 0, 0));
		cursortiles_raw.push_back(Vertex(-4,  4, 0, 0, 0));
	}
	int id = Render::addBlobScript(Render::layer_postworld, this, "TileCursor.as", "BlobRenderFunction");
}

void BlobRenderFunction(CBlob@ this, int id)
{
	if (!this.isMyPlayer()) return;
	CBlob @CursorBlob = this.getCarriedBlob();
	if (CursorBlob is null)
	RenderCursorFor(this);
}

bool oldreversed;
u16 oldbuildtile;

void onTick( CBlob@ this )
{
	if (!this.isMyPlayer()) return;
	u16 buildtile = this.get_u16("build block");
	bool reversed = this.get_bool("tile flipped");
	u8 brushtype = this.get_u8("brush type");

	if (oldbuildtile != buildtile || oldreversed != reversed)
	{		
		f32 ubit = 0.0625f;
		f32 vbit = 0.0178571428571429f;
		u16 u =  buildtile%16;	
		u16 v =  buildtile/16;


		//if (brushtype == 0)
		{
			if (reversed)
			{
				square_raw[0].u = ((u)*ubit)+ubit;			square_raw[0].v = ((v)*vbit);
				square_raw[1].u = ((u)*ubit);				square_raw[1].v = ((v)*vbit);
				square_raw[2].u = ((u)*ubit);				square_raw[2].v = ((v)*vbit)+vbit;
				square_raw[3].u = ((u)*ubit)+ubit;			square_raw[3].v = ((v)*vbit)+vbit;
			}
			else
			{
				square_raw[0].u = ((u)*ubit);			square_raw[0].v = ((v)*vbit);
				square_raw[1].u = ((u)*ubit)+ubit;		square_raw[1].v = ((v)*vbit);
				square_raw[2].u = ((u)*ubit)+ubit;		square_raw[2].v = ((v)*vbit)+vbit;
				square_raw[3].u = ((u)*ubit);			square_raw[3].v = ((v)*vbit)+vbit;
			}
		}
		
		oldbuildtile = buildtile;
		oldreversed = reversed;
	}
}
void RenderCursorFor(CBlob@ this)
{	
	if (!this.isMyPlayer()) return;

	u16 angle = this.get_u16("build angle");
	u16 buildtile = this.get_u16("build block");
	u8 brushtype = this.get_u8("brush type");
	float radius = brushtype == 2 ? 0.25 : this.get_u8("brushsize");	
	Vec2f aimpos = getMap().getTileSpacePosition(getControls().getMouseWorldPos())*8+Vec2f(4,4);

	if (brushtype == 1)
	{
		u8 radius = this.get_u8("brushsize");
		f32 radsq = radius * radius;

		for (int x = -radius; x < radius; ++x)
		for (int y = -radius; y < radius; ++y)
		{
			Vec2f off(x, y);		

			if (off.LengthSquared() >= radsq-1)
				continue;			

			Matrix::MakeIdentity(model);
			Matrix::SetRotationDegrees(model, 0, 0, angle);	
			Matrix::SetTranslation(model, aimpos.x+(off.x*8), aimpos.y+(off.y*8), 0);
			Render::SetModelTransform(model);
			Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);
		}
	}
	else if (brushtype == 2)
	{		
			Matrix::MakeIdentity(model);
			Matrix::SetRotationDegrees(model, 0, 0, angle);	
			Matrix::SetTranslation(model, (aimpos.x), aimpos.y, 0);
			Render::SetModelTransform(model);
			Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);
	}	
	else if (brushtype == 0 && !this.isKeyJustPressed( key_action1 ))
	{
		Vec2f temp_start = this.get_Vec2f("temp start");
		Vec2f temp_finish = this.get_Vec2f("temp finish");		 
		f32 Distance_x = (temp_finish.x - temp_start.x);
		f32 Distance_y = (temp_finish.y - temp_start.y);

		for (int x_step = 0; x_step-1 < (Distance_x < 0 ? -Distance_x/8 : Distance_x/8); ++x_step)
		{
			for (int y_step = 0; y_step-1 < (Distance_y < 0 ? -Distance_y/8 : Distance_y/8); ++y_step)
			{
				Vec2f off(((Distance_x < 0 ? -x_step : x_step) * 8), ((Distance_y < 0 ? -y_step : y_step) * 8));

				Vec2f tpos = aimpos - off;
				
				Matrix::MakeIdentity(model);
				Matrix::SetRotationDegrees(model, 0, 0, angle);	
				Matrix::SetTranslation(model, tpos.x, tpos.y, 0);
				Render::SetModelTransform(model);
				Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);													
			}	
		}		
	}
	else 
if (brushtype == 3 && !this.isKeyJustPressed( key_action1 ))
{
	Vec2f temp_start = this.get_Vec2f("temp start");
	Vec2f temp_finish = this.get_Vec2f("temp finish");	

	int thickness = 4;

	float lineangle = (temp_start-temp_finish).AngleRadians()-(Maths::Pi/2);

	for (int thickCount = -thickness; thickCount < thickness; thickCount++)
	{
		int dx = Maths::Abs(((temp_finish.x - temp_start.x)/8));
		int dy = -Maths::Abs((temp_finish.y - temp_start.y)/8);	
		int sx = temp_start.x < temp_finish.x ? 8 : -8;
 		int sy = temp_start.y < temp_finish.y ? 8 : -8;
 		int err = dx+dy; 
 		int e2;
 		int x0 = temp_start.x+(thickCount*8)*-Maths::Cos(lineangle); 
 		int y0 = temp_start.y+(thickCount*8)*Maths::Sin(lineangle);
 		int x1 = temp_finish.x+(thickCount*8)*Maths::Cos(lineangle); 
 		int y1 = temp_finish.y+(thickCount*8)*-Maths::Sin(lineangle);

 		int Len_steps = Maths::Abs(dx) > Maths::Abs(dy) ? Maths::Abs(dx) : Maths::Abs(dy);

		for (int Len_step = 0; Len_step < Len_steps+1; Len_step++)
		{
			Vec2f off(x0, y0);
			Vec2f tpos = off;
			
			Matrix::MakeIdentity(model);
			Matrix::SetRotationDegrees(model, 0, 0, angle);	
			Matrix::SetTranslation(model, tpos.x, tpos.y, 0);
			Render::SetModelTransform(model);
			Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);	
		    if (x0==x1 && y0==y1) break;
		    e2 = 2*err;
		    if (e2 >= dy) { err += dy; x0 += sx; } /* e_xy+e_x > 0 */
		    if (e2 <= dx) { err += dx; y0 += sy; } /* e_xy+e_y < 0 */
		}	
	}
}

//	else if (brushtype == 3 && !this.isKeyJustPressed( key_action1 ))
//	{
//		CMap@ map = getMap();
//		u8 radius = this.get_u8("brushsize");
//		Vec2f temp_start = this.get_Vec2f("temp start");
//		Vec2f temp_finish = this.get_Vec2f("temp finish");	
//
// 		u16 lineangle = (temp_start - temp_finish).Angle();
//		int dx = Maths::Abs(temp_finish.x - temp_start.x);
//		int dy = Maths::Abs(temp_finish.y - temp_start.y);
//
// 		int Len_steps = (temp_start - temp_finish).Length();
// 		
//		for (int x_step = 0; x_step < 1+Len_steps; ++x_step)
//		{
//			//for (int y_step = -radius; y_step < radius; ++y_step)
//			{
//				Vec2f off =  Vec2f(x_step, -1 /*y_step*8*/).RotateBy(-lineangle);
//
//				Vec2f tpos = (map.getTileSpacePosition(aimpos + off)*8)+Vec2f(4,4);
//				
//				Matrix::MakeIdentity(model);
//				Matrix::SetRotationDegrees(model, 0, 0, angle);	
//				Matrix::SetTranslation(model, tpos.x, tpos.y, 0);
//				Render::SetModelTransform(model);
//				Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);													
//			}	
//		}	
//	}

	//else if (brushtype == 0)
	//{
	//	Vec2f temp_start = this.get_Vec2f("temp start");
	//	Vec2f temp_finish = this.get_Vec2f("temp finish");	
	//	f32 Distance_x = (temp_finish.x - temp_start.x);
	//	f32 Distance_y = (temp_finish.y - temp_start.y);
	//	float scalex = (Maths::Abs(Distance_x/8));
	//	float scaley = (Maths::Abs(Distance_y/8));
	//	Matrix::MakeIdentity(model);
	//	Matrix::SetRotationDegrees(model, 0, 0, angle);	
	//	Matrix::SetScale(model, 1+scalex,  1+scaley, 1.0);
	//	Matrix::SetTranslation(model, temp_finish.x-(Distance_x)/2, temp_finish.y-(Distance_y)/2, 0);
	//	Render::SetModelTransform(model);
	//	Render::RawTrianglesIndexed(world_tex, square_raw, square_IDs);
	//}
}