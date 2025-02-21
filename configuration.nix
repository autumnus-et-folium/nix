{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.groups.autumnus = {};
  users.users.autumnus = {
    isNormalUser = true;
    group = "autumnus";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "sergius";
  };

  security.sudo.extraRules = [
    {
      groups = [ "autumnus" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    kitty
    zsh
    oh-my-zsh
    docker
    docker-compose
    vagrant
    vagrant-libvirt
    terraform
    networkmanager-dmenu
    nemo
    mpv
    btop
    glances
    dig
    ss
    mtr
    journalctl
    rsync
    logrotate
    grep
    pgrep
    ps
    iproute2
    openssh
    hyprland
    xdg-desktop-portal-hyprland
    waybar
    wofi
    v2ray
    qv2ray
    wlogout
    terminus_font
    ansible
    slack
    firefox
    google-chrome
    vscode
    yt-dlp
    youtube-dlg
    logiops
    pycharm-community
    kubectl
    helm
    tfsec
    packer
    pre-commit
    ansible-lint
    yamllint
    nmap
    tcpdump
    wireshark-cli
    htop
    vnstat
    lsof
    jq
    cat
    ls
    nftables
    xdg-desktop-portal-gtk
    libsForQt5.xwaylandvideobridge
    python3
    udisk
    ffmpeg
    telegram-desktop
    obs-studio
  ];

  services.resolved = {
    enable = true;
    dnsOverTls = "opportunistic";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com
      DNS=9.9.9.9#dns.quad9.net
    '';
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.waybar.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 53 2375 2376 ];
    allowedUDPPorts = [ 53 ];
    denyPorts = [ 22 1900 ];
  };
  networking.nftables.enable = true;
  
  networking.firewall.logDeny = true;

  services.udisks2.enable = true;

  services.gnome.gnome-keyring.enable = true;
  
  services.logid.enable = true;

  boot.loader.systemd-boot.consoleMode = "quiet";

  nixpkgs.config.allowUnfree = true;

  programs.hyprland.settings.binds = [
    "movecursor 0 0 exec wlogout" 
    "movecursor 100 0 exec loginctl lock-session"
    "movecursor 0 100 exec wofi --show drun"
    "movecursor 100 100 exec hyprctl dispatch togglespecialworkspace magic"  
  ];

  system.stateVersion = "23.11";
}
