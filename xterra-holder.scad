include <common.scad>

tab_thickness = 2.5;
tab_middle_width = 20;
tab_middle_dz = tab_thickness + 2.5;
tab_side_width = 16;
tab_side_spacing = 19;
tab_depth = 25;
dot_thickness = 1;
dot_width = 4;
tab_width = 2 * tab_side_width + tab_side_spacing;

module tab_side() {
    ccube([tab_side_width, tab_depth, tab_thickness]);
    translate([0, 0, tab_thickness])
        ccube([dot_width, tab_depth, dot_thickness]);
}

module tabs() {
    translate([(tab_side_width + tab_side_spacing)/2, 0, 0])
        tab_side();
    translate([-(tab_side_width + tab_side_spacing)/2, 0, 0])
        tab_side();
    translate([0, 0, tab_middle_dz])
        ccube([tab_middle_width, tab_depth, tab_thickness]);
}

connector_x = 2 * (2 + tab_side_width) + tab_side_spacing;
connector_y = 2 + tab_depth;
connector_z = tab_thickness + tab_middle_dz + 4;

module connector() {
    difference() {
        ccube([connector_x, connector_y, connector_z]);
        translate([0, connector_y - tab_depth, 2]) tabs();
    }
}

translate([0, connector_y / 2, -connector_z + 2])
    connector();

base_x = 100;
base_y = 40;
base_z = 4;

lip_x = base_x;
lip_y = 4;
lip_z = 15;

translate([0, connector_y - base_y/2, 0]) {
    ccube([base_x, base_y , base_z]);
    translate([0, base_y/2 - lip_y/2, base_z])
        ccube([lip_x, lip_y, lip_z]);
}
