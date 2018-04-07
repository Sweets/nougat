#!/usr/bin/env bats

@test "nougat -h" {
  ../nougat -h

  [ "$?" -eq 0 ]
}
