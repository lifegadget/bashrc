#!/bin/bash

echo "Shutting down Locker"
echo "--------------------"
sudo docker rm api
echo "Building Locker"
echo "--------------------"
sudo docker build -t "lifegadget/docker-locker" ~/repos/mine/docker-locker
echo "Starting up Locker"
echo "--------------------"
sudo docker run --name api \
	-e PREP="['(composer.phar install)','(bower update)']" \
	-e PRIVATE_KEY="$(< ~/.ssh/id_rsa_nopass)" \
	-e PASSWORD="" \
	-e BRANCH="develop" \
	-e ENTRY_ALIAS="api" \
	"lifegadget/docker-locker" \
	load git@bitbucket.org:ksnyder/api.git
