d = 3.25;
dz = 5;
flange_dz = 1.5;

translate([0, 0, dz/2])
    cylinder(h = dz, r = d/2, center = true, $fn = 64);
translate([0, 0, -flange_dz/2])
    cylinder(h = flange_dz, r = d/2 + 1, center = true, $fn = 64);
