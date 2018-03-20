#!/usr/bin/env bats

@test "nougat -h" {
  ../nougat.sh -h

  [ "$?" -eq 0 ]
}
