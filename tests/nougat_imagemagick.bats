#!/usr/bin/env bats

export NOUGAT_BACKEND="imagemagick"

load nougat_helper

@test "nougat -b $NOUGAT_BACKEND" {
  nougat
}

@test "nougat -b $NOUGAT_BACKEND -f" {
  nougat_f
}

@test "nougat -b $NOUGAT_BACKEND -fs" {
  nougat_fs
}

@test "nougat -b $NOUGAT_BACKEND -ft" {
  nougat_ft
}

@test "nougat -b $NOUGAT_BACKEND -ftc" {
  nougat_ftc
}
