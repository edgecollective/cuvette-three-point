// holder8.scad -- holder7 with a shortened chamber and a 15 mm beam height.
//
// New in holder8:
//   - the whole chamber now tops out at chamber_depth=28 (the PCB plates
//     and shrouds keep their full height -- the 34 mm boards require it),
//     so ~22 mm of a 45 mm cuvette stands exposed for grabbing, all round;
//   - the clip shifted down with the chamber: hinge block at z 24..28,
//     tongue hanging to z 6.5, nub at z=10.  The nub sits below the beam
//     (a nub at beam height z=20 would leave only a 4 mm spring arm --
//     far too stiff); pressing 5 mm above the seat still registers the
//     plumb-sitting cuvette against the full-height rods.  Spring force is
//     back to ~2 N with the stock 1.6 mm tongue;
//   - floor_thick 2 -> 5: the beam passes 15 mm above the cuvette's bottom
//     (standard Z-dimension).
//
// From holder7: each shroud can get a slot through one lateral (+/-y)
// side wall for the PCB's bottom-edge pin header.  Install the board
// rotated 90 degrees (the symmetric 26 mm hole grid allows it) so the
// header edge faces the slot; a right-angle header's pins then point out
// sideways -- parallel to the base plate, perpendicular to the cuvette
// axis.  The slot is open toward the shroud rim, so a board with the
// header already soldered drops straight into its pocket.  Toggle per side
// with header_cutaway_det / header_cutaway_emit; both slots sit on the same
// global y side (header_side) so the wiring exits together.
//
// Cuvette holder for a colorimeter, in one self-contained file:
//   - square cavity with three registration rods (two on +x, one on -y) and
//     a 6 mm optical window through the +/-x walls at half height;
//   - a springy corner clip: a flexible tongue anchored at the top, living
//     in a fully INTERNAL light-tight pocket at the -x/+y corner, whose
//     rounded nub presses the cuvette diagonally into the rods -- same
//     seat every insertion, no ambient light path into the chamber;
//   - thick (6 mm) opaque walls, with the four vertical corner edges
//     chamfered so they don't obscure the PCB mounting holes;
//   - shrouded mounting plates on +/-x for the emitter and detector PCBs
//     (34 mm square, M3 holes on a 26 mm grid), boards recessed behind a
//     light-blocking rim, screws self-tap into 2.5 mm pilot holes;
//   - a base plate with two ears (+/-y) for screwing the whole assembly
//     to a board.
//
// PRINT UPSIDE DOWN (plate/shroud tops on the bed): the clip tongue then
// builds base-first from its anchor block and its enclosed pocket needs no
// support (which could never be removed).  Flipped, the chamber rim now
// sits 12 mm above the bed (chamber_depth < holder_depth), so let the
// slicer support the chamber ring and the base plate's ears -- both are
// external and reachable from the open +/-y sides.  The chamber floor
// (~13 mm) and shroud far segment (~35 mm) bridge acceptably.

$fn = 40;

/* ---- cuvette chamber ---- */
window_diam  = 6;
cuvette_dim  = 12.5;
rod_radius   = 0.5;
holder_side  = cuvette_dim + rod_radius*2;
holder_depth = 40;
wall_width   = 6;    // thick: makes the clip pocket internal, walls opaque
floor_thick  = 5;    // cuvette seat height; beam = window_z - floor_thick
                     // = 15 mm above the cuvette bottom
chamber_depth = 35;  // chamber wall height (holder_depth stays the height
                     // of the PCB plates/shrouds)
outer_side   = holder_side + wall_width*2;
window_z     = holder_depth/2;   // optical window height

/* ---- spring clip ---- */
clip_thick   = 1.6;   // tongue thickness
clip_width   = 5;     // tongue width across the corner
clip_gap     = 0.7;   // clearance from tongue face to seated cuvette corner
clip_preload = 0.4;   // nub interference with the seated cuvette corner
clip_root_z  = 24;    // pocket ceiling (chamber_depth-4); tongue anchors
                      // into the solid block above
clip_tip_z   = 6.5;   // height of the tongue's free end
nub_r        = 1.2;
nub_len      = 3;
nub_z        = 10;    // as high as the shortened spring arm allows; below
                      // the beam, but the plumb cuvette registers fine

/* ---- internal clip pocket (diagonal distances from cavity center) ---- */
pocket_front = 8.6;   // front plane; breaks the cavity corner into a slit
pocket_back  = 12.0;  // back plane; >=1.6 mm of skin remains to outer faces
pocket_hw    = 3.7;   // half-width; 1.2 mm side gap around the tongue
pocket_skin  = 1.6;   // opaque skin kept behind the pocket at the corner

// the body's vertical corner edges are chamfered back to this diagonal
// distance: clears the PCB bosses/pilot holes (at y=+/-13) that the full
// square corners would obscure, while keeping the clip pocket sealed
corner_flat_d = pocket_back + pocket_skin;

d_cuvette = cuvette_dim/2 * sqrt(2);   // seated cuvette corner edge (~8.84)
d_face    = d_cuvette + clip_gap;      // inner face of the tongue
d_nub_tip = d_cuvette - clip_preload;  // nub tip, past the cuvette corner

/* ---- PCB mounts ---- */
pcb_size     = 34;
hole_spacing = 26;
pcb_thick    = 1.6;
m3_pilot     = 3.2;
boss_d       = 7;
standoff     = 4;
plate_thick  = 3;
shroud_wall  = 2;
pcb_clr      = 0.3;
shroud_lip   = 1;
shroud_in    = pcb_size + 2*pcb_clr;
shroud_out   = shroud_in + 2*shroud_wall;
shroud_h     = standoff + pcb_thick + shroud_lip;
plate_width  = shroud_out;

/* ---- optional header cutaways ---- */
header_cutaway_det  = false;   // slot in the detector-side shroud
header_cutaway_emit = false;   // slot in the emitter-side shroud
header_side  = 1;     // +1: slot on the +y side, -1: on the -y side
header_len   = 22;    // slot length along z (7x2.54 header body + margin)
header_clear = 3;     // slot floor this far below the board's inner face,
                      // clearing a right-angle header body on that side

/* ---- base plate ---- */
base_thick   = 3;
ear_deep     = 9;     // how far the ears extend past the plates in y
base_r       = 4;     // corner radius
mount_hole_d = 3.4;   // M3 clearance; 4.2 for #6 wood screws
base_x       = 2*(outer_side/2 + plate_thick + shroud_h);  // flush w/ shrouds
base_y       = plate_width + 2*ear_deep;
mount_hole_x = 12;                              // holes at (+/-x, +/-y)
mount_hole_y = plate_width/2 + ear_deep/2;

// place children at diagonal distance d up the -x/+y corner;
// local +x points back toward the cavity center, local y along the corner
module at_corner(d=0, z=0) {
    translate([-d/sqrt(2), d/sqrt(2), z])
        rotate([0,0,-45])
            children();
}

/* ---------- chamber body (chamber_depth tall) ---------- */
module body() {
    translate([0,0,chamber_depth/2]) {
        difference() {
            cube([outer_side, outer_side, chamber_depth], center=true);

            // inner cavity
            translate([0,0,floor_thick])
                cube([holder_side, holder_side, chamber_depth], center=true);

            // optical window
            translate([0,0,window_z - chamber_depth/2])
                rotate([0,90,0])
                    cylinder(h=outer_side+2, r=window_diam/2, center=true);

            // chamfer all four vertical corner edges (see corner_flat_d)
            for (a=[0:90:270])
                rotate([0,0,a])
                    translate([corner_flat_d/sqrt(2), corner_flat_d/sqrt(2), 0])
                        rotate([0,0,45])
                            translate([0, -outer_side, -(chamber_depth+2)/2])
                                cube([outer_side, outer_side*2, chamber_depth+2]);
        }

        // two registration rods along y on the +x side
        translate([cuvette_dim/2+rod_radius, holder_side/3, 0])
            cylinder(h=chamber_depth, r=rod_radius, center=true);
        translate([cuvette_dim/2+rod_radius, -holder_side/3, 0])
            cylinder(h=chamber_depth, r=rod_radius, center=true);

        // one registration rod on the -y side
        translate([0, -cuvette_dim/2-rod_radius, 0])
            cylinder(h=chamber_depth, r=rod_radius, center=true);
    }
}

/* ---------- internal clip pocket ---------- */
// enclosed on all sides: floor below, solid block above clip_root_z, and
// >=1.6 mm of wall behind and beside it; opens only via the corner slit
module clip_pocket() {
    at_corner(pocket_front, floor_thick)
        translate([-(pocket_back-pocket_front), -pocket_hw, 0])
            cube([pocket_back-pocket_front, pocket_hw*2,
                  clip_root_z - floor_thick]);
}

/* ---------- the springy tongue with its nub ---------- */
module tongue() {
    // flat 45-degree tongue, fusing into the solid material above the pocket
    at_corner(d_face)
        translate([-clip_thick, -clip_width/2, clip_tip_z])
            cube([clip_thick, clip_width, chamber_depth - clip_tip_z]);

    // rounded vertical nub ridge; tip sits clip_preload past the seated
    // cuvette corner, round profile ramps for insertion and removal
    at_corner(d_nub_tip + nub_r)
        hull() {
            translate([0, 0, nub_z - nub_len/2]) sphere(r=nub_r);
            translate([0, 0, nub_z + nub_len/2]) sphere(r=nub_r);
        }
}

/* ---------- shrouded PCB mounting plate ---------- */
module pcb_mount(header_cut=false) {
    difference() {
        union() {
            // backplate, full holder height
            translate([0, -plate_width/2, 0])
                cube([plate_thick, plate_width, holder_depth]);

            // shroud wall ring, grounded at z=0 and flush with the top rim
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

        // header cutaway: slot through one lateral shroud wall, open to the
        // rim so the board drops in with its right-angle header attached
        if (header_cut)
            translate([plate_thick + standoff - header_clear,
                       header_side*(shroud_in + shroud_wall)/2 - (shroud_wall+2)/2,
                       window_z - header_len/2])
                cube([shroud_h - standoff + header_clear + 2,
                      shroud_wall + 2, header_len]);
    }
}

// ghost PCB seated in its pocket, for fit checking
module pcb_ghost() {
    translate([standoff + plate_thick, -pcb_size/2, window_z - pcb_size/2])
         color("Green", 0.4) {
             cube([pcb_thick, pcb_size, pcb_size]);
         }
}

// ghost cuvette in its seated position
module cuvette() {
    
    translate([-cuvette_dim/2, -cuvette_dim/2, floor_thick])
        color("Blue", 0.4) {
        cube([cuvette_dim, cuvette_dim, holder_depth]);
        }
}

/* ---------- base plate ---------- */
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
// chamber + clip + both shrouded PCB mounts (holder4 in the file series)
module holder_assembly() {
    difference() {
        body();
        clip_pocket();
    }
    tongue();

    // mirror([1,0,0]) flips x only, so header_side puts both slots on the
    // same global y side
    translate([outer_side/2, 0, 0])          // detector side
        pcb_mount(header_cut=header_cutaway_det);
    translate([-outer_side/2, 0, 0])         // emitter side
        mirror([1,0,0]) pcb_mount(header_cut=header_cutaway_emit);
}

module holder8() {
    base_plate();
    translate([0,0,base_thick])
        holder_assembly();
}

holder8();
translate([0,0,base_thick]) cuvette();
translate([outer_side/2, 0, base_thick]) pcb_ghost();
translate([-outer_side/2, 0, base_thick]) mirror([1,0,0]) pcb_ghost();
