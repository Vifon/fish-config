if status is-login
    switch (tty)
        case /dev/tty1
            exec startx -- vt1 > /dev/null
        case /dev/tty2
            exec env SESSION=emacs startx -- vt2 > /dev/null
    end
end

if not status is-interactive
    exit
end

# Initialize the pretty ls(1) colors if available.
if test -r ~/.dircolors
    dircolors -c ~/.dircolors | source
else
    dircolors -c | source
end

function history-fzf
    history | fzf --multi | fish --interactive
end

alias lh 'ls -lh'
alias annex 'git annex'
alias printl 'printf \'%s\n\''
alias zsh 'env NOFISH=1 zsh'
