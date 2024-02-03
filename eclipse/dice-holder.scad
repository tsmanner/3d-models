include <measurements.scad>

difference() {
    ccube([3*die_w+2*thickness, 3*die_w+2*thickness, 2*die_w+2*thickness]);
    translate([0, 0, thickness]) ccube([3*die_w, 3*die_w, 2*die_w+2*thickness]);
}
