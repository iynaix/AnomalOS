# Desktop environment configuration
# Wayland-based desktop with Hyprland compositor, SDDM, and PipeWire audio
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./hyprland.nix
    ./stylix.nix
    ./media.nix
    ./rofi.nix
    ./flatpak.nix
    ./kdeconnect.nix
  ];

  config = mkIf config.mySystem.features.desktop {
    # Basic desktop services
    services = {
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = config.services.pipewire.enable;
      };

      upower.enable = true;
      ratbagd.enable = true;
      devmon.enable = true;
      locate.enable = true;
    };

    # KWallet PAM integration (SDDM delegates to login stack)
    security.pam.services.login.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };

    # XDG portal setup
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    programs = {
      udevil.enable = true;
    };

    users.users.${config.mySystem.user.name}.packages = with pkgs; [
      # Applications
      file-roller
      gemini-cli
      kdePackages.okular
      pavucontrol
      qalculate-gtk
      qview
      transmission_4-gtk
      unzipNLS
      vlc

      # Utilities
      alarm-clock-applet
      bluetui
      fastfetch
      gparted
      piper

      # System libraries and support
      adwaita-icon-theme
      dbus
      dbus-broker
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.kwalletmanager
      libGL
      libnotify
      libportal
      lm_sensors
      mesa
      wireplumber
      xdg-dbus-proxy

      # Terminal and system utilities
      cliphist
      pamixer
      ueberzugpp

      # X11 compatibility libraries
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXxf86vm
    ];

    # Desktop utility aliases
    environment.shellAliases = {
      gparted = "sudo WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR gparted";
    };

    home-manager.users.${config.mySystem.user.name} = {
      services.swaync = {
        enable = true;
        settings = {
          positionX = "right";
          positionY = "top";
          control-center-margin-top = 10;
          control-center-margin-bottom = 10;
          control-center-margin-right = 10;
          control-center-margin-left = 10;
          timeout = 5;
          timeout-low = 3;
          timeout-critical = 0;
          fit-to-screen = false;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
        };
      };

      stylix.targets.swaync.enable = true;

      services.swaync.style = ''
          * {
            font-family: "DejaVu Sans";
            font-size: 11pt;
          }

          .notification-row {
            margin: 8px;
          }

          .notification {
            background: @base00;
            border: 2px solid @base0D;
            border-radius: 12px;
            padding: 12px;
            margin: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
          }

          .notification.low {
            border: 2px solid @base03;
          }

          .notification.critical {
            border: 2px solid @base08;
            box-shadow: 0 4px 12px rgba(255, 0, 102, 0.3);
          }

          .notification-content {
            background: transparent;
            padding: 8px;
            border: none;
          }

          .summary {
            color: @base05;
            font-weight: bold;
            font-size: 12pt;
            margin-bottom: 4px;
          }

          .body {
            color: @base06;
            font-size: 10pt;
            margin-top: 4px;
          }

          .time {
            color: @base04;
            font-size: 9pt;
            margin-top: 4px;
          }

          .close-button {
            background: @base08;
            color: @base00;
            border-radius: 8px;
            padding: 4px;
            margin: 4px;
            border: none;
          }

          .close-button:hover {
            background: lighter(@base08);
          }

          .notification-action {
            background: @base01;
            color: @base05;
            border: 1px solid @base0D;
            border-radius: 8px;
            padding: 8px;
            margin: 4px;
          }

          .notification-action:hover {
            background: @base02;
          }

          .notification-action:active {
            background: @base0F;
          }

          .control-center {
            background: @base00;
            border: 2px solid @base0D;
            border-radius: 12px;
            padding: 12px;
            margin: 10px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.6);
          }

          .widget-title {
            color: @base05;
            font-size: 14pt;
            font-weight: bold;
            margin: 8px;
          }

          .widget-title > button {
            background: @base01;
            border: 1px solid @base0D;
            border-radius: 8px;
            color: @base05;
            padding: 6px 12px;
          }

          .widget-title > button:hover {
            background: @base02;
          }

          .widget-dnd {
            margin: 8px;
          }

          .widget-dnd > switch {
            background: @base01;
            border: 1px solid @base0D;
            border-radius: 16px;
          }

          .widget-dnd > switch:checked {
            background: @base0B;
          }

          .widget-dnd > switch slider {
            background: @base06;
            border-radius: 12px;
          }
      '';

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = false;
          };

          image = [
            {
              monitor = "";
              path = "\${HOME}/Pictures/monster.jpg";
              border_size = 2;
              border_color = "rgb(${config.lib.stylix.colors.base0C})";
              size = 300;
              rounding = 270;
              position = "25, 0";
              halign = "center";
              valign = "center";
            }
          ];

          label = [
            {
              monitor = "";
              text = "cmd[update:1000] echo -e \"<b>\$(date +\"%A, %B %d\")</b>\"";
              color = "rgb(${config.lib.stylix.colors.base09})";
              font_size = 32;
              font_family = "Iosevka Nerd Font";
              position = "0, -110";
              halign = "center";
              valign = "top";
            }
            {
              monitor = "";
              text = "cmd[update:1000] echo \"<span>\$(date +\"%X\")</span>\"";
              color = "rgb(${config.lib.stylix.colors.base09})";
              font_size = 42;
              font_family = "Iosevka Nerd Font";
              position = "0, -150";
              halign = "center";
              valign = "top";
            }
            {
              monitor = "";
              text = "   \$USER";
              color = "rgb(${config.lib.stylix.colors.base0E})";
              outline_thickness = 2;
              font_size = 20;
              font_family = "Iosevka Nerd Font";
              position = "0, 157";
              halign = "center";
              valign = "bottom";
            }
          ];

          shape = [
            {
              monitor = "";
              size = "320, 55";
              color = "rgb(${config.lib.stylix.colors.base00})";
              rounding = -1;
              border_size = 2;
              border_color = "rgb(${config.lib.stylix.colors.base0C})";
              position = "0, 140";
              halign = "center";
              valign = "bottom";
            }
          ];

          input-field = lib.mkForce [
            {
              monitor = "";
              size = "320, 55";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.2;
              dots_center = true;
              outer_color = "rgb(${config.lib.stylix.colors.base0C})";
              inner_color = "rgb(${config.lib.stylix.colors.base00})";
              font_color = "rgb(${config.lib.stylix.colors.base0E})";
              fade_on_empty = false;
              font_family = "Iosevka Nerd Font";
              placeholder_text = "<span foreground=\"##${config.lib.stylix.colors.base0C}\">    </span>";
              hide_input = false;
              position = "0, -450";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
      stylix.targets.hyprlock.enable = true;

      programs.wezterm = {
        enable = true;
        extraConfig = ''
          config.font = wezterm.font("Terminess Nerd Font")
          config.font_size = 14.0
          config.use_fancy_tab_bar = true
          config.enable_tab_bar = true
        '';
      };
      stylix.targets.wezterm.enable = true;

      xdg.dataFile."applications/org.wezfurlong.wezterm.desktop".text = ''
        [Desktop Entry]
        Name=WezTerm
        Comment=Wez's Terminal Emulator
        Keywords=shell;prompt;command;commandline;cmd;
        Icon=org.wezfurlong.wezterm
        StartupWMClass=org.wezfurlong.wezterm
        TryExec=wezterm
        Exec=env WEZTERM_CONFIG_FILE=/home/${config.mySystem.user.name}/.config/wezterm/wezterm.lua wezterm start --cwd .
        Type=Application
        Categories=System;TerminalEmulator;Utility;
        Terminal=false
      '';

      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        keymap = builtins.fromTOML (builtins.readFile ./yazi/keymap.toml);
        settings = builtins.fromTOML (builtins.readFile ./yazi/yazi.toml);

        plugins = {
          mount =
            pkgs.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "plugins";
              rev = "main";
              sha256 = "sha256-7vsqHvdNimH/YVWegfAo7DfJ+InDr3a1aNU0f+gjcdw=";
            }
            + "/mount.yazi";
          git =
            pkgs.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "plugins";
              rev = "main";
              sha256 = "sha256-7vsqHvdNimH/YVWegfAo7DfJ+InDr3a1aNU0f+gjcdw=";
            }
            + "/git.yazi";
        };

        initLua = ''
          require("git"):setup()
        '';

        # Override Stylix theme background
        theme = {
          mgr = {
            bg = lib.mkForce "#${config.lib.stylix.colors.base00}";
          };
          status = {
            separator_open = lib.mkForce "";
            separator_close = lib.mkForce "";
            separator_style = lib.mkForce {
              fg = "#${config.lib.stylix.colors.base00}";
              bg = "#${config.lib.stylix.colors.base00}";
            };
          };
          which = {
            mask = {
              bg = lib.mkForce "#${config.lib.stylix.colors.base00}";
            };
          };
        };
      };
      stylix.targets.yazi.enable = true;
      stylix.targets.vesktop.enable = true;

      programs.vesktop.enable = true;

      # XDG MIME type associations
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.kde.okular.desktop";
        };
      };

      xdg.dataFile."applications/yazi.desktop".text = ''
        [Desktop Entry]
        Name=Yazi
        Icon=yazi
        Comment=Blazing fast terminal file manager written in Rust, based on async I/O
        Exec=env WEZTERM_CONFIG_FILE=/home/${config.mySystem.user.name}/.config/wezterm/wezterm.lua wezterm -e yazi %u
        Terminal=false
        Type=Application
        MimeType=inode/directory
        Categories=Utility;Core;System;FileTools;FileManager;ConsoleOnly;
        Keywords=File;Manager;Explorer;Browser;Launcher;
      '';

      # Fastfetch configuration
      xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = {
          source = "~/dotfiles/modules/desktop/AnomLogo.png";
          height = 20;
          width = 40;
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "wm"
          "terminal"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "break"
          "colors"
        ];
      };
    };

    # Desktop fonts
    fonts.packages = with pkgs.nerd-fonts; [
      dejavu-sans-mono
      zed-mono
      jetbrains-mono
      fira-code
      terminess-ttf
      space-mono
      hack
      iosevka
    ];
  };
}
