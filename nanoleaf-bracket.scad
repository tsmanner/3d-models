bracket_th = 4;
light_th = 8.65;
post_r = 8.2;
flat_r = 40;
light_w = 205;
screw_hole_r = 2;

module half_hex(h, r) {
  difference() {
    cylinder(h=h, r=r, $fn=6);
    translate([-r, 0, 0])
      cube([r * 2, r, h]);
  }
}

module middle() {
  half_hex(h=light_th, r=post_r);
  translate([0, 0, light_th])
    half_hex(h=bracket_th, r=flat_r);
  translate([0, bracket_th, 0])
    difference() {
      rotate([0, 0, 180])
        half_hex(h=bracket_th, r=flat_r);
      translate([ 12.5, 12.5, 0])
        cylinder(h=bracket_th, r=screw_hole_r, $fn=64);
      translate([-12.5, 12.5, 0])
        cylinder(h=bracket_th, r=screw_hole_r, $fn=64);
    }
  translate([-flat_r, 0, 0])
    cube([flat_r * 2, bracket_th, light_th + bracket_th]);
}

module end2() {
  middle();
  linear_extrude(light_th)
    polygon([
      [0, 0],
      [flat_r/2, -flat_r * sin(60)],
      [flat_r, 0]
    ]);
}

module end1() {
  middle();
  linear_extrude(light_th)
    polygon([
      [0, 0],
      [-flat_r/2, -flat_r * sin(60)],
      [flat_r/2, -flat_r * sin(60)],
      [flat_r, 0]
    ]);
}


// middle();
end2();
// end1();
