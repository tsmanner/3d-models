function dHex(e2e) = e2e / sin(60);
function rHex(e2e) = dHex(e2e) / 2;

module Hex(e2e, h) {
  cylinder(d = dHex(e2e), h = h, $fn = 6);
}

function dThread(std) =
  std == "6-32" ? 4 :
  // If it's not found, it is metric already.
  // Add 1/2mm tolerance so it doesn't bind.
  std + 0.5;

function rThread(std) = dThread(std) / 2;

// Thread diameter
// Thread length
// Thread padding
// Head diameter
// Head length
// Head padding
module ScrewStraightHead(td, tl, tp, hd, hl, hp) {
  translate([0, 0, -tp]) cylinder(d = td, h = tl + tp);
  translate([0, 0,  tl]) cylinder(d = hd, h = hl + hp);
}

// Thread diameter
// Thread length
// Thread padding
// Head diameter
// Head length 1: Length of chamfer.
// Head length 2: Length of head above chamfer edge.
// Head padding
module ScrewChamferHead(td, tl, tp, hd, hl1, hl2, hp) {
  translate([0, 0, -tp      ]) cylinder(d  = td,          h = tl + tp);
  translate([0, 0,  tl      ]) cylinder(d1 = td, d2 = hd, h = hl1);
  translate([0, 0,  tl + hl1]) cylinder(d  = hd,          h = hl2 + hp);
}

// Must provide either
// screw_l && head_l && head_d
// screw_l && thread_l && head_d
// screw_l && head_l1 && head_l2 && head_d1 && head_d2
// screw_l && thread_l && head_d
// thread_l && head_l && head_d
// thread_l && head_l1 && head_l2 && head_d1 && head_d2
module Screw(
  std,
  screw_l = undef,
  thread_l = undef,
  thread_padding = 0,
  head_l = undef,
  head_d = undef,
  head_l1 = undef,
  head_l2 = undef,
  head_padding = 0,
) {
  if (head_l1 && head_l2) {
    ScrewChamferHead(
      dThread(std),
      thread_l ? thread_l : screw_l - head_l1 - head_l2,
      thread_padding,
      head_d,
      head_l1,
      head_l2,
      head_padding
    );
  } else {
    ScrewStraightHead(
      dThread(std),
      thread_l ? thread_l : screw_l - head_l,
      thread_padding,
      head_d,
      head_l,
      head_padding
    );
  }
}

module CaseScrew(thread_padding = 0, head_padding = 0) {
  Screw(
    "6-32",
    screw_l = 9,
    head_l = 3,
    head_d = 9
  );
}

CaseScrew(0, 0, $fn = 32);

module HillmanNut() {
  Hex(8, 3);
}

module HillmanScrew(thread_padding = 0, head_padding = 0) {
  Screw(
    "6-32",
    screw_l = 13.3,
    head_l1 = 2.5,
    head_l2 = 0.75,
    head_d = 6.5
  );
}

translate([10, 10]) {
  HillmanScrew(0, 0, $fn = 32);
  HillmanNut();
}
