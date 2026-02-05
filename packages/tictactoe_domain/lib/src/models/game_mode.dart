enum GameMode {
  multiplayer,
  easy,
  medium,
  hard;

  bool get isMultiplayer => this == GameMode.multiplayer;
  bool get isSinglePlayer => !isMultiplayer;
}
