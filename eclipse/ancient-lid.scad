include <measurements.scad>

lid() {
    circle(r=ancient_r+thickness, $fn=7);
    circle(r=ancient_r, $fn=7);
    circle(r=finger_d/2, $fn=7);
}
