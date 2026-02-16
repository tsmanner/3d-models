$fn = 128;

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
hole_h = 3.25;
hole_h1 = 2.25;
hole_h2 = hole_h - hole_h1;
hole_base_d = 11;
hole_base_r = hole_base_d / 2;
hole_base_w = 16.5;
// Distance from the edge of the deck to the opening.
hole_dx = 36.5;
// Distance from the bottom of the deck to the center of the hole.
hole_dy = 13.35 - hole_r;
// Center to center distance between the holes.
hole_spacing = 118;

mount_r = 11;
mount_d = mount_r * 2;

blade_dy = 23;
// From the front hole.
blade_dz = -45.5;

module Blade(h) {
  rotate([0, 90, 0]) cylinder(d = 87, h = h);
}

module TrackInterface(h) {
  translate([0, wFrame("25") / 2, 0]) 
    rotate([0, 0, -90])
      linear_extrude(h) Channel("25");
}

module DeckInterface(h) {
  bot_x = lip_dx;
  top_x = 2.25;
  union() {
    dx = deck_th;
    dy = deck_th + deck_r;
    translate([dx, dy, 0]) {
      cube([bot_x, lever_h - dy, h]);
    }
  }
  union() {
    dy = deck_h;
    translate([0, dy, 0]) {
      cube([top_x, lever_h - dy, h]);
    }
  }
  union() {
    dx = deck_th + deck_r;
    dy = deck_th + deck_r;
    translate([dx, dy])
      cylinder(r = deck_r, h = h);
  }
  union() {
    dx = deck_th + deck_r;
    dy = deck_th;
    translate([dx, dy])
      cube([bot_x - deck_r, deck_r, h]);
  }
}

module Interface(h) {
  TrackInterface(h);
  DeckInterface(h);
}

module NutSlot() {
  e2e = 8;
  x = 3.25;
  z = e2e;
  translate([
    (lip_dx + deck_th - x) / 2,
    hole_dy - rHex(e2e),
    -z / 2
  ]) {
    cube([x, hole_dy + mount_r + 1, z]);
  }
  // Bolt hole, lag bolts are ~75mm long.
  translate([0, hole_dy, 0])
    rotate([0, 90, 0])
      cylinder(d = dThread("6-32"), h = 75);
}

module RearPylonTop() {
  translate([0, hole_dy, 0]) {
    intersection() {
      rotate([0, 90, 0])
        cylinder(r = mount_r, h = hole_dx + hole_h);
      translate([0, 0, -mount_r])
        cube([hole_dx + hole_h, mount_r, mount_d]);
    }
  }
}

// Offset by deck_th + deck_r to get out of the way of the deck edge.
module RearPylonBot() {
  h = hole_dy - deck_th;
  dx = deck_th + deck_r;
  translate([dx, deck_th, -mount_r]) cube([hole_dx - dx + hole_h, h, mount_d]);
}

module RearPylon() {
  difference() {
    union() {
      TrackInterface(mount_r);
      intersection() {
        DeckInterface(mount_r);
        cube([deck_th + deck_r, hole_dy, mount_r]);
      }
      translate([0, 0, mount_r]) {
        RearPylonTop();
        RearPylonBot();
      }
    }
    translate([hole_dx, hole_dy, mount_r]) rotate([0, 90, 0]) cylinder(d = hole_d, h = hole_h1);
    translate([hole_dx + hole_h1, hole_dy, mount_r]) {
      rotate([0, 90, 0]) {
        linear_extrude(hole_h2 + 1) {
          circle(d = hole_base_d);
          polygon([
            [-hole_base_r, 0],
            [ hole_base_r, 0],
            [ hole_base_w / 2, - hole_dy + deck_th - 0.1],
            [-hole_base_w / 2, - hole_dy + deck_th - 0.1],
          ]);
        }
      }
    }
  }
}

module FrontPylon() {
  translate([0, 0, mount_d]) mirror([0, 0, 1]) RearPylon();
}


difference() {
  union() {
    translate([0, 0, mount_r]) Interface(hole_spacing);
    RearPylon();
    translate([0, 0, hole_spacing])
      FrontPylon();
  }
  translate([0, 0, mount_r]) {
    NutSlot();
    translate([0, 0, hole_spacing]) NutSlot();
    translate([deck_th + lip_dx, blade_dy, hole_spacing + blade_dz])
      Blade(hole_dx);
  }
}

