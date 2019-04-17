#!/bin/bash

RUN=$1

if [[ ! -f rebench.conf ]]; then
  echo "missing rebench.conf"
  exit 1
fi

if [[ -f $RUN ]]; then
  if [[ "$2" != "-f" ]]; then
    echo "$RUN already exists. use -f"
    exit 1
  fi
fi

time ~/.local/bin/rebench rebench.conf -c -df $RUN
