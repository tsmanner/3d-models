include <measurements.scad>

ccube([3*die_w+2*thickness, 3*die_w+2*thickness, thickness]);
translate([0, 0, thickness]) ccube([3*die_w, 3*die_w, thickness]);
