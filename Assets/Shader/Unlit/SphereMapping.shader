Shader "Unlit/SphereMapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                // POSITION is the vertex position, typically a float3 or float4.
                float4 vertex : POSITION;

                // TEXCOORD0 is the first UV coordinate, typically float2, float3 or float4.
                // float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
        
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // Transforms 2D UV by scale/bias property #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
                // It scales and offsets texture coordinates. XY values controls the texture tiling and ZW the offset.
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = normalize(v.vertex.xyz);
                return o;
            }

            // pixel shader; returns low precision ("fixed4" type)
            // color ("SV_Target" semantic)
            fixed4 frag (v2f i) : SV_Target
            {
                float PI = 3.14159265359;
                float3 N = normalize(i.normal);

                /*
                we need arcustangens2 -> atan2 since we 
                convert plane cartesian coordinates into polar coordinates
                on the sphere
                */
                half longitude_uv = atan2(N.z, N.x) / (2 * PI);
                half latitude_uv =  0.5 + asin(N.y) / PI;
                float2 sphericalUV = float2(longitude_uv, latitude_uv);
                
                // sample the texture
                fixed4 col = tex2D(_MainTex, sphericalUV);
                return col;
            }
            ENDCG
        }
    }
}
