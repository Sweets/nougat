#!/bin/sh

export PATH="$PWD/bin:$PATH"

if [ "$CI" = "true" ]
then
  bats -t .
else
  bats -p .
fi
