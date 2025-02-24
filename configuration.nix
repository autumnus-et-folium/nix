# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.mesa
      pkgs.amdvlk
      pkgs.libvdpau-va-gl
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
    experimental = false;
    metrics-addr = "0.0.0.0:9323";
  };
  virtualisation.virtualbox.host.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, ru";
    options = "grp:alt_space_toggle";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.autumnus = {
    isNormalUser = true;
    description = "sergius";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "video" "render" "vboxusers" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
#  services.xserver.displayManager.autoLogin.enable = true;
#  services.xserver.displayManager.autoLogin.user = "autumnus";
  services.displayManager.autoLogin = {
    enable = true;
    user = "autumnus";
  };

  #dns
#  services.resolved.enable = true;
#  services.resolved.dnsOverTls = "opportunistic";
#  services.resolved.dns = "9.9.9.9";
#  services.libvirtd.enable = true;
#  services.libvirtd.wheelGroup = "libvirt";

  # Install firefox.
  programs.firefox.enable = true;
  programs.vim.enable = true;
  programs.git.enable = true;
  programs.zsh.enable = true;
#  programs.vagrant.enable = true; #  programs.vagrant.plugins = [pkgs.vagrantDocker]; #не существует памятка про плагин

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     google-chrome
     k3d
     kubectl
     kubectx
     slack
     telegram-desktop
     nemo
     mpv
     obs-studio
     yt-dlp

     nekoray 
    
     terminus_font
     ffmpeg
     grim
     slurp
     dunst
     dig
     transmission_4-qt6
     libvirt
     virt-manager
#     terraform-providers.libvirt
     qemu_kvm
     logrotate
     jq
     lsof
     vnstat
     nmap
     btop
     glances
     mtr
     
#?     kubens
     glxinfo
     htop
     radeontop
     virtualbox
     python3
#?     pip
     kubernetes-helm
     helmfile
     ansible
     docker-compose
     jetbrains.pycharm-community
#     terraform
     vagrant
     vscode

     oh-my-zsh
     zsh-autosuggestions
     zsh-syntax-highlighting

     vimPlugins.vim-fugitive
     vimPlugins.syntastic
     vimPlugins.vim-airline

     alacritty
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
