void MainLight_half(out half3 Direction, out half3 Color)
{
    // https://blog.unity.com/technology/custom-lighting-in-shader-graph-expanding-your-graphs-in-2019
    #if SHADERGRAPH_PREVIEW
        Direction = half3(0.5, 0.5, 0);
        Color = 1;
    #else
        Light light = GetMainLight();
        Direction = light.direction;
        Color = light.color;
    #endif
}
