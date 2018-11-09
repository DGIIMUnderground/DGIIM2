/*
	Examen2015 Módulo II

	I) Parte obligatoria mínima (50%):
	Construir un único programa que cree un proceso hijo. Ambos procesos utilizaran un cauce con/sin
	nombre para comunicarse (el tipo de cauce lo dejo a vuestra elección). Donde el trabajo de cada
	proceso es:

	a) El padre:Lee el directorio actual y para cada archivo regular contenido en el mismo:
	• obtiene e imprime en pantalla su número de inodo junto con el UID del propietario.
	• escribe el nombre del archivo en el cauce.

	b) El hijo: Lee del cauce el nombre del archivo escrito por el padre el lo lee entero mediante el
	mecanismo de proyección de archivos. Tras lo cual, muestra en pantalla su contenido.

	II) Ampliación:
	a) [15%] El padre se asegura que los archivos cuyo nombre va a pasar al hijo tienen permiso de
	lectura para el proceso, si no fuese así, lo cambia para que los pueda leer el hijo.

	b) [15%] Establecer un manejador para la señal SIGPIPE en el padre en caso de que el proceso
	hijo finalice inesperadamente de forma que se indique el evento por pantalla.

	c) [20%] El acceso al archivo por parte del proceso hijo es exclusivo, es decir, bloqueará el
	archivo antes de acceder al mismo y lo desbloqueará al finalizar.

*/

#include <stdio.h>
#include <signal.h>
#include <sys/types.h>	
#include <unistd.h>		
#include <sys/stat.h>
#include <fcntl.h>		
#include <errno.h>
#include <stdlib.h>
#include <dirent.h>
#include <fcntl.h>
#include <string.h>
#include <sys/mman.h>

//Manejador para SIGPIPE
void sa_handler_SIGPIPE(int signum){
	printf("No hay lectores.\n");
	exit(EXIT_FAILURE);
}

int main(){
	pid_t pid;

	//Estructuras para moverse por el directorio
	int fd, fdarch;
	DIR *midir;
	struct dirent *lectura;
	struct stat atributos;

	//Datos para la proyección de memoria
	char * memoria;
	char archivo[50];
	size_t tamanio;
	char ch;

	//Cambio la acción de SIGPIPE (señal 13)
	struct sigaction sa;
	sa.sa_handler = sa_handler_SIGPIPE;
	if(sigaction(13, &sa, NULL)<0){
		perror("Error en sigaction.\n");
	}

	//Preparo el struct para el cerrojo
	struct flock cerrojo;
	cerrojo.l_type = F_RDLCK;
	cerrojo.l_whence = SEEK_SET;
	cerrojo.l_start = 0;
	cerrojo.l_len = 0;

	//Desactivo buffer para printf
	setvbuf(stdout, NULL,_IONBF, 0);

	//Creo FIFO
	umask(0);
	mkfifo("ARCHFIFO", 0666);

	//Bifurcación de procesos
	if((pid=fork())<0){
		perror("Error en el fork.");
		exit(EXIT_FAILURE);
	}
	else if(pid){ //PROCESO PADRE

		if((fd = open("ARCHFIFO", O_WRONLY, 0666))<0){
			perror("Error en open");
			exit(EXIT_FAILURE);
		}

		if((midir = opendir("."))<0){
			perror("Error abriendo el directorio");
			exit(EXIT_FAILURE);
		}
		//Leemos entradas del directorio
		while((lectura = readdir(midir)) != NULL){
			stat(lectura->d_name, &atributos);

			if(S_ISREG(atributos.st_mode)){ //Si es regular

				printf("<%d> %d\n", (int)atributos.st_ino, (int)atributos.st_uid);
				
				if(write(fd, lectura->d_name, strlen(lectura->d_name)+1)<strlen(lectura->d_name)+1){
					perror("Error en write");
				}
			}
		}
		close(fd);  

		//Esperamos la finalización del hijo
		wait(NULL);

		exit(EXIT_SUCCESS);

	}
	else{ //PROCESO HIJO
		if((fd = open("ARCHFIFO", O_RDONLY, 0666))<0){
			perror("Error en open");
			exit(EXIT_FAILURE);
		}

		//Establezco cerrojo
		fcntl(fd, F_SETLKW, &cerrojo);

		while(read(fd, &ch, sizeof(char))>0){
			archivo[0]=ch;
			int i=1;

			//Leemos nombre de archivp
			while(ch != '\0' && read(fd, &ch, sizeof(char))>0){
				archivo[i]=ch;
				i++;
			}
			if((fdarch=open(archivo, O_RDONLY))<0){
				perror("Error al abrir archivo");
				exit(EXIT_FAILURE);
			}
			if(stat(archivo, &atributos)<0){
				perror("Error en en stat");
				exit(EXIT_FAILURE);
			}

			//Proyectamos archivo en memoria
			memoria = (char *)mmap(0, atributos.st_size, PROT_READ, MAP_SHARED, fdarch, 0);
			if(memoria == MAP_FAILED){
				perror("Error al proyectar");
				exit(EXIT_FAILURE);
			}
		
			close(fdarch);

			printf("%s:\n\n%s\n\n", archivo, memoria);
			if(munmap(memoria, atributos.st_size)<0){
				perror("Error al liberar proyección.\n");
				exit(EXIT_FAILURE);
			}
			strcpy(archivo, "");
		}
		//Quitamos el cerrojo
		cerrojo.l_type = F_UNLCK;
		fcntl(fd, F_SETLKW, &cerrojo);

		close(fd);
		unlink("ARCHFIFO"); //Eliminamos el FIFO
		exit(EXIT_SUCCESS);
	}
}