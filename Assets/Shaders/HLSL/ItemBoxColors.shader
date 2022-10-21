// https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@8.2/manual/writing-shaders-urp-basic-unlit-structure.html
Shader "Unlit/ItemBoxColors"
{
    Properties
    {
        _Grayscale ("Grayscale", 2D) = "white" {}
        _Colors ("Colors", 2D) = "white" {}
        _ColorVelocity ("Color Velocity", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Front

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // The Core.hlsl file contains definitions of frequently used HLSL
            // macros and functions, and also contains #include references to other
            // HLSL files (for example, Common.hlsl, SpaceTransforms.hlsl, etc.).
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                // The positionOS variable contains the vertex positions in object space.
                float4 positionOS   : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                // The positions in this struct must have the SV_POSITION semantic.
                float4 positionHCS  : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _Grayscale;
            sampler2D _Colors;
            float _ColorVelocity;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // The TransformObjectToHClip function transforms vertex positions
                // from object space to homogenous clip space
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.uv = IN.uv;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 grayscaleColor = tex2D(_Grayscale, IN.uv);

                float timeScaled = _Time.y * _ColorVelocity;

                float offset = grayscaleColor.r + timeScaled;
                float2 offsetUVs = frac(IN.uv + offset);

                half4 rainbowColor = tex2D(_Colors, offsetUVs);

                return rainbowColor;
            }
            ENDHLSL
        }
    }
}
