# cuvette-three-point

3D-printed cuvette holder for a DIY colorimeter, designed in OpenSCAD. A
12.5 mm square cuvette drops into a chamber and is pressed by a printed
spring clip against three registration rods, so it seats in exactly the same
position every insertion ("three-point" kinematic registration). Emitter and
detector PCBs mount on opposite faces, aligned with an optical window through
the chamber at cuvette mid-height.

The current, print-tested design is `v1/holder15.scad` (blessed STL beside
it). The numbered `holderN` files in `drafts/` are the design history, each
stage self-contained and renderable (see Lineage below); when making
changes, work on the latest version (or a new draft stage if the user asks
for one — that has been the pattern), and refresh `v1/` only when a print
test blesses a new revision.

## Core design (holder9)

Coordinates: z up, origin at the cavity center, chamber floor at z=0 plane
(base plate below at -3..0 gets added by translating the assembly up
`base_thick`). Optical axis = x. All dimensions parametric at the top of the
file; the values below are the defaults as of 2026-07-11 (the user tunes
`standoff`, `shroud_lip`, `chamber_depth`, `m3_pilot` etc. directly — always
check the file, not this doc, for current numbers).

- **Registration**: three vertical rods (r=0.5) half-embedded in the cavity
  walls — two on the +x wall at y=±holder_side/3, one on the -y wall at x=0.
  Rod surfaces sit exactly at the cuvette envelope, so the seated cuvette has
  faces at x=+6.25 and y=-6.25 and ends up centered on the optical axis.
- **Spring clip**: a flat tongue at 45° across the -x/+y corner (diagonally
  opposite the rods), anchored at the TOP, hanging down inside a fully
  internal, light-tight pocket. A rounded capsule nub on its face presses the
  cuvette corner diagonally into the rods at optical-path height.
  - Diagonal-coordinate convention: `at_corner(d)` places geometry at
    distance `d` along the corner diagonal (local +x back toward cavity
    center). Seated cuvette corner: `d_cuvette = 6.25*sqrt(2) ≈ 8.839`.
  - Nub tip rests at `d_cuvette - clip_preload` (0.4 mm interference → the
    square constrained by nub+rods is ~12.22 mm, verified). Tongue face at
    `d_cuvette + clip_gap` (0.7 clearance — contact is nub-only).
  - Spring: 1.6 mm thick × 5 wide, hinge (pocket ceiling) at z=36, tip at 16,
    nub at window_z → ~14-16 mm arm ≈ 1.4-2 N seating force, PLA stress ~10 MPa.
  - Free travel before the tongue back hits the pocket: ~0.86 mm ≈ 2× preload.
- **Pocket** (all in diagonal distance): front plane 8.6 (breaks the cavity
  corner into a ~2 mm slit — required so the nub can reach through), back
  12.0, half-width 3.7 (1.2 mm side gaps), ≥1.6 mm opaque skin (`pocket_skin`)
  on every outside face. No ambient light path into the chamber.
- **Anchor tower**: the chamber walls stop at `chamber_depth` (< holder_depth)
  so most of the cuvette is exposed for grabbing, but a corner column rises
  to the plate-top plane (z=40) purely to give the tongue its hinge height.
- **Optics**: 6 mm window through both ±x walls at `window_z = 20`;
  `floor_thick = 5` puts the beam 15 mm above the cuvette bottom (standard
  Z-dimension).
- **Walls**: 6 mm thick (opaque, and thick enough to fully enclose the clip
  pocket). The body's four vertical corner edges are chamfered to
  `corner_flat_d = pocket_back + pocket_skin` so the corners don't obscure
  the PCB mounting holes at y=±13.
- **PCB mounts**: plates on ±x for two 34×34 mm boards (KiCad design; M3
  holes on a 26×26 grid centered on the board = centered on the window).
  Four bosses (d=7) + through holes; shroud wall ring around each board
  pocket (34.6 opening) blocks stray light and aligns the board. Optional
  `header_cutaway_*` slots let a right-angle pin header on the board's edge
  exit sideways (board installed rotated 90°, which the symmetric hole grid
  allows).
- **Base plate**: rounded 3 mm plate flush with the shrouds in x, with two
  ear strips (±y) carrying four board-mounting holes (`mount_hole_d`).
- **View modes** (holder9): `view_mode = "solid" | "xray" | "cutaway"` and
  `show_ghosts` — xray ghosts the shell (`%`, preview-only) around a crimson
  tongue; cutaway carves the corner open (real geometry, exportable).
  CLI: `openscad -D 'view_mode="xray"' holder9.scad`.

## Printing (important)

**holder10 and later: print RIGHT SIDE UP** (base plate on the bed). The
tongue is hinged at the bottom (root fused into the chamber floor), so it
builds base-first and the sealed pocket needs no support; nothing else
overhangs. Only the shroud top segments (~35 mm) bridge.

**holder4 through holder9: print upside down** (plate/shroud tops on the
bed) — their tongue hangs from a top anchor, and support inside the sealed
pocket could never be removed, so right-side-up printing is broken by design
for those files. Flipped, support the chamber rim and base ears (external,
reachable).

## Verification recipes that worked well

- **Single-solid check**: `openscad -o out.stl file.scad` and look for
  `Volumes: 2` in the CGAL output (2 = outer space + one connected part;
  3+ means something is floating).
- **Clearance / interference proofs by boolean probe**: intersect a
  translated copy of the moving part (or a probe cube / oversized test
  board / seated cuvette block) with the solid; "Current top level object
  is empty" proves clearance, and running a sweep of offsets brackets the
  exact contact point. Used for: tongue spring-back room, nub preload depth,
  hole positions, board pocket fit.
- **Sections**: `projection(cut=true) translate([0,0,-z]) part();` for
  horizontal slices; `intersection()` with a thin slab (rotated -45° for the
  clip diagonal) for vertical sections. Render PNGs with
  `--projection=o --camera=...`.
- `use <file.scad>` imports modules but NOT top-level calls or variables,
  and is NOT transitive — test harness .scad files must `use` every file
  whose modules they call, and redefine any needed constants.

## OpenSCAD gotchas hit in this project

- **Coincident faces weld**: a union where two parts merely touch on a plane
  fuses them (this once welded the tongue's bounds-trimmed edge to a PCB
  plate, freezing the spring — fixed with clearance recesses, later made
  moot by thick walls). Watch for flush faces near moving parts.
- `%` excludes from render/export; `color(..., alpha)` does NOT — ghosts
  must use `%` (optionally `%color(...)` to keep a tint) or they end up in
  the STL.
- F5 preview lies about coplanar/difference faces (z-fighting, phantom
  sheets); `--render` gives geometric truth but flattens colors. Offsetting
  a decorative cut 0.3 mm off a shared plane fixes preview artifacts.
- Top-level variables are evaluated in file order — a variable can't
  reference one defined later in the file.
- Modifying `holder_depth`-style shared constants: several files must keep
  their copied parameter blocks in sync (`holder2`→`holder2_mounted`,
  headers note "must match"); holder6+ are self-contained to avoid this.

## Lineage

| file | added |
|---|---|
| holder.scad | user's original: cavity, rods, window, corner cut idea |
| holder2.scad | springy corner clip (tongue + nub + notch) |
| holder2_mounted.scad | PCB mounting plates with bosses |
| holder3.scad | light shrouds around the boards |
| holder4.scad | thick walls → fully internal light-tight clip pocket; corner chamfers |
| holder5.scad | base plate with mounting ears |
| holder6.scad | consolidation: fully standalone file (holder6_a: user variant) |
| holder7.scad | optional shroud header cutaways |
| holder8.scad | 15 mm beam height (floor 5), chamber shortened for cuvette grabbing |
| holder9.scad | view modes (xray/cutaway), clip anchor tower, nub back at beam height |
| holder10.scad | bottom-hinged spring (prints right side up, tower removed), fatter nub (r=2, back-flattened), preload 0.6, thicker rods (r=0.75); response to holder9 print test (grip too loose) |
| holder11.scad | flat block nub tangent to the cuvette corner (45° wedge slide on top, chamfer below); response to holder10 print test (round nub gave the corner two stable positions) |
| holder12.scad | ±y walls shaved to 3 mm above the pocket roof for nut access (superseded by holder13's approach) |
| holder13.scad | based on holder11 (no shave): captive hex-nut insets (5.8 AF × 2.6 deep) in each plate's inner face at all 8 holes; nuts press in once, screws drive from the board side |
| holder14.scad | nub block raised (nub_z_lo 12→15) and its underside wedge steepened to 1.5:1 (~56°) for a cleaner right-side-up print |
| holder15.scad | pressing face widened 3→7 mm (print-rounded edges were inside the slit and caused residual bistability); pocket gains a shallow wide front zone to house it without thinning the corner's opaque skin |
| v2/holder16.scad | holder15 with wall_width 5 (NB: leaves only ~0.47 mm skin over the pocket's deep corners — the pocket was sized for 6 mm walls) |
| v2/holder15_short_one_side.scad | holder15 with the +x (two-rod) wall thinned to `short_wall` (2 mm), bringing that board 4 mm closer to the cuvette; chamber internals verified geometrically IDENTICAL to holder15 (boolean XOR over the chamber region is empty); mount either PCB on the short side — the clip corner marks the long (−x) side |

## Wooden case (`wooden_case/`)

Finger-jointed plywood enclosure for the v1 holder plus the UV-Control
board (115×46, mount holes on a 108×39 grid, micro-USB on the board's long
"top" edge, SSD1306 display, buttons wired to its A/B/C pads). Two
versions: `v1/case1.scad` hangs the board under the lid (display soldered
on headers showing through a lid window); `v2/case2.scad` — display,
buttons, and holder PCBs are all on CABLES, so the
board mounts flat on the case floor on `board_lift` standoffs (hole grid
in the bottom panel, USB slot near the floor), the lid window gets M2
mount holes for the cabled SSD1306 module and can go anywhere, and the
buttons are free too (but their ~20 mm bodies hang over the board's front
edge — see the note at `button_z`); `v3/case3.scad` is the current
direction — v2 minus all lid fasteners: the walls repeat their bottom-edge
"square wave" tabs on their TOP edges and the lid gets the same slots as
the bottom panel (shared `edge_slots(fit)` module; `slot_fit` adds lid-slot
clearance, 0 = kerf-snug), so the lid PRESS-FITS on dry, helped by the
snug holder opening (`v3_shorter/case3_shorter.scad`: same, but the lid
lands flush with the CHAMBER TOP RIM instead — `hold_top = 38` = base 3 +
chamber_depth 35, so `Hi = hold_top − t`, the plates/shrouds poke 5 mm up
through the lid bands, 5 mm more cuvette is grabbable, and `button_z`
drops 21→19 for margin in the shorter wall); `v4/case4.scad` +
`v4/post4.scad` is the current
direction — v3's square-wave lid plus four M3 screws into 3D-PRINTED
NUT-CARRIER POSTS (print 4): each post hangs on a front/back wall via a
tab through an 8×8 lasered slot at z (Hi−14)..(Hi−6), top face flush at
the wall top, M3 nut slid in captive from the inside (holder15-style),
M3×14 down through the lid; glueless, posts slim (post_d 8) to clear the
board footprint, print the post lying on a side face. Shared facts:

- Origin: plan center, z=0 at the interior floor. Interior height is
  `Hi = hold_h - t` so the lid's OUTER face is exactly flush with the
  holder top (43) — the defining constraint of the case. Holder stands on
  the floor at `holder_cx` (left end), screwed through its base ears
  (holes at holder_cx±12, y=±23.8), and rises through a lid opening. In
  v1 the opening is loose all around; in v2 it is a CROSS: longitudinally
  snug (open_l = hold_base_x + 2*open_fit, so the ±x edges clamp the
  holder's shroud/board faces; kerf-tune open_fit) with four small relief
  notches at y=±13 for the PCB screw heads (they stick ~3 mm past those
  faces into the lid thickness); full open_w width only over the
  plate/shroud bands, while the middle narrows to an octagon hugging the
  chamber walls + corner chamfers (chamber_hw/chamber_corner_d), covering
  the former open corridors above the chamber on the ±y sides. v2's lid has no display
  mounting holes — just the window (module fixed with tape/glue/bezel).
- Board's KiCad top edge (USB) faces +y (back panel) in both versions.
- Lid is removable. v1: screws into four glued-in corner strips (offcuts
  of the same ply) at `lid_scr`. v2: T-SLOT CAPTIVE NUTS — each front/back
  wall top edge has a T-slot (channel `tslot_chan_w`, nut cross-slot
  `tslot_nut_w`×`tslot_nut_t`, depths derived from `lid_screw_len` − t)
  holding an M3 nut; M3×16 machine screws drive down through the lid.
  Sheet-thickness independent (works at 1/8"; edge-screwing ply directly
  was rejected — M3 OD ≈ 3.0 vs 3.2 mm edge would split/strip). v3: no
  fasteners — press-fit onto the walls' top-edge tabs. v4: v3's tabs for
  location + M3 screws into printed hanging nut-carrier posts for
  retention.
- `mode="flat"` lays out all six panels in 2D for DXF/SVG export;
  `mode="3d"` is the assembly with `%` ghosts.
- Verified (same boolean recipes): all panel-pair intersections are exact
  mating faces (zero volume), holder and board clear all wood and blocks.
- **UNVERIFIED against hardware**: display window, USB slot, and button
  positions/diameter are estimates marked ADJUST in the file — measure the
  real board/buttons before cutting.

## Conventions

- STLs are generated artifacts; commit them only deliberately (e.g., a known
  good print of the current holder). Sources of truth are the .scad files.
- Commit only when the user asks.
