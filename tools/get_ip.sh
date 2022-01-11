#!/bin/bash

nmcli | grep -i inet4 | awk '{print $2}' | awk -F / '{print $1}'
