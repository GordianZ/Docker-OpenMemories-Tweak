#!/bin/sh
git config --global --add safe.directory /Code
gradle build --stacktrace
