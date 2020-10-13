#!/bin/bash

export $(grep -v '^#' .env | xargs)

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
npm install
sync

# # Build application
# npm run $BUILD_SCRIPT
# sync


# Cleanup
find . -not \( -path './node_modules/*' -or -path './node_modules' -or -name 'package-lock.json' \) -print0 | xargs -0 -I {} rm -rf {}