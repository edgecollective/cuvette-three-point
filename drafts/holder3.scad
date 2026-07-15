// holder3.scad -- holder2_mounted plus a light shroud around each PCB.
//
// Each mounting plate now carries a rectangular wall surrounding the board
// pocket.  The wall rises shroud_lip past the back face of the seated PCB
// (i.e. higher than the standoffs), so the board sits recessed inside a rim
// that blocks stray light from reaching the detector or leaking from the
// emitter.  The plate is widened so the shroud walls land on it.
//
// Print note: upright as modeled, the top segment of each shroud is a ~35 mm
// bridge -- enable supports (or accept a little sag; it's non-optical).
// If you need a cable exit for the pin header, cut a notch in the shroud
// where your header lands.

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

/* ---- PCB mount parameters (as in holder2_mounted.scad) ---- */
pcb_size     = 34;    // square board edge
hole_spacing = 26;    // M3 hole grid, centered on the board
pcb_thick    = 1.6;
m3_pilot     = 2.5;   // self-tapping M3 pilot hole
boss_d       = 7;     // standoff boss diameter
standoff     = 5;     // board-to-plate gap (clearance for components/sensor)
plate_thick  = 3;

/* ---- shroud parameters ---- */
shroud_wall  = 2;     // shroud wall thickness
pcb_clr      = 0.3;   // pocket clearance around the board, per side
shroud_lip   = 1;     // wall rises this far past the back of the seated PCB

shroud_in    = pcb_size + 2*pcb_clr;              // pocket opening
shroud_out   = shroud_in + 2*shroud_wall;
shroud_h     = standoff + pcb_thick + shroud_lip; // wall height above plate
plate_width  = shroud_out;                        // plate carries the walls

// one shrouded mounting plate, drawn on the +x side (x=0 is the holder's
// outer wall face), board centered on the window axis
module pcb_mount() {
    difference() {
        union() {
            // backplate, full holder height so the wings print from the bed
            translate([0, -plate_width/2, 0])
                cube([plate_thick, plate_width, holder_depth]);

            // shroud wall ring around the board pocket (outer box spans the
            // full holder height: grounded at z=0, flush with the top rim)
            difference() {
                translate([plate_thick, -shroud_out/2, 0])
                    cube([shroud_h, shroud_out, holder_depth]);
                translate([plate_thick-1, -shroud_in/2, window_z - shroud_in/2])
                    cube([shroud_h+2, shroud_in, shroud_in]);
            }

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

// ghost PCB seated in its pocket, for fit checking
module pcb_ghost() {
    %translate([standoff + plate_thick, -pcb_size/2, window_z - pcb_size/2])
        cube([pcb_thick, pcb_size, pcb_size]);
}

/* ---------- assembly ---------- */
clip_pocket_depth = 1.5;   // flex clearance recessed into the emitter plate

// same fix as holder2_mounted.scad: the clip tongue's outer side edge is
// flush with the plane the emitter plate sits on, so recess the plate there
module clip_pocket() {
    translate([-outer_side/2 - clip_pocket_depth, 4.5, 12])
        cube([clip_pocket_depth, 4.3, 29]);
}

module holder3() {
    holder2();

    translate([outer_side/2, 0, 0])          // detector side
        pcb_mount();

    difference() {
        translate([-outer_side/2, 0, 0])     // emitter side
            mirror([1,0,0]) pcb_mount();
        clip_pocket();
    }
}

holder3();
//translate([outer_side/2, 0, 0]) pcb_ghost();
//translate([-outer_side/2, 0, 0]) mirror([1,0,0]) pcb_ghost();
