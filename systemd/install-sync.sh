#!/bin/bash

# --- CONFIGURATION ---
REPOS=(
    "$HOME/Documents/wiki/delta"
    # Add more paths here
)

USER_UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$USER_UNIT_DIR"

install() {
    echo "Creating Service Template..."
    cat <<'EOF' > "$USER_UNIT_DIR/git-sync@.service"
[Unit]
Description=Auto-sync Git repo at %f
After=network.target

[Service]
Type=oneshot
# %f provides the unescaped path automatically in newer systemd versions
WorkingDirectory=%f
ExecStart=/usr/bin/bash -c 'git add . && (git diff-index --quiet HEAD || git commit -m "Auto-sync [%u] on %H") && git pull --rebase --autostash && git push'

[Install]
WantedBy=default.target
EOF

    echo "Creating Timer Template..."
    cat <<EOF > "$USER_UNIT_DIR/git-sync@.timer"
[Unit]
Description=Run Git sync for %f every 15 mins

[Timer]
OnCalendar=*:0/2
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload

    for REPO in "${REPOS[@]}"; do
        # Use -p to ensure it's treated as a path
        ESCAPED_PATH=$(systemd-escape -p "$REPO")
        echo "Enabling sync for $REPO..."
        systemctl --user enable --now "git-sync@$ESCAPED_PATH.timer"
    done
}

uninstall() {
    # Find all active git-sync units and disable them
    systemctl --user list-units --type=timer --all | grep 'git-sync@' | awk '{print $1}' | xargs -I {} systemctl --user disable --now {}
    rm -f "$USER_UNIT_DIR/git-sync@.service" "$USER_UNIT_DIR/git-sync@.timer"
    systemctl --user daemon-reload
    echo "Uninstalled."
}

case "$1" in
    install) install ;;
    uninstall) uninstall ;;
    *) echo "Usage: $0 {install|uninstall}" ;;
esac
