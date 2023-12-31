#define CLIENT_ONLY

const string back_name = "pixel.png";
const string tex1_name = "FluidMask1.png";
const string tex2_name = "FluidMask5.png";

const int wavelength = 128;
const f32 amplitude = 24.0;
const f32 z = -500.0;
const int framesize = 256;
const int gframesize = 256;

Vertex[] water_raw_back;
Vertex[] water_raw;
Vertex[] water_raw2;
float[] model;

void onInit(CRules@ this)
{
	int water_id = Render::addScript(Render::layer_background, "WaterBackgroundRender.as", "RenderWater", 0.0f);
}

void onTick(CRules@ this)
{
	if (water_raw_back.size() > 0) return;

	CMap@ map = getMap();

	const uint width = (map.tilemapwidth*map.tilesize);
	const uint height = (map.tilemapheight*map.tilesize);

	water_raw_back.push_back(Vertex(0,      0, 	 	 0, 0, 0, 	SColor(255,10,60,120)));
	water_raw_back.push_back(Vertex(width, 	0, 	 	 0, 1, 0, 	SColor(255,10,60,120)));
	water_raw_back.push_back(Vertex(width, 	height,  0, 1, 1,  	SColor(255,10,60,120)));
	water_raw_back.push_back(Vertex(0,		height,  0, 0, 1,  	SColor(255,10,60,120)));

	water_raw.push_back(Vertex(0,       0, 	 		 1, 0, 0, 									SColor(55,80,200,180)));
	water_raw.push_back(Vertex(width, 	0, 	 		 1, width/framesize, 0, 					SColor(55,80,200,180)));
	water_raw.push_back(Vertex(width, 	height,      1, width/framesize, height/framesize,  	SColor(55,80,200,180)));
	water_raw.push_back(Vertex(0,		height,      1, 0, height/framesize,  					SColor(55,80,200,180)));

	water_raw2.push_back(Vertex(0,      0, 	 		2, 0, 0, 									SColor(20, 210, 210, 210)));
	water_raw2.push_back(Vertex(width, 	0, 	 		2, width/framesize, 0, 						SColor(20, 210, 210, 210)));
	water_raw2.push_back(Vertex(width, 	height, 	2, width/framesize, height/framesize, 		SColor(20, 210, 210, 210)));
	water_raw2.push_back(Vertex(0,		height, 	2, 0, height/framesize, 					SColor(20, 210, 210, 210)));
}

void RenderWater(int id)
{
	float time = getGameTime()*0.1;

	Render::SetAlphaBlend(true);
	Render::RawQuads(back_name, water_raw_back);

	f32 w1 =  -amplitude * Maths::Sin(Maths::Pi*2.0f*((time))/wavelength);
	f32 w2 =  -amplitude * Maths::Cos(Maths::Pi*2.0f*((time))/wavelength);

	Matrix::MakeIdentity(model);
	Matrix::SetTranslation(model, w1*1.4, -w2*1.4, 0);			
	Render::SetModelTransform(model);
	Render::RawQuads(tex1_name, water_raw);

	Matrix::MakeIdentity(model);
	Matrix::SetTranslation(model, w1, -w2, 0);			
	Render::SetModelTransform(model);
	Render::RawQuads(tex2_name, water_raw2);
}
