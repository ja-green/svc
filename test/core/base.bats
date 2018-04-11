#!/usr/bin/env bats

load ${test_root}/helpers.bash

@test "no arguments" {
  run svc
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "usage:  " ]
}

@test "short help argument" {
  run svc -h
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "usage:  " ]
}

@test "long help argument" {
  run svc --help
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "usage:  "   ]
}
