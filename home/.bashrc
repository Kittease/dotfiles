# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Homebrew — detect install path per OS/architecture
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv bash)"               # macOS (Apple Silicon)
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv bash)"                  # macOS (Intel)
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"  # Linux
fi

# Machine-specific overrides (not tracked in git)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
