#define characterStepBeginHelper
/// characterStepBeginHelper()

/*
 *  All script calls after this point go to tabs in characterHelper
 */

// get Input if appropriate
characterInput();

#define characterTarget
/// characterTarget 

  image_angle = point_direction(0, 0, x_axisR, y_axisR);

#define characterStepHelper
/// characterStepHelper() 

// Movement, Attacking, Blocking

/*
 *  All script calls after this point go to tabs in characterHelper
 */

// soft-target, targetID, or input direction
characterTarget();

// attacking
characterAttack();

// move based on character input    
characterMove();

#define characterAttack
/// characterAttack() 

if (object_index == obj_player) {
    // player attacking
    if (shooting && can_shoot) {
        // make a bullet
        bullet = instance_create(x,y,obj_bullet);
        bullet.x = x;
        bullet.y = y;
        // send the bullet randomly into the squoze_cone
        min_angle = image_angle - global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
        max_angle = image_angle + global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
        bullet.image_angle = random_range(min_angle,max_angle);
        bullet.direction = bullet.image_angle;
        bullet.speed = global.BULLET_SPEED;
        // recoil and squoze_cone
        // none just yet
        
        // set the alarm for time between 
        can_shoot = false;
        alarm[0] = global.STEPS_BETWEEN_BULLETS;    
    }
}

#define characterMove
/// characterMove 

if (object_index == obj_player) {
    // adjust character position based on input
    var new_x = x + x_axisL * MOVEMENT_SPEED * (1 - squoze_value *.8);
    var new_y = y + y_axisL * MOVEMENT_SPEED * (1 - squoze_value *.8);
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

#define characterActionHelper
/// characterActionHelper()