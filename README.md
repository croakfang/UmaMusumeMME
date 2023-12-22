# UmaMusumeMME
Umamusume Shader for MMD

Model rip by 红白de黑白、无名

![shader](https://github.com/croakfang/UmaMusumeMME/assets/32562737/508479a2-44d5-4fbf-9633-a4835d6a7d5b)

# Usage
此MME需要使用[UmaViewer](https://github.com/katboi01/UmaViewer)导出的模型才能完全工作。  

### 对于 `UMA_Body.fx` / `UMA_Hair.fx` / `UMA_Tail.fx`
1. 找到以下内容：
```
texture TripleMaskTexture < string ResourceName = "Texture2D/tex_bdy2005_00_base.png"; > ;
texture OptionMaskTexture < string ResourceName = "Texture2D/tex_bdy2005_00_ctrl.png"; > ;
texture ToonMapTexture < string ResourceName = "Texture2D/tex_bdy2005_00_shad_c.png"; > ;
texture EnvMapTexture < string ResourceName = "Texture2D/tex_chr_env000.png"; > ;
```  
2. 将`ResourceName`改为你想要渲染马娘的对应部位的贴图，变动部分基本只有编号，`base`/`ctrl`/`shad_c`这些后缀不要有变化  

### 对于 `UMA_Eye.fx` / `UMA_Face.fx`
1. 找到以下内容：
```
texture TripleMaskTexture < string ResourceName = "Texture2D/tex_bdy2005_00_base.png"; > ;
texture OptionMaskTexture < string ResourceName = "Texture2D/tex_bdy2005_00_ctrl.png"; > ;
texture ToonMapTexture < string ResourceName = "Texture2D/tex_bdy2005_00_shad_c.png"; > ;
texture EnvMapTexture < string ResourceName = "Texture2D/tex_chr_env000.png"; > ;

texture MainTex < string ResourceName = "Texture2D/tex_chr2005_00_eye0_all.png"; > ;
texture High0Tex < string ResourceName = "Texture2D/tex_chr2005_00_eyehi00.png"; > ;
texture High1Tex < string ResourceName = "Texture2D/tex_chr2005_00_eyehi01.png"; > ;
texture High2Tex < string ResourceName = "Texture2D/tex_chr2005_00_eyehi02.png"; > ;
```
2. 将`ResourceName`改为你想要渲染马娘的对应部位的贴图
3. 将模型名字修改为英文，如：Daitaku Helios.pmx
4. 模型添加一个骨骼`head`，将其父骨骼设为`頭`，并与`頭`位置重合
5. 找到参数:  
   ```
   float4x4 _faceShadowHeadMat : CONTROLOBJECT < string name = "model.pmx"; string item = "摢"; >
   ```  
   将`name`替换为模型的名字，`item`替换为`head`，如：  
   ```
   float4x4 _faceShadowHeadMat : CONTROLOBJECT < string name = "model.pmx"; string item = "head"; >
   ```
### 重要参数  
其它值不建议修改  
|参数名|说明|
|-|-|
|_ToonStep|阴影范围|
|_ToonFeather|阴影羽化|
|_ToonBrightColor|亮部颜色|
|_ToonBrightColor|暗部颜色(阴影)|
|_RimStep|边缘光范围|
|_RimFeather|边缘光羽化|
|_RimColor|边缘光颜色|
|_OutlineWidth|描边厚度|
|_OutlineColor|描边颜色|
|_GlobalOutlineOffset|描边Z偏移，确保其<=0，如果出现描边黑块，尝试逐步减少它的值|

