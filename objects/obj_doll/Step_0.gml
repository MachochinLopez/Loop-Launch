#region Mover al mono
if (state != DollStates.Freeze) {
    if (array_length(rails) == 0) return;
    
    // Permitir detectar el riel anterior solo si la velocidad es muy baja (permite cambio de dirección)
    var speed_magnitude = sqrt(hspeed * hspeed + vspeed * vspeed);
    var allow_previous_rail = (speed_magnitude < 1.0); // Ajusta este valor según necesites
    
    var exclude_rail = allow_previous_rail ? noone : previous_rail;
    var closest_rail = get_closest_rail_excluding_previous(x, y, rails, rail_detection_distance, exclude_rail);
    
    if (closest_rail != noone) {
        var rail_angle = get_rail_angle(closest_rail);
        var closest_point = project_point_to_rail(x, y, closest_rail);
        
        x = closest_point.x;
        y = closest_point.y;
        
        // Calcular velocidad a lo largo del riel
        var rail_speed = hspeed * cos(rail_angle) + vspeed * sin(rail_angle);
        var gravity_acceleration = doll_gravity * sin(rail_angle);
        rail_speed += gravity_acceleration;
        
        // SOLUCIÓN 1: Reducir fricción o hacerla condicional
        // Solo aplicar fricción si la velocidad es alta
        if (abs(rail_speed) > 1.0) {
            rail_speed *= (1 - doll_friction);
        }
        
        // SOLUCIÓN: Velocidad mínima garantizada en rieles
        // Siempre mantener una velocidad mínima para garantizar el salto
        var min_speed = 0.8; // Ajusta este valor según necesites
        if (abs(rail_speed) < min_speed) {
            var rail_direction = sign(rail_speed);
            if (rail_direction == 0) rail_direction = 1; // Default hacia adelante
            rail_speed = min_speed * rail_direction;
        }
        
        // Convertir de vuelta a hspeed/vspeed
        hspeed = rail_speed * cos(rail_angle);
        vspeed = rail_speed * sin(rail_angle);
        
        previous_rail = current_rail;
        current_rail = closest_rail;
        state = DollStates.Grinding;
    } else {
        // En el aire
        vspeed += doll_gravity;
        hspeed *= air_resistance;
        
        current_rail = noone;
        state = DollStates.InAir;
    }
    
    x += hspeed;
    y += vspeed;
}

// SOLUCIÓN: Detección como plataforma - verificar si hay "suelo" debajo
if (state == DollStates.Grinding) {
    var has_support = false;
    
    // Verificar en múltiples puntos alrededor del sprite (especialmente abajo)
    var check_points = [
        {x: x, y: y + 3},           // Directamente abajo
        {x: x + 5, y: y + 3},       // Abajo-derecha
        {x: x - 5, y: y + 3},       // Abajo-izquierda
        {x: x + hspeed * 2, y: y},  // En dirección del movimiento
        {x: x, y: y}                // Posición actual
    ];
    
    // Si encontramos riel en cualquiera de estos puntos, tenemos soporte
    for (var i = 0; i < array_length(check_points); i++) {
        var rail_check = get_closest_rail(check_points[i].x, check_points[i].y, rails, 8);
        if (rail_check != noone) {
            has_support = true;
            break;
        }
    }
    
    // Si no hay soporte, caerse como una plataforma
    if (!has_support) {
        current_rail = noone;
        state = DollStates.InAir;
    }
}
#endregion

if (keyboard_check_pressed(vk_enter)) {
    rails = obj_draw_lines.rails;
    state = DollStates.InAir;
}