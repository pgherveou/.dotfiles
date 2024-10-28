#!/usr/bin/env bash

echo "$1" | nc -N localhost 8378
