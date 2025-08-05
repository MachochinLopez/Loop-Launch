draw_self();

if (state == DollStates.Grinding) {
    var rail_check = get_closest_rail_directional(x, y, rails, rail_detection_distance, hspeed, vspeed, current_rail);

    if (rail_check != noone) {
        draw_line_width_color(rail_check.x1, rail_check.y1, rail_check.x2, rail_check.y2, 5, c_red, c_red); 
    }
}
