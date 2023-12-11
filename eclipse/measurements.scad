thickness = 1.9;
finger_d = 22;

module holder(h) {
    // Child 0 is the outer shape
    // Child 1 is the inner shape
    // Child 2 is the end-cap hole shape
    // Bottom end
    difference() {
        linear_extrude(thickness) { children(0); }
        translate([0, 0, -1])
            linear_extrude(thickness+2) { children(2); }
    }
    // Main chamber: h + thickness to leave room for the lid.
    translate([0, 0, thickness])
        difference() {
            linear_extrude(h + thickness) { children(0); }
            translate([0, 0, -1])
                linear_extrude(h + thickness + 2) { children(1); }
        }
}

module lid() {
    // Child 0 is the outer shape
    // Child 1 is the inner shape
    // Child 2 is the end-cap hole shape
    // Bottom end
    difference() {
        linear_extrude(thickness) { children(0); }
        translate([0, 0, -1])
            linear_extrude(thickness+2) { children(2); }
    }
    // Cap plug
    translate([0, 0, thickness])
        difference() {
            linear_extrude(thickness) { children(1); }
            translate([0, 0, -1])
                linear_extrude(thickness+2) { children(2); }
        }
}

//
// Discovery Tiles
//

discovery_w = 24;
discovery_count = 21;

function discovery_corner_r(w) = w * 7 / 24;

module discovery_tile_shape(w) {
    r = discovery_corner_r(w);
    translate([-w/2, -w/2]) {
        translate([w-r, w-r])
            circle(r=r, $fn=64);
        square([w-r, w]);
        square([w, w-r]);
    }
}

//
// Ancients
//

ancient_r = 19.5;
ancient_count = 22;

//
// Monotliths/Orbitals
//

monolith_orbital_d = 25.25;
monolith_orbital_count = 22;
