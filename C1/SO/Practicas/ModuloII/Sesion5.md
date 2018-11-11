## Ejercicio 1
Código del programa EnvioSignal.c:
```c
/*
 envioSignal.c
 Trabajo con llamadas al sistema del Subsistema de Procesos conforme a POSIX 2.10
 Utilización de la llamada kill para enviar una señal:
 0: SIGTERM
 1: SIGUSR1
 2: SIGUSR2
  a un proceso cuyo identificador de proceso es PID.
 SINTAXIS: envioSignal [012] <PID>
*/


#include <sys/types.h> //POSIX Standard: 2.6 Primitive System Data Types
#include<limits.h> //Incluye <bits/posix1_lim.h> POSIX Standard: 2.9.2 //Minimum    //Values Added to <limits.h> y <bits/posix2_lim.h>
#include <unistd.h> //POSIX Standard: 2.10 Symbolic Constants         <unistd.h>
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
	if(pid == LONG_MIN || pid == LONG_MAX) //Comprobación del rango permitido para PIDs
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
		case 0: //SIGTERM
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
 Utilización de la llamada sigaction para cambiar el comportamiento del proceso frente a la recepción de una señal.
*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <stdlib.h>

static void sig_USR_hdlr(int sigNum) // Número de señal recibida
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

    sig_USR_nact.sa_handler= sig_USR_hdlr; //El handler se encara de interceptar las señales mandadas desde fuer


    //'sigemptyset' inicia el conjunto de señales dado al conjunto vacio.

    sigemptyset (&sig_USR_nact.sa_mask);
    sig_USR_nact.sa_flags = 0;

    //Establecer mi manejador particular de señal para SIGUSR1
    if( sigaction(SIGUSR1,&sig_USR_nact,NULL) <0)
    //                       ^^^^^^    tratamiento para la señal
    {
        perror("\nError al intentar establecer el manejador de senal para SIGUSR1");
        exit(EXIT_FAILURE);
    }

    //Establecer mi manejador particular de señal para SIGUSR2
    if( sigaction(SIGUSR2,&sig_USR_nact,NULL) <0)
    {
        perror("\nError al intentar establecer el manejador de senal para SIGUSR2");
        exit(EXIT_FAILURE);
    }

    while (true);
}
```

## Ejercicio 2
Podemos ver la lista de señales poniendo en la terminal `kill -l`. `SIGUSER1` y `SIGUSER2` en principio, no están definidas. Las podemos definir nosotros mismos.
`sigaction(int, const struct sigaction*, struct sigaction*)` es capaz de indicar qué hacer bajo cierta señal. El entero es el número de señal.

Podemos enviar las señaes con `kill -[Identificador de señal] [PID del proceso]`. Para dejar al proceso muerto matao', usamos `kill -KILL PID`, o `kill -SIGKILL PID`. Son equivalentes.

Código del programa usando la estructura `sigaction`:
```c
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <stdlib.h>

static int j;
static int contadores[31];

static void handler(int i){
    contadores[i]++;
    printf("La señal %d se ha recibido %d veces\n", i, contadores[i]);
};

int main(){
    struct sigaction sa;

    // Nuestro handler se encargará de gestionar qué narices pasa cuando
    // se le manda una señal específica. En nuestro caso, incrementará
    // una variable, dependiendo de la señal.
    sa.sa_handler = handler;
    sigemptyset(&sa.sa_mask);


    // Reiniciar las funciones que hayan sido interrumpidas por un manejador
    sa.sa_flags = SA_RESTART;

    int contadores[31];

    for (j=1; j<31; j++)
        contadores[j] = 0;

    int i;
    for (i=1; i<=60; i++)
        if (sigaction(i, &sa, NULL) == -1)
            printf("Error en el handler");

    while(1);
}
```

Programa alternativo utilizando la biblioteca signal:
```c
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>

//Contador de las veces que se ha usado cada señal
int contador[35];

//Funcion para llevar el contador
static void handler(int sig) {
  contador[sig]++;
  printf("\nSe ha recibido la señal %d, que se ha realizado %d veces.",sig, contador[sig]);
}


int main() {
   setvbuf(stdout, NULL, _IONBF, 0);

  //Pongo a 0 todo el contador de las señales
  int i;
  for(i=0; i < 35; i++)
    contador[i] = 0;

  //Informamos de las señales que no podemos manejar

  printf("No puedo manejar la señal %d\n", SIGKILL);
  printf("No puedo manejar la señal %d\n", SIGSTOP);

  //Ahora trabajamos con las señales recibidas
  //Primero vamos a dar de alta las señales que podemos utilizar, en mi caso, van a hacer todas lo mismo, incrementar en 1 su contador

 //Asociamos las 35 señales a la función handler, para que cuando las llamemos, se incremente su contador
  for(i=1; i <= 35; i++)
        signal(i,handler);

  //Bucle infinito para que el programa se ejecute mientras no le mandemos las señales para terminar(9,19)
  while (1);

}
```

## Ejercicio 3

Código del programa:
```c
#include <stdio.h>
#include <signal.h>

int main(){
    sigset_t mascara;

    // Creamos la máscara, y la vaciamos por si tuviera basura
    sigemptyset(&mascara);

    // La rellenamos con todas las máscaras posibles
    sigfillset(&mascara);

    // Eliminamos la que nos interesa: SIGUSR1
    sigdelset(&mascara, SIGUSR1);

    // Cuando suspendamos, el programa no reaccionará a ninguna señal, excepto SIGUSER1
    sigsuspend(&mascara);
}
```

## Ejercicio 4
Código del programa:
```c
// tarea12.c

#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

static int signal_recibida = 0;

static void manejador (int sig) {
          signal_recibida = 1;
}

int main (int argc, char *argv[]) {
    sigset_t conjunto_mascaras;
    sigset_t conj_mascaras_original;
    struct sigaction act;

    //Iniciamos a 0 todos los elementos de la estructura act
    memset (&act, 0, sizeof(act));

    act.sa_handler = manejador;

    if (sigaction(SIGTERM, &act, 0) == -1) {
        perror ("sigaction");
        exit(EXIT_FAILURE);
    }

    //Iniciamos un nuevo conjunto de mascaras
    sigemptyset (&conjunto_mascaras);
    //Añadimos SIGTERM al conjunto de mascaras
    sigaddset (&conjunto_mascaras, SIGTERM);

    //Bloqueamos SIGTERM
    //
    if (sigprocmask(SIG_BLOCK, &conjunto_mascaras, &conj_mascaras_original) < 0) {
       perror ("primer sigprocmask");
       exit(EXIT_FAILURE);
    }

    sleep (10);

    //Restauramos la señal y desbloqueamos SIGTERM
    if (sigprocmask(SIG_SETMASK, &conj_mascaras_original, NULL) < 0) {
       perror ("segundo sigprocmask");
       exit(EXIT_FAILURE);
    }

    sleep (1);

   if (signal_recibida)
       printf ("\nSenal recibida\n");
   exit(EXIT_SUCCESS);
}
```
La función sigprocmask se emplea para modificar la lista de señales bloqueadas en un momento dado. Tiene la siguiente sintáxis:
```c++
int sigprocmask (int how, const sigset_t * set, sigset_t * old_set)
```
El primer parámetro, `how`, determina el comportamiento ante las máscaras. Sus posibles valores son:
- **SIG_BLOCK**: El conjunto de señales bloqueadas es la unión del actual y las de `set`
- **SIG_UNBLOCK**: El conjunto de señales presentes en set se eliminan de las bloquedas. Se considera permitido el intento de desbloquear una señal que no se haya bloqueada
- **SIG_SETMASK**: El conjunto de señales bloqueadas pasa a ser las de `set`

Por tanto, en nuestro programa, bloqueamos las típicas y la SIGTERM. SIGTERM es una señal de apagado *amable*: permite cerrar buffers, archivos abiertos, liberar memoria, etc... Es la señal por defecto cuando hacemos `kill PID` en la terminal.

Volviendo al cauce del programa: cuando usamos el segundo `sigprocmask()`, esta vez, usamos el parámetro SIG_SETMASK. Por tanto, vamos a bloquear las que contenga `conj_mascaras_original`. Esta contiene las originales: aquellas que se encontraban bloqueadas *antes* del primer `sigprocmask()`. Puedes ver que adquirimos el valor de las originales al pasárselo como tercer argumento en la primera ejecución.

Entre sigprocmask y sigprocmask, hemos dejado al programa inactivo 10s. Este periodo de tiempo nos permite capturar las señales. Como el manejador de señales es la función `manejador()`, si alguna señal ha llegado durante esos 10s (incluido SIGTERM), se ejecutará el `if()` final, indicándonos que, efectivamente, se ha recibido alguna señal
