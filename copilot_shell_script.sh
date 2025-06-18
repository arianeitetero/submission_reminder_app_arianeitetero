#!/bin/bash

# Function to display colored output
print_status() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

# Function to find the submission reminder directory
find_submission_dir() {
    # Look for directories matching the pattern submission_reminder_*
    local dirs=(submission_reminder_*)
    
    if [[ ${#dirs[@]} -eq 0 || ! -d "${dirs[0]}" ]]; then
        print_error "No submission reminder directory found!"
        print_error "Please run create_environment.sh first to set up the application."
        exit 1
    elif [[ ${#dirs[@]} -gt 1 ]]; then
        print_warning "Multiple submission reminder directories found:"
        for dir in "${dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                echo "  - $dir"
            fi
        done
        echo ""
        read -p "Please enter the directory name to use: " selected_dir
        if [[ ! -d "$selected_dir" ]]; then
            print_error "Directory '$selected_dir' does not exist."
            exit 1
        fi
        echo "$selected_dir"
    else
        echo "${dirs[0]}"
    fi
}

# Main script logic
echo "============================================="
echo "    Submission Reminder App - Copilot       "
echo "============================================="
echo ""

# Find the submission reminder directory
app_dir=$(find_submission_dir)
config_file="$app_dir/config/config.env"

print_status "Using directory: $app_dir"

# Check if config file exists
if [[ ! -f "$config_file" ]]; then
    print_error "Configuration file not found: $config_file"
    print_error "Please ensure the application is properly set up."
    exit 1
fi

# Display current assignment
current_assignment=$(grep "^ASSIGNMENT=" "$config_file" | cut -d'=' -f2 | tr -d '"')
print_status "Current assignment: $current_assignment"
echo ""

# Prompt for new assignment name
read -p "Enter the new assignment name: " new_assignment

# Validate input
if [[ -z "$new_assignment" ]]; then
    print_error "Assignment name cannot be empty. Exiting..."
    exit 1
fi

print_status "Updating assignment from '$current_assignment' to '$new_assignment'"

# Create backup of config file
backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$config_file" "$backup_file"
print_status "Backup created: $backup_file"

# Update the ASSIGNMENT value in config.env using sed
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

# Verify the change was made
if grep -q "^ASSIGNMENT=\"$new_assignment\"" "$config_file"; then
    print_status "Assignment successfully updated to: $new_assignment"
else
    print_error "Failed to update assignment. Restoring backup..."
    cp "$backup_file" "$config_file"
    exit 1
fi

echo ""
print_status "Configuration updated successfully!"
echo ""

# Ask if user wants to run the application now
read -p "Would you like to run the application now to check submissions? (y/n): " run_now

if [[ "$run_now" =~ ^[Yy]$ ]]; then
    print_status "Running startup.sh..."
    echo ""
    echo "==========================================="
    cd "$app_dir"
    ./startup.sh
    echo "==========================================="
else
    print_status "You can run the application later by executing:"
    echo "  cd $app_dir"
    echo "  ./startup.sh"
fi

echo ""
print_status "Copilot script completed successfully!"
