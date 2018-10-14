## Ejercicio 1
Código del programa EnvioSignal.c: 
```c
/*
 envioSignal.c
 Trabajo con llamadas al sistema del Subsistema de Procesos conforme a POSIX 2.10
 Utilizaci�n de la llamada kill para enviar una se�al:
 0: SIGTERM
 1: SIGUSR1
 2: SIGUSR2
  a un proceso cuyo identificador de proceso es PID.
 SINTAXIS: envioSignal [012] <PID> 
*/

#include <sys/types.h>
#include<limits.h> 
#include <unistd.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>

int main(int argc, char *argv[]){
	long int pid;
	int signal;
	
	if(argc<3) {
		printf("\nSintaxis de ejecucion: envioSignal [012] <PID>\n\n");
		exit(EXIT_FAILURE);
	}
    
	pid= strtol(argv[2],NULL,10);
	if(pid == LONG_MIN || pid == LONG_MAX)
	{
		if(pid == LONG_MIN)
			printf("\nError por desbordamiento inferior LONG_MIN %ld",pid);
		else
			printf("\nError por desbordamiento superior LONG_MAX %ld",pid);
			perror("\nError en strtol");
			exit(EXIT_FAILURE);
	}
    
	signal=atoi(argv[1]);
	switch(signal){
		case 0: //SIGTERM => se carga el proceso
			kill(pid,SIGTERM); break;
		case 1: //SIGUSR1 
			kill(pid,SIGUSR1); break;
		case 2: //SIGUSR2
			kill(pid,SIGUSR2); break;
		default : // not in [012]
            printf("\n No puedo enviar ese tipo de senal"); 
	}
}
```
El programa se ejecuta de la siguiente forma:
`./ejecutable {0,1,2} PID`
Dependiendo de si usas 0,1 o 2, el programa con el PID que se ha enviado se cerrará de una forma u otra. No tiene más misterio

---

Código del programa ReciboSignal.c:
```c
/*
 reciboSignal.c
 Trabajo con llamadas al sistema del Subsistema de Procesos conforme a POSIX 2.10
 Utilizaci�n de la llamada sigaction para cambiar el comportamiento del proceso       
 frente a la recepci�n de una se�al.
*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <stdlib.h>

static void sig_USR_hdlr(int sigNum)
{
    if(sigNum == SIGUSR1)
        printf("\nRecibida la senal SIGUSR1\n\n");
    else if(sigNum == SIGUSR2)
        printf("\nRecibida la senal SIGUSR2\n\n"); 
}

int main(int argc, char *argv[])
{
    struct sigaction sig_USR_nact;

    if(setvbuf(stdout,NULL,_IONBF,0) ){    
        perror("\nError en setvbuf");
    }

    //Inicializar la estructura sig_USR_na para especificar la nueva acci�n para la se�al.

    sig_USR_nact.sa_handler= sig_USR_hdlr;


    //'sigemptyset' inicia el conjunto de se�ales dado al conjunto vacio. 

    sigemptyset (&sig_USR_nact.sa_mask);
    sig_USR_nact.sa_flags = 0;

    //Establecer mi manejador particular de se�al para SIGUSR1
    if( sigaction(SIGUSR1,&sig_USR_nact,NULL) <0) 
    {
        perror("\nError al intentar establecer el manejador de senal para SIGUSR1");
        exit(EXIT_FAILURE);
    }
    
    //Establecer mi manejador particular de se�al para SIGUSR2
    if( sigaction(SIGUSR2,&sig_USR_nact,NULL) <0) 
    {
        perror("\nError al intentar establecer el manejador de senal para SIGUSR2");
        exit(EXIT_FAILURE);
    }

    // while true?
    for(;;) {}
}
```