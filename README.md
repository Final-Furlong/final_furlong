# Final Furlong

[![CI](https://github.com/Final-Furlong/final_furlong/actions/workflows/main.yml/badge.svg)](https://github.com/Final-Furlong/final_furlong/actions/workflows/main.yml)

**Final Furlong** is a platform to run an online horse racing game.

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

## Contributing

- [Build details](BUILD_DETAIL.md)
- [Detailed contributing guide](CONTRIBUTING.md)

Once you’ve cloned the repo and set up the environment,
you can run the specs, or submit a pull request.
