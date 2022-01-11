function latexmk
    set latexmk_path (which latexmk)
    if [ (count $argv) -eq 0 ]
        ls *.tex | xargs $latexmk_path
    else
        $latexmk_path $argv
    end
end
