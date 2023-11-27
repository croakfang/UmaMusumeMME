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


float3 _WorldSpaceLightPos  	:DIRECTION < string Object = "Light"; > ;
float3 _WorldSpaceCameraPos		:POSITION < string Object = "Camera"; > ;

texture MainTexture : MATERIALTEXTURE;
texture TripleMaskTexture < string ResourceName = "Texture2D/tex_chr2005_00_face_base.png"; > ;
texture OptionMaskTexture < string ResourceName = "Texture2D/tex_chr2005_00_face_ctrl.png"; > ;
texture ToonMapTexture < string ResourceName = "Texture2D/tex_chr2005_00_face_shad_c.png"; > ;
texture EnvMapTexture < string ResourceName = "Texture2D/tex_chr_env000.png"; > ;
texture DirtTexture;
texture EmissiveTexture;

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
float4 _SpecularColor = 1;
float _EnvRate = 1;
float _EnvBias = 5;
float _ToonStep = 0.5; //Shadow strength
float _ToonFeather = 0.0001;
float4 _ToonBrightColor = float4(1, 1, 1, 0);
float4 _ToonDarkColor = float4(1, 1, 1, 0);
float _RimStep = 0.15;
float _RimFeather = 0.001;
float4 _RimColor = 0;
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
float _UseOriginalDirectionalLight = 0;
float3 _OriginalDirectionalLightDir = 1;
float _VertexColorToonPower = 1;

float _GlobalCameraFov = 30;
float _GlobalOutlineWidth = 1;
float _OutlineWidth = 0.2;
float _GlobalOutlineOffset = -0.1;
float4 _OutlineColor = float4(0, 0, 0, 1); //TOONCOLOR;

float _CylinderBlend = 0.25;
float4x4 _faceShadowHeadMat : CONTROLOBJECT < string name = "model.pmx"; string item = "摢"; > ; //replace name to your model filename (Shift-JIS)
float3 _LocalFaceUp = float3(0, 1, 0);
float3 _LocalFaceForward = float3(0, 0, -1);
float _CheekPretenseThreshold = 0.775;
float _NosePretenseThreshold = 0.775;
float _NoseVisibility = 0;
float _faceShadowAlpha = 0;
float _faceShadowEndY = 0;
float _faceShadowLength = 0.1;
float4 _faceShadowColor = float4(0.6, 0.6, 1, 1);

sampler _MainTex = sampler_state { texture = <MainTexture>;		MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _TripleMaskMap = sampler_state { texture = <TripleMaskTexture>;	MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _OptionMaskMap = sampler_state { texture = <OptionMaskTexture>;	MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _ToonMap = sampler_state { texture = <ToonMapTexture>;		MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _DirtTex = sampler_state { texture = <DirtTexture>;		MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _EnvMap = sampler_state { texture = <EnvMapTexture>;		MINFILTER = LINEAR;	MAGFILTER = LINEAR;	MIPFILTER = LINEAR; };
sampler2D _EmissiveTex = sampler_state { texture = <EmissiveTexture>;	MINFILTER = LINEAR;	MAGFILTER = LINEAR; MIPFILTER = LINEAR; };

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

float3x3 ConvertTo3x3(float4x4 mat)
{
	float3x3 result;

	result._m00 = mat._m00;
	result._m01 = mat._m01;
	result._m02 = mat._m02;

	result._m10 = mat._m10;
	result._m11 = mat._m11;
	result._m12 = mat._m12;

	result._m20 = mat._m20;
	result._m21 = mat._m21;
	result._m22 = mat._m22;

	return result;
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
	float2 v1 : TEXCOORD0;
	float3 v2 : NORMAL0;
	float4 v3 : TEXCOORD3; //Vertex Color -->Additional UV3
};

struct v2f {
	float4 o0 : POSITION;
	float2 o1 : TEXCOORD0;
	float p1 : TEXCOORD5;
	float4 o2 : TEXCOORD7;
	float4 o3 : TEXCOORD8;
	float4 o4 : TEXCOORD1;
	float4 o5 : TEXCOORD2;
	float4 o6 : TEXCOORD3;
	float4 o7 : TEXCOORD4;
	float4 o8 : TEXCOORD9;
};


struct Edge_a2v {
	float4 v0 : POSITION0;
	float3 v1 : NORMAL0;
	float2 v2 : TEXCOORD0;
	float4 v3 : TEXCOORD3; //Vertex Color -->Additional UV3
};

struct Edge_v2f {
	float4 o0 : POSITION0;
	float2 o1 : TEXCOORD11;
	float2 p1 : TEXCOORD12;
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
	f.o7 = 0;
	f.o8 = 0;
	f.p1 = 0;

	float3 _FaceUp = mul(_LocalFaceUp, ConvertTo3x3(_faceShadowHeadMat));
	float3 _FaceForward = mul(_LocalFaceForward, ConvertTo3x3(_faceShadowHeadMat));
	float3 _FaceCenterPos = mul(float4(0, 0.1, 0, 1), _faceShadowHeadMat).xyz;

	float4 r0, r1, r2;

	r0 = mul(v.v0, unity_ObjectToWorld);

	f.o0 = mul(r0, UNITY_MATRIX_VP);

	r1 = mul(r0, unity_ObjectToWorld);

	r0.w = mul(r1, UNITY_MATRIX_V).z;

	r0.w = -_Global_FogMinDistance.w + -r0.w;
	r0.w = saturate(r0.w / _Global_FogLength.w);
	r0.w = 1 + -r0.w;
	r1.x = saturate(r0.y / _Global_MaxHeight);
	r1.x = 1 + -r1.x;
	f.p1.x = saturate(r0.w * r1.x + _Global_MaxDensity);
	f.o1.xy = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
	f.o2.xyz = float3(0, 0, 0);
	f.o3.xyzw = v.v3.xyzw;
	r0.w = 1 + -_CylinderBlend;
	r0.w = v.v3.z * r0.w;

	r1.xyz = mul(float4(v.v2, 0), unity_ObjectToWorld).xyz;

	r2.xyz = -_FaceCenterPos + r0.xyz;
	r1.w = dot(_FaceUp, r2.xyz);
	r2.xyz = r1.www * _FaceUp + _FaceCenterPos;
	r2.xyz = -r2.xyz + r0.xyz;
	r1.w = dot(r2.xyz, r2.xyz);
	r1.w = rsqrt(r1.w);
	r1.xyz = -r2.xyz * r1.www + r1.xyz;
	r2.xyz = r2.xyz * r1.www;
	r1.xyz = r0.www * r1.xyz + r2.xyz;
	f.o4.xyz = r1.xyz;
	f.o5.xyz = r0.xyz;

	f.o6.xyz = mul(float4(r1.xyz, 0), UNITY_MATRIX_V).xyz;

	r0.w = _SpecularPower * -10 + 11;
	f.o7.x = exp2(r0.w);
	f.o7.yzw = float3(0, 0, 0);

	f.o8 = mul(r0, _faceShadowHeadMat);

	return f;

}

float4 frag(v2f f) : COLOR0{

	float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
	float4 result;
	float3 _WorldSpaceLightPos0 = float3 (_WorldSpaceLightPos.x * -1, _WorldSpaceLightPos.y * -1, _WorldSpaceLightPos.z * -1);
	float3 _FaceUp = mul(_LocalFaceUp, ConvertTo3x3(_faceShadowHeadMat));
	float3 _FaceForward = mul(_LocalFaceForward, ConvertTo3x3(_faceShadowHeadMat));
	float3 _FaceCenterPos = mul(float4(0, 0.1, 0, 1), _faceShadowHeadMat).xyz;
	r0.xy = float2(1, 1) + f.o6.xy;
	r0.xy = float2(0.5, 0.5) * r0.xy;

	//r0.xyzw = t5.Sample(s3_s, r0.xy).xyzw;
	r0 = tex2D(_EnvMap, r0.xy);

	r0.w = _SpecularPower * 10 + 1;
	r0.w = max(0, r0.w);
	r1.x = cmp(-0 >= _RimVerticalOffset);
	r1.y = cmp(-0 >= _RimHorizonOffset);
	r1.xy = r1.xy ? float2(1, 1) : float2(-1, -1);
	r2.xyz = _WorldSpaceCameraPos.xyz + -f.o5.xyz;
	r1.z = dot(r2.xyz, r2.xyz);
	r1.z = rsqrt(r1.z);
	r2.xyz = r2.xyz * r1.zzz;
	r3.x = UNITY_MATRIX_V[0].x; //cb3[9].x
	r3.y = UNITY_MATRIX_V[0].y; //cb3[10].x
	r3.z = UNITY_MATRIX_V[0].z; //cb3[11].x
	r1.yzw = r3.xyz * r1.yyy + -r2.xyz;
	r1.yzw = abs(_RimHorizonOffset) * r1.yzw + r2.xyz;
	r4.x = UNITY_MATRIX_V[1].x;  //cb3[9].y;
	r4.y = UNITY_MATRIX_V[1].y; //cb3[10].y;
	r4.z = UNITY_MATRIX_V[1].z; //cb3[11].y;
	r5.xyz = r4.xyz * r1.xxx + -r1.yzw;
	r1.xyz = abs(_RimVerticalOffset) * r5.xyz + r1.yzw;
	r1.x = dot(r1.xyz, f.o4.xyz);
	r1.y = max(0, r1.x);
	r1.y = log2(r1.y);
	r0.w = r1.y * r0.w;
	r0.w = exp2(r0.w);
	r0.w = min(1, r0.w);

	float4 option = tex2D(_OptionMaskMap, f.o1.xy);
	r1.z = option.y * _UseOptionMaskMap;
	r1.w = (option.z - 0.5) * _UseOptionMaskMap + 0.5;

	r0.w = r1.y * r0.w;
	r5.xyz = _SpecularColor.xyz * _LightColor0.xyz;
	r5.xyz = r5.xyz * r0.www;
	r5.xyz = max(float3(0, 0, 0), r5.xyz);

	r6 = tex2D(_ToonMap, f.o1.xy);

	r6.xyz = _LightColor0.xyz * r6.xyz;
	r6.xyz = _GlobalToonColor.xyz * r6.xyz;
	r7.xyz = float3(-1, -1, -1) + _ToonDarkColor.xyz;
	r0.w = 1 + -f.o3.w;
	r0.w = _VertexColorToonPower * r0.w;
	r1.y = FloatToInt(_UseOriginalDirectionalLight);
	r1.y = cmp(r1.y >= 1);
	r1.y = r1.y ? 1.000000 : 0;
	r2.w = dot(_OriginalDirectionalLightDir.xyz, _OriginalDirectionalLightDir.xyz);
	r2.w = rsqrt(r2.w);
	r3.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
	r3.w = rsqrt(r3.w);
	r8.xyz = _WorldSpaceLightPos0.xyz * r3.www;
	r9.xyz = _OriginalDirectionalLightDir.xyz * r2.www + -r8.xyz;
	r8.xyz = r1.yyy * r9.xyz + r8.xyz;
	r1.y = dot(f.o4.xyz, r8.xyz);
	r2.w = 0.5 * r1.y;
	r2.w = min(0, r2.w);
	r2.w = 0.5 + r2.w;
	r0.w = dot(r0.ww, r2.ww);
	r0.w = 1 + -r0.w;
	r2.w = cmp(0.5 >= _ToonDarkColor.w);
	r3.w = r2.w ? 1.000000 : 0;
	r9.xyz = r2.www ? float3(0, 0, 0) : _ToonDarkColor.xyz;
	r9.xyz = r9.xyz * r0.www;
	r2.w = r3.w * r0.w;
	r7.xyz = r2.www * r7.xyz + float3(1, 1, 1);
	r6.xyz = r6.xyz * r7.xyz + r9.xyz;
	r2.w = cmp(0.5 >= _ToonBrightColor.w);
	r3.w = r2.w ? 1.000000 : 0;
	r7.xyz = r2.www ? float3(0, 0, 0) : _ToonBrightColor.xyz;
	r7.xyz = r7.xyz * r0.www;
	r0.w = r3.w * r0.w;
	r9.xyz = float3(-1, -1, -1) + _ToonBrightColor.xyz;
	r9.xyz = r0.www * r9.xyz + float3(1, 1, 1);

	//r10.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
	r10 = tex2D(_MainTex, f.o1.xy);

	r10.xyz = _LightColor0.xyz * r10.xyz;

	result.w = r10.w;
	r7.xyz = r10.xyz * r9.xyz + r7.xyz;

	r9.xyz = -r7.xyz + r6.xyz;

	r0.w = cmp(0 >= _ToonFeather);
	r0.w = r0.w ? 1.000000 : 0;
	r2.w = -_ToonFeather + _ToonStep;
	r3.w = r1.y * 0.5 + 0.5;
	r1.y = max(0, r1.y);

	//r10.xyzw = t1.Sample(s1_s, f.o1.xy).xyzw;
	r10 = tex2D(_TripleMaskMap, f.o1.xy);

	r2.w = -r10.x * r3.w + r2.w;
	r3.w = -r10.x * r3.w + _ToonStep;
	r3.w = -0.0500000007 + r3.w;
	r3.w = saturate(r3.w * 20 + 1);
	r2.w = r2.w / _ToonFeather;
	r2.w = saturate(1 + r2.w);
	r0.w = r0.w * -r2.w + r2.w;
	r11.xyz = r0.www * r9.xyz + r7.xyz;

	r5.xyz = r11.xyz + r5.xyz;
	r11.xyz = _GlobalDirtToonColor.xyz + -_GlobalDirtColor.xyz;
	r11.xyz = r0.www * r11.xyz + _GlobalDirtColor.xyz;
	r11.xyz = r11.xyz + -r5.xyz;

	//r12.xyzw = t4.Sample(s5_s, f.o1.xy).xyzw;
	r12 = tex2D(_DirtTex, f.o1.xy);

	r12.xyz = _DirtScale * r12.xyz;
	r0.w = _DirtRate[1] * r12.y;
	r0.w = r12.x * _DirtRate[0] + r0.w;
	r0.w = r12.z * _DirtRate[2] + r0.w;
	r5.xyz = r0.www * r11.xyz + r5.xyz;

	r0.xyz = r5.xyz * r0.xyz;
	r0.xyz = r0.xyz * _EnvBias + -r5.xyz;
	r1.z = _EnvRate * r1.z;
	r0.xyz = r1.zzz * r0.xyz + r5.xyz;

	r1.z = _RimStep + -_RimFeather;
	r1.x = r1.z + -r1.x;
	r1.x = r1.x / _RimFeather;
	r1.x = saturate(1 + r1.x);
	r1.x = r1.x * r1.x;
	r1.x = r1.x * r1.x;
	r1.x = _RimColor.w * r1.x;
	r1.x = r1.x * r1.w;
	r5.xyz = _RimColor.xyz + -_SpecularColor.xyz;
	r5.xyz = _RimSpecRate * r5.xyz + _SpecularColor.xyz;
	r5.xyz = r5.xyz * r1.xxx;
	r1.x = _RimShadow + r1.y;
	r1.y = _RimShadowRate2 + r1.y;
	r1.x = _RimShadowRate + r1.x;
	r5.xyz = r5.xyz * r1.xxx;
	r0.xyz = r5.xyz * _GlobalRimColor.xyz + r0.xyz;

	r1.xz = cmp(float2(-0, -0) >= float2(_RimHorizonOffset2, _RimVerticalOffset2));
	r1.xz = r1.xz ? float2(1, 1) : float2(-1, -1);
	r3.xyz = r3.xyz * r1.xxx + -r2.xyz;
	r2.xyz = abs(_RimHorizonOffset2) * r3.xyz + r2.xyz;
	r3.xyz = r4.xyz * r1.zzz + -r2.xyz;
	r2.xyz = abs(_RimVerticalOffset2) * r3.xyz + r2.xyz;
	r1.x = dot(r2.xyz, f.o4.xyz);
	r1.z = _RimStep2 + -_RimFeather2;
	r1.x = r1.z + -r1.x;
	r1.x = r1.x / _RimFeather2;
	r1.x = saturate(1 + r1.x);
	r1.x = r1.x * r1.x;
	r1.x = r1.x * r1.x;
	r1.x = _RimColor.w * r1.x;
	r1.x = r1.x * r1.w;
	r2.xyz = _RimColor2.xyz + -_SpecularColor.xyz;
	r2.xyz = _RimSpecRate2 * r2.xyz + _SpecularColor.xyz;
	r1.xzw = r2.xyz * r1.xxx;
	r1.xyz = r1.xzw * r1.yyy;
	r0.xyz = r1.xyz * _GlobalRimColor.xyz + r0.xyz;
	r1.xy = _GlobalRimColor.xy * r5.xy;
	r1.x = r1.x + r1.y;
	r1.x = r5.z * _GlobalRimColor.z + r1.x;
	r1.x = cmp(9.99999975e-06 >= r1.x);
	r1.xyz = r1.xxx ? _GlobalDirtColor.xyz : _GlobalDirtRimSpecularColor.xyz;
	r1.xyz = r1.xyz + -r0.xyz;
	r0.xyz = r0.www * r1.xyz + r0.xyz;
	r0.w = 1 + -r0.w;
	r1.xyz = _FaceForward.zxy * r8.yzx;
	r1.xyz = _FaceForward.yzx * r8.zxy + -r1.xyz;
	r1.x = dot(r1.xyz, _FaceUp);
	r1.x = cmp(r1.x >= 0);
	r1.yzw = -_FaceCenterPos.yzx + f.o5.yzx;
	r2.xyz = _FaceForward.zxy * r1.yzw;
	r1.yzw = _FaceForward.yzx * r1.zwy + -r2.xyz;
	r1.y = dot(r1.yzw, _FaceUp);
	r1.y = cmp(r1.y >= 0);
	r1.xy = r1.xy ? float2(1, 1) : float2(-1, -1);
	r1.x = r1.y * r1.x + 1;
	r1.x = 0.5 * r1.x;
	r1.yzw = r1.xxx * r9.xyz + r7.xyz;
	r2.xyz = r7.xyz + -r6.xyz;
	r2.xyz = r1.xxx * r2.xyz + r6.xyz;
	r1.xyz = r1.yzw + -r0.xyz;
	r1.w = dot(_FaceForward.xyz, -r8.xyz);
	r1.w = 0.100000001 + r1.w;
	r1.w = max(0, r1.w);
	r1.w = 0.5 + -r1.w;
	r1.w = -abs(r1.w) * 2 + 1;
	r1.w = max(0, r1.w);
	r2.w = dot(_FaceUp, r8.xyz);
	r3.x = dot(_FaceForward.xyz, r8.xyz);
	r3.x = 1 + -abs(r3.x);
	r3.x = saturate(r3.x + r3.x);
	r2.w = min(0, r2.w);
	r2.w = 1 + r2.w;
	r2.w = r2.w * r2.w;
	r1.w = r2.w * r1.w;
	r2.w = -0.50999999 + r10.y;
	r2.w = max(0, r2.w);
	r2.w = r2.w * r3.w;
	r1.w = dot(r2.ww, r1.ww);
	r3.yz = float2(1, 1) + -float2(_CheekPretenseThreshold, _NosePretenseThreshold);
	r1.w = cmp(r1.w >= r3.y);
	r1.w = r1.w ? 1.000000 : 0;
	r2.w = cmp(r10.y >= 0.50999999);
	r2.w = r2.w ? 1.000000 : 0;
	r1.w = r2.w * r1.w;
	r0.xyz = r1.www * r1.xyz + r0.xyz;
	r1.xyz = r2.xyz + -r0.xyz;
	r1.w = min(0.49000001, r10.y);
	r1.w = r1.w * -2 + 1;
	r1.w = r1.w * r3.x;
	r1.w = cmp(r1.w >= r3.z);
	r1.w = r1.w ? 1.000000 : 0;
	r2.x = cmp(0.49000001 >= r10.y);
	r2.x = r2.x ? 1.000000 : 0;
	r1.w = r2.x * r1.w;
	r1.w = _NoseVisibility * r1.w;
	r0.xyz = r1.www * r1.xyz + r0.xyz;

	//r1.xyzw = t6.Sample(s6_s, f.o1.xy).xyzw;
	r1 = tex2D(_EmissiveTex, f.o1.xy);

	r1.xyz = _EmissiveColor.xyz * r1.xyz;
	r1.xyz = r1.xyz * r0.www;
	r2.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
	r0.xyz = r0.xyz * r2.xyz + r1.xyz;
	r0.w = -_faceShadowEndY + f.o8.y;
	r0.w = saturate(r0.w / _faceShadowLength);
	r1.x = -r0.w * _faceShadowAlpha + 1;
	r0.w = _faceShadowAlpha * r0.w;
	r0.w = r10.z * r0.w;
	r1.yzw = r0.www * r0.xyz;
	r0.w = r10.z * r1.x;
	r1.x = 1 + -r10.z;
	r2.xyz = r0.www * r0.xyz;
	r0.xyz = r1.xxx * r0.xyz + r2.xyz;
	r0.xyz = r1.yzw * _faceShadowColor.xyz + r0.xyz;
	r0.xyz = -_Global_FogColor.xyz + r0.xyz;
	r0.xyz = f.p1.xxx * r0.xyz + _Global_FogColor.xyz;
	r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
	r0.xyz = _Saturation * r0.xyz;
	r1.x = 1 + -_Saturation;
	result.xyz = r0.www * r1.xxx + r0.xyz;
	return result;
}

Edge_v2f Edge_vert(Edge_a2v v) {
	Edge_v2f f;
	f.o0 = 0;
	f.o1 = 0;
	f.p1 = 0;

	float4 r0, r1, r2;

	r0.xyz = mul(float4(UNITY_MATRIX_I_V[0].y, UNITY_MATRIX_I_V[1].y, UNITY_MATRIX_I_V[2].y, UNITY_MATRIX_I_V[3].y), unity_WorldToObject).xyz;

	r0.x = dot(r0.xyz, v.v1.xyz);

	r0.xy = float2(UNITY_MATRIX_P[0].y, UNITY_MATRIX_P[1].y) * r0.xx;


	r1.xyz = mul(float4(UNITY_MATRIX_I_V[0].x, UNITY_MATRIX_I_V[1].x, UNITY_MATRIX_I_V[2].x, UNITY_MATRIX_I_V[3].x), unity_WorldToObject).xyz;

	r0.z = dot(r1.xyz, v.v1.xyz);

	r0.xy = float2(UNITY_MATRIX_P[0].x, UNITY_MATRIX_P[1].x) * r0.zz + r0.xy;


	r1.xyz = mul(float4(UNITY_MATRIX_I_V[0].z, UNITY_MATRIX_I_V[1].z, UNITY_MATRIX_I_V[2].z, UNITY_MATRIX_I_V[3].z), unity_WorldToObject).xyz;

	r0.z = dot(r1.xyz, v.v1.xyz);


	r0.xy = float2(UNITY_MATRIX_P[0].z, UNITY_MATRIX_P[1].z) * r0.zz + r0.xy;

	r0.xy = float2(UNITY_MATRIX_P[0].w, UNITY_MATRIX_P[1].w) + r0.xy;

	r0.z = _GlobalCameraFov * 0.5 + 0.75;
	r0.xy = r0.xy * r0.zz;
	r0.z = _GlobalOutlineWidth * v.v3.x;
	r0.z = _OutlineWidth * r0.z;
	r0.z = 0.0027999999 * r0.z;


	r1 = mul(v.v0, unity_ObjectToWorld);


	r2 = mul(r1, UNITY_MATRIX_VP);


	f.o0.xy = r0.xy * r0.zz + r2.xy;
	r0.x = 1 + -v.v3.y;
	r0.x = 0.0187500007 * r0.x;
	r0.x = _GlobalCameraFov * r0.x;
	f.o0.z = -r0.x * _GlobalOutlineOffset + r2.z;
	f.o0.w = r2.w;

	r0.x = mul(r1, UNITY_MATRIX_V).z;

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


