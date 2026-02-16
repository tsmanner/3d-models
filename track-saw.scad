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

mount_dx = 39.25;
front_mount_r = 12;
front_mount_d = front_mount_r * 2;
rear_mount_r = 10;
rear_mount_d = rear_mount_r * 2;

hole_d = 6.25;
hole_r = hole_d / 2;
hole_h = 3.25;
hole_h1 = 2.25;
hole_h2 = hole_h - hole_h1;
hole_base_d = 12;
hole_base_r = hole_base_d / 2;
hole_base_w = 15.5;
// Distance from the bottom of the deck to the center of the hole.
hole_dy = 13.35 - hole_r;
// Center to center distance between the holes.
hole_spacing = 118;

blade_d = 87;
blade_dy = 23;
// From the front hole.
blade_dz = 45.5;

module Blade(h) {
  rotate([0, 90, 0]) cylinder(d = blade_d, h = h);
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
    cube([x, 50, z]);
  }
  // Bolt hole, lag bolts are ~75mm long.
  translate([0, hole_dy, 0])
    rotate([0, 90, 0])
      cylinder(d = dThread("6-32"), h = 75);
}

module Pylon(r) {
  difference() {
    union() {
      TrackInterface(r);
      intersection() {
        DeckInterface(r);
        cube([deck_th + deck_r, hole_dy, r]);
      }
      translate([0, 0, r]) {
        translate([0, hole_dy, 0]) {
          intersection() {
            rotate([0, 90, 0])
              cylinder(r = r, h = mount_dx);
            translate([0, 0, -r])
              cube([mount_dx, r, r * 2]);
          }
        }
        translate([deck_th + deck_r, deck_th, -r])
          cube([mount_dx - deck_th - deck_r, hole_dy - deck_th, r * 2]);
      }
    }
    translate([mount_dx - hole_h, hole_dy, r]) {
      rotate([0, 90, 0]) {
        linear_extrude(hole_h1 + 1) {
          circle(d = hole_d);
          translate([-hole_r, -hole_dy]) square([hole_d, hole_dy]);
        }
      }
    }
    translate([mount_dx - hole_h2, hole_dy, r]) {
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
  difference() {
    Pylon(front_mount_r);
    translate([deck_th + lip_dx, blade_dy, front_mount_r + blade_dz])
      Blade(mount_dx + 1);
    translate([mount_dx - hole_h2, 0, front_mount_r - hole_base_r])
      cube([5, front_mount_d, front_mount_d]);
    translate([-0.1, lever_h, 0])
      cube([mount_dx + 1, 20, front_mount_d]);
  }
}

module RearPylon() {
  mirror([0, 0, 1]) Pylon(rear_mount_r);
}


difference() {
  union() {
    translate([0, 0, front_mount_r])
      Interface(hole_spacing);
    FrontPylon();
    translate([0, 0, front_mount_r + hole_spacing + rear_mount_r])
      RearPylon();
  }
  translate([0, 0, front_mount_r]) {
    NutSlot();
    translate([0, 0, hole_spacing]) NutSlot();
  }
}

