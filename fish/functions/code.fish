function code
    set os_name (uname)

    if [ $os_name = Darwin ]
        set code_path /Applications/Visual\ Studio\ Code.app/
        open -a $code_path $argv

    else if [ $os_name = Linux ]
        set code (which code)
        $code $argv
    end #end of judgemanet of os
end
