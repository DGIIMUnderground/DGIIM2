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

    // Para comprobar errores
    //       v
	int fd, error;
    //   ^
    // Descriptor

	if (strcmp(redireccion,"<") == 0){
		int fd = open (archivo, O_RDONLY); // Abrimos archivo. O_RDONLY => solo lectura
		close(STDIN_FILENO); // Cerramos la entrada estándar
        error = fcntl(fd, F_DUPFD, STDIN_FILENO); // Ajustamos la entrada estándar con el fichero
		// Ahora la entrada estándar es el fichero
		execlp(programa,"", NULL); //Ejecutamos la orden

	} else if (strcmp(redireccion,">") == 0){
		int fd = open (archivo, O_WRONLY); // Abrimos archivo. O_WRONLY => escritura únicamente
		close(1); // Cerramos la salida estándar 
		error = fcntl(fd, F_DUPFD, 1); // Redirección de salida 
		char bufer[256];
		execlp(programa,"", NULL); 
	}

	if (error == -1)
		perror("Ocurrió un error");
}

```
