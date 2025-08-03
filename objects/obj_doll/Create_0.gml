enum DollStates {
    Freeze,
    InAir,
    Grinding
}

state = DollStates.Freeze;

// Físicas
hspeed = 0;
vspeed = 0;
doll_gravity = 0.2;
friction = 0.0001;
air_resistance = 0.995;

// Rieles
rails = [];
current_rail = noone;

// Tresholds
rail_detection_distance = 10;
rail_connection_tolerance = 2;
jump_distance_threshold = 3;