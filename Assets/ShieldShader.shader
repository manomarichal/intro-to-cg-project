Shader "Unlit/ShieldShader = "
{
    Properties
    {
        _StartColor ("Start Color", Color) = (1, 1, 1, 1) 
        _EndColor ("Tail Color", Color) = (1, 1, 1, 1) 
    }
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

            Pass
        {
            // pass tags
            Zwrite Off 
            Blend One One // Additive
            Cull Off
               
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _StartColor;
            float4 _EndColor;
            
            struct mesh_data
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct interpolations
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: TEXCOORD1;
            };

            interpolations vert (mesh_data v)
            {
                interpolations o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normals;
                return o;
            }

            fixed4 frag (interpolations i) : SV_Target
            {
                float remove_ground = abs(i.normal.y) < 0.999;
                float wave = i.uv.y + cos(i.uv.x*100)*0.05;
                float t = frac(wave - _Time*50);
                float4 gradient = lerp(_StartColor, _EndColor, i.uv.y);
                
                return t*gradient*remove_ground*(1-i.uv.y);
            }
            ENDCG
        }
    }
}
