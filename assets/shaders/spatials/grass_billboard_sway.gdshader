shader_type spatial;
render_mode depth_prepass_alpha, depth_draw_opaque;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_nearest, repeat_enable;

uniform float wrap : hint_range(-2.0, 2.0) = 0.0;
uniform float steepness : hint_range(1.0, 8.0) = 1.0;
uniform int cuts : hint_range(1, 8) = 3;

// 🌬️ Paramètres du vent
global uniform float wind_strength : hint_range(0.0, 1.0) = 0.3;  // amplitude du vent
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;     // vitesse d'oscillation
uniform vec2 wind_direction = vec2(1.0, 0.3);               // direction du vent (x,z)
uniform float wind_waviness : hint_range(0.0, 10.0) = 4.0;  // fréquence des vagues

varying vec3 instance_origin;

void vertex() {
	instance_origin = MODELVIEW_MATRIX[3].xyz;

	// --- Billboard effect ---
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		INV_VIEW_MATRIX[0],
		INV_VIEW_MATRIX[1],
		INV_VIEW_MATRIX[2],
		MODEL_MATRIX[3]
	);
	NORMAL = vec3(0.0, 1.0, 0.0);

	// Effet de vent
	// On applique une oscillation sur les sommets en fonction du temps, de la hauteur et de la direction du vent.
	float t = TIME * wind_speed;
	
	// Position locale du sommet (avant projection)
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Le vent affecte surtout les parties hautes du quad (y proche du max)
	float sway_factor = clamp(VERTEX.y, 0.0, 1.0);

	// Calcul de la force du vent selon direction et sinusoïde
	float wind_wave = sin(dot(world_pos.xz, wind_direction) * wind_waviness + t);

	// Application de la déformation
	world_pos.x += wind_wave * wind_strength * wind_direction.x * sway_factor;
	world_pos.z += wind_wave * wind_strength * wind_direction.y * sway_factor;

	// Mise à jour du vertex final
	VERTEX = (inverse(MODEL_MATRIX) * vec4(world_pos, 1.0)).xyz;
}

void fragment() {
	vec2 base_uv = UV;
	LIGHT_VERTEX = instance_origin;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
}

void light() {
	float attenuation = ATTENUATION;
	float NdotL = dot(NORMAL, LIGHT);
	float diffuse_amount = NdotL + (attenuation - 1.0) + wrap;
	diffuse_amount *= steepness;
	float cuts_inv = 1.0 / float(cuts);
	float diffuse_stepped = clamp(diffuse_amount + mod(1.0 - diffuse_amount, cuts_inv), 0.0, 1.0);
	vec3 diffuse = ALBEDO.rgb * LIGHT_COLOR / PI;
	diffuse *= diffuse_stepped;
	DIFFUSE_LIGHT += diffuse;
}
