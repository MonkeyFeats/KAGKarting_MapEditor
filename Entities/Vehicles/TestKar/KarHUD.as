#include "KarCommon.as";

const string iconsFilename = "Speedometer.png";

void onInit(CSprite@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_myplayer;
	this.getCurrentScript().removeIfTag = "dead";
}

void onRender(CSprite@ this)
{	
	CBlob@ blob = this.getBlob();	
	CPlayer@ player = blob.getPlayer();
	if (blob is null || player is null) return;

	KarInfo@ kar; if (!player.get("karInfo", @kar)) { return; }
	KarBody@ moveVars; if (!blob.get("moveVars", @moveVars)) {return;}

	//const f32 HUD_X = getScreenWidth();
	const f32 HUD_Y = getScreenHeight();
	// Speedometer //
	Vec2f speedoframesize = Vec2f(192, 192);
	Vec2f offset = Vec2f(10, 38);
	Vec2f center = Vec2f(speedoframesize.x/2, HUD_Y-speedoframesize.y/2) + offset;
	GUI::DrawIcon(iconsFilename, 0, Vec2f(192, 192), center+-speedoframesize/2, 0.5f);

	// Needle
	Vec2f needlepoint = Vec2f(center.x-68, center.y+38).RotateBy(moveVars.KMPH, center);
	GUI::DrawLine2D( center, needlepoint, SColor(255,255,0,0));

	// RPMguage //	
	Vec2f rpmneedlepoint = Vec2f(center.x-28, center.y+45).RotateBy(moveVars.EngineRPM/(360/8), center+Vec2f(0,45));
	GUI::DrawLine2D( center+Vec2f(0,45), rpmneedlepoint, SColor(255,255,0,0));

	// Gear	//	
	GUI::DrawTextCentered("G "+(moveVars.CurrentGear+1), center+Vec2f(0,25), color_white);

	if (g_debug > 0) 
	{
		Vec2f pos = blob.getInterpolatedPosition();
		//Vec2f targetPos = kar.TargetWayPosition;

		//f32 angle = blob.getAngleDegrees();
		//f32 angleOffset = 270.0f;
		//f32 targetangle = (targetPos - pos).getAngle();
		//f32 angletotarget = (angle + targetangle + angleOffset) % 360;	

		GUI::SetFont("hud");
		
		//Vec2f lv = moveVars.VelocityForce;			
		//GUI::DrawArrow( pos, (pos + lv), SColor(255,0,0,255) );
		//GUI::DrawArrow( pos, kar.NextWayPosition, SColor(255,0,0,255) );
		//GUI::DrawArrow( pos, kar.TargetWayPosition, SColor(255,0,255,0) );
		//GUI::DrawArrow( pos, kar.LastWayPosition, 	SColor(255,255,0,0) );	
		//GUI::DrawText("TargetWaypointNum = " + currentway	, Vec2f(getScreenWidth()-512, 148), color_white);
		//GUI::DrawText("LastWaypointNum = "   + lastway		, Vec2f(getScreenWidth()-512, 164), color_white);
		//GUI::DrawText("CurrentLap = " 	 	 + currentLap	, Vec2f(getScreenWidth()-512, 180), color_white);

	   	int i = 10;
		Vec2f bp = blob.getInterpolatedPosition();

		GUI::DrawLine(bp+moveVars.AxleFront.LeftWheel.LocalPosition, bp+moveVars.AxleFront.RightWheel.LocalPosition, SColor(255,255,0,0)); 
		GUI::DrawLine(bp+moveVars.AxleRear.LeftWheel.LocalPosition, bp+moveVars.AxleRear.RightWheel.LocalPosition, SColor(255,255,0,0)); 
		GUI::DrawLine(bp+moveVars.AxleFront.LocalPosition, bp+moveVars.AxleRear.LocalPosition, SColor(255,255,0,0)); 

		Vec2f weightedpos = getDriver().getScreenPosFromWorldPos(bp+moveVars.CenterOfGravity); 
		GUI::DrawRectangle(weightedpos+Vec2f(-4,-4), weightedpos+Vec2f(4,4), SColor(255,255,0,0));

	    GUI::DrawText("Speed: " + moveVars.KMPH, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText("RPM: " + moveVars.EngineRPM, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText("Gear: " + (moveVars.CurrentGear + 1), Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText("LocalAcceleration: " + moveVars.LocalAcceleration, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "LocalVelocity: " + moveVars.LocalVelocity, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "Velocity: " + moveVars.Velocity, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "SteerAngle: " + moveVars.SteerAngle, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "AngularVelocity: " + moveVars.AngularVelocity, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "moveVars.CenterOfGravity: " + moveVars.CenterOfGravity, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "HeadingAngle: " + moveVars.HeadingAngle, Vec2f(32, 16*i), color_white); i++;

	    GUI::DrawText( "TireFL Weight: " + moveVars.AxleFront.LeftWheel.ActiveWeight, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireFR Weight: " + moveVars.AxleFront.RightWheel.ActiveWeight, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRL Weight: " + moveVars.AxleRear.LeftWheel.ActiveWeight, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRR Weight: " + moveVars.AxleRear.RightWheel.ActiveWeight, Vec2f(32, 16*i), color_white); i++;

	    GUI::DrawText( "TireFL Friction: " + moveVars.AxleFront.LeftWheel.FrictionForce, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireFR Friction: " + moveVars.AxleFront.RightWheel.FrictionForce, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRL Friction: " + moveVars.AxleRear.LeftWheel.FrictionForce, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRR Friction: " + moveVars.AxleRear.RightWheel.FrictionForce, Vec2f(32, 16*i), color_white); i++;

	    GUI::DrawText( "TireFL Grip: " + moveVars.AxleFront.LeftWheel.Grip, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireFR Grip: " + moveVars.AxleFront.RightWheel.Grip, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRL Grip: " + moveVars.AxleRear.LeftWheel.Grip, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "TireRR Grip: " + moveVars.AxleRear.RightWheel.Grip, Vec2f(32, 16*i), color_white); i++;

	    GUI::DrawText( "AxleF SlipAngle: " + moveVars.AxleFront.SlipAngle, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "AxleR SlipAngle: " + moveVars.AxleRear.SlipAngle, Vec2f(32, 16*i), color_white); i++;

	    GUI::DrawText( "AxleF Torque: " + moveVars.AxleFront.Torque, Vec2f(32, 16*i), color_white); i++;
	    GUI::DrawText( "AxleR Torque: " + moveVars.AxleRear.Torque, Vec2f(32, 16*i), color_white); i++;
	}
}