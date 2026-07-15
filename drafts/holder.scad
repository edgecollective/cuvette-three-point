$fn=30;

window_diam = 6;
window_height=15;

cuvette_dim=12.5;
rod_radius=.5;
holder_side=cuvette_dim+rod_radius*2;
holder_depth=40;
wall_width=2;
outer_side=holder_side+wall_width*2;

paddle_width=wall_width;

module holder(){
translate([0,0,holder_depth/2]) {
difference(){
    cube([outer_side,outer_side,holder_depth],center=true);
   
    // inner cavity
    translate([0,0,wall_width]) 
cube([holder_side,holder_side,holder_depth],center=true);
    
    //  optical window
    //translate([outer_side/2,0,0])
rotate([0,90,0])
cylinder(h=holder_side*2,r1=window_diam/2,r2=window_diam/2,center=true);
}



// two points along y on positive x side
translate([cuvette_dim/2+rod_radius,holder_side/3,0])
cylinder(h=holder_depth,r1=rod_radius,r2=rod_radius,center=true);

translate([cuvette_dim/2+rod_radius,-holder_side/3,0])
cylinder(h=holder_depth,r1=rod_radius,r2=rod_radius,center=true);

translate([0,-cuvette_dim/2-rod_radius,0])
cylinder(h=holder_depth,r1=rod_radius,r2=rod_radius,center=true);
}
}

//holder();

/*
rotate(a=10, v=[1,0,0]) {
    translate([outer_side/2,outer_side/2,0])
rotate([0,0,120]) 
    cube([10,3,holder_depth]);  
}
*/

//rotate(a=90,v=[0,0,1]) {
   /* rotate([0,0,90]) {
translate([-holder_side/2,0,0])
cube([paddle_width,holder_side,holder_depth]);
}
*/

difference() {
 
holder();
 
//corner removal    
translate([-holder_side/2,holder_side/2,holder_depth/2])
rotate([0,0,-45]) 
cube([paddle_width,holder_side*2,holder_depth*1.1],center=true);

}
/*
translate([0,0,0]) {
    union() {
        //cube(15, center=true);
        cylinder(h=15,r1=5,r2=5,center=true);
    }
}
*/