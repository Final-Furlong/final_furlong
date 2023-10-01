#!/bin/bash

YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

echo "${YELLOW}[ scripts/security ] Running bundler audit${NOCOLOR}"

bin/bundler-audit check --update

echo "${NOCOLOR}---------------------------------------------------------------------------------------------${NOCOLOR}"

echo "${YELLOW}[ scripts/security ] Running brakeman"
echo "[ scripts/security ] Analyzing code for security vulnerabilities."
echo "[ scripts/security ] Output will be in tmp/brakeman.html, which"
echo "[ scripts/security ] can be opened in your browser.${NOCOLOR}"
bundle exec brakeman -q -o tmp/brakeman.html

echo "${NOCOLOR}---------------------------------------------------------------------------------------------${NOCOLOR}"

echo "${YELLOW}[ scripts/security ] Running yarn audit${NOCOLOR}"
sh .github/scripts/yarn_audit.sh
