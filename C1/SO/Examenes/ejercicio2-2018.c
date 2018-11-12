// Quijano Rey - Sergio
// Doble Grado Ingenieria Informatica Matematicas

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>

#define NEJ 60
#define NSALIDA 1024
static int acabado = 1;

static void handler (int signum){
	printf("Se ha recibido la señal %i\n");
	acabado = 0;
}

int main(int argc, char * argv[]){
	extern int errno;
	char current_salida[NSALIDA];
	char old_salida[NSALIDA] = "\0";

	// Añado un manejador para señales para SIGINT
	struct sigaction sa;
	sa.sa_handler = handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART;
	if(sigaction(SIGINT, &sa, NULL) == -1){
		perror("Error cambiando el manejador de señales\n");
		exit(EXIT_FAILURE);
	}

	// Depuro la entrada de argumentos
	if(argc != 2){
		perror("Error! Argumentos invalidos\n");
		perror("Modo de uso: ./miwatch <path>\n");
		exit(EXIT_FAILURE);
	}


	// Ejecuto el numero de veces necesarias el comando
	for(int i = 0; i < NEJ && acabado != 0; i++){
		// Creo un cauce sin nombre
		int cauce[2];
		if(pipe(cauce) == -1){
			perror("Error creando cauce sin nombre\n");
			exit(EXIT_FAILURE);
		}
		
		// Creo un hijo
		int pid = fork();
		if(pid < 0){
			perror("Error creando un hijo\n");
			exit(EXIT_FAILURE);
		}

		if(pid == 0){//HIJO
			// El hijo solo escribe
			if(close(cauce[0]) == -1){
				perror("Error cerrando el cauce de entrada en el hijo\n");
				exit(EXIT_FAILURE);
			}

			// Conecto la salida estandar con el cauce
			if(close(STDOUT_FILENO) == -1){
				perror("Error cerrando la salida\n");
				exit(EXIT_FAILURE);
			}

			// Conecto la salida al cauce
			if(dup2(cauce[1], STDOUT_FILENO) == -1){
				perror("Error redireccionando la salida al cauce\n");
				exit(EXIT_FAILURE);
			}

			// Ejecuto el comando
			int errcode = execlp("ls", "ls", argv[1], NULL);

			// Manejo el error del ls
			if(errcode == -1){
				perror("Error ejecutando el comando\n");
				printf("Valor de errno: %i\n", errno);

				// Devuelvo al padre la condicion de fallo
				exit(errno);
			}
			
			// Cierro el cauce de salida
			if(close(cauce[1]) == -1){
				perror("Error en cierre final del cauce del hijo\n");
				exit(EXIT_FAILURE);
			}
		}else{//PADRE
			// El padre solo lee
			if(close(cauce[1]) == -1){
				perror("Error cerrando el cauce de salida del padre\n");
				exit(EXIT_FAILURE);
			}

			// Espero a que termine la ejecución del hijo
			int status;
			waitpid(pid, &status, 0);
			
			// Compruebo el estado de la salida del hijo
			if(WIFEXITED(status) == 0){	// Ha salido mal
				perror("Mi hijo ha acabado mal\n");
				acabado = 0;

				// Muestro por pantalla el valor de ls si me es posible
				if(read(cauce[0], current_salida, NSALIDA) == -1){
					printf("No puedo mostrar la salida cuando ha fallado el hijo\n");
				}else{
					printf("Valor de salida cuando falla el hijo:\n%s\n", current_salida);
				}	
			}

			// Leo del cauce en el array
			if(read(cauce[0], current_salida, NSALIDA) == -1){
				perror("Error leyendo del cauce la salida de ls\n");
				exit(EXIT_FAILURE);
			}

			// Muestro lo que se ha leido por pantalla
			printf("Contenido leido:\n%s\n", current_salida);

			// Cierro el cauce de entrada
			if(close(cauce[0]) == -1){
				perror("Error en el cierre final del padre\n");
				exit(EXIT_FAILURE);
			}
			
		}

		// Compruebo que las salidas coinciden
		if(memcmp(current_salida, old_salida, NSALIDA) != 0 && strcmp(old_salida, "\0") != 0){
			perror("Dos ejecuciones no coinciden!\n");
			acabado = 0;
		}

		// Paralizo la ejecucion del programa 1 segundo
		sleep(1);
	}

	// Toda la ejecucion ha salido OK
	exit(EXIT_SUCCESS);
}
