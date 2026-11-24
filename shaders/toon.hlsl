// Cel shading: the sun in a few hard bands of light, ambient fill and a bright rim.
// material_param(0): light bands, 2 to 6, material_param(1): rim strength,
// material_param(2): how much sunlight the darkest band keeps, in [0, 1]
float4 shade(VertexOut v, GpuObjectData od)
{
    float3 albedo = pool_sample(od.albedo_index, v.uv).rgb * od.tint_roughness.rgb;
    float3 n = normalize(v.normal);
    float3 to_eye = normalize(float3(VIEW.cam_x, VIEW.cam_y, VIEW.cam_z) - v.world_pos);
    float3 sun = (float3)(0.0);
    if (LIGHTS.num_dir > 0)
    {
        float bands = clamp(material_param(0), 2.0, 6.0);
        float3 l = normalize(LIGHTS.dir[0].dir_i.xyz);
        float shadow = shadow_factor_cascaded(v.world_pos, v.view_depth, v.position.xy);
        float lit = saturate(dot(n, l)) * shadow;
        float banded = max(ceil(lit * bands) / bands, material_param(2));
        sun = LIGHTS.dir[0].col.rgb * LIGHTS.dir[0].dir_i.w * banded;
    }
    float rim = step(0.72, 1.0 - saturate(dot(n, to_eye))) * material_param(1);
    float3 ambient = irradiance_sample(n);
    return float4(albedo * (sun + ambient + rim), 1.0);
}
