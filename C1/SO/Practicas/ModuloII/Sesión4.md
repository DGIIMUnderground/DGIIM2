## Sesión 4. Comunicación entre procesos utilizando cauces
### Actividad 4.1 Trabajo con cauces con nombre
**Ejercicio 1.** Consulte en el manual las llamadas al sistema para la creación de archivos especiales en general (mknod) y la específica para archivos FIFO (mkfifo). Pruebe a ejecutar el siguiente código correspondiente a dos programas que modelan el problema del productor/consumidor, los cuales utilizan como mecanismo de comunicación un cauce FIFO.
Determine en qué orden y manera se han de ejecutar los dos programas para su correcto funcionamiento y cómo queda reflejado en el sistema que estamos utilizando un cauce FIFO. **No estoy muy segura, pero primero ha de ejecutarse el consumidorFIFO, escribiendo desde la terminal `gcc consumidorFIFO.c -o consumidorFIFO`, luego `gcc productorFIFO.c -o productorFIFO`, y ejecutando `./consumidorFIFO` se queda como en bucle infinito. Abrimos entonces otra terminal y ejecutamos `./productorFIFO mensaje` tantas veces como queramos hasta poner `./productorFIFO fin`, y vemos como en la terminal en la que tenemos el consumidor FIFO van apareciendo los mensajes, y con fin se cierra el cauce. En los otros archivos escribe cosas raras.**
~~~c
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
/* ======================== * ========================= */
El código de cualquier proceso productor quedaría de la siguiente forma:
/* ======================== * ========================= */
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
~~~
