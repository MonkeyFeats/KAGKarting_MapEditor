

namespace WeaponType
{
	enum type
	{
		none = 0,
		greenshell,
		redshell,
		banana,
		mushroom
	};
}

shared class KarInfo
{
	Vec2f[][] waypoints;
	u8 WaypointsPast;
	u8 CurrentLap;
	u8 WaypointLap;	
	u8 TargetWaypointNum;
	u8 NextWaypointNum;
	u8 LastWaypointNum;
	Vec2f TargetWayPosition;
	Vec2f NextWayPosition;
	Vec2f LastWayPosition;
	int Placement;
	u8 Colour;
	u8 Decal;
	u8 DecalColour;

	f32 DistanceToEnd;

	bool Has_Weapon;
	u8 Weapon_Type;

	KarInfo()
	{
		CurrentLap = 1;
		WaypointsPast = 0;
		NextWaypointNum = 1;
		TargetWaypointNum = 0;	
		LastWaypointNum = waypoints.length()-1;
		TargetWayPosition = Vec2f_zero;
		NextWayPosition = Vec2f_zero;
		LastWayPosition = Vec2f_zero;		
		Placement = 1;
		DistanceToEnd = 0;
		Has_Weapon = false;		
		Weapon_Type = 0;//WeaponType::none;	

		Colour = XORRandom(8);
		Decal = XORRandom(12);
		DecalColour = XORRandom(8);			
	}
};

shared class KarWheel
{
	Vec2f Origin;
	Vec2f LocalPosition;	
	float HeadingAngle;

	float RestingWeight;
	float ActiveWeight;
	float Grip;
	float FrictionForce;
	float Torque;
	bool SkidActive;

	KarWheel(){}
	KarWheel(Vec2f _offpos, float _angle)
	{
		Origin = _offpos;
		LocalPosition = _offpos;
		HeadingAngle = _angle;	
		SkidActive = false;
		Torque = 0;
	}

	void Update(CBlob@ blob, float karAngle, Vec2f karpos, float karAbsoluteVelocity)
	{	
		Vec2f OriginRotated = Origin;
		OriginRotated.RotateBy(-karAngle);
		LocalPosition = OriginRotated;

		uint16 type = getMap().getTile(karpos+LocalPosition).type;

		switch(type)
		{
			case 384: // road
			case 385:
			case 386:
			case 387:
			{
				if (SkidActive)
				{
					CParticle@ p = ParticlePixel(karpos+LocalPosition, Vec2f_zero, color_black, true, 30);
					if (getGameTime() % 5 == 0)
					makeSmokeParticle(karpos+LocalPosition);					
				}
			}break;

			case 544: // rumbler
			case 545:
			case 536:
			case 547:
			case 496 :
			case 497 :
			case 498 :
			case 499 :
			case 500 :
			case 501 :
			case 502 :
			case 503 :
			case 504 :
			case 505 :
			case 506 :
			case 507 :
			case 508 :
			case 510 :
			case 511 :
			{
				if (karAbsoluteVelocity > 1)
				{
					blob.getSprite().PlayRandomSound("/RumblerHit", 0.6+(karAbsoluteVelocity/20), 0.1+(karAbsoluteVelocity/6));

				}

				if (SkidActive)
				{
					CParticle@ p = ParticlePixel(karpos+LocalPosition, Vec2f_zero, color_black, true, 30);
					if (getGameTime() % 5 == 0)
					makeSmokeParticle(karpos+LocalPosition);					
				}
			}break;

			case 388: // grass
			case 389:
			case 390:
			case 391:
			case 392: // sand
			case 393:
			case 394:
			case 395:
			case 396: // dirt
			case 397:
			case 398:
			case 399:
			{
				if (karAbsoluteVelocity > 1)
				//if (SkidActive)
				{
					CParticle@ p = ParticlePixel(karpos+LocalPosition, Vec2f_zero, SColor(0xff371f0e), true, 30);
					if (getGameTime() % 12 == 0)
					blob.getSprite().PlayRandomSound("/Dirty", 0.4+(karAbsoluteVelocity/20), 0.5+(karAbsoluteVelocity/15));
				}
			}break;
		}	
		
		//SkidActive = Maths::Abs(FrictionForce) > 5000.0;	

		if (SkidActive)
		{
			float ff = Maths::Abs(FrictionForce/7000);
			if (getGameTime() % 2 == 0)
			Sound::Play("CarSkidding2.ogg", karpos+LocalPosition, 0.4+(karAbsoluteVelocity/20), 0.1+(karAbsoluteVelocity/8));
					
		}
	}

	void makeSmokeParticle(Vec2f pos)
	{
		string texture;
		switch (XORRandom(2))
		{
			case 0: texture = "Entities/Effects/Sprites/SmallSmoke1.png"; break;
			case 1: texture = "Entities/Effects/Sprites/SmallSmoke2.png"; break;
		}
		ParticleAnimated(texture, pos, Vec2f(0, 0), 0.0f, 1.0f, 2, 0.0f, true);
	}
};

shared class KarAxel
{
	KarWheel@ LeftWheel;
	KarWheel@ RightWheel;

	Vec2f Origin;
	Vec2f LocalPosition;
	float WheelDiameter;
	float RollingCircumference;
	float ActiveWeight;
	float WeightRatio;
	float DistanceToCG;
	float SlipAngle;
	float FrictionForce;
	float Torque; 

	KarAxel(){}
	KarAxel(float _Wheeloffpos, float _Axleoffpos, float _angle)
	{
		Origin = Vec2f(0,_Axleoffpos);
		LocalPosition = Vec2f(0,_Axleoffpos);
		WheelDiameter = 0.65;	//diameter in meters
		RollingCircumference = WheelDiameter*Maths::Pi;		
		@LeftWheel = KarWheel(Vec2f(-_Wheeloffpos,_Axleoffpos), _angle);		
		@RightWheel = KarWheel(Vec2f(_Wheeloffpos,_Axleoffpos), _angle);		
	}

	void Update(CBlob@ blob, float karAngle, Vec2f karpos, float karAbsoluteVelocity)
	{
		Vec2f OriginRotated = Origin;
		OriginRotated.RotateBy(-karAngle);
		LocalPosition = OriginRotated;

		LeftWheel.Update(blob, karAngle,karpos,karAbsoluteVelocity);
		RightWheel.Update(blob, karAngle,karpos,karAbsoluteVelocity);		

		Torque = Maths::Lerp(Torque, (LeftWheel.Torque + RightWheel.Torque) / 2.0f, 0.45); // pretend flywheel lerp
	}
};

shared class KarBody
{
	f32 KMPH;
	f32 EngineRPM;
	int CurrentGear;

	KarAxel@ AxleFront;
	KarAxel@ AxleRear;

	float GearRatio;
	float CGHeight;
	float Mass;
	float BrakePower;
	float EBrakePower;
	float WeightTransfer;
	float MaxSteerAngle;
	float CornerStiffnessFront;
	float CornerStiffnessRear;
	float AirResistance;
	float RollingResistance;
	float EBrakeGripRatioFront;
	float TotalTireGripFront;
	float EBrakeGripRatioRear;
	float TotalTireGripRear;
	float SteerPower;
	float SteerAngle;
	float SteerCorrectionAmount;
	float SpeedTurningStability;
	float WheelBase;
	float TrackWidth;	
	float HeadingAngle; 
	Vec2f LocalAcceleration;
	Vec2f LocalVelocity;
	Vec2f Velocity;
	Vec2f VelocityForce;
	Vec2f CenterOfGravity;	
	float AngularVelocity;
	float AngularForce;

	u16 PeakRPM;
	u16[] OptimalShiftUpRPM;
	u16[] OptimalShiftDownRPM; 

	int[] TorqueCurve;
	float[] GearRatios;
	float EffectiveGearRatio;

	float ClutchTimer = 0;

	void Update(CBlob@ blob, float Throttle, float Brake, float EBrake, float steerInput)
	{		
		const float gravity = 9.81f;
		Vec2f Pos = blob.getInterpolatedPosition();
		Velocity = blob.getVelocity();
		HeadingAngle = (blob.getAngleDegrees()); // -90 degrees

		AngularVelocity = blob.getAngularVelocity();	
		float AbsoluteVelocity = Velocity.Length();	
		Vec2f localvelvec = Velocity;
		LocalVelocity = localvelvec.RotateBy(-HeadingAngle);	

		KMPH = Maths::Abs(LocalVelocity.Length())*16;
		f32 MetersPerSec = KMPH*0.2777778;
		
		EngineRPM = KMPH / (Maths::Pi * 2 / 60.0f) * (getGearRatio() * EffectiveGearRatio);

		while (EngineRPM < 700) 
		{
			EngineRPM += 30;//bubububu
		}

		// gears //
		if (EngineRPM > 6000 && CurrentGear != 5 && ClutchTimer == 0)
	 	{ 			
	 		CurrentGear+=1; ClutchTimer = 6;
	 	}	
	 	else if (EngineRPM < 3000 && CurrentGear != 0 && ClutchTimer == 0)
	 	{
	 		CurrentGear-=1;  ClutchTimer = 2;
	 	}
	 	if (ClutchTimer > 0)
	 	{
	 		ClutchTimer--;
	 	}

	 	// Cleanup
		if (Velocity.Length() < 0.01f && Throttle == 0)
		{
			AbsoluteVelocity = 0;
			Velocity = Vec2f_zero;
			LocalAcceleration = Vec2f_zero;
			LocalVelocity = Vec2f_zero;
			VelocityForce = Vec2f_zero;
			SteerAngle = 0;
			AngularForce = 0;
			AxleFront.SlipAngle = 0;
			AxleRear.SlipAngle = 0;
			AxleRear.Torque = 0;
			AxleFront.Torque = 0;
			return;
		}
		// Forces
	 	int SignedY;
	 	if (LocalVelocity.y > 0)
	 	SignedY = 1;
	 	else if (LocalVelocity.y < 0)
	 	SignedY = -1;

		// Steering direction	
		SteerAngle = SmoothSteering(-SignedY*steerInput, AbsoluteVelocity) * MaxSteerAngle;

		// steer wheel angle, unused atm
		AxleFront.RightWheel.HeadingAngle = HeadingAngle+SteerAngle;
		AxleFront.LeftWheel.HeadingAngle = HeadingAngle+SteerAngle;		
		AxleRear.RightWheel.HeadingAngle = HeadingAngle;
		AxleRear.LeftWheel.HeadingAngle = HeadingAngle;

		// Weight transfer
		float transferX = (WeightTransfer * LocalVelocity.x * (TrackWidth*0.01))*Mass;
		float transferY = (WeightTransfer * LocalVelocity.y * (WheelBase*0.01)); 

		// Weight on each axle
		float weightFront =  Mass*(AxleFront.WeightRatio + transferY);
		float weightRear =  Mass*(AxleRear.WeightRatio - transferY);

		// Weight on each tire
		AxleFront.LeftWheel.ActiveWeight = (weightFront - transferX);
		AxleFront.RightWheel.ActiveWeight = (weightFront + transferX);
		AxleRear.LeftWheel.ActiveWeight = (weightRear - transferX);
		AxleRear.RightWheel.ActiveWeight = (weightRear + transferX);

		// Calculate weight center of four tires
		Vec2f wpos;
		if (LocalAcceleration.Length() > 1.0f) 
		{
			float wfl =  AxleFront.LeftWheel.ActiveWeight;
			float wfr = AxleFront.RightWheel.ActiveWeight;
			float wrl =   AxleRear.LeftWheel.ActiveWeight;
			float wrr =  AxleRear.RightWheel.ActiveWeight;

			wpos = ((AxleFront.LeftWheel.LocalPosition * wfl) +
				   (AxleFront.RightWheel.LocalPosition * wfr) +
				   (AxleRear.LeftWheel.LocalPosition * wrl) +
				   (AxleRear.RightWheel.LocalPosition * wrr));				   		
			float weightTotal = wfl + wfr + wrl + wrr;

			wpos/=weightTotal;				
		}			
		CenterOfGravity = wpos;			

		// Slip angle
		AxleFront.SlipAngle = Maths::ATan2(LocalVelocity.x, Maths::Abs(LocalVelocity.y)) - ((SteerAngle/MaxSteerAngle));
		AxleRear.SlipAngle =  Maths::ATan2(LocalVelocity.x, Maths::Abs(LocalVelocity.y));

		// Brake and Throttle power	
		float activeBrake = Maths::Min(Brake * BrakePower + EBrake * EBrakePower, BrakePower);
		float activeThrottle = (Throttle * GetTorque()) * (getGearRatio() * EffectiveGearRatio);
		
		// Torque of each tire (rear wheel drive)
		AxleRear.LeftWheel.Torque = activeThrottle / (AxleRear.WheelDiameter/2);
		AxleRear.RightWheel.Torque = activeThrottle / (AxleRear.WheelDiameter/2);

		// Grip and Friction of each tire
		AxleFront.LeftWheel.Grip = TotalTireGripFront + (EBrake * (EBrakeGripRatioFront));
		AxleFront.RightWheel.Grip = TotalTireGripFront + ( EBrake * (EBrakeGripRatioFront));
		AxleRear.LeftWheel.Grip = TotalTireGripRear + ( EBrake * (EBrakeGripRatioRear));
		AxleRear.RightWheel.Grip = TotalTireGripRear + (EBrake * (EBrakeGripRatioRear));

		AxleFront.LeftWheel.FrictionForce = (Maths::Clamp(-CornerStiffnessFront * AxleFront.SlipAngle, -AxleFront.LeftWheel.Grip, AxleFront.LeftWheel.Grip) * (AxleFront.LeftWheel.ActiveWeight));
		AxleFront.RightWheel.FrictionForce = (Maths::Clamp(-CornerStiffnessFront * AxleFront.SlipAngle, -AxleFront.RightWheel.Grip, AxleFront.RightWheel.Grip) * (AxleFront.RightWheel.ActiveWeight));
		AxleRear.LeftWheel.FrictionForce = (Maths::Clamp(-CornerStiffnessRear * AxleRear.SlipAngle, -AxleRear.LeftWheel.Grip, AxleRear.LeftWheel.Grip) * (AxleRear.LeftWheel.ActiveWeight));
		AxleRear.RightWheel.FrictionForce = (Maths::Clamp(-CornerStiffnessRear * AxleRear.SlipAngle, -AxleRear.RightWheel.Grip, AxleRear.RightWheel.Grip) * (AxleRear.RightWheel.ActiveWeight));

		AxleFront.Update(blob, -HeadingAngle, Pos, AbsoluteVelocity);
		AxleRear.Update(blob, -HeadingAngle, Pos, AbsoluteVelocity);	

		//combined weights on axles
		AxleFront.FrictionForce = (AxleFront.LeftWheel.FrictionForce + AxleFront.RightWheel.FrictionForce); 
		AxleRear.FrictionForce = (AxleRear.LeftWheel.FrictionForce + AxleRear.RightWheel.FrictionForce); 

		// SlipRatio = ( (Vehicle Speed - Wheel Rotation Speed) / Vehicle Speed) * 100

		// tire traction against ground
		float tractionForceX = 0;
		float tractionForceY = ((AxleRear.Torque) - activeBrake * -SignedY);

		uint16 groundtype = getMap().getTile(Pos).type;	
		// tire drag
		float dragForceY = (((-RollingResistance * LocalVelocity.y) - (AirResistance * LocalVelocity.y)) * AbsoluteVelocity)*getGroundDrag(groundtype);
		float dragForceX = (((-RollingResistance * LocalVelocity.x) - (AirResistance * LocalVelocity.x)) * AbsoluteVelocity)*getGroundDrag(groundtype);
		
		float totalForceX = dragForceX + tractionForceX + (AxleFront.FrictionForce+AxleRear.FrictionForce);
		float totalForceY = -dragForceY + tractionForceY;

		//adjust X force so it levels out the car heading at high speeds
		if (AbsoluteVelocity > 10) {
			totalForceX *= (AbsoluteVelocity+1) / (21.0f - SpeedTurningStability);
		}

		// Finalizing forces
		LocalAcceleration = Vec2f(totalForceX,-totalForceY);// / Mass;
		Vec2f localAccelVec = LocalAcceleration * 0.01;
		localAccelVec.RotateBy(HeadingAngle);

		VelocityForce = localAccelVec;

		f32 angularTorque = ((AxleFront.FrictionForce - AxleRear.FrictionForce)/1000)*SteerCorrectionAmount;	
		f32 angularAcceleration = (angularTorque+SteerAngle) * 0.01;	
		
		AngularForce += angularAcceleration;
		AngularForce = Maths::Lerp(AngularForce, 0, 0.035);

		// checking absolute vel again after adding forces
		AbsoluteVelocity = Velocity.Length();
		// Speed is too low to turn
		if ((AbsoluteVelocity < 0.5 && Maths::Abs(SteerAngle) < 0.1) || KMPH < 0.01f) {
			AngularForce = 0;
		}	

		// Skidmarks
		if (Maths::Abs(LocalAcceleration.x) > 17100 || EBrake == 1) 
		{
			AxleRear.RightWheel.SkidActive = true;
			AxleRear.LeftWheel.SkidActive = true;
		} else 
		{
			AxleRear.RightWheel.SkidActive = false;
			AxleRear.LeftWheel.SkidActive = false;
		}
	}
	
	float getGearRatio() {return GearRatios[CurrentGear];} 

	f32 GetTorque()
	{	
		f32 T;	
		int RpmRange = Maths::Floor(EngineRPM/1000);		
		switch(RpmRange)
		{
			case 0: T = Maths::Lerp(TorqueCurve[0], TorqueCurve[1],  EngineRPM / 1000);
			case 1: T = Maths::Lerp(TorqueCurve[1], TorqueCurve[2], (EngineRPM - 1000) / 1000);
			case 2: T = Maths::Lerp(TorqueCurve[2], TorqueCurve[3], (EngineRPM - 2000) / 1000);
			case 3: T = Maths::Lerp(TorqueCurve[3], TorqueCurve[4], (EngineRPM - 3000) / 1000);
			case 4: T = Maths::Lerp(TorqueCurve[4], TorqueCurve[5], (EngineRPM - 4000) / 1000);
			case 5: T = Maths::Lerp(TorqueCurve[5], TorqueCurve[6], (EngineRPM - 5000) / 1000);
			case 6: T = Maths::Lerp(TorqueCurve[6], TorqueCurve[7], (EngineRPM - 6000) / 1000);
		}
		return T;
	}	

	float SmoothSteering(float steerInput, float AbsoluteVelocity) 
	{
		float steer = 0;
		if(Maths::Abs(steerInput) > 0.001f) {
			steer = Maths::Clamp(SteerAngle + steerInput * SteerPower, -1.0f, 1.0f); 
		}
		else
		{
			if (SteerAngle > 0) {
				steer = Maths::Max(SteerAngle - 1, 0);
			}
			else if (SteerAngle < 0) {
				steer = Maths::Min(SteerAngle + 1, 0);
			}
		}

		float activeVelocity = Maths::Min(AbsoluteVelocity, 250.0f);
		steer = steerInput * (1.0f - (AbsoluteVelocity / 30));

		return steer;
	}	

	float getGroundDrag(uint16 type)
	{
		//float groundtypedrag = 1.0;
		switch(type)
		{
			case 0: // water
			{
				return 1000.0f;
			}break;	
			//case 384: // road
			//case 385:
			//case 386:
			//case 387:
			//case 512: // rumbler
			//case 513:
			//case 514:
			//case 515:
			//{
			//	groundtypedrag = 1.0f;
			//}break;

			case 388: // grass
			case 389:
			case 390:
			case 391:
			case 392: // sand
			case 393:
			case 394:
			case 395:
			case 396: // dirt
			case 397:
			case 398:
			case 399:
			{
				return 25.0f;
			}break;					
		}
		return 0.25f;
	}
};
