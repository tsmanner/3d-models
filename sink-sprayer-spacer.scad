include <common.scad>

inner = 19.5;
outer = 34;
// gap = 11;
gap = outer;
dz = 5.5;
thickness = 0;

$fn = 128;


module slopeWedge() {
  translate([outer/2, -outer/2, 0])
  rotate([0, -90, 0])
  linear_extrude(outer)
    polygon([
      [dz,       0],
      [dz, outer],
      [      0, outer],
    ]);
}


difference() {
  cylinder(d=outer, h=thickness+dz);
  translate([0, 0, thickness])
    slopeWedge();
  cylinder(d=inner, h=thickness+dz);
  translate([-gap/2, 0, 0]) cube([gap, outer/2, dz+thickness]);
}
