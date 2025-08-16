echo "Do not execute this."
echo "Copy things from this and do it MANUALLY."
exec false # not exit 1 just so my LSP doesn't complain

# source https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html

# ====================
#    Remote  access
# ====================

sudo passwd root
systemctl restart sshd

# At this point, stop running this locally
ip addr
ssh root@192.168.X.Y

# ====================
#         SSD
# ====================
# show available disks
find /dev/disk/by-id/

# --------------------
#     Partitioning
# --------------------

# For the SSD
DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
MNT=$(mktemp -d)

# Clear all existing partition tables and data structures
wipefs $DISK # check
wipefs -a $DISK

# Leave 1MiB, then make a partition 4GiB large (labelled EFI)
# Make a pool for ZFS from 4GiB to SWAPFILE+RESERVE away from the end
# Make a pool for swap from SWAPFILE+RESERVE away from the end to RESERVE away from the end
# 3% of SSD space is given to SWAP,
# 7% is left empty for wear leveling
parted --script --align=optimal "${DISK}" -- \
        mklabel gpt \
        mkpart EFI 1MiB 4GiB \
        mkpart rpool 4GiB 90% \
        mkpart swap 90% 93% \
        set 1 esp on

# Check
lsblk $DISK -o name,partlabel,size

# tells the OS about the new partitions
partprobe $DISK

# -----------------
#     ZFS setup
# -----------------

# Check that $DISK-part2 exists
find /dev/disk/by-id/

# Set up ZFS
# ashift = 4KiB block size
# autotrim for SSDs
# mount to the tmpdir
# use POSIX ACL (permissions)
# don't mount the pool, mount the children
# let it choose the dnode
# use Unicode normalization
# don't update access times unless modified
# store extended attributes (like where a jpg was downloaded) in the system attributes instead of a separate file
zpool create \
        -o ashift=12 \
        -o autotrim=on \
        -R "${MNT}" \
        -O acltype=posixacl \
        -O canmount=off \
        -O dnodesize=auto \
        -O normalization=formD \
        -O relatime=on \
        -O xattr=sa \
        -O mountpoint=none \
        rpool \
        "${DISK}-part2"

# Check
zpool status

# Create root with lz4 compression
zfs create -o canmount=noauto -o mountpoint=legacy -o compression=lz4 rpool/root
mount -o X-mount.mkdir -t zfs rpool/root "${MNT}"

# ---------------------------
#     Mount boot and swap
# ---------------------------

# Check
mount | grep rpool

# Make and mount vfat
mkfs.vfat -n EFI "${DISK}"-part1
# Mount it with owner read-only, the right charset
mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1,X-mount.mkdir "${DISK}"-part1 "${MNT}"/boot

# Check
mount | grep vfat

# Make and use swap
mkswap "${DISK}"-part3
swapon "${DISK}"-part3

# Check
swapon --show

# ====================
#         HDD
# ====================

# --------------------
#     Partitioning
# --------------------

find /dev/disk/by-id/

DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00005'

wipefs $DISK # check
wipefs -a $DISK

# Only one partition
# No need to give reserve space because it's an HDD
parted --script --align=optimal "${DISK}" -- \
        mklabel gpt \
        mkpart server-storage 1MiB -1MiB

lsblk $DISK -o name,partlabel,size
partprobe $DISK

# -----------------
#     ZFS setup
# -----------------

# Check that $DISK-part1 exists
find /dev/disk/by-id/

zpool create \
        -o ashift=12 \
        -o autotrim=on \
        -R "${MNT}" \
        -O acltype=posixacl \
        -O canmount=off \
        -O dnodesize=auto \
        -O normalization=formD \
        -O relatime=on \
        -O xattr=sa \
        -O mountpoint=none \
        server-storage \
        "${DISK}-part1"

zpool status

zfs create -o canmount=noauto -o mountpoint=legacy -o compression=lz4 server-storage/data
zfs create -o canmount=noauto -o mountpoint=legacy -o compression=off server-storage/data/jellyfin-media
mount -o X-mount.mkdir -t zfs server-storage/data "${MNT}/media/server-storage"
mount -o X-mount.mkdir -t zfs server-storage/data/jellyfin-media "${MNT}/media/server-storage/jellyfin-media"

mount | grep server-storage

# ====================
#     Installation
# ====================

nixos-generate-config --root "${MNT}"
# Ensure all disks are in the hardware configuratoin
cat "$MNT/etc/nixos/hardware-configuration.nix"
cat "$MNT/etc/nixos/configuration.nix"

# You must:
# 1. Uncomment the user account AND CHANGE THE NAME TO miniluz
# 2. Set networking.hostId for ZFS to work
head -c 8 /etc/machine-id                # Get one from your machine-id or
head -c4 /dev/urandom | od -A none -t x4 # Generate a random one
# 3. Enable the SSH server (opens port by default)
vim "${MNT}/etc/nixos/configuration.nix"

# Install
# You will need to set the password for root upon installation.
# BE CAREFUL WITH THE KEYMAP AS THE DEFAULT ONE WILL BE USED
nixos-install --root "${MNT}"

# Unmount, export and reboot
cd /
umount -Rl "${MNT}"
zpool export -a # this makes ZFS cleanly close the pool, flush the caches to disk and mark it as unused

reboot

# ====================
#   After the reboot
# ====================
#
# In the actual server, you will need to:
# 1. Log in with root, with the password you have set up during the rebuild.
# 2. passwd miniluz
#
# Now you can SSH in again.
# 1. Clone your nixos-repo
# 2. Run first-time-setup.sh
# 3. Follow what's stated in the README
#
