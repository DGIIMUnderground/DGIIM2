# Sesión 6
## Ejercicio 1
> Implementa un programa que admita t argumentos. El primer argumento será unaorden de Linux; el segundo, uno de los siguientes caracteres “<” o “>”, y el tercero el nombre de un archivo (que puede existir o no). El programa ejecutará la orden que se especifica como argumento primero e implementará la redirección especificada por el segundo argumento hacia el archivo indicado en el tercer argumento

Ejecutaremos el programa de la forma `./Programa orden {<,>} archivo`. Será necesario *escapar* > y < para que se acepte. Un ejemplo de uso sería:
```
./Ej1 ls \> Prueba.txt
```
Cuando hagamos `fcntl()`, redireccionaremos la entrada estándar a un cierto. Lo haremos con permisos de lectura o escritura, dependiendo de lo que nos hayan pasado. Dicho esto, este es el código del programa:
```c
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char ** argv){
	if (argc != 4){
		perror("Syntax error: orden \"<\"\">\" archivo");
		exit(1);
	}

	char * programa = argv[1];
	char * redireccion = argv[2];
	char * archivo = argv[3];

	// Descriptor
	int fd;


	if (strcmp(redireccion,"<") == 0){
		if ((fd = open (archivo, O_RDONLY)) < 0){ // Abrimos archivo. O_RDONLY => solo lectura
			perror("Error en el open\n");
			exit(EXIT_FAILURE);
		}

		close(STDIN_FILENO); // Cerramos la entrada estándar

		if ((fcntl(fd, F_DUPFD, STDIN_FILENO)) == -1){ // Ajustamos la entrada estándar con el fichero
			perror("Error en fcntl\n");
			exit(EXIT_FAILURE);
		}

		// Ahora la entrada estándar es el fichero
		if((execlp(programa,"", NULL)) < 0){ //Ejecutamos la orden
			perror("Error en execlp\n");
			exit(EXIT_FAILURE);
		}

	} else if (strcmp(redireccion,">") == 0){
		if ((fd = open (archivo, O_WRONLY)) == -1){ // Abrimos archivo. O_WRONLY => escritura únicamente
			perror("Error en open\n");
      exit(EXIT_FAILURE);
		}

		close(1); // Cerramos la salida estándar

		error = fcntl(fd, F_DUPFD, 1); // Redirección de salida

		if (execlp(programa,"", NULL) < 0){
			perror("Error en execlp");
      exit(EXIT_FAILURE);
		}
	}
	else{
		printf("Error en el argumento 2\n");
    exit(EXIT_FAILURE);
	}
}

```
