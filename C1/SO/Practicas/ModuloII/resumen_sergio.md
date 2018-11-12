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

* `int file_descriptor = open(file_path, flags, mode_t mode)`
* Algunas flags importantes para la orden `open`
	* O_APPEND: añade los datos al final de archivo
	* O_ASYNC: permite el modo de escritura mediante señales
	* O_SYNC: permite escribir de forma sincronizada
	* O_TRUNC: si ya existe el archivo, se borran los datos para escribir desde cero
	* O_CREAT: si no existe el archivo se crea
* Algunos modos importantes para `open`
	* S_IRWXU  00700 user (file owner) has read, write, and execute permission
	* S_IRUSR  00400 user has read permission
	* S_IWUSR  00200 user has write permission
	* S_IXUSR  00100 user has execute permission
	* S_IRWXG  00070 group has read, write, and execute permission
	* S_IRGRP  00040 group has read permission
	* S_IWGRP  00020 group has write permission
	* S_IXGRP  00010 group has execute permission
	* S_IRWXO  00007 others have read, write, and execute permission
	* S_IROTH  00004 others have read permission
	* S_IWOTH  00002 others have write permission
	* S_IXOTH  00001 others have execute permission
	* S_ISUID  0004000 set-user-ID bit
	* S_ISGID  0002000 set-group-ID bit (see inode(7)).
	* S_ISVTX  0001000 sticky bit (see inode(7)).
* Algunos modos importantes para `open` en octal. Útiles para hacer comparaciones:
	* usuario | grupo | otros
	* Permiso r________	0400
	* Permiso r__r_____	0440
	* Permiso r__r__r__	0444
	* Permiso rw_______	0600
	* Permiso rw_r_____	0640
	* Permiso rw_r__r__	0644
	* Permiso rw_rw_r__	0664
	* Permiso rw_rw_rw_	0666
	* Permiso _w_______	0200
	* Permiso _w__w____	0220
	* Permiso _w__w__w_	0222
	* Permiso r_x______	0500
	* Permiso r_xr_x___	0550
	* Permiso r_xr_xr_x	0555
	* Permiso rwx______	0700
	* Permiso rwxr_x___	0750
	* Permiso rwxr_xr_x	0755
	* Permiso rwxrwxr_x	0775
	* Permiso rwxrwxrwx	0777
	* Permiso _wx______	0300
	* Permiso _wx_wx___	0330
	* Permiso _wx_wx_wx	0333
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
* `mode_t umask(mode_t mask)`
	* umask establece la máscara de usuario a `mask & 0777`
	* Devuelve el anterior valor de la máscara (siempre tiene éxito)
	* La máscara de usuario es usada por open para establecer los permisos iniciales del archivo que se va a crear. 
	* Los permisos presentes en la máscara se desactivan del argumento mode de open (*por ejemplo, si creamos un archivo con mode= 0666 y umask=022, este archivo se creará con 0666 & ~022 = 0644 = rw-r--r--*)
* Cambiar los permisos de un arhivo
	* `int chmod(const char *path, mode_t mode);`
	* `int fchmod(int fdescripor, mode_t mode);`
	* La tabla de macros de mode_t que se pueden combinar usando `or` aparece en `man 2 chmod`
	* En caso de éxito, devuelve 0. En caso de error, -1 y se asigna a la variable errno un valor adecuado.
* Cambiar el tamaño de un archivo:
	* `int ftruncate(int filedescriptor, off_t lenght)`
	* El archivo (que debe ser regular) ocupa ahora `lenght`
	* Devuelve 0 en caso de exito y -1 en fallo (establece `errno` a un flag dependiendo del caso)

## Manejo de directorios en `UNIX`

* `int stat(const char *pathname, struct stat *statbuf);`
* `int fstat(int fd, struct stat *statbuf);`
	* Devuelve una estructura `stat` para poder tomar informacion
* Macros para comprobar el tipo de un archivo, tras haber hecho `struct stat metadatos; stat(filepath, &metadatos)`
	* S_ISLNK(st_mode) Verdadero si es un enlace simbólico (soft)
	* S_ISREG(st_mode) Verdadero si es un archivo regular
	* S_ISDIR(st_mode) Verdadero si es un directorio
	* S_ISCHR(st_mode) Verdadero si es un dispositivo de caracteres
	* S_ISBLK(st_mode) Verdadero si es un dispositivo de bloques
	* S_ISFIFO(st_mode) Verdadero si es una cauce con nombre (FIFO)
	* S_ISSOCK(st_mode) Verdadero si es un socket
* `opendir`: se le pasa el pathname del directorio a abrir, y devuelve un puntero a la estructura de tipo DIR, llamada stream de directorio. El tipo DIR está definido en <dirent.h>.
* `readdir`: lee un puntero a structura DIR.
	* Devuelve la entrada leída a través de una estructura DIR, `NULL` si se ha llegado al final
	* Adelanta en una posición el puntero
	* Puede darse errores
* `closedir`: cierra un directorio, devolviendo 0 si tiene éxito, en caso contrario devuelve -1.
* `seekdir`: permite situar el puntero de lectura de un directorio (se tiene que usar en
combinación con telldir).
* `telldir`: devuelve la posición del puntero de lectura de un directorio.
* `rewinddir`: posiciona el puntero de lectura al principio del directorio.
* `nftw`: permite recorrer recursivamente un subárbol del sistema de archivos
	* `int nftw(const char * dirpath, int (*func)(const char *pathname, const struct stat *statbuf, int typeflag, struct FTW *ftwbuf), int nopenfd, int flags)`
	* Recorre los archivos indicados por `*dirpath`
	* Aplica la función `*func` para cada archivo del árbol
	* Por defecto, se hace un recorrido preorden no ordenado del árbol
	* `nopenfd`: indica el número máximo de descriptores que la función puede abrir
	* `flags` es un `or` de las constantes definidas en la tabla que aparece en `man nftw`

~~~c
DIR *opendir(char *dirname);
struct dirent *readdir(DIR *dirp);
int closedir(DIR *dirp);
void seekdir(DIR *dirp, log loc);
long telldir(DIR *dirp);
void rewinddir(DIR *dirp);

typedef struct _dirdesc {
	int dd_fd;
	long dd_loc;
	long dd_size;
	long dd_bbase;
	long dd_entno;
	long dd_bsize;
	char *dd_buf;
} DIR;

struct dirent {
	long d_ino; /* número i-nodo */
	char d_name[256]; /* nombre del archivo */
};
~~~

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
		* Un proceso escritor que escriba en el cauce sin que haya procesos consumidores recibirá la señan `SIGPIPE`: se debe crear un manejador para esta señal si se quiere que esta señal no provoque la finalización del proceso
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
	* Por ejemplo, para que lo que salga por la salida estandar se guarde en un archivo: `dup2(file,STDOUT_FILENO)`
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
* También puede consultarse con `kill -l`
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
	* `sigprocmask(int how, const sigset_t *set, sigset_t *oldset)`:
		* Se emplea para cambiar la lista de señales bloqueadas actualmente.
		* `how`: indica el tipo de cambio. Los valores que puede tomar son:
			* `SIG_BLOCK`: el conjunto de señales bloqueadas es la unión del conjunto actual y el argumento `set`
			* `SIG_UNBLOCK`: Las señales que hay en set se eliminan del conjunto actual de señales bloqueadas
			* `SIG_SETMASK`: El conjunto de señales bloqueadas se pone según el argumento set.
		* `set`: representa el puntero al nuevo conjunto de señales enmascaradas. set apunta a un conjunto de señales
		* `oldset` representa el conjunto anterior de señales enmascaradas. Si oldset no es NULL, el valor anterior de la máscara de señal se guarda en oldset
		* Retorna 0 en caso de éxito y -1 en caso de error
	* `int sigpending(sigset_t *set)`: permite el examen de señales pendientes 
		* Se guarda en `set` el conjunto de señales pendientes
		* Devuelve 0 en caso de éxito y 1 en caso de error
	* `sigsuspend(const sigset_t *mask)`: reemplaza temporalmente la máscara de señal para el proceso con la dada por el argumento mask y luego suspende el proceso hasta que se recibe una señal.
		* `mask`: representa el puntero al nuevo conjunto de señales enmascaradas
		* Retorna 0 en caso de éxito y -1 si sigsuspend es interrumpida por una señal capturada
* Es util conocer estas dos macros:
	* `LONG_MIN` y `LONG_MAX` controlan el menor y mayor valor de los `pid` del sistema
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

* Pequeña explicación de filosofía de uso:

~~~c

void myhandler(int signum){
	printf("Me ha llegado la señal %i\n", signum);
}
int main(){
	struct sigaction micontrolador;
	micontrolador.sa_handler = myhandler;	// Uso mi manejador que imprime mensajes por pantalla
	micontrolador.sa_flags = SA_RESTART;	// Reinicia las funciones interrumpidas por mi manejador

	if(sigaction(SIGINT, &micontrolador, NULL) == -1){
		printf("Error usando mi manejador de señales\n");
	}

	// Espera siempre
	while(1);
}
~~~

* Ejemplo que he encontrado en [stackoverflow](https://unix.stackexchange.com/questions/80044/how-signals-work-internally) bastante útil

~~~c
#include<signal.h>
#include<stdio.h>

/* Handler function */
void handler(int sig) {
    printf("Receive signal: %u\n", sig);
};

int main(void) {
    struct sigaction sig_a;

    /* Initialize the signal handler structure */
    sig_a.sa_handler = handler;
    sigemptyset(&sig_a.sa_mask);
    sig_a.sa_flags = 0;

    /* Assign a new handler function to the SIGINT signal */
    sigaction(SIGINT, &sig_a, NULL);

    /* Block and wait until a signal arrives */
    while (1) {
            sigsuspend(&sig_a.sa_mask);
            printf("loop\n");
    }
    return 0;
};
~~~

* Notas finales
	* No es posible bloquear SIGKILL, ni SIGSTOP, con una llamada a sigprocmask. 
	* De acuerdo con POSIX, el comportamiento de un proceso está indefinido después de que no haga caso de una señal SIGFPE, SIGILL o SIGSEGV
	* La división entera entre cero da un resultado indefinido
	* `sigaction` puede llamarse con un segundo argumento nulo para conocer el manejador de señal en curso. 

## Proyecciones de archivos en memoria

* La función `int fcntl(int fd, int orden, /* argumento_orden */);` (*file control*) tiene muchos modos de uso y va a ser la forma principal de:
	* Manejar las banderas de control de acceso a un archivo abierto
	* Duplicar descriptores de archivos (*redireccionamiento de archivos*)
	* Consultar e implementar bloqueos de una región de un archivo
	* Crear y manipular proyecciones de archivos en memoria
	* Órdenes admitidas:
		* F_GETFL: Retorna las banderas de control de acceso asociadas al descriptor de archivo. 
		* F_SETFL: Ajusta o limpia las banderas de acceso que se especifican como tercer argumento: O_APPEND, O_NONBLOCK, O_NOATIME, O_ASYNC, y O_DIRECT
			* Util cuando:
				* El archivo no fue abierto por el programa llamador, de forma que no tiene control sobre las banderas utilizadas por open. 
				* Se obtuvo el descriptor del archivo a través de una llamada al sistema que no es open (`pipe` o `shocket`)
		* F_GETFD: Devuelve la bandera close-on-exec del archivo indicado. 	
		* F_SETFD: Activa o desactiva la bandera close-on-exec del descriptor especificado
		* F_DUPFD: Duplica el descriptor de archivo especificado por fd en otro descriptor
		nuevoFD = fcntl(viejoFD,F_DUPFD, inicialFD)
		* F_SETLK: Establece un cerrojo sobre un archivo. No bloquea si no tiene éxito
		inmediatamente.
		* F_SETLKW: Establece un cerrojo y bloquea al proceso llamador hasta que se adquiere el cerrojo.
		* F_GETLK: Consulta si existe un bloqueo sobre una región del archivo.
* Algunos casos de uso:
	* Código 1: Quiero recuperar las banderas con las que un archivo fue abierto, y después comrpobar si el archivo tiene modo de sincronización y el modo de acceso (más complicado):
	* Código 2: Procedimiento para añadir la bandera `O_APPEND`
	* Código 3: Mismo uso que con `dup`
	* Código 4: Como aplicar un bloqueo/Desbloqueo
* Cerrojos
	* flock() que utiliza un cerrojo para bloquear el archivo completo.
	* fcntl() que utiliza cerrojos para bloquear regiones de un archivo.
	* El método general para utilizarlas tiene los siguientes pasos:
		1. Posicionar un cerrojo sobre el archivo.
		2. Realizar las entradas/salidas sobre el archivo.
		3. Desbloquear el archivo de forma que otro proceso pueda bloquearlo.
	* Al trabajar con estas funciones debemos trabajar sin buffers: `read, write` o `setvbuf`
* `void *mmap(void *adress, size_t lenght, int prot, int flags, int fd, off_t offset)`
	* Para proyectar en memoria
	* Retorna:
		* Dirección Inicial de la proyección si todo sale bien
		* MAP_FAILED en caso de error
	* Parametros
		* `adress`: dirección de inicio dentro del proceso para mapear. Le pasamos `NULL`
		* `lenght`: numero de bytes a proyectar desde `offset`
		* `fd`: archivo a proyectar. Una vez proyectado, podemos cerrar el archivo
		* `prot`: máscara que indica el tipo de proyección a realizar: `PROT_READ|PROT_WRITE`
* `int munmap(void *address, size_t length);`
	* Borra una proyeccion en memoria
	* Devuelve 0 para exito, -1 para error
	* `msync()`: hace que al desproyectar se actualice la información (en caso `MAP_SHARED`) de forma inmediata
* Otras funciones útiles:
	* mremap(): se utiliza para extender una proyección existente.
	* mprotect(): cambia la protección de una proyección.
	* madvise(): establece consejos sobre el uso de memoria, es decir, como manejar las entradas/salidas de páginas de una proyección.
	* remap_file_pages(): permite crear mapeos no-lineales, es decir, mapeos donde las páginas del archivo aparecen en un orden diferente dentro de la memoria contigua.
	* mlock(): permite bloquear (anclar) páginas en memoria.
	* mincore(): informa sobre las páginas que están actualmente en RAM
* Estructura flock para utilizar bloqueos sobre regiones del archivo:

~~~c
struct flock {
	short l_type; /* Tipo de cerrojo: F_RDLCK, F_WRLCK, F_UNLCK */
	short l_whence; /*Interpretar l_start: SEEK_SET,SEEK_CURR,SEEK_END*/
	off_t l_start; /* Desplazamiento donde se inicia el bloqueo */
	off_t l_len; /* Numero bytes bloqueados: 0 significa “hasta EOF” */
	pid_t l_pid; /* Proceso que previene nuestro bloqueo(solo F_GETLK)*/
};
~~~

**Código 1:**

~~~c
int banderas, ModoAcceso;
banderas=fcntl(fd, F_GETFL);

if (banderas == -1){
	perror(“fcntl error”);
}

// Compruebo la sincronización
if (banderas & O_SYNC)
	printf (”Las escrituras son sincronizadas \n”);

// Compruebo el modo de acceso haciendo máscara con O_ACCMODE
ModoAcceso=banderas & O_ACCMODE;
if (ModoAcceso == O_WRONLY || ModoAcceso == O_RDWR)
	printf (”El archivo permite la escritura \n);
~~~

**Código 2:**

~~~c
// Tomo los valores de las banderas del archivo
int bandera;
bandera = fcntl(fd, F_GETFL);

if (bandera == -1)
	perror(“fcntl”);

// Añado O_APPEND a las banderas del archivo
bandera |= O_APPEND;				// bandera = bander | O_APPEND
if (fcntl(fd, F_SETFL, bandera) == -1)
	perror(“fcntl”);
~~~

**Código 3:**

~~~c
int fd = open (“temporal”, O_WRONLY);
close (1);

if (fcntl(fd, F_DUPFD, 1) == -1 ) perror (“Fallo en fcntl”);

char bufer[256];
int cont = write (1, bufer, 256);
~~~

**Código 4:**

~~~c
struct flock mi_bloqueo;
. . . /* ajustar campos de mi_bloqueo para describir el cerrojo a usar */
fcntl(fd, orden, &mi_bloqueo);
~~~


---

### Otros snippets de código útiles

#### Includes y estructura básica del main

```c
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <dirent.h>
#include <fcntl.h>
#include <string.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <sys/wait.h>

int main(int argc, char * argv[]){
	if (argc != x){
		perror("Parámetros incorrectos");
		exit(-1);
	}
}
```


#### Manejo de señales con signal

```c

// Manejador de señales con signal
void handler(int signum){
    // operaciones
}

signal(numero_de_senal, handler)
```


#### Flock

```c
// Bloquear
struct flock cerrojo;
cerrojo.l_type   = F_RDLCK;
cerrojo.l_whence = SEEK_SET;
cerrojo.l_start  = 0;
cerrojo.l_len    = 0;

fcntl(descriptor, F_SETLKW, &cerrojo);

// Desbloquear
cerrojo.l_type = F_UNLCK;
fcntl(descriptor, F_SETLKW, &cerrojo);
```

#### Recorrer directorios

```c
// Recorremos archivos del directorio, sacamos permisos y hacemos comparaciones de permisos
char pathname[256];
strcpy(pathname, "./");
//               ^^^^
// Directorio principal

DIR * directorio = opendir(pathname);
struct dirent * elemento_dir;

while ( (elemento_dir = readdir(directorio)) != NULL){
	if (strcmp(elemento_dir->d_name, "..") != 0 && strcmp (elemento_dir->d_name, ".") != 0){
		char archivo[256];
		
		sprintf(archivo, "./%s", elemento_dir->d_name);
		struct stat atributos;
		
		if ( stat(archivo, &atributos) < 0){
			perror("No se han podido obtener los atributos");
			exit(-1);
		}

		if (S_ISREG(atributos.st_mode)){
			// Permiso para comprobar de cualquier archivo presente en el directorio
			//                       vvvv    vvvv
			if ((atributos.st_mode & 0444) != 0444)
				chmod(archivo, atributos.st_mode | 0444);

			printf("Nombre: %s. \tUID propietario: %d. \tiNodo: %d\n", elemento_dir->d_name, (int)atributos.st_uid, (int)atributos.st_ino);
		}
	}
}
```

#### Proyecciones de memoria

En este caso, sacamos los archivos desde un descriptor. Por hipótesis, se proyectará la de varios archivos

```c
char * memoria;
while( read(fd[0], archivo, 256) > 0){
	if ( (fd_archivo = open(archivo, O_RDONLY)) < 0){
		perror("No se ha podido abrir el archivo (hijo)");
		printf("Archivo: %s", archivo);
		exit(-1);
	}
	
	if ( stat(archivo, &atributos) < 0){
			perror("No se han podido obtener los atributos");
			exit(-1);
	}

	memoria = (char *)mmap(0, atributos.st_size, PROT_READ, MAP_SHARED, fd_archivo, 0);
	if(memoria == MAP_FAILED){
		perror("Error al proyectar");
		exit(EXIT_FAILURE);
	}

	close(fd_archivo);

	printf("%s:\n\n%s\n\n", archivo, memoria);
	if(munmap(memoria, atributos.st_size)<0){
		perror("Error al liberar proyección.\n");
		exit(EXIT_FAILURE);
	}

	strcpy(archivo, "");
}
```

#### Creación de cauces FIFOs

```c
int fd;

char archivo_fifo[256];
strcpy(archivo_fifo, "nombre_del_archivo");

umask(0);
mkfifo(archivo_fifo, 0666);

// Lectura, escritura, o ambas. Lo que te interese. Normalmente, esto se hará en padres/hijos 	
//                      vvvvvv
if ( (fd = open(archivo_fifo, O_RDWR, 0666))<0){
	perror("No se ha podido abrir el archivo FIFO");
	exit(-1);
}

// Operaciones

close(fd);
```
