#!/bin/bash
find ./ -iname *.Identifier | xargs rm
rm -r ./dist/*
rm -r ./build/output/*
