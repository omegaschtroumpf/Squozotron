#define characterStepHelper
/// characterStepHelper() 

// Movement, Attacking, Blocking

/*
 *  All script calls after this point go to tabs in characterStepHelper
 */

// get Input
//characterInput();

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
        
        image_angle -= min(abs(angle_diff), global.MAX_ROTATION * (1 - raw_squoze * global.SQUOZE_MAX * .7)) * sign(angle_diff);
    }
    squoze_diff = raw_squoze - squoze_value;

    // unsquoze is faster than squoze
    if (squoze_diff < 0)
        squoze_value += min(abs(squoze_diff), global.SQUOZE_RATE * 4 * (1 - squoze_value * global.SQUOZE_MAX)) * sign(squoze_diff);
    else {
        squoze_adjust = 1.3;
        if (squoze_value < .85) squoze_adjust = .75;
        if (squoze_value < .70) squoze_adjust = 1;
        if (squoze_value < .40) squoze_adjust = 1.25;
        squoze_value += min(squoze_diff, global.SQUOZE_RATE * squoze_adjust * (1 - squoze_value * global.SQUOZE_MAX)) * sign(squoze_diff);
    //    squoze_value += min(squoze_diff, global.SQUOZE_RATE * (1 - squoze_value * global.SQUOZE_MAX)) * sign(squoze_diff);
    }
    if (squoze_value > 1) squoze_value = 1;
    
    
    // use this moment's squoze and enemy positions to determine tracking
    
/// characterTarget 
/*
// Soft-Targeting, TargetID Targeting, and no target image direction
if (!stunned && can_target && !swordID) {
    // if right stick input without cancelling target, point that way as a starting point for soft targeting
    if ((x_axisR != 0 || y_axisR != 0) && !target_cancel_button_pressed) {
        soft_target = true;
        targetID = 0;
        image_angle = point_direction(0, 0, x_axisR, y_axisR);
    }
    if (target_button_pressed) {
        soft_target = true;
        targetID = 0;
    }
    if (target_cancel_button_pressed) {
        soft_target = false;
        targetID = 0;
    }
    if (soft_target) {
        // only do more with soft-target if I let go of the stick
        if (x_axisR == 0 || y_axisR == 0) {
            // clear out angles list in case there's anything there.  we'll populate it here and potentially refer to it when attacking
            ds_list_clear(softTargetAngles);
            // look for enemies and calculate a new image_angle
            // go through the enemies' positions and see if they are in my line of sight
            num = ds_list_size(attitudesList);
            vector_x = 0;
            vector_y = 0;
            see_enemies = false;
            for (i = 0; i < num; i++) {
                character_attitude = ds_list_find_value(attitudesList, i);
                character = character_attitude.characterID;
                attitude = character_attitude.attitude;
                // don't consider 
                if (character == id || attitude > ATTITUDE_ENEMY_MAX) continue; // don't evaluate self
                character_distance = point_distance(x, y, character.x, character.y);
                // only do more calculation with this enemy if he is in range
                if (character_distance <= TARGET_MAX_DISTANCE) {
                    character_direction = point_direction(x, y, character.x, character.y);
                    angle_diff = angle_difference(image_angle, character_direction);
                    if ((angle_diff < TARGET_ANGLE / 2) && angle_diff > (-TARGET_ANGLE / 2)) {
                        // in my line of sight, add to my vector calculations and softTargetAngles list
                        see_enemies = true;
                        ds_list_add(softTargetAngles, character_direction);
                        // distance to enemy will weight the vectoring, the farther away, the lower the influence an enemy has on targeting
                        // character.x - x because I want to point from me at relative 0,0 towards enemy
                        vector_x += (character.x - x) / sqr(sqr(character_distance));
                        vector_y += (character.y - y) / sqr(sqr(character_distance));
                    }
                }
            }
            // if I saw enemies, adjust my angle to face them.  If not, I'll keep my angle from right stick
            if (see_enemies) {
                // now I have a vector for the weighted direction towards enemies.
                image_angle = point_direction(0, 0, vector_x, vector_y);
            }
            else {
                soft_target = false;
            }
        }
    }
    // If I have a specific target, just look at him
    else if (targetID && instance_exists(targetID)) {            
        image_angle = point_direction(x, y, targetID.x,targetID.y);
    }
    // I aint got no target and no right stick input
    else {
        // what the hell direction am I moving in then?
        if (x_axisL != 0 || y_axisL != 0) image_angle = point_direction(0, 0, x_axisL, y_axisL);
    }
}
*/   
    
}

#define characterAttack
/// characterAttack() 

if (!shooting && (global.GUN_TYPE_INDEX == 2 || global.GUN_TYPE_INDEX == 3) && attack_lines[0]) {
    for (i =0; i < 6; i++) {
        instance_destroy(attack_lines[i]);
        attack_lines[i] = 0;
        show_debug_message("attack line " + string(i) + " destroyed");
    }
}

// player attacking
if (shooting && can_shoot && !sprinting) {
    switch(global.GUN_TYPE_INDEX) {
        case global.g_machinegun:
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
            gamepad_set_vibration(deviceID, .2 + raw_squoze * .3, .2 + raw_squoze *.3);
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
            break;
        case global.g_shotgun:

            // make five bullets
            min_angle = image_angle - global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            max_angle = image_angle + global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            bullet_interval = (max_angle - min_angle) / (global.SHOTGUN_BULLETS - 1);
            for (i = 0; i < global.SHOTGUN_BULLETS; i++) {
                bullet = instance_create(x,y,obj_bullet);
                bullet.damage = BULLET_STRENGTH;
                //start bullet at character origin
                bullet.x = x;
                bullet.y = y;
                bullet.image_angle = min_angle + (i * bullet_interval);
                bullet.direction = bullet.image_angle;
                bullet.speed = global.BULLET_SPEED;
            }
            // recoil to squoze_cone and player and controller
            squoze_value -= 3 * global.RECOIL_SQUOZE * (1 - squoze_value * .75);
            if (squoze_value < 0) squoze_value = 0;
            
            // adjust character position based on recoil
            var new_x = x - 3 * dcos(bullet.direction) * global.RECOIL_MOVE;
            var new_y = y + 3 * dsin(bullet.direction) * global.RECOIL_MOVE;
            position_check = characterCheckPosition(new_x, new_y);
            if (position_check == 1) {
                x = new_x;
                y = new_y;
            }
            else if (position_check == 2) x = new_x;
            else if (position_check == 3) y = new_y;
            
            // feedback!
            gamepad_set_vibration(deviceID, .5 + raw_squoze, .5 + raw_squoze);
            alarm[1] = 4;
            can_shoot = false;
            alarm[0] = global.STEPS_BETWEEN_BULLETS * 6;
            reloading = 1;
            
            /*
            // set the alarm for time between 
            can_shoot = false;
            if (bullet_count == BULLETS_BEFORE_PAUSE) {
                alarm[0] = SHOOT_PAUSE_STEPS;
                bullet_count = 0;
                reloading = 1;
            }
            else
                alarm[0] = global.STEPS_BETWEEN_BULLETS * 5;
            */
            break;
        case global.g_flame:
            min_angle = image_angle - global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            max_angle = image_angle + global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            bullet_interval = (max_angle - min_angle) / (global.SHOTGUN_BULLETS - 1);
            for (i = 0; i < global.SHOTGUN_BULLETS; i++) {
                bullet = instance_create(x,y,obj_flame_bullet);
                bullet.shooter = id;
                bullet.damage = BULLET_STRENGTH / 5;
                //start bullet at character origin
                bullet.x = x;
                bullet.y = y;
                bullet.direction = min_angle + (i * bullet_interval);
                bullet.image_angle = bullet.direction - 90;
                bullet.image_xscale = 2;
                bullet.speed = global.BULLET_SPEED / 2;
                bullet.alarm[0] = 10 + squoze_value / global.SQUOZE_MAX * 10;
                bullet.image_index = (random_range(0, 3));
            }
            
            // recoil to squoze_cone and player and controller
            squoze_value -= .3 * global.RECOIL_SQUOZE * (1 - squoze_value * .75);
            if (squoze_value < 0) squoze_value = 0;
            
            // adjust character position based on recoil
            var new_x = x - .3 * dcos(image_angle) * global.RECOIL_MOVE;
            var new_y = y + .3 * dsin(image_angle) * global.RECOIL_MOVE;
            position_check = characterCheckPosition(new_x, new_y);
            if (position_check == 1) {
                x = new_x;
                y = new_y;
            }
            else if (position_check == 2) x = new_x;
            else if (position_check == 3) y = new_y;
            
            // feedback!
            gamepad_set_vibration(deviceID, .2, .1 * raw_squoze + .1 * raw_squoze);
            alarm[1] = 4;    
            alarm[0] = global.STEPS_BETWEEN_BULLETS;
            reloading = 1;        
            break;        case global.g_water:
            min_angle = image_angle - global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            max_angle = image_angle + global.SQUOZE_CONE_SIZE*(1-squoze_value*global.SQUOZE_MAX)
            bullet_interval = (max_angle - min_angle) / (global.SHOTGUN_BULLETS - 1);
            for (i = 0; i < global.SHOTGUN_BULLETS; i++) {
                bullet = instance_create(x,y,obj_water_bullet);
                bullet.shooter = id;
                bullet.damage = BULLET_STRENGTH / 5;
                //start bullet at character origin
                bullet.x = x;
                bullet.y = y;
                bullet.direction = min_angle + (i * bullet_interval);
                bullet.image_angle = bullet.direction - 90;
                bullet.image_xscale = 2;
                bullet.speed = global.BULLET_SPEED / 2;
                bullet.alarm[0] = 10 + squoze_value / global.SQUOZE_MAX * 10;
                bullet.image_index = (random_range(0, 3));
            }
            
            // recoil to squoze_cone and player and controller
            squoze_value -= .3 * global.RECOIL_SQUOZE * (1 - squoze_value * .75);
            if (squoze_value < 0) squoze_value = 0;
            
            // adjust character position based on recoil
            var new_x = x - .3 * dcos(image_angle) * global.RECOIL_MOVE;
            var new_y = y + .3 * dsin(image_angle) * global.RECOIL_MOVE;
            position_check = characterCheckPosition(new_x, new_y);
            if (position_check == 1) {
                x = new_x;
                y = new_y;
            }
            else if (position_check == 2) x = new_x;
            else if (position_check == 3) y = new_y;
            
            // feedback!
            gamepad_set_vibration(deviceID, .2, .1 * raw_squoze + .1 * raw_squoze);
            alarm[1] = 4;    
            alarm[0] = global.STEPS_BETWEEN_BULLETS;
            reloading = 1;        
            break;
        default:
            break;
    }
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
    var new_x = x + x_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX * .5);
    var new_y = y + y_axisL * MOVEMENT_SPEED * (1 - raw_squoze * global.SQUOZE_MAX * .5);
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