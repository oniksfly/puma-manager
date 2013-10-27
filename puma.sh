#!/bin/bash

### BEGIN INIT INFO
# Provides:          scriptname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       Enable service provided by daemon.
### END INIT INFO

echo "Puma server manager"

if [ -z $1 ]
then
	process="info"
elif [ -n $1 ]
then
	process=$1
fi

if [ -z $2 ]
then
	project=""
elif [ -n $2 ]
then
	project=$2
fi


case $process in
	"start")
		echo "I'd like to start process"
		if [ -f /tmp/puma/puma-$project.pid ]
		then
    		echo "PID file already exist. Try: puma restart $project."
    	else
    		echo "Starting Puma server for $project"
    		/bin/bash -login -c "RAILS_ENV=production bundle exec puma -e production -d -b unix:///tmp/puma/puma-$project.sock --pidfile /tmp/puma/puma-$project.pid"
		fi
		;;
	"stop")
		echo "I'd like to stop Puma"
		if [ -f /tmp/puma/puma-$project.pid ]
		then
			echo "PID file already exist. I'm try to stop process."

    		PROCESS_NUMBER=$(ps -ef | grep `cat /tmp/puma/puma-$project.pid` | grep -v "grep" | wc -l)
    		echo $PROCESS_NUMBER
    		if [[ $PROCESS_NUMBER > 0 ]];
			then
    			echo "Process exist, stop it."
    			kill -9 `cat /tmp/puma/puma-$project.pid`
			else
				echo "Process didn't exist"
    		fi

    		rm /tmp/puma/puma-$project.pid
		else
			echo "No PID file exist. Nothing to stop."
		fi
		;;
	"restart")
		echo "I'd like to restart Puma"
		if [ -f /tmp/puma/puma-$project.pid ]
		then
    		echo "PID file already exist. I'm try to stop process."

    		PROCESS_NUMBER=$(ps -ef | grep `cat /tmp/puma/puma-$project.pid` | grep -v "grep" | wc -l)
    		if [[ $PROCESS_NUMBER > 0 ]];
			then
    			echo "Process exist, stop it."
    			kill -9 `cat /tmp/puma/puma-$project.pid`
			else
				echo "Process didn't exist"
    		fi

    		rm /tmp/puma/puma-$project.pid
    	else
            echo "PID file didn't exist. Nothing to stop."
		fi

        echo "Starting Puma server for $project"
        /bin/bash -login -c "RAILS_ENV=production bundle exec puma -e production -d -b unix:///tmp/puma/puma-$project.sock --pidfile /tmp/puma/puma-$project.pid"
		;;
	"info")
		echo "Puma server manager"
		;;
esac		
