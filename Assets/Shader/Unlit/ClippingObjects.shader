Shader "Unlit/ClippingObjects"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_Emission ("Emission", color) = (0,0,0)

    }
    SubShader
    {
        // the material is completely non-transparent and is rendered at the same time as the other opaque geometry
        // the material and its shader are applied at the geometry stage of the 
        // rendering pipeline, before other effects such as lighting and post 
        // lighting and post-processing effects are considered.
        Tags{ "RenderType"="Opaque" "Queue"="Geometry"}

        // render faces regardless if they point towards the camera or away from it
        Cull Off

        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                    // True or False. Is normal of object looking to camera direction (true) or not (false)
                    float v_Face : VFACE;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                // Object coords that clips an other object
                float4 _Clipping_Plane;

                v2f vert (appdata v)
                {
                    v2f o;
                    // float distance = dot(i.worldPos, _Plane.xyz);
                    o.vertex =
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    // o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    //calculate signed distance to plane
                    // sample the texture
                    // fixed4 col = tex2D(_MainTex, i.uv);
                    float facing = i.v_Face * 0.5 + 0.5;
                    fixed4 col = tex2D(_MainTex, i.uv);
                    col *= float4(col.rgb, col.rgb * facing);
                    return col;
                }
            ENDCG
        }
    }
}
