enum Player {
  x,
  o;

  Player get opponent => this == x ? o : x;
}
