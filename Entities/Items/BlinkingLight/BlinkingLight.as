#include "TeamColour.as"

void onInit(CBlob@ this)
{
	this.SetLight(true);
	this.SetLightRadius(24.0f);
	this.SetLightColor(getTeamColor(this.getTeamNum()));
	this.getCurrentScript().tickFrequency = 30;
}

bool on = true;
void onTick(CBlob@ this)
{
	on = !on;
	this.SetLight(on);
}