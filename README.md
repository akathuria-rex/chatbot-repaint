# Super simple Flask Micro-service

To get started, search confluence for onboarding documents. The associated guide for this repository is named: "Deploying a Flask App from Mac OSX 10.13.\*".

# Getting Started

Here are a few brief instructions, should the links above become outdated. Say you would like to rename your app. We will refer to the app's new name as `<app>`.

First. modify the Dockerfile `maintainer` and `description`. These have no implications elsewhere.

```
LABEL maintainer="John Doe <jdoe@rexchange.com>"
LABEL version="1.0"
LABEL description="<app>"
```

Rename the folder `sample` to `<app>`.

```
mv sample <app>
```

Modify `entrypoint.sh`'s `module` argument to reference your new folder.

```
uwsgi --http 0.0.0.0:80 --module "<app>" --callable app --processes 4 --threads 2 --uid 999 --chown-socket appuser:appuser --master
```

Rename the environment in `environments.yml`.

```
name: <app>
channels:
```

Change `PROJECT_NAME` in `Makefile`.

```
# Project configuration
PROJECT_NAME = <app>
```

Finally, rename all instances of `sample` in the `charts/` directory. These files determine the URL your app will be deployed at.

To deploy, build the docker container, upload it, and deploy to QA. See the tutorial above for more information.

```
make build-docker
make push-docker
make deploy-qa
```
