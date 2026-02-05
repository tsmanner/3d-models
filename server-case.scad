include <server-case/hardware.scad>
include <server-case/motherboard-measurements.scad>


$fn = 64;

module ccube(dims) {
  translate([0, 0, dims.z / 2]) cube(dims, center=true);
}

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

nut_h = max(nut_th, case_th);
mount_bot_d = case_th + hex_d(nut_e2e) + case_th;
mount_bot_r = mount_bot_d / 2;
mount_bot_h = nut_h + case_th;
mount_top_d = case_th + hex_d(ext_nut_e2e) + case_th;
mount_top_r = mount_top_d / 2;
mount_top_h = ext_nut_th + 0.5 - case_th;
mount_h = mount_bot_h + mount_top_h;

nut_slot_x = dHex(nut_e2e);
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

interior_x = atx_io_overhang_x + mini_itx_x + cable_cavity_x;
interior_y = psu_y + case_th + mini_itx_y + atx_io_overhang_y + 6;
interior_z = max(psu_z, atx_dz + 77 - case_th);
exterior_x = case_th + interior_x + case_th;
exterior_y = case_th + interior_y + case_th;
exterior_z = case_th + interior_z + case_th;

case_screw_x1 = nut_slot_x / 2;
case_screw_x2 = interior_x - nut_slot_x / 2;
case_screw_y1 = nut_slot_y / 2;
case_screw_y1b = case_screw_y1 + psu_y + case_th;
case_screw_y2 = interior_y - nut_slot_y / 2;

heatsink_x = 120;
heatsink_y = 133;
// About 8mm from +x of mobo, model is about 4mm wider than the real heatsink.
heatsink_dx = mobo_x - heatsink_x - 8 + 2;
// About 32mm from -y of mobo, model is a couple mm wider than the real heatsink.
heatsink_dy = 32 - 1;

badge_th = 1.5;
badge_w = 26;

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
  cube([badge_th, badge_w, badge_w]);
  translate([badge_th, badge_w/2, 5])
    rotate([90, 0, 90])
      linear_extrude(0.2)
        text("noctua", 5, halign="center");
}

//
// Case
//

// 6-32 steel nut + threaded standoff slot
//
// ━━━━━━━━━━━━╶┬╴     ╶┬╴
// ━━━━━━━━━━━━╶┼╴ 2    │
//     ┃  ┃     │       │ 10
//    ┏┛  ┗┓    │ 6.35  │
//    ┃╺══╸┃    │      ╶┼╴
// ━━━┫    ╊━━━╶┴╴     ╶┴╴
// ━━━┻━━━━┻━━━
//

mount_r1 = rHex(nut_e2e) + case_th;

module mount() {
  // Bottom of exterior to top of mobo
  mobo_top_h = case_th + 6.35 + mobo_th;
  nut_top_h = mobo_top_h - 10 + nut_th;
  h1 = nut_top_h + case_th;
  // Bottom
  difference() {
    cylinder(r = mount_r1, h = h1);
    translate([0, 0, -1])
      Hex(nut_e2e, h = h1 + 1);
  }
  // Top
  r2 = rThread("6-32") + case_th;
  translate([0, 0, h1]) {
    difference() {
      cylinder(r = r2, h=mount_top_h);
      translate([0, 0, -1])
        cylinder(r = rThread("6-32"), h = mount_top_h + 2);
    }
  }
}

module forEachMount() {
  for (hole = "CFHJ")
    translate(mitxMountingHole(hole))
      children();
}

module nut_slot() {
  support_x = nut_slot_x;
  support_z = support_x * tan(60);
  translate([-nut_slot_x / 2, -nut_slot_y / 2]) {
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
}

// Relative to the case interior.
module ForEachLidMount() {
  dx = nut_slot_x / 2;
  dy = nut_slot_y / 2;
  points = [
    [             dx,              dy + psu_y + 1/2], // +1/2 tolerance
    [             dx, interior_y - dy],
    [interior_x - dx,              dy],
    [interior_x - dx, interior_y - dy],
  ];
  if ($children == 4) {
    for (i = [0 : 3]) {
      translate(points[i]) children(i);
    }
  }
  else {
    for (point = points) {
      translate(point) children();
    }
  }
}

module grille(w, h, tilt, twist) {
  th = case_th / 2;
  spacing = th * 6;
  l = h / cos(tilt);
  slat_dx = l * sin(abs(tilt));
  count = (w + slat_dx) / spacing;
  intersection() {
    translate([tilt > 0 ? -slat_dx : 0, 0, 0]) {
      for (i = [0:count]) {
        translate([i*spacing, 0, 0])
        rotate([0, tilt,     0])
        rotate([0,    0, twist])
        translate([0, -1, -1])
          cube([th, case_th+2, l + spacing]);
      }
    }
    cube([w, case_th, h]);
  }
}

module case() {
  difference() {
    // Case perimeter
    union() {
      difference() {
        cube([exterior_x, exterior_y, case_th]);
        // Punch a hole for each mount.
        translate([case_th + mobo_dx, case_th + psu_y + case_th, -1])
          forEachMount() cylinder(r = mount_r1, h = case_th + 2);
      }
      // Instantiate the mounts.
      translate([case_th + mobo_dx, case_th + psu_y + case_th])
        forEachMount() mount();
      // PSU fence
      translate([case_th, case_th, case_th]) {
        th = case_th / 2;
        x = psu_x + th + th/2;
        y = psu_y + th + th/2;
        translate([psu_x + th/2,            0, 0]) cube([th,  y, case_th*2]);
        translate([           0, psu_y + th/2, 0]) cube([ x, th, case_th*2]);
      }
      // Sides of the case, all z dimensions are - case_th to leave space for the lid.
      cube([case_th, exterior_y, exterior_z - case_th]);
      translate([exterior_x - case_th, 0, 0])
        cube([case_th, exterior_y, exterior_z - case_th]);
      cube([exterior_x, case_th, exterior_z - case_th]);
      translate([0, exterior_y - case_th, 0])
        cube([exterior_x, case_th, exterior_z - case_th]);
      // Lid mounting brackets
      translate([case_th, case_th, exterior_z - case_th - nut_slot_z]) {
        ForEachLidMount() {
          nut_slot();
          nut_slot();
          mirror([1, 0, 0]) nut_slot();
          mirror([1, 0, 0]) nut_slot();
        }
      }
    } // union Case perimeter
    // IO hole
    translate([
      -1,
      case_th + psu_y + case_th + atx_io_dy,
      case_th + atx_dz + atx_io_dz(mobo_th)
    ]) cube([case_th+2, atx_io_w, atx_io_h]);
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
    ]) cube([case_th+2, power_y, power_z + power_dz + 1]);
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

    // Noctua badge power button hole
    translate([exterior_x - case_th - 1, (exterior_y - badge_w) / 2, (exterior_z - badge_w) / 2]) cube([case_th + 2, badge_w, badge_w]);
  }
  // PSU intake vent grille
  translate([
    case_th + psu_x - vent_x - vent_dx,
    0,
    case_th + (psu_z - vent_z) / 2
  ]) {
    grille(vent_x, vent_z,  45, 30);
    grille(vent_x, vent_z, -45, 30);
  }
  // CPU intake vent grille
  translate([
    case_th + heatsink_dx,
    case_th + interior_y,
    case_th + mobo_h + mobo_th
  ]) {
    grille(heatsink_x, 40,  45, -30);
    grille(heatsink_x, 40, -45, -30);
  }
}


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

// translate([exterior_x, 0, case_th + 4]) rotate([0, 180, 0])
//   lid();

// translate([0, 0, exterior_z + 5])
//   lid();

case();

//
// Power button
//

mx_w = 15;
mx_h = 5.3;
mx_travel = 3.3;
mx_clip_w = 14;
mx_clip_dw = (mx_w - mx_clip_w) / 2;
mx_clip_dz = 3.1;
mx_clip_th = 1.4;

module mx_mount() {
  cube([mx_w, mx_w, mx_clip_dz]);
}


key_w = 17.6;
key_h = 16.6;
key_th = 3.4;
key_depth = 0.3;

module power_button() {
  kt_dxy = 2.75;
  kt_dx = 0.5 * kt_dxy;
  kt_dy = 0.8 * kt_dxy;

  kbx = key_w;
  kby = key_h;
  ktx = kbx - kt_dxy;
  kty = kby - kt_dxy;
  kz = key_th;
  kbz = 1.5;
  ktz = kz - kbz;

  bx = badge_w;
  by = badge_w;

  rotate([180, 0, 0]) {
    difference() {
      cube([bx, by, kz]);
      translate([(bx - kbx) / 2, (by - kby) / 2, 0]) {
        hull() {
          cube([kbx, kby, kbz]);
          translate([kt_dx, kt_dy, kbz]) {
            cube([ktx, kty, ktz]);
          }
        }
      }
    }
  }
}


power_button_hole_w = badge_w + 1;
power_button_plate_w = power_button_hole_w + 4;

module power_button_mounting_plate() {
  // Mounting plate
  translate([0, 0, case_th]) {
    difference() {
      ccube([power_button_plate_w, power_button_plate_w, mx_clip_th]);
      translate([0, 0, -1])
        ccube([mx_clip_w, mx_clip_w, mx_clip_th + 2]);
    }
  }
  difference() {
    ccube([badge_w - 0.5, badge_w - 0.5, case_th]);
    translate([0, 0, -1])
      ccube([mx_w, mx_w, case_th + 2]);
  }
}

module power_button_mount() {
  // Bottom of mounting plate to top of button (small over extension so the button is a little bit recessed)
  dz = 10 + mx_clip_th;
  mount_bot_w = badge_w * 2;
  mount_top_w = power_button_hole_w + 2;
  difference() {
    hull() {
      ccube([mount_bot_w, mount_bot_w, 1]);
      ccube([mount_top_w, mount_top_w, dz]);
    }
    translate([0, 0, -1]) {
      ccube([power_button_hole_w, power_button_hole_w, dz + 2]);
    }
    translate([0, 0, -1])
      ccube([power_button_plate_w + 0.25, power_button_plate_w + 0.25, mx_clip_th + 0.5 + 1]);
  }
}
