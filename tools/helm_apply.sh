#!/bin/bash
set -euo pipefail

# `helm_apply.sh` installs or upgrades a release.
# Arguments:
#   $1: The project name
#   All the other arguments are expected to be valid `helm upgrade` arguments.
#   The main use case would be to add `--set key=value` arguments.

# Define variables.
: ${HELM_ENV:=minikube}
CONTEXT="${HELM_ENV}"
PROJECT_NAME=$1
shift

# Switch to the appropriate context.
if [ "${CONTEXT}" != minikube ]; then
  CONTEXT="${HELM_ENV}.k8s.rexchange.com"
fi
kubectl config use-context "${CONTEXT}"

# Execute the appropriate Helm command.
helm upgrade ${PROJECT_NAME} rex/rex-service \
  --install \
	-f charts/values.common.yaml \
	-f "charts/values.${HELM_ENV}.yaml" \
  $@
