## Ejercicio 1
Código del programa: 

```C
#include<sys/types.h>	
#include<unistd.h>		
#include<sys/stat.h>
#include<fcntl.h>		
#include<stdio.h>
#include<errno.h>
#include<stdlib.h>

int main (int argc, char * argv[]) {
	int fd1,fd2;
	struct stat atributos;
x
	//CREACION DE ARCHIVOS
	if( (fd1=open("archivo1", O_CREAT|O_TRUNC|O_WRONLY, S_IRGRP|S_IWGRP|S_IXGRP))<0) {
		printf("\nError %d en open(archivo1,...)",errno);
		perror("\nError en open");
		exit(EXIT_FAILURE);
	}

	umask(0);
	if( (fd2=open("archivo2", O_CREAT|O_TRUNC|O_WRONLY, S_IRGRP|S_IWGRP|S_IXGRP))<0) {
		printf("\nError %d en open(archivo2,...)",errno);
		perror("\nError en open");
		exit(EXIT_FAILURE);
	}

	//CAMBIO DE PERMISOS
	if(stat("archivo1",&atributos) < 0) {
		printf("\nError al intentar acceder a los atributos de archivo1");
		perror("\nError en lstat");
		exit(EXIT_FAILURE);
	}
	if(chmod("archivo1", (atributos.st_mode & ~S_IXGRP) | S_ISGID) < 0) {
		perror("\nError en chmod para archivo1");
		exit(EXIT_FAILURE);
	}
	if(chmod("archivo2",S_IRWXU | S_IRGRP | S_IWGRP | S_IROTH) < 0) {
		perror("\nError en chmod para archivo2");
		exit(EXIT_FAILURE);
	}

	printf("Archivos creados correctamente");
	return EXIT_SUCCESS;
}
```
Como en la sesión anterior, se usará `struct stat` para jugar con los permisos de los archivos.
En primer lugar, se crean dos archivos en el lugar donde se ejecuta el programa. El primero se llama `archivo1`, y el segundo, `archivo2`. Los parámetros de ambos archivos son idénticos. Las 3 primeras flags indican que son de creación (`O_CREAT|O_TRUNC|O_WRONLY`). Las últimas (`S_IRGRP|S_IWGRP|S_IXGRP`) cambian los permisos para el grupo: lectura, escritura y ejecución en caso de que haya creación. 
Si algo falla, el programa termina.

La segunda parte del programa empieza activando la máscara que permite modificar permisos de archivos. Dependiendo del parámetro pasado a umask, se crea con diferentes permisos. Tras esto, comprueba que se puede acceder a los atributos de `archivo1`
Después, cambia los permisos de `archivo1` y `archivo2`
- En `archivo1`, de primeras se añade lectura escritura y ejecución para el grupo, que al pasarle la máscara `~022`, se hace la operación `000 111 000 & 111 101 101 = 000 101 000`. Antes de la llamada a `chmod` esos son los permisos que tiene `archivo1`. `chmod` toma los permisos actuales y les quita el permiso de ejecución al grupo `(atributos.st_mode & ~S_IXGRP)`, para después activar la asignación del GID propietario al GID efectivo. Esta acción, al hacer `ls -l` se ve codificada con una S en el bit correspondiente a la ejecución del grupo. Por este motivo, tras ejecutar el programa, en `archivo1` el comando `ls -l` nos devuelve la siguiente secuencia: `---r-S---`
- Para `archivo2`, activa la lectura, escritura y ejecución para el usuario. Le da lectura y escritura al grupo y lectura para otros.
Si no se ha podido cambiar alguno, se elimina sale del programa. Si ha ido bien, termina la ejecución 

## Ejercicio 2
```c
#include<sys/types.h>	//Primitive system data types for abstraction of implementation-dependent data types.
						//POSIX Standard: 2.6 Primitive System Data Types <sys/types.h>
#include<unistd.h>		//POSIX Standard: 2.10 Symbolic Constants         <unistd.h>
#include<sys/stat.h>
#include<stdio.h>
#include<errno.h>
#include<stdlib.h>
#include<dirent.h> //formato DIR, para el stream que devuelve opendir
#include<string.h> //strlen, strcmp ...

int main(int argc, char const *argv[]) {
  
  char mensajeerror[] ="Debe dar 2 argumentos: ruta de un directorio y entero con permiso a conceder a todos los archivillos\n";
  
    if (argc != 3){
      // printf("Argumentos pasados incorrectamente (./ejecutable directorio octal_4_dígitos)");
       write(STDERR_FILENO, mensajeerror, strlen(mensajeerror));
       exit(EXIT_FAILURE);
    }

    DIR * directorio;
    int octal = strtol(argv[2], NULL, 8);
    // se está cambiando de base 8 a decimal el número pasado por argumentos
    // NULL en C es el delimitador de la cadena

    if ( (directorio = opendir(argv[1])) == NULL ){
        printf("No se ha podido abrir el directorio");
	perror( "opendir");
        exit(EXIT_FAILURE);
    }

    struct dirent * elemento_dir;
    
    // Variables de acceso a metadatos
    char ruta_completa[500];
    struct stat atributos;

    while ( (elemento_dir = readdir(directorio)) != NULL){
        if (strcmp (elemento_dir->d_name, "..") != 0 && strcmp (elemento_dir->d_name, ".") != 0){
            printf("Nombre de elemento: %s. \n",elemento_dir->d_name);
            
            // ruta_completa = carpeta/elemento
            strcpy(ruta_completa, argv[1]);
            strcat(ruta_completa, "/");
            strcat(ruta_completa,elemento_dir->d_name);

            // Accedemos al elemento deseado, y copiamos sus atributos en `atributos`            
            if (stat(ruta_completa, &atributos) < 0){
                printf("No se puede acceder a los atributos del archivo");
                exit(-1);
            }

            // Enseñamos los permisos 
            printf("Permisos antiguos de %s: %o\n", elemento_dir->d_name, atributos.st_mode);

            //Cambio de permisos. Necesario ponerlo dos veces
            chmod(ruta_completa, octal);
            
            if (chmod(ruta_completa, octal) < 0)
                printf("Error: %s\n", strerror(errno)); 
            else {
                // Recogemos los nuevos atributos
                stat(ruta_completa, &atributos);
                printf("Permisos nuevos: %o\n", atributos.st_mode);
            }
        }
    }
    
    closedir(directorio);
    exit(EXIT_SUCCESS);
}

```

## Ejercicio 3
La explicación se encuentra dentro del ejercicio

```c
#include<sys/types.h>	
#include<dirent.h>
#include<unistd.h>		
#include<sys/stat.h>
#include<fcntl.h>		
#include<stdio.h>
#include<errno.h>
#include<stdlib.h>
#include <string.h>

/**
 * Debemos visualizar la estructura tal que así:
 *   
 *   Directorio
 *    | - Directorio
 *    |       | - archivo
 *    |       | - archivo
 *    | - archivo
 *    | - archivo
 * 
 *  Para cada archivo, lo visualizaremos y mostraremos sus permisos, inodo, y su tamaño + cuenta de regulares
 */

void buscar_dir(DIR * directorio, char pathname[], int * contador_regulares, int * tamano_total){
    struct stat atributos;
    struct dirent * elemento_dir;
    DIR * directorio_actual;
    char cadena[500];

    while ( (elemento_dir = readdir(directorio))!= NULL){
        // Ignoraremos el directorio actual y el superior:
        if (strcmp(elemento_dir->d_name, ".")  != 0
        &&  strcmp(elemento_dir->d_name, "..") != 0){
             
            //Ruta de la forma elemento/directorio
            strcpy(cadena, pathname);
            strcat(cadena, "/");
            strcat(cadena,elemento_dir->d_name);

            // El nombre del archivo está contenido en cadena => comprobamos sus permisos
            if ( stat(cadena, &atributos) < 0){
                printf("No se ha podido comprobar los permisos");
                exit (-1);
            }

            // Es directorio => volvemos a acceder
            if (S_ISDIR(atributos.st_mode)) {    
                if ( (directorio_actual = opendir(cadena)) == NULL)
                    printf("Error al abrir el directorio: [%s]", cadena);
                else
                    buscar_dir(directorio_actual, cadena, contador_regulares, tamano_total);
            }
            else{
                // Imprimimos nodo
                
                // Comprobamos que es regular y miramos si tienes los permisos deseados
                // (ejecución en grupo y en otros)
                // El mayor problema es la expresión para comprobar qué permisos son los indicados
                if (S_ISREG(atributos.st_mode)
                && ( (atributos.st_mode & ~__S_IFMT) & 011) == 011) {
                    printf("%s %ld \n", cadena, atributos.st_ino);
                    (*contador_regulares)++;
                    // Casteo como entero. Modificas el puntero
                    (*tamano_total) += (int) atributos.st_size;

                }
            }
        }
    }

    closedir(directorio);
}

int main(int argc, char *argv[]){
    DIR * directorio;
    char pathname[500];
    
    int contador_regulares = 0;
    int tamano_total       = 0;

    // Preparación de directorios
    if (argc == 2)
        strcpy(pathname, argv[1]);
    else
        strcpy(pathname, ".");

    if ( (directorio = opendir(pathname)) == NULL){
        printf("Error al abrir el directorio");
        exit(-1);
    }

    printf("Estos son los inodos: \n");
    buscar_dir(directorio, pathname, &contador_regulares, &tamano_total);

    printf("Existen %d archivos regulares con permiso de ejecución en grupo y otros, y en total ocupan %d bytes", contador_regulares, tamano_total);

}
```


## Ejercicio 4
Implementa de nuevo el programa del ejercicio 3 utilizando la llamada al sistema nftw.

```c
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <dirent.h> //DIR
#include <ftw.h> // nftw

int contador_regulares = 0, tamano_total = 0;

int visitar (const char *pathname, const struct stat *statbuf, int typeflag, struct FTW *ftwbuf){
  if (S_ISREG(statbuf->st_mode) && ( (statbuf->st_mode & ~__S_IFMT) & 011) == 011){
    printf ("%s %ld\n",pathname, statbuf->st_ino);
    contador_regulares++;
    tamano_total += (int) statbuf->st_size;
  }

  return 0;
}

int main (int argc, char *argv[]){
  char pathname[500];

  if (argc == 2)
    strcpy(pathname, argv[1]);
  else if (argc == 1)
    strcpy(pathname, ".");
  else
    printf("Error, introduzca: ./Ej3 (<pathname>)\n");

  /*
  Parámetros:
  pathname: ruta del archivo
  visitar: función para saber sobre el archivo
  10: mÁximo nÚmero de descriptores
  0: modifica la operación de la función. Aquí no modifica nada
  */
  if(nftw(pathname, visitar, 10,0) != 0){
    perror("nftw");
  }

  printf("Existen %d archivos regulares y en total ocupan %d bytes\n", contador_regulares, tamano_total);

  exit(EXIT_SUCCESS);
}
```
