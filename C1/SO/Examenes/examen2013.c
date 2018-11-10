/*
    Lea la información que se le proporciona sobre el archivo maps
    Construya un programa que se le llamará conSoporte.c. Cuando se ejecute, obtendremos el PID
  de la ejecución del programa. Formamos la ruta del archivo que contiene el mapa de memoria de
  dicho padre con
        char mempadre[60];
        sprintf(mempadre, "proc/%d/maps", getppid());
    Deberá lanzar dos procesos, padre e hijo, que se comunicarán con un cauce
    El proceso hijo debe llamar a exec para lanzar cat y obtener el contenido de proc/%d/maps.
  Estos datos irán al cauce.
    El padre recogerá los datos desde el cauce. Cuando lea un '/', es porque ha encontrado un archivo
  aludido en maps, y deberá escribir en la salida estándar dicho archivo. Considerar lo siguiente:
        if ((strcmp(c, "/") == 0) deboescribir=1;
        if (deboescribir) {-escribir cosas-};
        if (strcmp(c, "\n") == 0) deboescribir=0;
*/
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>  	
#include<sys/stat.h>
#include<fcntl.h>
#include<errno.h>
#include<string.h>
#include<stdbool.h>

int main(int argc, char const *argv[]) {
    if (argc != 1){
        perror("Uso incorrecto de parámetros");
        exit(-1);
    }

    pid_t hijo; 

    // Intercambio de información entre procesos
    int fd_exchange[2]; 
        pipe(fd_exchange);

    if ( (hijo = fork()) < 0){
        perror("No se ha podido crear un hijo");
        exit(-1);
    }

    if (hijo == 0){
        // Cerramos lectura y salida estándar para reemplazarla
        close(STDOUT_FILENO);
        close(fd_exchange[0]);

        dup(fd_exchange[1]);

        // Obtenemos la ruta del archivo
        char mem_padre[60];
        sprintf(mem_padre, "/proc/%d/maps", getppid());

        // Recogemos y enviamos la información
         if (execl("/bin/cat", "cat", mem_padre, NULL) < 0){
             perror("Error en exec");
             exit(-1);
         }
    }

    else{
        // No nos interesa escribir para nada
        close(fd_exchange[1]);

        char buffer[1];
        bool is_written = false;
        
        // Leemos caracter a caracter
        while (read(fd_exchange[0], buffer, 1) == 1){
            if (strcmp(buffer, "/") == 0)
                is_written = true;
            else if (strcmp(buffer, "\n") == 0) {
                is_written = false;
                printf("\n");
            }
            
            if (is_written)
                printf("%s", buffer);       // Eficiencia. ¿Eso se come? LMAO
        }
    }
    
    return 0;
}
