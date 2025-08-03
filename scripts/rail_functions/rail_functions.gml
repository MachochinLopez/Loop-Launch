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

function project_point_to_rail(px, py, rail) {
    var dx = px - rail.x1;
    var dy = py - rail.y1;
    
    var qx = rail.x2 - rail.x1;
    var qy = rail.y2 - rail.y1;
    
    var dot = dx*qx + dy*qy;
    var len_sq = qx*qx + qy*qy;
    
    if (len_sq == 0) {
        return {x: rail.x1, y: rail.y1};
    }
    
    var param = clamp(dot/len_sq, 0, 1);
    
    var closest_x = rail.x1 + param * qx;
    var closest_y = rail.y1 + param * qy;
    
    return {x: closest_x, y: closest_y};
}


// Devuelve para qué lado masca la iguana.
function min_distance_to_edge(px, py, rail) {
    var dist1 = point_distance(px, py, rail.x1, rail.y1);
    var dist2 = point_distance(px, py, rail.x2, rail.y2);
    
    return min(dist1, dist2);
}

function get_connected_rail(current_rail, rails, rail_connection_tolerance) {
    for (var i = 0; i < array_length(rails); i++) {
        var rail = rails[i];
        
        // Si es el riel donde está grindeando saltárselo.
        if (rail == current_rail) continue;
        
        if (point_distance(current_rail.x1, current_rail.y1, rail.x2, rail.y2) < rail_connection_tolerance || 
            point_distance(current_rail.x2, current_rail.y2, rail.x1, rail.y1) < rail_connection_tolerance) {
            return rail;
        }
    }
    
    return noone;
}