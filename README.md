# cuvette-three-point

A 3D-printed cuvette holder for a DIY colorimeter, designed in OpenSCAD.

**Current design: [`v1/holder15.scad`](v1/holder15.scad) — print-tested and
working** (with a ready-to-slice [`v1/holder15.stl`](v1/holder15.stl)). A
standard 12.5 mm square cuvette drops in and seats in the same position
every insertion, with no bi-stability. The earlier `holderN` files in
[`drafts/`](drafts/) are the design history (see
[Design evolution](#design-evolution)).

## How it works: three-point registration

The core idea is kinematic registration. Three vertical rods are printed
half-embedded in the chamber walls — two on one wall (the +x side, flanking
the optical window) and one on the adjacent wall (−y). A printed leaf spring
in the opposite corner presses the cuvette diagonally into all three rods at
once, so the cuvette's position is defined by exactly three line contacts
plus the spring — over-constrained nowhere, repeatable everywhere.

The spring is a flexible tongue that lives inside a fully enclosed pocket in
the corner of the (6 mm thick, opaque) chamber wall:

- **hinged at the bottom**, its root fused into the chamber floor, so it
  prints right side up with no support inside the sealed pocket;
- carrying a **wide flat pressing block** whose face is tangent to the
  cuvette's corner (perpendicular to the corner diagonal). The face is 7 mm
  wide but the corner slit exposes only its dead-flat central ±1.9 mm, so
  the cuvette corner never touches a printed (rounded) edge — this is what
  eliminated the last trace of bi-stability;
- with a **45° wedge slide on top** of the block, so inserting the cuvette
  cams the spring open smoothly, and a steeper (~56°) wedge underneath so
  the block prints cleanly;
- preloaded 0.6 mm: a 12.5 mm cuvette deflects the spring and is held
  against the rods with roughly 2 N.

Because the pocket is internal — sealed by the floor below, solid material
above, and ≥1.6 mm of skin behind and beside it — the spring adds no
ambient-light path into the chamber. Its only opening is the narrow slit
the block presses through.

## Optics and mounting

- 6 mm **optical window** through both ±x walls; the beam passes 15 mm above
  the cuvette's bottom (a standard Z-dimension).
- **PCB mounts** on both ±x faces for 34 × 34 mm emitter and detector boards
  (M3 holes on a 26 mm grid), each board centered on the optical axis,
  recessed inside a light shroud, resting on standoff bosses.
- **Captive hex-nut insets** on each plate's inner face: press an M3 nut in
  once and drive the screws from the board side — no holding nuts in the
  tight gap. (The chamber's corner edges are chamfered so they don't obscure
  the holes.)
- **Base plate** with two ears for screwing the whole assembly to a board.
- The chamber is deliberately shorter than the plates, leaving most of a
  45 mm cuvette exposed to grab.

## Printing

Print **right side up** (base plate on the bed), no support material needed:
the bottom-hinged spring builds base-first inside its pocket, and the only
bridges are the small pocket ceiling and the shrouds' top segments.
Suggested: opaque (ideally black) filament for stray-light rejection.

## Using the OpenSCAD file

Everything is parametric; the interesting knobs are at the top of
`v1/holder15.scad` (`clip_preload` for grip force, `nut_af` for nut fit,
`mount_hole_d` for base screws, etc.). Two view helpers:

- `view_mode = "xray"` — spring drawn solid inside a transparent shell
  (preview/F5 only);
- `view_mode = "cutaway"` — corner carved open to expose the spring
  (real geometry, exportable);
- `show_ghosts = true` — translucent cuvette and PCBs for fit checking.

## Design evolution

Each `holderN.scad` in `drafts/` is self-contained and renderable; changes
were driven by print-and-test cycles:

| file | change |
|---|---|
| holder | original cavity + rods + window concept |
| holder2–3 | corner spring clip; PCB plates; light shrouds |
| holder4–5 | thick walls → fully internal light-tight spring pocket; base plate |
| holder6–7 | consolidated standalone file; optional header cutaways |
| holder8–9 | 15 mm beam height; shortened chamber for grabbing; view modes |
| holder10 | bottom-hinged spring (prints right side up); firmer preload; thicker rods |
| holder11 | flat block face replaces round nub (fixed two stable positions) |
| holder12 | (superseded) wall shave for nut access |
| holder13 | captive hex-nut insets instead |
| holder14 | block raised; steeper under-wedge for cleaner printing |
| **holder15** | **face widened to 7 mm so contact never reaches printed edges — bi-stability gone; print-tested, working** |
