// holder15.scad -- holder14 with a much wider flat pressing face.
//
// New in holder15 (from print testing of holder14): slight bi-stability
// remained when rotating the cuvette.  Cause: the 3 mm block was NARROWER
// than the 3.8 mm corner slit, so the cuvette corner rode on the block's
// printed (rounded) edges.  The face is now nub_w = 7 mm wide -- the slit
// exposes only its dead-flat central +/-1.9 mm, with the print-rounded
// edges far outside any possible contact.  To house the wide block, the
// pocket gains a WIDE FRONT ZONE (shallow, d pocket_front..nub_zone_back):
// being close to the cavity, its corners still keep ~2 mm of opaque skin,
// which widening the whole pocket would not (the deep pocket stays
// narrow).  The tongue stays 5 mm wide; the block overhangs it 1 mm per
// side, and its wings tuck into the deep zone at extreme deflection, so
// the travel hard-stop stays ~1.45 mm -- >2x the 0.6 preload.  Rest of
// the design is unchanged.
//
// From holder14: the block nub's lower end starts higher up the spring
// (nub_z_lo 12 -> 15; the flat face still spans the optical path at z=20),
// and its underside is wedged at a steeper 1.5:1 (~56 degrees from
// horizontal, vs 45 before) so it prints right side up with no droopy
// overhang under the block.
//
// From holder13: placing nuts on the inner side of the PCB plate holes
// was fiddly in the tight plate-to-chamber gap.  Each of the eight holes
// now has a HEX inset (nut_af across flats, nut_inset_depth deep) in the
// plate's inner face: press an M3 nut in once and it stays captive --
// nothing to hold while driving the screw from the board side.  The hex
// sits flat-side-up so its roof prints as a ~6 mm bridge.  Wall width and
// everything else are unchanged from holder11.
//
// From holder11 (print testing of holder10): with the rounded nub,
// the cuvette had TWO stable positions -- its corner could wedge into a
// valley on either side of the sphere's apex.  The nub is now a flat block
// whose pressing face is tangent to the cuvette corner (perpendicular to
// the corner diagonal), so there are no valleys: the corner meets a flat
// and slides to wherever the rods dictate.  Details:
//   - flat face nub_w wide (3 mm, clearing the widened slit by 0.4/side),
//     spanning z nub_z_lo..nub_z_hi so it presses with a vertical LINE
//     contact across the optical-path height;
//   - a 45-degree wedge slide on top, running from the tongue face down to
//     the block face, cams the tongue open as the cuvette first enters;
//   - a matching 45-degree chamfer underneath so the block prints cleanly
//     right side up;
//   - slit front widened (pocket_front 8.3 -> 8.0) for the wider block.
// Preload, spring, rods etc. unchanged from holder10.
//
// From holder10 (print testing of holder9 -- cuvette sat too loose):
//   - the tongue is flipped: hinged at the BOTTOM (root fused into the
//     chamber floor), free end at the top.  Printed right side up it builds
//     base-first with no support in its sealed pocket, so the whole part now
//     prints in its natural orientation: base plate and ears on the bed,
//     nothing to support.  The clip anchor tower is gone (no longer needed);
//     the spring arm is the same length as before (root z=5, nub z=20);
//   - grip firmed up: nub radius 1.2 -> 2.0 (a fatter, more surely-printed
//     bump with a gentler insertion ramp) and clip_preload 0.4 -> 0.6, so
//     the constrained square is ~12.08 mm -- a 12.5 mm cuvette deflects the
//     spring 0.6 mm and is pressed into the rods at ~2 N.  The pocket got
//     correspondingly deeper (pocket_back 12.6, slit front 8.3) to keep
//     ~2x spring-back travel and clearance around the fatter nub;
//   - rod_radius 0.5 -> 0.75: sturdier printed registration rods (their
//     contact surfaces stay exactly on the cuvette envelope).
//
// From holder9: set view_mode (just below) to choose how the model is
// shown:
//   "solid"   -- the real, printable part (default; use this for STL export)
//   "xray"    -- the tongue and nub drawn solid, everything else as a
//                transparent ghost, so the clip is visible in place
//   "cutaway" -- the chamber wall around the clip corner is carved away,
//                leaving the whole tongue (crimson) standing exposed in
//                the opening
// The xray ghosts use the % modifier, so they vanish on render (F6) --
// preview with F5.  The cutaway DOES render/export, handy for a demo print.
//
// From holder8:
//   - the chamber tops out at chamber_depth (the PCB plates and shrouds
//     keep their full height -- the 34 mm boards require it), so most of a
//     45 mm cuvette stands exposed for grabbing;
//   - floor_thick 5: the beam passes 15 mm above the cuvette's bottom
//     (standard Z-dimension); the nub presses at the same height.
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
//   - a springy corner clip: a flexible tongue hinged at the bottom, living
//     in a fully INTERNAL light-tight pocket at the -x/+y corner, whose
//     flat-faced block nub presses the cuvette diagonally into the rods --
//     same seat every insertion, no ambient light path into the chamber;
//   - thick (6 mm) opaque walls, with the four vertical corner edges
//     chamfered so they don't obscure the PCB mounting holes;
//   - shrouded mounting plates on +/-x for the emitter and detector PCBs
//     (34 mm square, M3 holes on a 26 mm grid), boards recessed behind a
//     light-blocking rim, screws self-tap into 2.5 mm pilot holes;
//   - a base plate with two ears (+/-y) for screwing the whole assembly
//     to a board.
//
// PRINT RIGHT SIDE UP (base plate on the bed).  The bottom-hinged tongue
// builds base-first from the chamber floor, its sealed pocket needs no
// support (the pocket ceiling is a ~4 mm internal bridge), and everything
// else rises from the base -- no support material anywhere.  The only real
// bridge is each shroud's top segment (~35 mm), which prints acceptably.

$fn = 40;

view_mode   = "solid"; // "solid" | "xray" | "cutaway"
show_ghosts = false;    // translucent cuvette + PCBs for fit checking

/* ---- cuvette chamber ---- */
window_diam  = 6;
cuvette_dim  = 12.5;
rod_radius   = 0.75;  // sturdier printed rods; contact stays on the envelope
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
clip_preload = 0.6;   // nub interference with the seated cuvette corner
clip_tip_z   = 25;    // height of the tongue's FREE END (top; hinge is at
                      // the bottom, fused into the chamber floor at z=5)
nub_w        = 7.0;   // width of the flat block face across the corner
                      // (much wider than the slit, so contact happens only
                      // on its dead-flat center, never its printed edges)
nub_z_lo     = 15;    // bottom of the flat pressing face
nub_z_hi     = 21;    // top of the flat face; 45-degree wedge slide above
                      // (the face spans the optical path at window_z=20)

/* ---- internal clip pocket (diagonal distances from cavity center) ---- */
pocket_front = 8.0;   // front plane; breaks the cavity corner into a slit
                      // (wide enough that the block nub clears its edges)
pocket_back  = 12.6;  // back plane; deep enough for ~2x preload travel
pocket_hw    = 3.7;   // half-width; 1.2 mm side gap around the tongue
pocket_skin  = 1.6;   // opaque skin kept behind the pocket at the corner
pocket_top   = 27;    // pocket ceiling; solid corner above seals it
nub_zone_back = 10.8; // back plane of the pocket's wide front zone, which
                      // houses the wide block through its travel; shallow,
                      // so its corners keep ~2 mm of opaque skin

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
m3_pilot     = 3.2;   // M3 clearance; screws thread into the trapped nuts
nut_af       = 5.8;   // nut inset across-flats (M3 nut 5.5 + fit clearance)
nut_inset_depth = 2.6; // pocket depth in the plate's inner face (nut is 2.4)
boss_d       = 7;
standoff     = 2;
plate_thick  = 3;
shroud_wall  = 2;
pcb_clr      = 0.3;
shroud_lip   = 0;
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
    difference() {
        // chamber walls
        translate([-outer_side/2, -outer_side/2, 0])
            cube([outer_side, outer_side, chamber_depth]);

        // inner cavity
        translate([-holder_side/2, -holder_side/2, floor_thick])
            cube([holder_side, holder_side, holder_depth]);

        // optical window
        translate([0, 0, window_z])
            rotate([0,90,0])
                cylinder(h=outer_side+2, r=window_diam/2, center=true);

        // chamfer all four vertical corner edges (see corner_flat_d)
        for (a=[0:90:270])
            rotate([0,0,a])
                translate([corner_flat_d/sqrt(2), corner_flat_d/sqrt(2), 0])
                    rotate([0,0,45])
                        translate([0, -outer_side, -1])
                            cube([outer_side, outer_side*2, holder_depth+2]);
    }

    // two registration rods along y on the +x side
    translate([cuvette_dim/2+rod_radius, holder_side/3, 0])
        cylinder(h=chamber_depth, r=rod_radius);
    translate([cuvette_dim/2+rod_radius, -holder_side/3, 0])
        cylinder(h=chamber_depth, r=rod_radius);

    // one registration rod on the -y side
    translate([0, -cuvette_dim/2-rod_radius, 0])
        cylinder(h=chamber_depth, r=rod_radius);
}

/* ---------- internal clip pocket ---------- */
// enclosed on all sides: floor below, solid corner above pocket_top, and
// opaque skin behind and beside it; opens only via the corner slit.
// Two zones: the deep narrow zone houses the tongue and its spring travel;
// the shallow WIDE front zone houses the broad block face.
module clip_pocket() {
    at_corner(pocket_front, floor_thick) {
        // deep zone (tongue)
        translate([-(pocket_back-pocket_front), -pocket_hw, 0])
            cube([pocket_back-pocket_front, pocket_hw*2,
                  pocket_top - floor_thick]);
        // wide front zone (block), 1.2 mm side gap around the block
        translate([-(nub_zone_back-pocket_front), -(nub_w/2 + 1.2), 0])
            cube([nub_zone_back-pocket_front, nub_w + 2.4,
                  pocket_top - floor_thick]);
    }
}

/* ---------- the springy tongue with its nub ---------- */
module tongue() {
    // flat 45-degree tongue, hinged at the BOTTOM: it runs from z=0 so its
    // lowest 5 mm fuse into the chamber floor; the free end is at clip_tip_z.
    // Printed right side up it builds base-first -- no support needed.
    at_corner(d_face)
        translate([-clip_thick, -clip_width/2, 0])
            cube([clip_thick, clip_width, clip_tip_z]);

    // flat block nub: its pressing face is tangent to the cuvette corner
    // (perpendicular to the corner diagonal), protruding nub_protr past the
    // tongue face so the face plane sits clip_preload inside the seated
    // cuvette corner.  A 45-degree wedge on top slides the cuvette in; a
    // steeper 1.5:1 wedge underneath (~56 degrees from horizontal) makes
    // the block print right side up with no droopy overhang.
    // Cross-section drawn in the (diagonal, z) plane and extruded across
    // the corner (local +x points toward the cavity center).
    nub_protr = d_face - d_nub_tip;   // = clip_gap + clip_preload
    at_corner(d_face)
        rotate([90, 0, 0])
            linear_extrude(height=nub_w, center=true)
                polygon([[-0.5, nub_z_lo - 1.5*(nub_protr + 0.5)], // back, bottom
                         [nub_protr, nub_z_lo],                // face, bottom
                         [nub_protr, nub_z_hi],                // face, top
                         [-0.5, nub_z_hi + nub_protr + 0.5]]); // back, top
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

        // M3 clearance holes, through plate and bosses
        for (dy=[-1,1], dz=[-1,1])
            translate([-1, dy*hole_spacing/2, window_z + dz*hole_spacing/2])
                rotate([0,90,0])
                    cylinder(h=plate_thick+standoff+2, d=m3_pilot);

        // hex nut insets on the plate's INNER face: the nut presses in once
        // and stays captive, so it needn't be held in the tight gap while
        // the screw is driven.  Hex oriented flat-side-up so the pocket
        // roof prints as a short bridge.
        for (dy=[-1,1], dz=[-1,1])
            translate([-0.01, dy*hole_spacing/2, window_z + dz*hole_spacing/2])
                rotate([0,90,0]) rotate([0,0,30])
                    cylinder(h=nut_inset_depth, d=nut_af*2/sqrt(3), $fn=6);

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
    // % keeps ghosts out of render/STL export; color still tints the preview
    %translate([standoff + plate_thick, -pcb_size/2, window_z - pcb_size/2])
         color("Green", 0.4) {
             cube([pcb_thick, pcb_size, pcb_size]);
         }
}

// ghost cuvette in its seated position
module cuvette() {
    
    %translate([-cuvette_dim/2, -cuvette_dim/2, floor_thick])
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
// everything EXCEPT the tongue, so the xray view can ghost it as one piece
module holder_shell() {
    base_plate();
    translate([0,0,base_thick]) {
        difference() {
            body();
            clip_pocket();
        }
        // mirror([1,0,0]) flips x only, so header_side puts both slots on
        // the same global y side
        translate([outer_side/2, 0, 0])      // detector side
            pcb_mount(header_cut=header_cutaway_det);
        translate([-outer_side/2, 0, 0])     // emitter side
            mirror([1,0,0]) pcb_mount(header_cut=header_cutaway_emit);
    }
}

module holder15() {
    holder_shell();
    translate([0,0,base_thick]) tongue();
}

/* ---------- view modes ---------- */
// block of chamber wall carved away around the clip corner by the cutaway
// view, leaving the whole tongue standing exposed in the opening (the box
// stops flush at the emitter plate face and clear of the optical window)
module corner_reveal() {
    translate([-outer_side/2, 3, base_thick + 1])
        cube([outer_side/2 - 3, outer_side/2 + 1,
              holder_depth + base_thick]);
}

if (view_mode == "xray") {
    translate([0,0,base_thick]) color("Crimson") tongue();
    %holder_shell();
} else if (view_mode == "cutaway") {
    difference() {
        holder_shell();
        corner_reveal();
    }
    translate([0,0,base_thick]) color("Crimson") tongue();
} else {
    holder15();
}

// fit-check ghosts
if (show_ghosts) {
    translate([0,0,base_thick]) cuvette();
    translate([outer_side/2, 0, base_thick]) pcb_ghost();
    translate([-outer_side/2, 0, base_thick]) mirror([1,0,0]) pcb_ghost();
}
