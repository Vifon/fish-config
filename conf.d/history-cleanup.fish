function __preexec_history_line_trim --on-event fish_preexec
    set trimmed (string trim $argv[1])
    if test -n "$trimmed"
        set -g last_commandline $argv[1]
    end
end
