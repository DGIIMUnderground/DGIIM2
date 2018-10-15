# Ensamblador

## General

Ensamblador es lo más cercano a lenguaje máquina. Se trabajará a bajo nivel con registros  e instrucciones concretas.

Los archivos ensamblador tienen como terminación _.s_

En los siguientes epígrafes tocaremos la estructura de los ficheros,  una lista de instrucciones y su sintaxis, así como los distintos registros y como emplearlos.

## Aprendiendo lo básico

### Estructura

Los programas en ensamblador siguen una especie de _código de etiquetas_.

Primeramente podemos encontrar el código dividido en secciones, que se especifican como _.section .<seccion>_.  Las secciones se componen principalmente de _.section .data_ donde se declaran los datos del programa y _.section .text_ donde se realiza el programa en sí y se sitúa el código.

Más concretamente, cabe destacar dentro de las secciones el comienzo del programa, que se puede denotar de dos maneras:

- _start: .global __start

- _main: .global main

Ambas formas de definirlo son equivalentes, pero ocasionarán diferencias a la hora de como crear el ejecutable o de como realizar alguna llamada al sistema, pero en esto profundizaremos más adelante.

Mediante etiquetas podemos llamar a funciones o crear bucles, sirven para poder desplazarse a la parte del código que corresponde a dicha etiqueta, como se puede observar en distintos ejemplos. Se denota por <etiqueta>:

### Instrucciones

- mov <fuente> <destino>

- add <fuente> <destino>

- sub <fuente> <destino>

- push <registro>

- pop <registro>

- adc <fuente> <destino>

- cmp <registro1> <registro2>

- je <etiqueta>

- jne <etiqueta>

- test <registro1> <registro2>

- call <etiqueta>

### Registros

Distinguimos dos tipos de registros:

- De propósito general: Son registros temporales y no es necesario salvarlos al llamar a una función.

  - eax: Acumulador.

  - ecx: Contador.

  - edx: Datos.

  - ebx: Base.

  - esi: Índice fuente.

  - edi: Índice destino.

- Específicos: Son registros importantes y que deben guardarse al modificar sus valores.

  - esp: Puntero de pila. No debe modificarse nunca.

  - ebp: Puntero base. Si se modifica debe guardarse.

### Accediendo a lo que quiero acceder

Para acceder a los datos encontraremos distintas opciones, usaremos de ejemplo eax y una variable resultado.

- %eax : Accede al resultado de eax.

- (%eax) : eax es un puntero y accedemos al dato de la dirección de memoria a la que apunta eax.

-  resultado : Este es el dato que está en resultado.

- $resultado : Es la dirección de memoria de resultado.

- $0, \$1, \$2, \$3... : Esto son constantes numéricas.

## ¿Y esto de qué me sirve?

La teoría por sí sola sirve de poco, luego vamos a pasar a algunas cosas más prácticas.

### Creando un ejecutable

Una vez hemos escrito nuestro programa ensamblador en un fichero _programa.s_ vamos a convertirlo en ejecutable. Para hacerlo, vamos a tener dos opciones dependiendo de como hayamos señalizado el comienzo del programa (main o start). 

> Yo personalmente recomiendo señalizar el comienzo usando main porque nos facilitará otras tareas, como, por ejemplo, mostrar algo por pantalla se simplifica de forma MUY significativa al usar main.

- Si hemos usado _main_ el comando a usar será el siguiente:

  ```shell
  as —32 -g sumanenteros.s -o sumanenteros.o; gcc -m32  sumanenteros.o -o sumanenteros
  ```

- Si hemos usado _start_ el comando a usar será:

  ```shell
  as --32 -g saludo.s -o saludo.o; ld -m elf_i386 saludo.o -o saludo
  ```

### ¿Cómo muestro un resultado por pantalla?

Para comprobar si nuestros programas funcionan suele ser conveniente recibir el resultado del programa para comprobarlo. En esta sección solo trataré como mostrar por pantalla un mensaje o resultado si hemos usado la declaración del comienzo del programa como _main_.

Si vamos a mostrar un mensaje de texto por pantalla basta declarar el mensaje en _.data_, cargar el mensaje en la pila, mover el puntero de pila al lugar pertinente y hacer la llamada a la función _printf_. Aquí tenemos un tradicional "Hola Mundo":

```shell
.section .data
	saludo:	.ascii "Hola Mundo\n\0 "
	
.section .text
	main:	 .global main
		push $saludo
		call printf 
		add $4 , %esp

	
# Finalización del programa
	mov $1, %eax
	mov $0, %ebx
	int $0x80
```

En este programa  declaramos el mensaje en la sección correspondiente, nótese el uso de `\n` para hacer un salto de línea y `\0` para finalizar el mensaje.

Aquí el mensaje sirve de mensaje y formato a la vez.

Se suma el tamaño correspondiente al mensaje que se ha mandado a _esp_.

La finalización de un programa es así por convenio.

-----

Si vamos a mostrar un número que hayamos calculado, haremos lo siguiente:

```shell
# Declaramos seccion de datos del programa
.section .data
	resultado: .quad -1
	formato: .ascii "La suma es: %u\n\0"

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
main: .global main

	mov $3, resultado

	# Escribir en pantalla
	push resultado
	push $formato
	call printf
	add $8, %esp

	#Ajuste final y fin de programa
	mov $1, %eax							
	mov $0, %ebx
	int $0x80
```

Es necesario hacer _push resultado_ para guardar el dato y no su dirección de memoria y hacer una variable formato para que sepa que se debe imprimir en forma de número, como lo indica `%u`

### Llamando a funciones y creando bucles

Este es el primer ejemplo de programa que llama a una función que contiene, a su vez, un bucle. En este programa (explicado detalladamente en los comentarios) se suman los elementos de una lista.

```shell
# Declaramos seccion de datos del programa
.section .data
 #Aqui se declara la lista, con elementos 1,2,10,1,2,10(binario),1,2,10(hexadecimal)
lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
# Guardamos la longitud de la lista, el punto accede a la direccion de memoria actual, entonces la direccion de memoria actual menos la direccion de memoria donde comienza la lista es la cantidad de memoria total que ocupa, ahora la dividimos entre 4 que es lo que ocupa el tipo de dato entero que es lo que almacena la lista, asi obtenemos el numero de elementos.
longlista:	.int (.-lista)/4
# Declaramos una variable resultado donde se almacenara el resultado de la suma, la inicializamos a -1
resultado:	.int -1

# Declaramos la seccion de texto del programa.
.section .text
# Declaramos la seccion de comienzo del programa.
main:	.global main

# Guardamos la direccion de memoria donde comienza la lista en ebx
	mov    $lista, %ebx
# Guardamos la longitud de l alista en ecx
	mov longlista, %ecx
# Llamamos a la funcion suma, que comienza en "suma:"
	call suma
# Aqui ya hemos realizado la funcion suma, y movemos eax al resultado.
	mov %eax, resultado

# Estas tres instrucciones son las de salida del programa.
	mov $1, %eax
	mov $0, %ebx
	int $0x80

# Aqui comienza la funcionn suma
suma:
# Metemos en la pila edx, para luego volver por donde ibamos
	push %edx
# Ponemos un 0 en eax
	mov $0, %eax
# Ponemos nu 0 en edx
	mov $0, %edx
# Esto sigue dentro de suma, a partirt de aqui se realizara un bucle
bucle:
# Sumamos ebx con edx y con 4, almacenando el resultado en eax ¿Por que?
################EXPLICACION##################
# ebx tiene la direccion base de la lista en memoria, vamos a ir sumandole edx y 4 de forma progresiva.
# ¿por que el 4? El 4 hace referencia al tipo de dato almacenado en la lista, en este caso entero, es loq eu ocupa cada entero.
# edx,4 es equivalent a edx*4, esto es, edx indica a que elemento de la lista se accede, ya que es:
# ebx+0*4=ebx. elemento 0
# ebx+1*4=ebx+4. elemento 1.
# Asi sucesivamente.
# luego edx es el indice del bucle, el equivalente a for(i)
###############################################3
	add (%ebx,%edx, 4), %eax
# Esta instruccion incrementa en uno edxz, el indice.
	inc       %edx
# En esta instruccion se compara edx con ecx, donde ecx recordamos es el numero de elementos de la lista, es decir, es la
# condicion de salida, si el indicce es igual al numero de elementos de  la lista entonces...
	cmp  %edx,%ecx
# jne significa "jump if not equal", luego si la comparacion anterior es falsa (no son iguales) el programa vuelve a la etiqueta "bucle:"
# pero si son iguales, se ignora esta instruccion y se sigue el programa. Es similar a un if.
	jne bucle

# Con pop accedemos a la pila restaurando edx al valor de antes de llamar a la funcion, estas instruccion pop y ret se usan para salir.
	pop %edx
	ret
```

> Hay más información [aqui](https://github.com/Mapachana/Ensamblador)
