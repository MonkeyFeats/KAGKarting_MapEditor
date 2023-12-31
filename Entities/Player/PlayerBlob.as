
#include "PixelOffsets.as"
#include "RunnerTextures.as"

void onInit( CSprite@ this )
{
	this.SetZ(550.0f);
	ensureCorrectRunnerTexture(this, "playerblob", "Player");
	
}

void onInit(CBlob@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
	this.Tag("player");
	this.Tag("flesh");

	this.SetMapEdgeFlags(u8(CBlob::map_collide_up) | u8(CBlob::map_collide_down) | u8(CBlob::map_collide_sides));
}

void onTick(CBlob@ this)
{
	const bool left = this.isKeyPressed(key_left);
	const bool right = this.isKeyPressed(key_right);
	const bool up = this.isKeyPressed(key_up);
	const bool down = this.isKeyPressed(key_down);
	Vec2f pos = this.getInterpolatedPosition();

	u16 moveSpeed = 6;

	Vec2f MoveVel;
	if (up)
	{MoveVel.y = -moveSpeed;}
	else if (down)
	{MoveVel.y = moveSpeed;}
	if (left)
	{MoveVel.x = -moveSpeed;}
	else if (right)
	{MoveVel.x = moveSpeed;}
	this.setVelocity(MoveVel);

	//bool facing = (this.getAimPos().x <= pos.x);
	//this.SetFacingLeft(facing);
	u16 Angle = -(this.getAimPos() - pos).Angle();
	if (Angle > 360) Angle = 0;
	if (Angle < 0) Angle = 360;
	this.setAngleDegrees(Angle);
}


