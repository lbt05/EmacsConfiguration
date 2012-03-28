#!/bin/sh

set -e

git pull
git submodule sync
git submodule init
git submodule update
