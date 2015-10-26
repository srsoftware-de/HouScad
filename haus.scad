module fenster(x){
    color([1,0,0]) translate([x-4,0,2]) cube([8,1,12]);
}

module door(x){
    color([0,0,1]) translate([x-4,0,0]) cube([8,1,12]);
}

module wand(length, height, config){
    linear_extrude(height=height)
        polygon(points=[[0,0],[length,0],[length-1,1],[1,1]  ]);    
    size=len(config);
    x=0;
    dx=length/(size+1);
    for (part = config){
        echo (x);
        assign(x=x+dx){
            echo (x);
            if (part=="w"){
                fenster(x);
            }
            if (part=="d"){
                door(x);
            }
        }
    }
}

    
wand(20,10,["w","w","d","w"]);

//fenster();