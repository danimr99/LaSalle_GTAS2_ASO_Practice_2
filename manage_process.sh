#!/bin/bash

# Get POST data
read post

# Get PID from POST
inputPID=$(echo ${post} | awk -F '=| ' '{print $2}')

# Store PID to a file
echo "${inputPID}" > "./data/process.txt"

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
echo "User ${username} listed all the details for the PID ${inputPID} [${now}]" >> /var/www/cgi-bin/data/log.txt


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
        <body class="text-center">
            <!-- Header -->
            <div class="row w-100 text-center">
                <h1 class="center">PID '${inputPID}'</h1>
            </div>
            <div class="container">
                <table class="table" style="margin: 5%;">
                    <thead>
                        <tr>
                            <th scope="col">User</th>
                            <th scope="col">Process Name</th>
                            <th scope="col">PID</th>
                            <th scope="col">%CPU</th>
                            <th scope="col">%MEM</th>
                            <th scope="col">VSZ</th>
                            <th scope="col">RSS</th>
                            <th scope="col">TTY</th>
                            <th scope="col">Stat</th>
                            <th scope="col">Start</th>
                            <th scope="col">Time</th>
                        </tr>
                    </thead>
                    <tbody>'

                    # Concatenate an entry for the corresponding input process to the table
                    ps aux | tail -n +2 | while read -r user pid cpu mem vsz rss tty stat start exec_time path_command ; do

                        if [ $inputPID == $pid ] ; then
                            echo '
                            <tr>
                                <th scope="row">'${user}'</th>
                                <td>'$(ps -p ${pid} -o comm=)'</td>
                                <td>'${pid}'</td>
                                <td>'${cpu}'</td>
                                <td>'${mem}'</td>
                                <td>'${vsz}'</td>
                                <td>'${rss}'</td>
                                <td>'${tty}'</td>
                                <td>'${stat}'</td>
                                <td>'${start}'</td>
                                <td>'${exec_time}'</td>
                            </tr>
                        '
                        fi 
                    done

                    echo '</tbody>
                </table>
            </div>'

            if [ "${isSudoer}" == true ]; then
                echo '
                    <div class="container center-text">
                        <form action="interrupt_process.sh" method="POST">
                            <div class="input-group mb-3">
                                <input id="secondsInterruption" name="secondsInterruption" type="number" class="form-control" 
                                    placeholder="Seconds to interrupt process" aria-label="Seconds to interrupt process" aria-describedby="button-interrupt">
                                <button class="btn btn-primary" type="submit" id="button-interrupt">Interrupt</button>
                            </div>
                        </form>
                        <form action="kill_process.sh" method="POST">
                            <button type="submit" class="btn btn-danger center-text">Kill process</button>
                        </form>
                    </div>
                '
            fi

            echo '<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" 
                integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" 
                integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" 
                integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        </body>
    </html>
'


