#define cmp -
float4x4 unity_MatrixV				:WORLDVIEW;
float4x4 unity_MatrixVP				:WORLDVIEWPROJECTION;
float4x4 unity_ObjectToWorld		:WORLD;
float4x4 unity_WorldToObject		:WORLDINVERSE;
float4x4 unity_MatrixInvV			:WORLDVIEWINVERSE;
float4x4 UNITY_MATRIX_P			    :PROJECTION;


float3 _WorldSpaceLightPos0		:DIRECTION < string Object = "Light"; > ;
float3 _WorldSpaceCameraPos		:POSITION < string Object = "Camera"; > ;

bool UseTexture = true;
bool UseSphereMap = false;
bool UseToon = false;

texture MainTexture : MATERIALTEXTURE;
texture TripleMaskTexture < string ResourceName = "tex_bdy1038_26_base.png"; > ;
texture OptionMaskTexture < string ResourceName = "tex_bdy1038_26_ctrl.png"; > ;
texture ToonMapTexture < string ResourceName = "tex_bdy1038_26_shad_c.png"; > ;
texture EnvMapTexture < string ResourceName = "tex_chr_env000.png"; > ;
texture DirtTexture;
texture EmissiveTexture;

sampler _MainTex = sampler_state
{
	texture = <MainTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _TripleMaskMap = sampler_state
{
	texture = <TripleMaskTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _OptionMaskMap = sampler_state
{
	texture = <OptionMaskTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _ToonMap = sampler_state
{
	texture = <ToonMapTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _DirtTex = sampler_state
{
	texture = <DirtTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _EnvMap = sampler_state
{
	texture = <EnvMapTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};
sampler2D _EmissiveTex = sampler_state
{
	texture = <EmissiveTexture>;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = LINEAR;
};

float4 _Global_FogMinDistance = 0;
float4 _Global_FogLength = 0;
float _Global_MaxDensity = 10;
float _Global_MaxHeight = 10;

float4 _MainTex_ST = float4(1, 1, 0, 0);
float _SpecularPower = 0.15;
float4 _HightLightParam;
float4 _HightLightColor;

float4 _LightColor0 = 1;
float4 _Global_FogColor = 0;
float _UseOptionMaskMap = 1;
float4 _SpecularColor = float4(1, 0.9, 0.6, 1);
float _EnvRate = 0.4;
float _EnvBias = 5;
float _ToonStep = 0.4;
float _ToonFeather = 0.001;
float4 _ToonBrightColor = float4(1, 1, 1, 0);
float4 _ToonDarkColor = float4(1, 1, 1, 0);
float _RimStep = 0.15;
float _RimFeather = 0.001;
float4 _RimColor = float4(1, 1, 1, 0.3);
float _RimShadow = 2;
float _RimSpecRate = 1;
float _RimShadowRate = 0.5;
float _RimHorizonOffset = 0;
float _RimVerticalOffset = 0;
float _RimStep2 = 0;
float _RimFeather2 = 0;
float4 _RimColor2 = 0;
float _RimSpecRate2 = 0;
float _RimHorizonOffset2 = 0;
float _RimVerticalOffset2 = 0;
float _RimShadowRate2 = 0;
float _Cutoff = 0.5;
float4 _CharaColor = 1;
float _Saturation = 1;
float _DirtRate[3] = { 0,0,0 };
float4 _GlobalDirtColor = 0;
float4 _GlobalDirtRimSpecularColor = 0;
float4 _GlobalDirtToonColor = 0;
float _DirtScale = 1;
float4 _GlobalToonColor = float4(1, 1, 1, 0);
float4 _GlobalRimColor = float4(1, 1, 1, 0);
float4 _LightProbeColor = 1;
float4 _EmissiveColor = 1;
float _UseOriginalDirectionalLight = 1;
float3 _OriginalDirectionalLightDir = 1;
float _VertexColorToonPower = 1;

float _GlobalCameraFov = 30;
float _GlobalOutlineWidth = 1;
float _OutlineWidth = 0.325;
float _GlobalOutlineOffset= 0;
float4 _OutlineColor = float4(0, 0, 0, 1);


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

struct a2v {
	float4 v0 : POSITION0;
	float2 v1 : TEXCOORD0;
	float3 v2 : NORMAL0;
	float4 v3 : COLOR0;
};

struct v2f {
	float4 o0 : POSITION;
	float2 o1 : TEXCOORD0;
	float  p1 : TEXCOORD5;
	float4 o2 : TEXCOORD7;
	float4 o3 : TEXCOORD8;
	float4 o4 : TEXCOORD1;
	float4 o5 : TEXCOORD2;
	float4 o6 : TEXCOORD3;
	float4 o7 : TEXCOORD4;
	float4 o8 : TEXCOORD10;
};

struct Edge_a2v {
	float4 v0 : POSITION0;
	float3 v1 : TANGENT0;
	float2 v2 : TEXCOORD0;
	float4 v3 : COLOR0;
};

struct Edge_v2f {
	float4 o0 : POSITION;
	float2 o1 : TEXCOORD11;
	float2 p1 : TEXCOORD12;
};

v2f vert(a2v v)
{
	v2f f;
	f.o0 = 0;
	f.o1 = 0;
	f.p1 = 0;
	f.o2 = 0;
	f.o3 = 0;
	f.o4 = 0;
	f.o5 = 0;
	f.o6 = 0;
	f.o7 = 0;
	f.o8 = 0;

	float4 r0, r1;
	r0.xyz = mul(v.v0, unity_ObjectToWorld).xyz;
	f.o0 = mul(float4(r0.xyz, 1), unity_MatrixVP);
	r1 = mul(v.v0, unity_ObjectToWorld);
	r0.w = mul(r1, unity_MatrixV).z;

	r0.w = -_Global_FogMinDistance.w + -r0.w;
	r0.w = saturate(r0.w / _Global_FogLength.w);
	r0.w = 1 + -r0.w;
	r1.x = saturate(r0.y / _Global_MaxHeight);
	r1.x = 1 + -r1.x;
	f.p1.x = saturate(r0.w * r1.x + _Global_MaxDensity);
	f.o1.xy = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
	f.o2.xyz = float3(0, 0, 0);
	f.o3.xyzw = v.v3.xyzw;
	f.o4.xyz = mul(float4(v.v2, 0), unity_ObjectToWorld).xyz;

	f.o5.xyz = r0.xyz;
	r0.x = -_HightLightParam.x + r0.y;
	r0.x = saturate(r0.x / _HightLightParam.y);
	r0.x = 1 + -r0.x;
	f.o8.xyzw = _HightLightColor.xyzw * r0.xxxx;

	r0.xyz = mul(float4(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y, unity_ObjectToWorld[3].y), unity_MatrixV).xyz;

	r0.xyz = v.v2.yyy * r0.xyz;

	r1.xyz = mul(float4(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x, unity_ObjectToWorld[3].x), unity_MatrixV).xyz;

	r0.xyz = r1.xyz * v.v2.xxx + r0.xyz;

	r1.xyz = mul(float4(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z, unity_ObjectToWorld[3].z), unity_MatrixV).xyz;

	f.o6.xyz = r1.xyz * v.v2.zzz + r0.xyz;
	r0.x = _SpecularPower * -10 + 11;
	f.o7.x = exp2(r0.x);
	f.o7.yzw = float3(0, 0, 0);
	return f;
}

float4 frag(v2f f) : COLOR0{

	float4 r0,r1,r2,r3,r4,r5,r6,text;
	float4 result;

	text = tex2D(_MainTex, f.o1.xy);

	r0 = tex2D(_TripleMaskMap, f.o1.xy);

	r0.z = -(r0.z < _Cutoff);
	if (r0.z != 0) discard;

	r1 = tex2D(_MainTex, f.o1.xy);
	r1.xyz = _LightColor0.xyz * r1.xyz;


	float4 option = tex2D(_OptionMaskMap, f.o1.xy);
	r0.z = option.y * _UseOptionMaskMap;
	r0.w = (option.z - 0.5) * _UseOptionMaskMap + 0.5;


	r2.xyz = _WorldSpaceCameraPos.xyz + -f.o5.xyz;
	r2.w = dot(r2.xyz, r2.xyz);
	r2.w = rsqrt(r2.w);
	r2.xyz = r2.xyz * r2.www;
	r2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
	r2.w = rsqrt(r2.w);
	r3.xyz = _WorldSpaceLightPos0.xyz * r2.www;
	r2.w = dot(_OriginalDirectionalLightDir, _OriginalDirectionalLightDir);
	r2.w = rsqrt(r2.w);
	r3.w = FloatToInt(_UseOriginalDirectionalLight);
	r3.w = cmp(r3.w >= 1);
	r3.w = r3.w ? 1.000000 : 0;
	r4.xyz = _OriginalDirectionalLightDir * r2.www + -r3.xyz;
	r3.xyz = r3.www * r4.xyz + r3.xyz;
	r2.w = dot(f.o4.xyz, r3.xyz);
	r3.x = 0.5 * r2.w;
	r3.y = r2.w * 0.5 + 0.5;
	r3.z = -_ToonFeather + _ToonStep;
	r0.x = -r0.x * r3.y + r3.z;
	r0.x = r0.x / _ToonFeather;
	r0.x = saturate(1 + r0.x);
	r3.y = -(0 >= _ToonFeather);
	r3.y = r3.y ? 1.000000 : 0;
	r0.x = r3.y * -r0.x + r0.x;


	r4 = tex2D(_ToonMap, f.o1.xy);

	r3.yzw = _LightColor0.xyz * r4.xyz;
	r3.yzw = _GlobalToonColor.xyz * r3.yzw;
	r4.x = 1 + -f.o3.w;
	r4.x = _VertexColorToonPower * r4.x;
	r3.x = min(0, r3.x);
	r3.x = 0.5 + r3.x;
	r3.x = dot(r4.xx, r3.xx);
	r3.x = 1 + -r3.x;
	r4.x = cmp(0.5 >= _ToonBrightColor.w);
	r4.y = r4.x ? 1.000000 : 0;
	r4.y = r4.y * r3.x;
	r5.xyz = float3(-1, -1, -1) + _ToonBrightColor.xyz;
	r4.yzw = r4.yyy * r5.xyz + float3(1, 1, 1);
	r5.xyz = r4.xxx ? float3(0, 0, 0) : _ToonBrightColor.xyz;
	r5.xyz = r5.xyz * r3.xxx;
	r1.xyz = r1.xyz * r4.yzw + r5.xyz;
	r4.x = cmp(0.5 >= _ToonDarkColor.w);
	r4.y = r4.x ? 1.000000 : 0;
	r4.y = r4.y * r3.x;
	r5.xyz = float3(-1, -1, -1) + _ToonDarkColor.xyz;
	r4.yzw = r4.yyy * r5.xyz + float3(1, 1, 1);
	r5.xyz = r4.xxx ? float3(0, 0, 0) : _ToonDarkColor.xyz;
	r5.xyz = r5.xyz * r3.xxx;
	r3.xyz = r3.yzw * r4.yzw + r5.xyz;
	r3.xyz = r3.xyz + -r1.xyz;
	r1.xyz = r0.xxx * r3.xyz + r1.xyz;

	r3 = tex2D(_DirtTex, f.o1.xy);

	r3.xyz = _DirtScale.xxx * r3.xyz;
	r3.y = _DirtRate[1].x * r3.y;
	r3.x = r3.x * _DirtRate[0] + r3.y;
	r3.x = r3.z * _DirtRate[2] + r3.x;
	r3.y = cmp(-0 >= _RimHorizonOffset);

	r4.x = unity_MatrixV[0].x;
	r4.y = unity_MatrixV[0].y;
	r4.z = unity_MatrixV[0].z;

	r3.z = cmp(-0 >= _RimVerticalOffset);
	r3.yz = r3.yz ? float2(1, 1) : float2(-1, -1);

	r5.x = unity_MatrixV[1].x;
	r5.y = unity_MatrixV[1].y;
	r5.z = unity_MatrixV[1].z;

	r6.xyz = r4.xyz * r3.yyy + -r2.xyz;
	r6.xyz = abs(_RimHorizonOffset) * r6.xyz + r2.xyz;
	r3.yzw = r5.xyz * r3.zzz + -r6.xyz;
	r3.yzw = abs(_RimVerticalOffset) * r3.yzw + r6.xyz;
	r3.y = dot(r3.yzw, f.o4.xyz);
	r3.z = _RimStep + -_RimFeather;
	r3.z = r3.z + -r3.y;
	r3.z = r3.z / _RimFeather;
	r3.z = saturate(1 + r3.z);
	r3.z = r3.z * r3.z;
	r3.z = r3.z * r3.z;
	r3.z = _RimColor.w * r3.z;
	r3.z = r3.z * r0.w;
	r6.xy = cmp(float2(-0, -0) >= float2(_RimHorizonOffset2, _RimVerticalOffset2));
	r6.xy = r6.xy ? float2(1, 1) : float2(-1, -1);
	r4.xyz = r4.xyz * r6.xxx + -r2.xyz;
	r2.xyz = abs(_RimHorizonOffset2) * r4.xyz + r2.xyz;
	r4.xyz = r5.xyz * r6.yyy + -r2.xyz;
	r2.xyz = abs(_RimVerticalOffset2) * r4.xyz + r2.xyz;
	r2.x = dot(r2.xyz, f.o4.xyz);
	r2.y = _RimStep2 + -_RimFeather2;
	r2.x = r2.y + -r2.x;
	r2.x = r2.x / _RimFeather2;
	r2.x = saturate(1 + r2.x);
	r2.x = r2.x * r2.x;
	r2.x = r2.x * r2.x;
	r2.x = _RimColor.w * r2.x;
	r0.w = r2.x * r0.w;
	r2.x = max(0, r3.y);
	r2.y = _SpecularPower * 10 + 1;
	r2.y = max(0, r2.y);
	r2.x = log2(r2.x);
	r2.x = r2.y * r2.x;
	r2.x = exp2(r2.x);
	r2.x = min(1, r2.x);
	r0.y = r2.x * r0.y;
	r2.xyz = _SpecularColor.xyz * _LightColor0.xyz;
	r2.xyz = r2.xyz * r0.yyy;
	r2.xyz = max(float3(0, 0, 0), r2.xyz);
	r1.xyz = r2.xyz + r1.xyz;
	r2.xyz = _GlobalDirtToonColor.xyz + -_GlobalDirtColor.xyz;
	r2.xyz = r0.xxx * r2.xyz + _GlobalDirtColor.xyz;
	r2.xyz = r2.xyz + -r1.xyz;
	r1.xyz = r3.xxx * r2.xyz + r1.xyz;
	r0.xy = float2(1, 1) + f.o6.xy;
	r0.xy = float2(0.5, 0.5) * r0.xy;

	r4 = tex2D(_EnvMap, r0.xy);

	r2.xyz = r4.xyz * r1.xyz;
	r0.x = _EnvRate * r0.z;
	r2.xyz = r2.xyz * _EnvBias + -r1.xyz;
	r0.xyz = r0.xxx * r2.xyz + r1.xyz;

	r1.xyz = _RimColor.xyz + -_SpecularColor.xyz;
	r1.xyz = _RimSpecRate * r1.xyz + _SpecularColor.xyz;

	r2.x = max(0, r2.w);
	r1.xyz = r1.xyz * r3.zzz;
	r2.y = _RimShadow + r2.x;
	r2.y = _RimShadowRate + r2.y;
	r1.xyz = r2.yyy * r1.xyz;
	r2.yz = _GlobalRimColor.xy * r1.xy;
	r0.xyz = r1.xyz * _GlobalRimColor.xyz + r0.xyz;
	r3.yzw = _RimColor2.xyz + -_SpecularColor.xyz;
	r3.yzw = _RimSpecRate2 * r3.yzw + _SpecularColor.xyz;
	r3.yzw = r3.xyz * r0.www;
	r0.w = _RimShadowRate2 + r2.x;
	r3.yzw = r3.yzw * r0.www;
	r0.xyz = r3.yzw * _GlobalRimColor.xyz + r0.xyz;
	r0.w = r2.y + r2.z;
	r0.w = r1.z * _GlobalRimColor.z + r0.w;
	r0.w = cmp(9.99999975e-06 >= r0.w);
	r1.xyz = r0.www ? _GlobalDirtColor.xyz : _GlobalDirtRimSpecularColor.xyz;
	r1.xyz = r1.xyz + -r0.xyz;
	r0.xyz = r3.xxx * r1.xyz + r0.xyz;
	r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
	r0.w = 1 + -r3.x;

	r2 = tex2D(_EmissiveTex, f.o1.xy);

	r2.xyz = _EmissiveColor.xyz * r2.xyz;
	r2.xyz = r2.xyz * r0.www;
	r0.xyz = r0.xyz * r1.xyz + r2.xyz;
	r0.xyz = f.o8.xyz + r0.xyz;
	r0.xyz = -_Global_FogColor.xyz + r0.xyz;
	r0.xyz = f.p1.xxx * r0.xyz + _Global_FogColor.xyz;
	r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r1.x = 1 + -_Saturation;
	r0.xyz = _Saturation * r0.xyz;
	result.xyz = r0.www * r1.xxx + r0.xyz;
	result.w = r1.w;
	return result;
}

Edge_v2f Edge_vert(Edge_a2v v) {

	Edge_v2f f;
	f.o0 = 0;
	f.o1 = 0;
	f.p1 = 0;

	float4 r0, r1, r2;
	r0.xyz = mul(float4(unity_MatrixInvV[0].y, unity_MatrixInvV[1].y, unity_MatrixInvV[2].y, unity_MatrixInvV[3].y), unity_WorldToObject).xyz;

	r0.x = dot(r0.xyz, v.v1.xyz);

	r0.xy = float2(UNITY_MATRIX_P[0].y, UNITY_MATRIX_P[1].y) * r0.xx;

	r1.xyz = mul(float4(unity_MatrixInvV[0].x, unity_MatrixInvV[1].x, unity_MatrixInvV[2].x, unity_MatrixInvV[3].x), unity_WorldToObject).xyz;

	r0.z = dot(r1.xyz, v.v1.xyz);

	r0.xy = float2(UNITY_MATRIX_P[0].x, UNITY_MATRIX_P[1].x) * r0.zz + r0.xy;

	r1.xyz = mul(float4(unity_MatrixInvV[0].z, unity_MatrixInvV[1].z, unity_MatrixInvV[2].z, unity_MatrixInvV[3].z), unity_WorldToObject).xyz;

	r0.z = dot(r1.xyz, v.v1.xyz);

	r0.xy = float2(UNITY_MATRIX_P[0].z, UNITY_MATRIX_P[1].z) * r0.zz + r0.xy;

	r0.xy = float2(UNITY_MATRIX_P[0].w, UNITY_MATRIX_P[1].w) + r0.xy;

	r0.z = _GlobalCameraFov * 0.5 + 0.75;
	r0.xy = r0.xy * r0.zz;
	r0.z = _GlobalOutlineWidth * v.v3.x;
	r0.z = _OutlineWidth * r0.z;
	r0.z = 0.0027999999 * r0.z;

	r1 = mul(v.v0, unity_ObjectToWorld);

	r2 = mul(r1, unity_MatrixVP);


	f.o0.xy = r0.xy * r0.zz + r2.xy;
	r0.x = 1 + -v.v3.y;
	r0.x = 0.0187500007 * r0.x;
	r0.x = _GlobalCameraFov * r0.x;
	f.o0.z = -r0.x * _GlobalOutlineOffset + r2.z;
	f.o0.w = r2.w;

	r0.x = mul(r1, unity_MatrixV).z;

	f.p1.y = r1.y / _Global_MaxHeight;
	r0.x = -_Global_FogMinDistance.w + -r0.x;
	f.p1.x = saturate(r0.x / _Global_FogLength.w);
	f.o1.xy = v.v2.xy;
	return f;
}

float4 Edge_frag(Edge_v2f f) : COLOR0{
	float4 r0,r1,r2;
	float4 result;

	r0 = tex2D(_TripleMaskMap, f.o1.xy);

	r0.x = cmp(r0.z < _Cutoff);
	if (r0.x != 0) discard;

	r0 = tex2D(_MainTex, f.o1.xy);

	r1.x = _OutlineColor.w + _OutlineColor.w;
	r1.yzw = -_OutlineColor.xyz + r0.xyz;
	r1.xyz = r1.xxx * r1.yzw + _OutlineColor.xyz;
	r2.xyzw = float4(-0.5, -1, -1, -1) + _OutlineColor.wxyz;
	r1.w = r2.x + r2.x;
	r2.xyz = r1.www * r2.yzw + float3(1, 1, 1);
	r1.w = cmp(_OutlineColor.w >= 0.5);
	r1.w = r1.w ? 1.000000 : 0;
	r0.xyz = r0.xyz * r2.xyz + -r1.xyz;
	r0.xyz = r1.www * r0.xyz + r1.xyz;
	r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
	r2.xy = float2(1, 1) + -f.p1.xy;
	r1.w = saturate(r2.x * r2.y + _Global_MaxDensity);
	r0.xyz = r0.xyz * r1.xyz + -_Global_FogColor.xyz;
	r0.xyz = r1.www * r0.xyz + _Global_FogColor.xyz;
	r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r1.y = 1 + -_Saturation;
	r0.xyz = _Saturation * r0.xyz;
	result.xyz = r1.xxx * r1.yyy + r0.xyz;
	result.w = r0.w;
	return result;
}

technique MainTec < string MMDPass = "object"; > {
	pass DarwObject {
		VertexShader = compile vs_3_0 vert();
		PixelShader = compile ps_3_0 frag();
	}
	pass DrawEdge {
		CULLMODE = CW;
		VertexShader = compile vs_3_0 Edge_vert();
		PixelShader = compile ps_3_0 Edge_frag();
	}
};

technique MainTec_ss < string MMDPass = "object_ss"; > {
	pass DarwObject {
		VertexShader = compile vs_3_0 vert();
		PixelShader = compile ps_3_0 frag();
	}
	pass DrawEdge {
		CULLMODE = CW;
		VertexShader = compile vs_3_0 Edge_vert();
		PixelShader = compile ps_3_0 Edge_frag();
	}
};


