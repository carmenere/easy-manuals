# Prerequisites
```bash
apt install -y dosfstools p7zip-rar p7zip-full
```

<br>

# Create EFI System Partition
**EFI System Partition** (aka **ESP**) is a partition on a data storage device that is used by computers having the **Unified Extensible Firmware Interface** (**UEFI**).<br>

1. List all devices: `fdisk -l`.
2. Enter to **interactive** mode: `fdisk /dev/sdX`.
3. In **interactive** mode:
   - create **GPT** table;
   - create partition **+8G**;
   - set partition type `EFI system` (id `1`);
4. Then format `/dev/sdX1` to **FAT32**: `mkfs.fat -F 32 /dev/sdX1`.

<br>

# Copy files from .iso image to partition:
1. Run `mkdir -p /mnt/efi`.
2. Run `mount /dev/sdXn /mnt/efi`.
3. Run `7z x /path/to/ubuntu-*.iso -o/mnt/efi`.
4. Run `sync`.
5. Run `umount /mnt/efi`.

<br>

# Create partition for data
1. Create partition for **data**, set its type to `Microsot base data` (id `11`).
2. Format it to `NTFS`: `mkfs.ntfs /dev/sdX2`.

<br>

# UEFI booting steps
On each device, `UEFI` looks for all `ESP` partitions.<br>
Within each `ESP` partition, `UEFI` looks for a specifically-named **bootloader file**  with a different name per architecture: `/EFI/boot/boot<ARCH>.efi`.
- `/EFI/boot/bootx64.efi` for **amd64**;
- `/EFI/boot/bootia32.efi` for **i386**;
- `/EFI/boot/bootaa64.efi` for **arm64**;
- `/EFI/boot/bootarm.efi` for **armhf**;
