function venv --description 'Activate a Python virtualenv' \
    --argument-names project_root

    set activate_path .venv/bin/activate.fish

    if test -z $project_root
        set project_root (pwd)
    end

    while not test -e $project_root/$activate_path \
        -o $project_root = /

        set project_root (dirname $project_root)
    end

    if test -e $project_root/$activate_path
        . $project_root/$activate_path
    else
        return 1
    end
end
