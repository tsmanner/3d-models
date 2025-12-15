$fn = 64;

cart_dx = 39.4;
cart_dy = 34;
cart_dz = 4;

screw_spacing = 26;

center = [cart_dx / 2, cart_dy / 2];

screw_m4_d1 = 4;
screw_m4_d2 = 8;
screw_m4_l = 8;
screw_m4_head_l = 2.2;
screw_m4_thread_l = screw_m4_l - screw_m4_head_l;

screw_4_40_d1 = 3;
screw_4_40_d2 = 5.5;
screw_4_40_l = 9.5;
screw_4_40_head_l = 1.7;
screw_4_40_thread_l = screw_4_40_l - screw_4_40_head_l;

spacer_dz = screw_m4_head_l;


cart_length = 61.4;
spacer_to_edge = (cart_length - cart_dx) / 2;
rail_dx = 500;
travel = 285.75; // 11 1/4 inches
cart_e2e = rail_dx - travel;
spacer_e2e = cart_e2e - (spacer_to_edge * 2);


module screw_m4() {
  cylinder(d=screw_m4_d1, h=screw_m4_l);
  translate([0, 0, screw_m4_thread_l])
    cylinder(d1=screw_m4_d1, d2=screw_m4_d2, h=screw_m4_head_l);
  // Add a cylinder for the head to clear the rest of the object, with some tolerance (10%).
  translate([0, 0, screw_m4_l])
    cylinder(d=screw_m4_d2, h=cart_dy);
}


module screw_4_40() {
  cylinder(d=screw_4_40_d1, h=screw_4_40_l);
  translate([0, 0, screw_4_40_thread_l])
    cylinder(d1=screw_4_40_d1, d2=screw_4_40_d2, h=screw_4_40_head_l);
  // Add a cylinder for the head to clear the rest of the object, with some tolerance (10%).
  translate([0, 0, screw_4_40_l])
    cylinder(d=screw_4_40_d2, h=cart_dy);
}

module cart() {
  cube([cart_dx, cart_dy, cart_dz]);
}

// module spacer() {
//   difference() {
//     cube([cart_dx, cart_dy, spacer_dz]);
//     translate([center.x - screw_spacing/2, center.y - screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
//     translate([center.x - screw_spacing/2, center.y + screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
//     translate([center.x + screw_spacing/2, center.y - screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
//     translate([center.x + screw_spacing/2, center.y + screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
//   }
// }


difference() {
  // The main body of the spacer
  cube([spacer_e2e, cart_dy, spacer_dz]);
  // Downward facing screw holes to mount to the carts.  M4.
  for (center = [[cart_dx / 2, cart_dy / 2], [spacer_e2e - cart_dx / 2, cart_dy / 2]]) {
    translate([center.x - screw_spacing/2, center.y - screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
    translate([center.x - screw_spacing/2, center.y + screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
    translate([center.x + screw_spacing/2, center.y - screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
    translate([center.x + screw_spacing/2, center.y + screw_spacing/2, spacer_dz - screw_m4_l]) screw_m4();
  }
  // Upward facing screw holes to mount to the underside of the table top.  4-40
  translate([              cart_dx + spacer_to_edge + screw_4_40_d2 , cart_dy / 2 - screw_spacing / 2, screw_4_40_l]) rotate([180, 0, 0]) screw_4_40();
  translate([              cart_dx + spacer_to_edge + screw_4_40_d2 , cart_dy / 2 + screw_spacing / 2, screw_4_40_l]) rotate([180, 0, 0]) screw_4_40();
  translate([spacer_e2e - (cart_dx + spacer_to_edge + screw_4_40_d2), cart_dy / 2 - screw_spacing / 2, screw_4_40_l]) rotate([180, 0, 0]) screw_4_40();
  translate([spacer_e2e - (cart_dx + spacer_to_edge + screw_4_40_d2), cart_dy / 2 + screw_spacing / 2, screw_4_40_l]) rotate([180, 0, 0]) screw_4_40();
}

// spacer();
// translate([cart_dx, 0, 0])
//   cube([spacer_e2e - (cart_dx * 2), cart_dy, spacer_dz]);
// translate([spacer_e2e - cart_dx, 0, 0])
//   spacer();

