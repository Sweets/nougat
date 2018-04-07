#!/usr/bin/env bats

@test "nougat should not create symlinks when a linking policy is not defined" {
 ../nougat.sh -f

 [[ -d "$HOME/Screenshots/All" ]]

 rm -rf "$HOME/Screenshots/All"

 sed -i 's/^NOUGAT_LINKING_POLICY.*$//g' ~/.config/nougat

 ../nougat.sh -f

 [[ ! -d "$HOME/Screenshots/All" ]]
}

