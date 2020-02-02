/* [BOX PARAMETERS] */
EXTRA_MARGIN = 14;
SENSOR_WIDTH = 70 + EXTRA_MARGIN;
SENSOR_HEIGHT = 70 + EXTRA_MARGIN;

// Front/Back panel thickness
BASE_THICKNESS = 2; 
// Corner diameter
CORNER_CURVE_DIAMETER = 10;

// Wall thickness
WALL_THICKNESS = 2;
// Front + Back wall, ie. thickness of the box
TOTAL_WALL_HEIGHT = 32;
// Heights of the back part (with SDS011)
WALL_HEIGHT = 18;
FRONT_WALL_HEIGHT = TOTAL_WALL_HEIGHT - WALL_HEIGHT + BASE_THICKNESS - 1; // Fix with BASE_THICKNESS - 1 (initial thickness was 1)


/* [MOUNTING ELEMS] */
HOLE_DIAMETER = 3.0; // initially 2.7
HOLE_HOLDER = 6.65;
SCREW_WALL_THICKNESS = 2;
SCREW_HEAD_DIAMETER = 6.4; // M3 screw
SCREW_HEAD_THICKNESS = 3.07; // M3 screw
SCREW_OFFSET = 0.7;


/* [Cut-outs dimensions] */
CABLE_PORT_HEIGHT = 21;
AIR_INTAKE_DIAMETER = 7.15;
FAN_SIZE = 35;
FAN_HEIGHT = 10;

/* [Wemos dimensions] */
// Wemos PCB thickness
WEMOS_PCB_THICKNESS = 1.62;
// Thickness towards the box, incl. PCB
WEMOS_TOTAL_PCB_THICKNESS = 5;

CHIP_THICKNESS = WEMOS_TOTAL_PCB_THICKNESS - WEMOS_PCB_THICKNESS;
echo("Calculad height of the electronics facing the box (ie. elevation needed): ", CHIP_THICKNESS);
SLOT_HEIGHT = CHIP_THICKNESS + 2.5; //initially + 2
echo("Calculad height of slot: ", SLOT_HEIGHT);

// PCB width
WEMOS_PCB_WIDTH = 64.1;
// PCB height
WEMOS_PCB_HEIGHT = 27.5;

WEMOS_WEMOS_PCB_THICKNESS = WEMOS_PCB_THICKNESS;
WEMOS_SUPPORT_HEIGHT = CHIP_THICKNESS + 1.5;
echo("Calculad height of Wemos support: ", WEMOS_SUPPORT_HEIGHT);
// Distance between PCB and box/cutout
WEMOS_OFFSET = 6;
// Amount of PCB between edge of board and hole
WEMOS_SCREW_OFFSET = 0.09;
// Screen width
WEMOS_SCREEN_WIDTH = 25;
// Screen height
WEMOS_SCREEN_HEIGHT = 14; 
// Screen offset from the bottom (where bottom the box is)
WEMOS_SCREEN_BOTTOM_OFFSET = 7.1;
// Screen distance from edge of PCB facing USB cut-out
WEMOS_SCREEN_SIDE_OFFSET = 8;
// Screw hole diameter (4 screws)
WEMOS_SCREW_HOLE_DIAMETER = 2.82;
// Antenna width
WEMOS_ANTENNA_WIDTH = 19.8;
// Antenna cutout height (allow some space)
WEMOS_ANTENNA_CUTOUT = 2;


/* [DHT22] */
// White sensor width
DHT_WIDTH = 20.8;
// White sensor height
DHT_HEIGHT = 15.8;
// White part total width
DHT_WIDHT_WITH_HEADER = 26;
// White part width
DHT_THICKNESS = 7.8;
// White base plate thickness
DHT_HEADER_THICKNESS = 1.6;
// Increase to enlarge DHT22 hole deeper into the part with dust sensor. Compensates for wall thickness
DHT_BACK_OFFSET = 2;
// Red PCB width
DHT_RED_PCB_WIDTH = 39.8;
// Red PCB height
DHT_RED_PCB_HEIGHT = 23;
// Red PCB thickness
DHT_RED_WEMOS_PCB_THICKNESS = 1.8;
// White part offset from the bottom (2 mounting holes)
DHT_RED_PCB_OFFSET = 12;
// Sensor offset from screw
DHT_OFFSET = 2.5;
// Position against the wall
DHT_Y_OFFSET = 7;

/* [DEBUG] */
//Shows cut objects
OBJ_VISIBLE = false;
// Moves parts of the box apart
EXPLODE = 0;
// Rotates front part (0=mounting position, 180 print)
ROTATE = 0;
// Number of shapes faces
$fn = 128;

//dust_sensor_back();

translate([0, 0, WALL_HEIGHT + EXPLODE])
rotate([0,ROTATE,0])
dust_sensor_front();
  

module air_grill(){
    hole_width = 2;
    hole_separator = 2;
    translate_step = hole_width + hole_separator;
    length = 10;
    
    initial_translation = translate_step;
    translate([length/2, -initial_translation, 0])
    for (n = [0:1:5]){
        translate([0,n*translate_step, 0]) 
        cube([length,hole_width,hole_width], true);    
    };     
}

module air_grill_set(){
    translate([0,-5,7])
    air_grill();
    
    translate([0,-5,3])
    air_grill();
    
    translate([0,-5,-1])
    air_grill();        
    
    translate([0,-5,-5])
    air_grill();         
    
    translate([0,-5,-9])
    air_grill();  

    translate([0,-5,-13])
    air_grill();      
}

module dht22redpcb(){
    color("red")     
    cube([DHT_RED_WEMOS_PCB_THICKNESS,DHT_RED_PCB_WIDTH,DHT_RED_PCB_HEIGHT], true);     
}

module dht22whitepart(){
    union(){
        cube([DHT_THICKNESS,DHT_WIDTH,DHT_HEIGHT], true);    
        
        translate([-(DHT_THICKNESS-DHT_HEADER_THICKNESS)/2,(DHT_WIDTH-DHT_WIDHT_WITH_HEADER)/2,0])
        cube([DHT_HEADER_THICKNESS,DHT_WIDHT_WITH_HEADER,DHT_RED_PCB_HEIGHT], true);    
        
        //translate([0,0,1.5])
        //air_grill_set();
    }    
}

module dht22(){
    union(){
        color("red")
        dht22redpcb();
        
        color("white")
        translate([(DHT_RED_WEMOS_PCB_THICKNESS + DHT_THICKNESS)/2-0.001,(DHT_RED_PCB_WIDTH - DHT_WIDTH)/2-DHT_RED_PCB_OFFSET,0])
        dht22whitepart();       
    }
}

module screw_head(height) {;
    cylinder(height,SCREW_HEAD_DIAMETER/2, SCREW_HEAD_DIAMETER/2, true);      
    translate([0,0,height/2])
    cylinder((SCREW_HEAD_DIAMETER-HOLE_DIAMETER)/2,SCREW_HEAD_DIAMETER/2, HOLE_DIAMETER/2 );      
}

module screw_pole(height, additional_thickness){
    pole_diameter = HOLE_DIAMETER + 2*SCREW_WALL_THICKNESS + additional_thickness;
    cylinder(height,pole_diameter/2, pole_diameter/2, true);              
}

module screw_tunnel(height){
    color("white")    
    cylinder(height,HOLE_DIAMETER/2, HOLE_DIAMETER/2, true);                  
}

module screw_port(height){
    screw_diameter = HOLE_DIAMETER + 2*SCREW_WALL_THICKNESS;
    
    difference(){
        cylinder(height,screw_diameter/2, screw_diameter/2, true);              
        cylinder(height*2,HOLE_DIAMETER/2, HOLE_DIAMETER/2, true);              
    }
}

module screw_heads(){
    screw_depth = 3;
    translate_x = (SENSOR_WIDTH-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;
    translate_y = (SENSOR_HEIGHT-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;    

    union(){      
        color("red")
        translate([translate_x,translate_y,screw_depth/2])
        screw_head(screw_depth);     

        color("red")
        translate([-translate_x,translate_y,screw_depth/2])
        screw_head(screw_depth);             
        
        color("red")
        translate([-translate_x,-translate_y,screw_depth/2])
        screw_head(screw_depth);           
        
        color("red")
        translate([translate_x,-translate_y,screw_depth/2])
        screw_head(screw_depth);    
    }
}

module screw_poles(height, additional_thickness){
    screw_depth = 10;
    translate_x = (SENSOR_WIDTH-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;
    translate_y = (SENSOR_HEIGHT-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;    

    translate([0,0,height/2])
    union(){      
        color("red")
        translate([translate_x,translate_y,0])
        screw_pole(height, additional_thickness);     

        color("red")
        translate([-translate_x,translate_y,0])
        screw_pole(height, additional_thickness);     
        
        color("red")
        translate([-translate_x,-translate_y,0])
        screw_pole(height, additional_thickness);       
        
        color("red")
        translate([translate_x,-translate_y,0])
        screw_pole(height, additional_thickness);     
    }    
}

module dht22_holder(height){
    size = SCREW_HEAD_DIAMETER-1;
    
    translate([size/2,size/2,height/2])
    color("blue")
    cube([size*1.5,size,height], true);      

}

module screw_tunnels(height){
    screw_depth = 10;
    translate_x = (SENSOR_WIDTH-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;
    translate_y = (SENSOR_HEIGHT-SCREW_HEAD_DIAMETER)/2+SCREW_OFFSET;    

    translate([0,0,height/2])
    union(){      
        translate([translate_x,translate_y,0])
        screw_tunnel(height*2);     

        translate([-translate_x,translate_y,0])
        screw_tunnel(height*2);               
        
        translate([-translate_x,-translate_y,0])
        screw_tunnel(height*2);            
        
        translate([translate_x,-translate_y,0])
        screw_tunnel(height*2);     
    }    
}

module dust_sensor_back(dust_sensor) { 
    wemos_wall_dist=3;
    wemos_fix_offset = 0.2;
    difference(){
        union(){
            translate([0, 0, BASE_THICKNESS/2])
            base();
            
            translate([0, 0, WALL_HEIGHT/2])
            base_with_walls(WALL_HEIGHT);        

            screw_poles(WALL_HEIGHT, 0.8);        
            
            //translate([SENSOR_WIDTH/2 - 9, -SENSOR_HEIGHT/2, 0])
            //dht22_holder(WALL_HEIGHT);      
      
    
        //    // WEMOS
        //    translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist,BASE_THICKNESS+WALL_HEIGHT-2])
        //    rotate([0,0,180])    
        //    scale([1,1,4])
        //    wemos_thick_plate();    
            translate([(SENSOR_WIDTH-HOLE_DIAMETER-EXTRA_MARGIN)/2-9.5, (SENSOR_HEIGHT-HOLE_DIAMETER-EXTRA_MARGIN)/2-3.48, BASE_THICKNESS])    
            screw_slot();
            
            // Extra stabilizer
            translate([-(SENSOR_WIDTH-HOLE_DIAMETER-EXTRA_MARGIN)/2+25, (SENSOR_HEIGHT-HOLE_DIAMETER-EXTRA_MARGIN)/2-3.48, BASE_THICKNESS])        
            stabiliser();  
            
            translate([-(SENSOR_WIDTH-HOLE_DIAMETER-EXTRA_MARGIN)/2+2.37, (SENSOR_HEIGHT-HOLE_DIAMETER-EXTRA_MARGIN)/2-22.47, BASE_THICKNESS])    
            screw_slot();    
            
            translate([(SENSOR_WIDTH-HOLE_DIAMETER-EXTRA_MARGIN)/2-9.5, -(SENSOR_HEIGHT-HOLE_DIAMETER-EXTRA_MARGIN)/2+3.48, BASE_THICKNESS])    
            screw_slot();       
            
            // Extra stabilizer
            translate([-(SENSOR_WIDTH-HOLE_DIAMETER-EXTRA_MARGIN)/2+2.37, -(SENSOR_HEIGHT-HOLE_DIAMETER-EXTRA_MARGIN)/2+3.48, BASE_THICKNESS])    
            stabiliser();            
        };  
        
        screw_heads();        
        screw_tunnels(WALL_HEIGHT);
              
//        // CABLES
//        color("red")
//        translate([-SENSOR_WIDTH/2, (SENSOR_HEIGHT-CABLE_PORT_HEIGHT-EXTRA_MARGIN)/2, BASE_THICKNESS+WALL_HEIGHT/2+2]) //Extra +2
//        cube([8,CABLE_PORT_HEIGHT,WALL_HEIGHT], true);         

        // WEMOS - cutout - fix
        translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET-wemos_fix_offset,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist+wemos_fix_offset,BASE_THICKNESS+WALL_HEIGHT-2])
        rotate([0,0,180])    
        scale([1,1,4])   
        wemos_thick_plate();

        // AIR INTAKE      
        color("red")
        translate([SENSOR_WIDTH/2, (SENSOR_HEIGHT-AIR_INTAKE_DIAMETER-EXTRA_MARGIN)/2-15.5, BASE_THICKNESS+AIR_INTAKE_DIAMETER/2+6.2])
        cube([8,AIR_INTAKE_DIAMETER,AIR_INTAKE_DIAMETER], true);  

       // DHT22
        translate([(SENSOR_WIDTH-DHT_RED_WEMOS_PCB_THICKNESS)/2 - DHT_OFFSET, -(SENSOR_HEIGHT-DHT_RED_PCB_WIDTH)/2 + DHT_Y_OFFSET, BASE_THICKNESS + (DHT_RED_PCB_HEIGHT+SLOT_HEIGHT+WEMOS_PCB_THICKNESS)/2+DHT_BACK_OFFSET])
        dht22();       
    }        
//    // DHT22 - positive
    if(OBJ_VISIBLE){
        translate([(SENSOR_WIDTH-DHT_RED_WEMOS_PCB_THICKNESS)/2 - DHT_OFFSET, -(SENSOR_HEIGHT-DHT_RED_PCB_WIDTH)/2 + DHT_Y_OFFSET, BASE_THICKNESS + (DHT_RED_PCB_HEIGHT+SLOT_HEIGHT+WEMOS_PCB_THICKNESS)/2+DHT_BACK_OFFSET])
        dht22();            
    }
}
module wemos_thick_plate() {
    cutout = 12;
    
    WEMOS_PCB_WIDTH = WEMOS_PCB_WIDTH;
    wemos_extra_width = 0.9;
    
    WEMOS_PCB_HEIGHT = WEMOS_PCB_HEIGHT;
    wemos_extra_height = 0.5;
    
    wemos_screw_offset = WEMOS_SCREW_OFFSET;
    wemos_screw_slot_diameter = WEMOS_SCREW_HOLE_DIAMETER;
    
    wemos_screen_width = WEMOS_SCREEN_WIDTH;
    wemos_screen_height = WEMOS_SCREEN_HEIGHT;
    wemos_screen_bottom_offset = WEMOS_SCREEN_BOTTOM_OFFSET;
    
    wemos_usb_to_screen = 2.2;
    
    wemos_usb_width = 9.9;
    wemos_usb_height = 12;
    wemos_usb_extra_width = 4;
    
    screw_extra_margin_height = 21;
    screw_extra_margin_thickness = 2.55;
    
    cube([WEMOS_PCB_WIDTH+wemos_extra_width,WEMOS_PCB_HEIGHT+wemos_extra_height,WEMOS_WEMOS_PCB_THICKNESS], true);
}


module wemos_plate() {
    cutout = 10;
    
    WEMOS_PCB_WIDTH = WEMOS_PCB_WIDTH;
    wemos_extra_width = 0.7;
    
    WEMOS_PCB_HEIGHT = WEMOS_PCB_HEIGHT;
    wemos_extra_height = 0.5;
    
    wemos_screw_offset = WEMOS_SCREW_OFFSET;
    wemos_screw_slot_diameter = WEMOS_SCREW_HOLE_DIAMETER;
    
    wemos_screen_width = WEMOS_SCREEN_WIDTH;
    wemos_screen_height = WEMOS_SCREEN_HEIGHT;
    wemos_screen_bottom_offset = WEMOS_SCREEN_BOTTOM_OFFSET;    wemos_screen_side_offset = WEMOS_SCREEN_SIDE_OFFSET;
    
    wemos_usb_to_screen = 2.2;
    
    wemos_usb_width = 1;
    wemos_usb_height = 12;
    wemos_usb_extra_width = 4;
    wemos_usb_y_offset = 9;

    
    screw_extra_margin_height = 21;
    screw_extra_margin_thickness = 2.55;
    
    wemos_button_hole = 2.3;
    // offset for right side button from middle
    wemos_button_x_offset = 23;
    wemos_button_y_offset = 8.3;
    // distance from right button to left
    wemos_button_gap = 4.5;
    
    translate_x = (WEMOS_PCB_WIDTH-wemos_screw_slot_diameter)/2 - wemos_screw_offset;
    translate_y = (WEMOS_PCB_HEIGHT-wemos_screw_slot_diameter)/2 - wemos_screw_offset;
    
    rotate([0,0,180]) {
    
    difference(){
        cube([WEMOS_PCB_WIDTH+wemos_extra_width,WEMOS_PCB_HEIGHT+wemos_extra_height,WEMOS_WEMOS_PCB_THICKNESS], true);
        
        translate([translate_x, translate_y, 0])
        cylinder(SLOT_HEIGHT,wemos_screw_slot_diameter/2, wemos_screw_slot_diameter/2, true); 
        
        translate([translate_x, -translate_y, 0])
        cylinder(SLOT_HEIGHT,wemos_screw_slot_diameter/2, wemos_screw_slot_diameter/2, true);         
        
        translate([-translate_x, -translate_y, 0])
        cylinder(SLOT_HEIGHT,wemos_screw_slot_diameter/2, wemos_screw_slot_diameter/2, true);                 
        
        translate([-translate_x, translate_y, 0])
        cylinder(SLOT_HEIGHT,wemos_screw_slot_diameter/2, wemos_screw_slot_diameter/2, true);                         
    }
    
    // Screen cut out
    color("red")
    translate([wemos_screen_side_offset, -(WEMOS_PCB_HEIGHT-wemos_screen_height)/2 + wemos_screen_bottom_offset, cutout/2])
    cube([wemos_screen_width,wemos_screen_height,cutout], true);    
    
    // USB port
    color("red")
    translate([(WEMOS_PCB_WIDTH-wemos_usb_width+wemos_usb_extra_width)/2+WEMOS_OFFSET, wemos_usb_y_offset, -BASE_THICKNESS+1])    
    cube([wemos_usb_width+wemos_usb_extra_width,wemos_usb_height,cutout], true);     
    
    // button holes
    /*color("red")
    translate([wemos_button_x_offset, wemos_button_y_offset, 0])  
    cylinder(h=cutout, d=wemos_button_hole);    

    color("red")
    translate([wemos_button_x_offset + wemos_button_gap, wemos_button_y_offset, 0])  
    cylinder(h=cutout, d=wemos_button_hole); */   
    
    // Additional screw cutouts
    color("green")
    translate([-(WEMOS_PCB_WIDTH/2), 0, (WEMOS_WEMOS_PCB_THICKNESS + screw_extra_margin_thickness)/2-0.3])  
    cube([10,WEMOS_ANTENNA_WIDTH,WEMOS_ANTENNA_CUTOUT], true);
}
}

module wemos_single_support() {
    wemos_screw_offset = WEMOS_SCREW_OFFSET;
    wemos_screw_slot_diameter = WEMOS_SCREW_HOLE_DIAMETER;    
    
    support_wall_thickness = 1.5;
    support_diameter = wemos_screw_slot_diameter + 2*support_wall_thickness; 
    
    difference(){
        cylinder(WEMOS_SUPPORT_HEIGHT,support_diameter/2, support_diameter/2, true); 
        cylinder(WEMOS_SUPPORT_HEIGHT*2,wemos_screw_slot_diameter/2, wemos_screw_slot_diameter/2, true);         
    }
}

module wemos_supports(){
    support_height = 4;
    
    WEMOS_PCB_WIDTH = WEMOS_PCB_WIDTH;
    WEMOS_PCB_HEIGHT = WEMOS_PCB_HEIGHT;    
    
    wemos_screw_offset = WEMOS_SCREW_OFFSET;
    wemos_screw_slot_diameter = WEMOS_SCREW_HOLE_DIAMETER;    
    
    translate_x = (WEMOS_PCB_WIDTH-wemos_screw_slot_diameter)/2 - wemos_screw_offset;
    translate_y = (WEMOS_PCB_HEIGHT-wemos_screw_slot_diameter)/2 - wemos_screw_offset;    

    union(){
        translate([translate_x, translate_y, 0])
        wemos_single_support();
        
        translate([translate_x, -translate_y, 0])
        wemos_single_support();
        
        translate([-translate_x, -translate_y, 0])
        wemos_single_support();
        
        translate([-translate_x, translate_y, 0])
        wemos_single_support();
    };     
}

module dust_sensor_front(dust_sensor) {  
    
    wemos_screw_offset = WEMOS_SCREW_OFFSET;
    wemos_screw_slot_diameter = WEMOS_SCREW_HOLE_DIAMETER;    
    
    translate_x = (WEMOS_PCB_WIDTH-wemos_screw_slot_diameter)/2 - wemos_screw_offset;
    translate_y = (WEMOS_PCB_HEIGHT-wemos_screw_slot_diameter)/2 - wemos_screw_offset;
    
    wemos_wall_dist = 3;
    
    dht_support_height = 4;
    dht_support_width = 7.5;
    dht_support_thickness = 6;
    
    difference(){
        union(){
            translate([0, 0, FRONT_WALL_HEIGHT/2])
            base_with_walls(FRONT_WALL_HEIGHT);                  
           
            translate([0, 0, FRONT_WALL_HEIGHT - BASE_THICKNESS/2])
            base();
            
            translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist, FRONT_WALL_HEIGHT - BASE_THICKNESS - WEMOS_SUPPORT_HEIGHT/2])
            wemos_supports();
            
            screw_poles(FRONT_WALL_HEIGHT, 0.8);      

            //dht22 support
            translate([SENSOR_WIDTH/2 - 4 - DHT_OFFSET, -SENSOR_HEIGHT/2 + DHT_Y_OFFSET - 2, 0])
            dht22_holder(FRONT_WALL_HEIGHT);            
            
            //other dht22 support
            color("blue")
            translate([SENSOR_WIDTH/2 - 1 - DHT_OFFSET, -SENSOR_HEIGHT/2 + DHT_Y_OFFSET + 34, FRONT_WALL_HEIGHT - BASE_THICKNESS -1])
            cube([dht_support_width,dht_support_height,dht_support_thickness], true);

        };                 
        
        // DHT22
        translate([(SENSOR_WIDTH-DHT_RED_WEMOS_PCB_THICKNESS)/2 - DHT_OFFSET, -(SENSOR_HEIGHT-DHT_RED_PCB_WIDTH)/2 + DHT_Y_OFFSET, FRONT_WALL_HEIGHT - BASE_THICKNESS - DHT_RED_PCB_HEIGHT/2])
        dht22();        
        
        //Screw tunnels
        translate([0, 0, -FRONT_WALL_HEIGHT/2-BASE_THICKNESS])        
        screw_tunnels(FRONT_WALL_HEIGHT);        
        
        // FAN (on top)
        color("red")
        translate([-SENSOR_WIDTH/2, -(SENSOR_HEIGHT-FAN_SIZE-EXTRA_MARGIN)/2+5, FAN_HEIGHT/2])
        cube([8,FAN_SIZE,FAN_HEIGHT], true);        
        
        // Wemos plate with the screen and USB
        translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist,FRONT_WALL_HEIGHT-BASE_THICKNESS - WEMOS_SUPPORT_HEIGHT - WEMOS_WEMOS_PCB_THICKNESS/2])
        wemos_plate();        

        // Wemos thicker cutout
        translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist,FRONT_WALL_HEIGHT-BASE_THICKNESS - WEMOS_SUPPORT_HEIGHT - WEMOS_WEMOS_PCB_THICKNESS*2-2])    
        scale([1,1,6])
        wemos_thick_plate();         
    }      
    
//    // DHT22 - positive
    if(OBJ_VISIBLE){
        translate([(SENSOR_WIDTH-DHT_RED_WEMOS_PCB_THICKNESS)/2 - DHT_OFFSET, -(SENSOR_HEIGHT-DHT_RED_PCB_WIDTH)/2 + DHT_Y_OFFSET, FRONT_WALL_HEIGHT - BASE_THICKNESS - DHT_RED_PCB_HEIGHT/2])
        dht22();  
    }
               
    if(OBJ_VISIBLE){
        translate([-(SENSOR_WIDTH-WEMOS_PCB_WIDTH)/2+WEMOS_OFFSET,(SENSOR_HEIGHT-WEMOS_PCB_HEIGHT)/2-wemos_wall_dist,FRONT_WALL_HEIGHT-BASE_THICKNESS - WEMOS_SUPPORT_HEIGHT - WEMOS_WEMOS_PCB_THICKNESS/2])    
        //scale([1,1,6])
        wemos_plate();        
    }
}

module rounded_corners(width, height, depth, corner_curve){
    x_translate = width-corner_curve;
    y_translate = height-corner_curve;     
    
    hull(){
            translate([-x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);    
            
            translate([-x_translate/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);

            translate([x_translate/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
            
            translate([x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
    }        
}

module base(){
    x_translate = SENSOR_WIDTH-CORNER_CURVE_DIAMETER;
    y_translate = SENSOR_HEIGHT-CORNER_CURVE_DIAMETER;    
    
    difference(){
         rounded_corners(SENSOR_WIDTH, SENSOR_HEIGHT, BASE_THICKNESS, CORNER_CURVE_DIAMETER);
//         cube([SENSOR_WIDTH-22,SENSOR_HEIGHT-22,BASE_THICKNESS*2], true);            
    }
}

module base_with_walls(wall_height){    
    difference(){
        // OUTSIDE
        rounded_corners(SENSOR_WIDTH+WALL_THICKNESS*2, SENSOR_HEIGHT+WALL_THICKNESS*2, wall_height, CORNER_CURVE_DIAMETER);        
        
        // INSIDE
        rounded_corners(SENSOR_WIDTH, SENSOR_HEIGHT, wall_height*2, CORNER_CURVE_DIAMETER);
    }
}

module stabiliser(){
    translate([0,0,CHIP_THICKNESS/2])
    cylinder(CHIP_THICKNESS,HOLE_HOLDER/2, HOLE_HOLDER/2, true);     
}

module screw_slot(){
    union(){
        translate([0,0,CHIP_THICKNESS/2])
        cylinder(CHIP_THICKNESS,HOLE_HOLDER/2, HOLE_HOLDER/2, true);            
        
        translate([0,0,SLOT_HEIGHT/2])
        cylinder(SLOT_HEIGHT,HOLE_DIAMETER/2, HOLE_DIAMETER/2, true);                    
    }
}
