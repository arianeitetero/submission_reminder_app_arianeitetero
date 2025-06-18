#!/bin/bash

# Startup script for Submission Reminder App
echo "=========================================="
echo "    Submission Reminder App Starting     "
echo "=========================================="
echo ""

# Check if all required files exist
required_files=("config/config.env" "modules/functions.sh" "scripts/reminder.sh" "assets/submissions.txt")
missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo "ERROR: Missing required files:"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
    echo "Please ensure all files are in place before running the application."
    exit 1
fi

# Source configuration
source ./config/config.env

echo "Configuration loaded:"
echo "  Assignment: $ASSIGNMENT"
echo "  Days remaining: $DAYS_REMAINING"
echo ""

# Run the reminder script
echo "Running submission reminder check..."
echo ""
bash ./scripts/reminder.sh

echo ""
echo "Submission reminder check completed!"
echo "=========================================="
