#!/usr/bin/env bash

[ -z "$NOUGAT_BACKEND" ] && exit 1

nougat() {
  if [ "$CI" = "true" ]
  then
    printf "Running in CI so cannot test mouse selection\\n" > /dev/stderr
    return 0
  fi

  export DATE="@$RANDOM"
  echo "$RANDOM" > /dev/null
  ../nougat -b $NOUGAT_BACKEND >> /tmp/test.log 2>&1 &

  sleep 1

  cnee --replay -f cnee.data -e /dev/null -ns > /dev/null 2>&1 || true

  read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

  [ -f "$HOME/Screenshots/${year}/${month}/${day}/${hour}:${minute}:${second}.png" ]
  [ -f "$HOME/Screenshots/All/${year}-${month}-${day}.${hour}:${minute}:${second}.png" ]
}

nougat_f() {
  export DATE="@$RANDOM"
  echo "$RANDOM" > /dev/null
  ../nougat -b $NOUGAT_BACKEND -f >> /tmp/test.log 2>&1

  [ "$?" -eq 0 ]

  read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

  [ -f "$HOME/Screenshots/${year}/${month}/${day}/${hour}:${minute}:${second}_full.png" ]
  [ -f "$HOME/Screenshots/All/${year}-${month}-${day}.${hour}:${minute}:${second}_full.png" ]

}

nougat_fs() {
  export DATE="@$RANDOM"
  echo "$RANDOM" > /dev/null

  # Should be silent (no output)
  if ! STDOUT="$(../nougat -b $NOUGAT_BACKEND -fs)"
  then
    printf "%s" "$STDOUT" >> /tmp/test.log 2>&1
    return 1
  fi

  printf "%s" "$STDOUT" >> /tmp/test.log 2>&1

  [ "$STDOUT" = "" ]

  read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

  [ -f "$HOME/Screenshots/${year}/${month}/${day}/${hour}:${minute}:${second}_full.png" ]
  [ -f "$HOME/Screenshots/All/${year}-${month}-${day}.${hour}:${minute}:${second}_full.png" ]
}

nougat_ft() {
  export DATE="@$RANDOM"
  echo "$RANDOM" > /dev/null

  ../nougat -b $NOUGAT_BACKEND -ft >> /tmp/test.log 2>&1

  [ "$?" -eq 0 ]

  read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

  [ -f "/tmp/${year}-${month}-${day}.${hour}:${minute}:${second}_full.png" ]
}

nougat_ftc() {
  export DATE="@$RANDOM"
  echo "$RANDOM" > /dev/null

  echo "" | xclip -selection clipboard -i

  # The `xterm` is necessary otherwise `bats` hangs. I don't think this is
  # a nougat issue since I can't reproduce it outside of the test environment
  # and running `nougat -b $NOUGAT_BACKEND -ftc` over VNC immediately fixes
  # things. I think this is some sort of race-condition :S
  xterm -e "echo '' | xclip -selection clipboard -i;../nougat -b $NOUGAT_BACKEND -ftc;xclip -selection clipboard -o > /tmp/${NOUGAT_BACKEND}_clipboard.png" >> /tmp/test.log 2>&1

  [ "$?" -eq 0 ]

  read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

  [ -f "/tmp/${year}-${month}-${day}.${hour}:${minute}:${second}_full.png" ]

  FILE="$(file --mime-type --brief "/tmp/${NOUGAT_BACKEND}_clipboard.png")"

  [ "$FILE" = "image/png" ]
}
