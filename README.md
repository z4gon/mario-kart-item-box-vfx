# Mario Kart Item Box VFX

VFX for the item box from the Mario Kart games, implemented both in Shader Graph and in pure HLSL for Universal RP in **Unity 2021.3.10f1**

### References

- [MARIO KART Item Box tutorial by Jettelly](https://www.youtube.com/watch?v=4p0YvPHO4Wc)

## Sections

- [Pure HLSL Implemenation](#pure-hlsl-implementation)
- [Shader Graph Implementation](#shader-graph-implementation)
- [Creating the Textures](#creating-the-textures)
- [Creating the Mesh](#creating-the-mesh)

## Pure HLSL Implemenation

### Animated Rainbow Colors

1. Mark the shader to cull front (only render inward looking faces)
1. Add two `Texture2D` properties, one for the rainbow colors and the other for the grayscale shapes.
1. Add a `Velocity` property to control the velocity of the animation.
1. Multiply the `Time` variable by the `Velocity` parameter, and add it to the `Red` channel of the `Grayscale` texture.
1. Use this value to offset the UVs along the X coordinate.
1. Use [frac()](https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-frac) to ensure the value is between 0 and 1 for uvs.
1. Use these new uvs to get the pixel color from the colors texture.

```c
half4 frag(Varyings IN) : SV_Target
{
   half4 grayscaleColor = tex2D(_Grayscale, IN.uv);

   float timeScaled = _Time.y * _ColorVelocity;

   float offset = grayscaleColor.r + timeScaled;
   float2 offsetUVs = float2(frac(IN.uv.x + offset), IN.uv.y);

   half4 rainbowColor = tex2D(_Colors, offsetUVs);

   return rainbowColor;
}
```

![Gif](./docs/7.gif)

## Shader Graph Implementation

### Animated Rainbow Colors

1. Add two `Texture2D` properties, one for the rainbow colors and the other for the grayscale shapes.
1. Add a `Velocity` property to control the velocity of the animation.
1. Multiply the `Time` variable by the `Velocity` parameter, and add it to the `Red` channel of the `Grayscale` texture.
1. Use this value as an offset in the `Tiling and Offset` node used to determine the UVs of the sampler 2D for the rainbow colors.
1. Mark the shader to cull front (only render inward looking faces)

#### Graph

![Gif](./docs/color-graph.png)

#### Result

![Gif](./docs/5.gif)
![Gif](./docs/6.gif)

## Creating the Textures

![Gif](./docs/1.gif)
![Gif](./docs/2.gif)
![Gif](./docs/3.gif)

## Creating the Mesh

![Gif](./docs/4.gif)
