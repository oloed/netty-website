#!/bin/bash

BIN=`dirname "$0"`
SRC="$BIN/../_site"

if [[ $# -ne 1 ]]; then
  DST="$BIN/../../netty.github.com"
  if [[ ! -d "$DST/.git" ]]; then
    echo 'Specify the path to git@github.com:netty/netty.github.com.git'
    exit 1
  fi
else
  DST="$1"
fi

if [[ ! -d "$DST/.git" ]]; then
  echo "Not a Git repository: $DST"
  exit 1
fi

set -e
pushd "$DST"
if ! git remote -v | grep -qF 'git@github.com:netty/netty.github.com.git'; then
  echo "Not a netty.github.com repository: $DST"
  exit 1
fi

GIT_STATUS="$(git status 2> /dev/null)"
if [[ ! ${GIT_STATUS} =~ (working directory clean) ]]; then
  echo "Working directory not clean: $DST"
  exit 1
fi

popd

rm -fr "$SRC"

pushd "$BIN/.."
awestruct -g
popd

pushd "$DST"
git pull --ff-only
popd

"$BIN/inject-google-analytics.sh"
rsync -a "$SRC/" "$DST"

cd "$DST"
git add .
git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $(date)"
git push

