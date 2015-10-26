// THIS SCRIPT IS FREE SOFTWARE.
// FEEL FREE TO COPY AND REDISTRIBUTE IT.
// NO MILITARY USE
//
// AUTHOR: STEPHAN RICHTER


// WINDOW MODULES
// can be added here:

module window1(x,neg){
    w=10;
    h=15;
    o=5;      
    if (neg){
        translate([1+x-w/2,-2,o+1]) cube([w-2,4,h-2]);
    } else {
        translate([x-w/2,-1,o]) cube([w,2,h]);
    }    
}

module window2(x,neg){
    w=12;
    h=15;
    o=5;      
    if (neg){
        translate([1+x-w/2,-2,o+1]) cube([w/2-1.5,4,2*h/3-0.5]);
        translate([0.5+x,-2,o+1]) cube([w/2-1.5,4,2*h/3-0.5]);
        translate([1+x-w/2,-2,o+2*h/3+1.5]) cube([w-2,4,h/3-0.5]);        
    } else {
        translate([x-w/2,-1,o]) cube([w,2,h+2]);
    }    
}

module window3(x,neg){
    w=12;
    h=15;
    o=5; 
    if (neg){
        translate([x-w/2+1,-2,5]){
            cube([w-2,4,h]);
            difference(){
                translate([w/2-1,0,h])
                    rotate([-90,0,0])
                        cylinder(d=w-2,h=4);            
                cube([w-2,4,h+1]);                
                
            }
        }
    } else {
        translate([x-w/2,-1,4]){
            cube([w,2,h+1]);
            translate([w/2,0,h+1])
                rotate([-90,0,0])
                    cylinder(d=w,h=2);     
        }
    }
}

// DOOR MODULES
// can be added here

module door1(x,neg){
    w=10;
    h=20;
    if (neg){
        translate([1+x-w/2,-2,0]) cube([w-2,2,h-1]);
    } else {
        translate([x-w/2,-1,0]) cube([w,2,h]);
    }    
}

module door2(x,neg){
    w=18;
    h=20;
    if (neg){
        translate([1+x-w/2,-2,0]) cube([w/2-1.5,2,h-1]);
        translate([0.5+x,-2,0]) cube([w/2-1.5,2,h-1]);
    } else {
        translate([x-w/2,-1,0]) cube([w,2,h]);
    }    
}

module roof1(length, width, elevation){    
    translate([0,-1,elevation])
        rotate([90,0,90])
            linear_extrude(height=length)
                polygon(points=[[0,0],[width+2,0],[1+width/2,width/3]]);        
}

// PART SWITCH
// register doors and windows here:

module part(x,type,sub){
    if (type=="w1"){
        window1(x,sub);
    }
    if (type=="w2"){
        window2(x,sub);
    }
    if (type=="w3"){
        window3(x,sub);
    }
 
    if (type=="d1"){
        door1(x,sub);
    }
    if (type=="d2"){
        door2(x,sub);
    }
}

// CREATE A WALL.
// config is a vector of parts, see example below

module wall(length, height, config){
    size=len(config);
    x=0;
    dx=length/(size+1);

    difference(){
        union(){
            linear_extrude(height=height)
                polygon(points=[[0,0],
                                [length,0],
                                [length-1,1],
                                [1,1]  ]);    
            for (i=[1:1:1+size]){
                part(i*dx,config[i-1]);
            }
        }
        for (i=[1:1:1+size]){
            part(i*dx,config[i-1],true);
        }
    }
}

// CREATE A STORY/LEVEL/FLOOR
// see example below
module story(length,width,config){
    wall(length,30,config[0]);
    translate([length,0,0]) 
        rotate([0,00,90])
            wall(width,30,config[1]);
    translate([length,width,0])
        rotate([0,0,180])
            wall(length,30,config[2]);
    translate([0,width,0])  
        rotate([0,00,270])
            wall(width,30,config[3]);
    translate([0,0,30])
        cube([length,width,1]);
}


// EXAMPLE: CREATE TWO-Story Building
// 1st level:
// 4 walls with a window/door configuration for each
story(120,70,[["w2","d1","w2","w2","w2"], 
              ["w3","w3","w3","w3"],
              ["w2","w2","w2","w2","w2"],
              ["w2","w2","w2","w2"]]);
// 2nd level:
translate([0,0,30])
    story(100,70,[["w3","w3","w3","w3"],
            ["w1","w1","d2"],
            ["w1","w1","w1","w1"],
            ["w1","w1","w1","w1"]]);

// roof
roof1(100,70,61);

