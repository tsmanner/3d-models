peg_h = 2.5;
peg_d = 3;
peg_hole_h = 2.25;
peg_hole_d = 3.75;
peg_stop_h = 2;
peg_stop_d = 5;

$fn = 128;

translate([0, 0, peg_stop_h]) {
    translate([0, 0, peg_hole_h]) {
        cylinder(d=peg_d, h=peg_h);
    }
    cylinder(d=peg_hole_d, h=peg_hole_h);
}
cylinder(d=peg_stop_d, h=peg_stop_h);
