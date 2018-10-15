## Ejercicio 1
Lo más destacable aquí es que el proceso padre se ejecuta antes que el hijo. Podéis comprobarlo. Por ejemplo, he aquí un log de la terminal:

```
Ahora soy el padre (22406), y el de mi hijo era 22407. Vamos a ver si el número es divisible por 4
4 es divisible por 4
Proceso con pid 22407, y parent 22406. Se comprobará si el número es par o impar
4 es par
```

Código del programa:
```c
#include<sys/types.h>
#include<unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int main(int argc, char const *argv[]){
    if (argc != 2){
        printf("Parámetros: ./ejecutable número\n");
        exit(-1);
    }

    pid_t pid = fork();
    int numero = atoi(argv[1]);

    if (pid < 0){
        printf("No se ha podido crear un fork\n");
        exit(-1);
    }   
    // Proceso hijo
    if (pid == 0){
        printf("Proceso con pid %d, y parent %d. Se comprobará si el número es par o impar\n", getpid(), getppid());


        if (numero % 2 == 0)
            printf("%d es par\n", numero);
        else
            printf("%d es impar\n", numero);
    }
    // Proceso padre
    if (pid){
        printf("Ahora soy el padre (%d), y el de mi hijo era %d. Vamos a ver si el número es divisible por 4\n", getpid(), pid);

        if (numero % 4 == 0)
            printf("%d es divisible por 4\n", numero);
        else
            printf("%d no es divisible por 4\n", numero);
    }

    exit(1);
}
```

## Ejercicio 2
```c
#include<sys/types.h>
#include<unistd.h>		
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int global=6;
char buf[]="cualquier mensaje de salida\n";

int main(int argc, char *argv[]) {
	int var;
	pid_t pid;

	var=88;

	if(write(STDOUT_FILENO,buf,sizeof(buf)+1) != sizeof(buf)+1) {
		perror("\nError en write");
		exit(EXIT_FAILURE);
	}

	//(1)if(setvbuf(stdout,NULL,_IONBF,0)) {
	//	perror("\nError en setvbuf");
	//}

	printf("\nMensaje previo a la ejecución de fork");

	if( (pid=fork())<0){
		perror("\nError en el fork");
		exit(EXIT_FAILURE);
	}
	else if(pid==0){  
		//proceso hijo ejecutando el programa
		global++;
		var++;
	} else  //proceso padre ejecutando el programa
		sleep(1);

	printf("\npid= %d, global= %d, var= %d\n", getpid(),global,var);
	exit(EXIT_SUCCESS);
}
```

`Write()` lo que hace es escribir la cadena de caracteres en la salida estándar
A continuación, crea el proceso hijo con `fork()`. Si no lo consigue alocar, se termina el programa
- Si el pid vale 0, se ejecuta el proceso hijo. Este incrementa dos variables
- Si no, ejecuta el código del padre. Este lo único que hace es esperarse un segundo

Descomentar las líneas de código adyacentes a (1) no tienen ningún efecto en el valor de las variables. Lo único que hace es deshabilitar el buffer de printf a salida estándar?

Los valores de las variables mostrados son diferentes porque son contextos diferentes. Al hacer un fork, se hace una copia de la memoria. En principio, hace falta especificarle que sea capaz de cambiar los valores del padre

Salida con buffer:
```
Mensaje previo a la ejecución de fork
pid= 3154, global= 7, var= 89
Mensaje previo a la ejecución de fork
pid= 3153, global= 6, var= 88
```
Salida sin buffer:
```

Mensaje previo a la ejecución de fork
pid= 3346, global= 7, var= 89

pid= 3345, global= 6, var= 88
```
## Ejercicio 3
Sinceramente, no sé cómo interpretar el output. Si alguien lo sabe, que edite esto.
```c
#include<sys/types.h>
#include<sys/wait.h>
#include<unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int main(){
    int num_procesos = 20;
    pid_t childpid;

    // Jerarquía tipo 1 //
    for (int i=1; i < num_procesos; i++){
        if ( (childpid = fork()) == -1){
            fprintf(stderr, "Could not create child %d: %s\n",i,strerror(errno));
            exit(-1);
        }


        if (childpid){
            printf("Padre: %d, proceso: %d\n", getppid(), getpid());
            break;
        }
    }

    // Jerarquía tipo 2 //
    for (int i=1; i < num_procesos; i++){
        if ( (childpid = fork()) == -1){
            fprintf(stderr, "Could not create child %d: %s\n",i,strerror(errno));
            exit(-1);
        }


        if (!childpid){
            printf("Padre: %d, proceso: %d\n", getppid(), getpid());
            break;
        }
    }
}
```
Es posible que este ejercicio esté mal. Necesita revisión
## Ejercicio 4
Código del programa:

```c
#include<sys/types.h>
#include<unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int main(){
    int i, estado;
    pid_t PID;

    // printf() as soon as posible
    setvbuf(stdout, (char*)NULL, _IONBF, 0);

    // Creación de hijos
    for(i=0; i<5; i++){
         if ((PID = fork()) <0){
            perror("Error en fork \n");
            exit(-1);
        }

        if (PID==0){  //Hijo imprime y muere
            printf("Soy el hijo PID = %i\n", getpid());
            exit(0);
        }
    }

    // Esperamos hijos
    for (i=4; i>=0; i--){
        PID = wait(&estado);
        printf("Ha finalizado el hijo con PID = %i\n", PID);
        printf("Solo me quedan %i hijos vivos\n\n", i);
    }

    exit(0);
}
```
Cuesta ver la lógica del programa, así que analicémosla:
- Los procesos hijos se empiezan a crear. Imprimen una cadena, y se cierran
- Mientras tanto, el segundo bloque for() los vigila. Es decir, `PID = wait()` vigila constantemente el cambio en el estado del proceso. Si alguno termina, entonces, el bucle continúa.

Podemos ver el comportamiento del programa mejor si quitamos el buffer de `printf()`:
```
Soy el hijo PID = 22199
Soy el hijo PID = 22200
Ha finalizado el hijo con PID = 22199
Solo me quedan 4 hijos vivos

Soy el hijo PID = 22201
Ha finalizado el hijo con PID = 22200
Solo me quedan 3 hijos vivos

Soy el hijo PID = 22202
Soy el hijo PID = 22203
Ha finalizado el hijo con PID = 22201
Solo me quedan 2 hijos vivos

Ha finalizado el hijo con PID = 22202
Solo me quedan 1 hijos vivos

Ha finalizado el hijo con PID = 22203
Solo me quedan 0 hijos vivos
```
¿Podéis observar cómo se entremezclan ambos bucles?

## Ejercicio 5
Modificación muy sencilla del anterior:
```c
#include<sys/types.h>
#include<unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int main(){
    int i, estado;
    int hijos_vivos=5;
    pid_t PIDs[5];

    // printf() as soon as posible
    setvbuf(stdout, (char*)NULL, _IONBF, 0);

    // Creación de hijos
    for(i=0; i<5; i++){
         if ((PIDs[i] = fork()) <0){
            perror("Error en fork \n");
            exit(-1);
        }

        if (PIDs[i]==0){  //Hijo imprime y muere
            printf("Soy el hijo PID = %i\n", getpid());
            exit(0);
        }
    }

    // Padre que espera a los pares
    for (i=4; i>=0; i -= 2){
        waitpid(PIDs[i], &estado);

        printf("Ha finalizado el hijo con PID = %i y estado %d\n", PIDs[i], estado);
        printf("Solo me quedan %d hijos vivos\n\n", --hijos_vivos);
    }

    // Padre que espera a los impares
    for (i=3; i>=1; i -= 2){
        waitpid(PIDs[i], &estado);

        printf("Ha finalizado el hijo con PID = %i y estado %d\n", PIDs[i], estado);
        printf("Solo me quedan %d hijos vivos\n\n", --hijos_vivos);
    }

    // Sleep(2) para garantizar que han finalizado las operaciones de salida    
    sleep(2);
    printf("Ya no me quedan hijos :(");

    exit(0);
}
```

Salida de la terminal:
```txt
Soy el hijo PID = 6361
Soy el hijo PID = 6362Soy el hijo PID = 6363
Ha finalizado el hijo con PID = 6364 y estado 32593
Solo me quedan 4 hijos vivos

Ha finalizado el hijo con PID = 6362 y estado 32593
Solo me quedan 3 hijos vivos

Ha finalizado el hijo con PID = 6360 y estado 32593
Solo me quedan 2 hijos vivos

Ha finalizado el hijo con PID = 6363 y estado 32593
Solo me quedan 1 hijos vivos

Ha finalizado el hijo con PID = 6361 y estado 32593
Solo me quedan 0 hijos vivos

Soy el hijo PID = 6364
Soy el hijo PID = 6360
Ya no me quedan hijos :(
```

## Ejercicio 6
Código del programa:
```c
#include<sys/types.h>
#include<sys/wait.h>
#include<unistd.h>
#include<stdio.h>
#include<errno.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
	pid_t pid;
	int estado;

	if( (pid=fork())<0) {
		perror("\nError en el fork");
		exit(EXIT_FAILURE);
	}
	else if(pid==0) {  //proceso hijo ejecutando el programa
		if(execl("/usr/bin/ldd", "ldd", "./tarea5") < 0) {
			perror("\nError en el execl");
			exit(EXIT_FAILURE);
		}
	}

	wait(&estado);
	/*
	<estado> mantiene información codificada a nivel de bit sobre el motivo de finalización del proceso hijo
	que puede ser el número de señal o 0 si alcanzó su finalización normalmente.
	Mediante la variable estado de wait(), el proceso padre recupera el valor especificado por el proceso hijo como argumento de la llamada exit(), pero desplazado 1 byte porque el sistema incluye en el byte menos significativo
	el código de la señal que puede estar asociada a la terminación del hijo. Por eso se utiliza estado>>8
	de forma que obtenemos el valor del argumento del exit() del hijo.
	*/

	printf("\nMi hijo %d ha finalizado con el estado %d\n",pid, estado>>8);

	exit(EXIT_SUCCESS);
}
```
Primero, alojamos un proceso nuevo con `fork()`, como vimos en los ejercicios anteriores. Si hemos conseguido crearlo, ejecutaremos el programa `ldd` con la función `execl()` dentro de C. Para ello, indicamos la ruta donde se encuentra el progama, con la orden y el nombre del ejecutable de nuestro programa. Si no conseguimos que se ejecute, nuestro programa en C se cerrará.
Mientras tanto, `wait()` le echa un ojo a lo que está ocurriendo en el proceso hijo mediante la variable estado. Está bien documentada en el código.

## Ejercicio 7
Código del programa:
```c
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int main(int argc, char const *argv[]){
  bool activar_backg = false;
  pid_t pid;
  char * argumentos[argc];
  int j = 0;

  if (argc == 1){
    printf("Error, se necesitan más argumentos\n");
    exit(0);
  }

  // Comprobamos que el último es la cadena bg
  if (strcmp(argv[argc-1], "bg") == 0)
    activar_backg = true;

  if (activar_backg){
    argumentos[argc-1] = '&';
    argumentos[argc] = NULL;
  }
  else {
    argumentos[argc-1] = NULL;
  }

  if (strcmp(argv[1], "bg")!=0){
    argumentos[0] = argv[1];
  }

  // Copia de parámetros para el ejecutable atendiendo a si nos pasan bg o no
  for (int i=1; i<argc && strcmp(argv[i], "bg")!=0; i++){
    argumentos[j] = argv[i];
    j++;
  }

  argumentos[j] = NULL;

  if ((pid=fork()) < 0){
    perror("\nError en el fork");
    exit(EXIT_FAILURE);
  }
  // Ejecución del hilo. Segundo plano
  else if (activar_backg && pid==0){
    if ((execv(argv[1], argumentos)) < 0){
      perror("\nError en el execl\n");
      exit(EXIT_FAILURE);
    }
  }
  // Ejecución del padre. Primer plano
  else if (!activar_backg && pid!=0){
    if ((execv(argv[1], argumentos)) < 0){
      perror("\nError en el execl\n");
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
```
