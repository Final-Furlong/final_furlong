# README

[![CI](https://github.com/Final-Furlong/final_furlong/actions/workflows/test.yml/badge.svg)](https://github.com/Final-Furlong/final_furlong/actions/workflows/test.yml) | [![Maintainability](https://api.codeclimate.com/v1/badges/83d464b7f230d7c654c6/maintainability)](https://codeclimate.com/repos/6277f8245c68b90ca1004642/maintainability) | [![Test Coverage](https://api.codeclimate.com/v1/badges/83d464b7f230d7c654c6/test_coverage)](https://codeclimate.com/repos/6277f8245c68b90ca1004642/test_coverage)

Requirements:
* Ruby
* Postgres
* Node

Setup:
```shell
cp config/database.yml.sample config/database.yml # update settings accordingly
bin/rails bundle
bin/rails db:setup

bin/dev # run dev environment
bin/rspec # run tests
```
