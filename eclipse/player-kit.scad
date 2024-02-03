include <measurements.scad>

ship_box_l = 140;
ship_box_w = 90;
ship_box_h = 33;

partition_w = 188;
partition_l = ship_box_w + 3*sector_r;
partition_h = 49;


// Octagonal but it's irregular, just use a cylinder
resource_d = 11;
resource_h = 10.5;
resource_count = 3;

action_card_l = sector_w;
action_card_w = 66;

module ship_box() {
    ccube([ship_box_l, ship_box_w, ship_box_h]);
}

sector_holder_w = sector_w + 2*thickness;
sector_holder_l = 3/2*sector_r;

module sector() {
    difference() {
    translate([0, -((sector_holder_l)/2 - sector_r/2), 0])
        ccube([sector_holder_w, sector_holder_l, 2*thickness]);
    translate([0, 0, thickness])
        rotate([0, 0, 90])
            cylinder(r=sector_r, h=thickness+1, $fn=6);
    }
}

// // Box partition
// difference() {
//     translate([0, 0, -1]) ccube([partition_w+4, partition_l+4, partition_h+1]);
//     ccube([partition_w, partition_l, partition_h+1]);
// }

// // Ship box
// translate([partition_w/2-ship_box_l/2, partition_l/2-ship_box_w/2, 0]) ship_box();

// // Player kits
// translate([ (partition_w-sector_holder_w)/2, -(partition_l/2-(sector_r)), 0]) sector();
// translate([ (partition_w-sector_holder_w)/2, partition_l/2-ship_box_w-(sector_r), 4]) rotate([0, 0, 180]) sector();
// // translate([-(partition_w-sector_w-thickness)/2, -(partition_l/2-(sector_r+thickness)), 0]) sector();

$fn=64;

difference() {
    ccube([action_card_l, action_card_w, resource_h]);
    translate([0, 0, resource_h+1]) rotate([180, 0, 0]) {
        translate([0, 0, -thickness]) ccube([action_card_l, action_card_w, thickness]);

        translate([0, -(action_card_w-3*cube_w)/2+2]) {
            ccube([10*cube_w, 3*cube_w, cube_w]);
            translate([9*cube_w/2, 3/2*cube_w+2*cube_w-1/2, 0]) ccube([cube_w, 4*cube_w+1, cube_w]);
        }

        translate([11-0*influence_d, 6, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-1*influence_d, 6, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-2*influence_d, 6, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-3*influence_d, 6, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-0*influence_d, 6+influence_d, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-1*influence_d, 6+influence_d, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-2*influence_d, 6+influence_d, 0]) cylinder(d=influence_d, h=2*influence_h);
        translate([11-3*influence_d, 6+influence_d, 0]) cylinder(d=influence_d, h=2*influence_h);

        translate([26, 3+0*resource_d, 0]) cylinder(d=resource_d, h=resource_h);
        translate([26, 3+1*resource_d, 0]) cylinder(d=resource_d, h=resource_h);
        translate([26, 3+2*resource_d, 0]) cylinder(d=resource_d, h=resource_h);
    }
}
