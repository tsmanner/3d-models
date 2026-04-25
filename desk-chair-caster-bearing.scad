$fn = 64;

id = 11.5;
od = 14 + 1/3;
// h = 19;

w = 40;
d = 15;
th = 4.5;
collar_th = 2.5;

s_d1 = 7;
s_d2 = 3.5;
s_h1 = 2/3;
s_h2 = 3 - s_h1;

s_dxy = w / 2 - s_d1;

module screw() {
  translate([0, 0, -1])
    cylinder(d = s_d1, h = s_h1 + 1);
  translate([0, 0, s_h1])
    cylinder(d1 = s_d1, d2 = s_d2, h = s_h2);
  cylinder(d = s_d2, h = th + 1);
}

module platform() {
  difference() {
    translate([-w/2, -w/2])
      cube([w, w, th]);
    translate([0, 0, -1])
      cylinder(d = id, h = th + 2);
    translate([ s_dxy,  s_dxy]) screw();
    translate([ s_dxy, -s_dxy]) screw();
    translate([-s_dxy,  s_dxy]) screw();
    translate([-s_dxy, -s_dxy]) screw();
  }
}

module shaft(h) {
  difference() {
    cylinder(d = od, h = h);
    translate([0, 0, -1])
      cylinder(d = id, h = h + 2);
  }
}

module top() {
  platform();
  translate([0, 0, th])
    shaft(10);
}

module bot() {
  difference() {
    platform();
    translate([0, 0, -1])
      cylinder(d = d, h = collar_th + 1);
  }
  translate([0, 0, th])
    shaft(5);
}

top();
// bot();
