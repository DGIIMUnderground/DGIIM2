// By Mapachana
// Enunciado en: https://github.com/Mapachana/Apuntes/blob/master/SO/examenes/SO_Examen2015_Modulo2_Mar%C3%ADaAngustiasS%C3%A1nchezBuend%C3%ADa.pdf

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
#include <sys/wait.h>

int contador = 0;

//Función que se invoca para manejar las señales
void manejadorsignal(int signum){
    printf("El valor de la suma es: %d\n", signum);
    kill(0, SIGKILL); //Envía la señal a todos los procesos de su grupo
	exit(EXIT_FAILURE);

}

int main(int argc, char * argv[]){
    //Comprobamos que el número de argumentos sea el correcto
    if (argc != 3){
        perror("Número de argumentos inválido\n");
        exit(EXIT_FAILURE);
    }

    // Desactivamos el buffer de salida para que haga los print de inmediato.
    setvbuf(stdout,NULL,_IONBF,0);

    char * pathname = argv[2];
    char * literal = argv[1];
    DIR *directorio;
    struct dirent * dir;
    struct stat atributos;
    char nombre[256];
    int fd[2];
    int fderror;
    pid_t PID;
    int estado;
    char valhijo[3];

    //Ponemos la mascara a 0 para que los archivos se creen con los permisos especificados
    umask(0);
    // Abrimos o creamos el archivo de redireccion de errores
    fderror = open("Errormigrep", O_CREAT|O_WRONLY, 0666);
    if(fderror < 0){
        perror("Error en open\n");
        exit(EXIT_FAILURE);
    }
    //Sobreescribimos la salida de error estandar con nuestro fichero
    if(dup2(fderror, STDERR_FILENO) < 0){
        perror("Error en dup2\n");
        exit(EXIT_FAILURE);
    }

    // Establecemos la funcion que gestionara la señal ce ctrl+c
    struct sigaction misigaction;

    misigaction.sa_handler = manejadorsignal;

    if (sigaction(SIGINT, &misigaction, NULL) < 0){
        perror("Error en sigaction\n");
        exit(EXIT_FAILURE);
    }

    //Creamos cauce sin nombre para comunicacion padre-hijo
    pipe(fd);

    // Abrimos el directorio y leemos la primera vez
    directorio = opendir(pathname);
    dir = readdir(directorio);

    //Recorremos el directorio dado como argumento
    while(dir != NULL){
        // En nombre ponemos la ruta del archivo actual
        sprintf(nombre, "%s/%s", pathname,dir->d_name);
        //Obtenemos los atributos del archivo
        if (stat(nombre, &atributos) < 0){
            perror("Error en stat\n");
            exit(EXIT_FAILURE);
        }
        // Si el archivo es regular...
        if (S_ISREG(atributos.st_mode)){
            // Creamos un hijo
            PID = fork();
            if (PID < 0){
                perror("Error en fork\n");
                exit(EXIT_FAILURE);
            }
            // Proceso hijo
            if (PID == 0){
                // Cerramos cauce de lectura
                close(fd[0]);
                // SObreescribimos la salida estandar con nuestro cauce
                if(dup2(fd[1],STDOUT_FILENO) < 0){
                    perror("Error en dup");
                    exit(EXIT_FAILURE);
                }
                // Invocamos la orden grep sobre nuestro archivo
                execlp("grep","grep", "-c", literal, nombre, NULL);
            }
            // Proceso padre
            else{
                int resultadohijo;
                //wait(&estado);
                // Leemos el resultado que ha dado el hijo
                read(fd[0], valhijo, 3);
                resultadohijo = atoi(valhijo);
                // Sumamos al total
                contador += resultadohijo;
            }

        }

        //Sigo leyendo
        dir = readdir(directorio);
    }
    // Para probar a matar al proceso darle al sleep para que sea mas facil (5 segundos para matarlo y ver que pasa)
    //sleep(5);
    printf("El resultado final de contar %s es: %d\n", literal, contador);
    exit(EXIT_SUCCESS);
}
