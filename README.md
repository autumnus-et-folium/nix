# Установка NixOS

## Подготовка диска
Запустите скрипт разметки:
```bash
bash <(curl -sL https://raw.githubusercontent.com/autumnus-et-folium/nix/main/partitioning.sh)

nixos-install --flake /mnt/root/nix#default
