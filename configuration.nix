{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Установка имени хоста
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Настройки пользователей
  users.groups.autumnus = {};
  users.users.autumnus = {
    isNormalUser = true;
    group = "autumnus";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "sergius";
  };

  # Настройка sudo
  security.sudo.extraRules = [
    {
      groups = [ "autumnus" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # Установка нужных пакетов
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

  # Настройки systemd-resolved с DNS over TLS
  services.resolved = {
    enable = true;
    dnsOverTls = "opportunistic";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com
      DNS=9.9.9.9#dns.quad9.net
    '';
  };

  # Настройка Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Настройка Hyperland
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Waybar стилизация и поведение
  programs.waybar.enable = true;

  # Файрвол и защита сети
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 53 2375 2376 ];
    allowedUDPPorts = [ 53 ];
    denyPorts = [ 22 1900 ];
  };
  networking.nftables.enable = true;
  
  # Логирование попыток доступа через firewall
  networking.firewall.logDeny = true;

  # Автомонтирование флешек с запросом пароля
  services.udisks2.enable = true;

  # GNOME Keyring для SSH-ключей
  services.gnome.gnome-keyring.enable = true;
  
  # Включение logid для Logitech MX Master 3
  services.logid.enable = true;

  # Настройки загрузчика
  boot.loader.systemd-boot.consoleMode = "quiet";

  # Разрешаем использование несвободных пакетов
  nixpkgs.config.allowUnfree = true;

  # Настройка горячих углов в Hyprland
  programs.hyprland.settings.binds = [
    "movecursor 0 0 exec wlogout"  # Левый верхний угол - меню выхода
    "movecursor 100 0 exec loginctl lock-session"  # Правый верхний угол - блокировка экрана
    "movecursor 0 100 exec wofi --show drun"  # Левый нижний угол - запуск Wofi (лаунчбар)
    "movecursor 100 100 exec hyprctl dispatch togglespecialworkspace magic"  # Правый нижний угол - показать рабочий стол
  ];

  system.stateVersion = "23.11";
}
