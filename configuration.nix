{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Basic system configuration
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.groups.autumnus = {};
  users.users.autumnus = {
    isNormalUser = true;
    group = "autumnus";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "video" "audio" "input" ];
    initialPassword = "sergius";
  };

  # Sudo configuration
  security.sudo.extraRules = [
    {
      groups = [ "autumnus" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    git vim wget curl
    
    # Terminal and shell
    kitty zsh oh-my-zsh
    
    # Development tools
    docker docker-compose
    vagrant vagrant-libvirt
    terraform
    ansible ansible-lint
    packer pre-commit
    yamllint tfsec
    kubectl helm
    vscode pycharm-community
    python3
    
    # System monitoring and networking
    btop glances mtr
    nmap tcpdump wireshark-cli
    htop vnstat lsof jq
    dig ss iproute2
    rsync logrotate
    
    # Wayland and Hyprland
    wayland
    xwayland
    hyprland
    waybar
    wofi
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-utils
    swww
    dunst
    grim
    slurp
    wl-clipboard
    wlogout
    qt5.qtwayland
    qt6.qtwayland
    polkit-kde-agent
    
    # Applications
    firefox google-chrome
    slack telegram-desktop
    nemo mpv
    obs-studio
    yt-dlp youtube-dlg
    
    # Other utilities
    v2ray qv2ray
    terminus_font
    logiops
    ffmpeg
    openssh
    libsForQt5.xwaylandvideobridge
  ];

  # DNS configuration
  services.resolved = {
    enable = true;
    dnsOverTls = "opportunistic";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com
      DNS=9.9.9.9#dns.quad9.net
    '';
  };

  # Docker configuration
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features = {
        buildkit = true;
      };
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Wayland and Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  # Required for screen sharing
  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Waybar configuration
  programs.waybar.enable = true;

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 53 2375 2376 22 ];
    allowedUDPPorts = [ 53 ];
    denyPorts = [ 1900 ];
    logDeny = true;
  };

  networking.nftables.enable = true;

  # System services
  services = {
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;
    logid.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };
  };

  # Security and authentication
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # Boot configuration
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "quiet";
    };
    efi.canTouchEfiVariables = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hyprland default configuration
  programs.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, Q, exec, wlogout"
      "$mod, L, exec, loginctl lock-session"
      "$mod, D, exec, wofi --show drun"
      "$mod, S, togglespecialworkspace, magic"
    ];
  };

  # Enable fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # System version
  system.stateVersion = "23.11";
}
