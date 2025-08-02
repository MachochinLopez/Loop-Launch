
#region Mouse actions

if (can_draw) {
    if (mouse_check_button_pressed(mb_left)) {
        is_drawing = true;
        current_line_points = [];
    }
    
    if (is_drawing && mouse_check_button(mb_left)) {
        // Tomar la siguiente posición a pintar
        var new_x = mouse_x;
        var new_y = mouse_y;
        
        // Si no está vacío
        if (array_length(current_line_points) > 0) {
            // Tomar el último punto
            var last = current_line_points[array_length(current_line_points) - 1];
            // Calcular vectores.
            var dx = new_x - last[0];
            var dy = new_y - last[1];
            
            // Calcular distancia
            var dist = point_distance(last[0], last[1], new_x, new_y);
            var temptative_distance = current_distance + dist;
            
            if (temptative_distance > max_distance) {
                var remainder = max_distance - current_distance;
                var dir = point_direction(last[0], last[1], new_x, new_y);
                var clamp_x = last[0] + lengthdir_x(remainder, dir);
                var clamp_y = last[1] + lengthdir_y(remainder, dir);
                                
                if (array_length(current_line_points) > 1) {
                    array_push(current_line_points, [clamp_x, clamp_y]);
                    var new_rail = add_rail_from_points([last[0], last[1]], [new_x, new_y]);
                    array_push(rails, new_rail);
                    array_push(lines, current_line_points);
                }
                current_distance += remainder;
                
                can_draw = false;
                is_drawing = false;
            } else {
                current_distance = temptative_distance;
                
                 // Agregar nuevo punto al array.
                array_push(current_line_points, [new_x, new_y]);
                var new_rail = add_rail_from_points([last[0], last[1]], [new_x, new_y]);
                array_push(rails, new_rail);
            }
        } else {
            // Agregar nuevo punto al array.
            array_push(current_line_points, [new_x, new_y]);
        }
    }
    
    if (mouse_check_button_released(mb_left)) {
        is_drawing = false;
        
        if (array_length(current_line_points) > 1) {
            array_push(lines, current_line_points);
        }
    }
}

show_debug_message({
    rail_count: array_length(rails),
    lines_count: array_length(lines),
    current_points_count: array_length(current_line_points),
    current_distance
})

#endregion

#region Additional controls

if (keyboard_check_pressed(vk_backspace) && array_length(lines) > 0 && !is_drawing) {
    var removed_line_points = array_pop(lines);
    var rails_to_remove = [];
    
    for (var i = 1; i < array_length(removed_line_points); i++) {
        // Remove a rail
        var rail_removed = array_get(rails, array_length(rails) - i);
        // Update distance
        var dist = point_distance(rail_removed.x1, rail_removed.y1, rail_removed.x2, rail_removed.y2);
        current_distance -= dist;
        
        array_push(rails_to_remove, rail_removed);
    }
    
    array_resize(rails, array_length(rails) - array_length(rails_to_remove));
    
    array_foreach(rails_to_remove, function(_element, _index) {
        instance_destroy(_element);
    });
    
   can_draw = true;
}

#endregion