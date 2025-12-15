bezel = 11;
badge = 25.5;
th = 2;
shroud = 5;


rotate([90, 0, 0]) difference() {
    cube([bezel+badge+th, shroud+th, bezel+badge+th]);
    cube([badge, th, badge]);
    translate([0, th, 0]) cube([bezel+badge, shroud, bezel+badge]);
}
