#region Mover al mono
if (state != DollStates.Freeze) {
    
    // Acceleration??
    
    x += hspeed;
    y += vspeed;
}
#endregion

if (state == DollStates.InAir) {
    vspeed += doll_gravity;
}

// Detectar colisión
    // Cambiar de estado a Grinding
    // Mantener sobre el riel usando x-y previous o algo así para empujarlo hacia o tomar en cuenta el ángulo
    // del riel y generar un vector de desplazamiento acorde justo al detectarla

// Si no detecta colisión
    // Cambiar el estado a InAir

// Si state == Grinding
    // Calcular la aceleración del monito al tocar el riel
        // Calcular la aceleración con el ángulo del riel, la gravedad y la inercia
        // Alterar hspeed y vspeed con esa proyección de la física

        // x += hspeed
        // y += vspeed

if (keyboard_check_pressed(vk_enter)) {
    rails = obj_draw_lines.rails;
    state = DollStates.InAir;
}