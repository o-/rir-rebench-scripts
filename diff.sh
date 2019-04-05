#!/bin/bash

RUN=$1
BMS=16

if [[ "$2" != "" ]]; then
  BASELINE=$2
else
  BASELINE="baseline.data"
fi

if [[ ! -f rebench.conf ]]; then
  echo "missing rebench.conf"
  exit 1
fi

if [[ ! -f $RUN ]]; then
  echo "Can't find $RUN"
  exit 1
fi
if [[ ! -f $BASELINE ]]; then
  echo "Can't find $RUN"
  exit 1
fi

~/.local/bin/rebench rebench.conf -df $BASELINE | head -n -1 | tail -n +11 | awk '{print $1", "$7}' | sort > /tmp/baseline.csv
~/.local/bin/rebench rebench.conf -df $RUN | head -n -1 | tail -n +11 | awk '{print $1", "$7}' | sort > /tmp/compare.csv

ruby diff.rb
