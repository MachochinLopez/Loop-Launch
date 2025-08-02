#region Mouse actions

if (mouse_check_button_pressed(mb_left)) {
    is_drawing = true;
    current_line_points = [];
}

if (is_drawing && mouse_check_button(mb_left)) {
    array_push(current_line_points, [mouse_x, mouse_y]);
}

if (mouse_check_button_released(mb_left)) {
    is_drawing = false;
    
    if (array_length(current_line_points) > 1) {
        array_push(lines, current_line_points);
    }
}

#endregion

#region Create rails

create_rails_from_lines(lines);

#endregion

//if (keyboard_check(vk_backspace)) {
    //points = [];
//}
