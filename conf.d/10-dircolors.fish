# Initialize the pretty ls(1) colors if available.
if test -r ~/.dircolors
    dircolors -c ~/.dircolors | source
else
    dircolors -c | source
end
