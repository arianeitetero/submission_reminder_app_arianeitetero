#!/bin/bash

# my copilot script to change assignment names
echo "Assignment Changer for Submission Reminder App"
echo "=============================================="

# i need to find the submission reminder directory first
# ill look for any folder that starts with "submission_reminder_"
app_directory=""

for folder in submission_reminder_*; do
    if [ -d "$folder" ]; then
        app_directory="$folder"
        break
    fi
done

# check if i found a directory
if [ -z "$app_directory" ]; then
    echo "I can't find your submission reminder app!"
    echo "Run create_environment.sh first."
    exit 1
fi

echo "Found your app in: $app_directory"

# now i need to find the config file
config_file="$app_directory/config/config.env"

# check if the config file exists
if [ ! -f "$config_file" ]; then
    echo "I can't find the config file!"
    echo "Something might be wrong with your app setup."
    exit 1
fi

# show the current assignment
echo "Let me check what assignment is currently set..."
current_assignment=$(grep "ASSIGNMENT=" "$config_file" | cut -d'=' -f2 | tr -d '"')
echo "Current assignment: $current_assignment"

# ask user for new assignment name
echo ""
echo "What assignment do you want to check for?"
read -p "Enter new assignment name: " new_assignment

# make sure they typed something
if [ -z "$new_assignment" ]; then
    echo "You didnt enter anything! Try again."
    exit 1
fi

echo "Changing assignment to: $new_assignment"

# use sed to replace the assignment in the config file
sed -i "s/ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

echo "Assignment updated succesfully!"

# ask if they want to run the app now
echo ""
echo "Do you want to check submissions for this new assignment?"
read -p "Type 'y' for yes or 'n' for no: " answer

if [ "$answer" = "y" ]; then
    echo "Running the app... here we go!"
    cd "$app_directory"
    ./startup.sh
else
    echo "You can run the app later by going to $app_directory and running ./startup.sh"
fi

echo "Hooray! Copilot mission completed!"
