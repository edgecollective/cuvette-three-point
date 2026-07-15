// holder5.scad -- holder4 on a base plate for mounting to a board.
//
// The whole assembly sits on a 3 mm plate that matches the shroud footprint
// in x and extends past the plates in +/-y as two mounting ears, each with
// two clearance holes (default 3.4 mm for M3; set mount_hole_d = 4.2 for #6
// wood screws).  The ears are on +/-y because that's where a screwdriver has
// a clear vertical path -- the shrouds occupy +/-x.
//
// PRINT UPSIDE DOWN, as with holder4 (the clip tongue's pocket is internal
// and must print support-free).  Flipped, the base becomes the top: its ear
// strips overhang, so let the slicer add support under just the ears --
// external and easy to remove.  Everything else is unchanged from holder4.

use <holder4.scad>

$fn = 40;

/* ---- must match holder4.scad ---- */
cuvette_dim  = 12.5;
rod_radius   = 0.5;
holder_side  = cuvette_dim + rod_radius*2;
wall_width   = 6;
outer_side   = holder_side + wall_width*2;
plate_thick  = 3;
pcb_size     = 34;
pcb_thick    = 1.6;
pcb_clr      = 0.3;
shroud_wall  = 2;
standoff     = 5;
shroud_lip   = 1;
shroud_h     = standoff + pcb_thick + shroud_lip;
plate_width  = pcb_size + 2*pcb_clr + 2*shroud_wall;

/* ---- base plate ---- */
base_thick   = 3;
ear_deep     = 9;     // how far the ears extend past the plates in y
base_r       = 4;     // corner radius
mount_hole_d = 3.4;   // M3 clearance; 4.2 for #6 wood screws
base_x       = 2*(outer_side/2 + plate_thick + shroud_h);  // flush w/ shrouds
base_y       = plate_width + 2*ear_deep;
mount_hole_x = 12;                              // holes at (+/-x, +/-y)
mount_hole_y = plate_width/2 + ear_deep/2;

module base_plate() {
    difference() {
        // rounded-corner plate
        hull()
            for (sx=[-1,1], sy=[-1,1])
                translate([sx*(base_x/2 - base_r), sy*(base_y/2 - base_r), 0])
                    cylinder(h=base_thick, r=base_r);

        // four board-mounting holes, out on the ears
        for (sx=[-1,1], sy=[-1,1])
            translate([sx*mount_hole_x, sy*mount_hole_y, -1])
                cylinder(h=base_thick+2, d=mount_hole_d);
    }
}

/* ---------- assembly ---------- */
module holder5() {
    base_plate();
    translate([0,0,base_thick])
        holder4();
}

holder5();
