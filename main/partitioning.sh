
---

### 2. **partitioning.sh** (Скрипт разметки диска)  
###Этот файл нужен для автоматического создания разделов, форматирования и монтирования.  

```bash
#!/bin/bash
set -e

DISK="/dev/nvme0n1"

if [ "$(id -u)" -ne 0 ]; then
    echo "Запустите скрипт с правами root!"
    exit 1
fi

echo "Разметка диска $DISK..."
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart ESP fat32 1MiB 512MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary linux-swap 512MiB 8GiB
parted -s "$DISK" mkpart primary ext4 8GiB 100%

echo "Форматирование разделов..."
mkfs.fat -F32 "${DISK}p1"
mkswap "${DISK}p2" && swapon "${DISK}p2"
mkfs.ext4 "${DISK}p3"

echo "Монтирование файловых систем..."
mount "${DISK}p3" /mnt
mkdir -p /mnt/boot
mount "${DISK}p1" /mnt/boot

echo "Клонирование конфигурации..."
nix-env -iA nixpkgs.git
git clone https://github.com/autumnus-et-folium/nix.git /mnt/root/nix

echo "Готово! Теперь настройте NixOS."
