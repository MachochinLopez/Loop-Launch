enum DollStates {
    Freeze,
    InAir,
    Grinding
}
state = DollStates.Freeze;

// Físicas mejoradas
hspeed = 0;
vspeed = 0;
acc = 0;
doll_gravity = 0.15;
doll_friction = 0.002;
air_resistance = 0.998;

// Rieles
rails = [];
current_rail = noone;

rail_detection_distance = 20;
rail_connection_tolerance = 4;
jump_distance_threshold = 6;


