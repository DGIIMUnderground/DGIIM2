#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>

void handler(int signum);
int nhijos=0;


int main(int argc, char ** argv){
	if(argc!=2){
		printf("Error en los argumentos\n");
		exit(EXIT_FAILURE);
	}

	/*CAMBIO EL MANEJADOR DE SIGCHLD*/
	struct sigaction sa;
	sa.sa_handler=handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags=SA_RESTART;
	if(sigaction(SIGCHLD, &sa, NULL)==-1){
		perror("Error al establecer el manejador de señal\n");
	}
	
	/*CREO Y ABRO FIFOs*/	
	umask(0);

	mknod("FIFOe", S_IFIFO|0666,0);
	mknod("FIFOs", S_IFIFO|0666,0);
	int fifoin, fifoout;
	if((fifoin=open("FIFOs", O_RDWR))<0){
		perror("Error en open\n");
		exit(EXIT_FAILURE);
	}
	
	if((fifoout=open("FIFOe", O_RDWR))<0){
		perror("Error en open\n");
		exit(EXIT_FAILURE);
	}

	/*CREO LOS PROCESOS HIJOS*/
	int nprocesos=atoi(argv[1]);
	pid_t PIDs[nprocesos];
	int i;
	for(i=0; i<nprocesos; i++){
		if((PIDs[i]=fork())<0){
			perror("No se pudo crear un hijo\n");
			exit(EXIT_FAILURE);
		}
		nhijos++;
		if(PIDs[i]==0){
		break;
		}
	}
	/*GENERACIÓN DE NÚMEROS ALEATORIOS Y ESCRITURA EN EL CAUCE*/
	int naleatorio = rand()%5; //He puesto 5 por no pararme a programar el numero de archivos del directorio
	for(i=0; i<nprocesos; i++){	
		int naleatorio = rand()%7;
		write(fifoout, &naleatorio, sizeof(int));
	}
	
	/*LLAMADA AL PROGRAMA ESCLAVO*/
	for(i=0; i<nprocesos; i++){
		if(PIDs[i]==0){
			sleep(i);
			if(execlp("./slave", "./slave", NULL)==-1){
				perror("Error en execlp");
				exit(EXIT_FAILURE);
			}
			exit(EXIT_SUCCESS);
		}
	}

	/*LECTURA DEL TRABAJO DEL PROCESO HIJO*/
	char cadena[PATH_MAX];
	for(i=0; i<nprocesos; i++){
		read(fifoin, cadena, PATH_MAX);
		printf("%s", cadena);
	}
}

void handler(int signum){
	nhijos--;	
}
