#!/bin/bash

#Step 1: Prompt for username and full name
read -p "Enter new employee's user name: " username
read -p "Enter full name: " fullname

#Step 2: Check if the user already exists
if id "$username" &>/dev/null; then
   echo "Error: User '$username' already exists."
   exit 1
fi

#Step 3: Create the user account 
# Generate the temporary password
temp_pass=$(openssl rand -base64 12)

#Create user with a home directory and full name as comment
sudo useradd -m -c "$fullname" "$username"

#Set a temporary password
echo "$username:$temp_pass" | sudo chpasswd

#Force password change on first login
sudo change -d 0 "$username"

#Step 4: Print success message 
echo "user '$username' has been created successfully."
echo "temporary password: $temp_pass"

#Step 5: Log the onboarding event
echo "$username - $(date)" >> onboarding.log

git add onboard_employee.sh
git commit -m "feat: Create initial employee onboarding scripts"
git push -u origin feature/onboarding-scripts

