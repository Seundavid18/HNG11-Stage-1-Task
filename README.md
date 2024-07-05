## Creating Users and Groups on Linux with a Bash Script

## Overview

This bash script automates the process of creating multiple users and groups on a Linux system. It's designed to streamline the onboarding process for new employees or system users. The script reads user information from an input file, creates users with their respective groups, sets random passwords, and logs all actions.

## Features

- Creates users and their personal groups
- Adds users to additional specified groups
- Generates random passwords for each user
- Logs all actions for auditing purposes
- Stores generated passwords securely
- Handles existing users and groups
- Provides detailed error checking and reporting

## Prerequisites

- Linux environment (tested on Ubuntu)
- Root or sudo access
- Bash shell

## Installation

1. Clone this repository or download the `create_users.sh` script.
2. Make the script executable:
   ```
   chmod +x create_users.sh
   ```

## Usage

1. Create an input file (e.g., `users.txt`) with the following format:
   ```
   username; group1,group2,group3
   ```
   Each line represents a user. The username and groups are separated by a semicolon (;). Multiple groups are separated by commas (,).

2. Run the script with root privileges:
   ```
   sudo ./create_users.sh users.txt
   ```
   Replace `users.txt` with the path to your input file.

## Input File sample

```
light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data
```

- Each line represents a user
- Username and groups are separated by a semicolon (;)
- Multiple groups are separated by commas (,)
- Whitespace around separators is ignored

## Output

- Users are created with their home directories
- Each user is assigned to their specified groups
- Random passwords are generated for each user
- All actions are logged in `/var/log/user_management.log`
- Passwords are stored in `/var/secure/user_passwords.csv`

## Troubleshooting

- Ensure you have root privileges when running the script
- Check the log file at `/var/log/user_management.log` for detailed information about each action and any errors
- Verify that the input file is formatted correctly

## Conclusion

By automating user and group management with a Bash script, you can efficiently handle multiple users, ensure security through proper permissions and password management, and maintain an audit log of all actions. This script provides a solid foundation for user management in a Linux environment.
