enum DollStates {
    Freeze,
    InAir,
    Grinding
}
state = DollStates.Freeze;

// Físicas mejoradas
hspeed = 0;
vspeed = 0;
doll_gravity = 0.2;
doll_friction = 0.002; // Reducida de 0.005 a 0.002
air_resistance = 0.998; // Menos resistencia del aire
min_rail_speed = 0.8; // Velocidad mínima garantizada en rieles

// Rieles
rails = [];
current_rail = noone;
previous_rail = noone; // Para evitar rebotes

// Thresholds ajustados
rail_detection_distance = 12; // Aumentado para mejor detección
rail_connection_tolerance = 4;  // Más tolerante
jump_distance_threshold = 6;   // Más generoso
