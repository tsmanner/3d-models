$fn = 128;

faucet_d = 25.1;
faucet_r = faucet_d / 2;
clip_th = 2;
clip_r = faucet_r + clip_th;
clip_d = clip_r * 2;
clip_theta = -30;
scrubby_r = faucet_r/2;

module ring(r, th) {
  difference() {
    cylinder(r=r + th, h=th);
    translate([0, 0, -1]) {
      cylinder(r=r, h=th+2);
    }
  }
}

module quadrant(q, r, th) {
  dx = (q == 1 || q == 4) ? 0 : -r;
  dy = (q == 1 || q == 2) ? 0 : -r;
  translate([dx, dy, -1]) cube([r, r, th+2]);
}

difference() {
  ring(faucet_r, clip_th);
  quadrant(4, clip_r, clip_th);
  rotate([0, 0, clip_theta]) {
    translate([0, 0, -1]) {
      difference() {
        cylinder(r=clip_r+1, h=clip_th+2);
        quadrant(2, clip_r, clip_th);
        quadrant(3, clip_r, clip_th);
        quadrant(4, clip_r, clip_th);
      }
    }
  }
}
rotate([0, 0, clip_theta]) {
  translate([0, clip_r - clip_th/2, 0])
    cylinder(d=clip_th, h=clip_th);
}

translate([0, -clip_r, 0]) cube([faucet_d, clip_th, clip_th]);

translate([faucet_d, 0, 0]) {
  difference() {
    ring(faucet_r, clip_th);
    quadrant(1, clip_r, clip_th);
    quadrant(2, clip_r, clip_th);
    quadrant(3, clip_r, clip_th);
  }
  translate([faucet_r - scrubby_r, 0, 0]) {
    difference() {
      ring(scrubby_r, clip_th);
      quadrant(2, scrubby_r + clip_th, clip_th);
      quadrant(3, scrubby_r + clip_th, clip_th);
      quadrant(4, scrubby_r + clip_th, clip_th);
    }
    translate([0, scrubby_r + clip_th/2, 0]) cylinder(d=clip_th, h=clip_th);
  }
}
