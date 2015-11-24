Shader "Food/Karaage" {
    CGINCLUDE
    
	#include "UnityCG.cginc"
	#include "ClassicNoise2D.cginc"

	ENDCG
	
	Properties {
	    _MainTex("Base (RGB)", 2D) = "white" { }
	    _Color1("Color 1 (RGB)", Color) = (0,0,0,1)
	    _Color2("Color 2 (RGB)", Color) = (1,1,1,1)
		_Seed ("Seed", Range(0.0, 1.0)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma target 3.0 
	    #pragma surface surf Lambert vertex:vert

		float3 _Color1;
		float3 _Color2;
		float _Seed;

	    struct Input {
	        float2 uv_MainTex;
	    };

		void vert(inout appdata_full v)
		{
		    float c = 0.5;
		    float s = 1.0;
		    float w = 0.5;

		   	for (int i = 0; i < 6; i++)
		    {
		        float3 coord = float3((v.vertex.xy + float2(0.2, 1) * _Seed) * s, 0) * 2;
		        float3 period = float3(s, s, 1) * 2;

	            c += pnoise(coord, period) * w;

		        s *= 2.0;
		        w *= 0.5;
		    }
		
	        v.vertex.xyz *= 1 + (c - 0.5);
		}

		sampler2D _MainTex;
	    void surf (Input IN, inout SurfaceOutput o) {
		    float2 uv = IN.uv_MainTex * 4.0;

		    float c = 0.5;
		    float s = 1.0;
		    float w = 0.5;

		   	for (int i = 0; i < 10; i++)
		    {
		        float3 coord = float3((uv + float2(0.2, 1) * _Seed) * s, 0) * 2;
		        float3 period = float3(s, s, 1) * 2;

	            c += pnoise(coord, period) * w;

		        s *= 2.0;
		        w *= 0.5;
		    }

	        o.Albedo = lerp(_Color1, _Color2, c);
	        o.Alpha = 1;
	    }

		ENDCG
	} 
	FallBack "Diffuse"
}
