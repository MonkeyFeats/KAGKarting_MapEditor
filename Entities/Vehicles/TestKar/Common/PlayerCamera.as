// set camera on local player
// this just sets the target, specific camera vars are usually set in StandardControls.as

#define CLIENT_ONLY
#include "Spectator.as"

void Reset(CRules@ this)
{
	SetTargetPlayer(null);
	CCamera@ camera = getCamera();
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void onInit(CRules@ this)
{
	Reset(this);
}

void onSetPlayer(CRules@ this, CBlob@ blob, CPlayer@ player)
{
	CCamera@ camera = getCamera();
	if (camera !is null && player !is null && player is getLocalPlayer())
	{
		camera.setPosition(blob.getPosition());
		camera.setTarget(blob);
		camera.mousecamstyle = 1; // follow
		//camera.targetDistance = 1.5f; // zoom factor
		camera.posLag = 1.5f;
	}
}

// cam zoom done in standard controls