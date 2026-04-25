$fn = 64;

dx = 106;
dy =   2;
dz =  45;

r = 5;

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
