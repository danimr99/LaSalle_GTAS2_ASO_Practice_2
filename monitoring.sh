#!/bin/bash


# Get stats for CPU, Memory and Disk
cpu=$(cat /proc/stat |grep cpu |tail -1|awk '{ print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10) }' | awk '{ print 100-$1 }')
memory=$(free -m | awk 'NR==2{ print $3*100/$2 }')
disk=$(df -h | awk '$NF=="/"{ printf $3/$2*100 }')

# Log action to file
now=$(date)
username=$(cat /var/www/cgi-bin/data/username.txt)
echo "User ${username} has displayed resources statistics [${now}]" >> /var/www/cgi-bin/data/log.txt


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

            <!-- Includes for the gauges -->
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <script type="text/javascript">
                google.charts.load("current", {"packages":["gauge"]});
                google.charts.setOnLoadCallback(drawChart);

                function drawChart() {

                    var data = google.visualization.arrayToDataTable([
                    ["Label", "Value"],
                    ["Memory", '${memory}'],
                    ["CPU", '${cpu}'],
                    ["Disk", '${disk}']
                    ]);

                    var options = {
                        width: 800, height: 240,
                        redFrom: 90, redTo: 100,
                        yellowFrom:75, yellowTo: 90,
                        minorTicks: 5
                    };

                    var chart = new google.visualization.Gauge(document.getElementById("chart_div"));

                    chart.draw(data, options);
                }
            </script>
        </head>
        <body>
            <!-- Header -->
            <div class="row w-100 text-center">
                <h1 class="center">Monitoring</h1>
            </div>

            <br><br><br>

            <!-- Gauges -->
            <div id="chart_div" style="width: 800px; height: 240px; text-align: center; margin: 0 auto;"></div>

            <br><br>

            <!-- Access log -->
            <div class="row w-100 text-center">
                <h1 class="center">Access Log</h1>
            </div>
            <br>
            <div class="container">
                <ul class="list-group">
                '
                # Count lines of access log file
                linesCounter=`sudo cat /var/log/apache2/access.log | wc -l`

                # Read last 10 access logs to the server
                counter=10
                while [ $counter -gt 0 ] 
                do
                    index=$(($linesCounter - $counter))

                    line=`sudo cat /var/log/apache2/access.log | awk FNR==${index}`

                    echo '<li class="list-group-item">'${line}'</li>'

                    counter=$(($counter - 1))
                done
                
                echo '
                </ul>
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



