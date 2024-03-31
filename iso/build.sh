#!/usr/bin/env bash

script_location="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

nix build --cores 0 ${script_location}#nixosConfigurations.minimal_iso.config.system.build.isoImage
