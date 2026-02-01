$fn = 32;

function hex_d(e2e) = e2e / sin(60);
function hex_r(e2e) = hex_d(e2e) / 2;

board_w = 12;
board_th = 1.6;
board_dz = 5;
board_dx = 32.75;

hole1_x = 9.2;
hole1_y = 3;
hole1_dx = 1.75;

module hole1(th) {
  $fn = 32;
  d = hole1_y;
  translate([d/2, 0]) {
    hull() {
      cylinder(d=d, h=th);
      translate([hole1_x - d, 0])
        cylinder(d=d, h=th);
    }
  }
}

module front() {
  x1 = 5;
  x2 = x1 + hole1_dx;
  x3 = x2 + hole1_x;
  pin_th = 0.5;
  cube([x3, board_w, board_dz]);
  translate([0, 0, board_dz])
    cube([x1, board_w, board_th]);
  translate([0, 0, board_dz + board_th])
    cube([x3, board_w, 2]);
  translate([x2, board_w / 2, board_dz + board_th - pin_th])
    hole1(pin_th);
}


// translate([0, board_w * 3])
//   front();




nut_e2e = 8;
nut_th = 3;
screw_head_d = 8;
screw_thread_d = 4;

module nut_slot() {
  screw_slot_x = 12; // ~8.5 on the board, plus tolerance.
  screw_slot_y = screw_thread_d;
  screw_slot_z = 1;
  nut_slot_x = screw_slot_x + hex_r(nut_e2e);
  x = 10 + screw_head_d/2 + nut_slot_x;
  screw_slot_dx = x - screw_slot_x;
  screw_slot_dy = (board_w - screw_slot_y) / 2;
  screw_slot_dz = board_dz - screw_slot_z;
  nut_slot_dx = x - nut_slot_x;
  nut_slot_dy = (board_w - nut_e2e) / 2;
  nut_slot_dz = board_dz - screw_slot_z - nut_th;
  difference() {
    cube([x, board_w, board_dz]);
    translate([nut_slot_dx, nut_slot_dy, nut_slot_dz])
      cube([nut_slot_x + 1, nut_e2e, nut_th]);
    translate([screw_slot_dx, screw_slot_dy, screw_slot_dz - 0.1])
      cube([screw_slot_x + 1, screw_slot_y, screw_slot_z + 1.1]);
  }
}



module back() {
  dy = -15;
  difference() {
    union() {
      translate([0, board_w + dy - screw_head_d/2, 0])
        cube([screw_head_d, screw_head_d, 2]);
      nut_slot();
    }
    translate([screw_head_d/2, board_w + dy, 0])
      cylinder(d=screw_thread_d, h=2);
    translate([screw_head_d/2, board_w + dy, 2])
      cylinder(d=screw_head_d, h=board_dz);
  }
}

back();
