function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)

    set -l fish_color_user green
    set -l fish_color_host yellow
    set -l fish_color_host_remote yellow --bold

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    set -l git_prompt yes
    for pattern in $fish_prompt_git_ignored_patterns
        if string match -q "$pattern" "$PWD"
            set git_prompt no
            break
        end
    end

    set -l vcs_status
    if test $git_prompt = yes
        set -g __fish_git_prompt_showcolorhints yes
        set -g __fish_git_prompt_showdirtystate yes
        set -g __fish_git_prompt_showstashstate yes
        set -g __fish_git_prompt_showuntrackedfiles yes
        set vcs_status (fish_vcs_prompt)
    end

    # Write pipestatus
    # If the status was carried over (e.g. after `set`), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color $bold_flag $fish_color_status) $last_pipestatus)

    echo -n -s (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal $vcs_status $normal " "$prompt_status $suffix " "
end
