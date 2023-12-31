// Kar Movement
#include "KarCommon.as";

void onInit(CMovement@ this)
{
	this.getCurrentScript().removeIfTag = "dead";
	this.getCurrentScript().runFlags |= Script::tick_not_attached;	

	KarBody engine;
	@engine.AxleFront = KarAxel( 2.1, -3.5, 0);
	@engine.AxleRear =  KarAxel( 2.1,  4,   0);

	engine.EngineRPM = 750;
	engine.CurrentGear = 0;

	engine.CGHeight = 0.55f;
	engine.Mass = this.getBlob().getMass();
	engine.BrakePower = 12000;
	engine.EBrakePower = 55000;
	engine.WeightTransfer = 1.1f;
	engine.CornerStiffnessFront = 20.0f;
	engine.CornerStiffnessRear = 20.0f;
	engine.AirResistance = 30.0f;
	engine.RollingResistance = 30.0f;
	engine.TotalTireGripFront = 2.6f;
	engine.TotalTireGripRear = 3.0f;
	engine.EBrakeGripRatioFront = 2.5f;
	engine.EBrakeGripRatioRear = 0.15f;
	engine.MaxSteerAngle = 15.0f;
	engine.SteerPower = 0.15f;
	engine.SteerCorrectionAmount = 0.8f;
	engine.SpeedTurningStability = 10.0f;

	// Left wheels to right wheels distance 
	engine.TrackWidth = (Maths::Abs(engine.AxleRear.LeftWheel.Origin.x) + Maths::Abs(engine.AxleRear.RightWheel.Origin.x));
	// Front axle to back axle distance
	engine.WheelBase = (Maths::Abs(engine.AxleFront.Origin.y) + Maths::Abs(engine.AxleRear.Origin.y));	

	// Axle distance from center
	// Extend the calculations past actual car dimensions for better simulation	... too much and it becomes a go-kart/rc-car
	engine.AxleFront.DistanceToCG = Maths::Abs(engine.AxleFront.LocalPosition.y)*2.2;
	engine.AxleRear.DistanceToCG = Maths::Abs(engine.AxleRear.LocalPosition.y)*2.2;	

	// Calculate resting weight of each Tire
	engine.AxleFront.WeightRatio = engine.AxleFront.DistanceToCG / engine.WheelBase;
	float weightF = engine.Mass * 9.81f * engine.AxleFront.WeightRatio;
	engine.AxleFront.LeftWheel.RestingWeight = weightF;
	engine.AxleFront.RightWheel.RestingWeight = weightF; 

	engine.AxleRear.WeightRatio = engine.AxleRear.DistanceToCG / engine.WheelBase;
	float weightR = engine.Mass * 9.81f * engine.AxleRear.WeightRatio;
	engine.AxleFront.LeftWheel.RestingWeight = weightR;
	engine.AxleFront.RightWheel.RestingWeight = weightR;

	int[] eCurve = { 100, 200, 325, 420, 460, 340, 270, 100 }; // horsepower at each x1000 rpm
	engine.TorqueCurve = eCurve;	
	float[] gRatios = { 3.9f, 2.9f, 2.3f, 1.5f, 1.0f, 0.79f}; engine.EffectiveGearRatio =  2.4f;
	engine.GearRatios = gRatios;

	//engine.PeakRPM = 6000;
	//engine.OptimalShiftUpRPM = gRatios[CurrentGear]/gRatios[CurrentGear+1])*engine.PeakRPM;
	//engine.OptimalShiftDownRPM = gRatios[CurrentGear]/gRatios[CurrentGear-1])*engine.PeakRPM;		

	this.getBlob().set("moveVars", engine);
}
void onTick(CMovement@ this)
{	
	CBlob@ blob = this.getBlob();
	if (blob is null) return;
	KarBody@ engine;
	if (!blob.get("moveVars", @engine))
	{ return; }

	//if (blob.isMyPlayer() || blob.isBot()) //needed?
	{
		const bool left		= blob.isKeyPressed(key_left);
		const bool right	= blob.isKeyPressed(key_right);
		const bool up		= blob.isKeyPressed(key_up);
		const bool down		= blob.isKeyPressed(key_down);
		const bool use		= blob.isKeyPressed(key_use);
		//const bool spacebar	= blob.isKeyPressed(key_action3); // has problems for no reason

		float Throttle = 0;
		float Brake = 0;
		float EBrake = 0;	
		float Steer = 0;

		if (up && !down && engine.ClutchTimer == 0) {Throttle = 1;} 
		else if (!up && down && -engine.LocalVelocity.y > 0.5f  && engine.ClutchTimer == 0) {Throttle = 0; Brake = 1;}	
		else if (!up && down  && engine.ClutchTimer == 0) {Throttle = -1;}
		else {Throttle = 0;}

		if(!left && right) { Steer = 1;} //brake = 1?
		else if(left && !right)	{ Steer = -1;}
		else {Steer = 0;}

		if(blob.isKeyPressed(key_action3))
		{ EBrake = 1; }
		else {EBrake = 0;}		

		if (getRules().isWarmup() && up)
		{
			engine.EngineRPM += 150;
			if (engine.EngineRPM > 7000)
			engine.EngineRPM -= 500+XORRandom(500);
		}
		else if (getRules().isWarmup() && !up)
		{
			engine.EngineRPM -= 150;
			if (engine.EngineRPM < 750)
			engine.EngineRPM += 250+XORRandom(250);
		}
		else
		engine.Update(blob, Throttle, Brake, EBrake, Steer);
		
		if(!getRules().isWarmup()) //netural 
		{
			blob.getShape().SetCenterOfMassOffset(engine.CenterOfGravity);
			blob.AddForce(engine.VelocityForce);
			blob.setAngularVelocity(engine.AngularForce);
		}	

		//if (engine.KMPH > 120 && blob.isMyPlayer() )
		//ShakeScreen((engine.KMPH-120)*0.2, 10, blob.getPosition());
	}	

	CSprite@ sprite = blob.getSprite();
	if (sprite !is null)
	{
		sprite.SetEmitSound("engine2.ogg");
		sprite.SetEmitSoundPaused(false);
		sprite.SetEmitSoundVolume(0.15f);
		sprite.SetEmitSoundSpeed(0.3f + (engine.EngineRPM/7000));	
		//sprite.getVars().sound_emit_pitch = 0.5f + (engine.EngineRPM/6000);
	}	
}
