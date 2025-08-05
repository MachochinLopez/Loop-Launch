var rail = other;

if (state == DollStates.InAir) {
    // Indicar que ya está sobre un riel.
    state = DollStates.Grinding;
    vspeed = 0;
    hspeed = 0;
}

// Calcular punto más cercano del riel a donde colisionó.
var projected_point = project_point_to_rail(x, y, rail.x1, rail.y1, rail.x2, rail.y2);

// Desplazar al monito respecto a la colisión.
x = projected_point.x;
y = projected_point.y;

// TODO: Agregar físicas con ángulos y todo del riel al monito.

