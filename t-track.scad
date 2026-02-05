function wSlot(type) =
  type == "25" ? 6.5 :
  undef;

function hSlot(type) =
  type == "25" ? 2.25 :
  undef;

function wChannel(type) =
  type == "25" ? [16.5, 5.5] :
  undef;

function hChannel(type) =
  type == "25" ? 5.5 :
  undef;

function rChannel(type) =
  type == "25" ? 1 :
  undef;

function wFrame(type) =
  type == "25" ? 25 :
  undef;

module Channel(type) {
  $fn = 64;
    sw = wSlot(type);
    sh = hSlot(type);
    cw = wChannel(type);
    ch = hChannel(type);
    r  = rChannel(type);

  translate([0, -sh]) {
    minkowski() {
      circle(r=1);
      offset(delta=-r) {
        polygon([
          [-cw[0]/2, 0],
          [ cw[0]/2, 0],
          [ cw[1]/2, -ch],
          [-cw[1]/2, -ch],
        ]);
      }
    }
    translate([-sw/2, 0])
      square([sw, sh]);
  }
}

Channel("25");
