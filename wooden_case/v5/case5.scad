// case5.scad -- v3_shorter plus M3 SELF-TAPPING LID SCREWS: the lid keeps
// the press-fit "square wave" seating for location, and is additionally
// retained by M3 self-tappers driving down through lid clearance holes
// into the top EDGES of the walls below -- two into the front wall, two
// into the back, one into each side wall (see *_scr_* below), all placed
// on solid edge segments clear of the tabs and corner fingers.
//
// !! Edge-screwing 5 mm ply leaves only ~1 mm of material each side of an
// M3 thread, so: ALWAYS drill a 2.0-2.5 mm pilot first (assemble the box,
// use the lid holes as drill guides), drive gently, and don't overtighten
// -- the threads strip before the head seats if you crank on them.
// Screw length: through the lid (t) + ~10 mm of engagement => M3 x 16.
//
// Based on case3_shorter.scad -- v3 with a SHORTER case: the lid's outer face is
// flush with the holder's CHAMBER TOP RIM (base 3 + chamber_depth 35 =
// 38 mm above the floor) instead of the taller PCB plate/shroud tops (43).
// The plates/shrouds poke 5 mm up through the lid's cross-opening bands,
// and 5 mm more of the cuvette stands clear of the case for grabbing;
// the lid's octagonal middle still hugs the chamber walls, whose rim now
// sits exactly at the lid surface.  Only hold_top (below) and a slightly
// lowered button_z differ from v3.
//
// Changes from v2/case2.scad (inherited from v3):
//   - the T-slot captive-nut lid screws are GONE (no lid screws at all);
//   - instead the walls carry the same "square wave" tab pattern on their
//     TOP edges as on their bottom edges, and the lid gets slots matching
//     the bottom panel's, so the lid presses onto the walls exactly the
//     way the bottom does -- but unglued, held by friction alone.  Cut
//     with the kerf tuned snug (or add slot_fit below) so the fit is a
//     firm push; the snug holder opening in the lid also helps hold it.
// Everything else -- board flat on the floor, cabled display/buttons,
// cross-shaped snug holder opening, flush-top constraint -- is v2.
//
//   mode = "3d"    assembly preview, with ghost holder / board / buttons
//   mode = "flat"  2D panel layout for cutting:
//                  openscad -D 'mode="flat"' -o case3.dxf case3.scad
//
// !!! VERIFY BEFORE CUTTING (marked ADJUST below): display window, USB
// slot, and button positions/diameter are estimates -- measure the real
// parts and tune first.  Board outline/holes (115 x 46, 108 x 39 grid)
// and all holder numbers are exact.
//
// Assembly:
//   1. glue walls + bottom (the lid stays dry -- press fit);
//   2. screw the holder to the floor (M3 x 8 + nuts under the case);
//   3. stand the control board on board_lift standoffs, screws up through
//      the bottom panel;
//   4. mount the display module behind its lid window, the buttons in the
//      front panel; cable everything; press the lid onto the wall tabs.

use <../../v1/holder15.scad>

mode = "flat";   // "3d" | "flat"

/* ---- material ---- */
t       = 5;    // plywood thickness
fingers = 5;    // finger segments per vertical edge (odd number)
slot_fit = 0;   // per-side clearance added to the LID slots only: 0 relies
                // on kerf for the press fit; go +0.05 if too tight

/* ---- cuvette holder (MUST MATCH v1/holder15.scad) ---- */
hold_base_x = 39.2;   // base plate footprint along the optical axis
hold_base_y = 56.6;   // base plate footprint across (ear to ear)
hold_mnt_x  = 12;     // ear holes at (+/-12, +/-23.8) around the holder center
hold_mnt_y  = 23.8;
hold_mnt_d  = 3.4;    // M3 clearance
hold_h      = 43;     // base bottom -> plate/shroud top (info; pokes above)
hold_top    = 38;     // base bottom -> CHAMBER top rim (base 3 +
                      // chamber_depth 35); the lid lands flush with THIS

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
Hi = 38;              // interior height: floor top -> lid UNDERSIDE = 38,
                      // so the lid underside meets the chamber top rim
                      // (hold_top) and with t=5 the lid's outer face lands
                      // flush with the PCB plate/shroud tops (43)
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
open_w        = 39;    // band length along the lid's long axis: was 42
                       // (1.7 mm slack/side around the 38.6 mm plates);
                       // shortened 1.5 mm per side -> 0.2 mm fit/side
// (no screw-head relief notches: with the lid raised to z 38..43, the
// PCB screws at z=36 sit below the lid underside -- but see the NB at
// the top screws: a standard head's top edge reaches z~38.8, so use
// LOW-PROFILE or countersunk screws on the UPPER holder holes, or the
// lid will sit ~0.8 mm proud on the heads)

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
disp_sz     = [25, 14];    // glass opening (measured)

/* ---- back panel: USB slot ---- ADJUST (plug overmolds vary) */
usb_cx = 53;                       // slot center x (was 75; shifted 22
                                   //   toward the middle of the case)
usb_w  = 16;
usb_z0 = 12.5;                     // slot bottom, above the interior floor
usb_z1 = 17.5;                     //   (raised 2.5 = half the 5 mm span)
usb_h  = usb_z1 - usb_z0;
usb_cz = (usb_z0 + usb_z1)/2;
// NB: with board_lift = 6 the connector sits at z 7.6..10.6 -- mostly
// BELOW this slot.  Use ~9-10 mm standoffs (board_lift) to center the
// connector in the 10..15 window.

/* ---- front panel: cabled buttons ---- ADJUST count/positions/diameter.
   NB: with the board on the floor, a panel-mount button's body (~20 mm
   deep) hangs OVER the board's front edge strip; button_z=21 leaves
   ~4.5 mm over the board surface, so keep the buttons over low (SMD)
   regions of the board, or move them / shorten the body accordingly */
button_x = [35, 67];    // hole centers along the front, toward the right end
button_z = 19;          // center height, lowered vs v3's 21: the shorter
                        // wall (Hi=32) needs margin above the 16 mm hole;
                        // body-over-board clearance drops to ~3.6 mm
button_d = 12;          // 12 mm panel-mount pushbutton (measured)

/* ---- self-tapping lid screws into the wall top edges ---- */
lid_scr_d  = 3.2;         // lid clearance holes for M3 self-tappers
fb_scr_x   = [-80, 0, 80]; // into the front AND back walls (6 screws):
                          //   near each end (solid segment between the
                          //   outer tab and the corner fingers) plus one
                          //   mid-length (solid segment between the two
                          //   middle tabs)
side_scr_y = [];          // none into the side (end) walls
scr_embed  = 11;          // thread engagement below the lid (M3 x 16)

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
// same tabs upward through slots in the press-fit lid.

module wall_fb_blank() {           // front/back: full outer length
    difference() {
        translate([-L/2, 0]) square([L, Hi]);
        for (i=[0:fingers-1]) if (i%2==1) {
            translate([-L/2-eps, i*seg]) square([t+eps, seg]);
            translate([ L/2-t,   i*seg]) square([t+eps, seg]);
        }
    }
    for (cx=fb_tab_x) {
        translate([cx-fb_tab_w/2, -t]) square([fb_tab_w, t+eps]);       // bottom
        translate([cx-fb_tab_w/2, Hi-eps]) square([fb_tab_w, t+eps]);   // top
    }
}

module wall_side_2d() {            // left/right: body Wi + edge tabs
    translate([-Wi/2, 0]) square([Wi, Hi]);
    for (i=[0:fingers-1]) if (i%2==1) {
        translate([-Wi/2-t,     i*seg]) square([t+eps, seg]);
        translate([ Wi/2-eps,   i*seg]) square([t+eps, seg]);
    }
    for (cy=side_tab_y) {
        translate([cy-side_tab_w/2, -t]) square([side_tab_w, t+eps]);      // bottom
        translate([cy-side_tab_w/2, Hi-eps]) square([side_tab_w, t+eps]);  // top
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
        // holder base-ear holes, holder ROTATED 90 deg (optical axis
        // across the case; emitter/detector boards face front/back)
        translate([holder_cx, 0]) rotate(90)
            for (sx=[-1,1], sy=[-1,1])
                translate([sx*hold_mnt_x, sy*hold_mnt_y])
                    circle(d=hold_mnt_d, $fn=32);
        for (sx=[-1,1], sy=[-1,1])
            translate([brd_cx + sx*brd_dx/2, sy*brd_dy/2])
                circle(d=brd_hole_d, $fn=32);
    }
}

module lid_2d() {                  // opening, display window, press-fit slots
    difference() {
        square([L, W], center=true);
        edge_slots(slot_fit);
        // cross opening, rotated 90 deg with the holder: the snug open_l
        // direction now runs across the case (case y)
        translate([holder_cx, 0]) rotate(90) {
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
        translate(disp_c) square(disp_sz, center=true);
        // self-tapper clearance holes over the wall centerlines
        for (x=fb_scr_x, sy=[-1,1])
            translate([x, sy*(Wi+t)/2]) circle(d=lid_scr_d, $fn=32);
        for (sx=[-1,1], y=side_scr_y)
            translate([sx*(Li+t)/2, y]) circle(d=lid_scr_d, $fn=32);
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
    %color([0.15, 0.15, 0.15]) translate([holder_cx, 0, 0])
        rotate([0, 0, 90]) holder15();

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
            rotate([-90,0,0]) cylinder(h=t+20, d=button_d-0.5, $fn=40); // body
            rotate([ 90,0,0]) cylinder(h=2, d=button_d+2, $fn=40);      // bezel
            rotate([ 90,0,0]) translate([0,0,2])
                cylinder(h=2.5, d=button_d-5, $fn=40);                  // actuator
        }

    // the six self-tapping lid screws (heads on the lid, threads in the
    // wall edges below)
    %color("Silver") for (p=[ for (x=fb_scr_x, sy=[-1,1]) [x, sy*(Wi+t)/2],
                              for (sx=[-1,1], y=side_scr_y) [sx*(Li+t)/2, y] ])
        translate([p[0], p[1], 0]) {
            translate([0, 0, Hi+t]) cylinder(h=2, d=5.5, $fn=20);       // head
            translate([0, 0, Hi-scr_embed])
                cylinder(h=scr_embed+t, d=2.9, $fn=20);                 // shank
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
    // back panel FLIPPED about its vertical axis in the flat layout, so
    // the face drawn up here is the one that faces OUT on the case
    translate([0, -(W/2+2*gap+2*(Hi+t)+t)]) mirror([1, 0]) back_2d();
    translate([L/2+gap+t+Wi/2, 0]) wall_side_2d();
    translate([L/2+gap+t+Wi/2, Hi+2*t+gap]) wall_side_2d();
} else {
    assembly();
    ghosts();
}
