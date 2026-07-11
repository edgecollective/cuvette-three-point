// holder2_mounted.scad -- holder2 plus mounting plates for the emitter and
// detector PCBs (34 mm square, M3 holes on a 26 mm grid, per the KiCad board).
//
// One plate on each +/-x face of the holder, centered on the optical window,
// with four standoff bosses so board components (facing the holder) have
// clearance.  M3 screws self-tap into the 2.5 mm pilot holes.
//
// Plates run the full height of the holder so their wings reach the build
// plate -- the whole assembly prints upright without support for the mounts
// (the clip tongue in holder2 still wants a little support in its notch).

use <holder2.scad>

$fn = 40;

/* ---- must match holder2.scad ---- */
window_diam  = 6;
cuvette_dim  = 12.5;
rod_radius   = 0.5;
holder_side  = cuvette_dim + rod_radius*2;
holder_depth = 40;
wall_width   = 2;
outer_side   = holder_side + wall_width*2;
window_z     = holder_depth/2;   // optical window height

/* ---- PCB mount parameters ---- */
pcb_size     = 34;    // square board edge
hole_spacing = 26;    // M3 hole grid, centered on the board
pcb_thick    = 1.6;
m3_pilot     = 2.5;   // self-tapping M3 pilot hole
boss_d       = 7;     // standoff boss diameter
standoff     = 5;     // board-to-plate gap (clearance for components/sensor)
plate_thick  = 3;

// one mounting plate, drawn on the +x side of the origin plane (x=0 is the
// holder's outer wall face), board centered on the window axis
module pcb_mount() {
    difference() {
        union() {
            // backplate, full holder height so the wings print from the bed
            translate([0, -pcb_size/2, 0])
                cube([plate_thick, pcb_size, holder_depth]);

            // four standoff bosses on the 26 mm grid
            for (dy=[-1,1], dz=[-1,1])
                translate([0, dy*hole_spacing/2, window_z + dz*hole_spacing/2])
                    rotate([0,90,0])
                        cylinder(h=plate_thick+standoff, d=boss_d);
        }

        // optical window continues through the plate
        translate([-1, 0, window_z])
            rotate([0,90,0])
                cylinder(h=plate_thick+2, d=window_diam);

        // M3 pilot holes, through plate and bosses
        for (dy=[-1,1], dz=[-1,1])
            translate([-1, dy*hole_spacing/2, window_z + dz*hole_spacing/2])
                rotate([0,90,0])
                    cylinder(h=plate_thick+standoff+2, d=m3_pilot);
    }
}

// ghost PCB in its mounted position, for fit checking
module pcb_ghost() {
    %translate([standoff + plate_thick, -pcb_size/2, window_z - pcb_size/2])
        cube([pcb_thick, pcb_size, pcb_size]);
}

/* ---------- assembly ---------- */
clip_pocket_depth = 1.5;   // flex clearance recessed into the emitter plate

// The clip tongue's outer side edge is trimmed flush to the holder footprint
// (x = -outer_side/2) in holder2.scad -- exactly the plane the emitter plate
// sits on, so without this recess the tongue would print welded to the plate.
// A blind pocket (not a through-slot) keeps the plate light-tight.
module clip_pocket() {
    translate([-outer_side/2 - clip_pocket_depth, 4.5, 12])
        cube([clip_pocket_depth, 4.3, 29]);
}

module holder2_mounted() {
    holder2();

    translate([outer_side/2, 0, 0])          // detector side
        pcb_mount();

    difference() {
        translate([-outer_side/2, 0, 0])     // emitter side
            mirror([1,0,0]) pcb_mount();
        clip_pocket();
    }
}

holder2_mounted();
//translate([outer_side/2, 0, 0]) pcb_ghost();
//translate([-outer_side/2, 0, 0]) mirror([1,0,0]) pcb_ghost();
