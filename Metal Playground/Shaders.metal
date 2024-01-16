#include <metal_stdlib>

using namespace metal;

struct VertexIn 
{
    float3 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
};

struct VertexOut
{
    float4 position [[position]];

    float3 eye_position;
    float3 eye_normal;
};

struct Uniforms
{
    float4x4 model_matrix;
    float4x4 view_matrix;
    float4x4 projection_matrix;
};

vertex VertexOut vertex_main(VertexIn vertex_in [[stage_in]],
                              constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut vertex_out;
    vertex_out.position = uniforms.projection_matrix * uniforms.view_matrix * uniforms.model_matrix * float4(vertex_in.position, 1);

    vertex_out.eye_position = (uniforms.view_matrix * uniforms.model_matrix * float4(vertex_in.position, 1)).xyz;
    vertex_out.eye_normal = (uniforms.view_matrix * uniforms.model_matrix * float4(vertex_in.normal, 0)).xyz;

    return vertex_out;
}

fragment float4 fragment_main(VertexOut vertex_out [[stage_in]])
{
    float4 base_color(1, 1, 1, 1);

    float3 light_direction(1, 1, 0);

    float3 f_unlit(0, 0, 0);

    float3 N = normalize(vertex_out.eye_normal);
    float3 L = normalize(light_direction - vertex_out.eye_position);

    float light = saturate(dot(N, L));

    return base_color * float4(f_unlit + light, 1);

    return base_color;
}
