## Ejercicio 1
1. Abre un archivo, y comprueba que ha sido correctamente abierto. Si no se ha conseguido abrir, se cierra
2. Escribe el contenido del array buff `(abcdefghij)`. Si no se ha conseguido escrbrir, se cierra
3. Posiciona el cursor en la parte inicial del archivo
4. Escribe ahora el contenido del segundo array en el archivo. Si no lo ha conseguido, cierra el programa
5. Finaliza la ejecución

## Ejercicio 2
```c
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>  	
#include<sys/stat.h>
#include<fcntl.h>
#include<errno.h>
#include <string.h>

int main(int argc, char *argv[]){
    if (argc != 2){
        printf("Incorrecto número de argumentos");
    }

    FILE * file_read_pointer  = fopen(argv[1], "r");
    FILE * file_write_pointer = fopen("salida.txt", "w");
    
    if ( file_read_pointer == NULL){
        perror("Error al abrir el archivo de entrada");
        exit(EXIT_FAILURE);
    }

    if ( file_write_pointer == NULL){
        perror("Error al abrir el archivo de salida");
        exit(EXIT_FAILURE);
    }

    int iterador=0;
    char buffer[80];
    char ch;
    
    while ( (ch = fgetc(file_read_pointer)) != EOF){
        if ( iterador < (80/sizeof(char)) ){
            fputc(ch, file_write_pointer);
            iterador++;
        }
        
        else if (ch != EOF){
            fputc('\n', file_write_pointer);
            iterador = 0;
        }
    }

    fclose(file_read_pointer);
    fclose(file_write_pointer);
}
```

## Ejercicio 3 
El programa recibe el nombre de un elemento, y analiza de qué tipo es. Para ello, invoca un struct del tipo `stat`, y compara poco a poco qué flag se activa.

- `S_ISREG` => Es regular
- `S_ISCHR` => Especial de caracteres
- `S_ISDIR` => Es un directorio 
...

Si alguno de esos bits se ha activado, copia en la cadena `tipoArchivo` el mensaje tras cada `if()`.

## Ejercicio 4 
Una macro es una pieza de código que recibe un nombre. Cada vez que su nombre se usa, se reemplaza por lo que sea que venga tras su definición. 
Lo que necesitamos construir es una minifunción booleana, que nos devuelva verdadero o falso. 

Para saber los permisos de un archivo, podemos crear un `struct stat` para comprobarlos. Sin embargo, existe un problema: los permisos no vienen como strings, sino en binario. Por tanto, debemos hacer comparaciones de lo que queramos. 

En este caso, necesitamos hacer una comparación del parámetro `.st_mode` y `0170000`. Al hacer una operación AND, y el resultado es `0100000`, estamos ante un archivo regular. 
`0170000` corresponde a `S_IFMT`. Es una máscara de bits para los campos de bit del tipo de archivo
`0100000` implica que el archivo es regular. 

Por tanto, reutilizando el código del ejercicio 3, podemos crear lo siguiente: 
```c
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>  
#include<sys/stat.h>
#include<stdio.h>
#include<errno.h>
#include<string.h>

#define S_ISREG2(mode) ( (mode & 0170000) == 0100000)

int main(int argc, char const *argv[]) {
    int i;
	struct stat atributos;
	char tipoArchivo[30];

	if(argc<2) {
		printf("\nSintaxis de ejecucion: tarea2 [<nombre_archivo>]+\n\n");
		exit(EXIT_FAILURE);
	}

	for(i=1;i<argc;i++) {
		printf("%s: ", argv[i]);
		
		if(lstat(argv[i], &atributos) < 0) {
			printf("\nError al intentar acceder a los atributos de %s",argv[i]);
			perror("\nError en lstat");
		}

		else if(S_ISREG2(atributos.st_mode)) printf("Regular");
        else printf("No es un archivo regular");
    }
    exit(EXIT_SUCCESS);
}
``` 