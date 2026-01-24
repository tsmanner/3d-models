
hook_top_d = 3.5;
hook_bot_d = 2.5;
hook_taper = hook_top_d - hook_bot_d;
clip_h = 22;
clip_w = 6;

module clip(th) {
  clip_d = th + hook_top_d + th;
  clip_latch_th = th + 0.4;
  $fn = 64;
  translate([-clip_d, 0, 0]) {
    linear_extrude(clip_w) {
      polygon([
        [0, clip_h],
        [th + hook_top_d + th, clip_h],
        [th + hook_top_d + th,          th],
        [th + hook_top_d          ,          th],
        [th + hook_top_d          , clip_h - th],
        [th                       , clip_h - th],
        [th + hook_taper          ,          th],
        [          hook_taper          ,          th],
      ]);
      translate([clip_latch_th / 2 + hook_taper, th]) {
        circle(d=clip_latch_th);
      }
      translate([th + hook_top_d + th, th]) {
        difference() {
          circle(r=th);
          translate([0, -th])
            square([th, 2 * th]);
        }
      }
    }
  }
}

module teapot_hook(th, x, y, z, r) {
  clip(th);
  $fn = 1024;
  linear_extrude(z) {
    difference() {
      square([x, y]);
      translate([x / 2, r]) circle(r=r - th);
      translate([0 - r, 0]) square([r, r]);
      translate([x / 2 - r, r]) square([r, r]);
      translate([x / 2, r]) square([r, r]);
      translate([x, 0]) square([r, r]);
    }
    translate([x, th/2]) square([th, y + th/2]);
    translate([x, 0]) square([th/2, th]);
    translate([x + th/2, th/2]) circle(d=th);
  }
}

teapot_hook(3.5, 20, 12, clip_w, 50);
