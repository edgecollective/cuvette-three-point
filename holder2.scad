// holder2.scad -- cuvette holder with a springy corner clip
//
// The open corner from holder.scad is replaced by a flexible tongue that is
// anchored at the TOP of the holder (the corner stays solid above
// clip_root_z) and hangs down the -x/+y corner at 45 degrees.  A rounded nub
// near the tongue's free end protrudes clip_preload past the seated cuvette
// corner, so it presses the cuvette diagonally into the three registration
// rods (two on the +x wall, one on the -y wall) -- same seat every insertion.
//
// Print note: printed upright as modeled, the tongue's free end (z=clip_tip_z)
// starts over the open notch, so enable supports (they pull out of the open
// corner easily).  Tune spring force with clip_thick (stiffness ~ t^3) and
// clip_preload.

$fn = 40;

window_diam   = 6;
window_height = 15;

cuvette_dim  = 12.5;
rod_radius   = 0.5;
holder_side  = cuvette_dim + rod_radius*2;
holder_depth = 40;
wall_width   = 2;
outer_side   = holder_side + wall_width*2;

/* ---------- spring clip parameters ---------- */
clip_thick   = 1.6;   // tongue thickness
clip_width   = 5;     // tongue width across the corner
clip_gap     = 0.7;   // clearance from tongue face to seated cuvette corner
clip_preload = 0.4;   // nub interference with the seated cuvette corner
clip_root_z  = 36;    // corner stays solid above this; tongue anchors into it
clip_tip_z   = 16;    // height of the tongue's free end
nub_r        = 1.2;   // radius of the rounded nub ridge
nub_len      = 3;     // vertical length of the nub ridge
nub_z        = holder_depth/2;  // press right at the optical window height
notch_d      = 8.6;   // corner material beyond this diagonal distance is cleared

// distances measured diagonally outward from the cavity center to the -x/+y corner
d_cuvette = cuvette_dim/2 * sqrt(2);   // seated cuvette corner edge   (~8.84)
d_face    = d_cuvette + clip_gap;      // inner face of the tongue
d_nub_tip = d_cuvette - clip_preload;  // nub tip, inside the cuvette line by the preload

// place children at diagonal distance d up the -x/+y corner;
// local +x points back toward the cavity center, local y runs along the corner face
module at_corner(d=0, z=0) {
    translate([-d/sqrt(2), d/sqrt(2), z])
        rotate([0,0,-45])
            children();
}

/* ---------- body (walls, floor, window, registration rods) ---------- */
module body() {
    translate([0,0,holder_depth/2]) {
        difference() {
            cube([outer_side, outer_side, holder_depth], center=true);

            // inner cavity
            translate([0,0,wall_width])
                cube([holder_side, holder_side, holder_depth], center=true);

            // optical window
            rotate([0,90,0])
                cylinder(h=holder_side*2, r=window_diam/2, center=true);
        }

        // two registration rods along y on the +x side
        translate([cuvette_dim/2+rod_radius, holder_side/3, 0])
            cylinder(h=holder_depth, r=rod_radius, center=true);
        translate([cuvette_dim/2+rod_radius, -holder_side/3, 0])
            cylinder(h=holder_depth, r=rod_radius, center=true);

        // one registration rod on the -y side
        translate([0, -cuvette_dim/2-rod_radius, 0])
            cylinder(h=holder_depth, r=rod_radius, center=true);
    }
}

/* ---------- corner notch: clears the corner so the tongue can flex ---------- */
// removes everything beyond notch_d at the corner, from the floor up to
// clip_root_z; above that the corner stays solid to anchor the tongue
module corner_notch() {
    at_corner(notch_d, wall_width)
        translate([-outer_side, -outer_side, 0])
            cube([outer_side, outer_side*2, clip_root_z - wall_width]);
}

/* ---------- the springy tongue with its nub ---------- */
module tongue() {
    // flat 45-degree tongue, running from its free end up past clip_root_z
    // so it fuses into the solid corner block at the top
    at_corner(d_face)
        translate([-clip_thick, -clip_width/2, clip_tip_z])
            cube([clip_thick, clip_width, holder_depth - clip_tip_z]);

    // rounded vertical nub ridge on the inner face; its tip sits clip_preload
    // past the seated cuvette corner, and its round profile gives a ramp for
    // insertion and removal
    at_corner(d_nub_tip + nub_r)
        hull() {
            translate([0, 0, nub_z - nub_len/2]) sphere(r=nub_r);
            translate([0, 0, nub_z + nub_len/2]) sphere(r=nub_r);
        }
}

/* ---------- assembly ---------- */
module holder2() {
    intersection() {
        union() {
            difference() {
                body();
                corner_notch();
            }
            tongue();
        }
        // trim everything back to the holder's footprint
        translate([0,0,holder_depth/2])
            cube([outer_side, outer_side, holder_depth], center=true);
    }
}

// ghost cuvette in its seated position (against the rods), for fit checking
module cuvette() {
    %translate([-cuvette_dim/2, -cuvette_dim/2, wall_width])
        cube([cuvette_dim, cuvette_dim, holder_depth]);
}

holder2();
//cuvette();
