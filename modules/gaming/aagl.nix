{
  config,
  lib,
  inputs,
  ...
}:
with lib; {
  config = mkIf config.mySystem.features.gaming {
    # Anime Game Launchers (Genshin, Honkai, Wuthering Waves, ZZZ)
    programs = {
      anime-game-launcher.enable = true;      # Genshin Impact
      honkers-railway-launcher.enable = true; # Honkai: Star Rail
      honkers-launcher.enable = true;         # Honkai Impact 3rd
      wavey-launcher.enable = true;           # Wuthering Waves
      sleepy-launcher.enable = true;          # Zenless Zone Zero
    };

    # Use the aagl nixConfig for additional settings
    nix.settings = inputs.aagl.nixConfig;
  };
}
