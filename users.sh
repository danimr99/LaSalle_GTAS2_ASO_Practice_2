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
echo "User ${username} has listed all users [${now}]" >> /var/www/cgi-bin/data/log.txt

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
                <h1 class="center">Users</h1>
            </div>
            '

            if [ "${isSudoer}" == true ]; then
                echo '
                    <!-- Create and delete user buttons -->
                    <div style="margin: 3%; width: 30%;">
                        <button type="submit" class="btn btn-primary" onclick="createUser()">Create User</button>
                        <button type="submit" class="btn btn-danger" onclick="deleteUser()">Delete User</button>
                    </div>
                '
            fi

            echo '<!-- Users table -->
            <div class="container">
                <table class="table" style="margin: 5%;">
                    <thead>
                        <tr>
                            <th scope="col">User</th>
                            <th scope="col">UID</th>
                            <th scope="col">GID</th>
                            <th scope="col">Directory</th>
                            <th scope="col">Shell</th>
                        </tr>
                    </thead>
                    <tbody>'

                    # Concatenate an entry for each process to the table
                    cat /etc/passwd | while read -r entry ; do
                        # Get all fields for each entry
                        IFS=':' read -ra info <<< "$entry"; declare -p info >> /dev/null

                        echo '
                            <tr>
                                <th scope="row">'${info[0]}'</th>
                                <td>'${info[2]}'</td>
                                <td>'${info[3]}'</td>
                                <td>'${info[5]}'</td>
                                <td>'${info[6]}'</td>
                            </tr>
                        '
                    done

                    echo '</tbody>
                </table>
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



