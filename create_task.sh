#!/bin/bash


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
            
            <h1 class="center">Create Task</h1>

            <div class="container center-text w-50">
                <form style="margin: 5%;" action="add_task.sh" method="POST">
                    <div class="mb-3 ">
                        <label for="inputMinute" class="form-label">Minute</label>
                        <input type="text" class="form-control" id="inputMinute" name="inputMinute" aria-describedby="inputMinute" placeholder="Minute">
                    </div>
                    <div class="mb-3">
                        <label for="inputHour" class="form-label">Hour</label>
                        <input type="text" class="form-control" id="inputHour" name="inputHour" placeholder="Hour">
                    </div>
                    <div class="mb-3">
                        <label for="inputDay" class="form-label">Day</label>
                        <input type="text" class="form-control" id="inputDay" name="inputDay" placeholder="Day">
                    </div>
                    <div class="mb-3">
                        <label for="inputMonth" class="form-label">Month</label>
                        <input type="text" class="form-control" id="inputMonth" name="inputMonth" placeholder="Month">
                    </div>
                    <div class="mb-3">
                        <label for="inputWeekday" class="form-label">Weekday</label>
                        <input type="text" class="form-control" id="inputWeekday" name="inputWeekday" placeholder="Weekday">
                    </div>
                    <div class="mb-3">
                        <label for="inputCommand" class="form-label">Command</label>
                        <input type="text" class="form-control" id="inputCommand" name="inputCommand" placeholder="Command to be executed">
                    </div>
                    
                    <button type="submit" class="btn btn-primary center-text">Create</button>
                    <button type="button" class="btn btn-primary center-text" onclick="logOut()">Exit</button>
                </form>
            </div>
            
            
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