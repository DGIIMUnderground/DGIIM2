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

Open devuelve un número entero que si es menor que 0 indica que se ha producido un error, por eso las comproobaciones con if.

errno es un entero que viene de la biblioteca errno.h que da el código del error ocurrido.

### Lectura de archivos

Read hace una llamada al sistema para leer de un archivo, y tengo varios argumentos:

- fd, numero/nombre del archivo en que el queremos escribir.
- arrray con los datos y caracteres a leer.
- numero de bytes desde el comienzo del array que se desean leer.

Read devuelve el numero de bytes que se han leídoo, por eso podemos comprobar si se haleído correctamente mediante un if, comparando el número que devuelve read con 0.

### Escritura de archivos

Write hace una llamada al sistema para escribir en un archivo, y tengo varios argumentos:

- fd, numero del archivo en que el queremos escribir.

- arrray con los datos y caracteres a escribir.

- numero de bytes desde el comienzo del array que se desean escribir.

Write devuelve el numero de bytes que se han escrito, por eso podemos comprobar si se ha escrito correctamente mediante un if, comparando el número que devuelve write con el que debería haber escrito.

### lseek

La posición actual (current_offset) de un archivo abierto puede cambiarse explícitamente utilizando la llamada al sistema _lseek_.

### stat

stat en consola muestra los metadatos.
lstat o stat en c es una orden que devuelve los metadatos, y por ejemplo:
`stat(archivo, &atributos)` guarda los atributos de archivo en atributos. (Donde atributos es definido _struct stat_)

Además tenemos flags predefinidas como *S_IFREG* que pasandole un _struct stat_ con el método *.st__mode* nos devuelven verdadero o falso a si es REGular, DIRectorio.... (`S_IFREG(atributos.st_mode)`)

Todas estas flags están en el guión de la práctica páginas 80 y 81.

### Macros

Podemos definir macros usando las flags anteriores.

## Sesión 2: Llamadas al sistema para SA (Parte II)

### Gestión de permisos

La llamada al sistema **umask** fija la máscara de permisos para el proceso y devuelve el valor previamente establecido.

En umask se usa como argumento unos números que son combinación de los permisos _rwx_ para _ugo_. Por ejemplo:

Creamos un archivo con mode 0666 y tenemos el valor por defecto de umask a 022, entonces el archivo se crea con permisos 0666 & ~022 = 0644 = rwxr--r--.

La llamada **chmod** trabaja sobre un archivo especificado por su pathname, mientras que la función **fchmod** opera sobre un archivo que ha sido previamente abierto con *open*.

Podemos cambiar los permisos usando instrucciones predefinidas como *S_IRWXU* (usuario con permisos de rwx). Todas estas instrucciones están en el guión en las páginas 85 y 86.

Si realiza la acción correctamente devuelve un 0 y de lo contrario un -1.

### Funciones de manejo de directorios

Para manejar los directorios vamos a usar una serie de funciones y tipos de datos siguientes:

- opendir: Se le pasa el path del directorio a abrir y devuelve un puntero a una estructura de tipo DIR.

- readdir: Lee la entrada donde está situada el puntero de lectura de un directorio ya abierto. Tras leer adelanta el puntero una posición. Devuelve la entrada leída en un dato tipo struct dirent, si se produce un error o acaba el directorio devuelve NULL.

- closedir: Cierra el directrio, si tiene éxito devuelve 0.

### nftw()

Esta llamada permite recorrer recursivamente un sub-árbol y realizar algunas operaciones sobre ellos, si necesidad de hacerlo a mano.

`nftw(<directorio>, <funcion>, <nummaximodirectoriosabiertosalavez>, <valorexitositodovabien>`

## Sesión 3: Llamadas al sistema para el control de procesos

### Creación de procesos





### Concatenar

Quiza hay que meter el stdlib, string.h en alguna tarea que falta incluso de fabrica.
printf("Bloque num %d", i)
sprintf(buf1, "blque num %d", i)
write(fd, buf1, strlen(buf1))
