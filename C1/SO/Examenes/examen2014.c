/*
    1. Implementa un programa llamado catdir con la siguiente sintaxis:
        catdir <directorio> <fichero_salida>
    donde
    a) El primer parámetro es obligatorio. El segundo opcional
    b) La orden debe escribir en el archivo fichero_salida todos los archivos regulares del directorio
    que tengan permiso de escritura en propietario y grupo
    c) Va sumando los bloques ocupados por los ficheros del apartado b)
    d)
    e) si no se escribe el segundo argumento, se saca directamente en la salida estándar
    f) Antes de terminar, debe escribir en pantalla el resultado del apartado c)

    2. Implementa un programa en c llamado principal que tiene como argumentos
    nombres de directorios (d1 d2 ... dn) y que realiza las siguientes acciones:
    a) Por cada argumento recibido, crea un proceso hijo que se encargará de
    ejecutar el programa catdir.
    b) Cada hijo usará como argumento del programa que va a ejecutar el nombre
    del directorio por el cual se creó y el nombre de un archivo que se llamará
    fsalida.<pid del hijo>.
    c) El proceso padre crea un archivo de tipo cauce (con o sin nombre) que le
    comunicará con sus procesos hijos. De este cauce leerá números (que
    escribirán sus hijos) que irá sumando.
    d) Cuando todos los procesos hijos finalicen, el proceso padre imprimirá en
    pantalla un mensaje indicando que "la suma de los bloques de todos los
    archivos es <numero>" y finalizará.
*/

#include<sys/types.h>
#include<dirent.h>
#include<unistd.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<stdio.h>
#include<errno.h>
#include<stdlib.h>
#include<string.h>


// Si este valor es NULL, escribiremos lo que encontramos en la salida estándar
//                                                                     vvvvvvvvvvvvvvv
void buscar_dir(DIR * directorio, char pathname[], int * tamano_total, char archivo[]){
    struct stat atributos;
    struct dirent * elemento_dir;
    DIR * directorio_actual;
    char cadena[500];
    int fd;

    if(strcmp(archivo, "NULL") != 0)
      if ((fd = open(archivo, O_CREAT|O_TRUNC|O_WRONLY, S_IWUSR|S_IRUSR)) < 0 ){
        perror("No se ha podido abrir el archivo a escribir");
        exit(-1);
      }

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
                    buscar_dir(directorio_actual, cadena, tamano_total, archivo);
            }
            else{
                // Comprobamos que es regular y miramos si tienes los permisos deseados
                // El mayor problema es la expresión para comprobar qué permisos son los indicados
                if (S_ISREG(atributos.st_mode) && (atributos.st_mode & 0220 ) == 0220 ) {
                    if (strcmp("NULL", archivo) == 0){
                        printf("%s\n", elemento_dir->d_name);
                        execl("/bin/cat", "cat", cadena, NULL);
                    }
                    else{
                      close(1); //Cerramos la salida estandar

                      fcntl(fd, F_DUPFD, 1);

                      if (execlp("/bin/cat", "cat", cadena, NULL) < 0){
                        perror("Error en execlp");
                        exit(EXIT_FAILURE);
                      }
                    }

                    (*tamano_total) += (int) atributos.st_size;
                }
            }
        }
    }

    closedir(directorio);
}

int main(int argc, char const *argv[]) {
    if (argc != 2 && argc != 3){
        perror("./catdir directorio fichero");
        exit(-1);
    }

    int tamano_total = 0;

    // Preparación de fichero de salida
    char fichero_salida[256];
    if (argc == 3){
        strcpy(fichero_salida, argv[2]);
    }
    else
        strcpy(fichero_salida, "NULL");

    // Preparación de directorios
    DIR * directorio;
    if ( (directorio = opendir(argv[1])) == NULL){
        printf("Error al abrir el directorio");
        exit(-1);
    }

    // Localización
    char pathname[500];
    strcpy(pathname, argv[1]);


    buscar_dir(directorio, pathname, &tamano_total, fichero_salida);

    printf("Los archivos encontrados ocupan %d bytes en total", tamano_total);
    return 0;
}
