#!/bin/bash

get_info() {
    case $(uname -s) in
        "Darwin")
            airport_path="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

            #Check if airport is available
            if [[ ! -x $airport_path ]]; then
                echo "$airport_path: not found" 1>&2
                exit 1
            fi

            # Get the wifi information and then set it to an info array
            info=( $(eval "$airport_path" --getinfo | grep -E "^ *(agrCtlRSSI|state|lastTxRate|SSID):" | awk '{print $2}') )
            if [[ ${#info[@]} -eq 0 ]]; then
                echo "offline"
                exit 1
            fi

                    # cut out a needed information from the info
                    # reference: http://osxdaily.com/2007/01/18/airport-the-little-known-command-line-wireless-utility/
            rssi="${info[0]}"   # strength of wifi wave
            stat="${info[1]}"   # whether wifi is available
            rate="${info[2]}"   # bandwidth of wifi wave
            ssid="${info[3]}"   # wifi ssid name
            signal=$((100+${rssi}))
            ;;
        "Linux")
            ssid=$(nmcli -f DEVICE,CONNECTION device   | sed -E "s/\s+/\ /g" | grep wlp | cut -d \  -f 2-)
            signal=$(nmcli -f SSID,SIGNAL dev wifi | grep ${ssid} | head -n 1 | awk '{print $2}' )
            echo $signal
            ;;
        :)
            echo "invalid os"
            exit 1
            ;;
    esac
}

# Apply the correct color to the battery status prompt
apply_colors() {
    # Green
    if [[ $rssi -ge -50 ]]; then
        if ((output_tmux)); then
            COLOR="#[fg=$good_color]"
        elif ((output_zsh)); then
            COLOR="%F{$good_color}"
        elif ((output_fish)); then
            COLOR=$good_color
        else
            COLOR=$good_color
        fi

    # Yellow
    elif [[ $rssi -ge -80 ]]; then
        if ((output_tmux)); then
            COLOR="#[fg=$middle_color]"
        elif ((output_zsh)); then
            COLOR="%F{$middle_color}"
        elif ((output_fish)); then
            COLOR=$middle_color
        else
            COLOR=$middle_color
        fi

    # Red
    elif [[ $rssi -lt -80 ]]; then
        if ((output_tmux)); then
            COLOR="#[fg=$warn_color]"
        elif ((output_zsh)); then
            COLOR="%F{$warn_color}"
        elif ((output_fish)); then
            COLOR=$warn_color
        else
            COLOR=$warn_color
        fi
    fi
}

print_status() {
    # Determine the signal from rssi of wifi
        # reference of strength (rssi)
        #  -20　Excellent
        #  -30　Excellent
        #  -40　Excellent
        #  -50　Excellent
        #  -60　better
        #  -70　good
        #  -80　not good
        #  -90　bad
        # -100　bad

        # Creates the bar▁▂▃▄▅▆▇█
		#▂▄▆_ ▂▅█
		# ▂▄▆█
        #▂▅█
        # ▂ ▅ █
        signal_deci=$(expr $signal / 10)
        # rssi(-m*10-n) -> m
        case $signal_deci in
            6|7|8|9|10)
                GRAPH="▂▄▆█" #強い
                ;;
            4|5)
                GRAPH="▂▄▆_" #ビミョい
                ;;
            2|3)
                GRAPH="▂▄__" #弱い
                ;;
            0|1)
                GRAPH="▂___" #
                ;;
            :)
                GRAPH="____" #例外
                ;;
        esac

    if ((output_tmux)); then
        printf "%s%s %s%s" "$COLOR" "$GRAPH" "#[default]"
    elif ((output_zsh)); then
        printf "%%B%s%s %s" "$COLOR" "$GRAPH"
    else
        printf "\e[0;%sm%s %s \e[m\n"  "$COLOR" "$GRAPH"
    fi
}

# Read args
while getopts ":g:m:w:tzeab:p" opt; do
    case $opt in
        t)
            output_tmux=1
            good_color="green"
            middle_color="yellow"
            warn_color="red"
            ;;
        z)
            output_zsh=1
            good_color="64"
            middle_color="136"
            warn_color="160"
            ;;
        f)
            output_fish-1
            #good_color
            ;;
        :)
            echo "Option -$OPTARG requires an argument"
            exit 1
            ;;
    esac
done

# If the wifi rate (wifi bandwidth) is unavailable,
if [ "$rate" = 0 ]; then
    echo "no_wifi"
    exit 1
fi

# Outputs wifi
#   example: "fun-wifi 351Mbs ▂ ▅   "
get_info
if [ $(echo "$ssid" | grep -e 'aterm-904394-') ]; then
	wifi_name="my home "
else
	wifi_name="${ssid}"
fi
echo -ne "${wifi_name}"
apply_colors
print_status
