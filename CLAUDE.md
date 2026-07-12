# cuvette-three-point

3D-printed cuvette holder for a DIY colorimeter, designed in OpenSCAD. A
12.5 mm square cuvette drops into a chamber and is pressed by a printed
spring clip against three registration rods, so it seats in exactly the same
position every insertion ("three-point" kinematic registration). Emitter and
detector PCBs mount on opposite faces, aligned with an optical window through
the chamber at cuvette mid-height.

`holder9.scad` is the current design. The numbered files are the design
history, each stage self-contained and renderable (see Lineage below); when
making changes, work on the latest file (or a new `holderN+1.scad` if the
user asks for a new stage — that has been the pattern).

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
| holder14.scad | **current** — nub block raised (nub_z_lo 12→15) and its underside wedge steepened to 1.5:1 (~56°) for a cleaner right-side-up print |

## Conventions

- STLs are generated artifacts; commit them only deliberately (e.g., a known
  good print of the current holder). Sources of truth are the .scad files.
- Commit only when the user asks.
