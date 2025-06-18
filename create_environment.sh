#!/bin/bash

# Function to display colored output
print_status() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# Prompt user for their name
echo "Welcome to the Submission Reminder App Setup!"
echo "=============================================="
read -p "Please enter your name: " user_name

# Validate input
if [[ -z "$user_name" ]]; then
    print_error "Name cannot be empty. Exiting..."
    exit 1
fi

# Create main directory
main_dir="submission_reminder_${user_name}"
print_status "Creating main directory: $main_dir"

if [[ -d "$main_dir" ]]; then
    print_error "Directory $main_dir already exists. Please remove it first or choose a different name."
    exit 1
fi

mkdir "$main_dir"
cd "$main_dir"

# Create subdirectories
print_status "Creating subdirectories..."
mkdir -p assets config modules scripts

# Create and populate config.env
print_status "Creating config/config.env..."
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create and populate functions.sh
print_status "Creating modules/functions.sh..."
cat > modules/functions.sh << 'EOF'
#!/bin/bash
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)
        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create and populate reminder.sh
print_status "Creating scripts/reminder.sh..."
cat > scripts/reminder.sh << 'EOF'
#!/bin/bash
# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"
check_submissions $submissions_file
EOF

# Create and populate submissions.txt with original data + 5 more students
print_status "Creating assets/submissions.txt..."
cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Michael, Shell Navigation, not submitted
Sarah, Git, submitted
James, Shell Navigation, submitted
Emily, Shell Basics, not submitted
David, Shell Navigation, not submitted
Lisa, Git, not submitted
Kevin, Shell Basics, submitted
Rachel, Shell Navigation, not submitted
EOF

# Create startup.sh script
print_status "Creating startup.sh..."
cat > startup.sh << 'EOF'
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
EOF

# Make all .sh files executable
print_status "Making all .sh files executable..."
find . -name "*.sh" -type f -exec chmod +x {} \;

# Create a simple image placeholder (since we can't create actual images)
print_status "Creating image placeholder..."
echo "This is a placeholder for image.png" > image.png

print_status "Environment setup completed successfully!"
print_status "Directory structure created: $main_dir"
print_status "All .sh files have been made executable."
echo ""
echo "To test the application, navigate to the directory and run:"
echo "  cd $main_dir"
echo "  ./startup.sh"
echo ""
echo "Directory structure:"
echo "$main_dir/"
echo "├── assets/"
echo "│   └── submissions.txt"
echo "├── config/"
echo "│   └── config.env"
echo "├── modules/"
echo "│   └── functions.sh"
echo "├── scripts/"
echo "│   └── reminder.sh"
echo "├── image.png"
echo "└── startup.sh"
