#!/bin/bash

# Get POST data
read post

# Get username from POST 
username=$(echo ${post} | awk -F '=|&' '{print $2}')

# Get password from POST
password=$(echo ${post} | awk -F '=| ' '{print $3}')

# Check if exists the username introduced by the user
if id "${username}" &>/dev/null; then
    existsUser=true

    # Check if password introduced by the user is valid
    # Get encrypted password from /etc/shadow file
    shadowPassword=$(echo "$(sudo cat /etc/shadow | grep ${username} | awk -F ':|:' '{print $2}')")

    # Get encryption method and key used on /etc/shadow 
    IFS='$' read -ra shadow <<< "$shadowPassword"; declare -p shadow >> /dev/null

    # Encrypt password introduced by the user to check if matches
    encryptedPassword=$(echo $(mkpasswd -m SHA-512 ${password} ${shadow[2]}))

    # Check if passwords are the same 
    if [ "${shadowPassword}" == "${encryptedPassword}" ]; then
        passwordOk=true

        # Store username to a file
        echo "${username}" > "./data/username.txt"
    else
        passwordOk=false
    fi

else
    existsUser=false
    passwordOk=false
fi

# Check if user is sudoer 
if getent group sudo | grep -q "\b${username}\b"; then 
    isSudoer=true
else 
    isSudoer=false
fi

# Check if login has been successful
if [ "${existsUser}" == true ] && [ "${passwordOk}" == true ]; then
    html='
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

                <!-- Bootstrap icons -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css"/>

                <!-- Custom styles for this template -->
                <link href="./css/style.css" rel="stylesheet">
            </head>
            <body>
                <div class="row text-center">
                    <div class="px-3 py-3 pt-md-5 pb-md-4 mx-auto text-center">
                        <h1 class="display-4">Welcome back, <span class="username-text">'$username'</span></h1>
                        <p class="lead">Select an option to start managing your system</p>
                    </div>
                </div>

                <div class="container">
                    <div class="card-deck mb-3 text-center">
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Processes</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/process.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary" onclick="processes()">Select</button>
                            </div>
                        </div>
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Monitoring</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/monitor.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary" onclick="monitoring()">Select</button>
                            </div>
                        </div>
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Logs</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/log-file.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary">Select</button>
                            </div>
                        </div>
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Users</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/users.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary" onclick="users()">Select</button>
                            </div>
                        </div>
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Network</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/network.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary">Select</button>
                            </div>
                        </div>
                        <div class="card mb-4 box-shadow">
                            <div class="card-header">
                                <h4 class="my-0 font-weight-normal">Tasks</h4>
                            </div>
                            <div class="card-body">
                                <img class="mb-4" src="./images/tasks.png" alt="" width="75" height="75">
                                <button type="button" class="btn btn-lg btn-block btn-outline-primary">Select</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container center-text">
                    <button type="button" class="btn btn-secondary center-text" onclick="logOut()">
                        <i class="bi bi-box-arrow-left"></i> Log Out
                    </button>
                    '

                    if [ "${isSudoer}" == true ]; then
                        html+='
                            <button type="button" class="btn btn-warning center-text" onclick="restart()">
                                <i class="bi bi-arrow-clockwise"></i> Restart
                            </button>
                            <button type="button" class="btn btn-danger center-text" onclick="powerOff()">
                                <i class="bi bi-power"></i> Power Off
                            </button>
                            '
                    fi
                
                html+='
                </div>
                
                <script>
                    function processes() {
                        location.replace("processes.sh");
                    }

                    function monitoring() {
                        location.replace("monitoring.sh");
                    }

                    function users() {
                        location.replace("users.sh");
                    }

                    function logOut() {
                        location.replace("login.sh");
                    }

                    function restart() {
                        location.replace("restart.sh");
                    }

                    function powerOff(url) {
                        location.replace("power_off.sh");
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
else
    html='
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
                
                <style>
                    .bd-placeholder-img {
                        font-size: 1.125rem;
                        text-anchor: middle;
                        -webkit-user-select: none;
                        -moz-user-select: none;
                        user-select: none;
                    }

                    @media (min-width: 768px) {
                        .bd-placeholder-img-lg {
                        font-size: 3.5rem;
                        }
                    }
                </style>

                <!-- Custom styles for this template -->
                <link href="./css/login.css" rel="stylesheet">
            </head>
            <body class="text-center">
                <main class="form-signin">
                    <form action="login.sh" method="POST">
                        <img class="mb-4" src="./images/error.png" alt="" width="75" height="75">
                        <h1 class="h3 fw-normal">Username or password not valid</h1>
                        <button class="w-100 btn btn-lg btn-primary" type="submit">Back</button>
                    </form>
                </main>
                
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" 
                    integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" 
                    integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" 
                    integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
            </body>
        </html>
    '
fi


echo Content-type: text/html
echo
echo -e ${html}

