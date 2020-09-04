#!/bin/bash
set -euo pipefail

# `helm_apply.sh` installs or upgrades a release.
# Arguments:
#   $1: The project name
#   All the other arguments are expected to be valid `helm upgrade` arguments.
#   The main use case would be to add `--set key=value` arguments.

PROJECT_NAME=$1
shift
: ${HELM_ENV:=local}
: ${CONTEXT:=$HELM_ENV}
NAMESPACE="default"
RELEASE_NAME="${HELM_ENV}-${PROJECT_NAME}"


if [ "${HELM_ENV}" != local ]; then
  if [[ "${HELM_ENV}" == qa[0-9]* ]]; then
    NAMESPACE="${HELM_ENV}"
    CONTEXT="qa.k8s.rexchange.com"
  else
    CONTEXT="${HELM_ENV}.k8s.rexchange.com"
  fi
else
  CONTEXT="docker-for-desktop"
fi

kubectl config use-context "${CONTEXT}"

# Execute the appropriate Helm command.
helm upgrade \
  ${RELEASE_NAME} rex/rex-service \
  --install \
        -f charts/values.common.yaml \
        -f "charts/values.${HELM_ENV}.yaml" \
  --namespace "${NAMESPACE}" \
  $@


