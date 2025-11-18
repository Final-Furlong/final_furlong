# Final Furlong

[![Build Status](https://finalfurlong.semaphoreci.com/badges/final_furlong/branches/main.svg?style=shields&key=3039b3ed-f657-4f3a-aca4-aa2ba22a1d7d)](https://finalfurlong.semaphoreci.com/projects/final_furlong)
[![Maintainability](https://qlty.sh/badges/5d217b6a-2125-461f-98c2-9b6c82cae534/maintainability.svg)](https://qlty.sh/gh/Final-Furlong/projects/final_furlong)
[![Code Coverage](https://qlty.sh/badges/5d217b6a-2125-461f-98c2-9b6c82cae534/coverage.svg)](https://qlty.sh/gh/Final-Furlong/projects/final_furlong)

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
