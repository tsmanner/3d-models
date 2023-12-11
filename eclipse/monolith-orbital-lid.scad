include <measurements.scad>

lid() {
    circle(d=monolith_orbital_d+thickness, $fn=128);
    circle(d=monolith_orbital_d, $fn=128);
    circle(d=finger_d, $fn=128);
}
