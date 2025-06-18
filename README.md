Submission Reminder App
A shell script-based application that helps track student submission statuses and send reminders to students who haven't submitted their assignments.
Repository Information

Repository Name: submission_reminder_app_arianeitetero
Author: arianeitetero
Purpose: Educational assignment for mastering shell scripting and Git workflows

Features

Automated environment setup with proper directory structure
Student submission tracking
Dynamic assignment management
Automated reminder system
Easy-to-use copilot script for assignment updates

Project Structure
submission_reminder_{yourName}/
├── assets/
│   └── submissions.txt      # Student submission records
├── config/
│   └── config.env          # Application configuration
├── modules/
│   └── functions.sh        # Helper functions
├── scripts/
│   └── reminder.sh         # Main reminder logic
├── image.png               # Image placeholder
└── startup.sh              # Application launcher
Getting Started
Prerequisites

Bash shell (Linux/macOS/WSL on Windows)
Git (for version control)
Basic terminal/command line knowledge

Installation & Setup

Clone the repository
bashgit clone https://github.com/arianeitetero/submission_reminder_app_arianeitetero.git
cd submission_reminder_app_arianeitetero

Make scripts executable
bashchmod +x create_environment.sh
chmod +x copilot_shell_script.sh

Run the environment setup
bash./create_environment.sh

The script will prompt you for your name
It will create a directory named submission_reminder_{yourName}
All necessary files and directories will be created automatically
File permissions will be set correctly


Test the application
bashcd submission_reminder_{yourName}
./startup.sh
