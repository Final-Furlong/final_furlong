# Final Furlong

[![CI](https://github.com/Final-Furlong/final_furlong/actions/workflows/test.yml/badge.svg)](https://github.com/Final-Furlong/final_furlong/actions/workflows/test.yml) | [![Maintainability](https://api.codeclimate.com/v1/badges/83d464b7f230d7c654c6/maintainability)](https://codeclimate.com/repos/6277f8245c68b90ca1004642/maintainability) | [![Test Coverage](https://api.codeclimate.com/v1/badges/83d464b7f230d7c654c6/test_coverage)](https://codeclimate.com/repos/6277f8245c68b90ca1004642/test_coverage)

## Setup

1. Clone the repo
2. Make sure Postgres is installed & running
3. Run `bin/setup`

## Running the App

1. Run `overmind start`

## Tests and CI

1. `bin/ci` runs tests + security checks
2. `log/test.log` will use production logging format

## Production

* Rails logging is done via lograge.
  Run `bin/setup help` to learn how to run this locally.
