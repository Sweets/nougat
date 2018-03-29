#!/usr/bin/env bats

@test "nougat -p" {
 YEAR="$(ls -1 ~/Screenshots | head -1)"
 MONTH="$(ls -1 ~/Screenshots/$YEAR | head -1)"
 DAY="$(ls -1 ~/Screenshots/$YEAR/$MONTH | head -1)"
 SCREENSHOT="$(ls -1 ~/Screenshots/$YEAR/$MONTH/$DAY | shuf | head -1)"

 test -L "$HOME/Screenshots/All/$YEAR-$MONTH-$DAY.$SCREENSHOT"

 rm -f "$HOME/Screenshots/$YEAR/$MONTH/$DAY/$SCREENSHOT"

 ../nougat.sh -tpf

 ! test -L "$HOME/Screenshots/All/$YEAR-$MONTH-$DAY.$SCREENSHOT"
}
