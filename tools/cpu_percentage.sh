#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_freebsd() {
	[ $(uname) == "FreeBSD" ]
}

is_openbsd() {
	[ $(uname) == "OpenBSD" ]
}

is_linux() {
	[ $(uname) == "Linux" ]
}

is_cygwin() {
	command -v WMIC &> /dev/null
}

is_linux_iostat() {
	# Bug in early versions of linux iostat -V return error code
	iostat -c &> /dev/null
}

# is second float bigger?
fcomp() {
	awk -v n1=$1 -v n2=$2 'BEGIN {if (n1<n2) exit 0; exit 1}'
}

cpu_load_status() {
	local percentage=$1
	if fcomp 80 $percentage; then
		echo "high"
	elif fcomp 30 $percentage && fcomp $percentage 80; then 
		echo "medium"
	else
		echo "low"
	fi
}

cpus_number() {
	if is_linux; then
		nproc
	else
		sysctl -n hw.ncpu
	fi
}

command_exists() {
	local command="$1"
	command -v "$command" &> /dev/null
}


print_cpu_percentage() {
	if command_exists "iostat"; then

		if is_linux_iostat; then
			iostat -c 1 2 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%3.1f%%", usage)}' | sed 's/,/./'
		elif is_osx; then
			iostat -c 2 disk0 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$6} END {printf("%3.1f%%", usage)}' | sed 's/,/./'
		elif is_freebsd || is_openbsd; then
			iostat -c 2 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%3.1f%%", usage)}' | sed 's/,/./'
		else
			echo "Unknown iostat version please create an issue"
		fi
	elif command_exists "sar"; then
		sar -u 1 1 | sed '/^\s*$/d' | tail -n 1 | awk '{usage=100-$NF} END {printf("%3.1f%%", usage)}' | sed 's/,/./'
	else
		if is_cygwin; then
			usage="$(WMIC cpu get LoadPercentage | grep -Eo '^[0-9]+')"
			printf "%3.1f%%" $usage
		else
			load=`ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'`
			cpus=$(cpus_number)
			echo "$load $cpus" | awk '{printf "%3.1f%%", $1/$2}'
		fi
	fi
}

main() {
	print_cpu_percentage
}
main
