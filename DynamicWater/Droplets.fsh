void main() {
    
    
    vec4 texture = texture2D(u_texture, v_tex_coord);
    if (texture.a > 0.8) {
        texture = vec4(0.0, 0.0, 1.0, 1.0);
    }
    else{
        texture = vec4(0.0, 0.0, 0.0, 0.0);
    }
    
    gl_FragColor = texture;

}