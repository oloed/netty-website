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

# Make sure netty-website is clean
pushd "$SRC/.."
GIT_STATUS="$(git status 2> /dev/null)"
if [[ ! ${GIT_STATUS} =~ (working directory clean) ]]; then
  echo "Working directory not clean: $PWD"
  exit 1
fi
popd

# Make sure netty.github.com is clean
pushd "$DST"

if ! git remote -v | grep -qF 'git@github.com:netty/netty.github.com.git'; then
  echo "Not a netty.github.com repository: $PWD"
  exit 1
fi

GIT_STATUS="$(git status 2> /dev/null)"
if [[ ! ${GIT_STATUS} =~ (working directory clean) ]]; then
  echo "Working directory not clean: $DST"
  exit 1
fi

popd

# Generate the web site
rm -fr "$SRC"
pushd "$BIN/.."
awestruct -g
popd

# Pull the latest changes in netty.github.com
pushd "$DST"
git pull --ff-only
popd

# Inject Google Analytics JavaScript in all generated HTMLs
"$BIN/inject-google-analytics.sh"

# Copy the generated web site to netty.github.com
rsync -a "$SRC/" "$DST"

# Publish the generated web site
cd "$DST"
git add .
git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $(date)"
git push

