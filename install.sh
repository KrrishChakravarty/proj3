#!/bin/bash
dnf install -y stress-ng
nohup stress-ng --cpu 2 --timeout 1200s > /var/log/stress.log 2>&1 &
