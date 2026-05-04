#!/usr/bin/env bash
df -B1 --output=used,size "${1:-/}" | awk 'NR==2 {
  u[0]="B"; u[1]="KB"; u[2]="MB"; u[3]="GB"; u[4]="TB"; u[5]="PB"
  used=$1; tot=$2; i=0
  while (tot >= 1024 && i < 5) { used/=1024; tot/=1024; i++ }
  printf "%.1f%s / %.1f%s\n", used, u[i], tot, u[i]
}'
