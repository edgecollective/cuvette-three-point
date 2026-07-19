// case4.scad -- wooden case, v4: screw-down lid via 3D-PRINTED NUT-CARRIER
// POSTS (see post4.scad; print four).
//
// Changes from v3/case3.scad:
//   - the lid keeps v3's press-fit "square wave" tab/slot joint for
//     location, but is now RETAINED by four M3 machine screws;
//   - each screw drives into an M3 nut held captive in a printed post
//     that HANGS on a front/back wall: a tab on the post drops into a
//     through-slot lasered near the wall top, the post's top face sits
//     flush at the wall top, and the nut slides into the post from the
//     inside (holder15-style captive nut -- nothing to hold or drop
//     during assembly).  No glue for any of it: the tab locates the post
//     and the lid screw clamps it.  Posts hang high on the walls, so
//     they clear the floor-mounted board entirely.
// Everything else -- board flat on the floor, cabled display/buttons,
// cross-shaped snug holder opening, flush-top constraint -- is v3.
//
//   mode = "3d"    assembly preview, with ghost holder / board / posts
//   mode = "flat"  2D panel layout for cutting:
//                  openscad -D 'mode="flat"' -o case4.dxf case4.scad
//
// !!! VERIFY BEFORE CUTTING (marked ADJUST below): display window, USB
// slot, and button positions/diameter are estimates -- measure the real
// parts and tune first.  Board outline/holes (115 x 46, 108 x 39 grid)
// and all holder numbers are exact.
//
// Assembly:
//   1. glue walls + bottom (the lid stays dry);
//   2. slide an M3 nut into each printed post; drop each post's tab into
//      its wall slot from inside;
//   3. screw the holder to the floor (M3 x 8 + nuts under the case);
//   4. stand the control board on board_lift standoffs, screws up through
//      the bottom panel;
//   5. mount the display module behind its lid window, the buttons in the
//      front panel; cable everything; press the lid onto the wall tabs
//      and drive four M3 x 14 screws into the posts.

use <../../v1/holder15.scad>
use <post4.scad>

mode = "3d";   // "3d" | "flat"

/* ---- material ---- */
t       = 6;    // plywood thickness
fingers = 5;    // finger segments per vertical edge (odd number)
slot_fit = 0;   // per-side clearance added to the LID slots only: 0 relies
                // on kerf for a snug seat; go +0.05 if too tight

/* ---- cuvette holder (MUST MATCH v1/holder15.scad) ---- */
hold_base_x = 39.2;   // base plate footprint along the optical axis
hold_base_y = 56.6;   // base plate footprint across (ear to ear)
hold_mnt_x  = 12;     // ear holes at (+/-12, +/-23.8) around the holder center
hold_mnt_y  = 23.8;
hold_mnt_d  = 3.4;    // M3 clearance
hold_h      = 43;     // base bottom -> plate/shroud top

/* ---- control board (UV-Control v0.1), flat on the floor ---- */
brd_l      = 115;
brd_w      = 46;
brd_dx     = 108;     // mounting hole spacing, long axis
brd_dy     = 39;      // mounting hole spacing, short axis
brd_hole_d = 3.4;
board_lift = 6;       // standoff height: floor -> board underside

/* ---- interior ---- */
Li = 180;             // interior length  (x)
Wi = 62;              // interior width   (y)
Hi = hold_h - t;      // interior height: lid OUTER face flush w/ holder top
L  = Li + 2*t;
W  = Wi + 2*t;

/* ---- layout (origin: plan center, z=0 at the interior floor) ---- */
holder_cx = -56;      // holder center; board occupies the rest of the floor
brd_x0    = -28;              // board LEFT edge (KiCad x=0); +y = board top
brd_cx    = brd_x0 + brd_l/2; //   edge (USB side) faces the BACK panel

// lid opening: snug LONGITUDINALLY -- its +/-x edges close onto the
// holder's shroud/board faces (hold_base_x wide) so the lid clamps the
// holder top in place.  open_fit is the per-side clearance: 0.1 is a push
// fit in clean ply; tune against your kerf (0 or slightly negative for a
// press fit).  The PCB screw heads stick ~3 mm past those faces at
// y=+/-13, up into the lid thickness, so the opening edges get four small
// relief notches for them.  Crosswise (y) keeps its loose 1.7 mm/side.
open_fit      = 0.1;
open_l        = hold_base_x + 2*open_fit;
open_w        = 42;
head_relief_w = 9;     // notch width along y, centered on y=+/-13
head_relief_d = 3.5;   // notch depth beyond the opening edge (head is ~3)

// the opening is a CROSS, not a rectangle: full open_w width only over the
// plate/shroud bands at the +/-x ends; the middle narrows to an octagon
// hugging the chamber's outer walls and corner chamfers, so the lid covers
// the otherwise-open corridors above the chamber on the +/-y sides
chamber_hw       = 13;     // chamber outer half-width (outer_side/2 in v1)
chamber_corner_d = 14.2;   // chamber corner chamfer distance (corner_flat_d)

/* ---- lid: cabled SSD1306 module ---- ADJUST window to the real glass;
   no mounting holes -- fix the module to the lid underside with tape,
   hot glue, or a printed bezel */
disp_c      = [51, 0];     // window center -- free, place anywhere on the lid
                           //   (centered above the two front-panel buttons)
disp_sz     = [26, 15];    // glass opening

/* ---- back panel: USB slot ---- ADJUST (plug overmolds vary) */
usb_cx = 75;                       // slot center x (board-local ~103)
usb_w  = 16;
usb_h  = 10;
usb_cz = board_lift + 1.6 + 1.5;   // centered on the connector

/* ---- front panel: cabled buttons ---- ADJUST count/positions/diameter.
   NB: with the board on the floor, a panel-mount button's body (~20 mm
   deep) hangs OVER the board's front edge strip; button_z=21 leaves
   ~4.5 mm over the board surface, so keep the buttons over low (SMD)
   regions of the board, or move them / shorten the body accordingly */
button_x = [35, 67];    // hole centers along the front, toward the right end
button_z = 21;          // center height
button_d = 16;          // 16 mm panel-mount pushbutton

/* ---- printed nut-carrier posts (post4.scad; MUST MATCH) ---- */
post_l     = 12;   // post length along the wall
post_d     = 8;    // post depth into the case (clears the board footprint)
post_h     = 18;   // post height; hangs with its top at the wall top
post_tab_w = 8;    // wall through-slot for the post's tab, 8 x 8,
post_tab_h = 8;    //   spanning case z (Hi-14)..(Hi-6)
post_x     = [-84, 84];        // post centers on BOTH front/back walls
post_scr_y = Wi/2 - post_d/2;  // lid screw y = post bore center
lid_scr_d  = 3.4;              // M3 clearance through the lid (M3 x 14)

/* ---- top/bottom-edge tabs (same "square wave" both edges) ---- */
fb_tab_x   = [-60, -20, 20, 60];   // front/back wall tab centers (case x)
fb_tab_w   = 18;
side_tab_y = [-14, 14];            // side wall tab centers (case y)
side_tab_w = 14;

seg = Hi/fingers;
eps = 0.01;

/* ================= 2D panels ================= */
// Vertical-edge joint convention: the FRONT/BACK panels run the full outer
// length and keep material on the EVEN segments at their ends; the SIDE
// panels sit between them and grow tabs on the ODD segments.  All four
// walls drop tabs (t deep) through slots in the bottom panel AND grow the
// same tabs upward through slots in the screw-down lid.

module wall_fb_blank() {           // front/back: full outer length
    difference() {
        union() {
            difference() {
                translate([-L/2, 0]) square([L, Hi]);
                for (i=[0:fingers-1]) if (i%2==1) {
                    translate([-L/2-eps, i*seg]) square([t+eps, seg]);
                    translate([ L/2-t,   i*seg]) square([t+eps, seg]);
                }
            }
            for (cx=fb_tab_x) {
                translate([cx-fb_tab_w/2, -t]) square([fb_tab_w, t+eps]);
                translate([cx-fb_tab_w/2, Hi-eps]) square([fb_tab_w, t+eps]);
            }
        }
        // through-slots for the printed posts' locating tabs
        for (cx=post_x)
            translate([cx-post_tab_w/2, Hi-14])
                square([post_tab_w, post_tab_h]);
    }
}

module wall_side_2d() {            // left/right: body Wi + edge tabs
    translate([-Wi/2, 0]) square([Wi, Hi]);
    for (i=[0:fingers-1]) if (i%2==1) {
        translate([-Wi/2-t,     i*seg]) square([t+eps, seg]);
        translate([ Wi/2-eps,   i*seg]) square([t+eps, seg]);
    }
    for (cy=side_tab_y) {
        translate([cy-side_tab_w/2, -t]) square([side_tab_w, t+eps]);
        translate([cy-side_tab_w/2, Hi-eps]) square([side_tab_w, t+eps]);
    }
}

module front_2d() {                // buttons
    difference() {
        wall_fb_blank();
        for (bx=button_x)
            translate([bx, button_z]) circle(d=button_d, $fn=48);
    }
}

module back_2d() {                 // USB slot at floor-level board height
    difference() {
        wall_fb_blank();
        translate([usb_cx, usb_cz]) square([usb_w, usb_h], center=true);
    }
}

// the wall-tab slots shared by the bottom panel and the lid
module edge_slots(fit=0) {
    for (cx=fb_tab_x, sy=[-1,1])
        translate([cx, sy*(Wi+t)/2])
            square([fb_tab_w+2*fit, t+2*fit], center=true);
    for (cy=side_tab_y, sx=[-1,1])
        translate([sx*(Li+t)/2, cy])
            square([t+2*fit, side_tab_w+2*fit], center=true);
}

module bottom_2d() {               // tab slots + holder AND board hole grids
    difference() {
        square([L, W], center=true);
        edge_slots();
        for (sx=[-1,1], sy=[-1,1])
            translate([holder_cx + sx*hold_mnt_x, sy*hold_mnt_y])
                circle(d=hold_mnt_d, $fn=32);
        for (sx=[-1,1], sy=[-1,1])
            translate([brd_cx + sx*brd_dx/2, sy*brd_dy/2])
                circle(d=brd_hole_d, $fn=32);
    }
}

module lid_2d() {                  // opening, window, tab slots, post screws
    difference() {
        square([L, W], center=true);
        edge_slots(slot_fit);
        translate([holder_cx, 0]) {
            // narrow octagonal middle: hugs the chamber walls + chamfers
            intersection() {
                square(2*(chamber_hw+open_fit), center=true);
                rotate(45) square(2*(chamber_corner_d+open_fit), center=true);
            }
            // full-width bands over the plates/shrouds at the +/-x ends
            for (sx=[-1,1])
                translate([sx*(open_l/2 + chamber_hw - 0.5)/2, 0])
                    square([open_l/2 - chamber_hw + 0.5, open_w], center=true);
        }
        // relief notches for the holder's PCB screw heads (y=+/-13)
        for (sx=[-1,1], sy=[-1,1])
            translate([holder_cx + sx*(open_l+head_relief_d)/2, sy*13])
                square([head_relief_d+eps, head_relief_w], center=true);
        translate(disp_c) square(disp_sz, center=true);
        // lid screws into the printed posts
        for (x=post_x, sy=[-1,1])
            translate([x, sy*post_scr_y]) circle(d=lid_scr_d, $fn=32);
    }
}

/* ================= 3D assembly ================= */
module assembly() {
    color("BurlyWood") translate([0, 0, -t]) linear_extrude(t) bottom_2d();
    color("BurlyWood") translate([0, 0, Hi]) linear_extrude(t) lid_2d();
    color("Peru") translate([0, -Wi/2, 0])
        rotate([90,0,0]) linear_extrude(t) front_2d();
    color("Peru") translate([0, Wi/2+t, 0])
        rotate([90,0,0]) linear_extrude(t) back_2d();
    color("Peru") for (sx=[-1,1])
        translate([sx>0 ? Li/2 : -Li/2-t, 0, 0])
            rotate([90,0,90]) linear_extrude(t) wall_side_2d();
}

module ghosts() {
    // the v1 holder, screwed to the floor (printed in black filament)
    %color([0.15, 0.15, 0.15]) translate([holder_cx, 0, 0]) holder15();

    // printed nut-carrier posts hanging on the front/back walls
    %color("DarkOrange") for (cx=post_x) {
        translate([cx-post_l/2, -Wi/2, Hi-post_h]) post4();
        translate([cx-post_l/2,  Wi/2, Hi-post_h]) mirror([0,1,0]) post4();
    }
    // their M3 screws (x 14) and captive nuts
    %color("Silver") for (cx=post_x, sy=[-1,1])
        translate([cx, sy*post_scr_y, 0]) {
            translate([0, 0, Hi+t]) cylinder(h=2, d=5.5, $fn=20);   // head
            translate([0, 0, Hi+t-14]) cylinder(h=14, d=3, $fn=20); // shank
            translate([0, 0, Hi-4.5-2.4])
                cylinder(h=2.4, d=6.35, $fn=6);                     // nut
        }

    // control board on its standoffs (component side up)
    %color("Green")
        translate([brd_x0, -brd_w/2, board_lift]) cube([brd_l, brd_w, 1.6]);
    %color("Gray") for (sx=[-1,1], sy=[-1,1])
        translate([brd_cx+sx*brd_dx/2, sy*brd_dy/2, 0])
            cylinder(h=board_lift, d=5, $fn=24);
    // micro-USB at the board's back edge
    %color("Silver")
        translate([usb_cx-4, brd_w/2-8, board_lift+1.6]) cube([8, 8, 3.5]);

    // panel-mount buttons in the front panel (16 mm anti-vandal style):
    // bezel + actuator proud of the panel, body reaching ~20 mm inside
    %color("Silver") for (bx=button_x)
        translate([bx, -W/2, button_z]) {
            rotate([-90,0,0]) cylinder(h=t+20, d=15.5, $fn=40);   // body
            rotate([ 90,0,0]) cylinder(h=2, d=18.5, $fn=40);      // bezel
            rotate([ 90,0,0]) translate([0,0,2])
                cylinder(h=2.5, d=10, $fn=40);                    // actuator
        }

    // cabled display module against the lid underside
    %color("DarkSlateGray")
        translate([disp_c[0]-13.7, disp_c[1]-13.9, Hi-1.8])
            cube([27.4, 27.8, 1.8]);
}

/* ================= output ================= */
if (mode == "flat") {
    gap = 8;
    bottom_2d();
    translate([0, W+gap]) lid_2d();
    translate([0, -(W/2+gap+Hi+t)]) front_2d();
    translate([0, -(W/2+2*gap+2*(Hi+t)+t)]) back_2d();
    translate([L/2+gap+t+Wi/2, 0]) wall_side_2d();
    translate([L/2+gap+t+Wi/2, Hi+2*t+gap]) wall_side_2d();
} else {
    assembly();
    ghosts();
}
