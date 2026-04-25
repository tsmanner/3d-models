$fn = 64;

dx = 51;
dy =  1.5;
dz = 27;

r = 4;

rotate([90, 0, 0]) {
  translate([0, 0, r])
    cube([dx, dy, dz - r]);
  translate([r, 0, 0])
    cube([dx - r - r, dy, r]);
  translate([r, 0, r])
    rotate([-90, 0, 0])
      cylinder(r = r, h = dy);
  translate([dx - r, 0, r])
    rotate([-90, 0, 0])
      cylinder(r = r, h = dy);
}
