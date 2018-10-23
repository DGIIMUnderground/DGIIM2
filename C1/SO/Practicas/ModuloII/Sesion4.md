# Sesión 4. Comunicación entre procesos utilizando cauces
## Ejercicio 1: Trabajo con cauces con nombre
> Consulte en el manual las llamadas al sistema para la creación de archivos especiales en general (mknod) y la específica para archivos FIFO (mkfifo). Pruebe a ejecutar el siguiente código correspondiente a dos programas que modelan el problema del productor/consumidor, los cuales utilizan como mecanismo de comunicación un cauce FIFO. Determine en qué orden y manera se han de ejecutar los dos programas para su correcto funcionamiento y cómo queda reflejado en el sistema que estamos utilizando un cauce FIFO. 

Primero, necesitamos compilar y ejecutar ambos archivos. Es recomendable abrirlos con dos terminales, una al lado de otra. Primero, ejecutaremos `consumidorFIFO`. Este se quedará esperando al otro programa, `productorFIFO`. Cuando abramos el segundo con un pequeño mensajillo como segundo parámetro, podemos ver que aparece en la otra terminal. 
```
|------------------------------------------ | ------------------------------------------|
|--------------- Terminal 1 --------------- | --------------- Terminal 2 ---------------|
|------------------------------------------ | ------------------------------------------|
| $ ./consumidorFIFO                        |  $ ./productorFIFO prueba_de_mensaje      |
| Mensaje recibido: prueba_de_mensaje       |                                           |
|                                           |                                           |
|                                           |  $ ./productorFIFO tralalara-larita       |
| Mensaje recibido: tralalara-larita        |                                           |
|------------------------------------------ | ------------------------------------------| 
```
Códigos de los programas:
```c
//consumidorFIFO.c
//Consumidor que usa mecanismo de comunicacion FIFO
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define ARCHIVO_FIFO "ComunicacionFIFO"

int main(){
  int fd;
  char buffer[80];// Almacenamiento del mensaje del cliente
  int leidos;
  //Crear el cauce con nombre (FIFO) si no existe
  umask(0);
  mknod(ARCHIVO_FIFO,S_IFIFO|0666,0); //también vale: mkfifo(ARCHIVO_FIFO,0666);

  //Abrir el cauce para lectura-escritura
  if((fd=open(ARCHIVO_FIFO,O_RDWR)) <0){
    perror("open");
    exit(-1);
  }
  //Aceptar datos a consumir hasta que se envíe la cadena fin
  while(1) {
    leidos=read(fd,buffer,80);
    if(strcmp(buffer,"fin")==0) {
      close(fd);
      return 0;
    }
    printf("\nMensaje recibido: %s\n", buffer);
  }
  return 0;
}
```
```c
//productorFIFO.c
//Productor que usa mecanismo de comunicacion FIFO
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#define ARCHIVO_FIFO "ComunicacionFIFO"

int main(int argc, char *argv[]){
  int fd;

  //Comprobar el uso correcto del programa
  if(argc != 2) {
    printf("\nProductorFIFO: faltan argumentos (mensaje)");
    printf("\nPruebe: productorFIFO <mensaje>, donde <mensaje> es una
    cadena de caracteres.\n");
    exit(-1);
  }

  //Intentar abrir para escritura el cauce FIFO
  if((fd=open(ARCHIVO_FIFO,O_WRONLY)) <0){
    perror("\nError en open");
    exit(-1);
  }

  //Escribir en el cauce FIFO el mensaje introducido como argumento
  if((write(fd,argv[1],strlen(argv[1])+1)) != strlen(argv[1])+1){
    perror("\nError al escribir en el FIFO");
    exit(-1);
  }
  close(fd);
  return 0;
}
```

## Ejercicio 2: Trabajo con cauces sin nombre
> Consulte en el manual en línea la llamada al sistema pipe para la creación de cauces sin nombre. Pruebe a ejecutar el siguiente programa que utiliza un cauce sin nombre y describa la función que realiza. 

Un `pipe` es un mecanismo de transmisión de datos entre procesos. Como su nombre indica, es una tubería. Puedes mandar y recibir información:
```
             \.............../
Proceso 1 -> - - - - - - - - -> Proceso 2
             /```````````````\
```
En el grafico de arriba, mostramos cómo proceso 1 manda información al segundo. Sin embargo, tenemos que tener cuidado de que ambos no intenten mandar información a la vez, o se formaría un caos.
Hablando ya en `C`, abrimos un pipe con la orden `pipe(int [])`. Le pasaremos un array de enteros de tamaño 2. Simbolizaremos la recepción de datos con la posición 0. La escritura/envío será en la posición 1. 
En el código de tarea6.c, crearemos dos procesos: un hijo y un padre. El hijo cierra el denominado **descriptor** de lectura y escribe en el cauce; y el padre, cierra el de escritura y lee desde la pipe. Por tanto, recibe lo que pasa el hijo. 
~~~c
/*
tarea6.c
Trabajo con llamadas al sistema del Subsistema de Procesos y Cauces conforme a
POSIX 2.10
*/
#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
int main(int argc, char *argv[]){    
  int fd[2], numBytes;
  pid_t PID;
  char mensaje[]= "\nMensaje transmitido por un cauce\n";
  char buffer[80];

  pipe(fd); // Llamada al sistema para crear un cauce sin nombre
  if ((PID= fork())<0){
    perror("Error en fork");
    exit(-1);
  }

  if (PID == 0) { //Cierre del descriptor de lectura en el proceso hijo
    close(fd[0]);
    // Enviar el mensaje a través del cauce usando el descriptor de escritura
    write(fd[1],mensaje,strlen(mensaje)+1);
    exit(0);
  }
  else { // Estoy en el proceso padre porque PID != 0
    //Cerrar el descriptor de escritura en el proceso padre
    close(fd[1]);
    //Leer datos desde el cauce
    numBytes= read(fd[0],buffer,sizeof(buffer));
    printf("\nEl número de bytes recibidos es: %d",numBytes);
    printf("\nLa cadena enviada a través del cauce es: %s", buffer);
  }
  return(0);
}
~~~

## Ejercicio 3 
> Redirigiendo las entradas y salidas estándares de los procesos a los cauces podemos escribir un programa en lenguaje C que permita comunicar órdenes existentes sin necesidad de reprogramarlas, tal como hace el shell (por ejemplo ls | sort). En particular, ejecute el siguiente programa que ilustra la comunicación entre proceso padre e hijo a través de un cauce sin nombre redirigiendo la entrada estándar y la salida estándar del padre y el hijo respectivamente.

El matiz más técnico de este ejercicio es la redefinición de las salidas y entradas. In a nutshell, se modifican las salida y entrada estándar para que se use el cauce
Ejecutamos(`./tarea7`) tras haber compilado y enlazado con `gcc tarea7.c -o tarea7` y vemos como en efecto resulta lo mismo que al poner `ls|sort

Código del programa:
```c
/*
tarea7.c
Programa ilustrativo del uso de pipes y la redirección de entrada y
salida estándar: "ls | sort"
*/
#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
int main(int argc, char *argv[]){
  int fd[2];
  pid_t PID;

  pipe(fd); // Llamada al sistema para crear un pipe
  
  if ( (PID= fork())<0) {
    perror("fork");
    exit(-1);
  }
  if(PID == 0) { // ls
    //Establecemos la dirección del flujo de datos en el cauce cerrando
    // el descriptor de lectura de cauce en el proceso hijo
    close(fd[0]); //Así, redirigimos la salida estándar para enviar datos al cauce

    //Cerramos la salida estándar del proceso hijo
    close(STDOUT_FILENO);
  
    //Duplicamos el descriptor de escritura en cauce en el descriptor
    //correspondiente a la salida estándar (stdout)
    dup(fd[1]);
  
    execlp("ls","ls",NULL);
  }
  else { // sort. Estamos en el proceso padre porque PID != 0
  
    //Se establece la dirección del flujo de datos en el cauce cerrando
    // el descriptor de escritura en el cauce del proceso padre.
    close(fd[1]);
  
    //Redirigimos la entrada estándar para tomar los datos del cauce.
    //Cerramos la entrada estándar del proceso padre
    close(STDIN_FILENO);
  
    //Duplicamos el descriptor de lectura de cauce en el descriptor
    //correspondiente a la entrada estándar (stdin)
    dup(fd[0]);
  
    execlp("sort","sort",NULL);
  }
  return(0);
}
```

## Ejercicio 4 
Código del programa:
```c
/*
tarea8.c
Programa ilustrativo del uso de pipes y la redirecci�n de entrada y
salida est�ndar: "ls | sort", utilizando la llamada dup2.
*/

#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>

int main(int argc, char *argv[]) {
	int fd[2];
	pid_t PID;

	pipe(fd); // Llamada al sistema para crear un pipe

	if ( (PID= fork())<0) {
		perror("\Error en fork");
		exit(EXIT_FAILURE);
	}
	if (PID == 0) { // ls
		//Cerrar el descriptor de lectura de cauce en el proceso hijo
		close(fd[0]);

		//Duplicar el descriptor de escritura en cauce en el descriptor
		//correspondiente a la salida estandr (stdout), cerrado previamente en
		//la misma operacion
		dup2(fd[1],STDOUT_FILENO);
		execlp("ls","ls",NULL);
	}
	else { // sort. Proceso padre porque PID != 0.
		//Cerrar el descriptor de escritura en cauce situado en el proceso padre
		close(fd[1]);

		//Duplicar el descriptor de lectura de cauce en el descriptor
		//correspondiente a la entrada est�ndar (stdin), cerrado previamente en
		//la misma operaci�n
		dup2(fd[0],STDIN_FILENO);
		execlp("sort","sort",NULL);
	}

	return EXIT_SUCCESS;
}
```
La única diferencia es el uso de `dup()` vs `dup2()`. Difieren en que dup asigna el descriptor más pequeño disponible; mientras que dup2 te deja elegir el que quieras. Se puede incluso reemplazar uno existente. En este caso, hacemos lo segundo.

## Ejercicio 5
