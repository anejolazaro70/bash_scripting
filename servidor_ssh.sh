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
if [ "$1" != 'start' ] && [ "$1" != 'stop' ]
    then
        ayuda
        exit 1
fi

if [ $ESTADO_SSHD -eq 0 ]
    then
        if [ "$1" == 'stop' ]
            then
                echo 'servidor ssh is running. Stopping...'
                $(sudo /etc/init.d/ssh stop)
                exit 0
        elif [ "$1" == 'start' ]
            then
                echo 'servidor ssh running'
                exit 0
        fi
elif [ $ESTADO_SSHD -ne 0 ]
    then
        if [ "$1" == 'start' ]
            then
                echo 'servidor ssh is not running. Starting...'
                $(sudo /etc/init.d/ssh start)
                exit 0
        elif [ "$1" == 'stop' ]
            then
                echo 'servidor ssh is not running'
                exit 0
        fi
fi
