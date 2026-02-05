use <t-track.scad>

ctype = "25";

bed_w = 177;

// Radius of the interior of the caddy.
r          = 100;
th         =   3;
in_d       =  55;
in_h       =  75;
out_w      = 405;
conn_w     =  10;
out_d      =  in_d + th;
out_h      = th +in_h + th;
in_w       = out_w - th - th;
segments   = ceil(out_w / bed_w);
conn_step  = (out_w - conn_w) / segments;
conn_dzs = [for (i = [0 : conn_step : out_w]) i ];

module TopConnector() {
  w = wFrame(ctype);
  rotate([0, 0, -90]) {
    linear_extrude(conn_w) {
      Channel(ctype);
      polygon([
        [-w/2,   0],
        [-w/2,  th],
        [ w/2, w/2],
        [ w/2,   0]
      ]);
    }
  }
}

module BotConnector() {
  w = wFrame(ctype);
  mirror([0, 1, 0]) {
    linear_extrude(conn_w) {
      Channel(ctype);
      polygon([
        [-w/2,    0],
        [-w/2,   th],
        [ w/2, 2*th],
        [ w/2+in_d+th, th],
        [ w/2+in_d+th, th],
        [ w/2,    0]
      ]);
    }
  }
}

module Connectors() {
  for (i = conn_dzs) {
    translate([0, th+in_h+25/2, i]) {
      TopConnector();
    }
    translate([-25/2, th, i]) {
      BotConnector();
    }
  }
}


module Interior() {
  translate([-1, 0, -1]) linear_extrude(out_w+2) square([in_d+1, in_h]);
}

module Exterior() {
  linear_extrude(out_w) square([in_d+th, th+in_h+th]);
}

module Caddy() {
  difference() {
    Exterior();
    translate([0, th])
      Interior();
  }
  cube([out_d, out_h, th]);
  translate([0, 0, th+in_w])
    cube([out_d, out_h, th]);
  Connectors();
}

module CaddyPart(n) {
  dzs = [
    0,
    conn_dzs[1] + conn_w/2,
    conn_dzs[2] + conn_w/2,
    out_w,
  ];
  dx = wFrame("25");
  dy = th;
  translate([0, 0, -dzs[n]]) {
    intersection() {
      translate([-dx, -dy, dzs[n]]) cube([dx + out_d, dy + out_h + wFrame("25"), dzs[n+1]-dzs[n]]);
      Caddy();
    }
  }
}

module Parts() {
  dx = wFrame("25") + out_d + 3;
  CaddyPart(0);
  translate([dx, 0]) CaddyPart(1);
  translate([dx * 2, 0]) CaddyPart(2);
}

Parts();
