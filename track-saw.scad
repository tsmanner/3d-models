$fn = 64;

use <hardware.scad>
use <t-track.scad>

deck_h = 7.5;
deck_th = 1.5;
deck_rim_h = deck_h - deck_th;
deck_r = 3;

lever_h = deck_h + 9;
lip_dx = 7.5;
bushing_th = 4.5;

hole_d = 6.25;
hole_r = hole_d / 2;
hole_h1 = 2.25;
hole_h2 = 3.25;
hole_base_od = 10;
// Distance from the edge of the deck to the opening.
hole_dx = 36.5;
// Distance from the base of the deck to the center of the hole.
hole_dy = 13.35 - hole_r;
// Center to center distance between the holes.
hole_dz = 118;

// len = hole_dz + hole_base_od;
len = 10;

module DeckInterface() {
  bot_x = lip_dx;
  top_x = 2.25;
  union() {
    dx = deck_th;
    dy = deck_th + deck_r;
    translate([dx, dy, 0]) {
      cube([bot_x, lever_h - dy, len]);
    }
  }
  union() {
    dy = deck_h;
    translate([0, dy, 0]) {
      cube([top_x, lever_h - dy, len]);
      // cube([top_x, wFrame("25") - dy, len]);
    }
  }
  union() {
    dx = deck_th + deck_r;
    dy = deck_th + deck_r;
    translate([dx, dy])
      cylinder(r = deck_r, h = len);
  }
  union() {
    dx = deck_th + deck_r;
    dy = deck_th;
    translate([dx, dy])
      cube([bot_x - deck_r, deck_r, len]);
  }
}

module NutSlot() {
  e2e = 8;
  x = 3.25;
  z = e2e;
  translate([
    (lip_dx + deck_th - x) / 2,
    hole_dy - rHex(e2e),
    (len - z) / 2
  ]) {
    cube([x, lever_h, z]);
  }
  // Bolt hole, lag bolts are ~75mm long.
  translate([deck_th, hole_dy, len / 2])
    rotate([0, 90, 0])
      cylinder(d = dThread("6-32"), h = 75);
}

translate([0, wFrame("25") / 2, 0]) rotate([0, 0, -90]) linear_extrude(len) Channel("25");
difference() {
  DeckInterface();
  NutSlot();
}
