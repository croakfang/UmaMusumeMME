/****************
Made by CroakFang
Update Date: 2023-11-26
Project Address: https://github.com/croakfang/UmaMusumeMME
Description: This MME requires models exported with UmaViewer to fully achieve its effects.
This file must be saved in UTF-8 encoding to function correctly.
Non-alphabetic characters must be encoded in Shift-JIS, or they will not be recognized. For example, the character "頭" should be written as "摢".
****************/
#define cmp -
float4x4 UNITY_MATRIX_V				:WORLDVIEW;
float4x4 UNITY_MATRIX_VP			:WORLDVIEWPROJECTION;
float4x4 UNITY_MATRIX_I_V			:WORLDVIEW;
float4x4 UNITY_MATRIX_P			    :PROJECTION;
float4x4 unity_ObjectToWorld		:WORLD;
float4x4 unity_WorldToObject		:WORLDINVERSE;


float3 _WorldSpaceLightPos		:DIRECTION < string Object = "Light"; > ;
float3 _WorldSpaceCameraPos		:POSITION < string Object = "Camera"; > ;

texture MainTexture : MATERIALTEXTURE; //Unused in this fx
texture MainTex < string ResourceName = "Texture2D/tex_chr1089_30_eye0_all.png"; >;
texture High0Tex < string ResourceName = "Texture2D/tex_chr1089_30_eyehi00.png"; >;
texture High1Tex < string ResourceName = "Texture2D/tex_chr1089_30_eyehi01.png"; >;
texture High2Tex < string ResourceName = "Texture2D/tex_chr1089_30_eyehi02.png"; >;

sampler2D _MainTex  = sampler_state { texture = <MainTex>;	MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _High0Tex = sampler_state { texture = <High0Tex>;	    MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _High1Tex = sampler_state { texture = <High1Tex>;	    MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _High2Tex = sampler_state { texture = <High2Tex>;		MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };


float _EyePupliScale = 1;
float4 _MainParam[] = { float4(0, 0, 0, 0), float4(0, 0, 0, 0) }; // Left and right eye offsets , x(0-3): eye type
float4 _HighParam1[] = { float4(0, 0, 0, 0.22), float4(0, 0, 0, 0.22), float4(0, 0, 0, 0) }; // Left eye upper highlight (w value for intensity), left eye lower highlight, and bilateral blink effect
float4 _HighParam2[] = { float4(0, 0, 0, 0.22), float4(0, 0, 0, 0.22), }; // Right eye upper highlight, right eye lower highlight
float4 _MainTex_ST = float4(0.25, 1, 0, 0);
float4 _High0Tex_ST = float4(1, 1, 0, 0);
float4 _Offset = 1;

float4 _Global_FogMinDistance = 0;
float4 _Global_FogLength = 0;
float _Global_MaxHeight = 10;
float4 _Global_FogColor = 0;
float _Global_MaxDensity = 10;

float3 _FaceCenterPos : CONTROLOBJECT < string name = "Curren.pmx"; string item = "頭"; > ;
float3 _FaceUp = float3(0, 1, 0);
float _CylinderBlend = 0.25;

float _UseOriginalDirectionalLight = 0;
float3 _OriginalDirectionalLightDir = 0;

float _ToonStep = 0.4;
float _ToonFeather = 0.1;
float _Limit = 0.1;//Hightlight Limit, keep it > 0 

float4 _GlobalToonColor = float4(1, 1, 1, 0);
float4 _ToonBrightColor = float4(1, 1, 1, 0);
float4 _ToonDarkColor = float4(1, 1, 1, 0);
float4 _CharaColor = 1;
float4 _LightProbeColor = 1;

float _Saturation = 1;


int FloatToInt(float f)
{
	struct FloatInt
	{
		int    i;
		float  f;
	};
	FloatInt ret = { 0,0 };
	FloatInt bias = { 0,0 };
	ret.f = f;
	bias.i = (23 + 127) << 23;
	if (f < 0.0f) { bias.i = ((23 + 127) << 23) + (1 << 22); }
	ret.f += bias.f;
	ret.i -= bias.i;
	return ret.i;
}

/****************
For models exported from UmaViewer:
UV0 --> model UV
UV1 --> Additional UV1
UV2 --> Additional UV2
Vertex Color -->Additional UV3
****************/

struct a2v {
	float4 v0 : POSITION;
	float3 v1 : NORMAL0;
	float4 v2 : TEXCOORD0;
	float4 v3 : TEXCOORD1;
	float2 v4 : TEXCOORD2;
};

struct v2f {
	float4 o0 : POSITION;
	float2 o1 : TEXCOORD0;
	float2 p1 : TEXCOORD1;
	float2 o2 : TEXCOORD2;
	float2 p2 : TEXCOORD3;
	float2 o3 : TEXCOORD4;
	float2 p3 : TEXCOORD6;
	float4 o4 : TEXCOORD7;
	float4 o5 : TEXCOORD8;
	float3 o6 : TEXCOORD9;
};

v2f vert(a2v v) {

	v2f f;
	f.o0 = 0;
	f.o1 = 0;
	f.o2 = 0;
	f.o3 = 0;
	f.o4 = 0;
	f.o5 = 0;
	f.o6 = 0;
	f.p1 = 0;
	f.p2 = 0;
	f.p3 = 0;

	float4 r0, r1, r2, r3, r4, r5;

	r0 = mul(v.v0, unity_ObjectToWorld);
	r1 = mul(r0, UNITY_MATRIX_VP);

	f.o0.xyzw = _EyePupliScale * r1.xyzw;
	r1.xy = float2(-0.5, -0.5) + v.v2.yx;
	r1.zw = _MainParam[0].yx + r1.xy;
	r1.xy = _MainParam[1].yx + r1.xy;
	sincos(_MainParam[0].z, r2.x, r3.x);
	r2.xy = r2.xx * r1.zw;
	r4.x = r1.w * r3.x + -r2.x;
	r4.y = r1.z * r3.x + r2.y;
	r1.zw = float2(0.5, 0.5) + r4.xy;
	r2.xy = r1.zw * _MainTex_ST.xy + _MainTex_ST.zw;
	sincos(_MainParam[1].z, r3.x, r4.x);
	r1.zw = r3.xx * r1.xy;
	r3.x = r1.y * r4.x + -r1.z;
	r3.y = r1.x * r4.x + r1.w;
	r1.xy = float2(0.5, 0.5) + r3.xy;
	r1.xy = r1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
	sincos(_HighParam1[0].z, r3.x, r4.x);
	r3.yz = float2(-0.5, -0.5) + v.v3.yx;
	r4.yz = _HighParam1[0].yx + r3.yz;
	r3.xw = r4.yz * r3.xx;
	r4.z = r4.z * r4.x + -r3.x;
	r4.w = r4.y * r4.x + r3.w;
	r3.xw = float2(0.5, 0.5) + r4.zw;
	r3.xw = _Offset.xy + r3.xw;
	r2.zw = r3.xw * _High0Tex_ST.xy + _High0Tex_ST.zw;
	r3.xw = _HighParam2[0].yx + r3.yz;
	sincos(_HighParam2[0].z, r4.x, r5.x);
	r4.xy = r4.xx * r3.xw;
	r4.z = r3.w * r5.x + -r4.x;
	r4.w = r3.x * r5.x + r4.y;
	r3.xw = float2(0.5, 0.5) + r4.zw;
	r3.xw = _Offset.zw + r3.xw;
	r1.zw = r3.xw * _High0Tex_ST.xy + _High0Tex_ST.zw;
	r0.w = cmp(v.v2.y >= 0.5);
	f.o1.xy = r0.ww ? r2.xy : r1.xy;
	f.p1.xy = r0.ww ? r2.zw : r1.zw;
	r1.xy = _HighParam1[1].yx + r3.yz;
	r1.zw = _HighParam2[1].yx + r3.yz;
	sincos(_HighParam1[1].z, r2.x, r3.x);
	r2.xy = r2.xx * r1.xy;
	r4.x = r1.y * r3.x + -r2.x;
	r4.y = r1.x * r3.x + r2.y;
	r1.xy = float2(0.5, 0.5) + r4.xy;
	r1.xy = r1.xy * _High0Tex_ST.xy + _High0Tex_ST.zw;
	sincos(_HighParam2[1].z, r2.x, r3.x);
	r2.xy = r2.xx * r1.zw;
	r4.x = r1.w * r3.x + -r2.x;
	r4.y = r1.z * r3.x + r2.y;
	r1.zw = float2(0.5, 0.5) + r4.xy;
	r1.zw = r1.zw * _High0Tex_ST.xy + _High0Tex_ST.zw;
	f.o2.xy = r0.ww ? r1.xy : r1.zw;
	r1.xy = float2(-0.5, -0.5) + v.v4.yx;
	r1.xy = _HighParam1[2].yx + r1.xy;
	sincos(_HighParam1[2].z, r2.x, r3.x);
	r1.zw = r2.xx * r1.xy;
	r2.z = r1.y * r3.x + -r1.z;
	r2.w = r1.x * r3.x + r1.w;
	r1.xy = float2(0.5, 0.5) + r2.zw;
	f.p2.xy = r1.xy * _High0Tex_ST.xy + _High0Tex_ST.zw;

	r1 = mul(v.v0, unity_ObjectToWorld);

	r1.x = mul(r1, UNITY_MATRIX_V).z;

	r1.x = -_Global_FogMinDistance.w + -r1.x;
	f.o3.x = saturate(r1.x / _Global_FogLength.w);
	f.p3.x = r0.w ? _HighParam1[0].w : _HighParam2[0].w;
	f.p3.y = r0.w ? _HighParam1[1].w : _HighParam2[1].w;
	f.o3.y = r0.y / _Global_MaxHeight;
	r1.xyz = -_FaceCenterPos.xyz + r0.xyz;
	r0.w = dot(_FaceUp.xyz, r1.xyz);
	r1.xyz = r0.www * _FaceUp.xyz + _FaceCenterPos.xyz;
	r1.xyz = -r1.xyz + r0.xyz;
	f.o5.xyz = r0.xyz;
	r0.x = dot(r1.xyz, r1.xyz);
	r0.x = rsqrt(r0.x);

	r0.yzw = mul(float4(v.v1.xyz, 0), unity_ObjectToWorld).xyz;

	r1.xyz = r1.xyz * r0.xxx + -r0.yzw;
	r0.xyz = _CylinderBlend * r1.xyz + r0.yzw;
	f.o4.xyz = r0.xyz;

	f.o6.xyz = mul(float4(r0.xyz, 0), UNITY_MATRIX_V).xyz;

	return f;

}

float4 frag(v2f f) : COLOR{
	float4 r0,r1,r2,r3;
	float4 result;
	float3 _WorldSpaceLightPos0 = float3 (_WorldSpaceLightPos.x * -1, _WorldSpaceLightPos.y * -1, _WorldSpaceLightPos.z * -1);
	
	r0.x = FloatToInt(_UseOriginalDirectionalLight);
	r0.x = cmp(r0.x >= 1);
	r0.x = r0.x ? 1.000000 : 0;
	r0.y = dot(_OriginalDirectionalLightDir.xyz, _OriginalDirectionalLightDir.xyz);
	r0.y = rsqrt(r0.y);
	r0.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
	r0.z = rsqrt(r0.z);
	r1.xyz = _WorldSpaceLightPos0.xyz * r0.zzz;
	r0.yzw = _OriginalDirectionalLightDir.xyz * r0.yyy + -r1.xyz;
	r0.xyz = r0.xxx * r0.yzw + r1.xyz;
	r0.x = dot(f.o4.xyz, r0.xyz);
	r0.x = r0.x * 0.5 + 0.5;
	r0.y = _ToonStep + -_ToonFeather;
	r0.x = r0.y + -r0.x;
	r0.x = r0.x / _ToonFeather;
	r0.x = saturate(1 + r0.x);
	r0.y = cmp(0 >= _ToonFeather);
	r0.y = r0.y ? 1.000000 : 0;
	r0.x = r0.y * -r0.x + r0.x;

	//r1.xyzw = t2.Sample(s2_s, f.o2.xy).xyzw;
	r1 = tex2D(_High1Tex, f.o2.xy);

	r1.x = r1.x * f.p3.y + -_Limit;
	r0.y = cmp(0 < r1.x);
	r1.y = -r1.x;
	r0.yz = r0.yy ? float2(1, 0) : r1.xy;
	r0.w = cmp(r1.x < 0);
	r0.yz = r0.ww ? float2(0, -1) : r0.yz;
	r0.y = r0.y + r0.z;

	//r1.xyzw = t1.Sample(s1_s, f.p1.xy).xyzw;
	r1 = tex2D(_High0Tex, f.p1.xy);

	r1.x = r1.x * f.p3.x + -_Limit;
	r0.z = cmp(0 < r1.x);
	r1.y = -r1.x;
	r0.zw = r0.zz ? float2(1, 0) : r1.xy;
	r1.x = cmp(r1.x < 0);
	r0.zw = r1.xx ? float2(0, -1) : r0.zw;
	r0.z = r0.z + r0.w;
	r0.yz = max(float2(0, 0), r0.yz);

	//r1.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
	r1 = tex2D(_MainTex, f.o1.xy);

	r1.xyz = r1.xyz + r0.zzz;
	result.w = r1.w;
	r0.yzw = r1.xyz + r0.yyy;



	//r1.xyzw = t3.Sample(s3_s, f.p2.xy).xyzw;
	r1 = tex2D(_High2Tex, f.p2.xy);

	r1.x = r1.x * _HighParam1[2].w + -_Limit;
	r1.z = cmp(0 < r1.x);
	r1.y = -r1.x;
	r1.yz = r1.zz ? float2(1, 0) : r1.xy;
	r1.x = cmp(r1.x < 0);
	r1.xy = r1.xx ? float2(0, -1) : r1.yz;
	r1.x = r1.x + r1.y;
	r1.x = max(0, r1.x);
	r0.yzw = r1.xxx + r0.yzw;
	r1.xyz = _GlobalToonColor.xyz * r0.yzw;
	r1.xyz = float3(0.699999988, 0.699999988, 0.699999988) * r1.xyz;
	r2.xyz = float3(-1, -1, -1) + _ToonDarkColor.xyz;
	r1.w = cmp(0.5 >= _ToonDarkColor.w);
	r2.w = r1.w ? 1.000000 : 0;
	r3.xyz = r1.www ? float3(0, 0, 0) : _ToonDarkColor.xyz;
	r2.xyz = r2.www * r2.xyz + float3(1, 1, 1);
	r1.xyz = r1.xyz * r2.xyz + r3.xyz;
	r2.xyz = float3(-1, -1, -1) + _ToonBrightColor.xyz;
	r1.w = cmp(0.5 >= _ToonBrightColor.w);
	r2.w = r1.w ? 1.000000 : 0;
	r3.xyz = r1.www ? float3(0, 0, 0) : _ToonBrightColor.xyz;
	r2.xyz = r2.www * r2.xyz + float3(1, 1, 1);
	r0.yzw = r0.yzw * r2.xyz + r3.xyz;
	r1.xyz = r1.xyz + -r0.yzw;
	r0.xyz = r0.xxx * r1.xyz + r0.yzw;
	r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
	r0.xyz = r0.xyz * r1.xyz + -_Global_FogColor.xyz;
	r1.xy = float2(1, 1) + -f.o3.xy;
	r0.w = saturate(r1.x * r1.y + _Global_MaxDensity);
	r0.xyz = r0.www * r0.xyz + _Global_FogColor.xyz;
	r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r0.xyz = _Saturation * r0.xyz;
	r1.x = 1 + -_Saturation;
	result.xyz = r0.www * r1.xxx + r0.xyz;
	return result;
}


technique MainTec < string MMDPass = "object"; > {
	pass DarwObject {
		VertexShader = compile vs_3_0 vert();
		PixelShader = compile ps_3_0 frag();
	}
};
technique MainTec_ss < string MMDPass = "object_ss"; > {
	pass DarwObject {
		VertexShader = compile vs_3_0 vert();
		PixelShader = compile ps_3_0 frag();
	}
};


