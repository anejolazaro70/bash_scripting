#!/bin/bash
#script que arranca o para servidor ssh local
#acepta como argumentos 'start' para arrancar y 'stop' para parar
#si el servidor esta corriendo y el argumento es 'start', no hace nada
#si el servidor esta corriendo y el argumento es 'stop', lo para
#si el servidor esta parado y el argumento es 'start', lo arranca
#si el servidor esta parado y el argumento es 'stop', no hace nada
#si no se proporcionan argumentos, se genera un error
#posibles mejoras...
#1. Hacer manual o ayuda de script
#2. Forzar para que se ejecute en modo privilegiado
RUNNING=$(sudo netstat -nutlp | grep sshd)
ESTADO_SSHD=$?
#echo $RUNNING
#echo $ESTADO_SSHD
#echo $1
function ayuda(){
    echo 'Este script se utiliza para arrancar o parar el servicio ssh local'
    echo
    echo "Uso: ./servidor_ssh.sh start|stop"
    echo
    echo "start: arranca el servidor si no esta funcionando"
    echo "stop: para el servidor si no esta funcionando"
    echo
}

function pid_sshd(){
    RUNNING=$(sudo netstat -nutlp | grep sshd)
    for CAD in $RUNNING
        do
            if [[ $CAD =~ ^[0-9]+/sshd ]]
                then
                    PID=$(echo $CAD | grep -oP '\d+')
            fi
        done
}

if [ "$1" != 'start' ] && [ "$1" != 'stop' ]
    then
        ayuda
        exit 1
fi


if [ $ESTADO_SSHD -eq 0 ]
    then
        pid_sshd
        case "$1" in 
            stop )
                echo 'servidor ssh is running. PID: '$PID 'Stopping...'
                $(sudo /etc/init.d/ssh stop)
                exit 0
                ;;
            start )
                echo 'servidor ssh running. PID: '$PID
                exit 0
                ;;
        esac
elif [ $ESTADO_SSHD -ne 0 ]
    then
        case $1 in
            'start')
                echo 'servidor ssh is not running. Starting...'
                $(sudo /etc/init.d/ssh start)
                pid_sshd
                echo "PID: " $PID
                exit 0
                ;;
            'stop' )
                echo 'servidor ssh is not running'
                exit 0
                ;;
        esac
fi
