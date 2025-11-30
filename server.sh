#!/bin/bash

APP="main:app"
PORT=8080

case "$1" in
    start)
        echo "Stopping old processes..."
        pkill -f "gunicorn" 2>/dev/null

        echo "Starting Gunicorn on 0.0.0.0:$PORT..."
        nohup gunicorn -w 3 -b 0.0.0.0:$PORT $APP > server.log 2>&1 &
        echo "Started. Check: http://0.0.0.0:$PORT"
        ;;
    
    stop)
        echo "Stopping Gunicorn..."
        pkill -f "gunicorn"
        echo "Stopped."
        ;;
    
    status)
        if lsof -i :$PORT >/dev/null; then
            PID=$(lsof -t -i :$PORT)
            echo "Gunicorn is running on port $PORT (PID $PID)"
        else
            echo "Gunicorn is NOT running."
        fi
        ;;
    
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        ;;
esac
