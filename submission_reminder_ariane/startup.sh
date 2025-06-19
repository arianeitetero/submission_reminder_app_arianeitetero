#!/bin/bash

# my startup script for the submission reminder app
echo "Starting Submission Reminder App..."

# check if all the files exist before running
if [ ! -f "config/config.env" ]; then
    echo "Error: Config file missing!"
    exit 1
fi

if [ ! -f "modules/functions.sh" ]; then
    echo "Error: Functions file missing!"
    exit 1
fi

if [ ! -f "app/reminder.sh" ]; then
    echo "Error: Reminder script missing!"
    exit 1
fi

if [ ! -f "assets/submissions.txt" ]; then
    echo "Error: Student data file missing!"
    exit 1
fi

# everything looks good, let's run the reminder
bash ./app/reminder.sh

echo "App finished running!"
