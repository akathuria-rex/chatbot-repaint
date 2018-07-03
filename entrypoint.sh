#!/bin/sh
echo 'starting uwsgi'
uwsgi --http 0.0.0.0:80 --module "tutorial" --callable app --processes 4 --threads 2 --uid 999 --chown-socket appuser:appuser --master
