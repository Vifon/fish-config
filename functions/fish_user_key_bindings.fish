function fish_user_key_bindings
    functions -q fzf_key_bindings; and fzf_key_bindings

    function prepend-space
        set cmd (commandline)
        if test -n "$cmd"
            commandline --replace " "(string trim $cmd)
        end
    end
    bind \e" " prepend-space

    function priv
        exec fish --private
    end

    function __ranger-cd
        set tempfile (mktemp -t ranger.XXXXXX)
        if set -q fish_private_mode
            # We're in the private mode, ranger should respect it too.
            ranger -c --choosedir=$tempfile (pwd)
        else
            ranger --choosedir=$tempfile (pwd)
        end
        if test -f $tempfile
            cd (cat -- $tempfile)
        end
        rm -f -- $tempfile
        commandline -f repaint
    end
    bind \er __ranger-cd

    function __most_recent_file
        set arg (commandline --current-token)

        set candidates (string unescape $arg | sed 's,^~/,'"$HOME/"',')*
        if test (count $candidates) = 0
            return
        end

        set sorted (command ls -td $candidates)
        commandline --replace --current-token \
        (string escape --no-quoted $sorted[1])
    end
    bind \cxm __most_recent_file

    function __change_history_file
        read -P (set_color green)"history"(set_color normal)"> " fish_history
        if test -z "$fish_history"
            set -e fish_history
        end
        commandline -f repaint
    end
    bind \cxh __change_history_file
    function __dirlocal_history
        if test -n "$fish_history"
            set -ge fish_history
            set -ge prompt_suffix
        else
            set -g fish_history (string escape --style=var $PWD)
            set -g prompt_suffix (set_color purple) '#' (set_color normal)
        end
        commandline -f repaint
    end
    bind \e\ch __dirlocal_history

    function __accept-and-hold
        set cmd (commandline)
        set cursor (commandline --cursor)

        if test -z "$cmd"
            commandline --replace "$last_commandline"
            return
        end

        commandline -f execute
        function __accept-and-hold-callback \
            --inherit-variable cmd          \
            --inherit-variable cursor       \
            --on-event fish_postexec

            functions --erase __accept-and-hold-callback
            commandline --replace $cmd
            commandline --cursor $cursor
        end
    end
    bind \ea __accept-and-hold

    function __subfish
        set dir (string unescape (commandline --current-token) | sed 's,^~/,'"$HOME/"',')
        if not test -d $dir
            return 1
        end

        echo ' ><>'             # Draw a fish just cause.
        pushd $dir
        fish
        popd
        commandline -f repaint
    end
    bind \cx\cf __subfish
end
