#############
# SSH agent #
#############

SSH_AGENT_ENV="$HOME/.ssh-agent.env"

function _start_agent {
    eval "$(ssh-agent -s)" > /dev/null
    echo "SSH_AGENT_PID=$SSH_AGENT_PID" > "$SSH_AGENT_ENV"
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> "$SSH_AGENT_ENV"
    chmod 600 "$SSH_AGENT_ENV"
}

function _is_system_rebooted {
    if [ ! -f "$SSH_AGENT_ENV" ]; then
        return 0  # true: file does not exist, treat as rebooted
    fi

    # The modification time of the file in seconds since the epoch
    local file_modification_time=$(stat -c %Y "$SSH_AGENT_ENV")

    # The system uptime in seconds
    local system_uptime=$(awk '{print int($1)}' /proc/uptime)

    # The current time in seconds since the epoch
    local current_time=$(date +%s)

    # Infer the system boot time in seconds since the epoch
    local system_boot_time=$((current_time - system_uptime))

    if (( system_boot_time > file_modification_time )); then
        # If the system boot time is after the file modification time, the
        # system was rebooted.
        return 0  # true: system rebooted
    else
        return 1  # false: system not rebooted
    fi
}


# Source the environment variables if the file exists
if [ -f "$SSH_AGENT_ENV" ]; then
    . "$SSH_AGENT_ENV" > /dev/null
    # Ensure that the expected environment variables (and only those) are
    # available to child processes.
    export SSH_AGENT_PID
    export SSH_AUTH_SOCK

    if _is_system_rebooted || [ ! -f "$SSH_AUTH_SOCK" ] || ! ps -p "$SSH_AGENT_PID" --no-headers -o comm= | grep -q "^ssh-agent$"; then
        # In some sense, we have shown that the agent file is invalid.
        _start_agent
    fi
else
    # The agent.env file does not exist, so start the agent.
    _start_agent
fi


# Add SSH identity
ssh-add -q


