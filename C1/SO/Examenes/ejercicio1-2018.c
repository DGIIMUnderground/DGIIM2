/*Ejercicio 1: 
	Modo de uso: ./ex1 nombre_directorio
	Recorrer el directorio pasado como argumento, de modo que para los archivos 
	regulares que tengan el bit de usuario efectivo activado (SUID):

		1)Añadir los permisos rwx para otros.
		2)Mostrar el nombre completo de la ruta y el nº de inodo por pantalla
		3)En el directorio home del usuario crear un archivo con el mismo nombre,
	      con los mismos permisos (antes de modificarlos) y vacío.	
	      (Aclaración: se puede obtener el directorio con: char *home = getenv("HOME"))
	(Aclaración: incluir <limits.h>, donde se define PATH_MAX, que indica el tamaño 
	 máximo que puede tener la ruta de un archivo)
*/

#include<sys/types.h>	
#include<unistd.h>		
#include<sys/stat.h>
#include<fcntl.h>		
#include<stdio.h>
#include<errno.h>
#include<stdlib.h>
#include<dirent.h>
#include<string.h>
#include<limits.h>

int main(int argc, char * argv[]){
	
	DIR * midir;
	struct dirent * lectura;
	struct stat atributos;
	char ruta_archivo[PATH_MAX];
	int permisos;
	int fd;

	//Comprobamos argumentos
	if(argc != 2){
		printf("Error en el número de argumentos.\n");
		exit(EXIT_FAILURE);
	}
	
	//Obtenemos directorio inicial
	char *home = getenv("HOME");

	//Abrimos directorio pasado como argumento
	if((midir = opendir(argv[1]))==NULL){
		perror("opendir");
		exit(EXIT_FAILURE);
	}

	//Recorremos directorio
	while((lectura = readdir(midir)) != NULL){
		sprintf(ruta_archivo, "%s/%s", argv[1], lectura->d_name),
		lstat(ruta_archivo, &atributos);
		
		if(S_ISREG(atributos.st_mode) && ((atributos.st_mode & S_ISUID)==S_ISUID)){
			permisos = atributos.st_mode;
			
			//Cambiamos permisos
			if(chmod(ruta_archivo, atributos.st_mode|S_IRWXO)){
				perror("chmod");
				exit(EXIT_FAILURE);
			}
			
			//Mostramos información
			printf("%s, inodo <%d>\n", ruta_archivo, (int)atributos.st_ino);

			//Creamos nuevo archivo
			sprintf(ruta_archivo, "%s/%s", home, lectura->d_name);
			if((fd=open(ruta_archivo, O_CREAT|O_RDONLY))<0){   //El archivo se crea debido al flag O_CREAT
				perror("open");
				exit(EXIT_FAILURE);
			}
			if(chmod(ruta_archivo, permisos)<0){
				perror("chmod");
			}
			if(close(fd)<0){
				perror("close");
				exit(EXIT_FAILURE);
			}
		}
		
	}
	//Cerramos directorio
	if(closedir(midir)<0){
		perror("closedir");
		exit(EXIT_FAILURE);
	}
	exit(EXIT_SUCCESS);
}
