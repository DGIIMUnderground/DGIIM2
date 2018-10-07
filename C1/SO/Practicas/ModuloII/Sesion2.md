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

- En `archivo1`, al hacer la negación de S_IXGRP, como `S_IXGRP` es de la forma 0...01, se vuelve 1...10. Al hacer la AND, se ponen los permisos que coincidan entre `st_mode` y `~S_IXGRP`. Le añade, finalmente, `S_ISGID`. Esta activa la asignación del GID del propietario al GID efectivo del proceso que ejecute el archivo.
- Para `archivo2`, activa la lectura, escritura y ejecución para el archivo. Le da lectura al grupo y lectura para otros.
Si no se ha podido cambiar alguno, se elimina sale del programa. Si ha ido bien, termina la ejecución 

## Ejercicio 2
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

int main(int argc, char const *argv[]) {
    if (argc != 3){
        printf("Argumentos pasados incorrectamente (./ejecutable directorio octal_4_dígitos)");
        exit(EXIT_FAILURE);
    }

    DIR * directorio;
    int octal = strtol(argv[2], NULL, 8);
    // NULL en C es el delimitador de la cadena

    if ( (directorio = opendir(argv[1])) == NULL ){
        printf("No se ha podido abrir el directorio");
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