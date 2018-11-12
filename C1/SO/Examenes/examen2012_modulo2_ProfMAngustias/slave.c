#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>
#include <string.h>

int main(){
	int numero;
	int fin;
	fin=open("FIFOe",O_RDWR);
	if(fin==-1){
		perror("Error al abrir el fifo en el esclavo");
		exit(EXIT_FAILURE);
	}
	dup2(fin, STDIN_FILENO);
	if(read(STDIN_FILENO, &numero, sizeof(int))==0){
		printf("Error al leer del cauce");
		exit(EXIT_FAILURE);
	}
	DIR * directorio;
	struct dirent * actual;
	int i,fd;
	struct stat atributos;
	char ruta[PATH_MAX], mensaje[PATH_MAX];
	directorio=opendir(".");
	for(i=0; i<numero; i++)
		actual=readdir(directorio);
	sprintf(ruta, "./%s", actual->d_name);
	if(stat(ruta, &atributos)<0){
		printf("%s:\n", actual->d_name);
		perror("Error al acceder a los atributos de un archivo");
		exit(EXIT_FAILURE);
	}
	sprintf(mensaje, "\n%s:i-nodo: %ld\ntamaño: %ld\n", actual->d_name, atributos.st_ino, atributos.st_size);
	closedir(directorio);
	if((fd=open("FIFOs",O_RDWR))<0){
		perror("Error al abrir FIFOs");
		exit(EXIT_FAILURE);
	}
	if(write(fd,mensaje,strlen(mensaje)+1)!=strlen(mensaje)+1){
		perror("Error al escribir en el FIFO");
		exit(EXIT_FAILURE);
	}
	close(fd);
	exit(EXIT_SUCCESS);
}
