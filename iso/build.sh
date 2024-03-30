#!/usr/bin/env bash
nix build .#nixosConfigurations.minimal_iso.config.system.build.isoImage
