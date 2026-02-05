$fn = 64;

use <t-track.scad>

module Insert(r, l) {
  w1 = channel_w1;
  w2 = channel_w2;
  h = channel_h;
  linear_extrude(l) {
    minkowski() {
      circle(r=r);
      offset(delta=-r) {
        polygon([
          [-w1/2, -slot_h],
          [ w1/2, -slot_h],
          [ w2/2, -slot_h-h],
          [-w2/2, -slot_h-h],
        ]);
      }
    }
  }
  translate([-slot_w/2, -slot_h]) {
    cube([slot_w, slot_h, l]);
  }
}

len = 5;
linear_extrude(len) Channel("25");
translate([-25/2, 0]) cube([25, 2, len]);
