// Cloth rippling in the wind, pinned along the edge where uv.x is 0 and free at uv.x = 1.
// Displaces along the mesh's local Y, so it suits a flat grid such as the water_grid generator.
// material_param(0): wave height at the free edge, in meters, material_param(1): waves across the cloth,
// material_param(2): waves per second
VertexOut transform(float4x4 model, float3 pos, float3 normal, float3 tangent, float3 color, float2 uv)
{
    float k = 6.2831853 * material_param(1);
    float w = 6.2831853 * material_param(2);
    float phase = k * uv.x - w * VIEW.elapsed + 1.3 * uv.y;
    float amp = material_param(0) * uv.x;
    float lift = amp * (sin(phase) + 0.3 * sin(2.3 * phase + 0.8));
    float slope = amp * k * (cos(phase) + 0.69 * cos(2.3 * phase + 0.8)) + material_param(0) * sin(phase);
    float3 bent = normalize(normal - float3(1.0, 0.0, 0.0) * slope * 0.5);
    return project_vertex(model, pos + normal * lift, bent, tangent, color, uv);
}
