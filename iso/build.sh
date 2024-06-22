#!/usr/bin/env bash

set -euo pipefail
script_location="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

nix flake update --no-write-lock-file "${script_location}"
nix build --no-link --print-out-paths --cores 0 ${script_location}#nixosConfigurations.minimal_iso.config.system.build.isoImage | xargs -I{} find {} -type f -name "*.iso"
