#!/bin/bash

# Get username of the user logged in
username=$(cat /var/www/cgi-bin/data/username.txt)

# Check if user is sudoer 
if getent group sudo | grep -q "\b${username}\b"; then 
    isSudoer=true
else 
    isSudoer=false
fi

# Get crontab output of the user logged in to check if there are tasks programmed by the user
crontab_output=$(sudo crontab -u ${username} -l 2>&1)

# Log list of tasks to file
now=$(date)
echo "User ${username} has listed all tasks [${now}]" >> /var/www/cgi-bin/data/log.txt

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
                <h1 class="center">Tasks</h1>
            </div>
            '

            if [ "${isSudoer}" == true ]; then
                echo '
                    <!-- Create and delete user buttons -->
                    <div style="margin: 3%; width: 30%;">
                        <button type="submit" class="btn btn-primary" onclick="createTask()">Create Task</button>
                        <button type="submit" class="btn btn-danger" onclick="deleteTask()">Delete All Tasks</button>
                    </div>
                '
            fi

            # Check if there are tasks programmed by the user 
            no_crontab_message="no crontab for ${username}"
            if [[ "$crontab_output" == "$no_crontab_message" ]] || [ -z "$crontab_output" ] ; then
                echo '
                    <div class="row w-100 text-center">
                        <h4 class="center">There are not tasks programmed by '${username}' yet.</h1>
                    </div>
                '
            else 
                 echo '
                <!-- Tasks table -->
                    <div class="container">
                        <table class="table" style="margin: 5%;">
                            <thead>
                                <tr>
                                    <th scope="col">Minute</th>
                                    <th scope="col">Hour</th>
                                    <th scope="col">Day</th>
                                    <th scope="col">Month</th>
                                    <th scope="col">Weekday</th>
                                    <th scope="col">Command</th>
                                </tr>
                            </thead>
                            <tbody>'

                            # Concatenate an entry for each programmed task
                            sudo crontab -u ${username} -l | while read -r min hour day month weekday exec_command ; do
                                echo '
                                    <tr>
                                        <td>'${min}'</td>
                                        <td>'${hour}'</td>
                                        <td>'${day}'</td>
                                        <td>'${month}'</td>
                                        <td>'${weekday}'</td>
                                        <td>'${exec_command}'</td>
                                    </tr>
                                '
                            done

                            echo '</tbody>
                        </table>
                    </div>'
            fi

            echo '
            <script>
                function createTask() {
                    location.replace("create_task.sh");
                }

                function deleteTask() {
                    location.replace("delete_tasks.sh");
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



