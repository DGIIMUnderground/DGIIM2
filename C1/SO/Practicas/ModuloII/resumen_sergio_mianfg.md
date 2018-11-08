# Apuntes útiles para programación en C

## Control de errores

Lo más cómodo es usar la variable `errno` de la librería `errno.h` y usar la siguiente función de forma recurrente:

~~~c
#include <errno.h>
#include <stdio.h>	// Para hacer perror

/**
 * @brief controla el error, y en caso de ocurrir muestra un mensaje y hace exit con el codigo especificado
 * @param errcode el código de error, la mayoria de veces errno
 * @param errmsg el mensaje que se muestra en caso de ocurrir error
 * @param exitcode el valor de exit, por defecto su valor es 1
*/
void err_check(int errcode, char errmsg[]){
	if(errcode != 0){
		perror(errmsg);
		exit(EXIT_FAILURE);
	}	
}

int main(){
	extern int errno;

	// Algunas operaciones sobre archivos
	err_check(errno, "Error abriendo archivos de entrada");
}
~~~

## Uso de `string`

* Es casi obligado importar la librería `string.h`
* Se puede formatear strings en variables como se hace con `printf` usando `sprintf`
* Al ejecutar `strlen(texto_formateado)` nos devuelve el tamaño real del texto, no el que declaramos en el array

~~~c++
#include <string.h>

int main(){
	char texto[200];
	
	sprintf(texto, "Linea %iº", indx);
	int real_len = strlen(texto);		// Vale el tamaño real, no 200
}
~~~

## Uso de archivos

* `int file_descriptor = open(file_path, flags)`
* `close(file_descriptor)`
* `int bytes_wrote = write(file_descriptor, string, len_string)`
* `int bytes_read = read(file_descriptor, string_buff, bytes_to_read)`
* `lseek(file_descriptor, offset, offset_mode = SEEK_SET)`
* *File_descriptors* estándar definidos en `unistd.h`:
	* `STDIN_FILENO`
	* `STDOUT_FILENO`
	* `STDERR_FILENO`
* En `stdio.h` se definen tres *stream* para poder trabajar cómodamente con ellos:
	* stdin
	* stdout 
	* stderr
* Notar que no es lo mismo trabajar con descriptores de archivos (que son un entero) que con flujos de archivos, que son punteros a un *stream*

## Identificadores de procesos

* `getuid()`: devuelve el usuario del proceso
* `geteuid()`: devuelve el usuario efectivo del proceso
* `getgid()`: devuelve el grupo del proceso
* `getegid()`: devuelve el grupo efectivo del proceso
* `getpid()`: devuelve el id del proceso en el que se invoca (id de nuestro programa en `c`) 
* `getppid()`: devuelve el id del proceso padre que lo invoca (id del padre)

## Mecanismos de creacion de subprocesos

* `fork()`: devuelve 0 al hijo y el pid del hijo al padre, -1 en caso de error y se establece la variable `errno` apropiada
* `int exec(archivo, argumentos)`: ejecuta el archivo *archivo* con el mismo `pid` del programa que invoca a `exec`. Se deben pasar argumentos, el primero el nombre del ejecutable, el último un `(char *) NULL`
	* Las funciones obtienen el `enviroment` de la varialbe `extern char **environ`, con la excepción de `execle`
	* Si se niega el acceso al archivo, se busca el archivo en modo `shell`. Si no se encuentra, devuelve `EACCES` en `errno`
	* Si no se reconoce la cabecera de un archivo estas funciones ejecutarán el shell con el camino del archivo como su primer argumento.
	* La función solamente retorna en caso de error con el valor de `-1` y establece `errno`
	* Variaciones de la llamada al sistema:
		* `int execl(const char *path, const char *arg, ...);`:
		* `int execlp (const char *file, const char *arg, ...);`: si la ruta no es absoluta/relativa, busca el programa `shell`
		* `int execle(const char *path, const char *arg , ..., char * const envp[]);`: especifica además el entorno del proceso que ejecutará en programa con el argumento que va detrás de `NULL`, es un vector de cadenas C terminado con `NULL`
		* `int execv(const char *path, char *const argv[]);`:
		* `int execvp(const char *file, char *const argv[]);`: si la ruta no es absoluta/relativa, busca el programa `shell`
	* Ejemplo: `execl("./programas/programa5", "programa5", "arg1", "arg2", NULL)`
* `int clone(int (*fn)(void *), void *child_stack, int flags, void *arg, .../* pid_t *ptid, void *newtls, pid_t *ctid */ )`
	* Bastante similar a `fork()`
	* Se crea un nuevo proceso hijo que comienza ejecutando la funcion pasada como argumento
	* El hijo finaliza cuando se haga un `exit()` o la anterior función retorne
	* `child_stack` es un puntero a una pila que previamente hemos reservado para que la use el hijo
	* Se pueden pasar `flags` que vienen resumidos en una tabla en la página 103 de los apuntes, algunos ejemplos:
		* `CLONE_VM|CLONE_FILES|CLONE_FS|CLONE_THREAD|CLONE_SIGHAND` sirve para crear un hilo

## Mecanismos de sincronizacion

* `wait()`: hace que el proceso padre espere hasta que uno de sus hijos termine
	* Valor de retornado;
		* Exito: el valor del pid terminado
		* Error: -1 y establece el valor `errno`
* `waitpid(pid_t childp, &wstauts, OPTIONS)`: espera a que `chilpd` cambie de estado (termine o reciba una señal de bloqueo)
	* Valores de `childpid`:
		* Un valor positivo: se espera a ese `pid` en concreto
		* Valor menor que -1: espera a cualquier hijo con el mismo *groupid* igual al valor absoluto del pid
		* Valor igual a -1: espera a cualquier hijo
		* Valor igual a 0: espera a cualquier hijo con groupid igual al pid del proceso que se está ejecutando
	* Valores de `&wstatus`:
		* Si es `NULL`: no se guardan valores del estado de salida del hijo
		* Si no es `NULL`: se guardan valores del estado de salida del hijo, que se pueden tomar con:
			* `WIFEXITED(wstatus)`: `true` si el hijo termina de forma normal
			* ` WEXITSTATUS(wstatus)`: `true` si el hijo termina por la llegada de una señal
			* Listado completo en `man 2 wait`
	* Valores de `OPTIONS`:
		* `WNOHANG`: return immediately if no child has exited.
       		* `WUNTRACED`: also  return  if  a child has stopped
       		* `WCONTINUED`: also return if a stopped child has been resumed by delivery of SIGCONT.
		* `0`: no tiene nada de esto en cuenta
	* Valor retornado
		* Exito: el valor `pid` del proceso cuyo estado ha cambiado
		* Error: -1 y se establece el `errno`
* `exit(exit_code)`: se envia la señal `SIGCHLD` al padre y se le pasa como parametro `exit_code` si está haciendo un `wait`

## Miscelánea

* `int setvbuf(FILE *stream, char *buf, int mode , size_t size)`: para desactivar el buffer de *stream*, mirar los modos con `man 2 setvbuf`
	* ` setvbuf(stdout, (char*)NULL, _IONBF, 0);`: desactiva el buffer para el *printf*
* `exit(EXIT_FAILURE)`
* `exit(EXIT_SUCCESS)`

## Manejo de cauces

* `pipe`: crea un cauce sin nombre
	* Devuelve dos descriptores, uno de lectura y otro de escritura, luego no hay que hacer `open` para escribir en el cauce
	* Se gestiona automáticamente por el kernel
	* Solo puede usar por el padre y los hijos que se crean a partir del cauce
		* La llamada al sistema pipe debe realizarse siempre antes que la llamada fork. Si no, el proceso hijo no heredará los descriptores del cauce
		* Un proceso escritor que escriba en el cauce sin que haya procesos consumidores recibirá la señan `SIGPIPE`
	* `pipe(int fd[2])`
		* `fd[0]`: contiene el descriptor para lectura
		* `fd[1]`: contiene el descriptor para escritura
	* Filosofía de uso:
		* Creamos el cauce con `pipe`
		* Creamos un hijo
		* Hijo y padre cierran el `fd` de salida o entrada según el flujo de datos que elijamos
		* Podemos usar `dup` para enlazar un descriptor de archivo con otro, o con la SALIDA/ENTRADA estándar
* `int dup3(int oldfd, int newfd, int flags)`:
	* Contecta *oldfd* a *newfd* según los flags
* `mknod` y `mkfifo`:
	* Crea un cauce con nombre
	* Se puede leer y escribir sobre el con `read` y `write` teniendo en cuenta que son `FIFO` por lo que no se puede hacer `lseek`
	* No se cierra el cauce hasta que se llama explícitamente con `unlink`
	* Abrir un archivo FIFO en escritura sin que haya datos ni un proceso que escriba en el FIFO hace que el proceso lector se bloquee
	* `int mknod (const char *FILENAME, mode_t MODE, dev_t DEV)`
	* Modos:
		* S_IFCHR: representa el valor del código de tipo de archivo para un archivo de dispositivo orientado a caracteres.
		* S_IFBLK: representa el valor del código de tipo de archivo para un archivo de dispositivo orientado a bloques.
		* S_IFSOCK: representa el valor del código de tipo de archivo para un socket.
		* S_IFIFO: representa el valor del código de tipo de archivo para un FIFO .
	* El argumento DEV especifica a qué dispositivo se refiere el archivo especial. Su interpretación
		* `mknod("/tmp/FIFO", S_IFIFO|0666,0);` crea un cauce FIFO, los permisos solicitados son `S_IFIFO|0666 & ~umask`
		* `mknod()` permite crear cualquier tipo de archivo especial, pero para FIFO existe una llamada específica del sistema
		* `mkfifo(const char *FILENAME, mode_t MODE)`
	* La llamada `read` bloque al consumidor cuando no hay datos que leer en el cauce
		* `read` desbloquea devolviendo 0 cuando todos los productores cierran el cauce
		* `read` desbloquea devolviendo un valor positivo cuando se ha escrito en el cauce

## Manejo de señales

* Puede consultarse la tabla de señales con `man 7 signal`
* Según el valor del campo `action` se comporta como se describe:
	* `Term` : La acción por defecto es terminar el proceso.
	* `Ign`	 : La acción por defecto es ignorar la señal.
	* `Core` : La acción por defecto es terminar el proceso y realizar un volcado de memoria.
	* `Stop` : La acción por defecto es detener el proceso.
	* `Cont` : La acción por defecto es que el proceso continúe su ejecución si está parado.
* Llamadas al sistema principales:
	* int kill(pid_t pid, int sig)`: envia una señal a un proceso o conjunto de señales
		* Pid positivo: se envia la señal al pid especificado. Devuelve 0 con éxito, valor negativo con error
		* Pid cero: se envia la señal a cada proceso en el grupo de procesos actual.
		* Pid igual a -1: se envia la señal a cada proceso, expeto el primero, desde los números más altos en la tabla de procesos
		* Pid menor que -1: se envia la señal a los procesos del grupo de -pid (-4 envio la señal a los del grupo del pid 4)
		* Si sig es cero: no se envia niguna señal, se realiza la comprobación de errores
	* `int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)`: establece la acción a realizar según la llegada de la señal
		* `SIGKILL` y `SIGSTOP` no pueden cambiar su acción por defecto
		* `signum` especifica la señal y puede ser cualquier señal válida salvo SIGKILL o SIGSTOP, como ya hemos comentado
		* Si `act` no es NULL, la nueva acción para la señal signum se instala como act.
		* Si `oldact` no es NULL, la acción anterior se guarda en oldact.
		* Valor de retorno: 0 en caso de éxito y -1 en caso de error
	* `sigprocmask`: se emplea para cambiar la lista de señales bloqueadas actualmente.
	* `sigpending`: permite el examen de señales pendientes 
	* `sigsuspend`: reemplaza temporalmente la máscara de señal para el proceso con la dada por el argumento mask y luego suspende el proceso hasta que se recibe una señal.
* Estructura de datos 

~~~c
struct sigaction {
	void (*sa_handler)(int);
	void (*sa_sigaction)(int, siginfo_t *, void *);
	sigset_t sa_mask;
	int sa_flags;
	void (*sa_restorer)(void);
}
~~~
