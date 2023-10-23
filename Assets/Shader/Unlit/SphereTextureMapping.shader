Shader "Unlit/SphereTextureMapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // By default we use the built-in texture "white"  
        // (alternatives: "black", "gray" and "bump").
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexFunction
            #pragma fragment fragmentFunction

            #include "UnityCG.cginc"
            
            
            sampler2D _MainTex;

            // S and T are official names of texture coordinates
            // x and y component of Tiling is stored in:
            // _MainTex_ST.x
            // _MainTex_ST.y
            //  x and y component of Offset is stored in:
            // _MainTex_ST.z
            // _MainTex_ST.w
            float4 _MainTex_ST;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vertexFunction(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            fixed4 fragmentFunction(v2f i) : SV_Target
            {
                // tex2D() is an overloaded function
                // we use tex2D(Sampler2D, float2)
                // texture coordinates are multiplied with the tiling 
                // parameters and the offset parameters are added
                 return tex2D(_MainTex, _MainTex_ST.xy * i.uv.xy + _MainTex_ST.zw);

                // with #include "UnityCG.cginc" we can use
                //return tex2D(_MainTex, i.uv.xy);

            }
            ENDCG
        }
    }
}
