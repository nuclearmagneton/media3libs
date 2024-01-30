#!/bin/bash
set -eux

echo $ANDROID_NDK_HOME
echo $NDK_PATH

chmod +x ${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-av1.sh

cd media
export MEDIA3_PATH="$(pwd)"


${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
${ROOT_DIR}/.github/scripts/build-av1.sh
cd ${MEDIA3_PATH}
./gradlew publishToMavenLocal


cd ${ROOT_DIR}
mkdir -p repo
mv ~/.m2/repository/* repo

name: Push builds
      run: |
         cd $GITHUB_WORKSPACE/builds
         git config --local user.email "actions@github.com"
         git config --local user.name "GitHub Actions"
         git add repo/**
         git commit --amend -m "Build $GITHUB_SHA" || exit 0   # do not error if nothing to commit.
         git push --force
