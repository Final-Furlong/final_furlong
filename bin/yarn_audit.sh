#!/bin/bash

SCRIPT_DIR=$(pwd)

cd ../

if command -v asdf >/dev/null 2>&1
then
  asdf set nodejs 25.1.0
fi
yarn install --production=false

yarn audit
YARN_EXIT=$?

if [ $YARN_EXIT != 0 ]; then
  if [ -f yarn-audit-known-issues ]; then
    set +e
    output=$(yarn audit --json)
    set -e

    if echo "$output" | grep auditAdvisory | diff -q yarn-audit-known-issues - > /dev/null 2>&1; then
      echo
      echo Ignorning known vulnerabilities
      exit 0
    fi
  fi

  echo
  echo "Security vulnerabilities were found that were not ignored"
  echo
  echo "Check to see if these vulnerabilities apply to production"
  echo "and/or if they have fixes available. If they do not have"
  echo "fixes and they do not apply to production, you may ignore them"
  echo
  echo "To ignore these vulnerabilities, run:"
  echo
  echo "yarn audit --json | grep auditAdvisory > yarn-audit-known-issues"
  echo
  echo "and commit the yarn-audit-known-issues file"
fi

cd "$SCRIPT_DIR"

exit $YARN_EXIT
