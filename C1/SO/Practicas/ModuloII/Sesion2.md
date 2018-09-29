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
Como en la sesión anterior, se usará `struct stat` para jugar con los permisos de los archivos
En primer lugar, se crean dos archivos en el lugar donde se ejecuta el programa. El primero se llama `archivo1`, y el segundo, `archivo2`. Los parámetros de ambos archivos son idénticos. Las 3 primeras flags indican que son de creación (`O_CREAT|O_TRUNC|O_WRONLY`). Las últimas (`S_IRGRP|S_IWGRP|S_IXGRP`) cambian los permisos para el grupo: lectura, escritura y ejecución. 
Si algo falla, el programa termina

La segunda parte del programa empieza activando la máscara que permite modificar permisos de archivos. Tras esto, comprueba que se puede acceder a los atributos de `archivo1`
Después, cambia los permisos de `archivo1` y `archivo2`

//FIXME: ¿Qué narices hace `atributos.st_mode & ~S_IXGRP`? ¿Le quita permisos o algo?
- En `archivo1`, S_ISGID activa la asignación del GID del propietario al GID efectivo del proceso que ejecute el archivo
- Para `archivo2`, activa la lectura, escritura y ejecución para el archivo. Le da lectura al grupo y lectura para otros.
Si no se ha podido cambiar alguno, se elimina sale del programa. Si ha ido bien, termina la ejecución 