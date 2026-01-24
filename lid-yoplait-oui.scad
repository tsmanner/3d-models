$fn=256;
// $fn=64;

inner_d = 55;
outer_d = 67;

upper_th = 3;
lower_th = 5;

groove_id = 46;
groove_od = 57;
groove_depth = 1;

oring_th = 2;
oring_depth = 1.5;
oring_id = inner_d - (2 * oring_depth);
oring_offset = 1;

module oring() {
  rotate_extrude()
    translate([oring_id / 2, 0])
      square([oring_depth, oring_th]);
}

module groove() {
  groove_width = (groove_od - groove_id) / 2;
  rotate_extrude()
    translate([groove_id / 2, 0])
      square([groove_width, groove_depth]);
}

module lid() {
  difference() {
    union() {
      translate([0, 0, lower_th])
        cylinder(d=outer_d, h=upper_th);
      cylinder(d=inner_d, h=lower_th);
    }
    translate([0, 0, lower_th + upper_th - groove_depth])
      groove();
    translate([0, 0, lower_th - oring_th - oring_offset])
      oring();
  }
}

// groove();
lid();
// oring();
