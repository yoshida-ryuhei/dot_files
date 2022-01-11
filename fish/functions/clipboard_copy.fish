function clipboard_copy
    if [ (count $argv) -eq 1 ]

        set filename $argv
        set os_name (uname)
        if [ $os_name = Darwin ]
            cat $filename | pbcopy
        else if [ $os_name = Linux ]
            cat $filename | xsel --clipboard --input
        end
        return 0

    else if [ (count $argv ) -ne 0 ]
        return 0
    end

    set os_name (uname)
    if [ $os_name = Darwin ]
        pbcopy
    else if [ $os_name = Linux ]
        xsel --clipboard --input
    end
end
