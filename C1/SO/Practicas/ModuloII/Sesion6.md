# Sesión 6
##### Función fcntl
```c
fcntl(int descriptor, int orden, parámetros_orden )
//                                ^^^^^^^^^^^^^
// Si los requiriera, se pueden especificar en el tercer argumento. Es opcional
```

fcntl == file control
`orden` puede adquirir los valores...
- F_GETFL == get flags
- F_SETFL == set flags
- F_SETFD => el próximo hijo cerrará el descriptor
- F_GETFD => Recibe el estado de la bandera "close on exec"
- F_DUPFD => duplicate file descriptor
Bloqueos
- F_SETLK  => set lock
- F_SETLKW => set lock and wait
- F_GETLK  => get lock

##### Estructura flock
Parámetro más importante: `l_type`. Adquiere los valores {F_RDLCK, F_WRLCK, F_UNLCK} (lectura, escritura y desbloquear)

Ejemplo de uso con fcntl:
```c
struct flock mi_bloqueo.l_type = F_WRLCK

fcntl(fd, orden, &mi_bloqueo);
//       ^^^^^^^
// orden ∊ {F_SETLK, F_SETLKW, F_GETLK} 
```

---

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

*Nota: La profesora no ha especificado si debemos usar dup o fcntl en el examen. Lo dejo aquí como registro. Luego lo borramos -Andrés*

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
    printf("Error en los argumentos\n");
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
## Ejercicio 3
> Construir un programa que verifique que, efectivamente, el kernel comprueba quepuede darse una situación de interbloqueo en el bloqueo de archivos

Código del programa: 
```c
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
int main (int argc, char * argv[])
{
    struct flock cerrojo;   //estructura del cerrojo
    int i,fd;               //descriptor de archivo
    char basura[5];
    
    for( i=1; i<argc; i++) {
        if ((fd=open(argv[i], O_RDWR)) == -1 ) {//abrimos el archivo para escritura
            perror("open fallo");
            continue;
        }
		//creamos la estructura del cerrojo
        cerrojo.l_type=F_WRLCK;    //cerrojo para escritura
        cerrojo.l_whence=SEEK_SET;
        cerrojo.l_start=0;	       //archivo completo
        cerrojo.l_len=0;	  

        /* intentamos un bloqueo de escritura del archivo completo */
        if((fcntl (fd, F_SETLKW, &cerrojo) )== -1) {
            if(errno==EDEADLK)
                printf("ha detectado interbloqeo EDEADLK\n");

        }
        printf ("cerrojo puesto sobre el archivo %s\n",argv[i]);
        printf ("pulse cualquier tecla\n");
        
        scanf("%s",basura);

        sleep(1); //hacemos sleep para ver apreciar con mas detalle.

        /*  no desbloqueamos
         cerrojo.l_type=F_UNLCK;
         cerrojo.l_whence=SEEK_SET;
         cerrojo.l_start=0;
         cerrojo.l_len=0;
         if (fcntl (fd, F_SETLKW, &cerrojo) == -1) perror ("Desbloqueo");
        */
    }
    return 0;
}
```

## Ejercicio 4
> Construir un programa que se asegure que solo hay una instancia de él enejecución en un momento dado. El programa, una vez que ha establecido el mecanismo paraasegurar que solo una instancia se ejecuta, entrará en un bucle infinito que nos permitirácomprobar que no podemos lanzar más ejecuciones del mismo. En la construcción del mismo,deberemos asegurarnos de que el archivo a bloquear no contiene inicialmente nada escrito enuna ejecución anterior que pudo quedar por una caída del sistema.

De la forma en la que yo lo he hecho, no hace falta comprobar que se ha escrito algo. En cada ejecución, se abre y se bloquea sin escribir nada. Cuando termina, se desbloquea y sale

Código del programa:
```c
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
int main (int argc, char * argv[])
{
    struct flock cerrojo;
    int fd; 
    
    // Este archivo será el que usemos para comprobar bloqueos
    //           vvvvvvvvvvvvvvvvvvvvv
    if ((fd=open("./peaso_demonio.pid", O_RDWR | O_CREAT)) == -1 ) {//abrimos el archivo para escritura
        perror("Error al crear el archivo temporal");
        return 1;
    }
    //creamos la estructura del cerrojo
    cerrojo.l_type=F_WRLCK;    //cerrojo para escritura
    cerrojo.l_whence=SEEK_SET;
    cerrojo.l_start=0;	       //archivo completo
    cerrojo.l_len=0;	  

    // Comprobamos que no está activo el archivo
    if((fcntl (fd, F_SETLK, &cerrojo) )== -1) {
        printf("Se ha detectado otra instancia en ejecución. Cerrando...\n");
        sleep(1);
        return 1;
    }
    
    // printf as fast as possible
    setvbuf(stdout,NULL,_IONBF,0);
    
    printf("El programa se estará ejecutando durante 15 segundos. Intenta abrir otra instancia");
    sleep(15);

    // Tras los 15 segundos, procedemos a desbloquear
    cerrojo.l_type=F_UNLCK;
    cerrojo.l_whence=SEEK_SET;
    cerrojo.l_start=0;
    cerrojo.l_len=0;

    if (fcntl (fd, F_SETLKW, &cerrojo) == -1) 
        perror ("Error al desbloquear");
    
    return 0;
}
```
## Ejercicio 5
> Escribir un programa, similar a la ordencp, que utilice para su implementación la llamada al sistema mmap() y una función de C que nos permite  copiar memoria, como, por ejemplo memcpy(). Para conocer el tamaño del archivo origen podemos utilizar stat()y para establecer el tamaño del archivo destino se puede usar ftruncate()
Código del programa:
```c
#include<sys/types.h>  
#include<sys/stat.h>
#include<fcntl.h>
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<errno.h>
#include <unistd.h>
#include <sys/mman.h>

int main(int argc, char *argv[]) {
    struct stat atributos;      //estructura de los atributos de archivos
    int fd1;                    //descriptor de archivo del primer archivo
    int fd2;                    //descriptor de archivo del segundo archivo
    int tamano;                   //ambos archivos tiene el mismo tamaño
    
    char *memoria1,*memoria2;
    umask(0);
    
    if (argc<3) {
        printf("Falta de argumentos\n");
        return 1;
    }

    if ((fd1=open(argv[1],O_RDONLY, S_IRWXU))<0) {//abierto solo para lectura
        printf("\nError %d en open",errno);
        exit(-1);
    }

    umask(0);

    if ((fd2=open(argv[2],O_CREAT|O_RDWR,S_IRWXU))<0) {//abierto para escritura.
        printf("\nError %d en open",errno);
        exit(-1);
    }
    if (stat(argv[1],&atributos) < 0) // Adquirimos los atributos del archivo
        printf("\nError al intentar acceder a los atributos de %s",argv[1]);
    
    tamano = atributos.st_size;    //igualamos tamano al tamaño del archivo abierto para lectura

	//gestionamos la memoria para el segundo archivo abierto para escritura
    printf ("Ajustando el tamano archivo %s a %d \n",argv[2],tamano);
    ftruncate(fd2, tamano);      //trunca el tamaño de fd a i. i>tamano => rellena con NULL

	//abrimos la proyeccion del primer archivo para lectura, de forma compartida
    memoria1 = (char *)mmap(0, tamano, PROT_READ, MAP_SHARED, fd1, 0);
    if (memoria1 == MAP_FAILED) {       //retorna en memoria la direccion principal de la proyeccion
        perror("Fallo la proyeccion1"); //si fallo devuelve MAP_FAILED
        exit(-1);
    }

	//abrimos la proyeccion del segundo archivo para escritura, de forma compartida
    memoria2 = (char *)mmap(0, tamano,PROT_WRITE, MAP_SHARED, fd2, 0);
    if (memoria2 == MAP_FAILED) {//retorna en memoria la direccion principal de la proyeccion
        perror("Fallo la proyeccion2");//si fallo devuelve MAP_FAILED
        exit(-1);
    }

	//copiamos los archivos a traves de memoria
    printf ("Copiando del archivo %s al archivo %s\n",argv[1],argv[2]);
    memcpy(memoria2,memoria1,tamano);

    if (munmap (memoria1, tamano) == -1) {    //cerrar la proyeccion.
        printf("Error al cerrar la proyeccion \n");
        exit(-1);
    }
    if (munmap (memoria2, tamano) == -1) {    //cerrar la proyeccion.
        printf("Error al cerrar la proyeccion \n");
        exit(-1);
    }
     return 0;

}
```