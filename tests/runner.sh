#!/bin/sh

export PATH="$PWD/bin:$PATH"

bats -t .
