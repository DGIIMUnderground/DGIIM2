#include <stdio.h>
#include <signal.h>
#include <sys/types.h>	
#include <sys/wait.h>
#include <unistd.h>		
#include <sys/stat.h>
#include <fcntl.h>		
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#define NEJ 60
#define NSALIDA 1024

//Manejador para SIGINT
void sa_handler_SIGINT(int signum){
	wait(NULL);
	unlink("FIFO");
	printf("Finalizamos programa.\n");
	exit(EXIT_FAILURE);
}

int main(int argc, char * argv[]){

	char salida[NSALIDA], salida_anterior[NSALIDA];
	struct sigaction sa;
	pid_t PID;
	int estado;
	int fd;
	int leido;
	char separacion[2]="\n";
	int fin;

	//Comprobamos argumentos
	if(argc != 2){
		printf("Error en el número de argumentos.\n");
		exit(EXIT_FAILURE);
	}
	
	//Cambiamos acción de SIGINT (Ctrl+C)
	sa.sa_handler = sa_handler_SIGINT;
	if(sigaction(SIGINT, &sa, NULL)<0){
		perror("Error en sigaction.\n");
		exit(EXIT_FAILURE);
	}

	//Creamos FIFO intermediario
	umask(0);
	unlink("FIFO");
	if(mkfifo("FIFO", 0666)<0){
		perror("mkfifo");
		exit(EXIT_FAILURE);
	}
	
	//Abrimos FIFO
	if((fd=open("FIFO", O_RDWR))<0){
		perror("open");
		exit(EXIT_FAILURE);
	}

	//Ejecuciones de ls
	fin = 0;
	for(int i=0; i<NEJ && !fin; i++){
		if((PID=fork())<0){
			perror("fork");
			exit(EXIT_FAILURE);
		}
		else if (!PID){ //PROCESO HIJO
			if(dup2(fd, STDOUT_FILENO)<0){
				perror("dup2");
				exit(EXIT_FAILURE);
			}
			if(execlp("ls", "ls", argv[1], NULL)<0){
				perror("ls");
				exit(EXIT_FAILURE);
			}
		}
		else{ //PROCESO PADRE
			
			wait(&estado);
			if(estado != EXIT_SUCCESS){ //Comprobamos estado del hijo
				exit(EXIT_FAILURE);
			}

			strcpy(salida_anterior, salida);
			if((leido=read(fd, salida, NSALIDA))<0){
				perror("read");
				exit(EXIT_FAILURE);
			}
			
			if(write(STDOUT_FILENO, salida, leido)<leido){
				perror("write");
				exit(EXIT_FAILURE);
			}

			if(write(STDOUT_FILENO, separacion, 2)<2){
				perror("write");
				exit(EXIT_FAILURE);
			}
			
			if(i>0){
				if(strcmp(salida_anterior, salida)!=0){
					printf("Se ha detectado cambios en el ls. Saliendo...");
					fin = 1;
				}
			}
		}
		sleep(1);	
	}
	
	//Cerramos y eliminamos FIFO
	close(fd);
	unlink("FIFO");	
	exit(EXIT_SUCCESS);
}
