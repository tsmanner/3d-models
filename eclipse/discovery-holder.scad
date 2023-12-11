include <measurements.scad>

holder(thickness*discovery_count) {
    discovery_tile_shape(discovery_w + thickness*2);
    discovery_tile_shape(discovery_w);
    discovery_tile_shape(discovery_w - thickness*2);
}
