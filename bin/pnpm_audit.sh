#!/bin/bash

if command -v asdf >/dev/null 2>&1
then
  asdf set nodejs 25.1.0
fi
pnpm install --production=false

pnpm audit --ignore-unfixable
PNPM_EXIT=$?

if [ $PNPM_EXIT != 0 ]; then
  if [ -f pnpm-audit-known-issues ]; then
    set +e
    output=$(pnpm audit --json)
    set -e

    if echo "$output" | grep auditAdvisory | diff -q pnpm-audit-known-issues - > /dev/null 2>&1; then
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
  echo "pnpm audit --json | grep auditAdvisory > pnpm-audit-known-issues"
  echo
  echo "and commit the pnpm-audit-known-issues file"
fi

exit $PNPM_EXIT
