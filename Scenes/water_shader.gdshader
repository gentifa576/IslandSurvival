shader_type canvas_item;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable; 
uniform vec2 scroll1 = vec2(0.05,0.05);
uniform vec2 scroll2 = vec2(-0.05, -0.05);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float wave : hint_range(-1,1) = 0.2;
uniform vec4 tone_color : source_color;

uniform vec4 light_color : source_color;
uniform float light_top: hint_range(0.0,1.0) = 0.2;
uniform float light_bot : hint_range(0.0,1.0) = 0.4;

void fragment() {
	float depth = texture(noise1, UV+scroll1 * TIME * 0.2).x * texture(noise2, UV+scroll2*TIME*0.2).x;
	vec4 screen_value1 = texture(SCREEN_TEXTURE, SCREEN_UV + wave * vec2(depth));
	vec4 screen_value2 = texture(SCREEN_TEXTURE, SCREEN_UV - wave * vec2(depth));
	
	vec4 light = smoothstep(light_top, light_bot, depth) * light_color;
	COLOR = screen_value1 * screen_value2 * tone_color + light;
}
