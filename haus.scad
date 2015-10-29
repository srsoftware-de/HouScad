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

// ROOF MODULES
// roofs are created by intersecting a front profile
// with a sideward profile ("roofshade").
// the different shade options are defined next, followed by a switch
// and an intersection function.

module roofshape1(length,width,height){
    linear_extrude(height=length)
        polygon(points=[[-1,0],[width+1,0],[-1+width/2,height]]);        
}

module roofshape2(length,width,height){
    delta=height/2;
    linear_extrude(height=length)
        polygon(points=[[0,0],[width,0],[width,delta],
                        [width-delta,height],[delta,height],[0,delta]]);
}

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
module roof(length,width,height,elevation,shape){
    intersection(){
        translate([0,0,elevation])
            rotate([90,0,90])
                roofshape(length,width,height,shape[0]);
        translate([0,1+width,elevation])
            rotate([90,0,0])
                roofshape(width+2,length,height,shape[1]);
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

module example2(){
    
    // 1st floor
    story(120,60,[["w3","d1","w3","w3"], 
              ["w3","w3"],
              ["w3","","","","","","",""],
              ["w3","w3"]]);

    translate([10,60,0])
        story(90,100,[[],["w3","w3","d2","w3","w3"],[],["w3","w3","d2","w3","w3"]]);

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
              
    // 3rd floor    
    translate([0,0,60])
        story(120,60,[["w3","w3","w3","w3"], 
              ["w3","w3"],
              ["w3","","","","","","",""],
              ["w3","w3"]]);

    translate([10,60,60])
        story(90,100,[[],["w3","w3","w3","w3","w3"],[],["w3","w3","w3","w3","w3"]]);

    translate([0,160,60])
        story(120,60,[["","","","","","","","w3"], 
              ["w3","w3"],
              ["w3","w3","w3","w3","w3"],
              ["w3","w3"]]);


    roof(120,60,35,91,["r1","r0"]);
    translate([10,30])
        roof(90,160,30,91,["r0","r1"]);
    translate([0,160,0])
        roof(120,60,35,91,["r1","r0"]);
}

example2();
