function __fish_vcgencmd_need_command
    set cmd (commandline -opc )
    if [ ( count $cmd ) -eq 1 ]
        return 0
    else
        return 1
    end
end

# https://ss64.com/osx/vcgencmd.html

complete -f -c vcgencmd -n __fish_vcgencmd_need_command -a measure_clock -d 'Shows clock frequency, clock can be one of arm, core, h264, isp, v3d, uart, pwm, emmc, pixel, vec, hdmi, dpi'
complete -f -c vcgencmd -n __fish_vcgencmd_need_command -a measure_volts -d 'Shows voltage, id can be one core, sdram_c, sdram_i, sdram_p, and defaults to core if not specified.'
complete -f -c vcgencmd -n __fish_vcgencmd_need_command -a measure_temp -d 'Shows core temperature of BCM2835 SoC.'
complete -f -c vcgencmd -n __fish_vcgencmd_need_command -a version -d 'print current build version of VideoCore firmware':
