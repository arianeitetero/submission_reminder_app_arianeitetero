#!/bin/bash

#  the submission reminder app
# first i need to ask for the user's name

echo "Hello! Let's set up your submission reminder app."
echo "Please enter your name:"
read user_name

# checking if they actually typed something
if [ -z "$user_name" ]; then
    echo "Error: You must enter a name!"
    exit 1
fi

# check if the name has spaces thennnn this causes problems
if [[ "$user_name" =~ [[:space:]] ]]; then
    echo "Error: Name cannot contain spaces!"
    echo "Use something like 'ariane' or 'teta' instead of 'ariane itetero'"
    exit 1
fi

# checkig for weird characters that might break things
if [[ "$user_name" =~ [^a-zA-Z0-9_] ]]; then
    echo "Error: Name can only contain letters, numbers and underscore (_)"
    echo "Avoid special characters like @, #, $, %, etc."
    exit 1
fi

# check if directory already exists
if [ -d "submission_reminder_${user_name}" ]; then
    echo "Error: Directory submission_reminder_${user_name} already exists!"
    echo "Choose a different name or delete the existing directory."
    exit 1
fi

# now create the main directory with their name
echo "Creating your app directory... exciting!"
mkdir "submission_reminder_${user_name}"

# go into this new directory to create everything inside
cd "submission_reminder_${user_name}"

# create all the folders i need
echo "Making folders..."
mkdir app
mkdir modules
mkdir assets
mkdir config

# create the config.env file
echo "Creating config file..."
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# create the functions.sh file - this has the code to check submissions
echo "Creating functions file..."
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

# create the reminder.sh file - this runs the main app logic
echo "Creating reminder script..."
cat > app/reminder.sh << 'EOF'
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

# create submissions.txt with the original students plus more
echo "Creating student list..."
cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Teta, Shell Navigation, not submitted
Keza, Git, submitted
Ariane, Shell Navigation, submitted
Itetero, Shell Basics, not submitted
Uwimana, Shell Navigation, not submitted
Mugisha, Git, not submitted
Uwase, Shell Basics, submitted
Niyonzima, Shell Navigation, not submitted
EOF

# create my startup.sh file - this is the main entry point
echo "Creating startup script..."
cat > startup.sh << 'EOF'
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
EOF

# make all .sh files executable
echo "Making scripts executable... almost there!"
chmod +x app/reminder.sh
chmod +x modules/functions.sh
chmod +x startup.sh

# done!
echo "Hooray! We did it! Your app is ready to use!"
echo "To test it, run these commands:"
echo "cd submission_reminder_${user_name}"
echo "./startup.sh"
