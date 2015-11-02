// THIS SCRIPT IS FREE SOFTWARE.
// FEEL FREE TO COPY AND REDISTRIBUTE IT.
// NO MILITARY USE
//
// AUTHOR: STEPHAN RICHTER


// HELPER FUNCTIONS
module pie(r = 10, a1 = 0, a2 = 30, h = 10){
    rotate([0,0,360-a1])
        linear_extrude(h)
            slice(r,a2);
}

module slice(r = 10, deg = 30) {
    degn = (deg % 360 > 0) ? deg % 360 : deg % 360 + 360;    
    difference() {
        circle(r);
        if (degn > 180) {
            intersection_for(a = [0, 180 - degn]) {
                rotate(a) translate([-r, 0, 0]) square(r * 2);
            }
        } else {
            union() for(a = [0, 180 - degn]) {
                rotate(a) translate([-r, 0, 0]) square(r * 2);
            }
        }
    }
}


// WINDOW MODULES
// can be added here:

//         _
// simple | |
//        |_|
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

//   ___
//  |___|
//  | | |
//  |_|_| 
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

//  .-.
// |___|
// |   |
// |___|
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


//  _
// | |
// | |
module door1(x,neg){
    w=10;
    h=20;
    if (neg){
        translate([1+x-w/2,-2,0]) cube([w-2,2,h-1]);
    } else {
        translate([x-w/2,-1,0]) cube([w,2,h]);
    }    
}

//  ___
// | | |
// | | |
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

module door3(x,neg){
    w=18;
    h=20;
    if (neg){
        translate([x,2,h])
            rotate([90,0,0]){
                translate([-0.5,0,0])
                    pie(w/2-1.5,180,60,4);
                translate([0,0.5,0])
                    pie(w/2-1.5,240,60,4);
                translate([0.5,0,0])
                    pie(w/2-1.5,300,60,4);
            }
        translate([1+x-w/2,-2,0]) cube([w/2-1.5,2,h-1]);
        translate([0.5+x,-2,0]) cube([w/2-1.5,2,h-1]);

    } else {
        translate([x-w/2,-1,0])
            cube([w,2,h]);     
        translate([x,1,h])
                rotate([90,0,0])
                    cylinder(h=2,d=w);        
    }    
}

// ROOF MODULES
// roofs are created by intersecting a front profile
// with a sideward profile ("roofshade").
// the different shade options are defined next, followed by a switch
// and an intersection function.

//   /\ 
module roofshape1(length,width,height){
    linear_extrude(height=length)
        polygon(points=[[0,0],[width,0],[width/2,height]]);        
}

//   __
//  /  \     
module roofshape2(length,width,height){
    delta=height/2;
    linear_extrude(height=length)
        polygon(points=[[0,0],[width,0],[width,delta],
                        [width-delta,height],[delta,height],[0,delta]]);
}

//  .---.
// /     \ 
module roofshape3(length,width,height){
    delta=height/2;
    linear_extrude(height=length)
        polygon(points=[[0,0],[width,0],[width-0.6*delta,delta],
                        [width-2*delta,height],[2*delta,height],[0.6*delta,delta]]);
}


// roof shade switch
module roofshape(length,width,height,type){
    if (type=="r0"){
        cube([width,height,length]);
    }
    if (type=="r1"){
        roofshape1(length,width,height);
    }
    if (type=="r2"){
        roofshape2(length,width,height);
    }
    if (type=="r3"){
        roofshape3(length,width,height);
    }
    
}

// intersection of two roof shades
module roof(length,width,height,shape){
    intersection(){
        rotate([90,0,90])
            roofshape(length,width,height,shape[0]);
        translate([0,width,0])
            rotate([90,0,0])
                roofshape(width,length,height,shape[1]);
    }
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
    if (type=="d3"){
        door3(x,sub);
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

module ledge(length, width,d=2){
    hull(){
        cube([length,width,0.01]);
        translate([-d/2,-d/2,d/2])
            cube([length+d,width+d,d/2]);
    }
}

// EXAMPLE: CREATE SIMPLE TWO-STORY BUILDING
module example1(){
    // 1st level:
    // 4 walls with a window/door configuration for each
    story(120,70,[["w2","d3","w2","w2","w2"], 
              ["w3","w3","w3","w3"],
              ["w2","w2","w2","w2","w2"],
              ["w2","w2","w2","w2"]]);
    // 2nd level:
    translate([0,0,30]){
            story(100,70,[["w3","w3","w3","w3"],
                          ["w1","w1","d2"],
                          ["w1","w1","w1","w1"],
                          ["w1","w1","w1","w1"]]);
    }
    // roof:
    // creates a roof with specified length, width, height and elevation.
    // the combined roof shades are selected by the last parameter
    translate([-1,-1,61])
    roof(102,72,30,["r1","r3"]);
}

// EXAMPLE: CREATE MORE COMPLEX BUILDING
module example2(){
    
    // 1st floor
    story(120,60,[["w3","d1","w3","w3"], 
              ["w3","w3"],
              ["w3","","","","","","",""],
              ["w3","w3"]]);

    translate([10,60,0])
        story(90,100,[[],["w3","w3","d3","w3","w3"],[],["w3","w3","d3","w3","w3"]]);

    translate([0,160,0])
        story(120,60,[["","","","","","","","w3"], 
              ["w3","w3"],
              ["w3","d1","w3","w3","w3"],
              ["w3","w3"]]);
    
    // 2nd floor    
    translate([0,0,30])
        story(120,60,[["w3","w3","w3","w3"], 
              ["w3","w3"],
              ["w3","","","","","","",""],
              ["w3","w3"]]);

    translate([10,60,30])
        story(90,100,[[],["w3","w3","w3","w3","w3"],[],["w3","w3","w3","w3","w3"]]);

    translate([0,160,30])
        story(120,60,[["","","","","","","","w3"], 
              ["w3","w3"],
              ["w3","w3","w3","w3","w3"],
              ["w3","w3"]]);
              
    translate([0,0,60])
    ledge(120,60,2);
    translate([10,60,60])
    ledge(90,100);
    translate([0,160,60])
        ledge(120,60,2);
    // 3rd floor    
    translate([0,0,62])
        story(120,60,[["w3","w3","w3","w3"], 
              ["w3","w3"],
              ["w3","","","","","","",""],
              ["w3","w3"]]);

    translate([10,60,62])
        story(90,100,[[],["w3","w3","w3","w3","w3"],[],["w3","w3","w3","w3","w3"]]);

    translate([0,160,62])
        story(120,60,[["","","","","","","","w3"], 
              ["w3","w3"],
              ["w3","w3","w3","w3","w3"],
              ["w3","w3"]]);

    // roof parts
    translate([0,-1,93])
        roof(120,62,35,["r1","r0"]);
    translate([9,30,93])
        roof(92,160,30,["r0","r1"]);
    translate([0,159,93])
        roof(120,62,35,["r1","r0"]);
}



//example1();
example2();

