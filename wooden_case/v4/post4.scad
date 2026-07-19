// post4.scad -- 3D-printed nut-carrier post for the v4 wooden case.
// PRINT FOUR.  Each post hangs on a front/back wall: its tab drops into a
// through-slot lasered near the wall top, its top face sits flush with the
// wall top (= lid underside), and an M3 nut slides into the slot from the
// post's interior face, where it stays captive (same idea as the hex
// insets in v1/holder15.scad's PCB plates).  An M3 x 14 machine screw
// drives down through the lid into the nut; the nut_roof of plastic above
// the nut carries the pull-out load.  No glue anywhere: the tab locates
// the post, the screw clamps it.
//
// PRINT LYING ON A SIDE (x) FACE: every layer is then the full cross
// section (body + tab), so there are no overhangs and no support; the
// bore and nut slot print as short bridges.
//
// The parameters below MUST MATCH case4.scad (t, Hi, post_*).

t  = 6;       // case sheet thickness (tab reaches through the wall)
Hi = 43 - t;  // case interior height (info only; the post is ph tall)

pl = 12;      // post length along the wall
pd = 8;       // post depth into the case (clears the board footprint in plan)
ph = 18;      // post height; top face lands flush at the wall top

tab_w   = 8;      // wall slot is 8 x 8 (case4 post_tab_w/h)
tab_h   = 8;
tab_fit = 0.15;   // per-side clearance of the printed tab in the slot
tab_z   = ph - 14;   // tab bottom (post-local); slot at case z Hi-14..Hi-6

bore_d = 3.2;     // M3 clearance, down from the top face
bore_l = 12;
nut_w  = 5.8;     // M3 nut: 5.5 across flats + fit
nut_t  = 2.7;     // M3 nut: 2.4 thick + fit
nut_roof = 4.5;       // plastic between top face and nut
nut_slot_deep = 7;    // slide-in depth from the interior (y=pd) face

module post4() {
    difference() {
        union() {
            cube([pl, pd, ph]);                        // wall face at y=0
            translate([(pl-tab_w)/2 + tab_fit, -t, tab_z + tab_fit])
                cube([tab_w - 2*tab_fit, t + 0.01, tab_h - 2*tab_fit]);
        }
        // screw bore
        translate([pl/2, pd/2, ph - bore_l])
            cylinder(h=bore_l + 1, d=bore_d, $fn=24);
        // nut slide-in slot, open at the interior face
        translate([pl/2 - nut_w/2, pd - nut_slot_deep, ph - nut_roof - nut_t])
            cube([nut_w, nut_slot_deep + 1, nut_t]);
    }
}

post4();
