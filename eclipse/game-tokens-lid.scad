include <measurements.scad>
use <game-tokens-holder.scad>


difference() {
    body(thickness*2);
    game_tokens_holder();
}
