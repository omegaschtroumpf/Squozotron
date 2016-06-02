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
ini_close();
