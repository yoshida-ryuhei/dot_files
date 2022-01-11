sensors -u coretemp-isa-0000 | grep temp | grep input | head -n 1 | awk '{print $2}' | xargs printf "%.1f°C"
