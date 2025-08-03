#region Mover al mono
if (state != DollStates.Freeze) {
    if (array_length(rails) == 0) return;
    
    var closest_rail = get_closest_rail(x, y, rails, rail_detection_distance);
    
    if (closest_rail != noone) {
        var rail_angle = get_rail_angle(closest_rail);
        var closest_point = project_point_to_rail(x, y, closest_rail);
        
        x = closest_point.x;
        y = closest_point.y;
        
        var current_total_speed = sqrt(hspeed*hspeed + vspeed*vspeed);
        var movement_direction = sign(hspeed * cos(rail_angle) + vspeed * sin(rail_angle));
        
        var gravity_component = doll_gravity * sin(rail_angle);
        
        // PRIMERO aplicar gravedad, DESPUÉS fricción
        current_total_speed += gravity_component * movement_direction;
        current_total_speed *= (1 - friction);
        
        // Reversión en pendientes empinadas
        if (abs(current_total_speed) < 0.5 && gravity_component < 0) {
            current_total_speed = -abs(current_total_speed);
        }
        
        hspeed = current_total_speed * cos(rail_angle);
        vspeed = current_total_speed * sin(rail_angle);
        
        current_rail = closest_rail;
        state = DollStates.Grinding;
    } else {
        vspeed += doll_gravity;
        hspeed *= air_resistance;
        
        current_rail = noone;
        state = DollStates.InAir;
    }
    
    x += hspeed;
    y += vspeed;
}
    
if (state == DollStates.Grinding) {
    var distance_to_end = min_distance_to_edge(x, y, current_rail);
    
    if (distance_to_end < jump_distance_threshold) {
        var connected_rail = get_connected_rail(current_rail, rails, rail_connection_tolerance);
        
        if (connected_rail == noone) {
            current_rail = noone;
            state = DollStates.InAir;
        }
    }
}

#endregion



if (keyboard_check_pressed(vk_enter)) {
    rails = obj_draw_lines.rails;
    state = DollStates.InAir;
}