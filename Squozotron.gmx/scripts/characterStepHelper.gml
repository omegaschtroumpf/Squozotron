#define characterStepHelper
/// characterStepHelper() 

// Movement, Attacking, Blocking

/*
 *  All script calls after this point go to tabs in characterStepHelper
 */

// get Input
characterInput();

// adjusting aim/direction
characterTarget();

// attacking/shooting
characterAttack();

// move based on character input    
characterMove();

#define characterTarget
/// characterTarget 

// squoze_value
if (sprinting)
    squoze_value = 0;
else {
    // direction
    if (point_distance(0, 0, x_axisR, y_axisR) > .2) {
    
    raw_angle = point_direction(0, 0, x_axisR, y_axisR);
    angle_diff = angle_difference(image_angle,raw_angle);
    
    image_angle -= min(abs(angle_diff), global.MAX_ROTATION * (1 - raw_squoze * global.SQUOZE_MAX)) * sign(angle_diff);
    }
    squoze_diff = raw_squoze - squoze_value;
    // unsquoze is faster than squoze
    if (squoze_diff < 0)
        squoze_value += min(abs(squoze_diff), global.SQUOZE_RATE * 4 * (1 - squoze_value * global.SQUOZE_MAX)) * sign(squoze_diff);
    else
        squoze_value += min(squoze_diff, global.SQUOZE_RATE * (1 - squoze_value * global.SQUOZE_MAX)) * sign(squoze_diff);
    if (squoze_value > 1) squoze_value = 1;
}

#define characterAttack
/// characterAttack() 

// player attacking
if (shooting && can_shoot && !sprinting) {
    // make a bullet
    bullet = instance_create(x,y,obj_bullet);
    bullet_count++;
    bullet.damage = BULLET_STRENGTH;
    // start bullet at character origin
    bullet.x = x;
    bullet.y = y;
    // send the bullet randomly into the squoze_cone
    min_angle = image_angle - global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
    max_angle = image_angle + global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
    bullet.image_angle = random_range(min_angle,max_angle);
    bullet.direction = bullet.image_angle;
    bullet.speed = global.BULLET_SPEED;
    // recoil to squoze_cone and player and controller
    squoze_value -= global.RECOIL_SQUOZE * (1 - squoze_value * .75);
    if (squoze_value < 0) squoze_value = 0;
    
    // adjust character position based on recoil
    var new_x = x - dcos(bullet.direction) * global.RECOIL_MOVE;
    var new_y = y +dsin(bullet.direction) * global.RECOIL_MOVE;
    position_check = characterCheckPosition(new_x, new_y);
    if (position_check == 1) {
        x = new_x;
        y = new_y;
    }
    else if (position_check == 2) x = new_x;
    else if (position_check == 3) y = new_y;
    
    // feedback!
    gamepad_set_vibration(deviceID, .1 + raw_squoze * .3, .2 + raw_squoze *.3);
    alarm[1] = 2;
    
    
    // set the alarm for time between 
    can_shoot = false;
    if (bullet_count == BULLETS_BEFORE_PAUSE) {
        alarm[0] = SHOOT_PAUSE_STEPS;
        bullet_count = 0;
        reloading = 1;
    }
    else
        alarm[0] = global.STEPS_BETWEEN_BULLETS; 
}

#define characterMove
/// characterMove 

mv_speed = MOVEMENT_SPEED;
if (sprinting) {
    mv_speed *= SPRINT_MOVEMENT_MULTIPLIER;

    // direction
    if (point_distance(0, 0, x_axisL, y_axisL) > .2) {
    
    raw_angle = point_direction(0, 0, x_axisL, y_axisL);
    angle_diff = angle_difference(image_angle,raw_angle);
    image_angle -= min(abs(angle_diff), global.MAX_ROTATION * (1 - raw_squoze * global.SQUOZE_MAX)) * sign(angle_diff);

    }
    // adjust character position based on input
    var new_x = x + dcos(image_angle) * mv_speed;
    var new_y = y - dsin(image_angle)* mv_speed;
    position_check = characterCheckPosition(new_x, new_y);
    if (position_check == 1) {
        x = new_x;
        y = new_y;
    }
    else if (position_check == 2) x = new_x;
    else if (position_check == 3) y = new_y;
    
}
else {
    // adjust character position based on input
    var new_x = x + x_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX * .8);
    var new_y = y + y_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX * .8);
    position_check = characterCheckPosition(new_x, new_y);
    if (position_check == 1) {
        x = new_x;
        y = new_y;
    }
    else if (position_check == 2) x = new_x;
    else if (position_check == 3) y = new_y;
}

#define characterCheckPosition
/// characterCheckPosition(x, y);

// check for collisions to see if we can place character at (x, y)
new_x = argument0;
new_y = argument1;
// get the list of obj_character_solids.  If I'd collide with one that isn't me, don't move forward
num = instance_number(obj_solids);
collision_xy = false;
collision_x = false;
collision_y = false;
for (i = 0; i < num && !(collision_xy && collision_x && collision_y); i++) {
    check_instance = instance_find(obj_solids, i);
    // not checking for a collision with myself.  if match, then go to next i value
    if (check_instance == id) continue;
    if (place_meeting(new_x, new_y, check_instance)) {
        collision_xy = true;
    }
    if (collision_xy) {
        if (place_meeting(new_x, y, check_instance)) {
            collision_x = true;
        }
    }
    if (collision_xy && collision_x) {
        if (place_meeting(x, new_y, check_instance)) {
            collision_y = true;
        }
    }
}
if (!collision_xy) return 1;
if (!collision_x) return 2;
if (!collision_y) return 3;
return 0;