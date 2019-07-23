function __cwd_to_urxvt --on-variable PWD
    set -l update \033"]777;cwd-spawn;path;$PWD"\007

     switch $TERM
        case "rxvt-unicode*"
            echo -n $update
    end
end
__cwd_to_urxvt
