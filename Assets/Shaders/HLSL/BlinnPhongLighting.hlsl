void ComputeBlinnPhong_half(half3 lightDir, half3 normal, half3 viewDir, out half Specular)
{
    half3 reflectedLightDir = reflect(lightDir, normal);

    Specular = max(0, dot(-viewDir, reflectedLightDir)); // avoid negative values
}
