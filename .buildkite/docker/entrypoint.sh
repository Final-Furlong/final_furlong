#!/bin/bash

# Wait for DB to start
echo "--- Wait for DB to start"
wait-for-it db:5432 -t 60 -- "$@"
