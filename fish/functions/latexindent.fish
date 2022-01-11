latexindent -r -m general.tex -o general.tex -g /dev/null >/dev/null

function latexindent
    set latexindent_path (which latexindent)
    if [ (count $argv) -eq 0 ]
        $latexindent_path --help
    else
        for arg in $argv
            $latexindent_path --replacement --modifylinebreaks --local $arg --outputfile=$arg --logfile=/dev/null >/dev/null
        end
    end
end
