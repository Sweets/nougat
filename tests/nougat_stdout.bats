#!/usr/bin/env bats

@test "nougat -fi" {
  ../nougat.sh -fi > /tmp/file.png
  
  FILE="$(file --mime-type --brief "/tmp/file.png")"

  [[ "$FILE" == "image/png" ]]
}

@test "stdout shouldn't output to a terminal" {
  xterm -e '! ../nougat.sh -fi && exit 0 || kill -9 $(ps -o ppid= -p $$)'
}
