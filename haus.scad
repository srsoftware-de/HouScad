// THIS SCRIPT IS FREE SOFTWARE.
// FEEL FREE TO COPY AND REDISTRIBUTE IT.
// NO MILITARY USE
//
// AUTHOR: STEPHAN RICHTER

wall_thickness=5; 

// comment some of the following lines to not render respective parts
front=true; // render front wall
right=true; // render right wall
left=true; // render left wall
back=true; // render back wall
ceilings=true; // render ceilings

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
    width=10; // outer width
    height=15; // outer height
    frame_width=1; 
    elevation=5;      
    if (neg){
      translate([x-width/2+frame_width,-(1+frame_width),elevation+1]) cube([width-2*frame_width,2+frame_width+wall_thickness,height-2]);
    } else {
      translate([x-width/2,-frame_width,elevation]) cube([width,frame_width,height]);
    }    
}

//   ___
//  |___|
//  | | |
//  |_|_| 
module window2(x,neg){
    // adjustables
    width=12; // outer width
    height=17; // outer height
    elevation=5;
    frame_width=1;
    
    // calculated helpers. do noth change these
    uh=height/3-frame_width; // height of upper window part
    lh=2*uh; // height of lower window part
    lw=(width-3*frame_width)/2; // inner width of lower part
    depth=2+frame_width+wall_thickness;
    t=-(1+frame_width);
    
    // drawing
    if (neg){
      translate([x-width/2+frame_width,t,elevation+frame_width])
	cube([lw,depth,lh]);
      translate([x+frame_width/2,t,elevation+frame_width])
	cube([lw,depth,lh]);
      translate([x-width/2+frame_width,t,elevation+lh+2*frame_width])
	cube([width-2*frame_width,depth,uh]);        
    } else {
      translate([x-width/2,-frame_width,elevation]) cube([width,frame_width,height]);
    }    
}

//  .-.
// |___|
// |   |
// |___|
module window3(x,neg){
    width=12; // outer width
    height=22;  // outer height
    elevation=5;
    frame_width=0.5;
    
    // helpers, do not modify
    t=-(1+frame_width);
    df=2*frame_width; // double frame
    wh=width/2;
    depth=2+frame_width+wall_thickness;
    lh=height-wh; // lower height
    if (neg){      
      translate([x,t,elevation+lh]) rotate([270,0,0])
	pie(wh-frame_width,0,180,depth); 
      translate([x+frame_width-wh,t,elevation+frame_width])
	cube([width-df,depth,lh-df]);
    } else {
      translate([x-wh,-frame_width,elevation]){
	cube([width,frame_width,lh]);
	translate([wh,0,lh]) rotate([-90,0,0])
	  cylinder(d=width,h=frame_width);     
        }
    }
}

// DOOR MODULES
// can be added here


//  _
// | |
// | |
module door1(x,neg){
    width=10;
    height=20;
    frame_width=1;
    
    // helper, do not modify
    df=2*frame_width;
    if (neg){
      translate([x-width/2+frame_width,-df,0]) cube([width-df,df,height-frame_width]);
    } else {
      translate([x-width/2,-1,0]) cube([width,frame_width,height]);
    }    
}

//  ___
// | | |
// | | |
module door2(x,neg){
    // adjustables
    width=18; // outer width
    height=20; // outer height
    frame_width=1; 
    
    // helpers, do not modify
    hw=width/2; // half width
    df=frame_width*2; // double frame width
    if (neg){
      translate([x-hw+frame_width,-df,0]) cube([hw-3/2*frame_width,df,height-frame_width]);
      translate([x+frame_width/2,-df,0]) cube([hw-3/2*frame_width,df,height-frame_width]);
    } else {
      translate([x-hw,-frame_width,0]) cube([width,frame_width,height]);
    }    
}

//   __
//  /\/\
//  |-|-|
//  |_|_|
//  
module door3(x,neg){
    // adjustables
    width=18; // outer width
    height=29; // outer heigth
    frame_width=1;

    // helpers, do not modify
    hw=width/2; // half width
    lh=height-hw; // lower part height
    depth=2+frame_width+wall_thickness;
    q=3*frame_width/2;
    lw=(width-3*frame_width)/2;
    t=-(frame_width+1);
    if (neg){
      translate([x,t+depth,lh])
            rotate([90,0,0]){
                translate([-0.5,0,0])
		pie(hw-q,180,60,depth);
                translate([0,0.5,0])
		pie(hw-q,240,60,depth);
                translate([0.5,0,0])
		pie(hw-q,300,60,depth);
            }
            translate([x-hw+frame_width,t,0]) cube([lw,depth,lh-frame_width]);
	    translate([x+frame_width/2,t,0]) cube([lw,depth,lh-frame_width]);

    } else {
      translate([x-hw,-frame_width,0])
	  cube([width,frame_width,lh]);     
      translate([x,0,lh]) rotate([90,0,0])
		cylinder(h=frame_width,d=width);        
    }    
}

module door4(x,neg){
  // adjustables
  width=18;
  h1=18; // lower height
  h2=7; // upper height
  frame_width = 1;
    
  // helpers, do not modify
  hw=width/2; // half width
  df=2*frame_width; // double frame_width
  depth=2+frame_width+wall_thickness;
  t=-(frame_width+1);
  q=3*frame_width/2;
  if (neg){
    difference(){
      translate([x-hw+frame_width,-df,0]) cube([hw-q,df,h1]);
      translate([x-hw+q,-0.5,frame_width]) cube([hw-q-frame_width,2,h1/2-q]);
      translate([x-hw+q,-0.5,(frame_width+h1)/2]) cube([hw-q-frame_width,2,h1/2-q]);
    }
    difference(){
      translate([0.5+x,-df,0]) cube([hw-q,df,h1]);
      translate([1+x,-0.5,frame_width]) cube([hw-q-frame_width,2,h1/2-q]);
      translate([1+x,-0.5,(frame_width+h1)/2]) cube([hw-q-frame_width,2,h1/2-q]);
    }
    translate([x-hw+frame_width,t,h1+frame_width]) cube([width-df,depth,h2-df]);
  } else {
    translate([x-hw,-frame_width,0])
      cube([width,frame_width,h1+h2]);     
  }    
}

//  ____
// |()|0|
// |  | |
module door5(x,neg){
  // adjustables
  width=18;
  heigth=20;
  win_h=6; // window height
  frame_width=1;
  
  // helpers, do not modify
  df=2*frame_width; // double frame
  hw=width/2; // half width
  tw=width/3-frame_width; // third width
  q=3*frame_width/2;
  depth=2+frame_width+wall_thickness;
  t=-(frame_width+1);
  if (neg){
    translate([x-hw+frame_width,-df,0]) cube([2*tw,df,heigth-frame_width]);
    translate([x-hw+2*tw+df,-df,0]) cube([tw,df,heigth-frame_width]);
    
    // windows
    translate([x-hw+q,t,heigth-win_h-q]) cube([2*tw-frame_width,depth,win_h]);
    translate([x-hw+2*tw+frame_width+q,t,heigth-win_h-q]) cube([tw-frame_width,depth,win_h]);    
  } else {
    translate([x-hw,-frame_width,0]) cube([width,frame_width,heigth]);
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
    if (type=="d4"){
      door4(x,sub);
    }
    if (type=="d5"){
      door5(x,sub);
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
                                [length-wall_thickness,wall_thickness],
			[wall_thickness,wall_thickness]  ]);    
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
module story(length,width,height,config){
  if (front){
    wall(length,height,config[0]);
  }
  if (right){
    translate([length,0,0]) rotate([0,00,90])
      wall(width,height,config[1]);
  }
  if (back){
    translate([length,width,0]) rotate([0,0,180])
      wall(length,height,config[2]);
  }
  if (left){
    translate([0,width,0]) rotate([0,00,270])
      wall(width,height,config[3]);
  }
  if (ceilings){
    translate([0,0,height])
      cube([length,width,1]);
  }
}

module ledge_part(length,height){
  d=2;
  hull(){
    linear_extrude(height=0.01) 
    polygon([[d,d],[length-d,d],[length,0],[0,0]]);
    translate([0,0,height]) linear_extrude(height=0.01)
      polygon([[d,d],[length-d,d],[length+height,-height],[-height,-height]]);
  }
}

module ledge(length,width,height=2){
  ledge_part(length,height);
  translate([length,0,0])rotate([0,0,90])
  ledge_part(width,height);
  translate([length,width,0])rotate([0,0,180])    
  ledge_part(length,height);
  translate([0,width,0])rotate([0,0,270])
  ledge_part(width,height);
}

// EXAMPLE: CREATE SIMPLE TWO-STORY BUILDING
module example1(){
    // 1st level:
    // 4 walls with a window/door configuration for each
    story(120,70,30,[["w1","d3","w1","d5","w1"], 
              ["w3","w3","w3","w3"],
              ["w2","w2","w2","w2","w2"],
              ["w2","w2","w2","w2"]]);
    // 2nd level:
    translate([0,0,30]){
            story(100,70,30,[["w3","w3","w3","w3"],
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
    story(120,55,30,[["w2","d1","w2","w2"], ["w2","w2"], ["w2","","","","","","",""], ["w2","w2"]]);

    translate([10,55,0])
        story(90,100,30,[[],["w2","w2","d3","w2","w2"],[],["w2","w2","d3","w2","w2"]]);

    translate([0,155,0])
	story(120,55,30,[["","","","","","","","w2"], ["w2","w2"], ["w2","d1","w2","w2","w2"], ["w2","w2"]]);
    
    // 2nd floor    
    translate([0,0,30])
	story(120,55,30,[["w2","w2","w2","w2"], ["w2","w2"], ["w2","","","","","","",""], ["w2","w2"]]);

    translate([10,55,30])
	story(90,100,30,[[],["w2","w2","w2","w2","w2"],[],["w2","w2","w2","w2","w2"]]);

    translate([0,155,30])
	story(120,55,30,[["","","","","","","","w2"], ["w2","w2"], ["w2","w2","w2","w2","w2"], ["w2","w2"]]);
              
    translate([0,0,60])
        ledge(120,55,2);
    translate([10,55,60])
        ledge(90,100,2);
    translate([0,155,60])
        ledge(120,55,2);
        
    // 3rd floor    
    translate([0,0,62])
	story(120,55,30,[["w3","w3","w3","w3"], ["w3","w3"], ["w3","","","","","","",""], ["w3","w3"]]);

    translate([10,55,62])
	story(90,100,30,[[],["w3","w3","w3","w3","w3"],[],["w3","w3","w3","w3","w3"]]);

    translate([0,155,62])
	story(120,55,30,[["","","","","","","","w3"], ["w3","w3"], ["w3","w3","w3","w3","w3"], ["w3","w3"]]);

    // roof parts
    translate([0,-1,93])
        roof(120,57,35,["r1","r0"]);
    translate([9,30,93])
        roof(92,155,30,["r0","r1"]);
    translate([0,154,93])
        roof(120,57,35,["r1","r0"]); //*/
}

example1();
//example2();



