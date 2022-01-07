#!/bin/bash

# Get username of the user logged in
username=$(cat /var/www/cgi-bin/data/username.txt)

# Check if user is sudoer 
if getent group sudo | grep -q "\b${username}\b"; then 
    isSudoer=true
else 
    isSudoer=false
fi


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
                <h1 class="center">Processes</h1>
            </div>'

            if [ "${isSudoer}" == true ]; then
                echo '
                    <!-- PID search bar -->
                    <div class="row container" style="margin: 5%;">
                        <form action="manage_process.sh" method="POST">
                            <div class="input-group mb-3">
                                <input id="inputPID" name="inputPID" type="text" class="form-control" 
                                    placeholder="Process ID" aria-label="Process ID" aria-describedby="button-search">
                                <button class="btn btn-primary" type="submit" id="button-search">Search</button>
                            </div>
                        </form>
                    </div>
                '
            fi

            echo '<!-- Processes table -->
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

                    # Concatenate an entry for each process to the table
                    ps aux | tail -n +2 | while read -r user pid cpu mem vsz rss tty stat start exec_time path_command ; do
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
                    done

                    echo '</tbody>
                </table>
            </div>

            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" 
                integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" 
                integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" 
                integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        </body>
    </html>
'



