///////////////////////////////////////////////////
// Basic screenspace quad Shader
///////////////////////////////////////////////////

Texture2D shaderTexture: register(t0);//A valid texture to display
SamplerState SampleType;

//Standard matrix buffer
cbuffer MatrixBuffer : register(b7)
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
	matrix gViewProj;
};

struct GeoOut
{
	float4 PosH : SV_POSITION;
	float2 tex : TEXCOORD;
};

struct VertexIn3
{
	float4 PosL : POSITION;
};

struct VertexOut2
{
};

//[Vertex shader]
VertexOut2 VS(VertexIn3 input)
{
	VertexOut2 output;
	return output;
}

[maxvertexcount(6)]
void GS(point VertexOut2 input[1], inout TriangleStream<GeoOut> OutputStream)
{
	//The four coordinates of the quad (In terms of screenspace running from -1.0 to 1.0)

	//The quad currently fills the viewport

	float2 topRight = {1.0, 1.0};
	float2 topLeft = {-1.0, 1.0};
	float2 bottomRight = {1.0, -1.0};
	float2 bottomLeft = {-1.0, -1.0};

	//Upload the coordinates to the quad

	float4 v1;
	v1.x = topLeft.x; v1.y = topLeft.y; v1.z = 0.0; v1.w = 1.0;
	
	float4 v2;//Upper 1
	v2.x = topRight.x; v2.y = topRight.y; v2.z = 0.0; v2.w = 1.0;
	
	float4 v3;
	v3.x = bottomLeft.x; v3.y = bottomLeft.y; v3.z = 0.0; v3.w = 1.0;
	
	float4 v4;//Lower 1
	v4.x = bottomRight.x; v4.y = bottomRight.y; v4.z = 0.0; v4.w = 1.0;

	float4x4 worldViewProj = mul(worldMatrix, mul(viewMatrix, projectionMatrix));

	GeoOut gout1;
	gout1.PosH = v1;
	gout1.tex.x = 0.0;
	gout1.tex.y = 0.0;

	GeoOut gout2;
	gout2.PosH = v2;
	gout2.tex.x = 1.0;
	gout2.tex.y = 0.0;
	
	GeoOut gout3;
	gout3.PosH = v3;
	gout3.tex.x = 0.0;
	gout3.tex.y = 1.0;

	OutputStream.Append(gout1);
	OutputStream.Append(gout2);
	OutputStream.Append(gout3);
	OutputStream.Append(gout2);
	OutputStream.Append(gout3);

	GeoOut gout4;
	gout4.PosH = v4;
	gout4.tex.x = 1.0;
	gout4.tex.y = 1.0;
	OutputStream.Append(gout4);

	/*
	//Texture UVs corrected for correct display

		GeoOut gout1;
		gout1.PosH = v1;// mul(v1, worldViewProj);//v1;
		gout1.tex.x = 0.0;
		gout1.tex.y = 0.0;
		OutputStream.Append(gout1);
	
		GeoOut gout2;
		gout2.PosH = v2;//mul(v2, worldViewProj);//v2;
		gout2.tex.x = 0.0;
		gout2.tex.y = 1.0;
		OutputStream.Append(gout2);
	
		GeoOut gout3;
		gout3.PosH = v3;//mul(v3, worldViewProj);//v3;
		gout3.tex.x = -1.0;
		gout3.tex.y = 0.0;

		OutputStream.Append(gout3);
		OutputStream.Append(gout2);
		OutputStream.Append(gout3);

		GeoOut gout4;
		gout4.PosH = v4;//mul(v4, worldViewProj);//v3;
		gout4.tex.x = -1.0;
		gout4.tex.y = 1.0;
		OutputStream.Append(gout4);
	*/
}

//[Pixel shader]
float4 PS(GeoOut input) : SV_TARGET
{	
	float4 textureColor;

	//Show the texture:
	textureColor = shaderTexture.Sample(SampleType, input.tex);

	//Or show a solid color:
	//textureColor.r = 1.0;
	//textureColor.g = 1.0;
	//textureColor.b = 1.0;
	//textureColor.w = 1.0;

	return textureColor;
}