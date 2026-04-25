bx = 4;
bz = 2;

x = 2;
y = 4;
z = 2;

// bridge
translate([0, 0, z])
  cube([x + bx, y, z]);
// leg
cube([x, y, z]);
