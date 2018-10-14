# Conceptos básico para programar en ensamblador   

## Índice de contenidos  
- [ Compilación](#compilacion-del-programa )  
- [Registros básicos](#registros-basicos)
- [Instrucciones básicas](#intrucciones-basicas )  
- [Tipos de datos](#tipos-de-datos )


## Compilación del programa  
- El archivo debe tener una extensión .s
- Para compilarlo con gcc: `gcc -g -m32 nombre.s -o nombre_ejecutable`
El `-g ` es para poder depurarlo, el -m32 es para trabajar en 32 bytes  


### Posibles problemas  

Si intenta compilar por primera vez puede que obtenga, como me pasó a mí:
```shell
/usr/bin/x86_64-linux-gnu-ld: no se puede encontrar Scrt1.o: No existe el archivo o el directorio
/usr/bin/x86_64-linux-gnu-ld: no se puede encontrar crti.o: No existe el archivo o el directorio
/usr/bin/x86_64-linux-gnu-ld: se salta el /usr/lib/gcc/x86_64-linux-gnu/7/libgcc.a incompatible mientras se busca -lgcc
/usr/bin/x86_64-linux-gnu-ld: no se puede encontrar -lgcc
/usr/bin/x86_64-linux-gnu-ld: se salta el /usr/lib/gcc/x86_64-linux-gnu/7/libgcc_s.so.1 incompatible mientras se busca libgcc_s.so.1
/usr/bin/x86_64-linux-gnu-ld: no se puede encontrar libgcc_s.so.1
/usr/bin/x86_64-linux-gnu-ld: se salta el /usr/lib/gcc/x86_64-linux-gnu/7/libgcc.a incompatible mientras se busca -lgcc
/usr/bin/x86_64-linux-gnu-ld: no se puede encontrar -lgcc
collect2: error: ld returned 1 exit status
```

La solución es instalar la librería de 32 bits de gcc:
`sudo apt-get install gcc-multilib`

Otro posibe error puedría ser:
 ```shell
 definiciones múltiples de `_start'
/usr/lib/gcc/x86_64-linux-gnu/7/../../../../lib32/Scrt1.o:(.text+0x0): primero se definió aquí
/usr/lib/gcc/x86_64-linux-gnu/7/../../../../lib32/Scrt1.o: En la función `_start':
(.text+0x28): referencia a `main' sin definir

```
Esto se debe a que estamos compilando el programa con gcc, por tanto la estructura del main debería de ser:
```assembler
.section .data
# ... definicion de variables ...

.section .text
main:	.global main
#... estructura main del programa ...
```

## Registros básicos  
Los registros generales que utilizaremos son:

Registro | Origen del nombre  
--- | ---   
%eax | Acumulador  
%ecx | Contador  
%edx | Datos  
%ebx | Base  
%esi | Índice fuente  
%edi |Índice destino  
%esp %ebp | Puntero de pila y puntero bases USO ESPECIAL  


## Intrucciones básicas

Instrucción | Descripción | programa donde se ejemplifica
--- | ---- |---    
`push r` | añade a pila | [suma_lista.s](suma_lista.s)   
`pop r`| elemina de pila | [suma_lista.s](suma_lista.s)   
`call etiqueta` | se mueve hacia una etiqueta | [suma_lista.s](suma_lista.s)  
`ret` | retorno de subrutina, se carga de la pila | [suma_lista.s](suma_lista.s)   
` mov a, b` | mueve a -> b | [suma_lista.s](suma_lista.s)   
`cmp a, b` | compara a y b levanta flags | [suma_lista.s](suma_lista.s)   
`jne etiqueta` | comprueba flag y si no son iguales salta | [suma_lista.s](suma_lista.s)  

## Tipos de datos 

Dato | Descripción
--- | ---
.int | enteros de 4 bytes  
.quad | enteros de 8 bytes  
.ascii | para escribir cadenas de caracteres  
