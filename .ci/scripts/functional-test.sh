#!/usr/bin/env bash
set -euxo pipefail

# shellcheck disable=SC1091
source .ci/scripts/install-go.sh

rm -rf outputs || true
mkdir -p outputs
REPORT=outputs/junit-functional-tests

## Parse FEATURE if ALL
if [ -n "${FEATURE}" ] ; then
  if [ "${FEATURE}" == "all" ] ; then
    FEATURE='*'
  fi
else
  FEATURE='*'
fi

## Generate test report even if make failed.
set +e
exit_status=0
if ! REPORT=${REPORT} FEATURE=${FEATURE} make functional-test-ci ; then
  echo 'ERROR: functional-test-ci failed'
  exit_status=1
fi

sed -e 's/^[ \t]*//' ${REPORT} | grep -E '^<.*>$' > ${REPORT}.xml
exit $exit_status