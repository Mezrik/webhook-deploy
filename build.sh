#!/bin/bash

export $(grep -v '^#' .env | xargs)

function cleanup() {
  find . -not \( -path './node_modules/*' -or -path './node_modules' -or -name 'package-lock.json' \) -print0 | xargs -0 -I {} rm -rf {} 
}

# Pull new changes in repository
pushd $REPOSITORY_LOCATION 
git checkout master && git pull --ff-only $REMOTE_ORIGIN master
sync
popd

# Copy repository and install dependencies
mkdir -p repository
rsync --ignore-existing -raz --exclude 'node_modules' --exclude '.git' --exclude 'package-lock.json' $REPOSITORY_LOCATION ./repository
sync
pushd ./repository
npm install --unsafe-perm
sync

# Build application
npm run $BUILD_SCRIPT || (cleanup && exit 1)
sync

rsync -raz ./build "../$REPOSITORY_LOCATION"

cleanup