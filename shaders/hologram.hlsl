// A projected hologram: glowing scan lines rolling up the surface, a bright rim and a faint flicker.
// The glow color is the material's emissive_factor.
// material_param(0): scan lines per meter, material_param(1): roll speed in meters per second,
// material_param(2): flicker strength in [0, 1]
float hologram_hash(float x)
{
    return frac(sin(x * 12.9898) * 43758.5453);
}

float4 shade(VertexOut v, GpuObjectData od)
{
    float3 to_eye = normalize(float3(VIEW.cam_x, VIEW.cam_y, VIEW.cam_z) - v.world_pos);
    float facing = saturate(abs(dot(normalize(v.normal), to_eye)));
    float rim = pow(1.0 - facing, 3.0);
    float phase = frac(v.world_pos.y * material_param(0) - VIEW.elapsed * material_param(1));
    float scan = smoothstep(0.0, 0.1, phase) * (1.0 - smoothstep(0.35, 0.5, phase));
    float flicker = 1.0 - material_param(2) * step(0.92, hologram_hash(floor(VIEW.elapsed * 20.0)));
    float3 glow = od.emissive_metallic.rgb * (0.15 + 0.85 * scan + 2.5 * rim) * flicker;
    return float4(od.tint_roughness.rgb * 0.03 + glow, 1.0);
}
