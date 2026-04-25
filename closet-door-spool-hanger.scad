use <hardware.scad>
use <t-track.scad>

$fn = 64;

track = "25";
side = "L";
assert(side == "L" || side == "R", "side must be 'L' or 'R'");

spool_w = 67;
spool_d = 202;
spool_r = spool_d / 2;
hole_d = 50;
hole_r = hole_d /2;

hanger_h = spool_r / cos(30);

spool_dx = spool_r;
spool_dy = hanger_h / 2;
rod_d = 35;
rod_r = rod_d / 2;
rod_dx = spool_dx;
rod_dy = spool_dy + (side == "L" ? hole_r - rod_r : rod_r - hole_r);
cap_d = rod_d + 8;
cap_r = cap_d / 2;
cap_th1 = 4;
cap_th2 = 1;
cap_th = cap_th1 + cap_th2;
plat_d = hole_d + 10;
plat_r = plat_d / 2;

base_th = 5;
conn_w = 5;
conn_th = 10;

module Spool() {
  $fn = 256;
  difference() {
    cylinder(d = spool_d, h = spool_w);
    translate([0, 0, -1]) cylinder(d = hole_d, h = spool_w + 2);
  }
}

module Cap() {
  cylinder(d1 = rod_d, d2 = cap_d, h = cap_th1);
  translate([0, 0, cap_th1])
    cylinder(d = cap_d, h = cap_th2);
}

module Base() {
  difference() {
    union() {
      // Connector
      cube([conn_th, hanger_h, wFrame(track)]);
      // Base
      linear_extrude(base_th) {
        polygon([
          [ conn_th,        0],
          [spool_dx, spool_dy - plat_r],
          [spool_dx, spool_dy + plat_r],
          [ conn_th, hanger_h],
        ]);
        translate([spool_dx, spool_dy])
          circle(d = plat_d);
      }
      // Rod
      translate([rod_dx, rod_dy, base_th]) {
        cylinder(d = rod_d, h = spool_w);
        translate([0, 0, spool_w])
          Cap();
      }
    }
    // Connector
    translate([spool_dx, spool_dy, base_th]) Spool();
    translate([-1, hanger_h / 2 - hole_r, base_th]) cube([conn_th + 2, hole_d, wFrame(track)]);
    screw_l = 13;
    head_l = 3.18;
    head_d = 9;
    screw_dx = 4 - screw_l + head_l;
    screw_dy = head_d;
    screw_dz = wFrame("25") / 2;
    translate([screw_dx, screw_dy, screw_dz])
      rotate([0, 90, 0])
        Screw(5, screw_l = screw_l, head_l = head_l, head_d = head_d, head_padding = conn_th);
    translate([screw_dx, hanger_h - screw_dy, screw_dz])
      rotate([0, 90, 0])
        Screw(5, screw_l = screw_l, head_l = head_l, head_d = head_d, head_padding = conn_th);
    // Base
    translate([0, 0, -1]) {
      th = 15;
      dx = spool_dx - plat_r;
      dy1 = (th - conn_th) * (spool_dy - plat_r) / spool_dx + th;
      dy2 = dx * (spool_dy - plat_r) / spool_dx + th;
      linear_extrude(base_th + 2) {
        polygon([
          [th, dy1],
          [dx, dy2],
          [dx, hanger_h - dy2],
          [th, hanger_h - dy1],
        ]);
      }
    }
    // Rod
    translate([rod_dx, rod_dy, -1])
      cylinder(d = 2/3 * rod_d, h = base_th + spool_w + cap_th + 2);
    // Side text - 1/2mm relief
    translate([8, spool_dy, base_th - 1 / 2])
      linear_extrude(1) rotate([0, 0, side == "L" ? 0 : 180])
        text(side, valign = "center", halign = "center");
  }
}

Base();
