#!/usr/bin/env bash
set -e

if [ "$1" = "" ]
then
  echo "Usage: $0 <ssh-key-base64-encoded>"
  exit 1
fi

echo "$1" | base64 --decode > /root/.ssh/id_rsa
eval $(ssh-agent)
