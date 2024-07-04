#!/bin/bash

# File: create_user.sh
# Description: This script creates users and groups based on input from a text file.
# Usage: sudo ./create_users.sh <input-file>

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Please provide an input file"
    echo "Usage: $0 <input-file>"
    exit 1
fi

INPUT_FILE="create_user.txt"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Create necessary directories
mkdir -p /var/secure

# Create log file if it doesn't exist
touch $LOG_FILE

# Create password file if it doesn't exist and set permissions
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

log() {
    echo "$(date): $1" >> $LOG_FILE
}

create_user() {
    local username=$1
    local groups=$2

    # Check if user already exists
    if id "$username" &>/dev/null; then
        log "User $username already exists. Skipping creation."
        return
    fi

    # Create group for user if it doesn't exist
    if ! getent group $username > /dev/null 2>&1; then
        groupadd $username
        log "Created group $username"
    fi

    # Create user with personal group
    useradd -m -g $username $username
    log "Created user $username with personal group $username"

    # Set random password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "$username,$password" >> $PASSWORD_FILE
    log "Set password for user $username"

    # Add user to additional groups
    if [ ! -z "$groups" ]; then
        IFS=',' read -ra GROUP_ARRAY <<< "$groups"
        for group in "${GROUP_ARRAY[@]}"; do
            # Create group if it doesn't exist
            if ! getent group $group > /dev/null 2>&1; then
                groupadd $group
                log "Created group $group"
            fi
            usermod -aG $group $username
            log "Added user $username to group $group"
        done
    fi
}

# Main execution
while IFS=';' read -r username groups || [ -n "$username" ]; do
    # Remove leading/trailing whitespace
    username=$(echo $username | xargs)
    groups=$(echo $groups | xargs)

    create_user "$username" "$groups"
done < "$INPUT_FILE"

echo "User creation process completed. Check $LOG_FILE for details."
