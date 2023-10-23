Shader "Unlit/Displacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Displacement("Displacement", Range(0,1)) = 0.3
        _Color("Color", Color) = (1,1,1,1)
    }
    // multiple and different subshader possible (like one for PC and one for PS4)
    SubShader                                                
    {
        //Setup for renderer (Rendering Order)
        Tags { "RenderType"="Opaque" }

        // single instruction for GPU is Pass
        // A Pass is the fundamental element of a Shader object. It contains instructions for setting the state of the GPU, and the shader programs that run on the GPU.
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexFunction
            #pragma fragment fragmentFunction

            // include at compiletime helper functions
            #include "UnityCG.cginc"

            float4 _Color;
            fixed _Displacement;

            struct appdata
            {
                // inforamtion of vertices (x,y,z,w) its a packed array
                float4 vertex : POSITION;

                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                // SV_Position = Screenspace Position
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // appdata is standard struct for vertex
            v2f vertexFunction(appdata v)
            {
                v2f OUT;
                // parameter form of a linear equation.
                // vertex = P + nU -> U is normal
                // Movement of the vertex along the normal
                v.vertex.xyz = v.vertex.xyz + _Displacement * v.normal.xyz;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.uv = v.uv;
                return OUT;
            }

            //SV-Target = Rendertarget (e.g. Framebuffer of the Screen)
            fixed4 fragmentFunction(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
