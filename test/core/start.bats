#!/usr/bin/env bats

load ${test_root}/helpers.bash

@test "no arguments and not in directory" {
  run svc start
  [ "$status" -eq 1 ]
  [ "$output" = "fatal: $(basename $(pwd)) is not a recognised microservice directory" ]
}

@test "no arguments and in directory" {
  cd ${WORKSPACE}/vat-summary-frontend
  run svc start
  [ "$status" -eq 0 ]
  [ "$output" = "success: service 'vat-summary-frontend' started on port 9152" ]
}

@test "short help argument" {
  run svc start -h
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "start running a microservice" ]
}

@test "long help argument" {
  run svc start --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "start running a microservice" ]
}

@test "with arguments" {
  run svc start vat-summary-frontend
  [ "$status" -eq 0 ]
  [ "$output" = "success: service 'vat-summary-frontend' started on port 9152" ]
}
