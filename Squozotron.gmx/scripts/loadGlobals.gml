// Load global values from globals.ini
ini_open("globals.ini");
global.SQUOZE_MAX = ini_read_real("PLAYER","SQUOZE_MAX",1);
global.SQUOZE_CONE_ORIGIN_ADJUST = ini_read_real("PLAYER","SQUOZE_CONE_ORIGIN_ADJUST",0);
global.SQUOZE_CONE_SIZE = ini_read_real("PLAYER","SQUOZE_CONE_SIZE",0);
global.SQUOZE_CONE_POINT_A_COLOR = ini_read_string("PLAYER","SQUOZE_CONE_POINT_A_COLOR","c_red");
global.SQUOZE_CONE_POINT_B_COLOR = ini_read_string("PLAYER","SQUOZE_CONE_POINT_B_COLOR",c_yellow);
global.SQUOZE_CONE_POINT_C_COLOR = ini_read_string("PLAYER","SQUOZE_CONE_POINT_C_COLOR",c_orange);
global.SQUOZE_CONE_ALPHA = ini_read_real("PLAYER","SQUOZE_CONE_ALPHA",.25);
global.BULLET_SPEED = ini_read_real("PLAYER","BULLET_SPEED",5);
global.STEPS_BETWEEN_BULLETS = ini_read_real("PLAYER","STEPS_BETWEEN_BULLETS",10);
global.MAX_ROTATION = ini_read_real("PLAYER","MAX_ROTATION",10);
global.SQUOZE_RATE = ini_read_real("PLAYER","SQUOZE_RATE",5);
global.RECOIL_MOVE = ini_read_real("PLAYER","RECOIL_MOVE",2);
global.RECOIL_SQUOZE = ini_read_real("PLAYER","RECOIL_SQUOZE",20);

global.BULLET_EFFECT[0] = ef_cloud;
global.BULLET_EFFECT[1] = ef_ellipse;
global.BULLET_EFFECT[2] = ef_explosion;
global.BULLET_EFFECT[3] = ef_firework;
global.BULLET_EFFECT[4] = ef_flare;
global.BULLET_EFFECT[5] = ef_ring;
global.BULLET_EFFECT[6] = ef_smoke;
global.BULLET_EFFECT[7] = ef_spark;
global.BULLET_EFFECT[8] = ef_star;
global.BULLET_EFFECT_INDEX = 4;

global.BULLET_EFFECT_COLOR[0] = c_aqua;
global.BULLET_EFFECT_COLOR[1] = c_black;
global.BULLET_EFFECT_COLOR[2] = c_blue;
global.BULLET_EFFECT_COLOR[3] = c_dkgray;
global.BULLET_EFFECT_COLOR[4] = c_fuchsia;
global.BULLET_EFFECT_COLOR[5] = c_gray;
global.BULLET_EFFECT_COLOR[6] = c_green;
global.BULLET_EFFECT_COLOR[7] = c_lime;
global.BULLET_EFFECT_COLOR[8] = c_ltgray;
global.BULLET_EFFECT_COLOR[9] = c_maroon;
global.BULLET_EFFECT_COLOR[10] = c_navy;
global.BULLET_EFFECT_COLOR[11] = c_orange;
global.BULLET_EFFECT_COLOR[12] = c_purple;
global.BULLET_EFFECT_COLOR[13] = c_red;
global.BULLET_EFFECT_COLOR[14] = c_silver;
global.BULLET_EFFECT_COLOR[15] = c_teal;
global.BULLET_EFFECT_COLOR[16] = c_white;
global.BULLET_EFFECT_COLOR[17] = c_yellow;
global.BULLET_EFFECT_COLOR_INDEX = 0;

global.BULLET_EFFECT_SIZE[0] = 0;
global.BULLET_EFFECT_SIZE[1] = 1;
global.BULLET_EFFECT_SIZE[2] = 2;
global.BULLET_EFFECT_SIZE_INDEX = 0;

global.g_machinegun = 0;
global.g_shotgun = 1;
global.SHOTGUN_BULLETS = 5;
global.g_flame = 2;
global.g_water = 3;
global.GUN_TYPE_INDEX = global.g_water; // set default gun for player

ini_close();
