#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_dir="$repo_root/relay-package"

if [[ -n "${THEOS:-}" ]]; then
  theos_dir="$THEOS"
else
  theos_dir="${THEOS_DIR:-$HOME/theos}"
fi

if [[ ! -d "$theos_dir/.git" ]]; then
  echo "Theos was not found at $theos_dir" >&2
  echo "Set THEOS or THEOS_DIR to your install location." >&2
  exit 1
fi

git -C "$theos_dir" submodule update --init --recursive

if ! rustup target list --installed | grep -qx 'aarch64-apple-ios'; then
  rustup target add aarch64-apple-ios
fi

sdk_path="$(xcrun --sdk iphoneos --show-sdk-path)"
export SDKROOT="$sdk_path"

THEOS="$theos_dir" make -C "$package_dir" clean package FINALPACKAGE=1

artifact="$(find "$package_dir/packages" -maxdepth 1 -name '*.deb' -type f | sort | tail -n 1)"
if [[ -z "$artifact" ]]; then
  echo "Build completed but no .deb was found in $package_dir/packages" >&2
  exit 1
fi

echo "$artifact"
