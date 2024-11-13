#!/usr/bin/env bash
set -euo pipefail
# set -x

echo "building installer..."
nix build '.#nixosConfigurations.superbird.config.system.build.installer' -j"$(nproc)" --show-trace
echo "kernel is $(stat -Lc%s -- result/linux/kernel | numfmt --to=iec)"
echo "initrd is $(stat -Lc%s -- result/linux/initrd.img | numfmt --to=iec)"
echo "rootfs (sparse) is $(stat -Lc%s -- result/linux/rootfs.img | numfmt --to=iec)"

rm -rf ./out
mkdir ./out
cp -r ./result/* ./out/
cd ./out

echo "shrinking rootfs image..."
./scripts/shrink-img.sh
echo "rootfs (compact) is $(stat -Lc%s -- ./linux/rootfs.img | numfmt --to=iec)"

echo "done! find your installer at ./out!"
