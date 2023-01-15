Shader "Unlit/Movement"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}

        //for sin function
        _Distance("Distance", Float) = 1
        _Period("Period", Float) = 1
        _Speed("Speed",Float) = 1
        _Amount("Amount", Range(0.0, 1.0)) = 1
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
                    // inforamtion of vertices (x,y,z,w) its a packed array
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

                float       _Distance;
                float       _Period;
                float       _Speed;
                float       _Amount;

                v2f vertexFunction(appdata v)
                {
                    v2f o;
                    // we remain in object space for now
                    // _Time.y is the time in seconds
                    v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Period) * _Distance * _Amount;

                    o.vertex = UnityObjectToClipPos(v.vertex);

                    //TRANSFORM_TEX = takes uv data from model
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }

                fixed4 fragmentFunction(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                    return col;
                }
            ENDCG
        }
    }
}
