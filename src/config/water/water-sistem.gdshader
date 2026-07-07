shader_type spatial;

void vertex() {
	// waves for water
	
	float wave_1 = sin(VERTEX.x * 1.0 + TIME) * 0.01;
	float wave_2 = sin(VERTEX.z * 1.8 + TIME * 0.06) * 0.06;
	float wave_3 = sin((VERTEX.x + VERTEX.z) * 3.0 + TIME * 0.7) * 0.03;
	
	VERTEX.y += wave_1 + wave_2 + wave_3;
}
