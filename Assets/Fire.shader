Shader "Unlit/Test"
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
            };

            struct interpolations
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            interpolations vert (mesh_data v)
            {
                interpolations o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (interpolations i) : SV_Target
            {
                float wave = i.uv.y + cos(i.uv.x*100)*0.005;
                float t = frac(wave*10 - _Time*50);
                
                float4 gradient = lerp(_StartColor, _EndColor, i.uv.y);
                return t*gradient;
            }
            ENDCG
        }
    }
}
