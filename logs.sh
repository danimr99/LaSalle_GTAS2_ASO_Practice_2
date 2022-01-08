#!/bin/bash

# Get username of the user logged in
username=$(cat /var/www/cgi-bin/data/username.txt)

# Check if user is sudoer 
if getent group sudo | grep -q "\b${username}\b"; then 
    isSudoer=true
else 
    isSudoer=false
fi

# Log action to file
now=$(date)
echo "User ${username} has listed the most recent logs [${now}]" >> /var/www/cgi-bin/data/log.txt

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
            <link href="./css/style.css" rel="stylesheet">
        </head>
        <body>
            <!-- Header -->
            <div class="row w-100 text-center">
                <h1 class="center">Logs</h1>
            </div>

            <br><br>

            <div class="container">
                <ul class="list-group">
                '
                # Count lines of access log file
                linesCounter=`sudo cat /var/www/cgi-bin/data/log.txt | wc -l`

                # Read last 10 access logs to the server
                counter=20
                while [ $counter -gt 0 ] 
                do
                    index=$(($linesCounter - $counter))

                    line=`sudo cat /var/www/cgi-bin/data/log.txt | awk FNR==${index}`

                    echo '<li class="list-group-item">'${line}'</li>'

                    counter=$(($counter - 1))
                done
                
                echo '
                </ul>
            </div>

            <script>
                function createUser() {
                    location.replace("create_user.sh");
                }

                function deleteUser() {
                    location.replace("delete_user.sh");
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



