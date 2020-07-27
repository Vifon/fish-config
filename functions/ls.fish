function ls --description 'List contents of directory' --wraps=ls
    set -l param --color=auto --group-directories-first
    command ls $param $argv
end
