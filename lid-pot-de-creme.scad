$fn=256;
// $fn=64;

inner_d = 57;
outer_d = 68;

upper_th = 3;
lower_th = 5;

recess_id = 50;
recess_od = 61.5;
recess_depth = 1;

oring_th = 2;
oring_depth = 1.5;
oring_od = inner_d + oring_depth;
oring_d = oring_od - oring_depth;
oring_r = oring_d / 2;
oring_offset = 1;

module oring() {
  rotate_extrude()
    translate([oring_r - oring_depth, 0])
      square([oring_depth, oring_th]);
}

module recess() {
  recess_width = (recess_od - recess_id) / 2;
  rotate_extrude()
    translate([recess_id / 2, 0])
      square([recess_width, recess_depth]);
}

module lid() {
  difference() {
    union() {
      translate([0, 0, lower_th])
        cylinder(d=outer_d, h=upper_th);
      cylinder(d=inner_d, h=lower_th);
    }
    translate([0, 0, lower_th + upper_th - recess_depth])
      recess();
    translate([0, 0, lower_th - oring_th - oring_offset])
      oring();
  }
}

// recess();
lid();
// oring();
