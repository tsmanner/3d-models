aa_d = 14.25;
aa_h = 50.25;
aaa_d = 10.25;
aaa_h = 44;


module battery(d, h) {
  rotate([-90, 0, 0]) cylinder(h=h, d=d, $fn=64);
}


module batteries(d, h, rows, cols, padding) {
  _h = h / 2 + padding;
  translate([d / 2 + padding, _h, d / 2 + padding])
    minkowski() {
      battery(d + 2 * padding, _h);
      rotate([90, 0, 0])
        linear_extrude(_h)
          polygon([
            [                 0               ,                        0],
            [         (rows - 1) * d * sin(30), (cols - 1) * d * cos(30)],
            [(rows - 1) * (d + d * sin(30))   , (cols - 1) * d * cos(30)],
            [(rows - 1) * d                   ,                        0]
          ]);
    }
}


difference() {
  batteries(aa_d, aa_h, 4, 4, 2);
  translate([2, 2, 2])
    batteries(aa_d, aa_h, 4, 4, 0);
  translate([aa_d / 2 + 2, 0, aa_d / 2 + 2])
    battery(aa_d, aa_h + 4);
}
