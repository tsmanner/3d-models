include <common.scad>

d = 19;
base = 1;
border = 1.5;
pass_w = 4;

$fn = 128;

module cartridge() {
    translate([0, 0, d/2]) {
        sphere(d=d);
        cylinder(d=d, h=d+1);
    }
}

module holders(counts) {
    difference() {
        cube([counts.x*d + 2*border, counts.y*d + 2*border, d + base]);
        // Create each set of cylinder holder
        for (x = [0 : counts.x - 1], y = [0 : counts.y - 1])
            translate([border + d/2 + x*d, border + d/2 + y*d, base]) cartridge();
        // X axis pass-throughs between cells.
        for (x = [1 : counts.x - 1], y = [0 : counts.y - 1])
            translate([border + d*x, border + d/2 + d*y, base + d/3]) ccube([2, pass_w, d + 1]);
        // Y axis pass-throughs between cells.
        for (x = [0 : counts.x - 1], y = [1 : counts.y - 1])
            translate([border + d/2 + d*x, border + d*y, base + d/3]) ccube([pass_w, 2, d + 1]);
    }
}

holders([5, 8]);
