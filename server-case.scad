$fn = 64;


fan_d = 38;
fan_dz = 22.5;

power_z = 24;
power_x = 3.5;
power_y = 31;
power_dz = 3;
power_dy = 2.5;

vent_z = 68;
vent_x = 45;
vent_dx = 15.5;

cable_z = 21;
cable_y = 25;
cable_dz = 23;
cable_cavity_x = 20;

psu_z = 82.25;
psu_x = 150.5;
psu_y = 41.2;

screw_h = 9;
screw_head_h = 3;
screw_head_d = 9;
screw_thread_h = screw_h - screw_head_h;
screw_thread_d = 4;

case_th = 2;

nut_e2e = 8;
nut_th = 3;

ext_nut_th = 6.5;
ext_nut_e2e = 4.9;

// ─│┌┐└┘├┤┬┴┼╭╮╯╰╱╲╳╴╵╶╷
//
//
//
//        top_h
//    mobo_h  │
//         ├──├─              ┌────┐
//         │  │               │────│
//         │  │               │    │
//         │  │               │    │
//         │  │               │    │
//         │  │               │    │
//         │  └─           ┌──┘    └──┐
//         └──── ──────────┤          ├──────────
//                         │          │
//               ──────────┴──────────┴──────────
//
nut_h = max(nut_th, case_th);
mount_bot_d = case_th + hex_d(nut_e2e) + case_th;
mount_bot_r = mount_bot_d / 2;
mount_bot_h = nut_h + case_th;
mount_top_d = case_th + hex_d(ext_nut_e2e) + case_th;
mount_top_r = mount_top_d / 2;
mount_top_h = ext_nut_th + 0.5 - case_th;
mount_h = mount_bot_h + mount_top_h;

nut_slot_x = case_th + hex_d(nut_e2e);
nut_slot_y = case_th + nut_e2e;
nut_slot_z = case_th + nut_th + case_th;

hole_d = 4;

mobo_screw_x1 = 10.16;
mobo_screw_x1b = mobo_screw_x1 + 22.5;
mobo_screw_x2 = mobo_screw_x1 + 154.94;
mobo_screw_y1 = 6.35;
mobo_screw_y2 = mobo_screw_y1 + 157.48;

mobo_x = 170;
mobo_dx = 1;
mobo_y = 170;
mobo_th = 2;
mobo_h = mount_h - case_th; // Distance above the baseplate.
mobo_io_dy1 = 11.5;
mobo_io_dy2 = 6.5;
io_x = 3;
io_y = mobo_y - mobo_io_dy1 + mobo_io_dy2;
io_z = 50;
mobo_io_dz = -6;

interior_x = mobo_x + cable_cavity_x;
interior_y = psu_y + case_th + max(mobo_y + mobo_io_dy2, mobo_screw_y2 + mount_bot_r) + case_th;
interior_z = max(psu_z, mobo_h + 77 - case_th);
exterior_x = case_th + interior_x + case_th;
exterior_y = case_th + interior_y + case_th;
exterior_z = case_th + interior_z + case_th;

heatsink_x = 120;
heatsink_y = 134;
// About 8mm from +x of mobo, model is about 4mm wider than the real heatsink.
heatsink_dx = mobo_x - heatsink_x - 8 + 2;
// About 32mm from -y of mobo, model is about 4mm wider than the real heatsink.
heatsink_dy = 32 - 2;

badge_th = 1.5;
badge_w = 26;
badge_h = 26;

function hex_d(e2e) = e2e / sin(60);
function hex_r(e2e) = hex_d(e2e) / 2;

module hex(e2e, h) {
  cylinder(r=hex_r(e2e), h=h, $fn=6);
}

module screw() {
  cylinder(d=screw_thread_d, h=screw_thread_h);
  translate([0, 0, screw_thread_h]) cylinder(d=screw_head_d, h=screw_head_h);
}

module badge() {
  cube([badge_th, badge_w, badge_h]);
  translate([badge_th, badge_w/2, 5])
    rotate([90, 0, 90])
      linear_extrude(0.2)
        text("noctua", 5, halign="center");
}

module psu() {
  cube([psu_x, psu_y, psu_z]);
  // Vent protrusion - not a real protrusion, there to make sure the case leaves space
  translate([psu_x - vent_x - vent_dx, -4, (psu_z - vent_z) / 2])
    cube([vent_x, 5, vent_z]);
  // Fan protrusion - not a real protrusion, there to make sure the case leaves space
  translate([-5, psu_y / 2, fan_dz])
    rotate([0, 90, 0])
      cylinder(d=fan_d, h=5);
  // Bottom left screw hole, near the power plug.
  translate([screw_thread_h - case_th, psu_y - 3.5, psu_z - 15.5]) rotate([0, -90, 0]) screw();
  // Top left screw hole, near the fan, opposite power.
  translate([screw_thread_h - case_th, psu_y - 4.75, 5.75]) rotate([0, -90, 0]) screw();
  // Top right screw hole, near the fan, same side as power.
  translate([screw_thread_h - case_th, 4.5, 5.75]) rotate([0, -90, 0]) screw();
  // Power plug.  Uses th instead of power_x so it punches through the faceplate.
  translate([-power_x, power_dy, psu_z - power_z - power_dz])
    cube([power_x, power_y, power_z]);
  // Cables
  translate([psu_x, 0.01, cable_dz])
    cube([5, cable_y, cable_z]);
  // Cable side screw
  translate([psu_x - screw_thread_h + case_th, 14.6, 5]) rotate([0, 90, 0]) screw();
  translate([psu_x - screw_thread_h + case_th, psu_y - 9, 5]) rotate([0, 90, 0]) screw();
}

module mobo() {
  // The mobo
  difference() {
    cube([mobo_x, mobo_y, mobo_th]);
    translate([mobo_screw_x1 , mobo_screw_y1, -1]) cylinder(d=hole_d, h=mobo_th+2);
    translate([mobo_screw_x1b, mobo_screw_y2, -1]) cylinder(d=hole_d, h=mobo_th+2);
    translate([mobo_screw_x2 , mobo_screw_y1, -1]) cylinder(d=hole_d, h=mobo_th+2);
    translate([mobo_screw_x2 , mobo_screw_y2, -1]) cylinder(d=hole_d, h=mobo_th+2);
  }
  // The IO shield
  translate([-io_x, mobo_y - io_y + mobo_io_dy2, mobo_io_dz])
    cube([io_x, io_y, io_z]);
}

// 6-32 steel nut + threaded standoff slot
module mount() {
  union() {
    cylinder(r=mount_bot_r, h=mount_bot_h);
    translate([0, 0, mount_bot_h])
      cylinder(r=mount_top_r, h=mount_top_h);
  }
}

module nut_slot() {
  support_x = nut_slot_x;
  support_z = support_x * tan(60);
  difference() {
    union() {
      cube([nut_slot_x, nut_slot_y, nut_slot_z]);
      rotate([-90, 0, 0])
        linear_extrude(nut_slot_y)
          polygon([[0, 0], [support_x, 0], [0, support_z]]);
    }
    translate([-1, case_th/2, case_th]) cube([nut_slot_x + 2, nut_e2e, nut_th]);
    translate([nut_slot_x / 2, nut_slot_y / 2, -support_z - 1]) cylinder(d=screw_thread_d, h=nut_slot_z + support_z + 2);
  }
}

module grille(w, h, tilt, twist) {
  spacing = case_th * 2;
  l = h / cos(tilt);
  slat_dx = h * sin(tilt);
  count = (w + slat_dx) / spacing;
  intersection() {
    translate([-slat_dx, 0, 0]) {
      for (i = [0:count]) {
        translate([i*spacing, 0, 0])
        rotate([0, tilt,     0])
        rotate([0,    0, twist])
        translate([0, -1, -1])
          cube([case_th/2, case_th+2, l+3]);
      }
    }
    cube([w, case_th, h]);
  }
}

module case() {
  difference() {
    // Case perimeter
    union() {
      // Baseplate of the case with standoffs and the holes for hex mounting nuts.
      // Standoffs do not get a z translation, they're designed for access from the
      // exterior, so they're modeled including the case_th.
      difference() {
        union() {
          cube([exterior_x, exterior_y, case_th]);
          translate([case_th + mobo_dx, case_th + psu_y + case_th]) {
            translate([mobo_screw_x1 , mobo_screw_y1]) mount();
            translate([mobo_screw_x1b, mobo_screw_y2]) mount();
            translate([mobo_screw_x2 , mobo_screw_y1]) mount();
            translate([mobo_screw_x2 , mobo_screw_y2]) mount();
          }
        }
        translate([case_th + mobo_dx, case_th + psu_y + case_th]) {
          translate([mobo_screw_x1 , mobo_screw_y1, -1]) {
            hex(nut_e2e, h=nut_h+1);
            translate([0, 0, nut_h])
              cylinder(r=hex_r(ext_nut_e2e), h=case_th + mount_top_h + 2);
          }
          translate([mobo_screw_x1b, mobo_screw_y2, -1]) {
            hex(nut_e2e, h=nut_h+1);
            translate([0, 0, nut_h])
              cylinder(r=hex_r(ext_nut_e2e), h=case_th + mount_top_h + 2);
          }
          translate([mobo_screw_x2 , mobo_screw_y1, -1]) {
            hex(nut_e2e, h=nut_h+1);
            translate([0, 0, nut_h])
              cylinder(r=hex_r(ext_nut_e2e), h=case_th + mount_top_h + 2);
          }
          translate([mobo_screw_x2 , mobo_screw_y2, -1]) {
            hex(nut_e2e, h=nut_h+1);
            translate([0, 0, nut_h])
              cylinder(r=hex_r(ext_nut_e2e), h=case_th + mount_top_h + 2);
          }
        }
      }
      // PSU fence
      translate([case_th, case_th, case_th]) {
        th = case_th / 2;
        translate([psu_x + th/2,            0, 0]) cube([               th, psu_y + th + th/2, mobo_h]);
        translate([           0, psu_y + th/2, 0]) cube([psu_x + th + th/2,                th, mobo_h]);
      }
      // Sides of the case, all z dimensions are - case_th to leave space for the lid.
      cube([case_th, exterior_y, exterior_z - case_th]);
      translate([exterior_x - case_th, 0, 0])
        cube([case_th, exterior_y, exterior_z - case_th]);
      cube([exterior_x, case_th, exterior_z - case_th]);
      translate([0, exterior_y - case_th, 0])
        cube([exterior_x, case_th, exterior_z - case_th]);
      // Nut mounting brackets
      translate([case_th, case_th]) {
        translate([0, psu_y + case_th, case_th + interior_z - nut_slot_z]) nut_slot();
        translate([0, interior_y - nut_slot_y, case_th + interior_z - nut_slot_z]) nut_slot();
        translate([nut_slot_x + interior_x - nut_slot_x, interior_y - nut_slot_y, case_th + interior_z - nut_slot_z]) mirror([1, 0, 0]) nut_slot();
        translate([nut_slot_x + interior_x - nut_slot_x, 0, case_th + interior_z - nut_slot_z]) mirror([1, 0, 0]) nut_slot();
      }
    } // union Case perimeter
    // IO hole
    translate([
      -1,
      case_th + psu_y + case_th + mobo_y + mobo_io_dy2 - io_y,
      case_th + mobo_h + mobo_io_dz
    ]) cube([case_th+2, io_y, io_z]);
    // CPU intake vent hole
    translate([
      case_th + heatsink_dx,
      exterior_y - case_th - 1,
      case_th + mobo_h + mobo_th
    ]) cube([heatsink_x, case_th+2, 40]);
    // PSU intake vent hole
    translate([
      case_th + psu_x - vent_x - vent_dx,
      -1,
      case_th + (psu_z - vent_z) / 2
    ]) cube([vent_x, case_th+2, vent_z]);
    // PSU exhaust vent hole
    translate([
      -1,
      case_th + psu_y / 2,
      case_th + fan_dz
    ]) rotate([0, 90, 0]) cylinder(d=fan_d, h=case_th+2);
    // PSU power plug hole
    translate([
      -1,
      case_th + psu_y - power_y - power_dy,
      case_th + psu_z - power_z - power_dz
    ]) cube([case_th+2, power_y, power_z]);
    // PSU screws, back, clockwise starting from top
    translate([
      -1,
      case_th + 3.5,
      case_th + psu_z - 15.5
    ]) rotate([0, 90, 0]) cylinder(d=screw_thread_d, h=case_th+2);
    translate([
      -1,
      case_th + 4.75,
      case_th + 5.75
    ]) rotate([0, 90, 0]) cylinder(d=screw_thread_d, h=case_th+2);
    translate([
      -1,
      case_th + psu_y - 4.5,
      case_th + 5.75
    ]) rotate([0, 90, 0]) cylinder(d=screw_thread_d, h=case_th+2);
    // PSU screws, front
    translate([
      case_th + psu_x - 1,
      case_th + 14.6,
      case_th + 5
    ]) rotate([0, 90, 0]) cylinder(d=screw_thread_d, h=case_th+2);
    translate([
      case_th + psu_x - 1,
      case_th + psu_y - 9,
      case_th + 5
    ]) rotate([0, 90, 0]) cylinder(d=screw_thread_d, h=case_th+2);

    // Noctua badge power button hole
    translate([exterior_x - case_th - 1, (exterior_y - badge_w) / 2, (exterior_z - badge_h) / 2]) cube([case_th + 2, badge_w, badge_h]);
  }
  // PSU intake vent grille
  translate([
    case_th + psu_x - vent_x - vent_dx,
    0,
    case_th + (psu_z - vent_z) / 2
  ]) grille(vent_x, vent_z, 30, 30);
  // CPU intake vent grille
  translate([
    case_th + heatsink_dx,
    case_th + interior_y,
    case_th + mobo_h + mobo_th
  ]) grille(heatsink_x, 40, 30, -30);
}

module lid() {
  difference() {
    // The lid
    cube([exterior_x, exterior_y, case_th]);
    // Heatsink hole
    translate([case_th + heatsink_dx, case_th + psu_y + case_th + heatsink_dy, -1])
      cube([heatsink_x, heatsink_y, case_th + 2]);
    // Mounting screw holes
    translate([case_th, case_th]) {
      translate([nut_slot_x / 2, psu_y + case_th + nut_slot_y / 2, -1]) cylinder(d=screw_thread_d, h=case_th + 2);
      translate([nut_slot_x / 2, interior_y - nut_slot_y / 2, -1]) cylinder(d=screw_thread_d, h=case_th + 2);
      translate([nut_slot_x / 2 + interior_x - nut_slot_x, interior_y - nut_slot_y / 2, -1]) cylinder(d=screw_thread_d, h=case_th + 2);
      translate([nut_slot_x / 2 + interior_x - nut_slot_x, nut_slot_y / 2, -1]) cylinder(d=screw_thread_d, h=case_th + 2);
    }
  }
}

mx_w = 15;
mx_h = 5.3;
mx_travel = 3.3;
mx_clip_w = 14;
mx_clip_dw = (mx_w - mx_clip_w) / 2;
mx_clip_dz = 3.1;
mx_clip_th = 1.5;
button_platform_th = 2;

module ccube(dims) {
  translate([0, 0, dims.z/2]) cube(dims, center=true);
}



module power_button() {
  // Badge cube
  translate([0, 0, mx_h])
    ccube([badge_w, badge_h, badge_th + mx_travel + button_platform_th + 0.1]);
  // Clip cube
  ccube([mx_clip_w, mx_clip_w, mx_h + 0.1]);
  // Key top cube
  translate([0, 0, mx_h - mx_clip_dz])
    ccube([mx_w, mx_w, mx_h - mx_clip_th + 0.1]);
  // Key bot cube
  translate([0, 0, -0.1])
    ccube([mx_w, mx_w, mx_h - mx_clip_th - mx_clip_dz + 0.1]);
}

module power_button_housing(dw) {
  difference() {
    ccube([
      dw + badge_w + dw,
      dw + badge_h + dw,
      badge_th + mx_travel + button_platform_th + mx_h - case_th
    ]);
    power_button();
  }
}

kailh_fin_w = 1.25;
kailh_fin_l = 3;
kailh_fin_h = 3;
kailh_fin_spacing = 4.5;

module kailh_staple() {
  ccube([kailh_fin_spacing + kailh_fin_w*2, kailh_fin_l, button_platform_th/2]);
  translate([-kailh_fin_spacing/2 - kailh_fin_w/2, 0, 0])
    ccube([kailh_fin_w, kailh_fin_l, button_platform_th + kailh_fin_h]);
  translate([ kailh_fin_spacing/2 + kailh_fin_w/2, 0, 0])
    ccube([kailh_fin_w, kailh_fin_l, button_platform_th + kailh_fin_h]);
}

module button_platform() {
  difference() {
    ccube([badge_w, badge_h, button_platform_th]);
    kailh_staple();
  }
}

// case();

// translate([-exterior_x - 5, 0, 0])
// translate([0, 0, exterior_z + 10])
//   lid();


translate([2 * badge_w, 0])
  button_platform();
kailh_staple();

translate([0, 2 * badge_h]) {
  translate([2 * badge_h, 0]) power_button();
  power_button_housing(5);
}

// Test print:
// (1) Base with mounts and psu fence
// (2) Rear wall

// (1)
module base_test() {
  difference() {
    intersection() {
      translate([-1, -1, -1]) cube([exterior_x+2, exterior_y+2, case_th + mobo_h + 2]);
      case();
    }
    // Mobo center
    translate([case_th + case_th, case_th + psu_y + case_th + mobo_screw_y1 + 6, -1]) cube([interior_x - case_th - case_th, mobo_screw_y2 - mobo_screw_y1 - 12, case_th + 2]);
    // Mobo +y
    translate([case_th + mobo_screw_x1 + 6, case_th + psu_y + case_th + case_th, -1]) cube([mobo_screw_x2 - mobo_screw_x1 - 12, 20, case_th + 2]);
    // Mobo -y
    translate([case_th + mobo_screw_x1b + 6, interior_y - 20, -1]) cube([mobo_screw_x2 - mobo_screw_x1b - 12, 20, case_th + 2]);
    // PSU
    translate([case_th + case_th, case_th + case_th, -1]) cube([psu_x - case_th - case_th, psu_y - case_th - case_th, case_th + 2]);
    // PSU +x
    translate([case_th + psu_x + case_th + case_th, case_th + case_th, -1]) cube([interior_x - psu_x - 5 * case_th, psu_y, case_th + 2]);
  }
}

// base_test();

// (2)
module rear_test() {
  rotate([0, 90, 0]) {
    intersection() {
      // cube([case_th, exterior_y, exterior_z]);
      cube([case_th, exterior_y, case_th + fan_d / 2]);
      case();
    }
  }
}

// rear_test();

