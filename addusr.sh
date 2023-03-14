#!/bin/bash
userfile=$1 
#tr converts all capitals to small letters here
username=$(cat $userfile | tr 'A-Z'  'a-z')
password=$username@123

#running loop  to add users
for user in $username
do
       #adding users '$user' is a variable that changes
       #usernames accordingly in txt file.
       useradd $user
       echo $password | passwd --stdin $user
done

#wc -l counts number of lines
#tail is to print the lines of a file 
echo "$(wc -l /tmp/userlist) users have been created" 
tail -n$(wc -l /tmp userlist) /etc/passwd
