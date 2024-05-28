{ config, pkgs, ... }:

{


 # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "steve";
  home.homeDirectory = "/home/steve";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/steve/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
    };
  };

  # Git settings
  programs.git = {
    enable = true;
    userName = "Steve Wood";
    userEmail = "steve@lochrig.scot";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/steve/.config/nixos";
    };
  };

# Hyprland settings
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,auto"
    ];

    exec-once = [
      "waybar"
      "hyprpaper"
    ];

    env = [
      "XCURSOR_SIZE,24"
    ];

    input = {
      kb_layout = "gb";
      follow_mouse = 1;

      touchpad = {
        natural_scroll = "no";
      };
      
      sensitivity = 0;
    };

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;

      layout = "dwindle";

      allow_tearing = false;
    };

    decoration = {
      rounding = 10;

      blur = {
        enabled = true;
	size = 3;
	passes = 1;
      };

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      };

    "$mod" = "SUPER";
    bind =
    [
      "$mod, D, exec, rofi -show combi"
      "$mod, return, exec, kitty"
      "$mod SHIFT, Q, killactive"
      "$mod SHIFT, E, exit"
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

    ]
    ++ (
      # workspace binds via fancy code
      builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
	    ]
	   )
      10)
    );

    binde = 
    [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];
  };

  stylix.image = ./new_test.jpg;
  stylix.polarity = "dark";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
