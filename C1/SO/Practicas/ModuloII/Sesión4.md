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
### Actividad 4.2 Trabajo con cauces sin nombre
**Ejercicio 2.** Consulte en el manual en línea la llamada al sistema pipe para la creación de cauces sin nombre. Pruebe a ejecutar el siguiente programa que utiliza un cauce sin nombre y describa la función que realiza. **El proceso padre está recibiendo datos del hijo, ya que cierra el descriptor usado para escritura fd[1] y el hijo cierra el despriptor usado para lectura, fd[0].**
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
**Ejercicio 3.** Redirigiendo las entradas y salidas estándares de los procesos a los cauces podemos escribir un programa en lenguaje C que permita comunicar órdenes existentes sin necesidad de reprogramarlas, tal como hace el shell (por ejemplo ls | sort). En particular, ejecute el siguiente programa que ilustra la comunicación entre proceso padre e hijo a través de un cauce sin nombre redirigiendo la entrada estándar y la salida estándar del padre y el hijo respectivamente.**Ejecutamos(`./tarea7`) tras haber compilado y enlazado con `gcc tarea7.c -o tarea7` y vemos como en efecto resulta lo mismo que al poner `ls|sort`**
~~~c
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
~~~
**Ejercicio 4.** Compare el siguiente programa con el anterior y ejecútelo. Describa la principal diferencia, si existe, tanto en su código como en el resultado de la ejecución.**Al ejecutar el programa resulta lo mismo que el anterior, la única diferencia es que en vez de usar `close(STDOUT_FILENO)` o `close(STDIN_FILENO)` emplea `dup2(fd[1], STDOUT_FILENO)` o `dup2(fd[1], STDIN_FILENO)` respectivamente, pero es que son equivalentes ambas cosas; la cabecera de dup2 es `int dup2(int oldfd, int newfd)`, crea una copia de oldfd usando el número especificado en newfd. Si newfd había sido abierto con anterioridad, se cierra antes de volver a ser usado. Por otro lado, close() cierra un descriptor de archivo, de manera que no se refiera a ningún archivo y pueda volver a ser usado.**
~~~c
/*
tarea8.c
Programa ilustrativo del uso de pipes y la redirección de entrada y
salida estándar: "ls | sort", utilizando la llamada dup2.
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
    perror("\Error en fork");
    exit(-1);
  }

  if (PID == 0) { // ls
    //Cerrar el descriptor de lectura de cauce en el proceso hijo
    close(fd[0]);
    //Duplicar el descriptor de escritura en cauce en el descriptor
    //correspondiente a la salida estándar (stdout), cerrado previamente en
    //la misma operación
    dup2(fd[1],STDOUT_FILENO);
    execlp("ls","ls",NULL);
  }
  else { // sort. Proceso padre porque PID != 0.
    //Cerrar el descriptor de escritura en cauce situado en el proceso padre
    close(fd[1]);
    //Duplicar el descriptor de lectura de cauce en el descriptor
    //correspondiente a la entrada estándar (stdin), cerrado previamente en
    //la misma operación
    dup2(fd[0],STDIN_FILENO);
    execlp("sort","sort",NULL);
  }
  return(0);
}
~~~
**Ejercicio 5.** Este ejercicio se basa en la idea de utilizar varios procesos para realizar partes de una computación en paralelo. Para ello, deberá construir un programa que siga el esquema de computación maestro-esclavo, en el cual existen varios procesos trabajadores (esclavos) idénticos y un único proceso que reparte trabajo y reúne resultados (maestro). Cada esclavo es capaz de realizar una computación que le asigne el maestro y enviar a este último los resultados para que sean mostrados en pantalla por el maestro.
El ejercicio concreto a programar consistirá en el cálculo de los números primos que hay en un intervalo. Será necesario construir dos programas, maestro y esclavo. Ten en cuenta la siguiente especificación:
1. El intervalo de números naturales donde calcular los número primos se pasará como argumento al programa maestro. El maestro creará dos procesos esclavos y dividirá el intervalo en dos subintervalos de igual tamaño pasando cada subintervalo como argumento a cada programa esclavo. Por ejemplo, si al maestro le proporcionamos el intervalo entre 1000 y 2000, entonces un esclavo debe calcular y devolver los números primos comprendidos en el subintervalo entre 1000 y 1500, y el otro esclavo entre 1501 y 2000. El maestro creará dos cauces sin nombre y se encargará de su redirección para comunicarse con los procesos esclavos. El maestro irá recibiendo y mostrando en pantalla (también uno a uno) los números primos calculados por los esclavos en orden
creciente.
2. El programa esclavo tiene como argumentos el extremo inferior y superior del intervalo sobre el que buscará números primos. Para identificar un número primo utiliza el siguiente método concreto: un número n es primo si no es divisible por ningún k tal que 2 < k <= sqrt(n), donde sqrt corresponde a la función de cálculo de la raíz cuadrada. El esclavo envía al maestro cada primo
encontrado como un dato entero (4 bytes) que escribe en la salida estándar, la cuál se tiene que encontrar redireccionada a un cauce sin nombre. Los dos cauces sin nombre necesarios, cada uno para comunicar cada esclavo con el maestro, los creará el maestro inicialmente. Una vez que un esclavo haya calculado y enviado (uno a uno) al maestro todos los primos en su correspondiente intervalo terminará.**Compilamos y enlazamos uno a uno los programas: `gcc maestro.c -o maestro`, luego `gcc esclavo.c -o esclavo -lm` (se pone -lm para resolver referencias a la función sqrt incluida en math.h). He revisado mis programas y devuelven bien los primos, pero meten basura y no sé como solucionarlo. Aparte de eso creo que están correctos.**

~~~c
//maestro.c

#include <stdio.h>  //fprintf() y printf()
#include <unistd.h> //pipe(), exec()
#include <stdlib.h> //atoi(), exit()
#include <errno.h>  //perror()

int main(int argc, char *argv[]){
  int start= atoi(argv[1]), end= atoi(argv[2]);
  pid_t child_process_1, child_process_2;
  int fd_1[2], fd_2[2];
  char middle_char_1[10], middle_char_2[10];

  if(argc != 3 || start > end){
    fprintf(stderr, "%s\n","Modo de ejecución: ./ejer5 número_natural_1 número_natural_2, con el primero menor o igual que el segundo" );
    exit(EXIT_FAILURE);
  }

  //Creamos los pipes correspondientes
  if(pipe(fd_1) == -1){
    perror("Error en el primer pipe ");
    exit(EXIT_FAILURE);
  }

  if(pipe(fd_2) == -1){
    perror("Error en el segundo pipe ");
    exit(EXIT_FAILURE);
  }

  //Creamos el primer proceso hijo
  if((child_process_1= fork()) == -1){
    perror("Error en el primer fork");
    exit(EXIT_FAILURE);
  }

  //Dividimos el intervalo pasado como argumento en dos, guardando el valor medio en la siguiente variable:
  int middle_1= (start + end)/2 -1;
  int middle_2= middle_1 +1;

  //Redireccionamos la salida estándar a un cauce sin nombre para los dos procesos hijo
  if (child_process_1 == 0) {
    //Cerramos el descriptor de lectura de cauce en el proceso hijo 1
    close(fd_1[0]);

    /*Duplicamos el descriptor de escritura en cauce en el descriptor correspondiente
    a la salida estándar (stdout), cerrado previamente.*/
    dup2(fd_1[1],STDOUT_FILENO);

    //Convertimos int middle a char middle_[], tipo que acepta execl como argumento
    snprintf(middle_char_1, sizeof(int), "%d", middle_1);

    if(execl("./esclavo", "esclavo", argv[1], middle_char_1, NULL) == -1){
      perror("\nError en el primer execl");
      exit(EXIT_FAILURE);
    }
  }

  //Creamos el segundo proceso hijo y procedemos de manera análoga al anterior
  if((child_process_2= fork()) == -1){
    perror("Error en el segundo fork");
    exit(EXIT_FAILURE);
  }

  //Realizamos lo mismo para el proceso hijo 2
  if (child_process_2 == 0) { //Parte ejecutada por el hijo
    //Cerramos el descriptor de lectura de cauce
    close(fd_2[0]);

    /*Duplicamos el descriptor de escritura en cauce en el descriptor correspondiente
    a la salida estándar (stdout).*/
    dup2(fd_2[1], STDOUT_FILENO);

    //Convertimos int middle a char middle_[], tipo que acepta execl como argumento
    snprintf(middle_char_2, sizeof(int), "%d", middle_2);

    if(execl("./esclavo","esclavo", middle_char_2, argv[2], NULL) == -1){
      perror("\nError en el segundo execl");
      exit(EXIT_FAILURE);
    }
  }

  else { //Parte ejecutada por el padre al ser child_process_1 != 0
    //Cerramos el descriptor de escritura en cauce situado en el proceso padre
    close(fd_1[1]);
    close(fd_2[1]);

    int bytes_1, bytes_2, primes_1, primes_2;

    printf("\nPrimos del primer proceso hijo: \n");
    while(bytes_1 = read(fd_1[0], &primes_1, sizeof(int)) > 0)
      printf("%d\n", primes_1);

    printf("\nPrimos del segundo proceso hijo: \n");
    while(bytes_2 = read(fd_2[0], &primes_2, sizeof(int)) > 0)
      printf("%d\n", primes_2);

  }

  //return(EXIT_SUCCESS);
}
~~~
~~~c
//esclavo.c

#include <stdio.h>  //familia de funciones printf()
#include <stdlib.h> //exit(), atoi
#include <math.h>   //necesita -lm al enlazar
#include <unistd.h> //write()

//Devuelve 0 si el número no es primo, 1 si sí lo es
int is_prime(int number){
  //Si el número tiene algún divisor en el intervalo [2,sqrt(number)] no es primo
  for(int i= 2; i<= sqrt(number); i++){
    if(number % i == 0)
      return 0;
  }
  return 1;
}
int main(int argc, char *argv[]){
  if(argc != 3 || argv[1] > argv[2]){
    fprintf(stderr, "%s\n","Modo de ejecución: ./ejer5 número_natural_1 número_natural_2, con el primero menor o igual que el segundo" );
    exit(EXIT_FAILURE);
  }

  int start= atoi(argv[1]);
  int end= atoi(argv[2]);
  //Recorremos el intervalo pasado como argumento buscando los primos que contiene
  for(int i= start; i< end; i++){
    /*Enviamos cada primo encontrado al maestro como un entero que escribe en
    la salida estándar, la cual se encuentra ya redireccionada a un cauce sin nombre,
    creado por el maestro.*/
    if(is_prime(i)){
      printf("\nEl número %d es primo\n", i);
      write(STDOUT_FILENO, &i, sizeof(int));
    }
  }
  exit(0);
}
~~~
### Extra
> **Creación de cauces**
Para crear un cauce sin nombre en el lenguaje C utilizaremos la llamada al sistema pipe, la cual toma como argumento un vector de dos enteros int fd[2]. Si la llamada tiene éxito, el vector contendrá dos nuevos descriptores de archivo que permitirán usar el nuevo cauce. Por defecto, se suele tomar el primer elemento del vector (fd[0]) como un descriptor de archivo para sólo lectura, mientras que el segundo elemento (fd[1]) se toma para escritura.
Una vez creado el cauce, creamos un proceso hijo (que heredará los descriptores de archivos del padre) y establecemos el sentido del flujo de datos (hijo->padre o padre->hijo).
Como los descriptores son compartidos por el proceso padre y el hijo, debemos estar seguros siempre de cerrar con close el extremo del cauce que no nos interese en cada uno de los procesos, para evitar confusiones que podrían derivar en errores al usar el mecanismo. Si el **padre** quiere **recibir datos** del hijo, debe **cerrar** el descriptor usado para escritura **(fd[1])** y el **hijo** debe **cerrar** el descriptor usado para lectura **(fd[0])**. Si por el contrario el **padre** quiere **enviarle datos** al hijo, debe **cerrar** el descriptor usado para lectura **(fd[0])** y el **hijo** debe cerrar el descriptor usado para escritura **(fd[1])**.
Si deseamos conseguir **redireccionar** la entrada o salida estándar al descriptor de lectura o escritura del cauce podemos hacer uso de las llamadas al sistema **close, dup y dup2**

#### Notas sobre cauces con y sin nombre
Aspectos adicionales a tener en cuenta cuando se utilizan cauces:
+ Se puede crear un método de comunicación dúplex entre dos procesos abriendo dos cauces.
+ pipe debe realizarse siempre antes que fork. Si no, el proceso hijo no heredará los descriptores del cauce.
+ Un cauce sin nombre o un archivo FIFO tienen que estar abiertos simultáneamente por ambos extremos para permitir la lectura/escritura. Se pueden producir las siguientes situaciones a la hora de utilizar un cauce:

  + El primer proceso que abre el cauce (en modo sólo lectura) es el proceso lector. Entonces, la llamada open bloquea a dicho proceso hasta que algún proceso abra dicho cauce para escribir.
  + El primer proceso que abre el cauce (en modo sólo escritura) es el proceso escritor. En este caso, la llamada al sistema open no bloquea al proceso, pero cada vez que se realiza una operación de escritura sin que existan procesos lectores, el sistema envía al proceso escritor una señal SIGPIPE. El proceso escritor debe manejar la señal si no quiere finalizar (acción por defecto de la señal SIGPIPE).
  + La sincronización entre procesos productores y consumidores es atómica.

#### Example using pipe
The following program creates a pipe, and then  fork(2)s  to create  a  child process; the child inherits a duplicate set of file descriptors that refer to the same pipe.  After  the fork(2), each process closes the descriptors that it doesn't need for the pipe (see pipe(7)).  The parent then writes the string  contained  in the program's command-line argument to the pipe, and the child reads this string a byte at  a  time from the pipe and echoes it on standard output.

Program source:
~~~c
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[]){
 int pipefd[2];
 pid_t cpid;
 char buf;

 if (argc != 2) {
     fprintf(stderr, "Usage: %s <string>\n", argv[0]);
     exit(EXIT_FAILURE);
 }

 if (pipe(pipefd) == -1) {
     perror("pipe");
     exit(EXIT_FAILURE);
 }

 cpid = fork();
 if (cpid == -1) {
     perror("fork");
     exit(EXIT_FAILURE);
     }

     if (cpid == 0) {    /* Child reads from pipe */
         close(pipefd[1]);          /* Close unused write end */

         while (read(pipefd[0], &buf, 1) > 0)
             write(STDOUT_FILENO, &buf, 1);

         write(STDOUT_FILENO, "\n", 1);
         close(pipefd[0]);
         _exit(EXIT_SUCCESS);

     } else {            /* Parent writes argv[1] to pipe */
         close(pipefd[0]);          /* Close unused read end */
         write(pipefd[1], argv[1], strlen(argv[1]));
         close(pipefd[1]);          /* Reader will see EOF */
         wait(NULL);                /* Wait for child */
         exit(EXIT_SUCCESS);
     }
 }
~~~
