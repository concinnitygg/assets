// The engine's own lighting, unchanged.
float4 shade(VertexOut v, GpuObjectData od)
{
    return shade_surface(v, od);
}
