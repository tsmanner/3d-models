include <measurements.scad>;

// e2e - edge to edge distance of a hexagon.
sector_tile_e2e = 90;
sector_tile_r = e2e_to_r(sector_tile_e2e);
sector_tile_e = sector_tile_r;
sector_tile_h = 2;
num_sector_tiles = 1 + 8 + 11 + 18;


function e2e_to_d(e2e) = e2e/cos(30);
function e2e_to_r(e2e) = e2e_to_d(e2e)/2;

module hex(e2e, h) {
    cylinder(r=e2e_to_r(e2e), h=h, $fn=6);
}

module sectorTiles(n) {
    hex(sector_tile_e2e, h=sector_tile_h*n);
}

module sectorHolder() {
    translate([e2e_to_r(sector_tile_e2e + thickness), 0, 0])
    difference() {
        hex(sector_tile_e2e + thickness, sector_tile_h*num_sector_tiles/2);
        sectorTiles(19);
    }
}

sectorHolder();
