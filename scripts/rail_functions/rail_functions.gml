function add_rail_from_points(p1, p2) {
    var mid_x = (p1[0] + p2[0]) / 2;
    var mid_y = (p1[1] + p2[1]) / 2;
    
    var inst = instance_create_layer(mid_x, mid_y, "Instances", obj_grinding_rail);
    
    inst.x1 = p1[0];
    inst.y1 = p1[1];
    inst.x2 = p2[0];
    inst.y2 = p2[1];
    
    var angle = point_direction(p1[0], p1[1], p2[0], p2[1]);
    var len = point_distance(p1[0], p1[1], p2[0], p2[1]);
    
    inst.image_angle = angle;
    inst.image_xscale = len / sprite_get_width(inst.sprite_index) + 0.5;
    
    return inst;
}

function get_closest_rail(px, py, rails, rail_detection_distance) {
    var closest_rail = noone;
    var current_min_distance = 9999;
    
    for (var i = 0; i < array_length(rails); i++) {
        var rail = rails[i];
        
        var distance = distance_point_to_segment(px, py, rail);
        
        if (distance < rail_detection_distance && distance < current_min_distance) {
            current_min_distance = distance;
            closest_rail = rail;
        }
    }
    
    return closest_rail;
}

// Calcular ángulo con arctan2
function get_rail_angle(rail) {
    return arctan2(rail.y2 - rail.y1, rail.x2 - rail.x1);
}

// Proyectar en qué parte del riel estará.
function distance_point_to_segment(px, py, rail) {
    var projected_point = project_point_to_rail(px, py, rail);
    return point_distance(px, py, projected_point.x, projected_point.y);
}

/// @description Calcular en qué punto del riel debería proyectarse el doll luego de colisionar.
/// 
/// @param {real} doll_x Posición en x actual del doll.
/// @param {real} doll_y Posición en y actual del doll.
/// @param {real} rail_x1 Posición en y actual del doll.
/// @param {real} rail_y1 Posición en y actual del doll.
/// @param {real} rail_x2 Posición en y actual del doll.
/// @param {real} rail_y2 Posición en y actual del doll.
/// 
/// @return {struct} Objeto con x y y que representa la posición donde debería estar el doll.
function project_point_to_rail(doll_x, doll_y, rail_x1, rail_y1, rail_x2, rail_y2) {
    var dx = doll_x - rail_x1;
    var dy = doll_y - rail_y1;
    
    var rail_x_len = rail_x2 - rail_x1;
    var rail_y_len = rail_y2 - rail_y1;
    
    var dot = dot_product(dx, dy, rail_x_len, rail_y_len);
    var len_sq = power(rail_x_len, 2) + power(rail_y_len, 2);
    
    if (len_sq == 0) {
        return {x: rail_x1, y: rail_y1};
    }
    
    var param = clamp(dot/len_sq, 0, 1);
    
    var closest_x = rail_x1 + param * rail_x_len;
    var closest_y = rail_y1 + param * rail_y_len;
    
    return {x: closest_x, y: closest_y};
}


function distance_to_movement_edge(px, py, rail, movement_direction) {
    if (movement_direction > 0) {
        // Yendo hacia x2,y2
        return point_distance(px, py, rail.x2, rail.y2);
    } else {
        // Yendo hacia x1,y1
        return point_distance(px, py, rail.x1, rail.y1);
    }
}

function get_next_rail_index(_x, _y, _rails, _current_rail, _hspeed, _max_distance) {
    var current_idx = array_get_index(_rails, _current_rail);
    
    // Si no encontramos el riel actual, retornamos noone
    if (current_idx == -1) {
        return noone;
    }
    
    var speed_direction = sign(_hspeed);
    var next_idx = current_idx + speed_direction;
    
    // Verificamos que el siguiente índice esté dentro del rango válido
    if (next_idx >= 0 && next_idx < array_length(_rails)) {
        var next_rail = _rails[next_idx];
        var closest_point = project_point_to_rail(_x, _y, next_rail);
        var distance = point_distance(_x, _y, closest_point.x, closest_point.y);
        
        if (distance <= _max_distance) {
            return next_idx;  // Retornamos el índice, no el objeto
        }
    }
    
    return noone;
}

// Agrega esta función a tus scripts/helpers
function get_closest_rail_directional(_x, _y, _rails, _max_distance, _hspeed, _vspeed, _current_rail) {
    if (_current_rail == noone) return noone;
    
    var closest_rail = noone;
    var min_distance = _max_distance;
    
    // Calcular la dirección del movimiento
    var movement_angle = arctan2(_vspeed, _hspeed);
    
    for (var i = 0; i < array_length(_rails); i++) {
        var rail = _rails[i];

        if (_current_rail == rail) continue;
        
        var closest_point = project_point_to_rail(_x, _y, rail);
        var distance = point_distance(_x, _y, closest_point.x, closest_point.y);
        
        if (distance <= _max_distance) {
            // Calcular el ángulo hacia este riel
            var rail_angle = arctan2(closest_point.y - _y, closest_point.x - _x);
            
            // Calcular la diferencia angular
            var angle_diff = abs(angle_difference(movement_angle, rail_angle));
            
            // Solo considerar rieles que están "adelante" (dentro de 90 grados del movimiento)
            if (angle_diff < 90 || abs(_hspeed) < 0.1) { // Si velocidad muy baja, permitir cualquier dirección
                if (distance < min_distance) {
                    min_distance = distance;
                    closest_rail = rail;
                }
            }
        }
    }
    
    return closest_rail;
}

// ALTERNATIVA MÁS SIMPLE: Excluir el riel anterior (condicionalmente)
function get_closest_rail_excluding_previous(_x, _y, _rails, _max_distance, _previous_rail) {
    var closest_rail = noone;
    var min_distance = _max_distance;
    
    for (var i = 0; i < array_length(_rails); i++) {
        var rail = _rails[i];
        
        // Solo saltar el riel anterior si se especifica
        if (_previous_rail != noone && rail == _previous_rail) continue;
        
        var closest_point = project_point_to_rail(_x, _y, rail);
        var distance = point_distance(_x, _y, closest_point.x, closest_point.y);
        
        if (distance < min_distance) {
            min_distance = distance;
            closest_rail = rail;
        }
    }
    
    return closest_rail;
}
