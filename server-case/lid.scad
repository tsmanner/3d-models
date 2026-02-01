include <constants.scad>
include <hardware.scad>

//
// Lid
//

module lid_rim_outline() {
  support_gap = 1/2;
  x1  = support_gap;
  x2  = interior_x - support_gap;
  x1b = psu_x + support_gap;
  y1  = support_gap;
  y1b = case_screw_y1b - nut_slot_y / 2 + support_gap;
  y2  = interior_y - support_gap;
  polygon([
    [x1 , y1b],
    [x1 , y2 ],
    [x2 , y2 ],
    [x2 , y1 ],
    [x1b, y1 ],
    [x1b, y1b],
    [x1 , y1b],
  ]);
}

module lid_screw_hole() {
  translate([0, 0, -1])
    cylinder(d=screw_thread_d, h=case_th + 2);
  cylinder(d1=screw_thread_d, d2=6.5, h=2.5);
}

module lid() {
  support_gap = 1/2;
  support_w = 4;
  support_h = 4;
  rim_w = 3;
  rim_h = 3;
  x_support_dx = case_th + support_gap;
  x_support_dy = case_th + psu_y + case_th + heatsink_dy - support_w;
  y_support_dx = case_th + heatsink_dx - support_w;
  // y_support_dy = x_support_dy + support_w;
  y_support_dy = case_th + case_screw_y1b - nut_slot_y / 2 + support_gap;
  translate([0, 0, support_h]) {
    difference() {
      // The lid
      cube([exterior_x, exterior_y, case_th]);
      // Heatsink hole
      translate([case_th + heatsink_dx, case_th + psu_y + case_th + heatsink_dy, -1])
        cube([heatsink_x, heatsink_y, case_th + 2]);
      // Mounting screw holes
      translate([case_th, case_th]) {
        translate([case_screw_x1, case_screw_y1b]) lid_screw_hole();
        translate([case_screw_x1, case_screw_y2 ]) lid_screw_hole();
        translate([case_screw_x2, case_screw_y1 ]) lid_screw_hole();
        translate([case_screw_x2, case_screw_y2 ]) lid_screw_hole();
      }
    }
    // PSU power plug top insert
    translate([
      0,
      case_th + psu_y - power_y - power_dy - 0.25,
      -power_dz + 0.25
    ]) cube([case_th, power_y - 0.5, power_dz - 0.25]);
    // Rim
    translate([case_th, case_th, -rim_h]) {
      difference() {
        linear_extrude(rim_h) {
          difference() {
            lid_rim_outline();
            offset(delta=-rim_w)
              lid_rim_outline();
          }
        }
        translate([case_screw_x1, case_screw_y1b, -1]) ccube([nut_slot_x + 2*support_gap, nut_slot_y + 2*support_gap, rim_h+1]);
        translate([case_screw_x1, case_screw_y2 , -1]) ccube([nut_slot_x + 2*support_gap, nut_slot_y + 2*support_gap, rim_h+1]);
        translate([case_screw_x2, case_screw_y1 , -1]) ccube([nut_slot_x + 2*support_gap, nut_slot_y + 2*support_gap, rim_h+1]);
        translate([case_screw_x2, case_screw_y2 , -1]) ccube([nut_slot_x + 2*support_gap, nut_slot_y + 2*support_gap, rim_h+1]);
      }
    }
  }
  // Supports for rigidity
  translate([x_support_dx, x_support_dy, 0])
    cube([interior_x - support_gap - support_gap, support_w, support_h]);
  translate([y_support_dx, y_support_dy, 0])
    cube([support_w, interior_y - y_support_dy + case_th - support_gap, support_h]);
}

translate([exterior_x, 0, case_th + 4]) rotate([0, 180, 0])
  lid();
