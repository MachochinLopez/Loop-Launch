
#region Mouse actions

if (can_draw) {
    if (mouse_check_button_pressed(mb_left)) {
        is_drawing = true;
        current_line_points = [];
    }
    
    if (is_drawing && mouse_check_button(mb_left)) {
        // Tomar la siguiente posición del mouse
        var new_x = mouse_x;
        var new_y = mouse_y;
        
        // Si no está vacío
        if (array_length(current_line_points) > 0) {
            // Tomar el último punto
            var last = current_line_points[array_length(current_line_points) - 1];
            
            // Calcular distancia
            var dist = point_distance(last[0], last[1], new_x, new_y);
            
            // Si la distancia es mayor o igual al minimo que debe medir.
            if (dist >= min_rail_length) {
                var rails_step = floor(dist / min_rail_length);
                
                // Por cada cachito que cabe entre los puntos...
                for (var i = 1; i <= rails_step; i++) {
                    var t = i / rails_step;
                            
                    // Encontrar los puntos medios.
                    var dx = lerp(last[0], new_x, t);
                    var dy = lerp(last[1], new_y, t);
                    
                    // Sacamos la distancia del step.
                    var step_dist = point_distance(last[0], last[1], dx, dy);
                    var tmp_current_distance = current_distance + step_dist;
                    
                    // Si la distancia del step no es mayor a la distancia máxima...
                    if (tmp_current_distance <= max_distance) {
                        // Agregar nuevo punto al array.
                        array_push(current_line_points, [dx, dy]);
                        var new_rail = add_rail_from_points([last[0], last[1]], [dx, dy]);
                        array_push(rails, new_rail);
                        
                        // Actualizar la distancia.
                        current_distance += step_dist;
                        
                        // Convertir este punto en el último del array
                        last[0] = dx;
                        last[1] = dy;
                    } else {
                        // Cerrar la línea.
                        array_push(lines, current_line_points);
                        
                        // Dejar de dibujar.
                        can_draw = false;
                        is_drawing = false;
                    }
                }
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