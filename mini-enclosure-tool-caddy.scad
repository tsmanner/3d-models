$fn = 64;

use <hardware.scad>

th        =    3;
window_th =    1.5;
window_w  =  124;
window_h  =   33;
flat_w    =  110;
hanger_l  = window_th + th;
hanger_w  =   10;
hanger_h  = th + th;
hanger_dy = (window_w - flat_w) / 2;
hole_dz   = -  3.5;
// Interior caddy dimensions
width     =  window_w - th - th;
length    =   30;
depth     =  100;

// Screw(3, screw_l = 11, head_l = 3, head_d = 5.5, head_padding = 5);
// Hex(5.5, 2.5);

module CaddyInnerProfile() {
  square([length, width]);
}

module CaddyOuterProfile() {
  offset(th) {
    CaddyInnerProfile();
  }
}

module CaddyProfile() {
  difference() {
    CaddyOuterProfile();
    CaddyInnerProfile();
  }
}

module Caddy() {
  translate([th, th]) {
    translate([0, 0, th])
      linear_extrude(depth)
        CaddyProfile();
    linear_extrude(th)
      CaddyOuterProfile();
  }

  translate([
    -hanger_l,
    hanger_dy,
    depth - window_h + hanger_h
  ])
    Hanger();

  translate([
    -hanger_l,
    window_w - hanger_w - hanger_dy,
    depth - window_h + hanger_h
  ])
    Hanger();
}

module Hanger() {
  difference() {
    cube([hanger_l, hanger_w, hanger_h]);
    translate([hanger_l - window_th, -1, -1])
      cube([window_th, hanger_w + 2, th + 1]);
  }
}


difference() {
  Caddy();

  translate([-1, window_w / 2, depth + th - window_h + hanger_h + hole_dz])
    rotate([0, 90, 0])
      Screw(3, screw_l = 11, head_l = 3, head_d = 5.5, head_padding = 5);
}
