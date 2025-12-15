nameplate = [
  128,
  16,
  2,
];

difference() {
  translate([0, -1.5, -1.5]) cube([nameplate.x, nameplate.y + 3, nameplate.z + 3]);
  translate([0, 1.5, 0]) cube([nameplate.x, nameplate.y - 3, nameplate.z + 2]);
  cube(nameplate);
}
