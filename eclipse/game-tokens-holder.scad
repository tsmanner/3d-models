include <measurements.scad>

$fn = 128;

first_player_base_d = 18.25;
first_player_hips_d = 15;
first_player_neck_d = 8.5;
first_player_head_d = 13.25;
first_player_h = 38;
// The width of the dice holder exactly fits next to the ship box.
outer_w = 3*die_w+2*thickness;


dims = [
    [first_player_base_d,  0],
    [first_player_hips_d, 12],
    [first_player_head_d, 28],
    [first_player_head_d, first_player_h - first_player_head_d/2] // ish
];

module cone(bot, top) {
    translate([0, 0, bot[1]]) cylinder(d1=bot[0], d2=top[0], h=top[1] - bot[1]);
}

// Body
body_x = thickness + first_player_base_d + thickness + cube_w*2 + thickness;
body_y = first_player_base_d+2*thickness;
module body(h) {
    ccube([body_x, body_y, h]);
}

module first_player() {
    for (i = [0:len(dims)-2]) cone(dims[i], dims[i+1]);
    translate([0, 0, dims[len(dims)-1][1]]) sphere(d=dims[len(dims)-1][0]);
}

module cubes() {
    ccube([cube_w*2, cube_w*2, cube_w*3]);
}

module game_tokens_holder() {
    difference() {
        body(outer_w);
        // First player token
        translate([-first_player_base_d/2-thickness/2, 0, 0]) {
            translate([0, 0, thickness*2])
                first_player();
            cylinder(d=first_player_base_d, h=thickness*2+0.1);
        }
        translate([cube_w+thickness/2, 0, 0]) {
            translate([0, 0, thickness*2]) {
                // Round marker
                translate([0, 0, cube_w*3])
                    cylinder(d=round_d, h=round_h);
                // Damage cubes
                cubes();
            }
            ccube([cube_w*2, cube_w*2, thickness*2+0.1]);
        }
        // Volume for the lid
        ccube([body_x, body_y, thickness]);
    }
}

holder();
