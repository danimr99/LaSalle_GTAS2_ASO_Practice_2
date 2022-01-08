#!/bin/bash

# Get POST data
read post

# Get minute from POST 
inputMin=$(echo ${post} | awk -F '=|&' '{print $2}')

# Get hour from POST
inputHour=$(echo ${post} | awk -F '=|&' '{print $4}')

# Get day from POST
inputDay=$(echo ${post} | awk -F '=|&' '{print $6}')

# Get month from POST
inputMonth=$(echo ${post} | awk -F '=|&' '{print $8}')

# Get weekday from POST
inputWeekday=$(echo ${post} | awk -F '=|&' '{print $10}')

# Get command from POST
inputCommand=$(echo ${post} | awk -F '=' '{print $7}')

# Get username of the user logged in
username=$(cat /var/www/cgi-bin/data/username.txt)

# Check if some input is empty
if [ -z "$inputMin" ] ; then
    inputMin="0"
fi

if [ -z "$inputHour" ] ; then
    inputHour="0"
fi

if [ -z "$inputDay" ] ; then
    inputDay="0"
fi

if [ -z "$inputMonth" ] ; then
    inputMonth="0"
fi

if [ -z "$inputWeekday" ] ; then
    inputWeekday="0"
fi

# Format new task
command_string="${inputMin} ${inputHour} ${inputDay} ${inputMonth} ${inputWeekday} ${inputCommand}"

# Copy current tasks
sudo crontab -u ${username} -l > /var/www/cgi-bin/data/mycron.txt

# Echo new cron into cron file
echo ${command_string} >> /var/www/cgi-bin/data/mycron.txt

# Update all tasks and delete temp file
sudo crontab -u ${username} /var/www/cgi-bin/data/mycron.txt
sudo rm /var/www/cgi-bin/data/mycron.txt



echo Content-type: text/html
echo
echo '
    <!doctype html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta name="description" content="">
            <title>Web Admin</title>

            <!-- Bootstrap core CSS -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
                integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
            
            <!-- Custom styles for this template -->
            <link href="./css/power.css" rel="stylesheet">
        </head>
        <body class="text-center">
            <div class="row text-center">
                <div class="px-3 py-3 pt-md-5 pb-md-4 mx-auto text-center">
                    <h1 class="display-4">Task has been created succesfully!</h1>
                </div>
            </div>
            <button type="button" class="btn btn-primary center-text" onclick="logOut()">Exit</button>  

            <script>
                function logOut() {
                    location.replace("login.sh");
                }
            </script>
            
            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" 
                integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" 
                integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" 
                integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        </body>
    </html>
'