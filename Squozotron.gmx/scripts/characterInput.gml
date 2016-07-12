#define characterInput
/// playerInput() 

if (gamepad_is_connected(deviceID)) { 
    // Gamepad Input
    
    // left stick input
    x_axisL = gamepad_axis_value(deviceID, gp_axislh); // -1 .. 1
    y_axisL = gamepad_axis_value(deviceID, gp_axislv);
    x_axisR = gamepad_axis_value(deviceID, gp_axisrh);
    y_axisR = gamepad_axis_value(deviceID, gp_axisrv);

    // squoze input - left trigger
    raw_squoze = gamepad_button_value(deviceID, gp_shoulderlb);
    // shoot button - right trigger
    shooting = gamepad_button_check(deviceID, gp_shoulderrb);
    sprinting = gamepad_button_check(deviceID, gp_face1);
    // update image_angle if just beginning to sprint
    if (gamepad_button_check_pressed(deviceID, gp_face1))
        image_angle = point_direction(0, 0, x_axisL, y_axisL);
    
}
else {
    /*
    x_axisL = 0;
    y_axisL = 0;
    // Keyboard Input
    if (keyboard_check(vk_right)) {
        x_axisL = 1;
    }
    if (keyboard_check(vk_left)) {
        x_axisL = -1;
    }
    if (keyboard_check(vk_up)) {
        y_axisL = -1;
    }
    if (keyboard_check(vk_down)) {
        y_axisL = 1;
    }
    

    
    // gesture buttons
    //aggressive_button_pressed = keyboard_check_released(ord('Z'));
    //placating_button_pressed = keyboard_check_released(ord('X'));

    */       
}

#define enemyBasicAI
/// enemyBasicAI() 

// basic AI to create input
shoulder_r_pressed = false;
if (character_focus < random_range(10,60) && alarm[11] < 0) { // focus feels low to me
    // time to start moving away
    alarm[11] = random_range(15,20);  // count down that thing
    random_move = random(180);
}
if (alarm[11] > 0) {
    // i gotta keep moving
    x_axisL = dcos(image_angle - 90 - random_move);
    y_axisL = dsin(image_angle - 90 - random_move) * -1;
    
}
else {
    if (point_distance(x,y,targetID.x,targetID.y) < 240 && (random(100) < 6)) shoulder_r_pressed = true;
    else shoulder_r_pressed = false;

    x_axisL = dcos(image_angle);
    y_axisL = dsin(image_angle) * -1;
}