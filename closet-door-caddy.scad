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

module BotConnector() {
  linear_extrude(out_w) {
    translate([wFrame(ctype)/2, 0]) Channel(ctype);
  }
}

module TopConnector() {
  mirror([0, 1, 0]) BotConnector();
}

module Connectors() {
  translate([0, th+in_h+th]) {
    TopConnector();
  }
  BotConnector();
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

Caddy();
