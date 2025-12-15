$fn = 64;

spacer_dx = 50;
spacer_dy = 12;
spacer_dz = 8;

screw_d = 4;
screw_d1 = 3.5;
screw_d2 = 7.75;
screw_thread_l = 5;
screw_head_l = 3;
screw_l = screw_thread_l + screw_head_l;

module screw() {
  cylinder(d=screw_d, h=screw_l);
  translate([0, 0, screw_thread_l])
    cylinder(d1=screw_d1, d2=screw_d2, h=screw_head_l);
  // Add a cylinder for the head to clear the rest of the object, with some tolerance (10%).
  translate([0, 0, screw_l])
    cylinder(d=screw_d2 * 1.1, h=spacer_dy);
}

difference() {
  union() {
    translate([0, 0, 25 - spacer_dz]) {
      cube([spacer_dx, spacer_dy, spacer_dz]);
    }
    cube([spacer_dx, 2, 25]);
  }
  translate([spacer_dx / 2, 2 - screw_l, 25 / 2])
    rotate([-90, 0, 0])
      screw();
}
