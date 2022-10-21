half blinnPhong(half3 lightDir, half3 normal, half3 viewDir)
{
    half3 reflectedLightDir = reflect(lightDir, normal);

    half specular = max(0, dot(-viewDir, reflectedLightDir)); // avoid negative values

    return specular;
}
