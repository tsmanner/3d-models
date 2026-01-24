$fn = 32;

th = 3;

kvm_dz = 160;
kvm_dy = 100;
kvm_dx = 42.25;

leg_width = 70;
leg_thickness = 40.5;
leg_weld_r = 4;
leg_support_dy = 150;
leg_support_dz = 50;

module leg() {
  // translate([0, 0, kvm_dz]) {
    // Horizontal
    translate([0, 0, -leg_thickness])
      cube([leg_width, 500, leg_thickness]);
    // Vertical
    translate([0, -0.1, -500])
      cube([leg_width, leg_thickness + 0.1, 500]);
    // Desk support
    translate([0, leg_support_dy, 0])
      cube([leg_width, leg_thickness, leg_support_dz]);
    // Weld
    translate([0, leg_thickness, -leg_thickness])
      rotate([0, 90, 0])
        cylinder(r=leg_weld_r, h=leg_width);
  // }
}

module kvm() {
  // KVM Body, overshoot by a tiny amount to render more cleanly
  translate([0, -0.1, 0])
    cube([kvm_dx, kvm_dy + 0.1, kvm_dz]);
  // KVM port clearance
  translate([th, kvm_dy - 0.1, th])
    cube([kvm_dx - th - th, 10, kvm_dz - th - th]);
}

module kvm_part() {
  difference() {
    cube([th + kvm_dx + th, kvm_dy + th, th + kvm_dz + th]);
    translate([th, 0, th])
      kvm();
  }
}

module leg_part() {
  difference() {
    union() {
      // Vertical back support
      // translate([0, leg_thickness, -kvm_dz - th])
      //   cube([th, th, kvm_dz - leg_thickness + th]);
      // Horizontal under support
      // translate([0, 0, -leg_thickness - th])
      //   cube([th, kvm_dy + th, th]);
      // Over-leg hanger
      translate([0, 0, -leg_thickness])
        cube([leg_width + th, kvm_dy + th, leg_thickness + th]);
    }
    leg();
  }
}

kvm_part();
translate([th + kvm_dx + th, 0, th + kvm_dz])
// leg();
leg_part();
