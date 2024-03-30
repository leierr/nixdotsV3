#!/usr/bin/env bash

script_location="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
nix-build '<nixpkgs/nixos>' --no-link -A config.system.build.isoImage -I nixos-config=${script_location}/iso.nix
