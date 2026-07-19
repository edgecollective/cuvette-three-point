// case1.scad -- laser-cut wooden case for the v1 cuvette holder and the
// UV-Control board.
//
// Layout (top view): the holder stands on the case floor at the LEFT end,
// screwed down through its base ears, and rises through an opening in the
// lid so its top rim is FLUSH with the lid's outer face (the whole case
// height follows from that: lid top = holder top = 43 mm above the floor).
// The control board hangs component-side-up under the lid on four screws +
// spacers; the SSD1306 display shows through a lid window, the micro-USB
// exits through a slot in the back panel, and panel-mount buttons (wired to
// the board's A/B/C pads) go in the front panel.  The lid screws down onto
// four glued-in plywood corner strips, so it comes off for access.
//
// Construction: finger-jointed plywood box.  The four walls interlock at
// the vertical edges and drop tabs through slots in the bottom panel
// (glue-up); the lid is a plain plate.  Everything is parametric in the
// sheet thickness t -- interior height auto-adjusts so the lid outer face
// always lands at the holder top.
//
//   mode = "3d"    assembly preview, with ghost holder / board / blocks
//   mode = "flat"  2D panel layout for cutting:
//                  openscad -D 'mode="flat"' -o case1.dxf case1.scad
//
// !!! VERIFY BEFORE CUTTING (marked ADJUST below): the display window,
// USB slot, and button positions/diameter are estimates -- measure the
// assembled board (display glass position, USB plug width, actual buttons)
// and tune disp_*, usb_*, button_* first.  Board outline/holes (115 x 46,
// 108 x 39 grid) and all holder numbers are exact.
//
// Assembly:
//   1. glue walls + bottom; glue the four corner strips (offcuts of the
//      same ply, blk_len long) into the corners flush with the wall tops;
//   2. screw the holder to the floor (M3 x 8 + nuts under the case, or
//      wood screws into a sub-board);
//   3. hang the control board under the lid: M3 x 25 through the lid,
//      board_drop-long spacers, nut under the board;
//   4. mount buttons in the front panel, wire everything, screw the lid
//      down into the corner strips (small wood screws, lid_scr_d holes).

use <../../v1/holder15.scad>

mode = "3d";   // "3d" | "flat"

/* ---- material ---- */
t       = 6;    // plywood thickness
fingers = 5;    // finger segments per vertical edge (odd number)

/* ---- cuvette holder (MUST MATCH v1/holder15.scad) ---- */
hold_base_x = 39.2;   // base plate footprint along the optical axis
hold_base_y = 56.6;   // base plate footprint across (ear to ear)
hold_mnt_x  = 12;     // ear holes at (+/-12, +/-23.8) around the holder center
hold_mnt_y  = 23.8;
hold_mnt_d  = 3.4;    // M3 clearance
hold_h      = 43;     // base bottom -> plate/shroud top

/* ---- control board (UV-Control v0.1) ---- */
brd_l      = 115;
brd_w      = 46;
brd_dx     = 108;     // mounting hole spacing, long axis
brd_dy     = 39;      // mounting hole spacing, short axis
brd_hole_d = 3.4;
board_drop = 12;      // lid underside -> board component-side surface
                      // (spacer length; 12 puts a header-mounted SSD1306's
                      // glass about flush with the lid underside)

/* ---- interior ---- */
Li = 180;             // interior length  (x)
Wi = 62;              // interior width   (y)
Hi = hold_h - t;      // interior height: lid OUTER face flush w/ holder top
L  = Li + 2*t;
W  = Wi + 2*t;

/* ---- layout (origin: plan center, z=0 at the interior floor) ---- */
holder_cx = -56;      // holder center; board occupies the rest
open_l    = 50;       // lid opening around the holder top (clears the
open_w    = 42;       //   plates, board screw heads, and wire runs)

brd_x0    = -28;              // board LEFT edge (KiCad x=0); +y = board top
brd_cx    = brd_x0 + brd_l/2; //   edge (USB side) faces the BACK panel

/* ---- lid: display window ---- ADJUST to the real module position */
disp_c  = [69, 1];    // window center (board-local [97, 24])
disp_sz = [30, 20];

/* ---- back panel: USB slot ---- ADJUST (plug overmolds vary) */
usb_cx = 75;                       // slot center x (board-local ~103)
usb_w  = 16;
usb_h  = 10;
usb_cz = Hi - board_drop + 1.5;    // centered just above the board surface

/* ---- front panel: buttons ---- ADJUST count/positions/diameter */
button_x = [-20, 12];   // hole centers along the front (wired to A/B pads)
button_z = 15;          // center height (keeps the button body under the board)
button_d = 16;          // 16 mm panel-mount pushbutton

/* ---- lid screws + corner strips ---- */
blk_len   = 12;         // corner strip length (cut from the same ply, t thick)
lid_scr_d = 3;          // pilot clearance for small wood screws
lid_scr   = [ for (sx=[-1,1], sy=[-1,1])
                [sx*(Li/2 - blk_len/2), sy*(Wi/2 - t/2)] ];

/* ---- bottom-edge tabs ---- */
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
// walls drop tabs (t deep) through slots in the bottom panel.

module wall_fb_blank() {           // front/back: full outer length
    difference() {
        translate([-L/2, 0]) square([L, Hi]);
        for (i=[0:fingers-1]) if (i%2==1) {
            translate([-L/2-eps, i*seg]) square([t+eps, seg]);
            translate([ L/2-t,   i*seg]) square([t+eps, seg]);
        }
    }
    for (cx=fb_tab_x)
        translate([cx-fb_tab_w/2, -t]) square([fb_tab_w, t+eps]);
}

module wall_side_2d() {            // left/right: body Wi + edge tabs
    translate([-Wi/2, 0]) square([Wi, Hi]);
    for (i=[0:fingers-1]) if (i%2==1) {
        translate([-Wi/2-t,     i*seg]) square([t+eps, seg]);
        translate([ Wi/2-eps,   i*seg]) square([t+eps, seg]);
    }
    for (cy=side_tab_y)
        translate([cy-side_tab_w/2, -t]) square([side_tab_w, t+eps]);
}

module front_2d() {                // buttons
    difference() {
        wall_fb_blank();
        for (bx=button_x)
            translate([bx, button_z]) circle(d=button_d, $fn=48);
    }
}

module back_2d() {                 // USB slot
    difference() {
        wall_fb_blank();
        translate([usb_cx, usb_cz]) square([usb_w, usb_h], center=true);
    }
}

module bottom_2d() {               // full outer plate: tab slots + holder holes
    difference() {
        square([L, W], center=true);
        for (cx=fb_tab_x, sy=[-1,1])
            translate([cx, sy*(Wi+t)/2])
                square([fb_tab_w, t], center=true);
        for (cy=side_tab_y, sx=[-1,1])
            translate([sx*(Li+t)/2, cy])
                square([t, side_tab_w], center=true);
        for (sx=[-1,1], sy=[-1,1])
            translate([holder_cx + sx*hold_mnt_x, sy*hold_mnt_y])
                circle(d=hold_mnt_d, $fn=32);
    }
}

module lid_2d() {                  // opening, display window, all screw holes
    difference() {
        square([L, W], center=true);
        translate([holder_cx, 0]) square([open_l, open_w], center=true);
        translate(disp_c) square(disp_sz, center=true);
        for (sx=[-1,1], sy=[-1,1])
            translate([brd_cx + sx*brd_dx/2, sy*brd_dy/2])
                circle(d=brd_hole_d, $fn=32);
        for (p=lid_scr)
            translate(p) circle(d=lid_scr_d, $fn=32);
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

    // corner strips the lid screws into (cut from the same ply, glued in)
    %color("SaddleBrown") for (p=lid_scr)
        translate([p[0]-blk_len/2, p[1]>0 ? Wi/2-t : -Wi/2, 0])
            cube([blk_len, t, Hi]);
}

module ghosts() {
    // the v1 holder, screwed to the floor
    %translate([holder_cx, 0, 0]) holder15();

    // control board hanging under the lid (component side up)
    brd_top = Hi - board_drop;
    %color("Green")
        translate([brd_x0, -brd_w/2, brd_top-1.6]) cube([brd_l, brd_w, 1.6]);
    // display stack reaching up into the lid window
    %color("DarkSlateGray")
        translate([disp_c[0]-13, disp_c[1]-9, brd_top])
            cube([26, 18, board_drop-0.5]);
    // micro-USB at the board's back edge
    %color("Silver")
        translate([usb_cx-4, brd_w/2-6, brd_top]) cube([8, 8, 3.5]);
}

/* ================= output ================= */
if (mode == "flat") {
    gap = 8;
    bottom_2d();
    translate([0, W+gap]) lid_2d();
    translate([0, -(W/2+gap+Hi)]) front_2d();
    translate([0, -(W/2+2*gap+2*Hi+t)]) back_2d();
    translate([L/2+gap+t+Wi/2, 0]) wall_side_2d();
    translate([L/2+gap+t+Wi/2, Hi+t+gap]) wall_side_2d();
} else {
    assembly();
    ghosts();
}
