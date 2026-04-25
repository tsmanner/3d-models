$fn = 64;

hole_d = 4;
hole_r = hole_d / 2;
hole_spacing = 32;  // Distance center to center of holes on fan.
hole_delta = 4; // Distance center to edge of fan.

spacing = 8;
washer_d = 12;
washer_r = washer_d / 2;
th = 2;

spine_x = washer_d;
spine_y = washer_r + spacing * 2 + 4;  // 4 from mount hole to edge of fan.

cross_x = hole_d + spacing * 2;
cross_y = hole_d + (hole_delta - hole_r);

// cube([cross_x, cross_y, th]);
// translate([(cross_x - spine_x) / 2, 0, 0])
//   cube([spine_x, spine_y, th]);

bushing_od = 8;
bushing_id = 5; 
bushing_h = 7;

difference() {
  cylinder(d = bushing_od, h = bushing_h);
  translate([0, 0, -1])
    cylinder(d = bushing_id, h = bushing_h + 2);
}
