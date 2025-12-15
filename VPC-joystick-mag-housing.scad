$fn = 64;

thickness = 1;

cable_r = 2;
wire_d = 1.5;
pin_d = 0.77;
pin_pitch = 3.3 - pin_d;
channel_w = pin_pitch - 1;
channel_l = 5;
connector_h = 4.3;
connector_w = 20.5;
connector_l = 4;
connector_tab = 1;

housing_h = connector_h + 2 * thickness;
housing_w = connector_w + 2 * thickness;
housing_cavity_l = 13;
housing_l = 18;


module channel() {
  cube([
    channel_w,
    channel_l,
    connector_h,
  ]);
}

module connector() {
  // Main body
  translate([
    connector_h / 2,
    0,
    0,
  ]) cube([
    connector_w - connector_h,
    connector_l,
    connector_h,
  ]);
  // Rounded Ends
  r=connector_h / 2;
  translate([r, 0, r]) rotate([-90, 0, 0]) cylinder(r=r, h=connector_l);
  translate([connector_w - r, 0, r]) rotate([-90, 0, 0]) cylinder(r=r, h=connector_l);
  // Rectangular tab
  translate([
    0, 2, 0
  ]) cube([
    connector_w,
    connector_tab,
    connector_h,
  ]);
  // Wire/pin channels
  for (i = [-2:2]) {
    translate([
      (connector_w - channel_w) / 2 + (pin_pitch * i),
      connector_l,
      0,
    ]) channel();
  }
}


module cable() {
  translate([cable_r, 0, cable_r]) rotate([-90, 0, 0]) cylinder(r=cable_r, h=50);
}


module housing() {
  difference() {
    union() {
      // Connector area
      cube([
        housing_w,
        connector_l,
        housing_h / 2,
      ]);
      // Wire to cable port
      translate([0, connector_l, 0]) linear_extrude(housing_h / 2)
        polygon([
          [0, 0],
          [housing_w, 0],
          [housing_w / 2 + cable_r + thickness, housing_l],
          [housing_w / 2 - cable_r - thickness, housing_l],
        ]);
    }
    pin_dx = (housing_w - channel_w) / 2 - (pin_pitch * 2);
    translate([0, connector_l + channel_l, thickness]) linear_extrude(housing_h)
      polygon([
        [pin_dx, 0],
        [housing_w - pin_dx, 0],
        [housing_w / 2 + cable_r, housing_cavity_l - channel_l - thickness],
        [housing_w / 2 - cable_r, housing_cavity_l - channel_l - thickness],
      ]);
    // Cable port
    translate([housing_w / 2 - cable_r, housing_l - 2 * thickness, thickness]) cable();
  }
}


difference() {
  housing();
  translate([thickness, 0, thickness]) connector();
}
