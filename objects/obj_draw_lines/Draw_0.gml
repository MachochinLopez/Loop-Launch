draw_set_color(c_black);

for (var i = 0; i < array_length(lines); i++) {
    var line = lines[i];
    for (var j = 1; j < array_length(line); j++) {
        var p1 = line[j -1];
        var p2 = line[j];
        
        draw_line_width(p1[0], p1[1], p2[0], p2[1], 5);
    }
}

for (var i = 1; i < array_length(current_line_points); i++) {
    var p1 = current_line_points[i -1];
    var p2 = current_line_points[i];
    

    draw_line_width(p1[0], p1[1], p2[0], p2[1], 5);
}