use <hardware.scad>

$fn = 128;

inside_th = 4;
outside_th = 1;

overhang = 3;
hole_e2e = 62;
lip_e2e = overhang + hole_e2e + overhang;

panel_th = 1.46;

metal_th = 1.25;
metal_dy = hole_e2e / 2 - 8.5;

ethernet_l = 27;
ethernet_stem_d = 25;
ethernet_flat_d = 23.25;

ethernet_face_th = 2.5;
ethernet_face_d = 31;


module ccube(dims) {
  translate([-dims.x / 2, -dims.y / 2]) cube(dims);
}

module EthernetStem(h) {
  intersection() {
    cylinder(d = ethernet_stem_d, h = h);
    ccube([ethernet_flat_d, ethernet_stem_d, h]);
  }
}

module EthernetFace(h) {
  cylinder(d = ethernet_face_d, h = h);
}

module Oct(e2e, h, center = [false, false, false]) {
  dx = center.x ? 0 : e2e/2;
  dy = center.y ? 0 : e2e/2;
  dz = center.z ? -h/2 : 0;
  translate([dx, dy, dz]) {
    intersection() {
      translate([-e2e / 2, -e2e / 2]) cube([e2e, e2e, h]);
      rotate([0, 0, 45])
        translate([-e2e / 2, -e2e / 2]) cube([e2e, e2e, h]);
    }
  }
}

module Hole(h) {
  Oct(hole_e2e, h, [true, true, false]);
}

module Lip(h) {
  Oct(lip_e2e, h, [true, true, false]);
}


module Outside() {
  difference() {
    union() {
      translate([0, 0, outside_th]) {
        difference() {
          Lip(metal_th);
          translate([-lip_e2e / 2, metal_dy, -1])
            cube([lip_e2e, lip_e2e, metal_th + 2]);
        }
      }
      Lip(outside_th);
      Hole(panel_th / 2 + metal_th + outside_th);
    }
    translate([0, 0, -1]) EthernetStem(panel_th / 2 + metal_th + outside_th + 2);
  }
}


module Inside() {
  difference() {
    union() {
      Lip(inside_th - panel_th / 2);
      Hole(inside_th);
    }
    translate([0, 0, -1]) EthernetStem(inside_th + 2);
  }
}

// translate([ lip_e2e/2 + 2, 0])
//   Inside();
// translate([-lip_e2e/2 - 2, 0])
  Outside();
