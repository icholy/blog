#!/bin/sh

git push origin `git subtree split --prefix build_folder master`:gh-pages --force
