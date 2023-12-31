#include "Default/DefaultGUI.as"
#include "Default/DefaultLoaders.as"
#include "PrecacheTextures.as"
#include "EmotesCommon.as"

void onInit(CRules@ this)
{
	LoadDefaultMapLoaders();
	LoadDefaultGUI();

	sv_gravity = 0.0f;
	particles_gravity.y = 0.0f;
	sv_visiblity_scale = 1.25f;
	cc_halign = 2;
	cc_valign = 2;

	s_effects = false;

	sv_max_localplayers = 1;

	PrecacheTextures();

	//also restart stuff
	onRestart(this);

	Driver@ driver = getDriver();
	if (driver is null) return;

	driver.AddShader("tdwater", 1.0f);
	driver.SetShader("tdwater", true);
	driver.SetShaderExtraTexture("tdwater", CFileMatcher("/tdwater.png").getFirst());
	driver.SetShaderFloat("tdwater", "screenWidth", driver.getScreenWidth());
	driver.SetShaderFloat("tdwater", "screenHeight", driver.getScreenHeight());
	driver.ForceStartShaders();	
}

void onRestart(CRules@ this)
{
	SetChatVisible(false);
	//map borders
	CMap@ map = getMap();
	if (map !is null)
	{
		map.SetBorderFadeWidth(8.0f);
		map.SetBorderColourTop(SColor(0xff000000));
		map.SetBorderColourLeft(SColor(0xff000000));
		map.SetBorderColourRight(SColor(0xff000000));
		map.SetBorderColourBottom(SColor(0xff000000));
	}
}

void onRender(CRules@ this)
{
	if (getGameTime() == 0) return;
	Driver@ driver = getDriver();	
	if (driver is null) return;

	const float scalex = getDriver().getResolutionScaleFactor();
	const float zoom = getCamera().targetDistance * scalex;

	driver.SetShaderFloat("tdwater", "zoomscale", zoom);
	driver.SetShaderFloat("tdwater", "screenPosX", Maths::Abs(-(getCamera().getPosition().x)/getScreenWidth()));
	driver.SetShaderFloat("tdwater", "screenPosY", 1.0 + (-(getCamera().getPosition().y)/getScreenHeight()));
	driver.SetShaderFloat("tdwater", "time", getGameTime());
}

//chat stuff!
void onEnterChat(CRules @this)
{
	if (getChatChannel() != 0) return; //no dots for team chat

	CBlob@ localblob = getLocalPlayerBlob();
	if (localblob !is null)
	{
		SetChatVisible(true);
		set_emote(localblob, Emotes::dots, 100000);
	}
}

void onExitChat(CRules @this)
{	
	SetChatVisible(false);
	CBlob@ localblob = getLocalPlayerBlob();
	if (localblob !is null)
	{
		set_emote(localblob, Emotes::off);
		SetChatVisible(false);
	}
}
