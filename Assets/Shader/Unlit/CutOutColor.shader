Shader "Unlit/CutOutColor"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _Transparency("Transparency", Range(0.0,1)) = 0.25
        _CutOutThresh("Cutout Threshhold", Range(0.0,1.0)) = 0.2
    }
    SubShader
    {
        //Setup for renderer (Rendering Order)
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
            
        // we need this to set alpha channel for transparency
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
                #pragma vertex vertexFunction
                #pragma fragment fragmentFunction

                #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4      _MainTex_ST;
            sampler2D   _MainTex;
            float4      _Color;
            float       _Transparency;
            float       _CutOutThresh;

            v2f vertexFunction(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //TRANSFORM_TEX = takes uv data from model
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 fragmentFunction(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = _Transparency;
                // same as if(x < 0){ discard };
                // for x we give (col.r - _CutOutThresh) as argument 
                clip(col.r - _CutOutThresh);
                return col;
            }
            ENDCG
        }
    }
}
