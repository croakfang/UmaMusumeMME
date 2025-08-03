/****************
Made by CroakFang
Update Date: 2023-11-26
Project Address: https://github.com/croakfang/UmaMusumeMME
Description: This MME requires models exported with UmaViewer to fully achieve its effects.
This file must be saved in UTF-8 encoding to function correctly.
Non-alphabetic characters must be encoded in Shift-JIS, or they will not be recognized. For example, the character "頭" should be written as "摢".
****************/

#define cmp -
float4x4 UNITY_MATRIX_V : VIEW;
float4x4 UNITY_MATRIX_VP : VIEWPROJECTION;
float4x4 UNITY_MATRIX_I_V : WORLDVIEW;
float4x4 UNITY_MATRIX_P : PROJECTION;
float4x4 unity_ObjectToWorld : WORLD;
float4x4 unity_WorldToObject : WORLDINVERSE;


float3 _WorldSpaceLightPos : DIRECTION < string Object = "Light"; >;
float3 _WorldSpaceCameraPos : POSITION < string Object = "Camera"; >;

texture MainTexture : MATERIALTEXTURE;
texture TripleMaskTexture < string ResourceName = "Texture2D/tex_chr1089_30_hair_base.png"; >;
texture OptionMaskTexture < string ResourceName = "Texture2D/tex_chr1089_30_hair_ctrl.png"; >;
texture ToonMapTexture < string ResourceName = "Texture2D/tex_chr1089_30_hair_shad_c.png"; >;
texture EnvMapTexture < string ResourceName = "Texture2D/tex_chr_env000.png"; >;
texture DirtTexture;
texture EmissiveTexture;

float4 _Global_FogMinDistance = 0;
float4 _Global_FogLength = 0;
float _Global_MaxDensity = 10;
float _Global_MaxHeight = 10;
float4 _GlobalMipBias = float4(0, 1, 0, 0);

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
float3 _DirtRate = 0;
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
float _NormalizeNormal = 0;
float _Silhouette = 0;

float _GlobalCameraFov = 30;
float _GlobalOutlineWidth = 1;
float _OutlineWidth = 0.2;
float _GlobalOutlineOffset = 0;
float4 _OutlineColor = float4(0, 0, 0, 1); //TOONCOLOR;


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

struct a2v
{
    float4 v0 : POSITION0;
    float2 v1 : TEXCOORD0;
    float3 v2 : NORMAL0;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD1;
    float4 v5 : TEXCOORD2;
    float2 v6 : TEXCOORD3;
};

struct v2f
{
    float4 o0 : SV_POSITION0;
    float2 o1 : TEXCOORD0;
    float2 p1 : TEXCOORD5;
    float4 o2 : TEXCOORD7;
    float4 o3 : TEXCOORD8;
    float4 o4 : TEXCOORD1;
    float4 o5 : TEXCOORD2;
    float4 o6 : TEXCOORD3;
    float4 o7 : TEXCOORD4;
    float4 o8 : TEXCOORD10;
};

v2f vert(a2v v)
{
    v2f f;
    // 初始化输出变量
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
    
    float4 r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0;
    float4 worldPos = mul(v.v0, unity_ObjectToWorld); 
    r0 = mul(worldPos, UNITY_MATRIX_V);
    r1.w = dot(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x),
              float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x));
    r1.w = sqrt(r1.w);
    r0.x = v.v4.x * 12.5 * r1.w + r0.x;
    r1.w = dot(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y),
              float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y));
    r1.w = sqrt(r1.w); 
    r0.y = (1 - v.v4.y) * 12.5 * r1.w + r0.y; 

    f.o0 = mul(r0, UNITY_MATRIX_P); 

    r0.w = -_Global_FogMinDistance.w + -r0.z;
    r0.w = saturate(r0.w / _Global_FogLength.w);
    r0.w = 1 + -r0.w;
    
    r1.w = saturate(r0.y / _Global_MaxHeight);
    r1.w = 1 + -r1.w;
    r0.w = r0.w * r1.w + _Global_MaxDensity;
    f.p1.xy = saturate(r0.ww);

    f.o1.xy = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;


    r0.w = dot(v.v2.xyz, v.v2.xyz);
    r0.w = sqrt(r0.w);
    r1.w = cmp(9.99999975e-06 >= r0.w);
    r1.w = r1.w ? 1.0 : 0.0;
    r2.x = 1 + -r0.w;
    r0.w = r1.w * r2.x + r0.w;
    r2.xyz = v.v2.xyz / r0.www;
    
    r5.xyz = v.v2.xyz + -r2.xyz;
    r0.w = cmp(0.5 >= _NormalizeNormal);
    r0.w = r0.w ? 1.0 : 0.0;
    r2.xyz = r0.www * r5.xyz + r2.xyz;
    
    r5.xyz = float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y) * r2.yyy;
    r5.xyz = float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x) * r2.xxx + r5.xyz;
    f.o4.xyz = float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z) * r2.zzz + r5.xyz;

    f.o5.xyz = r0.xyz;

    r0.x = -_HightLightParam.x + r0.y;
    r0.x = saturate(r0.x / _HightLightParam.y);
    r0.x = 1 + -r0.x;
    
    r0.yzw = r2.yyy * r1.xyz;
    r0.yzw = r3.xyz * r2.xxx + r0.yzw;
    f.o6.xyz = r4.xyz * r2.zzz + r0.yzw;
    
    r0.y = _SpecularPower * -10 + 11;
    f.o7.x = exp2(r0.y);
    f.o7.yzw = float3(0, 0, 0);
    
    r0.y = 2 + -r0.x;
    r0.z = -r0.x * 2 + 3;
    r0.yw = r0.xx * r0.yx;
    r0.z = r0.w * r0.z + -r0.y;
    r1.xyz = cmp(_HightLightParam.zzz >= float3(2.5, 1.5, 0.5));
    r1.xyz = r1.xyz ? float3(1, 1, 1) : 0;
    r0.y = r1.x * r0.z + r0.y;
    r0.y = -r0.x * r0.x + r0.y;
    r0.y = r1.y * r0.y + r0.w;
    r0.y = r0.y + -r0.x;
    r0.x = r1.z * r0.y + r0.x;
    
    f.o8.xyz = _HightLightColor.xyz * r0.xxx;
    f.o8.w = r0.x;

    return f;
}


float4 frag(v2f f) : SV_Target
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7;
    float4 result;

    r0.xyzw = tex2Dbias(_TripleMaskMap, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;
    r0.z = cmp(r0.z < _Cutoff);
    if (r0.z != 0)
        discard;
    r1.xyzw = tex2Dbias(_MainTex, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;

    r0.zw = f.o3.xy * float2(2, 2) + float2(-1, -1);
    r0.z = dot(r0.zw, r0.zw);
    r0.z = sqrt(r0.z);
    r0.z = min(1, r0.z);
    r0.z = -r0.z * r0.z + 1;
    r2.z = sqrt(r0.z);
    r2.xy = f.o3.xy * float2(2, 2) + float2(-1, -1);
    r3.x = dot(r2.xyz, float3(UNITY_MATRIX_V[0].x, UNITY_MATRIX_V[1].x, UNITY_MATRIX_V[2].x));
    r3.y = dot(r2.xyz, float3(UNITY_MATRIX_V[0].y, UNITY_MATRIX_V[1].y, UNITY_MATRIX_V[2].y));
    r3.z = dot(r2.xyz, float3(UNITY_MATRIX_V[0].z, UNITY_MATRIX_V[1].z, UNITY_MATRIX_V[2].z));

    r0.z = dot(r3.xyz, r3.xyz);
    r0.z = rsqrt(r0.z);
    r2.xyz = r3.xyz * r0.zzz;

    r1.xyz = _LightColor0.xyz * r1.xyz;
    float4 option = tex2Dbias(_OptionMaskMap, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;
    r0.z = option.y * _UseOptionMaskMap;
    r0.w = (option.z - 0.5) * _UseOptionMaskMap + 0.5;
    r3.xyz = _WorldSpaceCameraPos.xyz + -f.o5.xyz;

    r2.w = dot(r3.xyz, r3.xyz);
    r2.w = rsqrt(r2.w);
    r3.xyz = r3.xyz * r2.www;

    r2.w = dot(_WorldSpaceLightPos.xyz, _WorldSpaceLightPos.xyz);
    r2.w = rsqrt(r2.w);
    r4.xyz = _WorldSpaceLightPos.xyz * r2.www;
    r2.w = dot(_OriginalDirectionalLightDir, _OriginalDirectionalLightDir);
    r2.w = rsqrt(r2.w);
    r3.w = _UseOriginalDirectionalLight;
    r3.w = cmp(r3.w >= 1);
    r3.w = r3.w ? 1.000000 : 0;
    r5.xyz = _OriginalDirectionalLightDir * r2.www + -r4.xyz;
    r4.xyz = r3.www * r5.xyz + r4.xyz;
    r2.w = dot(r2.xyz, r4.xyz);
    r3.w = 0.5 * r2.w;
    r4.x = r2.w * 0.5 + 0.5;
    r4.y = -_ToonFeather + _ToonStep;
    r0.x = -r0.x * r4.x + r4.y;
    r0.x = r0.x / _ToonFeather;
    r0.x = saturate(1 + r0.x);
    r4.x = cmp(0 >= _ToonFeather);
    r4.x = r4.x ? 1.000000 : 0;
    r0.x = r4.x * -r0.x + r0.x;

    r4.xyzw = tex2Dbias(_ToonMap, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;

    r4.xyz = _LightColor0.xyz * r4.xyz;
    r4.xyz = _GlobalToonColor.xyz * r4.xyz;
    r4.w = 1 + -f.o3.w;
    r4.w = _VertexColorToonPower * r4.w;
    r3.w = min(0, r3.w);
    r3.w = 0.5 + r3.w;
    r3.w = dot(r4.ww, r3.ww);
    r3.w = 1 + -r3.w;
    r4.w = cmp(0.5 >= _ToonBrightColor.w);
    r5.x = r4.w ? 1.000000 : 0;
    r5.x = r5.x * r3.w;
    r5.yzw = float3(-1, -1, -1) + _ToonBrightColor.xyz;
    r5.xyz = r5.xxx * r5.yzw + float3(1, 1, 1);
    r6.xyz = r4.www ? float3(0, 0, 0) : _ToonBrightColor.xyz;
    r6.xyz = r6.xyz * r3.www;
    r1.xyz = r1.xyz * r5.xyz + r6.xyz;
    r4.w = cmp(0.5 >= _ToonDarkColor.w);
    r5.x = r4.w ? 1.000000 : 0;
    r5.x = r5.x * r3.w;
    r5.yzw = float3(-1, -1, -1) + _ToonDarkColor.xyz;
    r5.xyz = r5.xxx * r5.yzw + float3(1, 1, 1);
    r6.xyz = r4.www ? float3(0, 0, 0) : _ToonDarkColor.xyz;
    r6.xyz = r6.xyz * r3.www;
    r4.xyz = r4.xyz * r5.xyz + r6.xyz;
    r4.xyz = r4.xyz + -r1.xyz;
    r1.xyz = r0.xxx * r4.xyz + r1.xyz;

    r4.xyzw = tex2Dbias(_DirtTex, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;

    r4.xyz = _DirtScale * r4.xyz;
    r3.w = dot(r4.xyz, _DirtRate.xyz);
    r4.x = cmp(-0 >= _RimHorizonOffset);
    r5.x = UNITY_MATRIX_V[0].x;
    r5.y = UNITY_MATRIX_V[0].y;
    r5.z = UNITY_MATRIX_V[0].z;
    r4.y = cmp(-0 >= _RimVerticalOffset);
    r4.xy = r4.xy ? float2(1, 1) : float2(-1, -1);
    r6.x = UNITY_MATRIX_V[1].x;
    r6.y = UNITY_MATRIX_V[1].y;
    r6.z = UNITY_MATRIX_V[1].z;
    r4.xzw = r5.xyz * r4.xxx + -r3.xyz;
    r4.xzw = abs(_RimHorizonOffset) * r4.xzw + r3.xyz;
    r7.xyz = r6.xyz * r4.yyy + -r4.xzw;
    r4.xyz = abs(_RimVerticalOffset) * r7.xyz + r4.xzw;


    r4.x = dot(r4.xyz, r2.xyz);


    r4.y = _RimStep + -_RimFeather;
    r4.y = r4.y + -r4.x;
    r4.y = r4.y / _RimFeather;
    r4.y = saturate(1 + r4.y);

    r4.y = r4.y * r4.y;
    r4.y = r4.y * r4.y;
    r4.y = _RimColor.w * r4.y;

    r4.y = r4.y * r0.w;


    r4.zw = cmp(float2(-0, -0) >= float2(_RimHorizonOffset2, _RimVerticalOffset2));
    r4.zw = r4.zw ? float2(1, 1) : float2(-1, -1);


    r5.xyz = r5.xyz * r4.zzz + -r3.xyz;
    r3.xyz = abs(_RimHorizonOffset2) * r5.xyz + r3.xyz;
    r5.xyz = r6.xyz * r4.www + -r3.xyz;
    r3.xyz = abs(_RimVerticalOffset2) * r5.xyz + r3.xyz;
    r2.x = dot(r3.xyz, r2.xyz);
    r2.y = _RimStep2 + -_RimFeather2;
    r2.x = r2.y + -r2.x;
    r2.x = r2.x / _RimFeather2;
    r2.x = saturate(1 + r2.x);
    r2.x = r2.x * r2.x;
    r2.x = r2.x * r2.x;
    r2.x = _RimColor.w * r2.x;
    r0.w = r2.x * r0.w;
    r2.x = max(0, r4.x);
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
    r1.xyz = r3.www * r2.xyz + r1.xyz;
    r0.xy = float2(1, 1) + f.o6.xy;
    r0.xy = float2(0.5, 0.5) * r0.xy;
                
    r5.xyzw = tex2Dbias(_EnvMap, float4(r0.xy, 0, _GlobalMipBias.x)).xyzw;

    r2.xyz = r5.xyz * r1.xyz;
    r0.x = _EnvRate * r0.z;
    r2.xyz = r2.xyz * _EnvBias + -r1.xyz;
    r0.xyz = r0.xxx * r2.xyz + r1.xyz;

    r1.xyz = _RimColor.xyz + -_SpecularColor.xyz;
    r1.xyz = _RimSpecRate * r1.xyz + _SpecularColor.xyz;


    r2.x = max(0, r2.w);
    r1.xyz = r1.xyz * r4.yyy;


    r2.y = _RimShadow + r2.x;
    r2.y = _RimShadowRate + r2.y;
    r1.xyz = r2.yyy * r1.xyz;
    r2.yz = _GlobalRimColor.xy * r1.xy;
    r0.xyz = r1.xyz * _GlobalRimColor.xyz + r0.xyz;

    r3.xyz = _RimColor2.xyz + -_SpecularColor.xyz;
    r3.xyz = _RimSpecRate2 * r3.xyz + _SpecularColor.xyz;
    r3.xyz = r3.xyz * r0.www;
    r0.w = _RimShadowRate2 + r2.x;
    r3.xyz = r3.xyz * r0.www;
    r0.xyz = r3.xyz * _GlobalRimColor.xyz + r0.xyz;
    r0.w = r2.y + r2.z;
    r0.w = r1.z * _GlobalRimColor.z + r0.w;
    r0.w = cmp(9.99999975e-06 >= r0.w);


    r1.xyz = r0.www ? _GlobalDirtColor.xyz : _GlobalDirtRimSpecularColor.xyz;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = r3.www * r1.xyz + r0.xyz;
    r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
    r0.w = 1 + -r3.w;


                //r2.xyzw = t6.SampleBias(s6_s, v1.xy, _GlobalMipBias.x).xyzw;
    r2.xyzw = tex2Dbias(_EmissiveTex, float4(f.o1.xy, 0, _GlobalMipBias.x)).xyzw;

    r2.xyz = _EmissiveColor.xyz * r2.xyz;
    r2.xyz = r2.xyz * r0.www;
    r0.xyz = r0.xyz * r1.xyz + r2.xyz;
    r1.xyz = f.o8.xyz + r0.xyz;
    r2.xyz = r0.xyz * f.o8.xyz + r0.xyz;
    r3.xyz = f.o8.xyz + -r0.xyz;
    r0.xyz = f.o8.www * r3.xyz + r0.xyz;
    r3.xy = cmp(_HightLightParam.ww >= float2(1.5, 0.5));
    r3.xy = r3.xy ? float2(1, 1) : 0;
    r0.xyz = r0.xyz + -r2.xyz;
    r0.xyz = r3.xxx * r0.xyz + r2.xyz;
    r0.xyz = r0.xyz + -r1.xyz;
    r0.xyz = r3.yyy * r0.xyz + r1.xyz;
    r0.xyz = -_Global_FogColor.xyz + r0.xyz;
    r0.xyz = f.p1.xxx * r0.xyz + _Global_FogColor.xyz;
    r1.xyz = _CharaColor.xyz + -r0.xyz;
    r0.xyz = _Silhouette * r1.xyz + r0.xyz;
    r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r1.x = 1 + -_Saturation;
    r0.xyz = _Saturation * r0.xyz;
    result.xyz = r0.www * r1.xxx + r0.xyz;
    result.w = r1.w;

    return result;
}

technique MainTec < string MMDPass = "object"; >
{
    pass DarwObject
    {
        VertexShader = compile vs_3_0 vert();
        PixelShader = compile ps_3_0 frag();
    }
};

technique MainTec_ss < string MMDPass = "object_ss"; >
{
    pass DarwObject
    {
        VertexShader = compile vs_3_0 vert();
        PixelShader = compile ps_3_0 frag();
    }
};
