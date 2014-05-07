#!/usr/bin/sh

BUILD_DIR="/tmp/build.$$"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if ! grep -P '^refs/heads/source' > /dev/null; then
    exit 0
fi

cd "$(git rev-parse --show-toplevel)"
git checkout source
( cd website && serve export . "${BUILD_DIR}" )
git checkout master
rsync -a --exclude data.yaml --delete --filter "P .git" "${BUILD_DIR}"/ .
git add -A .
git commit -m "Updates website"
rm -rf "${BUILD_DIR}"
git push -f origin master:master
git checkout "${CURRENT_BRANCH}"
