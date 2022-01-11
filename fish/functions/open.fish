function open
    set os_name (uname)
    if [ $os_name = Darwin ]
        # mac OS
        set open_path (which open)
    else if [ $os_name = Linux ]
        # Linux
        set open_path (which xdg-open)
    end #end of judgemanet of os
    $open_path $argv
end
