{ config, pkgs, ... }:

{
  # Включаем Wayland и Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Основные зависимости
  environment.systemPackages = with pkgs; [
    # Утилиты Wayland
    waybar           # Панель
    wofi             # Лаунчер
    wl-clipboard     # Менеджер буфера обмена
    
    # Необходимые утилиты
    kitty            # Терминал
    networkmanagerapplet
    brightnessctl    # Управление яркостью
    pavucontrol      # Управление звуком
    
    # Дополнительные пакеты
    grim             # Скриншоты
    slurp            # Выбор области экрана
    swaylock         # Блокировка экрана
    swayidle         # Управление режимом ожидания
  ];

  # Включаем необходимые сервисы
  services = {
    # DBus
    dbus.enable = true;
    
    # Управление питанием
    acpid.enable = true;
    
    # Звук
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  # Включаем поддержку Polkit
  security.polkit.enable = true;

  # Включаем NetworkManager
  networking.networkmanager.enable = true;

  # Включаем поддержку Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Включаем поддержку видео
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Добавляем пользователя в необходимые группы
  users.users.autumnus = {
    extraGroups = [ "video" "audio" "networkmanager" ];
  };
}
