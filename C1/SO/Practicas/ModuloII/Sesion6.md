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


## Ejercicio 2
> Reescribir el programa que implemente un encauzamiento de dos órdenes pero utilizando fcntl. Este programa admitirá tres argumentos. El primer argumento y el tercero serán dos órdenes de Linux. El segundo argumento será el carácter “|”. El programa deberá ahora hacer la redirección de la salida de la orden indicada por el primer argumento hacia el cauce, y redireccionar la entrada estándar de la segunda orden desde el cauce. Por ejemplo, para simular el encauzamiento ls|sort, ejecutaríamos nuestro programa como:
$> ./mi_programa2 ls “|” sort

Ejecutaremos el programa de la forma `./Programa orden1 "|" orden2`.

Un ejemplo de uso sería:
```
./Ej2 ls "|" sort
```


```c
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <stdbool.h>
#include <string.h>

int main (int argc, char * argv[]){
  char orden1[100], orden2[100];
  int fd[2];
  pid_t PID;

  if (argc != 4){
    perror("Número de argumentos incorrecto");
    exit(EXIT_FAILURE);
  }

  if (strcmp ("|", argv[2]) != 0){
    printf("Error en el argumento\n");
    exit(EXIT_FAILURE);
  }

  pipe(fd);

  if ((PID=fork()) < 0){
    perror("Error en el fork\n");
    exit(EXIT_FAILURE);
  }

  strcpy(orden1, argv[1]);
  strcpy(orden2, argv[3]);

  // Ejecución del hijo
  if (PID == 0){
    // Establecer la dirección del flujo de datos en el cauce cerrado
    // el descriptor de escritura en el cauce del proceso padre.
    close(fd[0]);

    // Redirigir la salida estándar para tomar los datos del cauce.
    // Cerrar la salida estándar del proceso hijo
    close(STDOUT_FILENO);

    // Hacemos la redirección hacia el archivo
    if (fcntl(fd[1], F_DUPFD, STDOUT_FILENO) == -1){
      perror("Error en fcntl\n");
      exit(EXIT_FAILURE);
    }

    // Ejecutamos el primer subprograma, del argumento 1
    // de esta manera lo que saldría por pantalla se escribirá en fd[1](cauce)
    execlp(orden1, orden1, NULL);
  }
  else{
    // Esperamos a que el hijo haya terminado
    sleep(1);

    // Establecer la dirección del flujo de datos en el cauce cerrando
    // el descriptor de escritura en el cauce del proceso padre.
    close(fd[1]);

    // Redirigir la entrada estándar para tomar los datos del cauce.
    // Cerrar la entrada estándar del proceso padre.
    close(STDIN_FILENO);

    // Hacemos la redirección hacia el archivo
    if (fcntl(fd[0], STDIN_FILENO) == -1){
      perror("Error en fcntl\n");
      exit(EXIT_FAILURE);
    }

    // Ejecutamos el segundo subprograma, del argumento 2
    // De esta manera lo que toma lo cogería del cauce en fd[0]
    execlp(orden2, orden2, NULL);
  }
}

```
