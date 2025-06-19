My Submission Reminder App
my shell scripting assignment. checks which students havent submitted work.
what i made

create_environment.sh - sets up the app
copilot_shell_script.sh - changes assignment names

how to use
bashchmod +x create_environment.sh
./create_environment.sh
type your name (like "ariane", no spaces)
bashcd submission_reminder_yourname
./startup.sh
shows students who didnt submit
bashcd ..
./copilot_shell_script.sh
changes assignment name
example output
Assignment: Shell Navigation
Days remaining: 2 days
--------------------------------------------
Reminder: Teta has not submitted the Shell Navigation assignment!
Reminder: Uwimana has not submitted the Shell Navigation assignment!
if problems

permission denied: chmod +x *.sh
directory exists: delete it first
files missing: run create_environment.sh again
