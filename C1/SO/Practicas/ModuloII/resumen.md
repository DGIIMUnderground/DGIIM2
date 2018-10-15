# Resumen del Módulo II: Uso del servicio del SO mediante la API
Estos apuntes son esencialmente código comentado.

## Sesión 1: Llamadas al sistema para el SA (Parte I)
---
### Llamada `open`
```c
int fd;
if ((fd = open("archivo", O_CREAT|O_TRUNC|O_WRONLY,S_IRUSR|S_IWUSR)) < 0) // llamada al sistema open
  printf("\nError %d en open", errno); //errno: código de error producido por la llamada al sistema
  perror("\nError en open"); // Imprimir en pantalla errno junto con un mensaje de error
  exit(-1) //salir del programa
```
- La llamada al sistema `open` devuelve el descriptor del fichero `archivo`, que será menor que 0 en caso de error.
- Parámetros de `open`:
  - `O_CREAT`: se crea el fichero si no existe
  - `O_TRUNC`: si existe el fichero y tiene habilitada la escritura, lo sobreescribe a tamaño 0
    - Para conservar la información del fichero: sustituir por `O_APPEND`
  - `O_WRONLY`: permitir sólo la escritura
  - `S_IRUSR`: comprueba que el usuario tiene permiso de lectura
  - `S_IRUSR`: comprueba que el usuario tiene permiso de escritura
---

### Llamada `write`
```c
char buf1[] = "abcdefghij"; //una cadena de caracteres
if (write(fd,buf1,10) != 10) { // false si se han escrito menos de 10 bytes y se desencadena el error
  perror("\nError en primer write");
  exit(-1);
}
```
- La llamada al sistema `write` imprime en el fichero `fd` (es el descriptor de fichero) los `10` primeros bytes (tercer argumento) extraídos de la cadena de caracteres `buf1`.
- Devuelve el número de bytes escritos correctamente
---

### Llamada `read`
```c
n = read(fd,buffer,nbytes);
```
- La llamada `read` lee de un fichero. Parámetros:
  - `fd`: descriptor de archivo del que se lee
  - `buffer`: variable (cstring) en la que se almacena lo leído
  - `nbytes`: número de bytes que se leen
---

### Llamada `lseek`
```c
if (lseek(fd,40,SEEK_SET) < 0) {
  perror("\nError en lseek");
  exit(-1);
}
```
- `lseek` mueve  el puntero del archivo, lo que permite leer y/o escribir a partir de cierto byte.
  - Primer argumento: `fd` es el descriptor de archivo.
  - Segundo argumento: `40`, posición en bytes en la que se colocará el puntero.
  - Tercer argumento: `SEEK_SET` indica que contamos los bytes desde el principio del fichero.
    - `SEEK_END`: final del fichero
  - Devuelve el número de bytes que se ha desplazado y menor que 0 en caso de error.

#### Aplicación de `lseek`: calcular la longitud de un fichero
- Situamos el puntero de archivo al comienzo del fichero, si es que no lo está:
```c
lseek(fd, 0, SEEK_SET);
```
- Situamos el puntero al final del archivo. Como `lseek` devuelve el número de bytes que se ha desplazado, obtenemos la longitud en baytes del fichero:
```c
int nbytes = lseek(fd,0,SEEK_END); //fd es un descriptor de archivo
```
- Calculamos el número de bloques dividiendo el número de bytes entre el tamaño en bytes de cada bloque:
```c
int nbloques = nbytes / tam_bloque;
if(nbytes % tam_bloque > 0)
  nbloques++;
```
- Situamos el puntero donde convenga, de nuevo, con `lseek`.
---

### LLamada close
```c
close(fd) //cierra el fichero cuyo descriptor es `fd`
```
## Sesión 3 

Instruciones | Descripción | sintaxis 
---| --- | ---   
fork | Crea un proceso hijo que mantiene el valor de las variables y se continua ejecutando desde ahí | fork()  
wait() | suspende la ejecución de un proceso hasta que alguno de sus hijos se suspente | `wait()`  
waitpid | suspendende el proceos hasta que determinado hijo termine |` waitpid(-1, &status, 0)`  
exit () | Finaliza el proceso u devuelve al proceso padre el valor que se le asigne | ` exit( int)`  


