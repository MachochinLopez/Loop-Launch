// Gravity

if (state == DollStates.InAir) {
    vspeed += doll_gravity;
    x += hspeed;
    y += vspeed;
}