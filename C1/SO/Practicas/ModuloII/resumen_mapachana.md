# Apuntes de prácticas de SO

## Sesión 1: Llamadas al sistema para SA (Parte I)

### Abrir archivos

Usaremos la función open que devuelve un numero, en este caso fd tiene como argumentos:

- "archivo" nombre y ruta del archivo a abrir.
- O_CREAT abrimos de forma que de forma que si no existe el fichero se crea.
- O_TRUNC si el archivo existía y contenía información se sobreescribe.
- O_APPEND si el archivo existía y contenía información no se sobreescribe, se añade al final.
- O_WRONLYnos da permiso solo de escritura en el fichero.
- O_RDONLY nos da permiso solo de lectura en el fichero.
- O_RDWR nos da permiso de lectura y escritura en el fichero.
- El último argumento es opcional y son los permisos con los que se crea el archivo si se crea en esa apertura:
  - S_IRUSR
  - S_IWUSR

`fd = open("nombrearchivo", <modoabrir>, <permisossisecrea>)`

`close(int fd)`

Open devuelve un número entero que si es menor que 0 indica que se ha producido un error, por eso las comproobaciones con if.

errno es un entero que viene de la biblioteca errno.h que da el código del error ocurrido.

### Lectura de archivos

Read hace una llamada al sistema para leer de un archivo, y tengo varios argumentos:

- fd, numero/nombre del archivo en que el queremos escribir.
- arrray con los datos y caracteres a leer.
- numero de bytes desde el comienzo del array que se desean leer.

`read(int fd, char buf[], int num caracteres)`

Read devuelve el numero de bytes que se han leído, por eso podemos comprobar si se haleído correctamente mediante un if, comparando el número que devuelve read con 0.

### Escritura de archivos

Write hace una llamada al sistema para escribir en un archivo, y tengo varios argumentos:

- fd, numero del archivo en que el queremos escribir.

- arrray con los datos y caracteres a escribir.

- numero de bytes desde el comienzo del array que se desean escribir.

`write(int fd, char buf[], int num caracteres)`

Write devuelve el numero de bytes que se han escrito, por eso podemos comprobar si se ha escrito correctamente mediante un if, comparando el número que devuelve write con el que debería haber escrito.

### lseek

La posición actual (current_offset) de un archivo abierto puede cambiarse explícitamente utilizando la llamada al sistema _lseek_.

`lseek(fd, int numcaracteres, SEEK_SET)`

### stat

stat en consola muestra los metadatos.
lstat o stat en c es una orden que devuelve los metadatos, y por ejemplo:
`stat(archivo, &atributos)` guarda los atributos de archivo en atributos. (Donde atributos es definido _struct stat_)

Además tenemos flags predefinidas como *S_IFREG* que pasandole un _struct stat_ con el método *.st__mode* nos devuelven verdadero o falso a si es REGular, DIRectorio.... (`S_IFREG(atributos.st_mode)`)

Todas estas flags están en el guión de la práctica páginas 80 y 81.

Además en atributos, una vez cargados los datos (hecho stat) podemos acceder a distintos campos, como:

- ino_t st_ino : Número de inodo de archivo.

- mode_t st_mode : Tipo e archivo donde están también los permisos.

- off_ t st_size : Tamaño total en bytes de archivos regulares.

- uid_t st_uid : UID del usuario propietario.

Hay más, están todas disponibles en la página 82 del guión de prácticas.

### Macros

Podemos definir macros usando las flags anteriores.

## Sesión 2: Llamadas al sistema para SA (Parte II)

### umask

La llamada al sistema umask fija la máscara de creación de permisos para el proceso y devuelve el valor previamente establecido. El argumento de la llamada a umask se forma con una combinación or de las 9 constantes de permisos (rwx para ugo).

`mode_t umask(mode_t mask)`

La máscara de permisos se pasa por open al crear un nuevo archivo y su valor por defecto es 022.

Supongamos que creamos un archivo con permisos 666, esto es: 110 110 110. La máscara vale por 022, es decir 000 010 010. Ahora, procedemos a aplicar  la máscara: Se niega bit a bit la máscara, quedando así: 111 101 101 y hacemos un & (and lógico bit a bit) con los permisos con los que se creó el archivo, esto es: 110 110 110 & 111 101 101 = 110 100 100, que es 644, lo que se traduce en rw-r---r--.

### Gestión de permisos

La llamada **chmod** trabaja sobre un archivo especificado por su pathname, mientras que la función **fchmod** opera sobre un archivo que ha sido previamente abierto con *open*.

`int chmod(const char *path, mode_t mode)`

`int fchmod(int fd, mode_t mode)`

*NOTA: Se ponen los permisos que se especifiquen tal cuál, para añadir o quitar permisos deberemos añadirlos o quitarlos mediante operaciones lógicas una vez obtenidos estos en una variable (de tipo struct stat y accedemos a ellos con .st_mode), ejemplos:*

```c
// Cambiamos los permisos, tuviera los que estuviera ahora tiene los que vienen ahí
if (chmod ("archivo1", S_IRWXU | S_IRGRP | S_IRWGRP | S_IROTH)){
  perror("Error cambiando los permisos");
  exit(EXIT_FAILURE);
}
// Obtenemos los atributos del archivo
if (stat("archivo1", &atributos) < 0){ //obtengo atributos y compruebo
  perror("Error en stat");
  exit(EXIT_FAILURE);
}
// Le quitamos permiso de ejecucion para grupos, ~ niega y hacemos &
if (chmod("archivo1", (atributos.stmode & ~S_IXGRP)) < 0){
  perror("Error cambiando los permisos");
  exit(EXIT_FAILURE);
}
// Le añadimos permiso de lectura para usuario
if (chmod("archivo1", (atributos.st_mode | S_RUSR)) < 0){
  perror("Error cambiando los permisos");
  exit(EXIT_FAILURE);
}
```

Podemos cambiar los permisos usando instrucciones predefinidas como *S_IRWXU* (usuario con permisos de rwx). Todas estas instrucciones están en el guión en las páginas 85 y 86.

Si realiza la acción correctamente devuelve un 0 y de lo contrario un -1.

### Funciones de manejo de directorios

Para manejar los directorios vamos a usar una serie de funciones y tipos de datos siguientes:

- opendir: Se le pasa el path del directorio a abrir y devuelve un puntero a una estructura de tipo DIR.

- readdir: Lee la entrada donde está situada el puntero de lectura de un directorio ya abierto. Tras leer adelanta el puntero una posición. Devuelve la entrada leída en un dato tipo struct dirent, si se produce un error o acaba el directorio devuelve NULL.

- closedir: Cierra el directrio, si tiene éxito devuelve 0.

`DIR* opendir(char* dirname)`

`struct dirent* readdir(DIR* dirp)`

`int closedir(DIR *dirp)`

Además el struct dirent tiene varios campos importantes, pero los que más son:

- long d_ino : Número inodo.

- char d_name[ 256 \] : Nombre de archivo.

Hacemos referencia a ellos como : midirent -> d_name.

### nftw()

Esta llamada permite recorrer recursivamente un sub-árbol y realizar algunas operaciones sobre ellos, si necesidad de hacerlo a mano.

`nftw(<directorio>, <funcion>, <nummaximodirectoriosabiertosalavez>, <valorexitositodovabien>`

`int nftw (const char* dir_path, int (*func), int nopenfd, int flags`

Donde la función func tiene estos argumentos:

`int (*func) (const char *pathname, const struct stat *statbuf, int typeflag, struct FTW *ftwbuf)`

## Sesión 3: Llamadas al sistema para el control de procesos

### Creación de procesos

Cada proceso es identificado por su PID, que se almacena en el tipo pid_t. Tenemos varios métodos para trabajar con los procesos:

- getpid() : Devuelve el PID del proceso que lo invoca.

- getppid() : Devuelve el PID del padre del proceso que lo invoca.

- getuid() : Devuelve el identificador de usuario del proceso que lo invoca (tipo uid_t).

- geteuid() : Devuelve el identificador del usuario efectivo del proceso que lo invoca.

- getgid() : Devuelve el identificador del grupo del usuario del proceso que lo invoca (tipo gid_t).

- getegid() : Devuelve el identificador del grupo efectivo del usuario del proceso que lo invoca.

### Fork()

La llamada al sistema fork() crea otro procceso hijo del proceso que lo invocó. Fork devuelve un valor u otro dependiendo de si lo ejecuta el proeso padre o el proceso hijo, y devuelve un número menor que 0 en caso de que haya habido algún error. Si el proceso padre llama a fork, le es devuelto el PID del proceso hijo creado, mientras que si lo llama el hijo, le es devuelto un 0. Aprovecharemos esto para (mediante ifs) separar el código del padre e hijo.

### vfork()

Es similar a fork, la única diferencia es que vfork crea un proceso sin copiar el espacio de direcciones del padre en al hijo, ya que éste estaba pensado para ejecutar un exec, y mientras tanto el padre dormía.

### wait, waitpid y exit

Las llamadas wait y waitpid se usan para sincronizar al proceso padre con los hijos, por ejemplo:

```c
int estado;
pid_t PID;
//Creamos hijo, hace algo y acaba (me lo salto)
PID = wait(&estado);
```

En este caso hemos creado un hijo y hemos esperado a que termine, entonces hemos esperado a que acabe y almacenado el PID del hijo en la variable PID.

waitpid se usa para esperar la finalización de un hijo concreto, especificado en su primer argumento `waitpid(pid_t <pidhijo>, &estado, 0)` 

### exec()

Las llamadas de la familia exec permiten ejecutar un programa distinto al actual. Estudiaremos varias llamadas relacionadas con exec, donde varían los argumentos que reciben.

- execl : Se le pasan los argumentos del programa uno a uno.

- execv : Se le pasan los argumentos del programa en un vector.

En ambos casos el último argumento o último componente debe ser NULL.

`int execl (const char *path, const char *arg, ...)`

`int execv (const char *path, char *const argv[])`

### clone

> Falta añadirlooooo

## Sesión 5: Llamadas al sistema para gestión y control de señales

### Señales

Las señales son un mecanismo básico de comunicación entre procesos para comunicar eventos síncronos ocurridos en ejecución.

Un manejador de señales es una función definida en el programa que se invoca al recibir una señal para gestionar como se deba. Una vez se ha gestionado, se sigue la ejecución normal del programa.

Las señales bloqueadas de un proceso se almacenan en un conjunto de señales llamado máscara de bloqueo de señales. Las señales bloqueadas permanecen pendientes y se despositarán (se iniciará una acción para gestionarla) cuando el proceso la desenmascare.

Por defecto, las señales existentes en POSIX tienen una acción asociada, aunque podemos modificar dicho comportamiento en la mayoría de ellas. Sin embargo, algunas, no podemos ni ignorarlas ni modificar su comportamiento, como por ejemplo las señales SIGKILL y SIGSTOP.

Las señales podemos nombrarlas según su nombre o según un valor entero asociado a cada una de ellas.

La lista de señales completa está en el guión de práticas en las páginas 122 y 123

### kill

La llamada kill se puede utilizar para enviar cualquier señal a un proceso o conjunto de ellos.

`int kill(pid_t pid, int sig)`

- pid : 

  - Si es estrictamente positivo se manda la señal al proceso con PID=pid.

  - Si es 0 se manda la señal a cada proceso del grupo del proceso actual.

  - Si es -1 se manda la señal a todos los procesos salvo el primero.

  - Si es menor que -1 se manda la señal a cada proceso en el grupo de procesos -pid.

- sig : Si es 0 no se manda ninguna señal pero se realiza comprobación de errores.

### sigaction

La llamada sigaction se emplea para cambiar la acción de un proceso cuando se recibe una determinada señal.

`int sigaction(int signum, const struct sigaction *act, struct sigaction *old_act)`

- signum : Especifica la señal, que puede ser cualquiera salvo SIGKILL y SIGSTOP.

- act : Si no es null la nueva acción para signum se instala como act.

- old_act : Si no es null, la acción anterior para signum se guarda en old_act.

La estructura de datos sigaction cuenta con:

- sa_handler : Especifica la acción que se va a asociar con la señal signum.

  - SIG_DFL establece la acción predeterminada.

  - SIG_IGN hace que se ignore la señal.

  - Puntero a una función manejadora para la señal.

- sa_mask : Establece la máscara de señales que deberían bloquearse. Para asignarle valores:

  - sigemptyset : Inicializa un conjunto vaccío de señales.

  - sigfillset : Inicializa un conjunto con todas las señales.

  - sigismember : Determina si una señal pertenece al conjunto.

  - sigaddset : Añade una señal al conjunto de señales.

  - sigddelset : Elimina una señal del conjunto de señales.

    `int sigemptyset(sigset_t *set)`

    `int sigaddset (sigset_t *set, int signal)`

- sa_flags : 

  - SA_RESTART : Hace que ciertas llamadas al sistema reinicien su ejecución al ser interrumpidas por la recepción de una señal.

> No sé si merece la pena seguir añadiendo a partir de este punto no me suena haber usado nada.

### sigprocmask

La llamada sigprocmask se emplea para examinar y cambiar la máscara de señales.

`int sigprocmask(int how, const sigset_t *set, sigset_t *oldset)`

- how : Indica el tipo de cambio:

  - SIG_BLOCK : El conjunto de señales bloqueadas es la unión del conjunto actual y set.

  - SIG_UNBLOCK : Las señales que hay en set se eliminan del conjunto actual de señales bloqueadas.

  - SIG_SETMASK : El conjunto de señales bloqueadas se pone según set.

- set : Puntero al nuevo conjunto de señales enmascaradas, SI es NULL se usa para consulta.

- oldset : Conjunto anterior de señales enmascaradas.

### sigpending

La llamada sigpending permite examinar el conjunto de señales bloqueadas y/o pendientes de entrega.

`int sigpending(sigset_t *set)`

- set : Puntero al conjunto de señales pendientes.

### sigsuspend

La llamada sigsuspend reemplaza temporalmente la máscara de señales para el proceso por la dada por el argumento y luego suspende el proceso hasta que se recibe una señal que no está en la máscara. Esto es, si en la máscara están todas las señales salvo la señal x el proceso seguirá en suspensión hasta que se le mande la señal x.

`int sigsuspend(const sigset_t *mask)`

- mask : Puntero al nuevo conjunto de señales enmascaradas.

> No olvides que hay que darle un repasillo a este resumen. Faltan algunas abreviaturas que no me acuerdo donde eran pero faltaban, creo que era en sigaction lo del handler y eso, pero ya no estoy segura de si faltaban o al final las puse ya. 

## Sesión 4: Comunicación entre procesos usando cauces

### Concepto y tipos de cauces

Un cauce es un mecanismo para la comunicación de información y sincronización entre procesos. Los datos pueden ser enviados (escritos) por varios procesos al cauce, y a su vez recibidos (leídos) por otros procesos desde dicho cauce.

La comunicación a través de un cauce sigue el paradigma de interacción productor/consumidor dnde existen dos tipos de procesos que se comunican mediante un buffer: los que generan datos (productores) y los que los toman (consumidores). Estos datos se toman en un orden FIFO, y la lectura de los datos por un proceso produce su eliminación del cauce.

Los cauces sin nombre no tienen archivo asociado en el sistema de archivos, solo existe un archivo temporalmente en memoria principal, al crear un cauce sin nombre (usando pipe) se devuelven dos descriptores, uno de escritura y otro de lectura. Además estos cauces solo pueden ser usados  por el proceso que los crea y los hijos del mismo creados después de la creación del cauce. También se cierran y elimina automáticamente cuando los contadores asociados de productores y consumidores que lo están usando valen ambos 0.

Un cauce con nombre (o archivo FIFO) se crean en disco como un archivo especial y consta de nombre, por tanto aparecen contenidos asociados de forma permanente a los directorios. Además los procesos abren y cierran los archivos FIFO normalmente con open y close, y cualquier proceso puede compartir datos usando las llamas read y write, es decir, no necesitan ser "familia".

### Cauces con nombre

Una vez creado el cauce cualquier proceso lo puede abrir como un archivo regular. El cauce debe estar abierto en ambos extremos para poder ealizar operaciones sobre él. Abrir un archivo FIFO para solo lectura produce un bloqueo hasta que otro proceso lo abra para escritura.

Para crear un archivo FIFO podemos usar la llamada mknod `int mknod (const char *FILENAME, mode_t MODE, dev_t DEV)` Para crearlo de tipo FIFO en mode pondremos S_IFIFO y en DEV un 0.

Ejemplo: `mknod("/tmp/FIFO", S_IFIFO|0666,0)` donde 0666 son los permisos que tendrá el archivo.

También podemos usar la llamada mkfifo: `int mkfifo (const char *FILENAME, mode_t MODE)` donde en MODE se establecen los permisos del archivo.

Los archivos FIFO se eliminan con la llamada al sistema unlink.

_NOTA: La llamada read es bloqueante para los procesos consumidores cuando no hay datos que leer y se desbloquea devolviendo 0 cuando todos los procesos que tenían cauce de escritura abierto se cierran o terminan._

### Cauces sin nombre

Al ejecutar la llamada al sistema pipe se crean dos descriptores, uno de write y otro de read.

para crear un cauce usaremos la llamada pipe, que necesita como argumento un vector de dos enteros que contendrá los descriptores de archivos, donde el primer elemento del vector es apra lectura y el segundo para escritura. Podemos cerrar uno de los cauces mediante close (es recomendable si no va a usarse).

La llamada al sistema dup se encarga de duplicar el descriptor indicado como parámetro de entrada en la primera entrada libre de la tabla de descriptores de archivo usada por el proceso.

La llamada al sistema dup2 permite una atomicidad en las operaciones sobre duplicación de descriptores de archivos que no proporciona dup.

## Sesión 6: Control de archivos y archivos

### fcntl

La llamada al sistema fcntl (file control) es una función multipropósito que permite consultar o ajustar las banderas de control de acceso de un descriptor (es decir, un archivo abierto). También permite duplicar descriptores de arhicovs y bloqueo de un archivo para acceso exclusivo.

`int fcnl(int fd, int orden, /*argumento_orden*/)`

Donde el argumento orden admite un rango de operaciones a realizar sobre el descriptor de archivos. El tercer argumento es opcional y depende de orden. Algunos ejemplos de órdenes:

- hlfkak

> Mirar y completar en pagina 140
> 
> DESISTO BUENA SUERTE  ME HE HINCHADO DE HACER APUNTES POR HOY

## Cosas extras

### Concatenar

Quiza hay que meter el stdlib, string.h en alguna tarea que falta incluso de fabrica.
printf("Bloque num %d", i)
sprintf(buf1, "blque num %d", i)
write(fd, buf1, strlen(buf1))
