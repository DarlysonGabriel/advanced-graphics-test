shader_type spatial;

void vertex() {
	// waves for water
	
	float wave_1 = sin(VERTEX.x * 2.0 + TIME) * 0.01;
	float wave_2 = sin(VERTEX.z * 1.8 + TIME * 0.06) * 0.06;
	float wave_3 = sin((VERTEX.x + VERTEX.z) * 3.0 + TIME * 0.7) * 0.03;
	
	VERTEX.y += wave_1 + wave_2 + wave_3;
}

void fragment() {
	
	float h = VERTEX.y; 
	float fresnel = pow(
	1.0 - dot(normalize(NORMAL), normalize(VIEW)), 5.0);
	
	vec3 deep = vec3(0.02, 0.18, 0.35);
	vec3 light = vec3(0.12, 0.45, 0.70);
	
	
	NORMAL += vec3(sin(UV.x * 50.0 + TIME) * 0.05, 0.0, cos(UV.y * 50.0 + TIME) * 0.05);
	
	// opacity
	ALPHA = 0.8;
	
	// clarity
	SPECULAR = 1.0;
	
	// ROUGHNESS
	ROUGHNESS = 0.1;
	
	// color
	ALBEDO += fresnel * 0.15;
	ALBEDO = mix(deep, light, clamp(h * 8.0 + 0.5, 0.0, 1.0));
}