# Project configuration
PROJECT_NAME = sample

# General.
SHELL = /bin/bash
TOPDIR = $(shell git rev-parse --show-toplevel)

# Docker.
DOCKER_NETWORK=rex
DOCKER_ORG = rex
ECS_REGISTRY = 355508092300.dkr.ecr.us-west-2.amazonaws.com
REPOSITORY = $(DOCKER_ORG)/$(PROJECT_NAME)
IMG = $(PROJECT_NAME)
TAG ?= $(shell git describe)

# Helm Charts.
CHART_NAME = rex-services  # TODO: wat, not used anyhwere???
DEPLOY_EXTRA_OPTS = "--set image.tag=$(TAG)"

default: setup

help: # Display help
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST) | sort

ci-all: ci-docs  ci-linters ci-tests ## Run all the CI targets

ci-linters: ## Run the static analyzers
	@flake8 --exclude=insightly/api . && echo "all clean!"

ci-docs: ## Ensure the documentation builds
	@echo "Not implemented yet."

ci-tests: ## Run the unit tests
	CITEST=1 python -m unittest -v ${TEST}

clean: ## Remove unwanted files in this project (!DESTRUCTIVE!)
	@echo "GIT RESET --HARD - manually edit make file to enable this"
    # @cd $(TOPDIR) && git clean -ffdx && git reset --hard

clean-all: clean clean-docker clean-minikube ## Clean everything (!DESTRUCTIVE!)

clean-docker: ## Remove all docker artifacts for this project (!DESTRUCTIVE!)
	@docker image rm -f $(shell docker image ls --filter reference='$(REPOSITORY)' -q)

clean-minikube: ## Remove all the Kubernetes objects associated to this project
	kubectl config use-context minikube
	@helm delete --purge $(PROJECT_NAME)

clean-qa:
	kubectl config use-context qa
	@helm delete --purge $(PROJECT_NAME)

clean-stage:
	kubectl config use-context stage
	@helm delete --purge $(PROJECT_NAME)

conda: ## Setup the conda environment
	conda env update -f environment.yml

deploy-minikube: ## Deploy the application to minikube
	@HELM_ENV=minikube bash tools/helm_apply.sh $(PROJECT_NAME) $(DEPLOY_EXTRA_OPTS)

deploy-prod: ## Deploy the application to production
	@HELM_ENV=prod bash tools/helm_apply.sh $(PROJECT_NAME) $(DEPLOY_EXTRA_OPTS)
	kubectl config use-context minikube

deploy-qa: ## Deploy the application to QA
	@HELM_ENV=qa bash tools/helm_apply.sh $(PROJECT_NAME) $(DEPLOY_EXTRA_OPTS)
	kubectl config use-context minikube

deploy-stage: ## Deploy the application to stage
	@HELM_ENV=stage bash tools/helm_apply.sh $(PROJECT_NAME) $(DEPLOY_EXTRA_OPTS)
	kubectl config use-context minikube

dist: ## Package the application
	@echo "Not implemented yet."

build-docker: ## Build the docker image
	@docker build -t $(REPOSITORY):$(TAG) .
	@docker tag $(REPOSITORY):$(TAG) $(ECS_REGISTRY)/$(REPOSITORY):$(TAG)

push-docker: ## Push a Docker image to ECR
	@eval $(shell aws ecr get-login --no-include-email --region us-west-2)
	@docker push $(ECS_REGISTRY)/$(REPOSITORY):$(TAG)

dev-conda: conda
	source activate dinolol && pip install -r requirements.txt
	@echo "****************************************"
	@echo "*remember to activate your environment!*"
	@echo "****************************************"

feature-publish: ci-linters test ## Run linters and git flow publish the current feature
	git flow feature publish

insightly-dev:
	@echo $(REX_SVC_INSIGHTLY_API_KEY) > apikey.txt && echo "YOU ARE USING QA INSIGHTLY!"

insightly-prod:
	@echo $(REX_SVC_INSIGHTLY_PROD_API_KEY) > apikey.txt && echo "YOU ARE USING PROD INSIGHTLY!"

lint-fix: ## fixes linting issues
	yapf -i -r -vv -e insightly/api/ .

release-push: ## after finishing a release, pushes, develop, master, and tags
	git checkout develop && git push && git checkout master && git push && git push --tags && git checkout develop
	@echo "you are now on DEVELOP"

run-dev: ## runs flask dev server
	FLASK_APP=dinolol FLASK_ENV=development flask run

setup: docker-build ## Setup the full environment (default)

test:
	python -m unittest -v ${TEST}

.PHONY: help ci-all ci-linters ci-doc ci-tests clean clean-all clean-docker clean-minikube deploy-minikube deploy-prod deploy-qa deploy-stage dist docker-build docker-push setup
