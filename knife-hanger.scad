$fn = 128;

slot_h = 20;
slot_w = 3;
th = 3;

steak_knife_th = 2;
steak_knife_w = 20;
steak_knife_count = 8;

difference() {
  cube([th + (steak_knife_w + th) * steak_knife_count, th + slot_w + th, slot_h]);
  translate([th, th, -1])
    cube([(steak_knife_w + th) * steak_knife_count - th, slot_w, slot_h+2]);
}
for (i = [1:steak_knife_count-1]) {
  translate([(th + steak_knife_w) * i, th])
    cube([th, slot_w, slot_h]);
}
