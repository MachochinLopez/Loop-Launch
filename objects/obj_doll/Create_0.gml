#region States

enum DollStates {
    InAir,
    OnRail
}

state = DollStates.InAir;

#endregion

#region Physics

doll_gravity = 0.05 * delta_time;

#endregion