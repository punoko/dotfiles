# name of this file should probably start with 0
# to run before other configs
if status is-interactive && command --query /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv fish)"
    fish_add_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    fish_add_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
    fish_add_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
    fish_add_path "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
end
