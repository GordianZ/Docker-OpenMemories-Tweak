#!/bin/sh
if [ -z "$REPO_URL" ]
then
	echo "env var REPO_URL not set, stopping container"
else
	git clone --recursive $REPO_URL .
	gradle build --stacktrace
fi
