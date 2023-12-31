#include "KarPNGLoader.as";
#include "KarCommon.as";
#include "Splash.as";

u16 dieTime;

void onInit(CBlob@ this)
{	
	this.getCurrentScript().removeIfTag = "dead";
	this.getCurrentScript().runFlags |= Script::tick_not_attached;	
	this.SetMapEdgeFlags( u8(CBlob::map_collide_up) | u8(CBlob::map_collide_down) | u8(CBlob::map_collide_sides) );

	this.Tag("player");			

	this.getShape().SetRotationsAllowed(true);
	this.getShape().getConsts().net_threshold_multiplier = 2.0f;

	CSprite@ sprite = this.getSprite();

	if (sprite !is null)
	{
		sprite.SetZ(100.0f); 

		CSpriteLayer@ basecoat = sprite.addSpriteLayer( "carbody", "Kar.png", 16, 24, 0, -1);
		if ( basecoat !is null)
		{
			Animation@ anim =  basecoat.addAnimation("default", 0, false);
			anim.AddFrame(1);
			basecoat.SetRelativeZ(1.0f);
			basecoat.SetOffset(Vec2f(-0.25f, 0.0f));
			basecoat.ScaleBy(Vec2f(0.5, 0.5));
		}

		CSpriteLayer@ decal = sprite.addSpriteLayer( "decal", "Kar.png", 16, 24, 0, -1);
		if (decal !is null)
		{
			Animation@ anim = decal.addAnimation("default", 0, false);
			int[] frames = {2,3,4,5,6,7,8,9,10,11,12,13,14};
			anim.AddFrames(frames);
			decal.SetOffset(Vec2f(-0.25f, 0.0f));
			decal.ScaleBy(Vec2f(0.5, 0.5));
		}				
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if (solid)
	{
		Vec2f vel = this.getOldVelocity();
		float velleng = vel.Length();

		if (velleng > 2)
		{
			this.getSprite().PlayRandomSound("/carcrash",velleng/10);
			sparks(point1, velleng);

			if (this.isMyPlayer())
			ShakeScreen(velleng, velleng*2, point1);
		}	
	}
}

void onTick(CBlob@ this)
{
	CPlayer@ player = this.getPlayer();
	if (player is null) return;

	if (this.getTickSinceCreated() == 5)
	{
		if (!getRules().isMatchRunning()) //one time setup
		{
			player.set_bool("Finished", false);
			KarInfo kar;						
			player.set("karInfo", kar);
		}

		KarInfo@ kar;
		if (player.get("karInfo", @kar))
		{
			this.server_setTeamNum(kar.Colour);
			if (this.getSprite() !is null)
			{
				CSpriteLayer@ decal = this.getSprite().getSpriteLayer("decal"); //need to reload for the colour to change
				if (decal !is null)
				{		
					decal.ReloadSprite("Kar.png", 16, 24, kar.DecalColour, -1);	
					decal.SetFrameIndex(kar.Decal);				
					//decal.setRenderStyle(RenderStyle::additive);
					//decal.SetColor( SColor(255,255,255,0) );
					decal.SetOffset(Vec2f(-0.25f, 0.0f));
					decal.SetRelativeZ(10.0f);
					decal.SetVisible(true);
				}
			}	
		}
	}

	CBlob@[] overlapping;
	getMap().getBlobsAtPosition(this.getPosition(), @overlapping);
	bool foundpass = false;
	for(uint i = 0; i < overlapping.length; i++)
	{
		CBlob@ o_blob = overlapping[i];
		if (o_blob !is null)
		{
			if (o_blob.getName() == "roadunderpass")
			{
				foundpass = true;
				if (!this.hasTag("overpassing"))
				{
					this.Tag("underpassing");
					//this.getSprite().setRenderStyle(RenderStyle::shadow);
				}
			}
			else if (o_blob.getName() == "roadoverpass")
			{
				foundpass = true;
				if (!this.hasTag("underpassing"))
				{
					this.Tag("overpassing");
				}
			} 
		}
	}	
	if (!foundpass)
	{
		//this.getSprite().setRenderStyle(RenderStyle::normal);
		this.Untag("overpassing");
		this.Untag("underpassing");
	}
}

void onDie(CBlob@ this)
{
	SetScreenFlash( 0, 255, 255, 255 ); // clear red screen bug
}

void sparks(Vec2f at, f32 damage)
{
	int amount = int(damage + XORRandom(5));

	for (int i = 0; i < amount; i++)
	{
		Vec2f vel = getRandomVelocity(0, damage/1.5f, 360.0f);
		CParticle@ p = ParticlePixel(at, vel, SColor(255, 200+ XORRandom(55), 200+ XORRandom(55), 100+XORRandom(155)), true, 15+ XORRandom(45));
		if (p !is null)
		{
			p.Z =1000;
			p.damping =  0.92;
		}
	}
}

void colsparks(Vec2f at, f32 damage)
{
	int amount = int(damage + XORRandom(5));

	for (int i = 0; i < amount; i++)
	{
		Vec2f vel = getRandomVelocity(0, damage/1.5f, 360.0f);
		CParticle@ p = ParticlePixel(at, vel, SColor(255, 100+ XORRandom(155), 100+ XORRandom(155), 100+XORRandom(155)), true, 15+ XORRandom(45));
		if (p !is null)
		{
			p.Z =1000;
			p.damping =  0.92;
		}
	}
}
