// https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@8.2/manual/writing-shaders-urp-basic-unlit-structure.html
Shader "Unlit/ItemBoxGlass"
{
    Properties
    {
        _FresnelPower("Fresnel Power", Range(0,2)) = 0.75
        _SpecularPower("Specular Power", Range(0,1)) = 0.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Tags { "Queue"="Transparent" }
        LOD 100

        ZWrite Off
        Blend One One

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // The Core.hlsl file contains definitions of frequently used HLSL
            // macros and functions, and also contains #include references to other
            // HLSL files (for example, Common.hlsl, SpaceTransforms.hlsl, etc.).
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "./MainLight.hlsl"
            #include "./BlinnPhongLighting.hlsl"

            struct Attributes
            {
                // The positionOS variable contains the vertex positions in object space.
                float4 positionOS   : POSITION;
                float3 normal : NORMAL;
            };

            struct Varyings
            {
                // The positions in this struct must have the SV_POSITION semantic.
                float4 positionHCS  : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // The TransformObjectToHClip function transforms vertex positions
                // from object space to homogenous clip space
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                // OUT.normal = IN.normal;
                OUT.normal = TransformObjectToWorldNormal(IN.normal);

                OUT.viewDir = normalize(_WorldSpaceCameraPos.xyz - TransformObjectToWorld(IN.positionOS));

                return OUT;
            }

            float _FresnelPower;
            float _SpecularPower;

            half4 frag(Varyings IN) : SV_Target
            {
                // fresnel
                half fresnelDot = dot(IN.normal, IN.viewDir);
                fresnelDot = saturate(fresnelDot); // clamp to 0,1
                half fresnel = max(0.0, _FresnelPower - fresnelDot); // fresnelDot is zero when normal is 90 deg angle from view dir

                // blinn phong
                float3 lightDir = 0;
                float3 lightColor = 0;
                MainLight_half(lightDir, lightColor);

                half specular = 0;
                ComputeBlinnPhong_half(lightDir, IN.normal, IN.viewDir, _SpecularPower, specular);

                half color = fresnel + specular;

                return half4(color, color, color, 0.5);
            }
            ENDHLSL
        }
    }
}
