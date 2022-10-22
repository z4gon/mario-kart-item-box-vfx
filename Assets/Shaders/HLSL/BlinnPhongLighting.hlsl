void ComputeBlinnPhong_half(half3 lightDir, half3 normal, half3 viewDir, half attenuation, out half Specular)
{
    half3 reflectedLightDir = reflect(lightDir, normal);

    half specularDot = dot(-viewDir, reflectedLightDir);

    Specular = max(0, specularDot - attenuation); // avoid negative values
}
