function create_rails_from_lines(lines) {
    for (var i = 0; i < array_length(lines); i++) {
        var line = lines[i];
        
        for (var j = 1; j < array_length(line); j++) {
            var p1 = line[j - 1];
            var p2 = line[j];
            
            var mid_x = (p1[0] + p2[0]) / 2;
            var mid_y = (p1[1] + p2[1]) / 2;
            
            var inst = instance_create_layer(mid_x, mid_y, "Instances", obj_grinding_rail);
            
            inst.x1 = p1[0];
            inst.y1 = p1[1];
            inst.x2 = p2[0];
            inst.y2 = p2[1];
            
            inst.angle = point_direction(p1[0], p1[1], p2[0], p2[1]);
            inst.len = point_distance(p1[0], p1[1], p2[0], p2[1]);
        }
    }
}