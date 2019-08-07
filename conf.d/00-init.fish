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
