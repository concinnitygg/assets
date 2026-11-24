// Molten rock: a dark crust split by glowing veins and pools that slowly crawl.
// The crust is the material's own surface; the glow ramps from deep red to yellow.
// material_param(0): pattern scale per meter, material_param(1): flow speed,
// material_param(2): glow strength
float lava_hash(float2 p)
{
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float lava_noise(float2 p)
{
    float2 i = floor(p);
    float2 f = frac(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    float a = lava_hash(i);
    float b = lava_hash(i + float2(1.0, 0.0));
    float c = lava_hash(i + float2(0.0, 1.0));
    float d = lava_hash(i + float2(1.0, 1.0));
    return lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);
}

float lava_fbm(float2 p)
{
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++)
    {
        sum += amp * lava_noise(p);
        p = p * 2.03 + float2(17.0, 9.0);
        amp *= 0.5;
    }
    return sum;
}

float4 shade(VertexOut v, GpuObjectData od)
{
    float2 p = v.world_pos.xz * material_param(0);
    float t = VIEW.elapsed * material_param(1);
    float warp = lava_fbm(p * 1.7 - float2(t, -0.5 * t));
    float n = lava_fbm(p + float2(0.6 * t, t) + 1.5 * warp);
    float veins = saturate(1.0 - abs(n - 0.5) * 9.0);
    float pools = saturate((0.38 - n) * 5.0);
    float heat = saturate(veins + pools);
    float3 ramp = lerp(float3(0.6, 0.04, 0.0), float3(1.0, 0.55, 0.08), heat * heat);
    ramp = lerp(ramp, float3(1.0, 0.9, 0.5), pow(heat, 6.0));
    float3 glow = ramp * heat * material_param(2);
    float4 crust = shade_surface(v, od);
    return float4(crust.rgb * (1.0 - heat) + glow, 1.0);
}
