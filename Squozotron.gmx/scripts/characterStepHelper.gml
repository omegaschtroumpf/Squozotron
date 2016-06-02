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

// direction
if (point_distance(0, 0, x_axisR, y_axisR) > .2) {

raw_angle = point_direction(0, 0, x_axisR, y_axisR);
angle_diff = angle_difference(image_angle,raw_angle);

image_angle -= min(abs(angle_diff), global.MAX_ROTATION * (1 - raw_squoze * global.SQUOZE_MAX)) * sign(angle_diff);
}

// squoze_value
squoze_diff = raw_squoze - squoze_value;
// unsquoze is twice as fast as squoze
if (squoze_diff < 0)
    squoze_value += min(abs(squoze_diff), global.SQUOZE_RATE * 4 * (1 - raw_squoze * global.SQUOZE_MAX * .5 - squoze_value * global.SQUOZE_MAX * .5)) * sign(squoze_diff);
else
    squoze_value += min(squoze_diff, global.SQUOZE_RATE * (1 - raw_squoze * global.SQUOZE_MAX * .5 - squoze_value * global.SQUOZE_MAX * .5)) * sign(squoze_diff);
if (squoze_value > 1) squoze_value = 1;

#define characterAttack
/// characterAttack() 

// player attacking
if (shooting && can_shoot) {
    // make a bullet
    bullet = instance_create(x,y,obj_bullet);
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
    squoze_value -= global.RECOIL_SQUOZE;
    if (squoze_value < 0) squoze_value = 0;
    x -= dcos(bullet.direction) * global.RECOIL_MOVE;
    y += dsin(bullet.direction) * global.RECOIL_MOVE;
    gamepad_set_vibration(deviceID, .2 + raw_squoze * .5, .2 + raw_squoze *.5);
    alarm[1] = 2;
    
    
    // set the alarm for time between 
    can_shoot = false;
    alarm[0] = global.STEPS_BETWEEN_BULLETS;    
}

#define characterMove
/// characterMove 


// adjust character position based on input
var new_x = x + x_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX);
var new_y = y + y_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX);
position_check = characterCheckPosition(new_x, new_y);
if (position_check == 1) {
    x = new_x;
    y = new_y;
}
else if (position_check == 2) x = new_x;
else if (position_check == 3) y = new_y;

#define characterCheckPosition
/// characterCheckPosition(x, y);

// check for collisions to see if we can place character at (x, y)
new_x = argument0;
new_y = argument1;
// get the list of obj_character_solids.  If I'd collide with one that isn't me, don't move forward
num = instance_number(obj_character_solids);
collision_xy = false;
collision_x = false;
collision_y = false;
for (i = 0; i < num && !(collision_xy && collision_x && collision_y); i++) {
    check_instance = instance_find(obj_character_solids, i);
    // not checking for a collision with myself.  if match, then go to next i value
    if (check_instance == id) continue;
    if (!collision_xy) {
        if (place_meeting(new_x, new_y, check_instance)) {
            collision_xy = true;
        }
    }
    if (collision_xy && !collision_x) {
        if (place_meeting(new_x, y, check_instance)) {
            collision_x = true;
        }
    }
    if (collision_xy && collision_x && !collision_y) {
        if (place_meeting(x, new_y, check_instance)) {
            collision_y = true;
        }
    }
}
if (!collision_xy) return 1;
if (!collision_x) return 2;
if (!collision_y) return 3;
return 0;